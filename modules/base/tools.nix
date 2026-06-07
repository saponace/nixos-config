{ pkgs, username, lib, ... }:

let
  toolsConfig = { ... }: {
    programs = {
      lsd = {
        enable = true;
        enableZshIntegration = false;
      };

      fzf = { # fuzzy search
        enable = true;
      };

      yazi = { # file explorer
        enable = true;
        enableZshIntegration = true;
      };

      zellij = { # terminal multiplexer
        enable = true;
        settings.show_startup_tips = false;
      };

      zoxide = { # better cd
        enable = true;
      };

      lazygit.enable = true;

      btop = {
        enable = true;
        settings.color_theme = lib.mkForce "elementarish";
      };
    };
  };
in
{
  environment.systemPackages = with pkgs; [
    udiskie
    jmtpfs # Androip Media Transfer Protocol
    jq
    rsync
    sshfs
    unzip
    wget
    zip
  ];

  home-manager.users.root = { ... }: {
    imports = [ toolsConfig ];
  };

  home-manager.users.${username} = { ... }: {
    imports = [ toolsConfig ];
  };
}
