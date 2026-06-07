{ ... }:

{
  imports = [
    ./hardware.nix
    ../../profiles/base.nix
    ../../profiles/desktop.nix
    ../../modules/peripherals/logitech.nix
    ../../modules/peripherals/nintendo-controllers.nix
    ../../modules/peripherals/android.nix
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

  system.stateVersion = "26.05";
}
