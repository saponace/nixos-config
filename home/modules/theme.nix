{ pkgs, ... }:

{
  home.pointerCursor = {
    name = "Nordzy-catppuccin-latte-dark";
    package = pkgs.nordzy-cursor-theme;
    size = 12;
    gtk.enable = true;
  };
}
