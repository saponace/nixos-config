{ username, ... }:

{
  home-manager.users.${username} = { ... }: {
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
}
