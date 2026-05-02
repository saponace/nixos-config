{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware.nix
    ../common.nix

    ../../configuration.nix
  ];

  system.stateVersion = "25.11";

  networking.hostName = "vm";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
