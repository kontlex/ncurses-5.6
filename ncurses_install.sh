#!/bin/sh

root_dir=$(pwd)
mkdir ${root_dir}/ncurses_bin
mkdir ${root_dir}/build

cd ${root_dir}/build

PATH="${TC_TOOLCHAIN_PATH}:${PATH}"
CC=${TC_TOOLCHAIN_TRIPLET}-gcc  ${root_dir}/src/configure ${TC_TOOLCHAIN_TRIPLET} --host=x86_64-gnu-linux --target=${TC_TOOLCHAIN_TRIPLET} --with-shared --prefix=${root_dir}/ncurses_bin

make HOSTCC=gcc CXX=${TC_TOOLCHAIN_TRIPLET}-c++

make install

rm -rf ${root_dir}/build