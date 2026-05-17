{ pkgs, ... }:

{
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    noctalia-shell      # Desktop shell
    xwayland-satellite  # Bridge for X apps to run in wayland
  ];

  home-manager.users.saponace = { lib, ... }: {
    home.file.".config/niri/config.kdl".source = ./config/niri/config.kdl;

    home.activation.installNoctaliaConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      # Clean up if the dir is a stale nix store symlink from a previous generation
      if [ -L "$HOME/.config/noctalia" ]; then
        rm "$HOME/.config/noctalia"
      fi
      mkdir -p "$HOME/.config/noctalia/plugins"
      cp -f "${./config/noctalia/settings.json}" "$HOME/.config/noctalia/settings.json"
      cp -f "${./config/noctalia/plugins.json}" "$HOME/.config/noctalia/plugins.json"
    '';
  };
}
