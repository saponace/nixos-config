{
  lib,
  pkgs,
  config,
  username,
  ...
}:

{
  options = {
    allowedUnfreePackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    allowedUnfreePrefixes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  config = {
    programs.nix-ld.enable = true;
    services.envfs.enable = true;

    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        username
      ];
      # Declared here rather than flake.nix nixConfig to avoid --accept-flake-config warnings
      extra-substituters = [ "https://nixos-raspberrypi.cachix.org" ];
      extra-trusted-public-keys = [
        "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
      ];
    };

    nixpkgs.config.allowUnfreePredicate =
      pkg:
      let
        name = lib.getName pkg;
      in
      builtins.elem name config.allowedUnfreePackages
      || builtins.any (prefix: lib.hasPrefix prefix name) config.allowedUnfreePrefixes;

    programs.nh = {
      enable = true;
      flake = "/home/${username}/repos/nixos-config";
      clean = {
        enable = true; # weekly by default
        extraArgs = "--keep 3 --keep-since 7d";
      };
    };

    environment.systemPackages = with pkgs; [
      nixfmt
      statix
      deadnix
    ];

    nix.optimise = {
      automatic = true;
      dates = [ "22:45" ];
    };
  };
}
