#!/bin/bash

set -euo pipefail
engine="$(modelctl status --wait-for-components --format=json | jq -r .engine)"
exec modelctl run --share-provider -- "$SNAP/engines/$engine/server" "$@"
