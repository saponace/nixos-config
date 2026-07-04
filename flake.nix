{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # HM for the RPi, matching nixos-raspberrypi's nixpkgs (master needs 26.x lib).
    # TODO: bump release branch when nixos-raspberrypi moves off nixos-25.11.
    home-manager-rpi = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixos-raspberrypi/nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-raspberrypi = {
      url = "github:nvmd/nixos-raspberrypi/main";
      # Don't follow this flake's nixpkgs: it needs its own pin (stdenv.hostPlatform.linux-kernel).
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
      home-manager-rpi,
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
      # nixosSystem, not nixosSystemFull: Full's global overlay (RPi-optimised
      # ffmpeg/pipewire) rebuilds lots of uncached graphical deps for nothing on
      # a headless server.
      mkRpi5Server =
        hostPath:
        nixos-raspberrypi.lib.nixosSystem {
          specialArgs = { inherit self username userEmail; };
          modules = [
            nixos-raspberrypi.nixosModules.raspberry-pi-5.base
            home-manager-rpi.nixosModules.home-manager
            disko.nixosModules.disko
            preservation.nixosModules.default
            hostPath
            ./profiles/base.nix
          ];
        };

      # Format disk and install
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

      # Build the sd image, flash it and seed /persistent
      mkFlash =
        system:
        let
          p = nixpkgs.legacyPackages.${system};
        in
        p.writeShellApplication {
          name = "flash";
          runtimeInputs = [
            p.mkpasswd
            p.util-linux # lsblk, mount
            p.git
          ];
          text = ''
            user_name=${username}
          ''
          + builtins.readFile ./scripts/flash.sh;
        };

      # Install with existing /persistent setup
      mkRefresh =
        system:
        let
          p = nixpkgs.legacyPackages.${system};
        in
        p.writeShellApplication {
          name = "refresh";
          runtimeInputs = [
            disko.packages.${system}.disko
            p.nixos-install-tools
          ];
          text = builtins.readFile ./scripts/refresh.sh;
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
        x86_64-linux = {
          bootstrap = mkBootstrap "x86_64-linux";
          refresh = mkRefresh "x86_64-linux";
          flash = mkFlash "x86_64-linux";
        };
        aarch64-linux = {
          bootstrap = mkBootstrap "aarch64-linux";
          refresh = mkRefresh "aarch64-linux";
          installer = rpi5InstallerImage;
        };
      };

      apps = {
        x86_64-linux = {
          bootstrap = {
            type = "app";
            program = "${self.packages.x86_64-linux.bootstrap}/bin/bootstrap";
          };
          refresh = {
            type = "app";
            program = "${self.packages.x86_64-linux.refresh}/bin/refresh";
          };
          flash = {
            type = "app";
            program = "${self.packages.x86_64-linux.flash}/bin/flash";
          };
        };
        aarch64-linux = {
          bootstrap = {
            type = "app";
            program = "${self.packages.aarch64-linux.bootstrap}/bin/bootstrap";
          };
          refresh = {
            type = "app";
            program = "${self.packages.aarch64-linux.refresh}/bin/refresh";
          };
        };
      };

      # `nix flake check` catches config errors (--no-build for eval only; --all-systems to also build configs for hosts with other architectures)
      checks = {
        x86_64-linux = {
          pre-commit = preCommitCheck;
          celeri = self.nixosConfigurations.celeri.config.system.build.toplevel;
          rutabaga = self.nixosConfigurations.rutabaga.config.system.build.toplevel;
        };
        aarch64-linux.topinambour = self.nixosConfigurations.topinambour.config.system.build.toplevel;
      };

      devShells.x86_64-linux.default = pkgs.mkShell {
        inherit (preCommitCheck) shellHook;
      };
    };
}
