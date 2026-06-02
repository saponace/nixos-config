{ pkgs, lib, username, ... }:
{
  imports = [
    ./hardware.nix
    ./network.nix
  ];

  boot.loader.raspberry-pi.bootloader = "kernel";

  # RPi kernel max for vm.mmap_rnd_bits is 30 (vs NixOS default of 33)
  boot.kernel.sysctl."vm.mmap_rnd_bits" = lib.mkForce 30;

  users.users.${username}.extraGroups = [ "docker" "networkmanager" "media" ];

  users.groups.media.gid = 1000;

  virtualisation.docker.enable = true;

  environment = {
    systemPackages = [ pkgs.docker-compose ];

    etc = {
      "stak/docker-compose.yaml".source = ./stak/docker-compose-stak.yaml;
      "stak/docker-compose.env".source = ./stak/docker-compose.env;
    };
  };

  systemd.services.stak = {
    description = "Stak";
    requires = [ "docker.service" "mnt-wd.mount" ];
    after = [ "docker.service" "mnt-wd.mount" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      TimeoutStopSec = 15;
      WorkingDirectory = "/etc/stak";
      ExecStartPre = "${pkgs.docker-compose}/bin/docker-compose --file /etc/stak/docker-compose.yaml --env-file /etc/stak/docker-compose.env --env-file /mnt/wd/stak-config/secrets.env down";
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose --file /etc/stak/docker-compose.yaml --env-file /etc/stak/docker-compose.env --env-file /mnt/wd/stak-config/secrets.env up";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose --file /etc/stak/docker-compose.yaml --env-file /etc/stak/docker-compose.env --env-file /mnt/wd/stak-config/secrets.env down";
    };
  };

  home-manager.users.${username} = { ... }: {
    programs.zsh = {
      shellAliases = {
        stak = "docker-compose --file /etc/stak/docker-compose.yaml --env-file /etc/stak/docker-compose.env --env-file /mnt/wd/stak-config/secrets.env";
      };
      initContent = ''
        stak-backup() {
          (cd /mnt/wd && zip -r "stak-config~$(date +%Y%m%d).zip" stak-config \
            --exclude "stak-config/radarr/logs/*" \
            --exclude "stak-config/radarr/MediaCover/*" \
            --exclude "stak-config/bazarr/log" \
            --exclude "stak-config/prowlarr/logs/*" \
            --exclude "stak-config/jellyfin/data/data/subtitles/*" \
            --exclude "stak-config/jellyfin/data/metadata/*" \
            --exclude "stak-config/jellyfin/cache/*" \
            --exclude "stak-config/sabnzbd/logs/*" \
            --exclude "stak-config/sonarr/logs/*" \
            --exclude "stak-config/sonarr/MediaCover/*")
        }
      '';
    };
  };

  system.stateVersion = "26.05";
}
