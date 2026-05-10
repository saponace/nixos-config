{ pkgs, ... }:

{
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    noctalia-shell # desktop shell
    swaylock       # app launcher
  ];

  home-manager.users.saponace.home.file.".config/niri/config.kdl" = {
    source = ./config.kdl;
  };
}
