set -euo pipefail

usage() {
  echo "usage: flash <host>" >&2
  echo "  Builds the host's sd image, flashes it and seeds /persistent." >&2
  exit 1
}

[ "$#" -ge 1 ] || usage
host="$1"
slug="saponace/nixos-config"

echo "==> Building the image"
nix build ".#nixosConfigurations.${host}.config.system.build.diskoImages" --accept-flake-config

echo "==> Current block devices:"
lsblk

echo
read -rp "Target device to flash '${host}' onto: " disk
[ -b "$disk" ] || { echo "Not a block device: ${disk}" >&2; exit 1; }

read -rp "${disk} will be wiped. Continue? [y/N] " reply
case "$reply" in
  [yY]*) ;;
  *) echo "Aborted." >&2; exit 1 ;;
esac

echo "==> Flashing"
sudo dd if=result/main.raw of="$disk" bs=4M status=progress conv=fsync
sudo udevadm settle

echo "==> Growing the root partition to fill the disk"
# Scoped to $disk: the by-partlabel symlinks are ambiguous when this machine uses them too
root_part=$(lsblk -no PATH,PARTLABEL "$disk" | awk '$2 == "disk-main-root" { print $1 }')
[ -n "$root_part" ] || { echo "No disk-main-root partition on ${disk}" >&2; exit 1; }
part_num=$(cat "/sys/class/block/${root_part##*/}/partition") # layout differs per host
sudo sfdisk --relocate gpt-bak-std "$disk" # the image's GPT backup header sits at the image's end
sudo udevadm settle
echo ", +" | sudo sfdisk -N "$part_num" "$disk" # btrfs follows on first boot via x-systemd.growfs
sudo udevadm settle

echo "==> Seeding the login password (hashed, stored on the persistent volume)"
mnt=$(mktemp -d)
sudo mount -o subvol=/persistent "$root_part" "$mnt"
mkpasswd -m sha-512 | sudo tee "${mnt}/password" >/dev/null

echo "==> Cloning config into ~/repos"
repos_dir="${mnt}/home/${user_name}/repos" # user_name is injected from flake.nix
sudo git clone "https://github.com/${slug}.git" "${repos_dir}/nixos-config"
sudo chown -R 1000:100 "${mnt}/home/${user_name}"

sudo umount "$mnt"
rmdir "$mnt"

echo "Done. Insert the disk into '${host}' and boot."
