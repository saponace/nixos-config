{ pkgs, ... }:

{
  services.printing.enable = true;
  security.polkit.enable = true; # Policy kit

  # Auto-mount removable drives
  services.udisks2.enable = true; # daemon
  environment.systemPackages = [ pkgs.udiskie ]; # tray icon
}
