{ username, ... }:

{
  time.timeZone = "America/Montreal";
  i18n.defaultLocale = "en_US.UTF-8";
  console.useXkbConfig = true; # derives console keymap from services.xserver.xkb.layout

  # Override dead key bindings
  home-manager.users.${username}.home.file.".XCompose".text = ''
    include "%L"

    <dead_acute> <c> : "ç"
    <dead_acute> <C> : "Ç"
  '';
}
