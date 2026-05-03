{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bitwig-studio
    nautilus
  ];

  programs.steam.enable = true;
}
