{ pkgs, ... }:

{
  services.printing.enable = true;
  preservation.preserveAt."/persistent".directories = [ "/var/lib/cups" ];

  security.polkit.enable = true; # Policy kit

  # Auto-mount removable drives
  services.udisks2.enable = true; # daemon
  environment.systemPackages = [ pkgs.udiskie ]; # tray icon
}
