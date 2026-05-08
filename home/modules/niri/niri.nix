{ pkgs, ... }:

{
  programs.niri.settings = {
      input = {
        keyboard = {
          xkb = {
            layout = "us,ru,ua";
            options = "grp:alt_shift_toggle,caps:escape";
          };
          "repeat-rate" = 40;
          "repeat-delay" = 250;
        };

        touchpad = {
          tap = true;
          "natural-scroll" = true;
        };

        mouse."accel-profile" = "flat";
      };

      layout = {
        gaps = 5;
        "focus-ring" = {
          width = 2;
          "active-color" = "#f5a97f";
        };
      };

      binds = {
        "Mod+Return".action.spawn = "alacritty";
        "Mod+D".action.spawn = "fuzzel";
        "Super+Alt+L".action.spawn = "swaylock";

        "Mod+Q" = { repeat = false; action."close-window" = null; };
        "Mod+F".action."maximize-column" = null;
        "Mod+G".action."fullscreen-window" = null;
        "Mod+Shift+F".action."toggle-window-floating" = null;
        "Mod+C".action."center-column" = null;

        "Mod+H".action."focus-column-left" = null;
        "Mod+L".action."focus-column-right" = null;
        "Mod+K".action."focus-window-up" = null;
        "Mod+J".action."focus-window-down" = null;

        "Mod+Shift+H".action."move-column-left" = null;
        "Mod+Shift+L".action."move-column-right" = null;
        "Mod+Shift+K".action."move-window-up" = null;
        "Mod+Shift+J".action."move-window-down" = null;

        "XF86AudioRaiseVolume" = {
          "allow-when-locked" = true;
          action.spawn = [ "wpctl" "set-volume" "-l" "1.4" "@DEFAULT_AUDIO_SINK@" "5%+" ];
        };
        "XF86AudioLowerVolume" = {
          "allow-when-locked" = true;
          action.spawn = [ "wpctl" "set-volume" "-l" "1.4" "@DEFAULT_AUDIO_SINK@" "5%-" ];
        };
        "XF86AudioMute" = {
          "allow-when-locked" = true;
          action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ];
        };
        "XF86AudioMicMute" = {
          "allow-when-locked" = true;
          action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle" ];
        };

        "Mod+Ctrl+S".action.spawn = [ "sh" "-c" "grim -l 0 - | wl-copy" ];
        "Mod+Shift+S".action.spawn = [ "sh" "-c" "grim -g \"$(slurp -w 0)\" - | wl-copy" ];
        "Mod+Shift+E".action.spawn = [ "sh" "-c" "wl-paste | swappy -f -" ];
      };

      "spawn-at-startup" = [
        { argv = [ "mako" ]; }
      ];
  };

  home.packages = with pkgs; [
    fuzzel
    mako
    swaylock
    swayidle
    xwayland-satellite
    wl-clipboard
    grim
    slurp
    swappy
  ];
}
