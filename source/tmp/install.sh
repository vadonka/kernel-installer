#!/sbin/sh
device=LGP990

ui_print()
{
	echo ui_print "$@" 1>&$UPDATE_CMD_PIPE;
	if [ -n "$@" ]; then
		echo ui_print 1>&$UPDATE_CMD_PIPE;
	fi
}
log () { echo "$@"; }
fatal() { ui_print "$@"; exit 1; }

ui_progress ()
{
	if [ "$1" == "" ]; then
		module=1;
	else
		module=$1
	fi;
	i=0
	while read LINE; do
		if [ `expr $i % $module` -eq 0 ]; then
			echo "ui_print #" 1>&$UPDATE_CMD_PIPE
		fi
		i=`expr $i + 1`
	done
}

bd="/tmp"
BB="/sbin/busybox"
cp="$BB cp"
sed="$BB sed"
awk="$BB awk"
grep="$BB grep"
chmod="$BB chmod"
sleep="$BB sleep"

ui_print "#################################"
ui_print "# ETaNa v3.0.y Kernel Installer #"
ui_print "#      rewrited by  vadonka     #"
ui_print "#################################"
ui_print ""
ui_print "** Installing LGE kernel Kang **"
ui_print "**  Based on lge-kernel-star  **"
ui_print "**       by the CM team       **"
ui_print ""
ui_print "** compiled and cherry picked **"
ui_print "**         by vadonka         **"
ui_print ""

ui_print "** Installing on MIUI/CM7 **"

ui_print "-Checking installer config..."
if [ -f "/sdcard/etana.conf" ]; then
	ui_print "--Installer config found!"
	ui_print "--Reading variables..."
	hack=`$grep "^ramhack" /sdcard/etana.conf | $sed 's/[^0-9]//g'`
	avpfreq=`$grep "^avpfreq" /sdcard/etana.conf | $sed 's/[^0-9]//g'`
	gpufreq=`$grep "^gpufreq" /sdcard/etana.conf | $sed 's/[^0-9]//g'`
	vdefreq=`$grep "^vdefreq" /sdcard/etana.conf | $sed 's/[^0-9]//g'`
	$sleep 3
else
	ui_print "--Installer config NOT found!"
	ui_print "--Use default values..."
	hack=0
	avpfreq=240000
	gpufreq=300000
	vdefreq=650000
	$sleep 3
fi

# Kernel flashing
ui_print ""
ui_print "Flashing the kernel"
ui_print "*******************"
# RAMhack
if [ "$hack" -ne 0 -a "$hack" -ne 32 -a "$hack" -ne 48 -a "$hack" -ne 64 -a "$hack" -ne 80 -a "$hack" -ne 96 ]; then
	hack=0
	ui_print "-RAMhack default=$hack MB"
else
	ui_print "-RAMhack size=$hack MB"
fi
# AVP Freq
if [ "$avpfreq" -lt 200000 -o "$avpfreq" -gt 280000 ]; then
	avpfreq=240000
	ui_print "-AVP freq default=$avpfreq"
else
	ui_print "-AVP freq=$avpfreq"
fi
# GPU Freq
if [ "$gpufreq" -lt 300000 -o "$gpufreq" -gt 366000 ]; then
	gpufreq=300000
	ui_print "-GPU freq default=$gpufreq"
else
	ui_print "-GPU freq=$gpufreq"
fi
# VDE Freq
if [ "$vdefreq" -lt 600000 -o "$vdefreq" -gt 700000 ]; then
	vdefreq=650000
	ui_print "-VDE freq default=$vdefreq"
else
	ui_print "-VDE freq=$vdefreq"
fi
$sleep 3

ui_print "-Building the new kernel..."
$chmod 0777 $bd/mkbootimg
$bd/mkbootimg --kernel $bd/zImage --ramdisk $bd/initrd.img --cmdline "mem=$((383+$hack))M@0M nvmem=$((128-$hack))M@$((384+$hack))M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990 avpfreq=$avpfreq gpufreq=$gpufreq vdefreq=$vdefreq" -o $bd/boot.img --base 0x10000000
if [ "$?" -ne 0 -o ! -f $bd/boot.img ]; then
	fatal "ERROR: Packing kernel failed!"
else
	imgsize=`ls -la $bd | $grep boot.img$ | $awk 'BEGIN {FS=" "} {print $5}'`
	if [ "$imgsize" -gt 1800000 ]; then
		ui_print "-New kernel image created succesfuly"
	else
		fatal "-ERROR: Building kernel failed!"
	fi
fi
ui_print "-Zeroed mmcblk0p5"
$BB dd if=/dev/zero of=/dev/block/mmcblk0p5
ui_print "-Writing the kernel..."
$BB dd if=$bd/boot.img of=/dev/block/mmcblk0p5
if [ "$?" -ne 0 ]; then
	fatal "ERROR: Flashing kernel failed!"
else
	ui_print "** Kernel flashed Succesfuly! **"
fi

# Cleanup process
ui_print ""
ui_print "-Clean up modules folder"
rm /system/lib/modules/*
ui_print "-Copying modules"
$cp /tmp/system/lib/modules/* /system/lib/modules/
$chmod 0644 /system/lib/modules/*
ui_print "-Installing Kernel image tools"
$cp -f /tmp/system/xbin/mkbootimg /system/xbin/mkbootimg
$cp -f /tmp/system/xbin/unpackbootimg /system/xbin/unpackbootimg
$cp -f /tmp/system/xbin/otf /system/xbin/otf
$chmod 0755 /system/xbin/mkbootimg
$chmod 0755 /system/xbin/unpackbootimg
$chmod 0755 /system/xbin/otf

# Unmount partitions
ui_print ""
ui_print "Umount Partitions"
ui_print "*****************"
umount /system
ui_print ""
ui_print "################################"
ui_print "#   ETaNa  Kernel  installed   #"
ui_print "################################"
