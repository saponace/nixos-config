{ config, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
  };

  home.file.".config/nvim" = {
    source = ../files/nvim;
    recursive = true;
  };
}
