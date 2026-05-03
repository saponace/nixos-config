{ pkgs, ... }:

{
  home.packages = with pkgs; [
    sxiv
    vlc
  ];

  programs.firefox.enable = true;

  services.flameshot = {
    enable = true;
    settings = {
      general = {
        showStartupLaunchMessage = false;
      };
    };
  };
}
