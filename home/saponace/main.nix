{ config, pkgs, ... }:

{
  imports = [
    ../modules/apps.nix
    ../modules/tools.nix
    ../modules/zsh/zsh.nix
    ../modules/nvim/nvim.nix
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
