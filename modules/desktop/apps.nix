{ pkgs, username, ... }:

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
    nautilus
    swayimg
    vlc
  ];

  programs.steam.enable = true;

  preservation.preserveAt."/persistent".users.${username}.directories = [
    ".config/mozilla"
    ".local/share/keyrings"
    "Bitwig Studio"
  ];

  home-manager.users.${username} = _: {
    programs = {
      firefox.enable = true;
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
