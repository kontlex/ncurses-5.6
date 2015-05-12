#!/bin/sh

mkdir $(pwd)/ncurses_bin

PATH="${TC_TOOLCHAIN_PATH}:${PATH}"
CC=${TC_TOOLCHAIN_TRIPLET}-gcc  ./configure ${TC_TOOLCHAIN_TRIPLET} --host=x86_64-gnu-linux --target=${TC_TOOLCHAIN_TRIPLET} --with-shared --prefix=$(pwd)/ncurses_bin

make HOSTCC=gcc CXX=${TC_TOOLCHAIN_TRIPLET}-c++

make install