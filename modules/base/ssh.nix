{ pkgs, username, ... }:
{

  environment.systemPackages = with pkgs; [
    sshfs
  ];

  services.openssh.enable = true;

  preservation.preserveAt."/persistent".users.${username}.directories = [
    ".ssh"
  ];
}
