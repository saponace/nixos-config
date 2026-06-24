{ ... }:
{
  imports = [
    ./hardware.nix
    ./disko.nix
    ../../modules/base/preservation.nix
    ../../modules/base/btrfs.nix
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

  system.stateVersion = "26.05";
}
