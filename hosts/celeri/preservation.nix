{ username, ... }:
{
  preservation = {
    enable = true;
    preserveAt."/persistent" = {
      directories = [
        {
          directory = "/var/lib/nixos";
          inInitrd = true;
        }
      ];
      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
        }
      ];
      users.${username}.directories = [
        "repos"
        "Bitwig\ Studio"
        "samples"
      ];
    };
  };
}
