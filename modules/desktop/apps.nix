{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bitwig-studio
    nautilus
    swayimg
    vlc
  ];

  programs.steam.enable = true;
}
