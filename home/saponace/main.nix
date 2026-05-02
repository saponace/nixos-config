{ pkgs, ... }:

{
  imports = [
    ../desktop/apps.nix
  ];

  home.username = "saponace";
  home.homeDirectory = "/home/saponace";

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
