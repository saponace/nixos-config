{ username, ... }:
{
  # machine-id is persisted via a bind-mount, which makes /etc/machine-id a
  # mount point and trips systemd-machine-id-commit (it expects a transient
  # tmpfs id to commit). The id is already persistent, so the unit is redundant.
  systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];

  preservation = {
    enable = true;
    preserveAt."/persistent" = {
      directories = [
        {
          directory = "/var/lib/nixos";
          inInitrd = true;
        }
        "/var/lib/systemd"
      ];
      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
        }
      ];
      users.${username}.directories = [
        "repos"
        "Bitwig\ Studio"
        "samples"
      ];
    };
  };
}
