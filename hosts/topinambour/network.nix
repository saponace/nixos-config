_: {
  networking.hostName = "topinambour";

  # Serves DNS for the LAN, so its address can't come from DHCP
  networking.networkmanager.ensureProfiles.profiles.wired = {
    connection = {
      id = "wired";
      type = "ethernet";
      interface-name = "end0";
    };
    ipv4 = {
      method = "manual";
      address1 = "192.168.0.2/24,192.168.0.1";
      # Fallback, or a broken Pi-hole leaves the host unable to resolve
      dns = "127.0.0.1;1.1.1.1;";
    };
  };

  services.avahi = {
    publish = {
      enable = true;
      addresses = true;
      domain = true;
    };
  };
}
