{ ... }:
{
  imports = [
    ./hardware.nix
    ../../profiles/base.nix
    ../../profiles/desktop.nix
    ../../profiles/laptop.nix
  ];

  networking.hostName = "rutabaga";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  services.xserver.xkb.layout = "fr";

  console.keyMap = "fr";

  system.stateVersion = "26.05";
}
