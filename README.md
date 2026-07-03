# nixos-config

## Fresh install on a new drive
From the installer ISO (partitions the disk, installs NixOS, and seeds `/persistent`; see `scripts/bootstrap.sh`):
```bash
nix run --extra-experimental-features "nix-command flakes" github:saponace/nixos-config#bootstrap -- [HOST]
```

## Reinstall onto an existing disk (keep /persistent)
Rebuilds the system without reformatting (`/persistent' pre-populated). Mounts the existing layout from `hosts/[HOST]/disko.nix` then installs.
```bash
nix run --extra-experimental-features "nix-command flakes" github:saponace/nixos-config#refresh -- [HOST]
```

## Personalizing
Identity lives in `flake.nix` which defines `username` and `userEmail`.

## Development
- Install git hooks (once per clone): `nix develop`

## Day-to-day
- Rebuild NixOS config and activate: `nh os switch`
- Update flake inputs: `nix flake update`
