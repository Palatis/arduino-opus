#!/bin/bash

: ${OPUS_GIT_REPO:="https://github.com/xiph/opus.git"}
: ${OPUS_GIT_OPTIONS:=""}
: ${OPUS_GIT_REF:="master"}
: ${OPUS_GIT_CHECKOUT:="true"}
: ${OPUS_CONFIGURE_EXTRA:=""}

LIBRARYROOT=$(dirname $(readlink -f "${0}"))/../

function error {
	echo ${1}
	exit 1
}

function show_help {
	echo ${0}
	echo "build script for opus on \`xtensa-lx106-elf'"
	echo "modify environment variables to tweak the behaviors."
	echo
	show_env
}

function show_env {
	echo "OPUS_GIT_REPO       : ${OPUS_GIT_REPO}"
	echo "OPUS_GIT_OPTIONS    : ${OPUS_GIT_OPTIONS}"
	echo "OPUS_GIT_REF        : ${OPUS_GIT_REF}"
	echo "OPUS_GIT_CHECKOUT   : ${OPUS_GIT_CHECKOUT}"
	echo "OPUS_CONFIGURE_EXTRA: ${OPUS_CONFIGURE_EXTRA}"
	echo "LIBRARYROOT         : ${LIBRARYROOT}"
	echo
}

while [[ $# -gt 0 ]]
do
	case ${1} in
	--help*)
		show_help
		exit
		;;
	*) # unknown option
		;;
	esac
done

show_env

# clone and checkout the git repository
if [ "${OPUS_GIT_CHECKOUT}" == "true" ]
then
	if [ ! -d "${LIBRARYROOT}/deps/opus.git" ]
	then
		mkdir -p "${LIBRARYROOT}/deps"
		git clone ${OPUS_GIT_OPTIONS} "${OPUS_GIT_REPO}" "${LIBRARYROOT}/deps/opus.git" || \
			error "git clone \"${OPUS_GIT_REPO}\" into \"${LIBRARYROOT}/opus.git\" failed."
	fi
	cd "${LIBRARYROOT}/deps/opus.git"
	git pull || error "git pull failed"
	git checkout ${OPUS_GIT_REF} || error "git checkout ${OPUS_GIT_REF} failed"
fi

if [ ! -x ${LIBRARYROOT}/deps/opus.git/configure ]
then
	cd "${LIBRARYROOT}/deps/opus.git"
	./autogen.sh
fi

mkdir -p "${LIBRARYROOT}/deps/opus.git/build/xtensa-lx106-elf"
cd "${LIBRARYROOT}/deps/opus.git/build/xtensa-lx106-elf"

# stolen CFLAGS and CXXFLAGS from platformio...
export CFLAGS="-std=gnu99 -Wpointer-arith -Wno-implicit-function-declaration -Wl,-EL -fno-inline-functions -nostdlib -Os -mlongcalls -mtext-section-literals -falign-functions=4 -ffunction-sections -fdata-sections -D__ets__ -DICACHE_FLASH -DESP8266 -DARDUINO_ARCH_ESP8266 -DARDUINO_ESP8266_NODEMCU -U__STRICT_ANSI__ ${CFLAGS}"
export CXXFLAGS="-std=c++11 -Wpointer-arith -Wno-implicit-function-declaration -Wl,-EL -fno-inline-functions -nostdlib -Os -mlongcalls -mtext-section-literals -falign-functions=4 -ffunction-sections -fdata-sections -D__ets__ -DICACHE_FLASH -DESP8266 -DARDUINO_ARCH_ESP8266 -DARDUINO_ESP8266_NODEMCU -U__STRICT_ANSI__ ${CXXFLAGS}"

# do the configure
${LIBRARYROOT}/deps/opus.git/configure \
	--host=xtensa-lx106-elf \
	--disable-doc \
	--enable-fixed-point \
	--disable-float-api \
	--disable-shared \
	--enable-static \
	--disable-extra-programs \
	--prefix=/ \
	--with-gnu-ld \
	--disable-maintainer-mode \
	${OPUS_CONFIGURE_EXTRA}

make -j"$(nproc)" || error "make -j$(nproc) failed"
make DESTDIR="${LIBRARYROOT}" install
