{ ... }:
{
  networking = {
    hostName = "topinambour";
    networkmanager.enable = true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    hostName = "stak"; # advertise as stak.local
    publish = {
      enable = true;
      addresses = true;
      domain = true;
    };
  };
}
