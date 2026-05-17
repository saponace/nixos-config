{ ... }:

{
  imports = [
    ./hardware.nix
    ../common.nix

    ../../modules/hardware/ext-monitor-bright-ctrl/default.nix
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

  console.keyMap = "us";

  system.stateVersion = "26.05";
}
