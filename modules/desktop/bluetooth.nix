_: {
  hardware.bluetooth.enable = true; # Bluetooth
  services.blueman.enable = true; # Bluetooth audio

  preservation.preserveAt."/persistent".directories = [
    "/var/lib/bluetooth"
  ];
}
