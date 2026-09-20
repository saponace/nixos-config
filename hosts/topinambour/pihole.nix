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
      domainNeeded = true;
      upstreams = [
        "1.1.1.1"
        "1.0.0.1"
      ];
      hosts = [ "192.168.0.2 topinambour" ];
    };
  };

  services.pihole-web = {
    enable = true;
    ports = [ 8053 ]; # 80 is homarr's
  };

  preservation.preserveAt."/persistent".directories = [
    {
      directory = "/etc/pihole";
      user = "pihole";
      group = "pihole";
      mode = "0700";
    }
    {
      directory = "/var/lib/pihole";
      user = "pihole";
      group = "pihole";
      mode = "0700";
    }
  ];
}
