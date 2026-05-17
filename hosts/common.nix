{ ... }:

{
  imports = [
    ../modules/display-manager.nix
    ../modules/window-manager/niri.nix
    ../modules/stylix.nix

    ../modules/base/nix.nix
    ../modules/base/locale.nix
    ../modules/base/networking.nix
    ../modules/base/users.nix
    ../modules/base/tools.nix
    ../modules/base/sound.nix
    ../modules/base/plymouth.nix

    ../modules/services/ssh.nix
    ../modules/desktop/apps.nix
    ../modules/desktop/virtualization.nix
    ../modules/desktop/ai.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.saponace = import ../home/saponace/main.nix;
  };
}
