{ pkgs, username, ... }:
{
  system.activationScripts.snapperNixosRebuild = {
    supportsDryActivation = false;
    # Snapshot on nixos-rebuild only; activation also runs at boot (stage 1)
    text = ''
      if [ -z "''${IN_NIXOS_SYSTEMD_STAGE1:-}" ]; then
        ${pkgs.snapper}/bin/snapper -c persistent create \
          --type single \
          --cleanup-algorithm number \
          --description "nixos-rebuild"
      fi
    '';
  };

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
}
