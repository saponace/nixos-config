_: {
  # Boot and kernel are handled by nixos-raspberrypi's raspberry-pi-5 module.

  fileSystems."/mnt/wd" = {
    device = "/dev/disk/by-uuid/7e9f033d-79c4-40bb-9aa6-755eafc8f8bc";
    fsType = "ext4";
    options = [
      "defaults"
      "noatime"
      "nofail" # don't block boot if fsck fails/hangs; stak.service still waits for the mount
    ];
  };

  swapDevices = [ ];
}
