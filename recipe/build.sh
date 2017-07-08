#!/bin/bash

export C_INCLUDE_PATH="${PREFIX}/include"
export LIBRARY_PATH="${PREFIX}/lib"

if [[ $(uname) == Darwin ]]; then
    export LDFLAGS="-Wl,-rpath,${PREFIX}/lib"
elif [[ $(uname) == Linux ]]; then
    export CFLAGS="-I${C_INCLUDE_PATH} "${CFLAGS}
    export LDFLAGS="-Wl,-rpath=${LIBRARY_PATH} -L${LIBRARY_PATH} "${LDFLAGS}
fi

# NO_GETTEXT disables internationalization (localized message translations)
# NO_INSTALL_HARDLINKS uses symlinks which makes the package 85MB slimmer (8MB instead of 93MB!)

# Add a place for git config files.
mkdir -p "${PREFIX}/etc"
make configure
./configure \
    --prefix="${PREFIX}" \
    --host=${HOST} \
    --with-gitattributes="${PREFIX}/etc/gitattributes" \
    --with-gitconfig="${PREFIX}/etc/gitconfig" \
    --with-iconv="${PREFIX}/lib" \
    --with-perl="${PREFIX}/bin/perl" \
    --with-tcltk="${PREFIX}/bin/tclsh"
make \
    --jobs=${CPU_COUNT} \
    NO_GETTEXT=1 \
    NO_INSTALL_HARDLINKS=1 \
    all strip install

git config --system http.sslVerify true
git config --system http.sslCAPath "${PREFIX}/ssl/cacert.pem"
git config --system http.sslCAInfo "${PREFIX}/ssl/cacert.pem"
