{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.android-tools # adb / fastboot
    pkgs.jmtpfs # mount Android storage over MTP
  ];

  # Disable USB autosuspend for ADB devices (Android ADB interface: class ff, subclass 42, protocol 01)
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ENV{ID_USB_INTERFACES}=="*:ff4201:*", ATTR{power/autosuspend}="-1"
  '';
}
