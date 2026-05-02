{ config, ... }:

{
  home.file.".config/nvim" = {
    source = ../files/nvim;
    recursive = true;
  };
}
