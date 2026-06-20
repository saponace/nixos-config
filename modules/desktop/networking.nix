{ username, ... }:

{
  hardware.bluetooth.enable = true; # Bluetooth
  services.blueman.enable = true; # Bluetooth audio

  networking = {
    networkmanager = {
      enable = true;
      insertNameservers = [ "1.1.1.1" ];
    };
    # DNS is owned by NetworkManager. Avoid networking.nameservers/resolvconf
    # because that "static" path pushes resolv.conf through openresolv, whose avahi
    # hook fails network-local-commands at boot.
    resolvconf.enable = false;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true; # resolve .local hostnames on the LAN
  };

  users.users.${username}.extraGroups = [ "networkmanager" ];

  preservation.preserveAt."/persistent".directories = [
    "/var/lib/bluetooth"
    "/etc/NetworkManager/system-connections"
  ];
}
