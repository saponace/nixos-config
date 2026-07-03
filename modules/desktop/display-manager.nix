{ username, ... }:

{
  # Auto-login into niri. Noctalia locks the screen immediately.
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "niri-session";
        user = username;
      };
      default_session = {
        command = "niri-session";
        user = username;
      };
    };
  };
}
