# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

  programs.zsh = {
    enable = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

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
