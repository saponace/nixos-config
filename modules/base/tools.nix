{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    udiskie
    jmtpfs # Androip Media Transfer Protocol
    rsync
    sshfs
    unzip
    wget
    zip
  ];
}
