{ pkgs, username, ... }:

{
  allowedUnfreePackages = [ "claude-code" ];

  environment.systemPackages = [
    pkgs.ollama
    pkgs.claude-code
  ];

  services.ollama = {
    enable = true;
    loadModels = [ "qwen2.5-coder:1.5b" ];
  };

  preservation.preserveAt."/persistent" = {
    directories = [ "/var/lib/ollama" ];
    users.${username} = {
      directories = [
        ".claude"
        ".config/opencode"
        ".local/share/opencode"
        ".local/state/opencode"
      ];
      files = [
        ".claude.json"
      ];
    };
  };

  home-manager.users.${username} = {
    programs.opencode.enable = true;
  };
}
