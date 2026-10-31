#!/usr/bin/env bash
# Sole user entry for report HTML preview. Implementation: preview/serve.sh.
# Usage: ./serve.sh
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
exec "$ROOT/preview/serve.sh" "$@"
