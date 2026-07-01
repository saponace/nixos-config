_: {
  networking.hostName = "topinambour";

  services.avahi = {
    hostName = "stak"; # advertise as stak.local
    publish = {
      enable = true;
      addresses = true;
      domain = true;
    };
  };
}
