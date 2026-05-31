{ pkgs, lib, username, ... }:
{
  imports = [
    ./hardware.nix
    ./network.nix
    ../../modules/desktop/nvim/nvim.nix
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
      ExecStartPre = "${pkgs.docker-compose}/bin/docker-compose --file /etc/mediastack/docker-compose.yaml --env-file /etc/mediastack/docker-compose.env --env-file /mnt/wd/mediastack-config/secrets.env down";
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose --file /etc/mediastack/docker-compose.yaml --env-file /etc/mediastack/docker-compose.env --env-file /mnt/wd/mediastack-config/secrets.env up";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose --file /etc/mediastack/docker-compose.yaml --env-file /etc/mediastack/docker-compose.env --env-file /mnt/wd/mediastack-config/secrets.env down";
    };
  };

  home-manager.users.${username} = { ... }: {
    programs.zsh = {
      shellAliases = {
        stak = "docker-compose --file /etc/mediastack/docker-compose.yaml --env-file /etc/mediastack/docker-compose.env --env-file /mnt/wd/mediastack-config/secrets.env";
      };
      initContent = ''
        mediastack-backup() {
          (cd /mnt/wd && zip -r "mediastack-config~$(date +%Y%m%d).zip" mediastack-config \
            --exclude "mediastack-config/radarr/logs/*" \
            --exclude "mediastack-config/radarr/MediaCover/*" \
            --exclude "mediastack-config/bazarr/log" \
            --exclude "mediastack-config/prowlarr/logs/*" \
            --exclude "mediastack-config/jellyfin/data/data/subtitles/*" \
            --exclude "mediastack-config/jellyfin/data/metadata/*" \
            --exclude "mediastack-config/jellyfin/cache/*" \
            --exclude "mediastack-config/sabnzbd/logs/*" \
            --exclude "mediastack-config/sonarr/logs/*" \
            --exclude "mediastack-config/sonarr/MediaCover/*")
        }
      '';
    };
  };

  system.stateVersion = "26.05";
}
