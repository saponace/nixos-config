{ pkgs, ... }:

{
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    fuzzel # app launcher
    swaylock # app launcher
    waybar
  ];

  home-manager.users.saponace.home.file.".config/niri/config.kdl" = {
    source = ./config.kdl;
  };
}
