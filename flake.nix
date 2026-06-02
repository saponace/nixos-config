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
          ./profiles/desktop.nix
        ];
      };
      mkRpi5Server = hostPath: nixos-raspberrypi.lib.nixosInstaller {
        specialArgs = { inherit self username userEmail; };
        modules = [
          nixos-raspberrypi.nixosModules.raspberry-pi-5.base
          home-manager.nixosModules.home-manager
          hostPath
          ./profiles/server.nix
        ];
      };
    in {
      nixosConfigurations.celeri = mkHost ./hosts/celeri;
      nixosConfigurations.rutabaga = mkHost ./hosts/rutabaga;
      nixosConfigurations.vm = mkHost ./hosts/vm;
      nixosConfigurations.topinambour = mkRpi5Server ./hosts/topinambour;
    };
}
