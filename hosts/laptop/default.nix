{ config, pkgs, lib, ... }:

let
  batteryLevel = pkgs.writeShellScriptBin "battery-level" (
    builtins.replaceStrings
      [ "@acpi@" "@notify_send@" ]
      [ "${pkgs.acpi}/bin/acpi" "${pkgs.libnotify}/bin/notify-send" ]
      (builtins.readFile ./scripts/battery-level)
  );
in
{
  imports = [
    ./hardware.nix
    ../common.nix
  ];

  networking = {
    hostName = "celeri";
    wireless.enable = true;
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  services = {
    tlp.enable = true;
    upower.enable = true;
    xserver = {
      xkb.layout = "fr";
    };
  };

  environment.systemPackages = with pkgs; [
    acpi
    brightnessctl
    libnotify
    batteryLevel
  ];

  home-manager.users.saponace.imports = [
    ../../home/modules/hardware/battery-level.nix
  ];

  system.stateVersion = "26.05";
}
