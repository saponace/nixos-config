{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware.nix
    ../common.nix
  ];

  networking.hostName = "poireau";

  networking.wireless.enable = true;
}
