{ username, ... }:

{
  hardware.i2c.enable = true;

  boot.binfmt = {
    emulatedSystems = [ "aarch64-linux" ];
    # Static qemu so can chroot into aarch64 systems
    preferStaticEmulators = true;
  };

  users.users.${username}.extraGroups = [ "i2c" ];
}
