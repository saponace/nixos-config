{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware.nix
    ../../configuration.nix

    ../../modules/base/locale.nix
    ../../modules/base/networking.nix
    ../../modules/base/users.nix
    ../../modules/base/tools.nix

    ../../modules/services/ssh.nix
  ];

  networking.hostName = "vm";

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.saponace = import ../../home/saponace/vm.nix;

  system.stateVersion = "24.11";
}
