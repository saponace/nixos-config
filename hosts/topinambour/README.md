## Raspberry-pi 5 installation

### 1. Build the SD image

Run from an x86 NixOS machine with aarch64 binfmt:

```sh
nix build .#nixosConfigurations.topinambour.config.system.build.diskoImages --accept-flake-config
```

### 2. Flash and seed the password

SD card in a USB reader (`lsblk` to find `/dev/sdX`):

```sh
sudo dd if=result/main.raw of=/dev/sdX bs=4M status=progress conv=fsync
sudo mount -o subvol=/persistent /dev/sdX2 /mnt
mkpasswd -m sha-512 | sudo tee /mnt/password >/dev/null
sudo umount /mnt
```

### 3. Boot

Insert the SD in the Pi, power on. Partition and filesystem grow to the full card.

```sh
ssh topinambour
```

### 4. Generate secrets (first install only)

This is only needed once. After the first boot:

```sh
echo "HOMARR_SECRET_ENCRYPTION_KEY=$(tr -dc 'a-f0-9' < /dev/urandom | head -c 64)" > /mnt/wd/stak-config/secrets.env
echo "SONARR_API_KEY=<sonarr api key>" >> /mnt/wd/stak-config/secrets.env
echo "RADARR_API_KEY=<radarr api key>" >> /mnt/wd/stak-config/secrets.env
```

Find the API keys in each app under Settings → General → Security → API Key.

### Rescue

Flash `.#packages.aarch64-linux.installer` to a fast USB drive (cheap pendrives have
abysmal random-write speed, nix evals take hours), boot the Pi from it:

```sh
nix run 'github:saponace/nixos-config#bootstrap' topinambour   # wipe + reinstall
nix run 'github:saponace/nixos-config#refresh' topinambour     # reinstall, keep /persistent
```
