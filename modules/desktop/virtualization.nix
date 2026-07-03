{ username, ... }:

{
  programs.virt-manager.enable = true;

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  users.users.${username}.extraGroups = [
    "kvm"
    "libvirtd"
  ];

  # libvirt state: VM definitions, networks, and the encrypted secret store.
  preservation.preserveAt."/persistent".directories = [ "/var/lib/libvirt" ];
}
