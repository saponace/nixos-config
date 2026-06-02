{ ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/peripherals/logitech.nix
    ../../modules/peripherals/nintendo-controllers.nix
  ];

  niri.outputsConfig = builtins.readFile ./monitors.kdl;

  networking.hostName = "celeri";

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
