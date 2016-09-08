#!/bin/bash

: ${OPUS_GIT_REPO:="https://github.com/xiph/opus.git"}
: ${OPUS_GIT_OPTIONS:=""}
: ${OPUS_GIT_REF:="master"}
: ${OPUS_GIT_CHECKOUT:="true"}
: ${OPUS_CONFIGURE_EXTRA:=""}

: ${OPUSFILE_GIT_REPO:="https://github.com/xiph/opusfile.git"}
: ${OPUSFILE_GIT_OPTIONS:=""}
: ${OPUSFILE_GIT_REF:="master"}
: ${OPUSFILE_GIT_CHECKOUT:="true"}
: ${OPUSFILE_CONFIGURE_EXTRA:=""}

LIBRARY_ROOT=$(dirname $(readlink -f "${0}"))/../
OPUS_ROOT="${LIBRARY_ROOT}/deps/opus.git"
OPUSFILE_ROOT="${LIBRARY_ROOT}/deps/opusfile.git"

function die {
	echo "*** ${1} ***"
	exit 1
}

function show_help {
	echo "${0} --host <chost> [--cflags <flags>] [--cxxflags <flags>]"
	echo "modify environment variables to tweak the behaviors."
	echo
	show_env
}

function show_env {
	echo "opus:"
	echo "  OPUS_GIT_REPO           : ${OPUS_GIT_REPO}"
	echo "  OPUS_GIT_OPTIONS        : ${OPUS_GIT_OPTIONS}"
	echo "  OPUS_GIT_REF            : ${OPUS_GIT_REF}"
	echo "  OPUS_GIT_CHECKOUT       : ${OPUS_GIT_CHECKOUT}"
	echo "  OPUS_CONFIGURE_EXTRA    : ${OPUS_CONFIGURE_EXTRA}"
	echo "opusfile:"
	echo "  OPUSFILE_GIT_REPO       : ${OPUSFILE_GIT_REPO}"
	echo "  OPUSFILE_GIT_OPTIONS    : ${OPUSFILE_GIT_OPTIONS}"
	echo "  OPUSFILE_GIT_REF        : ${OPUSFILE_GIT_REF}"
	echo "  OPUSFILE_GIT_CHECKOUT   : ${OPUSFILE_GIT_CHECKOUT}"
	echo "  OPUSFILE_CONFIGURE_EXTRA: ${OPUSFILE_CONFIGURE_EXTRA}"
	echo "misc:"
	echo "  LIBRARY_ROOT            : ${LIBRARY_ROOT}"
	echo "  CHOST                   : ${CHOST}"
	echo "  CFLAGS                  : ${CFLAGS}"
	echo "  CXXFLAGS                : ${CXXFLAGS}"
	echo
}

while [[ $# -gt 0 ]]
do
	case ${1} in
	--host*|--chost*)
		CHOST="${2}"
		shift 2
		;;
	--cflags*)
		CFLAGS="${2}"
		shift 2
		;;
	--cxxflags*)
		CXXFLAGS="${2}"
		shift 2
		;;
	--help*)
		show_help
		exit 0
		;;
	*) # unknown option
		shift
		;;
	esac
done

show_env

if [ -e $CHOST ]
then
	show_help
	exit 1
fi

mkdir -p "${LIBRARY_ROOT}/deps"

# clone and checkout opus from git
if [ "${OPUS_GIT_CHECKOUT}" == "true" ]
then
	if [ ! -d "${OPUS_ROOT}" ]
	then
		git clone ${OPUS_GIT_OPTIONS} "${OPUS_GIT_REPO}" "${OPUS_ROOT}" || \
			die "git clone \"${OPUS_GIT_REPO}\" into \"${OPUS_ROOT}\" failed."
	fi
	cd "${OPUS_ROOT}"
	git pull || die "git pull failed"
	git checkout ${OPUS_GIT_REF} || die "git checkout ${OPUS_GIT_REF} failed"
fi

if [ ! -x ${OPUS_ROOT}/configure ]
then
	cd "${OPUS_ROOT}"
	./autogen.sh
fi

# clone and checkout opusfile from git
if [ "${OPUSFILE_GIT_CHECKOUT}" == "true" ]
then
	if [ ! -d "${OPUSFILE_ROOT}" ]
	then
		git clone ${OPUSFILE_GIT_OPTIONS} "${OPUSFILE_GIT_REPO}" "${OPUSFILE_ROOT}" || \
			die "git clone \"${OPUSFILE_GIT_REPO}\" into \"${OPUSFILE_ROOT}\" failed."
	fi
	cd "${OPUSFILE_ROOT}"
	git pull || die "git pull failed"
	git checkout ${OPUSFILE_GIT_REF} || die "git checkout ${OPUSFILE_GIT_REF} failed"
fi

if [ ! -x ${OPUSFILE_ROOT}/configure ]
then
	cd "${OPUSFILE_ROOT}"
	./autogen.sh
fi

export CFLAGS
export CXXFLAGS

# build and install opus
mkdir -p "${OPUS_ROOT}/build/${CHOST}"
cd "${OPUS_ROOT}/build/${CHOST}"
${OPUS_ROOT}/configure \
	--host=${CHOST} \
	--disable-doc \
	--enable-fixed-point \
	--disable-float-api \
	--disable-shared \
	--enable-static \
	--disable-extra-programs \
	--prefix=/ \
	--with-gnu-ld \
	--disable-maintainer-mode \
	${OPUS_CONFIGURE_EXTRA} \
	|| die "opus configure failed"

make -j"$(nproc)" || die "making opus failed"
make DESTDIR="${LIBRARY_ROOT}" install || die "installing opus failed"

# build and install opusfile
mkdir -p "${OPUSFILE_ROOT}/build/${CHOST}"
cd "${OPUSFILE_ROOT}/build/${CHOST}"

# opusfile needs CPPFLAGS to include <ogg/ogg.h>
# it's only used for compiling and not linking, so we don't need any -L or -l.
CPPFLAGS="-I/usr/include" \
${OPUSFILE_ROOT}/configure \
	--host=${CHOST} \
	--prefix=/ \
	--disable-largefile \
	--disable-maintainer-mode \
	--disable-http \
	--enable-fixed-point \
	--disable-float \
	--disable-examples \
	--disable-doc \
	--with-gnu-ld \
	${OPUS_CONFIGURE_EXTRA} \
	|| die "opusfile configure failed"

make -j"$(nproc)" || die "making opusfile failed"
make DESTDIR="${LIBRARY_ROOT}" install || die "installing opusfile failed"
