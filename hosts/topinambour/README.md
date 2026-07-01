## Raspberry-pi 5 bootstraping

### 1. Build the installer image

Run on x86 (needs aarch64 binaries from the nixos-raspberrypi cachix cache or binfmt emulation):

```sh
nix build .#packages.aarch64-linux.installer --accept-flake-config
```

Image: `result/sd-image/*.img.zst`.

### 2. Flash to a USB drive

```sh
zstdcat result/sd-image/*.img.zst | sudo dd of=/dev/sdX bs=4M status=progress conv=fsync
```

`/dev/sdX` = the USB drive (`lsblk`).

### 3. Boot from USB and run bootstrap

Insert the live USB and the target SD, attach monitor + keyboard. Boot from USB.

TODO: remove branch postfix
```sh
nix run github:saponace/nixos-config/preservation-topinambour#bootstrap topinambour
```

### 4. Generate secrets (first install only)

This is only needed once. After the first boot:

```sh
echo "HOMARR_SECRET_ENCRYPTION_KEY=$(tr -dc 'a-f0-9' < /dev/urandom | head -c 64)" > /mnt/wd/stak-config/secrets.env
echo "SONARR_API_KEY=<sonarr api key>" >> /mnt/wd/stak-config/secrets.env
echo "RADARR_API_KEY=<radarr api key>" >> /mnt/wd/stak-config/secrets.env
```

Find the API keys in each app under Settings → General → Security → API Key.
