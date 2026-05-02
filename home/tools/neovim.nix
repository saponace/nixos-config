{ config, ... }:

{
  # LazyVim writes lazy-lock.json under ~/.config/nvim, so keep it writable.
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/home/files/nvim";
}
