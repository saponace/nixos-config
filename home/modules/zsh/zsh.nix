{ ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = builtins.concatStringsSep "\n" [
      (builtins.readFile ./config/misc)
      (builtins.readFile ./config/misc-functions)
      (builtins.readFile ./config/aliases)
      (builtins.readFile ./config/prompt)
    ];

    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake #";
    };
  };
}
