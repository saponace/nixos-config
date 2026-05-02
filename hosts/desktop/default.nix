{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware.nix
    ../common.nix
  ];

  system.stateVersion = "25.11";

  networking.hostName = "poireau";

  networking.wireless.enable = true;
}
