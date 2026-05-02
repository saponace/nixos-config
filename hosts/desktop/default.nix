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

  networking.hostName = "poireau";


  networking.wireless.enable = true;


  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.saponace = import ../../home/saponace/main.nix;

  system.stateVersion = "24.11";
}
