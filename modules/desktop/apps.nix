{ pkgs, username, ... }:

let
  # Upstream release binary: the flake builds from source with no binary cache
  omp = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "omp";
    version = "18.11.0";
    src = pkgs.fetchurl {
      url = "https://github.com/can1357/oh-my-pi/releases/download/v${version}/omp-linux-x64";
      hash = "sha256-wjpYrYqS9Oc4qhLckE87ChrHA1uVO5v105txoiYXn28=";
    };
    dontUnpack = true;
    dontStrip = true; # stripping drops the Bun payload appended to the executable
    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    installPhase = "install -Dm755 $src $out/bin/omp";
  };
in
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
    omp
    swayimg
    vlc
  ];

  programs.steam.enable = true;

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
      defaultApplications."application/pdf" = "firefox.desktop";
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
