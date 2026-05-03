{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    jmtpfs # Androip Media Transfer Protocol
    rsync
    sshfs
    unzip
    wget
    zip
  ];

  programs.tmux.enable = true;
  services.printing.enable = true;
  services.spice-vdagentd.enable = true;  # Enables clipboard sharing with host when running as vm
}
