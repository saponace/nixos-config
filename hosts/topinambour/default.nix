{
  pkgs,
  lib,
  username,
  ...
}:
{
  imports = [
    ./hardware.nix
    ./disko.nix
    ./network.nix
    ../../modules/base/preservation.nix
    ../../modules/base/btrfs.nix
  ];

  boot.loader.raspberry-pi.bootloader = "kernel";

  # RPi kernel max for vm.mmap_rnd_bits is 30 (vs NixOS default of 33)
  boot.kernel.sysctl."vm.mmap_rnd_bits" = lib.mkForce 30;

  users.users.${username}.extraGroups = [
    "docker"
    "networkmanager"
    "media"
  ];

  users.groups.media.gid = 1000;

  virtualisation.docker.enable = true;

  preservation.preserveAt."/persistent".directories = [ "/var/lib/docker" ];

  fileSystems."/persistent".neededForBoot = lib.mkForce true;

  environment = {
    systemPackages = [ pkgs.docker-compose ];

    etc = {
      "stak/docker-compose.yaml".source = ./stak/docker-compose-stak.yaml;
      "stak/docker-compose.env".source = ./stak/docker-compose.env;
      "stak/recyclarr.yml".source = ./stak/recyclarr.yml;
    };
  };

  systemd.services.stak =
    let
      dc = pkgs.docker-compose;
      args = "--file /etc/stak/docker-compose.yaml --env-file /etc/stak/docker-compose.env --env-file /mnt/wd/stak-config/secrets.env";
    in
    {
      description = "Stak";
      requires = [
        "docker.service"
        "mnt-wd.mount"
      ];
      after = [
        "docker.service"
        "mnt-wd.mount"
      ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        TimeoutStopSec = 15;
        WorkingDirectory = "/etc/stak";
        ExecStartPre = "${dc}/bin/docker-compose ${args} down";
        ExecStart = "${dc}/bin/docker-compose ${args} up";
        ExecStop = "${dc}/bin/docker-compose ${args} down";
      };
    };

  home-manager.users.${username} = _: {
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
