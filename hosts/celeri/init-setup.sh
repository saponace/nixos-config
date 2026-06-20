#!/usr/bin/env bash
# Lay out the initial niri session: a terminal on the left monitor (HDMI-A-1)
# and Firefox on the right (DP-1).

until niri msg version >/dev/null 2>&1; do sleep 0.1; done

# Wait for both monitors; niri can report ready before every output is enumerated.
until niri msg --json outputs 2>/dev/null \
  | jq -e 'has("HDMI-A-1") and has("DP-1")' >/dev/null 2>&1; do
  sleep 0.1
done

# Output name of the monitor currently showing window $1 (empty if unknown).
window_output() {
  local id="$1" ws=""
  ws=$(niri msg --json windows 2>/dev/null \
    | jq -r --argjson id "$id" '.[] | select(.id == $id) | .workspace_id' 2>/dev/null) || ws=""
  [ -n "$ws" ] || return 0
  niri msg --json workspaces 2>/dev/null \
    | jq -r --argjson ws "$ws" '.[] | select(.id == $ws) | .output' 2>/dev/null || true
}

# place_app <command> <app_id> <output>
place_app() {
  local cmd="$1" app_id="$2" output="$3" before="" id="" i

  before=$(niri msg --json windows 2>/dev/null \
    | jq -c --arg a "$app_id" '[.[] | select(.app_id == $a) | .id]' 2>/dev/null) || before="[]"

  niri msg action spawn -- "$cmd"

  # Wait for the new window to appear (id not seen before). Generous timeout: a
  # cold Firefox start can take well over ten seconds.
  for ((i = 0; i < 600; i++)); do
    id=$(niri msg --json windows 2>/dev/null \
      | jq -r --arg a "$app_id" --argjson before "$before" \
        'first(.[] | select(.app_id == $a and (.id as $i | $before | index($i) | not)) | .id) // empty' 2>/dev/null) || id=""
    if [ -n "$id" ]; then break; fi
    sleep 0.1
  done
  if [ -z "$id" ]; then return 0; fi

  # Retry the move until the window actually lands on the target output.
  for ((i = 0; i < 50; i++)); do
    niri msg action focus-window --id "$id" || true
    niri msg action move-column-to-monitor "$output" || true
    if [ "$(window_output "$id")" = "$output" ]; then break; fi
    sleep 0.1
  done

  # maximize-column toggles, so only call it once, after placement is confirmed.
  niri msg action focus-window --id "$id" || true
  niri msg action maximize-column || true
}

place_app alacritty Alacritty HDMI-A-1
place_app firefox firefox DP-1
