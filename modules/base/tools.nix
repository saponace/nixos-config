{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    unzip
    vim
    ranger
    lsd
    wget
  ];

  programs.tmux.enable = true;
  services.printing.enable = true;
  services.spice-vdagentd.enable = true;  # Enables clipboard sharing with host when running as vm
}
