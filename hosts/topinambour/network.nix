{ ... }:
{
  networking = {
    hostName = "topinambour";
    networkmanager.enable = true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    hostName = "stak"; # advertise as stak.local (A record, more reliable than CNAME aliases)
    publish = {
      enable = true;
      addresses = true;
      domain = true;
    };
  };
}
