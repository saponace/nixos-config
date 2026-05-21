{ pkgs, username, ... }:

{
  allowedUnfreePrefixes = [ "bitwig-studio" ]; # catches bitwig-studio6, bitwig-studio7, etc.
  allowedUnfreePackages = [ "steam" "steam-original" "steam-unwrapped" "steam-run" ];

  environment.systemPackages = with pkgs; [
    bitwig-studio
    nautilus
    swayimg
    vlc
  ];

  programs.steam.enable = true;

  home-manager.users.${username} = { ... }: {
    programs = {
      firefox.enable = true;
      alacritty.enable = true;
    };
  };
}
