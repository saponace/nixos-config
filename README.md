# nixos-config

## Fresh install on a new drive
From the installer ISO (partitions the disk, installs NixOS, and seeds `/persistent`; see `scripts/bootstrap.sh`):
```bash
nix run --extra-experimental-features "nix-command flakes" github:saponace/nixos-config#bootstrap -- [HOST]
```

## Install with existing /persistent
```bash
sudo nixos-install --no-root-passwd --flake github:saponace/nixos-config#[HOST]
```

## Personalizing
Identity lives in `flake.nix` which defines `username` and `userEmail`.

## Development
- Install git hooks (once per clone): `nix develop`

## Day-to-day
- Rebuild NixOS config and activate: `nh os switch`
- Update flake inputs: `nix flake update`
