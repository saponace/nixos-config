{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    unzip
    vim
    ranger
  ];
}
