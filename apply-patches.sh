#!/usr/bin/env bash

set -euo pipefail

if [ $# -ne 1 ]; then
	echo "usage: $0 <frida-root>" >&2
	exit 1
fi

FRIDA_ROOT=$(cd "$1" && pwd)
PATCHES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/patches" && pwd)

for path in "$PATCHES_DIR"/*; do
	name=$(basename "$path")
	echo "Applying patches to subprojects/$name"
	git -C "$FRIDA_ROOT/subprojects/$name" am "$path"/*.patch
done
