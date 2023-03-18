#!/bin/bash
set -e

# Install required dependencies
apt-get update -y
apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev libffi-dev liblzma-dev

# Set the version of Python to download and install
PYTHON_VERSION="3.11.2"

# Download the Python source tarball
PYTHON_TARBALL="Python-$PYTHON_VERSION.tar.xz"
curl -O "https://www.python.org/ftp/python/$PYTHON_VERSION/$PYTHON_TARBALL"

# Extract the source code and enter the directory
tar -xvf "$PYTHON_TARBALL"
cd "Python-$PYTHON_VERSION"

# Configure, build, and install Python
./configure --prefix=/opt/python --enable-optimizations
make -j "$(nproc)"
make altinstall

# Create a symbolic link for the new Python installation
ln -s /opt/python/bin/python${PYTHON_VERSION%.*} /usr/local/bin/python${PYTHON_VERSION%.*}
ln -s /opt/python/bin/pip${PYTHON_VERSION%.*} /usr/local/bin/pip${PYTHON_VERSION%.*}

# Clean up
cd ..
rm -rf "$PYTHON_TARBALL" "Python-$PYTHON_VERSION"

echo "Python $PYTHON_VERSION installation complete."
