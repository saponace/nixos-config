{ pkgs, ... }:

{
  users.users.saponace = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "kvm" "libvirtd" ];
    shell = pkgs.zsh;
    initialPassword = "pwd";
  };

  programs.zsh.enable = true;
}
