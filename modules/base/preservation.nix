{ username, ... }:
{
  # Shared impermanence core

  imports = [ ./ephemeral-downloads.nix ];

  preservation = {
    enable = true;
    preserveAt."/persistent" = {
      # Do not show as a removable device in nautilus
      commonMountOptions = [ "x-gvfs-hide" ];
      directories = [
        {
          directory = "/var/lib/nixos";
          inInitrd = true;
        }
        "/var/lib/systemd"
        "/var/log/journal"
      ];
      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
        }
      ];
      users.${username} = {
        directories = [
          "repos"
          "keep"
        ];
        files = [
          ".config/git/ignore" # global gitignore
        ];
      };
    };
  };

  # machine-id is persisted via a bind-mount, which makes /etc/machine-id a
  # mount point and trips systemd-machine-id-commit (it expects a transient
  # tmpfs id to commit). The id is already persistent, so the unit is redundant.
  systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];

  fileSystems."/nix".neededForBoot = true;
  fileSystems."/persistent".neededForBoot = true;
}
