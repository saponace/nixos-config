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
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      stylix,
      silentSDDM,
      nixos-raspberrypi,
      pre-commit-hooks,
      ...
    }:
    let
      username = "saponace";
      userEmail = "saponace@gmail.com";
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      mkHost =
        hostPath:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit self username userEmail; };
          modules = [
            stylix.nixosModules.stylix
            silentSDDM.nixosModules.default
            home-manager.nixosModules.home-manager
            hostPath
          ];
        };
      mkRpi5Server =
        hostPath:
        nixos-raspberrypi.lib.nixosInstaller {
          specialArgs = { inherit self username userEmail; };
          modules = [
            nixos-raspberrypi.nixosModules.raspberry-pi-5.base
            home-manager.nixosModules.home-manager
            hostPath
            ./profiles/base.nix
          ];
        };
      preCommitCheck = pre-commit-hooks.lib.x86_64-linux.run {
        src = ./.;
        hooks.nixfmt-rfc-style.enable = true;
        hooks.statix.enable = true;
      };
    in
    {
      nixosConfigurations = {
        celeri = mkHost ./hosts/celeri;
        rutabaga = mkHost ./hosts/rutabaga;
        vm = mkHost ./hosts/vm;
        topinambour = mkRpi5Server ./hosts/topinambour;
      };

      checks.x86_64-linux.pre-commit = preCommitCheck;

      devShells.x86_64-linux.default = pkgs.mkShell {
        inherit (preCommitCheck) shellHook;
      };
    };
}
