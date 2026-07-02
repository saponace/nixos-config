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

echo "==> Formatting and installing"
sudo disko-install --flake ".#${host}" --mode format --disk main "$disk"

echo "==> Seeding the login password into /persistent"
mnt=$(mktemp -d)
sudo mount -o subvol=/persistent /dev/disk/by-partlabel/disk-main-root "$mnt"
mkpasswd -m sha-512 | sudo tee "${mnt}/password" >/dev/null
sudo umount "$mnt"
rmdir "$mnt"

echo "Done. Insert the disk and boot."
