{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware.nix
    ../common.nix
  ];

  networking.hostName = "vm";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
