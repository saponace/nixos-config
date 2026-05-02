{ pkgs, ... }:

{
  users.users.sapo = {
    isNormalUser = true;
    description = "sapo";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    initialPassword = "sapo"; 
  };

  programs.zsh.enable = true;
}
