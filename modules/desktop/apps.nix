{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nautilus
  ];

  programs.steam.enable = true;
}
