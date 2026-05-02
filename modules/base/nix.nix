{ ... }:

{
  programs.nix-ld.enable = true;
  services.envfs.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
