#!/bin/bash -e

INSTALL_DIR=$(pwd)/utils
mkdir -p ${INSTALL_DIR}
mkdir -p out/
mkdir -p pkg/
wget -nc https://github.com/openssh/openssh-portable/archive/refs/tags/V_9_2_P1.tar.gz -O out/openssh-V_9_2_P1.tar.gz || true
tar xf out/openssh-V_9_2_P1.tar.gz -C pkg/
cd pkg/openssh-portable-V_9_2_P1

export PKG_CONFIG="${TOOLCHAIN}/bin/arm-linux-gnueabihf-pkg-config"
export CC="${TOOLCHAIN}/bin/arm-linux-gnueabihf-gcc"
export CXX="${TOOLCHAIN}/bin/arm-linux-gnueabihf-g++"
export CFLAGS="-Os"
export CXXFLAGS="-Os"

autoreconf
./configure \
    --host="arm-linux-gnueabihf" \
    --without-openssl \
    --without-audit \
    --without-lastlog \
    --without-osfsia \
    --without-ssl-engine \
    --without-openssl-header-check \
    --without-pam \
    --without-xauth

make -j$(($(nproc)+1)) sftp-server
cp sftp-server "${INSTALL_DIR}/"
