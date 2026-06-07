_:

{
  services.joycond.enable = true;
  boot.extraModprobeConfig = "options bluetooth disable_ertm=1";
}
