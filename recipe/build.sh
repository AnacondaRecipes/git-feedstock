#!/bin/bash

# NO_GETTEXT disables internationalization (localized message translations)
# NO_INSTALL_HARDLINKS uses symlinks which makes the package 85MB slimmer (8MB instead of 93MB!)

# pcre-feedstock recipe does not include --enable-jit
export NO_LIBPCRE1_JIT=1

echo : "BOOTSTRAPPING is set to: ${BOOTSTRAPPING}"
# Turn off tcltk when doing a restricted build
if [[ ! -z "${BOOTSTRAPPING+x}" ]] && [[ "${BOOTSTRAPPING}" == "yes" ]];then
  TK_OPT=""
else
  TK_OPT="--with-tcltk=${PREFIX}/bin/tclsh"
fi
echo "TK configure opt: ${TK_OPT}"

# Add a place for git config files.
mkdir -p "${PREFIX}/etc"
make configure
./configure \
    --prefix="${PREFIX}" \
    --host=${HOST} \
    --with-gitattributes="${PREFIX}/etc/gitattributes" \
    --with-gitconfig="${PREFIX}/etc/gitconfig" \
    --with-libpcre1 \
    --with-iconv="${PREFIX}/lib" \
    --with-perl="${PREFIX}/bin/perl" \
    "${TK_OPT}"


if [[ ! -z "${BOOTSTRAPPING+x}" ]] && [[ "${BOOTSTRAPPING}" == "yes" ]];then
  make \
      --jobs=${CPU_COUNT} \
      NO_GETTEXT=1 \
      NO_INSTALL_HARDLINKS=1 \
      all strip install \
      NO_TCLTK=yes \
      ${VERBOSE_AT}
else
  make \
      --jobs=${CPU_COUNT} \
      NO_GETTEXT=1 \
      NO_INSTALL_HARDLINKS=1 \
      all strip install \
      ${VERBOSE_AT}
fi

# build osxkeychain
if [[ $(uname) == "Darwin" ]]; then
  pushd contrib/credential/osxkeychain
  make -e
  cp -avf git-credential-osxkeychain $PREFIX/bin
  popd
fi

git config --system http.sslVerify true
git config --system http.sslCAPath "${PREFIX}/ssl/cacert.pem"
git config --system http.sslCAInfo "${PREFIX}/ssl/cacert.pem"

# Install completion files
mkdir -p $PREFIX/share/bash-completion/completions
cp contrib/completion/git-completion.bash $PREFIX/share/bash-completion/completions/git
