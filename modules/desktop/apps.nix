{
  pkgs,
  self,
  username,
  ...
}:

{
  allowedUnfreePrefixes = [ "bitwig-studio" ]; # catches bitwig-studio6, bitwig-studio7, etc.
  allowedUnfreePackages = [
    "steam"
    "steam-original"
    "steam-unwrapped"
    "steam-run"
  ];

  environment.systemPackages = with pkgs; [
    bitwig-studio
    btrfs-assistant # btrfs/snapper GUI
    nautilus
    self.inputs.llm-agents.packages.${stdenv.hostPlatform.system}.omp
    swayimg
    vlc
  ];

  programs.steam.enable = true;

  # Lets GLib apps (nautilus, firefox downloads…) launch Terminal=true entries like nvim.desktop
  xdg.terminal-exec = {
    enable = true;
    settings.default = [ "Alacritty.desktop" ];
  };

  preservation.preserveAt."/persistent".users.${username}.directories = [
    ".config/mozilla"
    ".local/share/keyrings"
    "Bitwig Studio" # workspace
    ".BitwigStudio" # license activation, EULA flag, prefs, installed packages
    ".local/share/Steam"
    ".steam"
    ".omp"
  ];

  home-manager.users.${username} = _: {
    xdg.mimeApps = {
      enable = true;
      associations.added."application/pdf" = "firefox.desktop";
      defaultApplications = {
        "application/pdf" = "firefox.desktop";
        "text/plain" = "nvim.desktop"; # also covers subclasses: markdown, nix, shell, json…
      };
    };

    programs = {
      firefox = {
        enable = true;
        profiles.default = {
          id = 0;
          settings = {
            # Don't show the "Firefox crashed" prompt after an unclean shutdown
            "browser.sessionstore.resume_from_crash" = false;

            # DoH tunnels DNS past the LAN resolver, hiding local names from it
            "network.trr.mode" = 5;
          };
        };
      };
      alacritty = {
        enable = true;
        settings.keyboard.bindings = [
          {
            key = "F";
            mods = "Control";
            action = "SearchForward";
          }
        ];
      };
    };
  };
}
