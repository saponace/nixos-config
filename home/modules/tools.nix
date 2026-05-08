{ ... }:

{
  programs = {
    lsd.enable = true;

    fzf = { # fuzzy search
      enable = true;
      enableZshIntegration = true;
    }; 

    yazi = { # file explorer
      enable = true;
      enableZshIntegration = true;
    };

    zellij = { # terminal multiplexer
      enable = true;
      settings = {
        theme = "catppuccin-macchiato";
        show_startup_tips = false;
      };
    };

    zoxide = { # better cd
      enable = true;
      enableZshIntegration = true;
    };
  };
}
