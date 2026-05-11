{ ... }:
{
  imports = [
    ./hardware.nix
    ../common.nix
  ];

  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  networking.hostName = "vm";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  system.stateVersion = "26.05";
}
