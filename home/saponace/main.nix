{ config, pkgs, ... }:

{
  imports = [
    ../desktop/apps.nix
    ../tools/zsh.nix
    ../tools/neovim.nix
  ];

  home.stateVersion = "25.11";

  home.username = "saponace";
  home.homeDirectory = "/home/saponace";

  programs.home-manager.enable = true;

  programs.zoxide.enable = true;
  programs.ranger.enable = true;

  xdg.enable = true;

}
