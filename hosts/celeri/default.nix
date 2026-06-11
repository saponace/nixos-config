{ pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../profiles/base.nix
    ../../profiles/desktop.nix
    ../../modules/peripherals/logitech.nix
    ../../modules/peripherals/nintendo-controllers.nix
    ../../modules/peripherals/android.nix
  ];

  niri.outputsConfig =
    let
      initSetup = pkgs.writeShellScript "init-setup" ''
        niri="${pkgs.niri}/bin/niri"
        jq="${pkgs.jq}/bin/jq"

        until "$niri" msg version >/dev/null 2>&1; do sleep 0.1; done

        events=$(mktemp)
        cleanup() {
          [ -n "''${stream_pid:-}" ] && kill "$stream_pid" 2>/dev/null
          rm -f "$events"
        }
        trap cleanup EXIT

        "$niri" msg --json event-stream >> "$events" &
        stream_pid=$!

        existing_ids=$("$niri" msg --json windows 2>/dev/null | "$jq" -r '.[].id' 2>/dev/null) || existing_ids=""

        "$niri" msg action spawn -- alacritty
        "$niri" msg action spawn -- firefox

        terminal_placed=false
        browser_placed=false

        tail -f "$events" | while IFS= read -r line; do
          app_id=$(printf '%s' "$line" | "$jq" -r '.WindowOpenedOrChanged.window.app_id // empty' 2>/dev/null) || true
          win_id=$(printf '%s' "$line" | "$jq" -r '.WindowOpenedOrChanged.window.id // empty' 2>/dev/null) || true

          if [ -z "$app_id" ]; then continue; fi

          for eid in $existing_ids; do
            if [ "$eid" = "$win_id" ]; then continue 2; fi
          done

          case "$app_id" in
            Alacritty)
              if [ "$terminal_placed" = "false" ]; then
                "$niri" msg action focus-window --id "$win_id"
                "$niri" msg action move-column-to-monitor HDMI-A-1
                "$niri" msg action focus-monitor HDMI-A-1
                "$niri" msg action maximize-column
                terminal_placed=true
              fi
              ;;
            firefox)
              if [ "$browser_placed" = "false" ]; then
                "$niri" msg action focus-window --id "$win_id"
                "$niri" msg action move-column-to-monitor DP-1
                "$niri" msg action focus-monitor DP-1
                "$niri" msg action maximize-column
                browser_placed=true
              fi
              ;;
          esac

          if [ "$terminal_placed" = "true" ] && [ "$browser_placed" = "true" ]; then
            break
          fi
        done
      '';
    in
    builtins.readFile ./monitors.kdl
    + ''
      spawn-at-startup "${initSetup}"
    '';

  networking.hostName = "celeri";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  system.stateVersion = "26.05";
}
