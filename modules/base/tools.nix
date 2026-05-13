{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    udiskie
    jmtpfs # Androip Media Transfer Protocol
    jq
    rsync
    sshfs
    unzip
    wget
    zip
  ];
}
