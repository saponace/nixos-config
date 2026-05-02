{ ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = builtins.concatStringsSep "\n" [
      (builtins.readFile ../files/zsh/misc)
      (builtins.readFile ../files/zsh/misc-functions)
      (builtins.readFile ../files/zsh/aliases)
      (builtins.readFile ../files/zsh/prompt)
    ];

    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake #";
    };
  };
}
