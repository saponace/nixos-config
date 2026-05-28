{ pkgs, username, ... }:
{
  imports = [ ./hardware.nix ];

  networking = {
    hostName = "topinambour";
    networkmanager.enable = true;
  };

  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  };

  users.users.${username}.extraGroups = [ "docker" "networkmanager" ];

  virtualisation.docker.enable = true;

  environment = {
    systemPackages = [ pkgs.docker-compose ];

    etc = {
      "mediastack/docker-compose.yaml".source = ./mediastack/docker-compose-mediastack.yaml;
      "mediastack/docker-compose.env".source = ./mediastack/docker-compose.env;
    };
  };

  systemd.services.mediastack = {
    description = "Mediastack";
    requires = [ "docker.service" "mnt-wd.mount" ];
    after = [ "docker.service" "mnt-wd.mount" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      TimeoutStopSec = 15;
      WorkingDirectory = "/etc/mediastack";
      ExecStartPre = "${pkgs.docker-compose}/bin/docker-compose --file /etc/mediastack/docker-compose.yaml --env-file /etc/mediastack/docker-compose.env down";
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose --file /etc/mediastack/docker-compose.yaml --env-file /etc/mediastack/docker-compose.env up";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose --file /etc/mediastack/docker-compose.yaml --env-file /etc/mediastack/docker-compose.env down";
    };
  };

  home-manager.users.${username} = { ... }: {
    programs.zsh.shellAliases = {
      dcompose = "docker-compose --file /etc/mediastack/docker-compose.yaml --env-file /etc/mediastack/docker-compose.env";
    };
  };

  system.stateVersion = "26.05";
}
