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

  users.users.${username} = {
    uid = 1000; # aligns with /mnt/wd ownership and Docker PUID=1000
    extraGroups = [ "docker" "networkmanager" ];
  };

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
