_: {
  networking.hostName = "topinambour";

  services.avahi = {
    publish = {
      enable = true;
      addresses = true;
      domain = true;
    };
  };
}
