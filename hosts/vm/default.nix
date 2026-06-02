{ ... }:
{
  imports = [
    ./hardware.nix
  ];

  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  networking.hostName = "vm";

  services.spice-vdagentd.enable = true; # Enables clipboard sharing with host when running as vm

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  system.stateVersion = "26.05";
}
