{ pkgs, username, ... }:

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

  niri.outputsConfig =
    let
      initSetup = pkgs.writeShellApplication {
        name = "init-setup";
        runtimeInputs = [
          pkgs.niri
          pkgs.jq
        ];
        text = builtins.readFile ./init-setup.sh;
      };
    in
    builtins.readFile ./monitors.kdl
    + ''
      spawn-at-startup "${initSetup}/bin/init-setup"
    '';

  networking.hostName = "celeri";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  preservation.preserveAt."/persistent".users.${username}.directories = [ "samples" ];

  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  system.stateVersion = "26.05";
}
