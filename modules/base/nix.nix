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

    environment = {
      systemPackages = with pkgs; [
        nh
        nixfmt
        statix
        deadnix
      ];

      sessionVariables = {
        NH_FLAKE = "/home/${username}/nixos-config/"; # Used by nh
      };
    };

    nix = {
      optimise = {
        automatic = true;
        dates = [ "22:45" ];
      };

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };
  };
}
