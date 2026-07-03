{ ... }:

{
  imports = [
    ../modules/desktop/hardware.nix
    ../modules/desktop/bluetooth.nix
    ../modules/desktop/sound.nix
    ../modules/desktop/boot.nix
    ../modules/desktop/services.nix
    ../modules/desktop/display-manager.nix
    ../modules/desktop/window-manager/niri.nix
    ../modules/desktop/theme.nix
    ../modules/desktop/ai.nix
    ../modules/desktop/apps.nix
    ../modules/desktop/virtualization.nix
  ];
}
