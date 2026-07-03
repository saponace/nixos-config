{
  pkgs,
  username,
  config,
  lib,
  ...
}:

{
  options.niri.outputsConfig = lib.mkOption {
    type = lib.types.lines;
    default = "";
  };

  config = {
    programs.niri.enable = true;

    environment.systemPackages = with pkgs; [
      noctalia-shell # Desktop shell
      xwayland-satellite # Bridge for X apps to run in wayland
      wl-clipboard
      wdisplays # arrange monitor layout
    ];

    # Polkit authentication agent
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    preservation.preserveAt."/persistent".users.${username}.directories = [
      ".cache/noctalia"
      ".config/noctalia/plugins"
      "Pictures/Wallpapers"
    ];

    home-manager.users.${username} =
      { lib, ... }:
      {
        home.file = {
          ".config/niri/config.kdl".text =
            builtins.readFile ./config/niri/config.kdl + config.niri.outputsConfig;
          ".config/noctalia/settings.json".source = ./config/noctalia/settings.json;
          ".config/noctalia/plugins.json".source = ./config/noctalia/plugins.json;
        };

        home.activation.installNoctaliaConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          # Clean up if the dir is a stale nix store symlink from a previous generation
          if [ -L "$HOME/.config/noctalia" ]; then
            rm "$HOME/.config/noctalia"
          fi
          mkdir -p "$HOME/.config/noctalia/plugins"
        '';
      };
  };
}
