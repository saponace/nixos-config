{ ... }:

{
  programs.lsd.enable = true;
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    settings.theme = "catppuccin-macchiato";
  };
}
