set -euo pipefail

increment="${1:-}"
if [ -z "$increment" ]; then
  echo "Usage: set-external-monitors-brightness <increment>" >&2
  exit 1
fi

ddcutil_options=(--noverify --sleep-multiplier .1)
mapfile -t monitors < <(ddcutil "${ddcutil_options[@]}" detect | awk '/Display/ {print $2}')

for monitor in "${monitors[@]}"; do
  if ((increment >= 0)); then
    ddcutil "${ddcutil_options[@]}" setvcp 10 + "$increment" -d "$monitor" &
  else
    ddcutil "${ddcutil_options[@]}" setvcp 10 - "${increment#-}" -d "$monitor" &
  fi
done
