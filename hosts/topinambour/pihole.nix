_: {
  services.pihole-ftl = {
    enable = true;
    openFirewallDNS = true;
    openFirewallWebserver = true;

    lists = [
      {
        url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
        description = "Steven Black's unified adlist";
      }
    ];

    settings.dns = {
      domain = "ht.home";
      expandHosts = true;
      upstreams = [
        "1.1.1.1"
        "1.0.0.1"
      ];
      hosts = [ "192.168.0.2 topinambour" ];
    };

    # Default is /etc/pihole, which NixOS owns; keep mutable state out of it
    settings.files = {
      database = "/var/lib/pihole/pihole-FTL.db";
      gravity = "/var/lib/pihole/gravity.db";
      macvendor = "/var/lib/pihole/macvendor.db";
    };
  };

  services.pihole-web = {
    enable = true;
    ports = [ 8053 ];
  };

  preservation.preserveAt."/persistent".directories = [
    {
      directory = "/var/lib/pihole";
      user = "pihole";
      group = "pihole";
      mode = "0700";
    }
  ];
}
