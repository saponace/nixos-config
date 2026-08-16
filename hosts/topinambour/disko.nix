{ pkgs, ... }:
let
  # Native VM for image builds; an emulated aarch64 VM takes hours
  buildPkgs = import pkgs.path { system = "x86_64-linux"; };
in
{
  # Image builder re-evals this config on x86
  nixpkgs.config.allowUnsupportedSystem = true;

  disko = {
    memSize = 4096;
    imageBuilder = {
      enableBinfmt = true;
      pkgs = buildPkgs;
      kernelPackages = buildPkgs.linuxPackages;
    };

    devices = {
      nodev."/" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=25%"
          "mode=755"
        ];
      };

      disk.main = {
        device = "/dev/mmcblk0";
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
                  # Dedicated subvolume for docker stuff so snapper doesn't recurse into it
                  "/persistent/var/lib/docker" = {
                    mountpoint = "/persistent/var/lib/docker";
                    mountOptions = [ "noatime" ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
