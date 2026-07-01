set -euo pipefail

usage() {
  echo "usage: bootstrap <host>" >&2
  echo "  host  one of the nixosConfigurations (e.g. celeri, rutabaga)" >&2
  exit 1
}

[ "$#" -ge 1 ] || usage
host="$1"
slug="saponace/nixos-config"
# TODO: testing — drop the branch suffix once merged to master.
flake="github:${slug}/preservation-topinambour"

echo "==> Current block devices:"
lsblk

echo
echo "Disko will DESTROY, format and mount the device declared in"
echo "  hosts/${host}/disko.nix"
read -rp "Continue installing '${host}'? [y/N] " reply
case "$reply" in
  [yY]*) ;;
  *) echo "Aborted." >&2; exit 1 ;;
esac

echo "==> Wiping stale filesystem signatures before partitioning"
disk_dev=$(nix --extra-experimental-features 'nix-command flakes' eval --raw "${flake}#nixosConfigurations.${host}.config.disko.devices.disk.main.device")
sudo wipefs -af "${disk_dev}"

echo "==> Partitioning, formatting and mounting"
sudo disko --mode destroy,format,mount --flake "${flake}#${host}"

echo "==> Seeding the login password (hashed, stored on the persistent volume)"
mkpasswd -m sha-512 | sudo tee /mnt/persistent/password >/dev/null

echo "==> Seeding NetworkManager connections from the live environment"
nm_dir="etc/NetworkManager/system-connections"
sudo mkdir -p "/mnt/persistent/${nm_dir}"
sudo cp -a "/${nm_dir}"/. "/mnt/persistent/${nm_dir}/"

echo "==> Installing NixOS"
sudo nixos-install --no-root-passwd --flake "${flake}#${host}"

echo "==> Cloning config into ~/repos"
repos_dir="/mnt/persistent/home/${user_name}/repos"  # user_name is injected from flake.nix
sudo mkdir -p "$repos_dir"
sudo git clone "https://github.com/${slug}.git" "${repos_dir}/nixos-config"

# chown by name from inside the installed system, where the user/group resolve.
sudo nixos-enter --root /mnt -c "chown -R ${user_name}:users /persistent/home/${user_name}"

read -rp "Bootstraping complete. Reboot into '${host}' ? [y/N] " reply
case "$reply" in
  [yY]*) sudo reboot ;;
  *) echo "Skipping reboot. Run 'sudo reboot' when ready." ;;
esac
