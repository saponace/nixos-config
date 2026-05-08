{ pkgs, ... }:

{
  home.packages = with pkgs; [
    swaybg # wallpaper
  ];

  programs = {
    fuzzel.enable = true; # app launcher
    swaylock.enable = true;
  };
  services = {
    mako.enable = true; # notification daemon
    swayidle.enable = true;
  };
}
