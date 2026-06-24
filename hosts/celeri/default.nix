{ username, ... }:

{
  imports = [
    ./hardware.nix
    ./disko.nix
    ../../modules/base/preservation.nix
    ../../modules/base/btrfs.nix
    ../../profiles/base.nix
    ../../profiles/desktop.nix
    ../../modules/peripherals/logitech.nix
    ../../modules/peripherals/nintendo-controllers.nix
    ../../modules/peripherals/android.nix
  ];

  networking.hostName = "celeri";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  niri.outputsConfig = builtins.readFile ./monitors.kdl;

  preservation.preserveAt."/persistent".users.${username}.directories = [ "samples" ];

  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  system.stateVersion = "26.05";
}
