{ username, ... }:
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
      device = "/dev/sda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "1M";
            type = "EF02";
          };
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "fmask=0077"
                "dmask=0077"
              ];
            };
          };
          swap = {
            size = "8G"; # adjust to match rutabaga's RAM
            content = {
              type = "swap";
              resumeDevice = true;
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
                  mountOptions = [ "noatime" ];
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
                # Disk-backed, ephemeral ~/Downloads. Emptied on boot by ephemeral-downloads.nix.
                "/downloads" = {
                  mountpoint = "/home/${username}/Downloads";
                  mountOptions = [
                    "noatime"
                    "nofail"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };
}
