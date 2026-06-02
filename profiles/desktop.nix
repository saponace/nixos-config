{ ... }:

{
  imports = [
    ../modules/desktop/hardware.nix
    ../modules/desktop/networking.nix
    ../modules/desktop/sound.nix
    ../modules/desktop/plymouth.nix
    ../modules/desktop/services.nix
    ../modules/desktop/display-manager.nix
    ../modules/desktop/window-manager/niri.nix
    ../modules/desktop/stylix.nix
    ../modules/desktop/ai.nix
    ../modules/desktop/apps.nix
    ../modules/desktop/virtualization.nix
  ];
}
