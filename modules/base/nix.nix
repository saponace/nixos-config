{ lib, pkgs, username, ... }:

{
  programs.nix-ld.enable = true;
  services.envfs.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    let 
      name = lib.getName pkg;
    in
      lib.hasPrefix "bitwig-studio" name  # catches any package named "bitwig-studio6", "bitwig-studio7" etc.
    || builtins.elem name [
    "steam"
    "steam-original"
    "steam-unwrapped"
    "steam-run"
    "claude-code"
  ];

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
}
