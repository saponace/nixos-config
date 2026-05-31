## Raspberry-pi installation

### 1. Build the SD card image

Run on celeri (or any x86 machine). Requires aarch64 binaries — either from the nixos-raspberrypi cachix cache (configured in `modules/base/nix.nix`) or aarch64 emulation via binfmt.

```sh
nix build .#nixosConfigurations.topinambour.config.system.build.sdImage --accept-flake-config
```

The image will be at `result/sd-image/*.img.zst`.

### 2. Flash the SD card

```sh
# decompress and flash in one step
zstdcat result/sd-image/*.img.zst | sudo dd of=/dev/sdX bs=4M status=progress conv=fsync
```

Replace `/dev/sdX` with your SD card device (`lsblk` to find it).

### 3. First boot

Insert the SD card into the Pi and power it on. SSH will be available once it boots:

```sh
ssh saponace@topinambour
```

Change the password:
```sh
passwd
```

### 4. Clone the repo and run the first switch

```sh
nix-shell -p git
git clone https://github.com/saponace/nixos-config.git
```

### 5. Generate secrets (first install only)

Create `/etc/mediastack/secrets.env` with service secrets that are not versioned in the repo.
This file persists across `nh os switch` rebuilds — only needed once.

```sh
echo "HOMARR_SECRET_ENCRYPTION_KEY=$(tr -dc 'a-f0-9' < /dev/urandom | head -c 64)" | tee /mnt/wd/mediastack-config/secrets.env
```
