{
  pkgs,
  lib,
  username,
  nixos-raspberrypi,
  ...
}:
let
  onPi = pkgs.stdenv.hostPlatform.isAarch64;

  stak-backup = pkgs.writeShellApplication {
    name = "stak-backup";
    runtimeInputs = [
      pkgs.zip
      pkgs.systemd
    ];
    text = ''
      keep=4
      cd /mnt/wd

      # every service holds sqlite WALs open; a clean stop checkpoints them into the .db files
      systemctl stop stak
      trap 'systemctl start stak' EXIT

      zip -r "stak-config~$(date +%Y%m%d).zip" stak-config \
        --exclude "stak-config/*/logs/*" \
        --exclude "stak-config/*/log" \
        --exclude "stak-config/*/log/*" \
        --exclude "stak-config/*/cache/*" \
        --exclude "stak-config/*/Sentry/*" \
        --exclude "stak-config/*/MediaCover/*" \
        --exclude "stak-config/*/Backups/*" \
        --exclude "stak-config/prowlarr/Definitions/*" \
        --exclude "stak-config/recyclarr/repositories/*" \
        --exclude "stak-config/jellyfin/data/data/subtitles/*" \
        --exclude "stak-config/jellyfin/data/metadata/*" \
        --exclude "stak-config/jellyfin/data/transcodes/*" \
        --exclude "stak-config/homeassistant/home-assistant.log*" \
        --exclude "stak-config/homeassistant/.cache/*" \
        --exclude "stak-config/homeassistant/tts/*"

      find . -maxdepth 1 -name 'stak-config~*.zip' -printf '%T@ %p\n' \
        | sort -rn | tail -n "+$((keep + 1))" | cut -d' ' -f2- | xargs -r rm -f
    '';
  };
in
{
  imports = [
    ./hardware.nix
    ./disko.nix
    ./network.nix
    ../../modules/base/preservation.nix
    ../../modules/base/btrfs.nix
  ];

  boot = {
    loader.raspberry-pi.bootloader = "kernel";

    # rpi5 defaults don't eval on x86 (image builder)
    kernelPackages =
      if onPi then nixos-raspberrypi.packages.aarch64-linux.linuxPackages_rpi5 else pkgs.linuxPackages;
    loader.raspberry-pi.firmwarePackage =
      if onPi then nixos-raspberrypi.packages.aarch64-linux.raspberrypifw else pkgs.raspberrypifw;

    # RPi kernel max for vm.mmap_rnd_bits is 30 (vs NixOS default of 33)
    kernel.sysctl."vm.mmap_rnd_bits" = lib.mkForce 30;
  };

  # This card's CQE breaks btrfs I/O (boot-tested); ext4/master tolerates it
  hardware.raspberry-pi.config.all.base-dt-params.sd_cqe = {
    enable = true;
    value = "0";
  };

  # Headless: no GPU
  hardware.raspberry-pi.config.all.dt-overlays.vc4-kms-v3d.enable = false;

  users.users.${username}.extraGroups = [
    "docker"
    "media"
  ];

  users.groups.media.gid = 1000;

  virtualisation.docker.enable = true;

  # Home Assistant runs on the host network, so docker's firewall bypass doesn't apply
  networking.firewall.allowedTCPPorts = [ 8123 ];

  preservation.preserveAt."/persistent".directories = [
    {
      directory = "/var/lib/docker";
      mode = "0710";
    }
  ];

  fileSystems."/persistent".neededForBoot = lib.mkForce true;

  environment = {
    systemPackages = [
      pkgs.docker-compose
      stak-backup
    ];

    etc = {
      "stak/docker-compose.yaml".source = ./stak/docker-compose-stak.yaml;
      "stak/docker-compose.env".source = ./stak/docker-compose.env;
      "stak/recyclarr.yml".source = ./stak/recyclarr.yml;
    };
  };

  systemd = {
    services = {
      stak =
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
            StandardOutput = "null"; # docker's journald driver already logs containers; compose duplicates it
            ExecStartPre = "${dc}/bin/docker-compose ${args} down";
            ExecStart = "${dc}/bin/docker-compose ${args} up";
            ExecStop = "${dc}/bin/docker-compose ${args} down";
          };
        };

      stak-backup = {
        description = "Stak config backup";
        requires = [ "mnt-wd.mount" ];
        after = [
          "mnt-wd.mount"
          "docker.service"
        ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = lib.getExe stak-backup;
        };
      };
    };

    timers.stak-backup = {
      description = "Weekly stak config backup";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "Sun 03:00";
        Persistent = true;
        RandomizedDelaySec = "10m";
      };
    };
  };

  home-manager.users.${username} = _: {
    programs.zsh.shellAliases = {
      stak = "docker-compose --file /etc/stak/docker-compose.yaml --env-file /etc/stak/docker-compose.env --env-file /mnt/wd/stak-config/secrets.env";
    };
  };

  system.stateVersion = "26.05";
}
