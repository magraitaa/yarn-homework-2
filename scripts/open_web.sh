#!/usr/bin/env bash
set -euo pipefail

# Run on the user's computer. The first argument is their existing SSH key.
if [ "$#" -ne 1 ] || [ ! -r "$1" ]; then
  echo "Usage: bash $0 /path/to/private_key" >&2
  exit 1
fi

echo 'Keep this terminal open. Web addresses are listed in README.md.'
exec ssh -N -o IdentitiesOnly=yes -o ExitOnForwardFailure=yes \
  -o ConnectTimeout=10 -i "$1" \
  -L 127.0.0.1:8088:team-12-nn:8088 \
  -L 127.0.0.1:9870:team-12-nn:9870 \
  -L 127.0.0.1:9868:team-12-nn:9868 \
  -L 127.0.0.1:19864:team-12-en:9864 \
  -L 127.0.0.1:29864:team-12-00:9864 \
  -L 127.0.0.1:39864:team-12-01:9864 \
  -L 127.0.0.1:18042:team-12-en:8042 \
  -L 127.0.0.1:28042:team-12-00:8042 \
  -L 127.0.0.1:38042:team-12-01:8042 \
  team@171.22.72.54
