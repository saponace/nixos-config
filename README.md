# nixos-config

NixOS configuration repo (flakes + Home Manager).

## Day-to-day

```bash
# Rebuild and make the new generation the default boot entry
sudo nixos-rebuild switch --flake .#<host>

# Rebuild but do not make the new generation the default boot entry
sudo nixos-rebuild test --flake .#<host>

# Update flake inputs
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
