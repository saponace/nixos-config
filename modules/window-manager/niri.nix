{ pkgs, ... }:

{
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    noctalia-shell # desktop shell
    fuzzel         # app launcher
    swaylock       # app launcher
    waybar
  ];

  home-manager.users.saponace.home.file.".config/niri/config.kdl" = {
    source = ./config.kdl;
  };
}
