{ pkgs, username, ... }:

{
  environment.systemPackages = [
    pkgs.ollama
    pkgs.claude-code
  ];

  services.ollama = {
    enable = true;
    loadModels = [ "qwen2.5-coder:1.5b" ];
  };

  home-manager.users.${username} = {
    programs.opencode.enable = true;
  };
}
