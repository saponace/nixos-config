{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware.nix
    ../common.nix
    ../../modules/desktop/virtualisation.nix
  ];

  networking.hostName = "poireau";

  networking.wireless.enable = true;

  system.stateVersion = "26.05";
}
