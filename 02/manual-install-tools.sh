#!/bin/bash

apt update
apt -y install git gcc g++ cmake make libxml2-dev liblz4-dev libzstd-dev \
        debhelper pkg-config devscripts build-essential fakeroot zip \
        openssl libpcap-dev libpcap0.8 libssl-dev libcrypt1-dev libatomic1 libxml2-dev \
        autoconf python3-sphinx python3-setuptools doxygen \
        python3-docutils zlib1g-dev librdkafka-dev

git clone -b ubuntu https://github.com/cesnet/nemea-framework
git clone -b ubuntu https://github.com/CESNET/ipfixprobe
git clone https://github.com/CESNET/libfds
git clone https://github.com/CESNET/ipfixcol2

(
cd nemea-framework
./bootstrap.sh
./configure -q --disable-doxygen-ps --disable-doxygen-pdf --prefix=/usr
make install
ldconfig
)
(
cd ipfixprobe
autoreconf -i
./configure -q --with-pcap --prefix=/usr
make install
)
(
cd libfds
mkdir build; cd build
cmake .. -DPACKAGE_BUILDER_DEB=On -DCPACK_PACKAGE_CONTACT="GitHub actions <no-reply@example.com>"
make deb
apt -y install ./pkg/deb/debbuild/*.deb
)
(
cd ipfixcol2
mkdir build; cd build
cmake .. -DPACKAGE_BUILDER_DEB=On -DCPACK_PACKAGE_CONTACT="GitHub actions <no-reply@example.com>"
make deb
apt -y install ./pkg/deb/debbuild/*.deb
)

