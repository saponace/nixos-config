{ ... }:
{
  imports = [
    ./hardware.nix
    ./disko.nix
    ./preservation.nix
    ../../profiles/base.nix
    ../../profiles/desktop.nix
    ../../profiles/laptop.nix
  ];

  networking.hostName = "rutabaga";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  fileSystems."/nix".neededForBoot = true;
  fileSystems."/persistent".neededForBoot = true;

  services.xserver.xkb.layout = "fr";

  system.stateVersion = "26.05";
}
