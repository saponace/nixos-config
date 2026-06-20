{
  pkgs,
  username,
  userEmail,
  config,
  ...
}:

{
  users.users.${username} = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
    ];
    shell = pkgs.zsh;
    # Password comes from is seeded to the persistent volume at install (see README).
    hashedPasswordFile = "/persistent/password";
  };

  programs.zsh.enable = true;

  # Pre-create sudo's lecture marker so it never lectures
  systemd.tmpfiles.rules = [
    "f /var/db/sudo/lectured/${toString config.users.users.${username}.uid} 0600 root root -"
  ];

  home-manager.users.root.home.stateVersion = "26.05";

  home-manager.users.${username} = _: {
    home.stateVersion = "26.05";

    xdg.enable = true;

    programs = {
      home-manager.enable = true;

      git = {
        enable = true;
        settings.user = {
          email = userEmail;
          name = username;
        };
      };
    };
  };
}
