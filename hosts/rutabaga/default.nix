{ pkgs, ... }:
{
  imports = [
    ./hardware.nix
  ];

  networking.hostName = "rutabaga";

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
