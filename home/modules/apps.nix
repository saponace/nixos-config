{ pkgs, ... }:

{
  home.packages = with pkgs; [
    swayimg # image visualizer
    vlc
  ];

  programs = {
    firefox.enable = true;

    alacritty = {
      enable = true;
      theme = "monokai";
      settings = {
        window.opacity = 0.85;
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

    opencode = {
      enable = true;
      tui.theme = "catppuccin-macchiato";
    };
  };
}
