{ config, pkgs, ... }:

{
  # SDDM on Wayland needs udev/input infrastructure from the xserver module
  # to make pointer devices work. This doesn't actually start X11.
  services.xserver.enable = true;

  programs.silentSDDM = {
    enable = true;
    theme = "catppuccin-mocha";

    # Hide profile picture
    settings = {
      "LoginScreen.LoginArea.Avatar".active-size = 1;
      "LoginScreen.LoginArea.Avatar".inactive-size = 1;
    };
  };

  # Cursor theme for SDDM — doesn't currently work on Wayland.
  # SDDM ignores CursorTheme and XCURSOR_THEME on its Wayland backend.
  services.displayManager.sddm = {
    extraPackages = [ pkgs.nordzy-cursor-theme ];
    settings.Theme.CursorTheme = "Nordzy-catppuccin-mocha-dark";
  };
  environment.variables = {
    XCURSOR_THEME = "Nordzy-catppuccin-mocha-dark";
    XCURSOR_SIZE = toString config.stylix.cursor.size;
  };
}
