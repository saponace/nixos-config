{ pkgs, ... }:

let
  setExternalMonitorsBrightness = pkgs.writeShellApplication {
    name = "set-external-monitors-brightness";
    runtimeInputs = [ pkgs.ddcutil pkgs.gawk ];
    text = builtins.readFile ./set-external-monitors-brightness.sh;
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
