#!/bin/bash

LIBRARY_ROOT="$(dirname $(readlink -f "${0}"))/.."
OPUS_ROOT="${LIBRARY_ROOT}/deps/opus.git"
OPUSFILE_ROOT="${LIBRARY_ROOT}/deps/opusfile.git"
OGG_ROOT="${LIBRARY_ROOT}/deps/ogg.git"

function show_env {
	echo "OGG          : ${OGG_ROOT}"
	echo "OPUS         : ${OPUS_ROOT}"
	echo "OPUSFILE     : ${OPUSFILE_ROOT}"
	echo "LIBRARY_ROOT : ${LIBRARY_ROOT}"
	echo
}

show_env

# copy the source files to platformio layout

# ogg
from="${OGG_ROOT}/src"
to="${LIBRARY_ROOT}/src"
for I in `find "${from}" -type f -name "*.[ch]"`
do
	mkdir -p "$(dirname ${I/${from}/${to}})"
	cp "${I}" "${I/${from}/${to}}"
done

from="${OGG_ROOT}/include"
to="${LIBRARY_ROOT}/src"
for I in `find "${from}" -type f -name "*.[ch]"`
do
	mkdir -p "$(dirname ${I/${from}/${to}})"
	cp "${I}" "${I/${from}/${to}}"
done

# opusfile
from="${OPUSFILE_ROOT}/src"
to="${LIBRARY_ROOT}/src"
for I in `find "${from}" -type f -name "*.[ch]"`
do
	mkdir -p "$(dirname ${I/${from}/${to}})"
	cp "${I}" "${I/${from}/${to}}"
done

from="${OPUSFILE_ROOT}/include"
to="${LIBRARY_ROOT}/src"
for I in `find "${from}" -type f -name "*.[ch]"`
do
	mkdir -p "$(dirname ${I/${from}/${to}})"
	cp "${I}" "${I/${from}/${to}}"
done

# opus
from="${OPUS_ROOT}/celt"
to="${LIBRARY_ROOT}/src/celt"
for I in `find "${from}" -type f -name "*.[ch]"`
do
	mkdir -p "$(dirname ${I/${from}/${to}})"
	cp "${I}" "${I/${from}/${to}}"
done

from="${OPUS_ROOT}/silk"
to="${LIBRARY_ROOT}/src/silk"
for I in `find "${from}" -type f -name "*.[ch]"`
do
	mkdir -p "$(dirname ${I/${from}/${to}})"
	cp "${I}" "${I/${from}/${to}}"
done

from="${OPUS_ROOT}/src"
to="${LIBRARY_ROOT}/src"
for I in `find "${from}" -type f -name "*.[ch]"`
do
	mkdir -p "$(dirname ${I/${from}/${to}})"
	cp "${I}" "${I/${from}/${to}}"
done

from="${OPUS_ROOT}/include"
to="${LIBRARY_ROOT}/src"
for I in `find "${from}" -type f -name "*.[ch]"`
do
	mkdir -p "$(dirname ${I/${from}/${to}})"
	cp "${I}" "${I/${from}/${to}}"
done

# clean-up
rm -rf \
	"${LIBRARY_ROOT}/src/celt/arm" \
	"${LIBRARY_ROOT}/src/celt/dump_modes" \
	"${LIBRARY_ROOT}/src/celt/mips" \
	"${LIBRARY_ROOT}/src/celt/tests" \
	"${LIBRARY_ROOT}/src/celt/x86" \
	"${LIBRARY_ROOT}/src/celt/opus_custom_demo.c" \
	"${LIBRARY_ROOT}/src/silk/arm" \
	"${LIBRARY_ROOT}/src/silk/mips" \
	"${LIBRARY_ROOT}/src/silk/x86" \
	"${LIBRARY_ROOT}/src/silk/fixed/mips" \
	"${LIBRARY_ROOT}/src/silk/fixed/x86" \
	"${LIBRARY_ROOT}/src/silk/float" \
	"${LIBRARY_ROOT}/src/opus_compare.c" \
	"${LIBRARY_ROOT}/src/opus_demo.c" \
	"${LIBRARY_ROOT}/src/repacketizer_demo.c" \
	"${LIBRARY_ROOT}/src/mlp_train.c" \
	"${LIBRARY_ROOT}/src/mlp_train.h" \
	"${LIBRARY_ROOT}/src/mlp_data.c" \
	"${LIBRARY_ROOT}/src/wincerts.c" \
	"${LIBRARY_ROOT}/src/winerrno.h"
