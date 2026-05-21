{ pkgs, username, ... }:

{
  stylix = {
    enable = true;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";

    targets.plymouth.enable = false;

    cursor = {
      package = pkgs.nordzy-cursor-theme;
      name = "Nordzy-catppuccin-mocha-dark";
      size = 12;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };

    opacity = {
      terminal = 0.8;
      popups = 0.9;
      desktop = 0.8;
    };
  };

  home-manager.users.${username} = { ... }: {
    stylix.targets = {
      alacritty.enable = true;
      firefox = {
        enable = true;
        profileNames = [ "default" ];
      };
      gtk.enable = true;
      qt.enable = true;
      noctalia-shell.enable = true;
    };
  };
}
