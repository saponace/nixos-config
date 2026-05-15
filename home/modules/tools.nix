{ ... }:

{
  programs = {
    lsd.enable = true;

    fzf = { # fuzzy search
      enable = true;
    }; 

    yazi = { # file explorer
      enable = true;
      enableZshIntegration = true;
    };

    zellij = { # terminal multiplexer
      enable = true;
      settings = {
        theme = "catppuccin-mocha";
        show_startup_tips = false;
      };
    };

    zoxide = { # better cd
      enable = true;
      enableZshIntegration = true;
    };
  };
}
