{ ... }:

{
  services.printing.enable = true;
  services.spice-vdagentd.enable = true;  # Enables clipboard sharing with host when running as vm
  services.udisks2.enable = true;
  security.polkit.enable = true;  # Policy kit
}
