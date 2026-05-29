{ lib, ... }:
{
  # Boot and kernel are handled by nixos-hardware.nixosModules.raspberry-pi-5

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"; # TODO: fill in after nixos-generate-config
    fsType = "ext4";
    options = [ "noatime" ];
  };

  # RPi 5 uses /boot/firmware for the FAT partition, not /boot
  fileSystems."/boot/firmware" = {
    device = "/dev/disk/by-uuid/XXXX-XXXX"; # TODO: fill in after nixos-generate-config
    fsType = "vfat";
    options = [ "noatime" "noauto" "x-systemd.automount" ];
  };

  fileSystems."/mnt/wd" = {
    device = "/dev/disk/by-uuid/7e9f033d-79c4-40bb-9aa6-755eafc8f8bc";
    fsType = "ext4";
    options = [ "defaults" "noatime" ];
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
