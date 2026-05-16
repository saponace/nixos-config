# nixos-config

NixOS configuration repo (flakes + Home Manager).

## Fresh Install

After installing NixOS and rebooting into the new system:

1) In a nix-shell with `git`:

2) Clone this repo
```bash
git clone https://github.com/saponace/nixos-config.git
cd nixos-config/
` ``

3) Optional - Copy the generated hardware config if it is the first install on this host
```bash
sudo cp /etc/nixos/hardware-configuration.nix hosts/[HOST]/hardware.nix
git add hosts/[HOST]/hardware.nix
```

4) Build
```bash
sudo nixos-rebuild switch --flake .#[HOST]
```

## Day-to-day

### Rebuild NixOS config and activate
```bash
nh os switch
```

### Update flake inputs
```bash
nix flake update
```

## VM notes

### libvirt (virt-install)

```bash
ISO="/var/lib/libvirt/images/nixos-graphical-25.11.9840.a4bf06618f0b-x86_64-linux.iso"

virt-install \
  --connect qemu:///system \
  --name nixos-test \
  --memory 4096 --vcpus 4 \
  --cpu host-passthrough \
  --disk path=/var/lib/libvirt/images/nixos-test.qcow2,size=40,bus=virtio,format=qcow2 \
  --cdrom "$ISO" \
  --os-variant nixos-unstable \
  --network network=default,model=virtio \
  --graphics spice \
  --video virtio \
  --boot uefi,bootmenu.enable=yes,loader=/usr/share/edk2/x64/OVMF_CODE.4m.fd,loader.readonly=yes,loader.type=pflash,loader.secure=no,nvram.template=/usr/share/edk2/x64/OVMF_VARS.4m.fd,firmware.feature0.name=secure-boot,firmware.feature0.enabled=no
```

Then run in the VM
```bash
echo 'nameserver 1.1.1.1' | sudo tee /etc/resolv.conf
```
