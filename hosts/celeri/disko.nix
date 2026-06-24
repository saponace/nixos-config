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
      device = "/dev/nvme0n1";
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
            size = "16G";
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
                  mountOptions = [
                    "subvol=nix"
                    "noatime"
                  ];
                };
                "/persistent" = {
                  mountpoint = "/persistent";
                  mountOptions = [
                    "subvol=persistent"
                    "noatime"
                  ];
                };
                # Disk-backed, ephemeral ~/Downloads. Emptied on boot by ephemeral-downloads.nix.
                "/downloads" = {
                  mountpoint = "/home/${username}/Downloads";
                  mountOptions = [
                    "subvol=downloads"
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
