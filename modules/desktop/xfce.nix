{ ... }:

{
  imports = [
    ./x11.nix
  ];

  services.xserver.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.displayManager.gdm.enable = true;
}
