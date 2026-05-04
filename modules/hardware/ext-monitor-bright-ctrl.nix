{ pkgs, ... }:

let
  setExternalMonitorsBrightness = pkgs.writeShellApplication {
    name = "set-external-monitors-brightness";
    runtimeInputs = [ pkgs.ddcutil pkgs.gawk ];
    text = ''
      set -euo pipefail

      increment="${1:-}"
      if [ -z "$increment" ]; then
        echo "Usage: set-external-monitors-brightness <increment>" >&2
        exit 1
      fi

      ddcutil_options="--noverify --sleep-multiplier .1"
      mapfile -t monitors < <(ddcutil $ddcutil_options detect | awk '/Display/ {print $2}')

      for monitor in "${monitors[@]}"; do
        if ((increment >= 0)); then
          ddcutil $ddcutil_options setvcp 10 + "$increment" -d "$monitor" &
        else
          ddcutil $ddcutil_options setvcp 10 - "${increment#-}" -d "$monitor" &
        fi
      done
    '';
  };

  increaseBrightness = pkgs.writeShellApplication {
    name = "increase-brightness";
    runtimeInputs = [ setExternalMonitorsBrightness ];
    text = ''
      exec set-external-monitors-brightness 20
    '';
  };

  decreaseBrightness = pkgs.writeShellApplication {
    name = "decrease-brightness";
    runtimeInputs = [ setExternalMonitorsBrightness ];
    text = ''
      exec set-external-monitors-brightness -20
    '';
  };
in
{
  boot.kernelModules = [ "i2c-dev" ];

  environment.systemPackages = [
    pkgs.ddcutil
    setExternalMonitorsBrightness
    increaseBrightness
    decreaseBrightness
  ];
}
