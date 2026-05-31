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
    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-raspberrypi = {
      url = "github:nvmd/nixos-raspberrypi/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, stylix, silentSDDM, nixos-raspberrypi, ... }:
    let
      username = "saponace";
      userEmail = "saponace@gmail.com";
      mkHost = hostPath: nixpkgs.lib.nixosSystem {
        specialArgs = { inherit self username userEmail; };
        modules = [
          stylix.nixosModules.stylix
          silentSDDM.nixosModules.default
          home-manager.nixosModules.home-manager
          hostPath
          ./modules/configuration.nix
        ];
      };
      mkServer = hostPath: nixpkgs.lib.nixosSystem {
        specialArgs = { inherit self username userEmail; };
        modules = [
          home-manager.nixosModules.home-manager
          hostPath
          ./modules/server-configuration.nix
        ];
      };
    in {
      nixosConfigurations.celeri = mkHost ./hosts/celeri;
      nixosConfigurations.rutabaga = mkHost ./hosts/rutabaga;
      nixosConfigurations.vm = mkHost ./hosts/vm;
      nixosConfigurations.topinambour = nixos-raspberrypi.lib.nixosSystem {
        specialArgs = { inherit self username userEmail; };
        modules = [
          home-manager.nixosModules.home-manager
          nixos-raspberrypi.nixosModules.raspberry-pi-5.base
          nixos-raspberrypi.nixosModules.raspberry-pi-5.bluetooth
          ./hosts/topinambour
          ./modules/server-configuration.nix
        ];
      };
    };
}
