{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware.nix

    ../../modules/base/locale.nix
    ../../modules/base/networking.nix
    ../../modules/base/users.nix
    ../../modules/base/tools.nix

    ../../modules/services/ssh.nix
    ../../modules/desktop/xfce.nix
  ];

  networking.hostName = "desktop";

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.saponace = import ../../home/saponace/desktop.nix;

  system.stateVersion = "24.11";
}
