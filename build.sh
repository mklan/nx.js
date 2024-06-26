#!/bin/bash
set -euo pipefail

APP="${1-hello-world}"

# Build JS runtime
pnpm bundle
mkdir -p romfs
cp -v ./packages/runtime/runtime.* ./romfs/

# Build packages and example app
pnpm build --filter "$APP"

# Build nx.js `.nro`
rm -f nxjs.nro
make

# Package app `.nro`
pnpm nro --filter "$APP"

if [ "$UPLOAD" -eq 1 ]; then
	curl --netrc "ftp://192.168.86.115:5000/switch/${APP}.nro" --upload-file "apps/${APP}/${APP}.nro"
fi
