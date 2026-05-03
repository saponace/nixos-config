{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
  };

  home.packages = with pkgs; [
    # Lazy.nvim bootstrap + core UX
    git
    ripgrep
    fd
    unzip
    curl
    gnutar

    # TreeSitter parser builds
    tree-sitter
    gcc
    gnumake

    # Prefer Nix-managed LSP/formatters over Mason downloads
    lua-language-server
    nil
    nixfmt
    statix
    stylua
    shfmt
  ];

  home.file.".config/nvim" = {
    source = ./config;
    recursive = true;
  };
}
