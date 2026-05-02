{ pkgs, ... }:

{
  users.users.saponace = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    initialPassword = "sapo";
  };

  programs.zsh.enable = true;
}
