{ pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ../common.nix
  ];

  networking = {
    hostName = "rutabaga";
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

  console.keyMap = "fr";

  environment.systemPackages = with pkgs; [
    acpi
    brightnessctl
    libnotify
  ];

  system.stateVersion = "26.05";
}
