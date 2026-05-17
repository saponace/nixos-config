{ pkgs, ... }:

{
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    noctalia-shell      # Desktop shell
    xwayland-satellite  # Bridge for X apps to run in wayland
  ];

  home-manager.users.saponace = { lib, ... }: {
    home.file = {
      ".config/niri/config.kdl".source = ./config/niri/config.kdl;
      ".config/noctalia/settings.json".source = ./config/noctalia/settings.json;
      ".config/noctalia/plugins.json".source = ./config/noctalia/plugins.json;
    };

    home.activation.installNoctaliaConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      # Clean up if the dir is a stale nix store symlink from a previous generation
      if [ -L "$HOME/.config/noctalia" ]; then
        rm "$HOME/.config/noctalia"
      fi
      mkdir -p "$HOME/.config/noctalia/plugins"
    '';
  };
}
