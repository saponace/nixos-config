{ pkgs, username, userEmail, ... }:

{
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "kvm" "libvirtd" ];
    shell = pkgs.zsh;
    initialPassword = username;
  };

  programs.zsh.enable = true;

  home-manager.users.${username} = { ... }: {
    home.stateVersion = "26.05";

    xdg.enable = true;

    programs = {
      home-manager.enable = true;

      git = {
        enable = true;
        settings.user = {
          email = userEmail;
          name = username;
        };
      };
    };
  };
}
