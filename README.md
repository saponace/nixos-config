# nixos-config

NixOS configuration repo (flakes + Home Manager).

## Fresh Install

Boot from the NixOS graphical ISO, close the installer, and open a terminal.

1. Verify the target disk name:
```bash
lsblk
```

2. Update `hosts/[HOST]/disko.nix` if the disk device or swap size differs from the defaults, then run:
```bash
nix run github:nix-community/disko/latest#disko-install -- \
  --flake github:saponace/nixos-config#[HOST] \
  --disk main /dev/[DISK]
```

This formats the disk and installs NixOS in one step. Reboot when done.

> **Note:** The `--disk main /dev/[DISK]` argument overrides the device in `disko.nix` at install time. Swap size is hardcoded per host.

## Development

### Install git hooks (once per clone)
```bash
nix develop
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
