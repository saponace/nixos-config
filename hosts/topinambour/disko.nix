{
  device ? "/dev/mmcblk0",
  ...
}:
{
  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=25%"
        "mode=755"
      ];
    };

    disk.main = {
      inherit device;
      # Flashable image size; grown to the full disk on first boot
      imageSize = "16G";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          firmware = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot/firmware";
              mountOptions = [
                "fmask=0077"
                "dmask=0077"
              ];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "noatime"
                    "x-systemd.growfs" # resize btrfs to the grown partition
                  ];
                };
                "/persistent" = {
                  mountpoint = "/persistent";
                  mountOptions = [ "noatime" ];
                };
                # Holds snapper snapshots of /persistent
                "/persistent/.snapshots" = {
                  mountpoint = "/persistent/.snapshots";
                  mountOptions = [ "noatime" ];
                };
              };
            };
          };
        };
      };
    };
  };
}
