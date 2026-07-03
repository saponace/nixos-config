{
  pkgs,
  username,
  lib,
  config,
  ...
}:
{

  environment.systemPackages = with pkgs; [
    sshfs
  ];

  services.openssh.enable = true;

  services.openssh.hostKeys = lib.mkIf config.preservation.enable [
    {
      path = "/persistent/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }
  ];

  preservation.preserveAt."/persistent".users.${username}.directories = [
    ".ssh"
  ];
}
