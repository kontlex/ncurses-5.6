#!/bin/sh
#arm-openwrt-linux-uclibcgnueabi-
#arm-brcm-linux-uclibcgnueabi
ROOT_DIR=/home/shavyrin/UFSD_Perfomance/projects/ncurses
DL_DIR=$ROOT_DIR/dl
SRC_DIR=$ROOT_DIR/src
NC_VER=5.6
INSTALL_DIR=$ROOT_DIR/install_ac3200
# TOOLCHAIN_DIR=/home/shavyrin/UFSD_Perfomance/NTGR7500_FW_AND_CC/R7500_uClibc/staging_dir/toolchain-arm_v7-a_gcc-4.6-linaro_uClibc-0.9.33.2_eabi
TOOLCHAIN_DIR=/home/shavyrin/toolchains/Asus_RT-AC3200/asuswrt-merlin/release/src-rt-6.x.4708/toolchains/hndtools-arm-linux-2.6.36-uclibc-4.5.3/arm-brcm-linux-uclibcgnueabi/sysroot

# mkdir $DL_DIR
mkdir $SRC_DIR
# wget -P $DL_DIR http://ftp.gnu.org/pub/gnu/ncurses/ncurses-$NC_VER.tar.gz
tar xfz $DL_DIR/ncurses-$NC_VER.tar.gz -C $SRC_DIR
mkdir $INSTALL_DIR

cd $SRC_DIR/ncurses-$NC_VER

#CC=arm-openwrt-linux-uclibcgnueabi-gcc  ./configure arm-openwrt-linux-uclibcgnueabi --host=x86_64-gnu-linux --target=arm-openwrt-linux --with-shared --prefix=$INSTALL_DIR
# CC=arm-openwrt-linux-uclibcgnueabi-gcc  ./configure arm-openwrt-linux-uclibcgnueabi --host=x86_64-gnu-linux --target=arm-openwrt-linux-uclibcgnueabi --with-shared --prefix=$TOOLCHAIN_DIR
CC=arm-brcm-linux-uclibcgnueabi-gcc  ./configure arm-brcm-linux-uclibcgnueabi --host=x86_64-gnu-linux --target=arm-brcm-linux-uclibcgnueabi --with-shared --prefix=$TOOLCHAIN_DIR

make HOSTCC=gcc CXX=arm-brcm-linux-uclibcgnueabi-c++

make install