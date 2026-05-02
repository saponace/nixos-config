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
      system = "x86_64-linux";

      mkHost = hostPath: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit self; };
        modules = [
          hostPath
          home-manager.nixosModules.home-manager
        ];
      };
    in {
      # Keep the original entrypoint so existing workflows don't break.
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };

      # New skeleton: per-host entrypoints.
      nixosConfigurations.laptop = mkHost ./hosts/laptop;
      nixosConfigurations.desktop = mkHost ./hosts/desktop;
      nixosConfigurations.vm = mkHost ./hosts/vm;
    };
}
