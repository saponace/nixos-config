{ pkgs, ... }:

{
  services = {
    tlp.enable = true;
    upower.enable = true;
  };

  environment.systemPackages = with pkgs; [
    acpi
    brightnessctl
    libnotify
  ];
}
