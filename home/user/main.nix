{ username, userEmail, ... }:

{
  imports = [
    ../modules/apps.nix
    ../modules/tools.nix
    ../modules/stylix-targets.nix
    ../modules/zsh/zsh.nix
    ../modules/nvim/nvim.nix
  ];

  home.stateVersion = "26.05";

  xdg.enable = true;

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      settings.user = {
        email = userEmail;
        name = username;
      };
    };
  };
}
