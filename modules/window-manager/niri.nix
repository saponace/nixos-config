{ ... }:

{
  programs.niri.enable = true;

  home-manager.users.saponace.home.file.".config/niri/config.kdl" = {
    source = ./config.kdl;
  };
}
