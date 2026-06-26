## Raspberry-pi installation

topinambour is installed by flashing a throwaway installer image, then bootstrap it.

### 1. Build the installer image

Run on a x86 machine. Requires aarch64 binaries (from the
nixos-raspberrypi cachix cache or aarch64 emulation via binfmt).

```sh
nix build .#packages.aarch64-linux.installer --accept-flake-config
```

The image will be produced at `result/sd-image/*.img.zst`.

### 2. Flash the SD card

```sh
zstdcat result/sd-image/*.img.zst | sudo dd of=/dev/sdX bs=4M status=progress conv=fsync
```

Replace `/dev/sdX` with your SD card device (`lsblk` to find it).

### 3. Boot the installer and run bootstrap

Insert the card, attach a monitor + keyboard, and power on. The installer auto-logs in
on the console. With an internet connection, run:

```sh
nix run github:saponace/nixos-config/preservation#bootstrap topinambour
```

### 4. Generate secrets (first install only)

This is only needed once. After the first boot:

```sh
echo "HOMARR_SECRET_ENCRYPTION_KEY=$(tr -dc 'a-f0-9' < /dev/urandom | head -c 64)" > /mnt/wd/stak-config/secrets.env
echo "SONARR_API_KEY=<sonarr api key>" >> /mnt/wd/stak-config/secrets.env
echo "RADARR_API_KEY=<radarr api key>" >> /mnt/wd/stak-config/secrets.env
```

Find the API keys in each app under Settings → General → Security → API Key.
