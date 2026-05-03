{ pkgs, ... }:

{
  home.packages = with pkgs; [
    sxiv
    vlc
  ];

  programs = {
    firefox.enable = true;

    alacritty = {
      enable = true;
      theme = "monokai";
      settings = {
        window.opacity = 0.8;
        font = {
          size = 10;
          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Regular";
          };
          bold = {
            family = "JetBrainsMono Nerd Font";
            style = "Bold";
          };
          italic = {
            family = "JetBrainsMono Nerd Font";
            style = "italic";
          };
        };
      };
    };
  };

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
