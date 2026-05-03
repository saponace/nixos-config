{ config, pkgs, lib, ... }:

{
  imports = [
    ../modules/base/nix.nix
    ../modules/base/locale.nix
    ../modules/base/networking.nix
    ../modules/base/users.nix
    ../modules/base/tools.nix
    ../modules/base/sound.nix
    ../modules/base/fonts.nix

    ../modules/services/ssh.nix
    ../modules/desktop/xfce.nix
    ../modules/desktop/apps.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.saponace = import ../home/saponace/main.nix;
}
