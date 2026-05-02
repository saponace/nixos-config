# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };


  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sapo = {
    isNormalUser = true;
    description = "sapo";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    initialPassword = "sapo"; 
  };

  programs.zsh = {
    enable = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.sapo = { config, ... }: {
      home.stateVersion = "25.11";
      programs.home-manager.enable = true;
      programs.zoxide.enable = true;
      programs.ranger.enable = true;

      xdg.enable = true;

      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        initContent = builtins.concatStringsSep "\n" [
          (builtins.readFile ./zsh/misc)
          (builtins.readFile ./zsh/misc-functions)
          (builtins.readFile ./zsh/aliases)
          (builtins.readFile ./zsh/prompt)
        ];

        shellAliases = {
          snrs = "sudo nixos-rebuild switch --flake /home/sapo/nixos-config#nixos";
        };
      };


      # LazyVim writes lazy-lock.json under ~/.config/nvim, so keep it writable.
      xdg.configFile."nvim".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/nvim";
    };
  };


  # Install firefox.
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    # Core CLI
    git
    curl

    # LazyVim runtime deps (plugins installed by lazy.nvim)
    ripgrep
    fd
    unzip

    # Tooling often required for plugin builds
    gcc
    gnumake

    # Common external tooling used by Neovim plugins (e.g. mason.nvim)
    nodejs
    python3
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
