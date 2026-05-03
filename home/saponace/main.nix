{ config, pkgs, ... }:

{
  imports = [
    ../desktop/apps.nix
    ../tools/zsh.nix
    ../tools/nvim.nix
  ];

  home.stateVersion = "25.11";

  home = {
    username = "saponace";
    homeDirectory = "/home/saponace";
  };

  xdg.enable = true;

  programs = {
    home-manager.enable = true;
    zoxide.enable = true;
    ranger.enable = true;
  };
}
