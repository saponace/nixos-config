{ config, pkgs, ... }:

{
  imports = [
    ../desktop/apps.nix
    ../tools/tools.nix
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
    git = {
      enable = true;
      userEmail = "saponace@gmail.com";
      userName = "saponace";
    };
    home-manager.enable = true;
    zoxide.enable = true;
    ranger.enable = true;
  };
}
