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
}
