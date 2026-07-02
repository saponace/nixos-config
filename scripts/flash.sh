set -euo pipefail

usage() {
  echo "usage: flash <host>" >&2
  echo "  Wipes a removable disk and installs <host> onto it." >&2
  echo "  Run from the repo root on another machine (disk in a USB reader)." >&2
  exit 1
}

[ "$#" -ge 1 ] || usage
host="$1"

echo "==> Current block devices:"
lsblk

echo
read -rp "Target device to WIPE and install '${host}' onto: " disk
[ -b "$disk" ] || { echo "Not a block device: ${disk}" >&2; exit 1; }

read -rp "${disk} will be wiped. Continue? [y/N] " reply
case "$reply" in
  [yY]*) ;;
  *) echo "Aborted." >&2; exit 1 ;;
esac

echo "==> Wiping stale filesystem signatures"
sudo wipefs -af "$disk"

echo "==> Partitioning, formatting and mounting at /mnt"
sudo disko --mode destroy,format,mount --argstr device "$disk" "hosts/${host}/disko.nix"

echo "==> Building the system"
toplevel=$(nix build --no-link --print-out-paths ".#nixosConfigurations.${host}.config.system.build.toplevel")

echo "==> Installing (closure copy + bootloader)"
sudo nixos-install --system "$toplevel" --root /mnt --no-root-passwd --no-channel-copy

echo "==> Seeding the login password into /persistent"
mkpasswd -m sha-512 | sudo tee /mnt/persistent/password >/dev/null

sudo umount -R /mnt

echo "Done. Insert the disk and boot."
