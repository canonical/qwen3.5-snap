#!/bin/bash

set -euo pipefail
engine="$(modelctl status --wait-for-components --format=json | jq -r .engine)"
exec modelctl run --share-provider --fallback-server -- "$SNAP/engines/$engine/server" "$@"
