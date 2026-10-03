#!/usr/bin/env bash

set -euo pipefail

if [ $# -ne 1 ]; then
	echo "usage: $0 <frida-root>"
	exit 1
fi

FRIDA_ROOT=$(cd "$1" && pwd)
PATCHES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/patches" && pwd)

for path in "$PATCHES_DIR"/*; do
	name=$(basename "$path")
	sub="$FRIDA_ROOT/subprojects/$name"
	echo "Applying patches to subprojects/$name"
	if ! git -C "$sub" am "$path"/*.patch; then
		git -C "$sub" am --abort
		echo "error: patches for '$name' do not apply; aborted, tree left clean"
		exit 1
	fi
done
