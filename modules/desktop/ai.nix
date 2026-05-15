
{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.ollama ];

  services.ollama = {
    enable = true;
    loadModels = [ "qwen2.5-coder:1.5b" ];
  };
}
