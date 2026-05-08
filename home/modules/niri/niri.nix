{ pkgs, ... }:

{
  # User-side niri configuration.
  xdg.configFile."niri/config.kdl".source = ./config.kdl;

  home.packages = with pkgs; [
    # Core desktop helpers used by the config.
    fuzzel
    mako
    swaylock
    swayidle
    xwayland-satellite

    # Clipboard + screenshot helpers.
    wl-clipboard
    grim
    slurp
    swappy
  ];
}
