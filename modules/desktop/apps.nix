{ pkgs, username, ... }:

{
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
