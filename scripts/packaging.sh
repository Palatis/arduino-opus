#!/bin/bash

mkdir -p build
tar c \
	src/ \
	library.json \
	library.properties \
	keywords.txt \
	README.md \
	LICENSE \
| xz -9 -e > "build/arduino-opus-$(git describe --tags).tar.xz"
