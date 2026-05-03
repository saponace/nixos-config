{ ... }:

{
  programs = {
    lsd.enable = true;

    yazi = {
      enable = true;
      enableZshIntegration = true;
    };

    zellij = {
      enable = true;
      enableZshIntegration = true;
      settings.theme = "catppuccin-macchiato";
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
