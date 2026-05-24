{ ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/hardware/logitech-peripherals.nix
  ];

  networking = {
    hostName = "celeri";
    wireless.enable = true;
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  console.keyMap = "us";

  system.stateVersion = "26.05";
}
