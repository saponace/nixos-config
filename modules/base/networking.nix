{ ... }:

{
  hardware.bluetooth.enable = true;

  networking = {
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" ];
  };
}
