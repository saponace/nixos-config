_: {
  networking.hostName = "topinambour";

  # NetworkManager's ipv6.method=disabled leaves the kernel link-local in
  # place, which dnsmasq then serves as an unreachable AAAA
  boot.kernel.sysctl."net.ipv6.conf.end0.disable_ipv6" = 1;

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
    # No IPv6 on the LAN, and dnsmasq would serve its link-local as an AAAA
    ipv6.method = "disabled";
  };

  services.avahi = {
    publish = {
      enable = true;
      addresses = true;
      domain = true;
    };
  };
}
