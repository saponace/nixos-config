{ pkgs, ... }:

{
  services.printing.enable = true;
  preservation.preserveAt."/persistent".directories = [ "/var/lib/cups" ];

  security.polkit.enable = true;
  security.polkit.enablePkexecWrapper = true; # required by btrfs-assistant

  # Auto-mount removable drives
  services.udisks2.enable = true; # daemon
  environment.systemPackages = [ pkgs.udiskie ]; # tray icon
}
