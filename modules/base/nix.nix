{ lib, ... }:

{
  programs.nix-ld.enable = true;
  services.envfs.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-unwrapped"
    "steam-run"
  ];
}
