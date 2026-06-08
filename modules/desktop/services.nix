_:

{
  services.printing.enable = true;
  services.udisks2.enable = true;
  security.polkit.enable = true; # Policy kit

  preservation.preserveAt."/persistent".directories = [ "/var/lib/cups" ];
}
