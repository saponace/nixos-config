set -euo pipefail

compose_file="${1:-hosts/topinambour/stak/docker-compose-stak.yaml}"

if [[ ! -f $compose_file ]]; then
  echo "no such compose file: $compose_file" >&2
  exit 1
fi

manifest_types='application/vnd.oci.image.index.v1+json,application/vnd.docker.distribution.manifest.list.v2+json,application/vnd.oci.image.manifest.v1+json,application/vnd.docker.distribution.manifest.v2+json'

# Pre-release markers, including PEP440-ish suffixes glued to the version (2026.4.0b2)
unstable_re='(^|[^a-z0-9])(alpha|beta|rc|pre|preview|dev|develop|nightly|snapshot|edge|unstable|insider|canary|test|daily)|[0-9](a|b|rc)[0-9]+$'

# A tag reduced to its alphabetic runs: "10.11.10ubu2404-ls34" and "12.0ubu2604-ls48"
# both give "ubu.ls", while "version-v1.6.0", "latest" and "main" do not. Comparing
# signatures keeps us on the same flavour of tag whatever the version shape.
signature_awk='
  function signature(tag) {
    tag = tolower(tag)
    gsub(/[^a-z0-9]/, "", tag)
    gsub(/[0-9]+/, ".", tag)
    sub(/^\./, "", tag)
    sub(/\.$/, "", tag)
    return tag
  }
'

signature() {
  awk "$signature_awk"'{ print signature($0) }' <<<"$1"
}

stable() {
  [[ ! ${1,,} =~ $unstable_re ]]
}

newer() {
  [[ $1 != "$2" && $(printf '%s\n%s\n' "$1" "$2" | sort -V | tail -n1) == "$1" ]]
}

escape() {
  sed 's/[][\.*^$|&/]/\\&/g' <<<"$1"
}

# Anonymous registries rate-limit hard, so back off instead of giving up
http_get() {
  local url="$1" attempt out code body delay
  shift
  for attempt in 1 2 3 4 5; do
    out=$(curl -sS -w $'\n%{http_code}' "$@" "$url" 2>/dev/null) || out=$'\n000'
    code=${out##*$'\n'}
    body=${out%$'\n'*}
    case $code in
      2*)
        printf '%s' "$body"
        return 0
        ;;
      429 | 5?? | 000) ;;
      *) return 1 ;;
    esac
    delay=$((attempt * 10))
    echo "  HTTP $code, retrying in ${delay}s" >&2
    sleep "$delay"
  done
  return 1
}

# Anonymous pull token, from the registry's own auth challenge
auth_token() {
  local api="$1" repo="$2" attempt challenge realm service
  for attempt in 1 2 3 4 5; do
    challenge=$(curl -sS -o /dev/null -D - "$api/$repo/tags/list?n=1" 2>/dev/null | tr -d '\r' || true)
    realm=$(sed -n 's/^[Ww][Ww][Ww]-[Aa]uthenticate:.*realm="\([^"]*\)".*/\1/p' <<<"$challenge")
    if [[ -n $realm ]]; then
      service=$(sed -n 's/^[Ww][Ww][Ww]-[Aa]uthenticate:.*service="\([^"]*\)".*/\1/p' <<<"$challenge")
      http_get "$realm?service=$service&scope=repository:$repo:pull" | jq -r '.token // .access_token // empty'
      return 0
    fi
    if (( attempt < 5 )); then
      sleep $((attempt * 10))
    fi
  done
}

# Version label of :latest. Saves walking a tag list thousands of entries long, but
# not every image publishes a :latest, or labels it with a tag that actually exists.
label_version() {
  local api="$1" repo="$2" token="$3" manifest digest config
  manifest=$(http_get "$api/$repo/manifests/latest" -H "Authorization: Bearer $token" -H "Accept: $manifest_types") || return 0
  if jq -e 'has("manifests")' <<<"$manifest" >/dev/null 2>&1; then
    digest=$(jq -r 'first(.manifests[] | select(.platform.os == "linux" and (.platform.architecture == "amd64" or .platform.architecture == "arm64")).digest) // empty' <<<"$manifest")
    [[ -n $digest ]] || return 0
    manifest=$(http_get "$api/$repo/manifests/$digest" -H "Authorization: Bearer $token" -H "Accept: $manifest_types") || return 0
  fi
  config=$(jq -r '.config.digest // empty' <<<"$manifest" 2>/dev/null)
  [[ -n $config ]] || return 0
  http_get "$api/$repo/blobs/$config" -L -H "Authorization: Bearer $token" \
    | jq -r '.config.Labels["org.opencontainers.image.version"] // empty' 2>/dev/null
}

list_tags() {
  local api="$1" repo="$2" token="$3" last="" url page count
  while :; do
    url="$api/$repo/tags/list?n=1000"
    if [[ -n $last ]]; then
      url="$url&last=$last"
    fi
    page=$(http_get "$url" -H "Authorization: Bearer $token") || return 0
    count=$(jq '(.tags // []) | length' <<<"$page")
    if (( count == 0 )); then
      return 0
    fi
    jq -r '.tags[]' <<<"$page"
    last=$(jq -r '.tags[-1]' <<<"$page")
    if (( count < 1000 )); then
      return 0
    fi
  done
}

images=$(grep -oE '^[[:space:]]*image:[[:space:]]*[^[:space:]]+' "$compose_file" \
  | sed 's/^[[:space:]]*image:[[:space:]]*//' | sort -u)

while read -r image; do
  tag=${image##*:}
  ref=${image%:*}
  if [[ $ref == "$image" || $tag == */* ]]; then
    echo "skipping untagged $image" >&2
    continue
  fi

  host=${ref%%/*}
  repo=${ref#*/}
  if [[ $host != *[.:]* && $host != localhost ]]; then
    repo=$ref
    host=registry-1.docker.io
    if [[ $repo != */* ]]; then
      repo="library/$repo"
    fi
  fi
  api="https://$host/v2"

  echo "checking $ref:$tag" >&2
  token=$(auth_token "$api" "$repo" || true)
  if [[ -z $token ]]; then
    echo "  no pull token for $host, skipping" >&2
    continue
  fi

  flavour=$(signature "$tag")
  latest=$(label_version "$api" "$repo" "$token" || true)
  if [[ -z $latest ]] || ! stable "$latest" || [[ $(signature "$latest") != "$flavour" ]]; then
    echo "  :latest is not labelled with a comparable tag, walking the tag list" >&2
    latest=$(list_tags "$api" "$repo" "$token" \
      | { grep -Eiv "$unstable_re" || true; } \
      | awk -v want="$flavour" "$signature_awk"'signature($0) == want' \
      | sort -V | tail -n1)
  fi

  if [[ -z $latest ]]; then
    echo "  found no comparable tag" >&2
  elif ! newer "$latest" "$tag"; then
    echo "  up to date" >&2
  else
    sed -i "s|\(^[[:space:]]*image:[[:space:]]*$(escape "$ref"):\)$(escape "$tag")[[:space:]]*$|\1$latest|" "$compose_file"
    echo "- \`$ref\`: \`$tag\` → \`$latest\`"
  fi
done <<<"$images"
