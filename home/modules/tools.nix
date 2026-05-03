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
      settings = {
        theme = "catppuccin-macchiato";
        show_startup_tips = false;
      };
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
