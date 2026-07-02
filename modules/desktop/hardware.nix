{ username, ... }:

{
  hardware.i2c.enable = true;

  boot.binfmt = {
    emulatedSystems = [ "aarch64-linux" ];
    # Static qemu so emulation works in chroots
    preferStaticEmulators = true;
  };

  users.users.${username}.extraGroups = [ "i2c" ];
}
