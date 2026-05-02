{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      mkHost = hostPath: nixpkgs.lib.nixosSystem {
        specialArgs = { inherit self; };
        modules = [
          hostPath
          home-manager.nixosModules.home-manager
        ];
      };
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };

      # New skeleton: per-host entrypoints.
      nixosConfigurations.desktop = mkHost ./hosts/desktop;
      nixosConfigurations.vm = mkHost ./hosts/vm;
    };
}
