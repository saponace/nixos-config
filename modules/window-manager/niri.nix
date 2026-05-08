{
  inputs,
  self,
  ...
}: {
  programs.niri.enable = true;
  systemd.user.services.niri.enableDefaultPath = false;
}
