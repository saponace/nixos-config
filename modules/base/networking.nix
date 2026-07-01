{ username, ... }:
{
  networking = {
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" ];
  };
  users.users.${username}.extraGroups = [ "networkmanager" ];

  # Resolve .local hostnames on the LAN.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  # Persist connection profiles across the tmpfs root.
  preservation.preserveAt."/persistent".directories = [
    "/etc/NetworkManager/system-connections"
  ];
}
