{ pkgs, ... }:

{
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    noctalia-shell      # Desktop shell
    swaylock            # Lockscreen
    xwayland-satellite  # Bridge for X aps to run in wayland
  ];

  home-manager.users.saponace.home.file.".config/niri/config.kdl" = {
    source = ./config.kdl;
  };
}
