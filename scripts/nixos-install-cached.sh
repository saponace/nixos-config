set -euo pipefail

# nixos-install <flake>#<host> that downloads prebuilt packages from the host's binary
# caches (e.g. omp from cache.numtide.com) instead of compiling them.
# Only the first install needs this: the caches are declared in nix.settings, but
# nix.conf only picks them up once the system is installed, too late for this build.
# From then on, every rebuild of the installed system downloads from them on its own.

flake="$1"
host="$2"
settings="${flake}#nixosConfigurations.${host}.config.nix.settings"

substituters=$(nix --extra-experimental-features 'nix-command flakes' eval --raw "${settings}.extra-substituters" --apply toString)
trusted_keys=$(nix --extra-experimental-features 'nix-command flakes' eval --raw "${settings}.extra-trusted-public-keys" --apply toString)

sudo nixos-install --no-root-passwd --flake "${flake}#${host}" \
  --option extra-substituters "$substituters" \
  --option extra-trusted-public-keys "$trusted_keys"
