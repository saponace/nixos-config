{ username, userEmail, ... }:
{
  imports = [
    ./base/nix.nix
    ./base/nvim/nvim.nix
    ./base/locale.nix
    ./base/users.nix
    ./base/tools.nix
    ./base/zsh/zsh.nix
  ];

  services.openssh.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit username userEmail; };
  };
}
