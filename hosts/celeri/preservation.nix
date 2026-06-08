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
        "/var/lib/bluetooth"
        "/var/lib/cups"
        "/etc/NetworkManager/system-connections"
        "/tmp"
      ];
      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
        }
      ];
      users.${username} = {
        directories = [
          ".ssh"
          ".gnupg"
          ".config/mozilla"
          "Downloads"
          "Pictures"
          "repos"
          "samples"
          "Bitwig Studio"
          ".local/share/keyrings"
          ".local/share/nvim"
        ];
      };
    };
  };
}
