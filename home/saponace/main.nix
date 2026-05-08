{ config, pkgs, ... }:

{
  imports = [
    ../modules/wm-dependencies.nix
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
    home-manager.enable = true;

    git = {
      enable = true;
      settings.user = {
        email =  "saponace@gmail.com";
        name = "saponace";
        };
    };
  };
}
