#!/sbin/sh
device=LGP990

bd="/tmp/kernel_files"
BB=$bd/busybox
sed="$BB sed"
awk="$BB awk"
grep="$BB grep"
chmod="$BB chmod"
chown="$BB chown"
tr="$BB tr"

$chmod 0777 $bd/mkbootimg
$bd/mkbootimg --kernel $bd/zImage --ramdisk $bd/initrd.img --cmdline "mem=$((383+64))M@0M nvmem=$((128-64))M@$((384+64))M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990" -o $bd/boot.img --base 0x10000000
if [ "$?" -ne 0 -o ! -f $bd/boot.img ]; then
    fatal "ERROR: Packing kernel failed!"
else
	imgsize=`ls -la $bd | grep boot.img$ | awk 'BEGIN {-F " "} {print $5}'`
	if [ "$imgsize" -gt "1800000" ]; then
		echo "-New kernel image created succesfuly"
	else
		fatal "-ERROR: Building kernel failed!"
	fi
fi

$BB dd if=/dev/zero of=/dev/block/mmcblk0p5
$BB dd if=$bd/boot.img of=/dev/block/mmcblk0p5
if [ "$?" -ne 0 ]; then
	fatal "ERROR: Flashing kernel failed!"
fi
