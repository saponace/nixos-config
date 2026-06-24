set -euo pipefail

usage() {
  echo "usage: install <host>" >&2
  echo "  host  one of the nixosConfigurations (e.g. celeri, rutabaga)" >&2
  exit 1
}

[ "$#" -ge 1 ] || usage
host="$1"
slug="saponace/nixos-config"
# TODO: testing — drop "/preservation" once that branch is merged to master.
flake="github:${slug}/preservation"

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
sudo nixos-install --no-root-passwd --flake "${flake}#${host}"

# Clone this repo into ~/repos/.
echo "==> Cloning the config into ~/repos"
repos_dir="/mnt/persistent/home/${user_name}/repos"  # user_name is injected from flake.nix
sudo mkdir -p "$repos_dir"
sudo git clone "https://github.com/${slug}.git" "${repos_dir}/nixos-config"

# chown by name from inside the installed system, where the user/group resolve.
sudo nixos-enter --root /mnt -c "chown -R ${user_name}:users /persistent/home/${user_name}"

echo "==> Done. Reboot into '${host}'."
