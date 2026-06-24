{ username, userEmail, ... }:

{
  imports = [
    ../modules/base/nix.nix
    ../modules/base/ssh.nix
    ../modules/base/locale.nix
    ../modules/base/users.nix
    ../modules/base/tools.nix
    ../modules/base/storage.nix
    ../modules/base/zsh
    ../modules/base/nvim
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit username userEmail; };
  };
}
