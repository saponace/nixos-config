{ ... }:

{
  systemd.user.services.battery-level = {
    Unit = {
      Description = "Check battery level and notify if low";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/battery-level -n";
    };
  };

  systemd.user.timers.battery-level = {
    Unit = {
      Description = "Check battery level every minute";
    };
    Timer = {
      OnBootSec = "2min";
      OnUnitActiveSec = "1min";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
