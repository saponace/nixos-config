{ username, ... }:

let
  zshConfig = { ... }: {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      initContent = builtins.concatStringsSep "\n" [
        (builtins.readFile ./config/misc.sh)
        (builtins.readFile ./config/functions.sh)
        (builtins.readFile ./config/aliases.sh)
        (builtins.readFile ./config/prompt.sh)
      ];
    };
  };
in
{
  home-manager.users.root = { ... }: {
    imports = [ zshConfig ];
  };

  home-manager.users.${username} = { ... }: {
    imports = [ zshConfig ];
  };
}
