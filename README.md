# nixos-config

## Fresh Install On a new drive

One command from the installer ISO (partitions the disk, installs NixOS and seeds `/persistent`. See `scripts/install.sh`):

```bash
nix run --extra-experimental-features "nix-command flakes" github:saponace/nixos-config#install -- [HOST]
```

## Install with existing /persistent/
```bash
sudo nixos-install --no-root-passwd --flake github:saponace/nixos-config#[HOST]
```

## Personalizing
Identity lives in `flake.nix` which defines `usernamne` and `userEmail`

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
