{ username, ... }:

{
  hardware.bluetooth.enable = true;  # Bluetooth
  services.blueman.enable = true;  # Bluetooth audio

  networking = {
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" ];
  };

  users.users.${username}.extraGroups = [ "networkmanager" ];
}
