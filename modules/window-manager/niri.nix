{ pkgs, ... }:

{
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    noctalia-shell      # Desktop shell
    xwayland-satellite  # Bridge for X aps to run in wayland
  ];

  home-manager.users.saponace.home.file = {
    ".config/niri/config.kdl".source = ./config/niri/config.kdl;
    ".config/noctalia/settings.json".source = ./config/noctalia/settings.json;
    ".config/noctalia/plugins.json".source = ./config/noctalia/plugins.json;
  };
}
