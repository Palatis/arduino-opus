#!/bin/bash

SCRIPT_ROOT=$(dirname $(readlink -f "${0}"))/

${SCRIPT_ROOT}/prepare.sh \
	--chost "xtensa-lx106-elf" \
	--cflags "-std=gnu99 -Wpointer-arith -Wno-implicit-function-declaration -Wl,-EL -fno-inline-functions -nostdlib -Os -mlongcalls -mtext-section-literals -falign-functions=4 -ffunction-sections -fdata-sections -D__ets__ -DICACHE_FLASH -DESP8266 -DARDUINO_ARCH_ESP8266 -DARDUINO_ESP8266_NODEMCU -U__STRICT_ANSI__ ${CFLAGS}" \
	--cxxflags "-std=c++11 -Wpointer-arith -Wno-implicit-function-declaration -Wl,-EL -fno-inline-functions -nostdlib -Os -mlongcalls -mtext-section-literals -falign-functions=4 -ffunction-sections -fdata-sections -D__ets__ -DICACHE_FLASH -DESP8266 -DARDUINO_ARCH_ESP8266 -DARDUINO_ESP8266_NODEMCU -U__STRICT_ANSI__ ${CXXFLAGS}" \
	${@}
