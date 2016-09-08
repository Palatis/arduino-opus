#!/bin/bash

export CFLAGS="-std=gnu99 -Wpointer-arith -Wno-implicit-function-declaration -Wl,-EL -fno-inline-functions -nostdlib -Os -mlongcalls -mtext-section-literals -falign-functions=4 -ffunction-sections -fdata-sections -D__ets__ -DICACHE_FLASH -DESP8266 -DARDUINO_ARCH_ESP8266 -DARDUINO_ESP8266_NODEMCU -U__STRICT_ANSI__"
export CXXFLAGS="-std=c++11 -Wpointer-arith -Wno-implicit-function-declaration -Wl,-EL -fno-inline-functions -nostdlib -Os -mlongcalls -mtext-section-literals -falign-functions=4 -ffunction-sections -fdata-sections -D__ets__ -DICACHE_FLASH -DESP8266 -DARDUINO_ARCH_ESP8266 -DARDUINO_ESP8266_NODEMCU -U__STRICT_ANSI__"

./configure --host=xtensa-lx106-elf --disable-doc --enable-fixed-point --disable-float-api --disable-shared --enable-static --disable-extra-programs --prefix=/ --with-gnu-ld --disable-maintainer-mode

echo "================="
echo "run \`make DESTDIR=/path/to/esp8266-arduino-opus install' after \`make'."
echo "================="
