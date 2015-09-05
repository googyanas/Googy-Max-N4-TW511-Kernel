#!/bin/sh
export KERNELDIR=`readlink -f .`
export RAMFS_SOURCE="/home/googy/Kernel/Googy-Max-N4/Ramdisk"
export PARENT_DIR=`readlink -f ..`
# export USE_SEC_FIPS_MODE=true
export CROSS_COMPILE=/home/googy/Downloads/linaro/bin/arm-cortex_a15-linux-gnueabihf-

RAMFS_TMP="/home/googy/Kernel/Googy-Max-N4/Ramdisk_tmp/tmp"

VER="\"-Googy-Max-N4-v$1\""
cp -f /home/googy/Kernel/Googy-Max-N4/Kernel2/arch/arm/configs/0googymax_exynos5433-trelte_defconfig /home/googy/Kernel/Googy-Max-N4/0googymax_exynos5433-trelte_defconfig
sed "s#^CONFIG_LOCALVERSION=.*#CONFIG_LOCALVERSION=$VER#" /home/googy/Kernel/Googy-Max-N4/0googymax_exynos5433-trelte_defconfig > /home/googy/Kernel/Googy-Max-N4/Kernel2/arch/arm/configs/0googymax_exynos5433-trelte_defconfig

# export KCONFIG_NOTIMESTAMP=true
export ARCH=arm
export SUB_ARCH=arm

make ARCH=arm 0googymax_exynos5433-trelte_defconfig || exit 1

. $KERNELDIR/.config

cd $KERNELDIR/

# make exynos5433-tre_eur_open_16.dtb || exit 1

make -j4 zImage || exit 1

# tools/dtbToolCM -o dt.img -s 2048 -p scripts/dtc/ arch/arm/boot/dts/ || exit 1

# make -j4 || exit 1

#  CONFIG_DEBUG_SECTION_MISMATCH=y

cd /home/googy/Kernel/Googy-Max-N4/Ggy_Ramdisk
rm -f /home/googy/Kernel/Googy-Max-N4/Kernel2/boot.img
rm -f /home/googy/Kernel/Googy-Max-N4/Ggy_Ramdisk/coh4/zImage
rm -r coh4_tmp
cp -f $KERNELDIR/arch/arm/boot/zImage /home/googy/Kernel/Googy-Max-N4/Ggy_Ramdisk/coh4/zImage
cp -rf coh4 coh4_tmp
./mkboot coh4 /home/googy/Kernel/Googy-Max-N4/Kernel2/boot.img || exit 1
# mv -f -v boot.img /home/googy/Kernel/Googy-Max-N4/Kernel2/boot.img

# chmod a+r tools/dt.img

# tools/mkbootimg --kernel $KERNELDIR/arch/arm/boot/zImage --dt tools/dt.img --ramdisk /home/googy/Kernel/Googy-Max-N4/Ramdisk_tmp/tmp.cpio.gz --base 0x10000000 --kernel_offset 0x00008000 --ramdisk_offset 0x01000000 --second_offset 0x00f00000 --tags_offset 0x00000100 --pagesize 2048 -o $KERNELDIR/boot.img

# tools/mkbootimg --kernel $KERNELDIR/arch/arm/boot/zImage --dt tools/dt.img --ramdisk /home/googy/Kernel/Googy-Max-N4/Ramdisk_tmp/tmp.cpio.gz --base 0x10000000 --kernel_offset 0x10000000 --ramdisk_offset 0x10008000 --tags_offset 0x10000100 --pagesize 2048 -o $KERNELDIR/boot.img

# tools/mkbootimg --kernel $KERNELDIR/arch/arm/boot/zImage --dt $KERNELDIR/dt.img --ramdisk /home/googy/Kernel/Googy-Max-N4/Ramdisk_tmp/tmp.cpio.gz --base 0x10000000 --kernel_offset 0x10000000 --ramdisk_offset 0x10008000 --tags_offset 0x10000100 --pagesize 2048 -o boot.img || exit 1

cd /home/googy/Kernel/Googy-Max-N4
mv -f -v /home/googy/Kernel/Googy-Max-N4/Kernel2/boot.img /home/googy/Kernel/Googy-Max-N4/Release/boot.img
cd /home/googy/Kernel/Googy-Max-N4/Release
zip -r ../Googy-Max-N4_Kernel_${1}_CWM.zip .

adb push /home/googy/Kernel/Googy-Max-N4/Googy-Max-N4_Kernel_${1}_CWM.zip /storage/sdcard0/Googy-Max-N4_Kernel_${1}_CWM.zip

# adb push /home/googy/Anas/Googy-Max4-Kernel/GoogyMax4_TW-Kernel_${1}_CWM.zip /storage/sdcard0/update-gmax4.zip
# 
# adb shell su -c "echo 'boot-recovery ' > /cache/recovery/command"
# adb shell su -c "echo '--update_package=/storage/sdcard0/update-gmax4.zip' >> /cache/recovery/command"
# adb shell su -c "reboot recovery"

adb kill-server
