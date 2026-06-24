set -euo pipefail

usage() {
  echo "usage: install <host> [flake-ref]" >&2
  echo "  host       one of the nixosConfigurations (e.g. celeri, rutabaga)" >&2
  echo "  flake-ref  defaults to github:saponace/nixos-config" >&2
  exit 1
}

[ "$#" -ge 1 ] || usage
host="$1"
flake="${2:-github:saponace/nixos-config}"

echo "==> Current block devices:"
lsblk

echo
echo "Disko will DESTROY, format and mount the device declared in"
echo "  hosts/${host}/disko.nix"
read -rp "Continue installing '${host}'? [y/N] " reply
case "$reply" in
  [yY] | [yY][eE][sS]) ;;
  *)
    echo "Aborted." >&2
    exit 1
    ;;
esac

echo "==> Partitioning, formatting and mounting (disko)"
sudo disko --mode destroy,format,mount --flake "${flake}#${host}"

echo "==> Seeding the login password (hashed, stored on the persistent volume)"
mkpasswd -m sha-512 | sudo tee /mnt/persistent/password >/dev/null

echo "==> Installing NixOS"
sudo nixos-install --flake "${flake}#${host}"

echo "==> Done. Reboot into '${host}'."
