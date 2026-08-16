{ lib, pkgs, ... }:

{
  boot = {
    plymouth = {
      enable = true;
      theme = "colorful_loop";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [
            "colorful_loop"
            "square"
            "hexagon_2"
          ];
        })
      ];
    };
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "systemd.show_status=auto"
    ];
    loader.timeout = 5;
  };

  # Play the splash until niri takes over
  services.greetd.greeterManagesPlymouth = true; # don't make greetd wait for plymouth to exit first
  systemd.services = {
    plymouth-quit.wantedBy = lib.mkForce [ ]; # never quit the splash at multi-user.target
    plymouth-quit-wait.wantedBy = lib.mkForce [ ]; # nor pull in its getty-blocking waiter
    greetd.serviceConfig.ExecStartPre = "-${lib.getExe' pkgs.plymouth "plymouth"} quit --retain-splash"; # quit but keep last frame up until niri draws
  };
}
