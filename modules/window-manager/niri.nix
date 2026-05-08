{ pkgs, ... }
:
{
  programs.niri.enable = true;
  systemd.user.services.niri.enableDefaultPath = false;

  environment.systemPackages = with pkgs; [ 
    fuzzel # app launcher
    swaylock
    mako  # notification daemon
    swayidle # idle management daemon
    xwayland-satellite # X compatibility layer
  ];
}
