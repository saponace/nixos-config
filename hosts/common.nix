{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../modules/display-manager.nix
    ../modules/window-manager/niri.nix

    # Replace the nixpkgs niri module with niri-flake's NixOS + HM integration.
    inputs.niri.nixosModules.niri

    ../modules/base/nix.nix
    ../modules/base/locale.nix
    ../modules/base/networking.nix
    ../modules/base/users.nix
    ../modules/base/tools.nix
    ../modules/base/sound.nix
    ../modules/base/fonts.nix

    ../modules/services/ssh.nix
    ../modules/desktop/apps.nix
  ];

  # Do not enable third-party binary caches by default.
  niri-flake.cache.enable = false;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.saponace = import ../home/saponace/main.nix;
  };
}
