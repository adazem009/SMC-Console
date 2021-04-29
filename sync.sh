#!/bin/bash

cd "$(dirname $BASH_SOURCE)"
chmod +x build.sh
if [ -d compiler ]; then
	rm -rf compiler
fi
source CONFIG
git clone "$CONFIG_COMPILER_URL" "$CONFIG_COMPILER_PATH" || {
	echo Failed to sync the compiler
	exit 1
}
