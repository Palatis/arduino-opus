#!/bin/bash

mkdir -p build
tar c \
	lib/*.a \
	lib/*.la \
	include/ \
	src/ \
	library.json \
	library.properties \
	keywords.txt \
	README.md \
	LICENSE \
| xz -9 -e > "build/esp8266-arduino-opus-$(git describe --always --long --tags).tar.xz"
