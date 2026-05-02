{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    unzip
    vim
    ranger
    lsd
    wget
  ];

  services.printing.enable = true;
  # Enable clipboard sharing with host when running as vm
  services.spice-vdagentd.enable = true;
}
