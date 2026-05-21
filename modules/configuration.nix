{ username, userEmail, ... }:

{
  imports = [
    ./display-manager.nix
    ./window-manager/niri.nix
    ./stylix.nix

    ./base/nix.nix
    ./base/locale.nix
    ./base/networking.nix
    ./base/users.nix
    ./base/tools.nix
    ./base/sound.nix
    ./base/plymouth.nix

    ./services.nix
    ./desktop/apps.nix
    ./desktop/virtualization.nix
    ./desktop/ai.nix

    ./tools/nvim/nvim.nix
    ./tools/zsh/zsh.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit username userEmail; };
  };
}
