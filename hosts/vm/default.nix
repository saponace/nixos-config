{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware.nix

    ../../configuration.nix

    ../../modules/base/locale.nix
    ../../modules/base/nix.nix
    ../../modules/base/networking.nix
    ../../modules/base/users.nix
    ../../modules/base/tools.nix

    ../../modules/services/ssh.nix
    ../../modules/desktop/xfce.nix
  ];

  networking.hostName = "vm";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.saponace = import ../../home/saponace/main.nix;

  system.stateVersion = "25.11";
}
