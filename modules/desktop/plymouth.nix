{ pkgs, ... }:

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

    # Silent boot
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "systemd.show_status=auto"
    ];
    # Do not set to 0 or it will hide the OS choice for bootloaders and
    # not possible to choose which generation to boot from
    loader.timeout = 5;
  };
}
