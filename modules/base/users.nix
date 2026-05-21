{ pkgs, username, ... }:

{
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "kvm" "libvirtd" ];
    shell = pkgs.zsh;
    initialPassword = username;
  };

  programs.zsh.enable = true;
}
