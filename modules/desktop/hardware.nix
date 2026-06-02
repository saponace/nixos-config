{ username, ... }:

{
  hardware.i2c.enable = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  users.users.${username}.extraGroups = [ "i2c" ];
}
