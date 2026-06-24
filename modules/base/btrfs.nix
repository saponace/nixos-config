{ pkgs, username, ... }:
{
  services = {
    snapper = {

      # Catch up missed timeline snapshots after downtime
      persistentTimer = true;

      # snapshots for /persistent
      configs.persistent = {
        SUBVOLUME = "/persistent";
        FSTYPE = "btrfs";
        ALLOW_USERS = [ username ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = 5;
        TIMELINE_LIMIT_DAILY = 7;
        TIMELINE_LIMIT_WEEKLY = 4;
        TIMELINE_LIMIT_MONTHLY = 0;
        TIMELINE_LIMIT_YEARLY = 0;
      };
    };

    # Checksum verification -- early warning for bit-rot.
    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [ "/persistent" ];
    };
  };

  # Snapshots and btrfs maintenance GUI
  environment.systemPackages = [ pkgs.btrfs-assistant ];
}
