{ config, pkgs, ... }:

{
  imports = [
    ../desktop/apps.nix
    ../tools/tools.nix
    ../tools/zsh.nix
    ../tools/nvim.nix
  ];

  home.stateVersion = "26.05";

  home = {
    username = "saponace";
    homeDirectory = "/home/saponace";
  };

  xdg.enable = true;

  programs = {
    git = {
      enable = true;
      settings.user = {
        email =  "saponace@gmail.com";
        name = "saponace";
        };
    };
    home-manager.enable = true;
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
