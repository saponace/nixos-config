{
  pkgs,
  username,
  lib,
  ...
}:

let
  theme = "catppuccin-mocha";
  cursorTheme = "Nordzy-catppuccin-mocha-dark";
  cursorSize = 12;
in
{
  stylix = {
    enable = true;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme}.yaml";
    polarity = "dark";

    targets.kmscon.enable = false;
    targets.plymouth.enable = false;

    cursor = {
      package = pkgs.nordzy-cursor-theme;
      name = cursorTheme;
      size = cursorSize;
    };

    fonts = {
      sizes.terminal = 11;
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

  environment.variables = {
    XCURSOR_THEME = cursorTheme;
    XCURSOR_SIZE = toString cursorSize;
  };

  home-manager.users.${username} = _: {
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

    programs.alacritty.settings.colors = lib.mkForce (
      (builtins.fromTOML (builtins.readFile "${pkgs.alacritty-theme}/share/alacritty-theme/dracula.toml"))
      .colors
      // {
        primary.background = "#1e1e2e";
      }
    );
  };
}
