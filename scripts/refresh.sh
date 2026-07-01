set -euo pipefail

usage() {
  echo "usage: refresh <host>"
  echo
  echo "Reinstalls onto an already-partitioned disk WITHOUT reformatting (/persistent pre-populated)"
  exit 1
}

[ "$#" -ge 1 ] || usage
host="$1"
slug="saponace/nixos-config"
# TODO: testing — drop the branch suffix once merged to master.
flake="github:${slug}/preservation-topinambour"

echo
echo "Disko will mount the device declared in hosts/${host}/disko.nix"
echo "Existing /nix and /persistent are preserved."
read -rp "Continue refreshing '${host}'? [y/N] " reply
case "$reply" in
  [yY]*) ;;
  *) echo "Aborted." >&2; exit 1 ;;
esac

echo "==> Mounting existing filesystems (no format)"
sudo disko --mode mount --flake "${flake}#${host}"

echo "==> Installing NixOS"
sudo nixos-install --no-root-passwd --flake "${flake}#${host}"

read -rp "Refresh complete. Reboot into '${host}' ? [y/N] " reply
case "$reply" in
  [yY]*) sudo reboot ;;
  *) echo "Skipping reboot. Run 'sudo reboot' when ready." ;;
esac
