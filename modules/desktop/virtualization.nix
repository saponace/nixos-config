{ username, ... }:

{
  programs.virt-manager.enable = true;

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  users.users.${username}.extraGroups = [ "kvm" "libvirtd" ];
}
