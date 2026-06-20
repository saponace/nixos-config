{
  pkgs,
  username,
  userEmail,
  ...
}:

{
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
    shell = pkgs.zsh;
    # Password comes from is seeded to the persistent volume at install (see README).
    hashedPasswordFile = "/persistent/password";
  };

  programs.zsh.enable = true;

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
