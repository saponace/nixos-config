{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  downloads = "/home/${username}/Downloads";
in
{
  # ~/Downloads is a disk-backed btrfs subvolume so large downloads don't fill tmpfs
  # The subvolume is emptied on every boot to keep the

  # Ensure the mountpoint is owned by the user (subvolume root is root:root).
  systemd.tmpfiles.rules = [
    "d ${downloads} 0755 ${username} users -"
  ];

  # Do not show as a removable device in nautilus
  fileSystems = lib.mkIf config.services.gvfs.enable {
    ${downloads}.options = [ "x-gvfs-hide" ];
  };

  systemd.services.wipe-downloads = {
    description = "Empty ${downloads} on boot (ephemeral disk-backed scratch)";
    wantedBy = [ "multi-user.target" ];
    unitConfig.RequiresMountsFor = downloads;
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.findutils}/bin/find ${downloads} -mindepth 1 -delete";
    };
  };
}
