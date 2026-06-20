{
  pkgs,
  lib,
  config,
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
    # initialPassword is kept on purpose as a safety net if persistent hashed pwd file is absent
    #   - it's the only password source on non-impermanent hosts
    initialPassword = username;
    hashedPasswordFile = lib.mkIf config.preservation.enable "/persistent/password";
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
