{ ... }:

{
  # SDDM on Wayland needs udev/input infrastructure from the xserver module
  # to make pointer devices work. This doesn't actually start X11.
  services.xserver.enable = true;

  programs.silentSDDM = {
    enable = true;

    # Hide profile picture
    settings = {
      "LoginScreen.LoginArea.Avatar".active-size = 1;
      "LoginScreen.LoginArea.Avatar".inactive-size = 1;
    };
  };
}
