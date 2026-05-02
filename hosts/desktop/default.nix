{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware.nix
    ../common.nix
  ];

  system.stateVersion = "24.11";

  networking.hostName = "poireau";

  networking.wireless.enable = true;
}
