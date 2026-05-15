{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, stylix, ... }:
    let
      mkHost = hostPath: nixpkgs.lib.nixosSystem {
        specialArgs = { inherit self; };
        modules = [
          stylix.nixosModules.stylix
          hostPath
          home-manager.nixosModules.home-manager
        ];
      };
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        modules = [
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
        ];
      };

      nixosConfigurations.celeri = mkHost ./hosts/celeri;
      nixosConfigurations.rutabaga = mkHost ./hosts/rutabaga;
      nixosConfigurations.vm = mkHost ./hosts/vm;
    };
}
