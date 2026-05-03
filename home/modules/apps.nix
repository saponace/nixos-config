{ pkgs, ... }:

{
  home.packages = with pkgs; [
    sxiv
    vlc
  ];

  programs.firefox.enable = true;

  services = {
    pasystray.enable = true;

    flameshot = {
      enable = true;
      settings = {
        general = {
          showStartupLaunchMessage = false;
        };
      };
    };
  };
}
