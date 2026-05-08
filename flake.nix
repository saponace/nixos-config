{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    niri.url = "github:sodiboo/niri-flake";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      mkHost = hostPath: nixpkgs.lib.nixosSystem {
        specialArgs = { inherit self inputs; };
        modules = [
          hostPath
          home-manager.nixosModules.home-manager
        ];
      };
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        modules = [
          home-manager.nixosModules.home-manager
        ];
      };

      # New skeleton: per-host entrypoints.
      nixosConfigurations.desktop = mkHost ./hosts/desktop;
      nixosConfigurations.laptop = mkHost ./hosts/laptop;
      nixosConfigurations.vm = mkHost ./hosts/vm;
    };
}
