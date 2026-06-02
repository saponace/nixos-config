{ username, userEmail, ... }:

{
  imports = [
    ./base/nix.nix
    ./base/hardware.nix
    ./base/locale.nix
    ./base/networking.nix
    ./base/users.nix
    ./base/tools.nix
    ./base/sound.nix
    ./base/plymouth.nix
    ./base/services.nix
    ./base/zsh/zsh.nix

    ./desktop/display-manager.nix
    ./desktop/window-manager/niri.nix
    ./desktop/stylix.nix
    ./desktop/ai.nix
    ./desktop/apps.nix
    ./desktop/virtualization.nix
    ./base/nvim/nvim.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit username userEmail; };
  };
}
