{ pkgs, ... }:

{
  home.packages = with pkgs; [
    swayimg # image visualizer
    vlc
  ];

  programs = {
    firefox.enable = true;
    alacritty.enable = true;
    opencode.enable = true;
  };
}
