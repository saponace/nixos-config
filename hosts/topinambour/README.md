## Raspberry-pi 5 installation

### Build image, flash and seed the password

Run from an x86 NixOS machine with aarch64 binfmt, SD card in a USB reader:

```sh
nix run .#flash topinambour
```

### Generate secrets on WD (first install only)

This is only needed once. After the first boot:

```sh
echo "HOMARR_SECRET_ENCRYPTION_KEY=$(tr -dc 'a-f0-9' < /dev/urandom | head -c 64)" > /mnt/wd/stak-config/secrets.env
echo "SONARR_API_KEY=<sonarr api key>" >> /mnt/wd/stak-config/secrets.env
echo "RADARR_API_KEY=<radarr api key>" >> /mnt/wd/stak-config/secrets.env
```

Find the API keys in each app under Settings → General → Security → API Key.

### Reinstall onto an existing disk (keep /persistent)
Rebuilds the system without reformatting (`/persistent' pre-populated).
```bash
nix run 'github:saponace/nixos-config#refresh' topinambour     # reinstall, keep /persistent
```

### Backup the stak config

Zips `/mnt/wd/stak-config`.

```sh
stak-backup
```
