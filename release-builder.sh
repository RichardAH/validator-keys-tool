#!/bin/bash
SCRIPT_LOCATION="`dirname \"$0\"`"
rm -rf release-build;
mkdir release-build;
cp inner_makefile release-build/makefile;
mkdir .nih_toolchain;
docker run -t -i --rm  -v `pwd`:/io --network host ghcr.io/foobarwidget/holy-build-box-x64 /hbb_exe/activate-exec bash -x -c '
cd /io;
cd .nih_toolchain &&
yum install -y wget lz4 lz4-devel git devtoolset-10-binutils zlib-static ncurses-static -y \
  devtoolset-7-gcc-c++ \
  devtoolset-9-gcc-c++ \
  devtoolset-10-gcc-c++ \
  snappy snappy-devel \
  zlib zlib-devel \
  lz4-devel \
  libarchive-devel \
  libasan &&
export PATH=`echo $PATH | sed -E "s/devtoolset-9/devtoolset-7/g"` &&
echo "-- Install Boost 1.75.0 --" &&
pwd &&
( wget -nc https://boostorg.jfrog.io/artifactory/main/release/1.75.0/source/boost_1_75_0.tar.gz; echo "" ) &&
tar -xzf boost_1_75_0.tar.gz &&
cd boost_1_75_0 && ./bootstrap.sh && ./b2 --prefix=/usr link=static --with-json -j8 && ./b2 install &&
export PATH=`echo $PATH | sed -E "s/devtoolset-7/devtoolset-10/g"` &&
cd ../../release-build/ &&
make && strip vkt-portable'
