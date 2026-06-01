{ username, ... }:

{
  hardware.bluetooth.enable = true;  # Bluetooth
  services.blueman.enable = true;  # Bluetooth audio

  networking = {
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true; # resolve .local hostnames on the LAN
  };

  users.users.${username}.extraGroups = [ "networkmanager" ];
}
