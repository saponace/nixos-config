{ lib, pkgs, config, username, ... }:

{
  options = {
    allowedUnfreePackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };

    allowedUnfreePrefixes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };
  };

  config = {
    programs.nix-ld.enable = true;
    services.envfs.enable = true;

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    nixpkgs.config.allowUnfreePredicate = pkg:
      let name = lib.getName pkg;
      in builtins.elem name config.allowedUnfreePackages
      || builtins.any (prefix: lib.hasPrefix prefix name) config.allowedUnfreePrefixes;

    environment = {
      systemPackages = with pkgs; [
        nh
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
