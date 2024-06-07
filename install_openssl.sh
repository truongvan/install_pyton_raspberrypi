#!/bin/bash
#install_openssl_from_source.sh
set -e

# Install required dependencies
apt-get update -y
apt-get install -y build-essential curl

# Set the version of OpenSSL to download and install
OPENSSL_VERSION="1.1.1w"

# Download and extract the source code
curl -O "https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz"
tar -xvf "openssl-$OPENSSL_VERSION.tar.gz"
cd "openssl-$OPENSSL_VERSION"

# Configure, build, and install OpenSSL
./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl
make -j "$(nproc)"
make install_sw

# Update the system's shared library cache
echo "/usr/local/openssl/lib" > /etc/ld.so.conf.d/openssl.conf
ldconfig

# Update the PATH and LD_LIBRARY_PATH variables
echo "export PATH=\"/usr/local/openssl/bin:\$PATH\"" > /etc/profile.d/openssl.sh
echo "export LD_LIBRARY_PATH=\"/usr/local/openssl/lib:\$LD_LIBRARY_PATH\"" >> /etc/profile.d/openssl.sh
source /etc/profile.d/openssl.sh

# Clean up
cd ..
rm -rf "openssl-$OPENSSL_VERSION.tar.gz" "openssl-$OPENSSL_VERSION"

echo "OpenSSL $OPENSSL_VERSION installation complete."
