{ username, ... }:

{
  hardware.i2c.enable = true;

  users.users.${username}.extraGroups = [ "i2c" ];
}
