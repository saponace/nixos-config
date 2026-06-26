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
    nixos-raspberrypi = {
      url = "github:nvmd/nixos-raspberrypi/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    preservation.url = "github:nix-community/preservation";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      stylix,
      nixos-raspberrypi,
      pre-commit-hooks,
      disko,
      preservation,
      ...
    }:
    let
      username = "saponace";
      userEmail = "saponace@gmail.com";
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      mkDesktop =
        hostPath:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit self username userEmail; };
          modules = [
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            disko.nixosModules.disko
            preservation.nixosModules.default
            hostPath
          ];
        };
      mkRpi5Server =
        hostPath:
        nixos-raspberrypi.lib.nixosSystemFull {
          specialArgs = { inherit self username userEmail; };
          modules = [
            nixos-raspberrypi.nixosModules.raspberry-pi-5.base
            home-manager.nixosModules.home-manager
            disko.nixosModules.disko
            preservation.nixosModules.default
            hostPath
            ./profiles/base.nix
          ];
        };
      mkBootstrap =
        system:
        let
          p = nixpkgs.legacyPackages.${system};
        in
        p.writeShellApplication {
          name = "bootstrap";
          runtimeInputs = [
            disko.packages.${system}.disko
            p.mkpasswd
            p.util-linux # lsblk
            p.nixos-install-tools
            p.git # clone this repo into the persistent home
          ];
          text = ''
            user_name=${username}
          ''
          + builtins.readFile ./scripts/bootstrap.sh;
        };
      # Minimal RPi5 installer image
      rpi5InstallerImage =
        (nixos-raspberrypi.lib.nixosInstaller {
          specialArgs = { inherit self username userEmail; };
          modules = [
            nixos-raspberrypi.nixosModules.raspberry-pi-5.base
            ./modules/base/nix.nix
          ];
        }).config.system.build.sdImage;
      preCommitCheck = pre-commit-hooks.lib.x86_64-linux.run {
        src = ./.;
        hooks = {
          nixfmt.enable = true;
          statix.enable = true;
          deadnix.enable = true;
        };
      };
    in
    {
      nixosConfigurations = {
        celeri = mkDesktop ./hosts/celeri;
        rutabaga = mkDesktop ./hosts/rutabaga;
        topinambour = mkRpi5Server ./hosts/topinambour;
      };

      packages = {
        x86_64-linux.bootstrap = mkBootstrap "x86_64-linux";
        aarch64-linux = {
          bootstrap = mkBootstrap "aarch64-linux";
          installer = rpi5InstallerImage;
        };
      };

      apps = {
        x86_64-linux.bootstrap = {
          type = "app";
          program = "${self.packages.x86_64-linux.bootstrap}/bin/bootstrap";
        };
        aarch64-linux.bootstrap = {
          type = "app";
          program = "${self.packages.aarch64-linux.bootstrap}/bin/bootstrap";
        };
      };

      checks.x86_64-linux.pre-commit = preCommitCheck;

      devShells.x86_64-linux.default = pkgs.mkShell {
        inherit (preCommitCheck) shellHook;
      };
    };
}
