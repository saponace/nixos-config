{ username, ... }:

{
  # Auto-login into niri. Noctalia locks the screen immediately.
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "niri-session";
        user = username;
      };
    };
  };
}
