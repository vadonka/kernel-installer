#!/sbin/sh
device=LGP990
TIMESTAMP=1333994133

ui_print() {
	echo ui_print "$@" 1>&$UPDATE_CMD_PIPE;
	if [ -n "$@" ]; then
		echo ui_print 1>&$UPDATE_CMD_PIPE;
	fi
}
log () { echo "$@"; }
fatal() { ui_print "$@"; exit 1; }

bd="/tmp"
BB=$bd/busybox
cp="$BB cp"
sed="$BB sed"
awk="$BB awk"
grep="$BB grep"
chmod="$BB chmod"
chown="$BB chown"
tr="$BB tr"
find="$BB find"
sha1sum="$BB sha1sum"

ui_print "################################"
ui_print "#      LGE Kernel Installer    #"
ui_print "#      rewrited by  vadonka    #"
ui_print "#     UI is optimized for the  #"
ui_print "#         New Touch CWM        #"
ui_print "################################"
ui_print ""
ui_print "** Installing LGE kernel Kang **"
ui_print "**  Based on lge-kernel-star  **"
ui_print "**       by the CM team       **"
ui_print ""
ui_print "** compiled and cherry picked **"
ui_print "**         by vadonka         **"
ui_print ""

ui_print "** Installing on MIUI/CM7 **"

if [ -e /system/build.prop.aiotweak ]; then
	ui_print ""
	ui_print "Removing old build.prop backup."
	rm /system/build.prop.aiotweak
fi

# Define cyanogenmod for specific parts
cyanogen=`$grep -c "cyanogenmod" /system/build.prop`

ui_print "Backup build.prop."
cp /system/build.prop /system/build.prop.aiotweak

ui_print ""
ui_print "Applying build.prop tweaks"
ui_print "**************************"

# Build prop modify procedure, dont touch!
##########################################
add()
{
	pcheck=`$grep -c "$1" /system/build.prop`
	orig=`$grep "$1$2" /system/build.prop`
	mod=`echo $1$2$3`
	if [ "$pcheck" -gt "0" ]; then
		$sed -i "s/$orig/$mod/g" /system/build.prop
	else
		echo $mod >> /system/build.prop
	fi
}

del()
{
	pcheck2=`$grep -c "$1" /system/build.prop`
	orig2=`$grep "$1$2" /system/build.prop`
	if [ "$pcheck2" -gt "0" ]; then
		if [ ! -z "$orig2" ];then
			$sed -i "/$orig2/d" /system/build.prop
		fi
	fi
}

############################################
# build.prop tweaks, changeable            #
# Make sure that you dont delete           #
# white space before and after the equals! #
############################################
if [ -e "/sdcard/etana.conf" ]; then
	bpallow=`grep -c "^enable_build.prop_tweaks" /sdcard/etana.conf`
else
	ui_print "-Kernel config file not found..."
	ui_print "--build.prop tweaks enabled by default"
	bpallow="1"
fi
if [ "$bpallow" -gt "0" ]; then
ui_print "--build.prop tweaks enabled"
# General
ui_print "-General"
add ro.wifi.channels = 14
add dalvik.vm.heapstartsize = 5m
add dalvik.vm.heapgrowthlimit = 48m
add dalvik.vm.heapsize = 48m
add ro.telephony.call_ring.delay = 400
add ro.HOME_APP_ADJ = 1
# Battery save
ui_print "-Battery save"
add wifi.supplicant_scan_interval = 180
add pm.sleep_mode = 1
add ro.ril.disable.power.collapse = 0
# Helps scrolling responsiveness
ui_print "-Scroll hack"
add windowsmgr.max_events_per_sec = 200
# Fix BSOD issue after a call
ui_print "-Endcall BSOD workaround"
add ro.lge.proximity.delay = 25
add ro.lg.proximity.delay = 25
# CM7 tweak
if [ "$cyanogen" == "1" ]; then
	ui_print "-CM7 specific tweaks"
	add persist.sys.use_dithering = 0
	add persist.sys.purgeable_assets = 1
fi
# Render UI with GPU
ui_print "-Speed up rendering"
add debug.sf.hw = 1
# Increase overall touch responsiveness
ui_print "-Increase touch responsiveness"
add debug.performance.tuning = 1
add video.accelerate.hw = 1
# Phone will not wake up from hitting the volume rocker
ui_print "-Vol.but. not wakeup the phone"
add ro.config.hwfeature_wakeupkey = 0
# Fix some application issues
ui_print "-Fix some application issues"
add ro.kernel.android.checkjni = 0
# Network speed tweak
ui_print "-Network speed tweak"
add net.tcp.buffersize.default = 6144,87380,1048576,6144,87380,1048576
add net.tcp.buffersize.wifi = 87380,1048576,2097152,87380,1048576,2097152
add net.tcp.buffersize.lte = 87380,524288,1048576,87380,524288,1048576
add net.tcp.buffersize.hsdpa = 6144,87380,1048576,6144,87380,1048576
add net.tcp.buffersize.evdo_b = 6144,87380,1048576,6144,87380,1048576
add net.tcp.buffersize.umts = 6144,87380,1048576,6144,87380,1048576
add net.tcp.buffersize.gprs = 6144,87380,1048576,6144,87380,1048576
add net.tcp.buffersize.edge = 6144,87380,524288,6144,16384,262144
add net.tcp.buffersize.hspa = 6144,87380,524288,6144,16384,262144
# Disable the setup wizard
ui_print "-Disable the setup wizard"
add ro.setupwizard.mode = DISABLED
else
ui_print "--build.prop tweaks disabled.."
ui_print "..in the config file!"
fi # Build.prop tweaks

# Kernel flashing
ui_print ""
ui_print "Flashing the kernel"
ui_print "*******************"
if [ -e "/sdcard/etana.conf" ]; then
	hack=`$grep "^ramhack" /sdcard/etana.conf | $awk 'BEGIN {FS="="} {print $2}'`
	if [ "$hack" == "0" -o "$hack" == "32" -o "$hack" == "48" -o "$hack" == "64" -o "$hack" == "80" -o "$hack" == "96" ]; then
		ui_print "-ramhack size is $hack MB"
	else
		ui_print "-invalid/undefined ramhack size!"
		ui_print "-ramhack is disabled by default"
		hack=0
	fi
else
	ui_print "-kernel config file not found..."
	ui_print "-ramhack is disabled by default"
	hack=0
fi
ui_print "-building the new kernel..."
$chmod 0777 $bd/mkbootimg
$bd/mkbootimg --kernel $bd/zImage --ramdisk $bd/initrd.img --cmdline "mem=$((383+$hack))M@0M nvmem=$((128-$hack))M@$((384+$hack))M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990" -o $bd/boot.img --base 0x10000000
if [ "$?" -ne 0 -o ! -f $bd/boot.img ]; then
    fatal "ERROR: Packing kernel failed!"
else
	imgsize=`ls -la $bd | grep boot.img$ | awk 'BEGIN {FS=" "} {print $5}'`
	if [ "$imgsize" -gt "1800000" ]; then
		echo "-New kernel image created succesfuly"
	else
		fatal "-ERROR: Building kernel failed!"
	fi
fi
ui_print "-zeroed mmcblk0p5"
$BB dd if=/dev/zero of=/dev/block/mmcblk0p5
ui_print "-writing the kernel..."
$BB dd if=$bd/boot.img of=/dev/block/mmcblk0p5
if [ "$?" -ne 0 ]; then
	fatal "ERROR: Flashing kernel failed!"
else
	ui_print "* Kernel flashed Succesfuly! *"
fi

# Cleanup process
ui_print ""
ui_print "Cleaning up"
ui_print "***********"
ui_print "-Clean up modules folder"
rm /system/lib/modules/*
if [ "$cyanogen" == "1" ]; then
	ui_print "-CM7 found!"
	ui_print "--Clean up the init.d folder"
	rm /system/etc/init.d/*
fi
ui_print "-Cleaning the dalvik-cache"
rm -rf /data/dalvik-cache/*
ui_print "-Cleaning the cache partition"
rm -rf /cache/*
umount /cache > /dev/null
/sbin/e2fsck -fy /dev/block/mmcblk0p2
mount /cache >/dev/null

# Installing modules, tweaks, mods
ui_print ""
ui_print "################################"
ui_print "# Install modules, tweak, etc. #"
ui_print "################################"
ui_print "-Copying modules"
cp /tmp/system/lib/modules/* /system/lib/modules/
$chmod 0644 /system/lib/modules/*
if [ "$cyanogen" == "1" ]; then
	ui_print "-Cyanogenmod found!"
	ui_print "--Installing CM7 init scripts"
	ui_print "--Installing AIO tweak"
	cp -f /tmp/system/etc/init.d/* /system/etc/init.d/
	$chmod 0755 /system/etc/init.d/*
	mkdir -p /data/tweakaio/logs
	if [ ! -f /data/tweakaio/tweakaio.conf ]; then
		ui_print "--TweakAIO params file not found!"
		ui_print "--Installing new params file"
		cp -f /tmp/data/tweakaio/tweakaio.conf /data/tweakaio/
	else
		ui_print "--TweakAIO params file found..."
		checknew=`$grep -c "TIMESTAMP" /data/tweakaio/tweakaio.conf`
		if [ "$checknew" -gt "0" ]; then
			tstamp=`$grep "TIMESTAMP" /data/tweakaio/tweakaio.conf | $sed "s/[^0-9]//g"`
			if [[ "$tstamp" == "$TIMESTAMP" ]]; then
				ui_print "--No need to update params file"
			else
				ui_print "--Backup OLD params file"
				mv /data/tweakaio/tweakaio.conf /data/tweakaio/tweakaio.conf.`date +%d%m%Y`
				ui_print "--Installing new params file"
				cp -f /tmp/data/tweakaio/tweakaio.conf /data/tweakaio/
			fi
		else
			ui_print "--Backup OLD params file"
			mv /data/tweakaio/tweakaio.conf /data/tweakaio/tweakaio.conf.`date +%d%m%Y`
			ui_print "--Installing new params file"
			cp -f /tmp/data/tweakaio/tweakaio.conf /data/tweakaio/
		fi
	fi
else
	ui_print "-Installing AIO tweak"
	cp -f /tmp/system/etc/init.d/90tweakaio /system/etc/init.d/
	$chmod 0755 /system/etc/init.d/90tweakaio
	mkdir -p /data/tweakaio/logs
	if [ ! -f /data/tweakaio/tweakaio.conf ]; then
		ui_print "--TweakAIO params file not found!"
		ui_print "--Installing new params file"
		cp -f /tmp/data/tweakaio/tweakaio.conf /data/tweakaio/
	else
		ui_print "--TweakAIO params file found..."
		checknew=`$grep -c "TIMESTAMP" /data/tweakaio/tweakaio.conf`
		if [ "$checknew" -gt "0" ]; then
			tstamp=`$grep "TIMESTAMP" /data/tweakaio/tweakaio.conf | $sed "s/[^0-9]//g"`
			if [[ "$tstamp" == "$TIMESTAMP" ]]; then
				ui_print "--No need to update params file"
			else
				ui_print "--Backup OLD params file"
				mv /data/tweakaio/tweakaio.conf /data/tweakaio/tweakaio.conf.`date +%d%m%Y`
				ui_print "--Installing new params file"
				cp -f /tmp/data/tweakaio/tweakaio.conf /data/tweakaio/
			fi
		else
			ui_print "--Backup OLD params file"
			mv /data/tweakaio/tweakaio.conf /data/tweakaio/tweakaio.conf.`date +%d%m%Y`
			ui_print "--Installing new params file"
			cp -f /tmp/data/tweakaio/tweakaio.conf /data/tweakaio/
		fi
	fi
fi
ui_print "-Fix tweakaio.conf permission"
$chmod 0777 /data/tweakaio/tweakaio.conf
ui_print "-Installing TweakAIO help file"
cp -f /tmp/data/tweakaio/tweakaio_hlp.txt /data/tweakaio/
ui_print "-Installing zram_stats binary"
cp -f /tmp/system/xbin/zram_stats /system/xbin/zram_stats
$chmod 0755 /system/xbin/zram_stats

ui_print "-Checking NvRM binary version"
nvrm_sha1=`$sha1sum /system/bin/nvrm_daemon | awk 'BEGIN {FS=" "} {print $1}'`
nvrm_v20q_sha1="fe5060fb1a94a77b1e2048e323e6e84748a74736"
if [[ "$nvrm_sha1" == "$nvrm_v20q_sha1" ]]; then
	ui_print "--NvRM binary already upgraded"
else
	ui_print "--Installing v20q NvRM binary"
	cp -f /tmp/system/bin/nvrm_daemon_v20q /system/bin/nvrm_daemon
	$chmod 0755 /system/bin/nvrm_daemon
	$chown root:shell /system/bin/nvrm_daemon
fi
ui_print "-Installing Kernel image tools"
cp -f /tmp/system/xbin/mkbootimg /system/xbin/mkbootimg
cp -f /tmp/system/xbin/unpackbootimg /system/xbin/unpackbootimg
cp -f /tmp/system/xbin/rh /system/xbin/rh
$chmod 0755 /system/xbin/mkbootimg
$chmod 0755 /system/xbin/unpackbootimg
$chmod 0755 /system/xbin/rh
ui_print "-Checking bash..."
bash_location=`$find /system -type f -name bash`
if [ ! -f $bash_location ]; then
	ui_print "--Bash binary not found!"
	ui_print "--Installing Bash"
	cp -f /tmp/system/xbin/bash /system/xbin/bash
	$chmod 0755 /system/xbin/bash
else
	ui_print "--Bash binary found..."
	ui_print "...skipping install bash"
fi
if [ -e "/sdcard/etana.conf" ]; then
	updatesu=`grep -c "^update_su" /sdcard/etana.conf`
else
	ui_print "-Kernel config file not found..."
	ui_print "--skiped su update"
	updatesu="0"
fi
if [ "$updatesu" -gt "0" ]; then
	ui_print "-Checking su..."
	su_location=`$find /system -type f -name su`
	su_sha1=`$sha1sum $su_location | awk 'BEGIN {FS=" "} {print $1}'`
	su_3032_sha1="61410f2e93f5a397f8fc3dd51ea04d6e82734615"
	if [[ "$su_sha1" == "$su_3032_sha1" ]]; then
		ui_print "--su binary is the latest"
		ui_print "--checking su filemod..."
		sumod1=`ls -l /system/xbin/su | awk 'BEGIN {FS=" "} {print $1}'`
		sumod2="-rwsr-sr-x"
		if [[ "$sumod1" == "$sumod2" ]]; then
			ui_print "--su binary filemod is fine"
		else
			ui_print "--su binary filemod is wrong, fixing..."
			$chmod 06755 /tmp/system/xbin/su
			$cp -fp /tmp/system/xbin/su $su_location
		fi
	elif [[ "$su_location" == "" ]]; then
		ui_print "--su binary is not found"
		ui_print "--Installing su binary v3.0.3.2"
		$chmod 06755 /tmp/system/xbin/su
		$cp -p /tmp/system/xbin/su /system/xbin/su
		#$chown root:root /system/xbin/su
	else
		ui_print "--su binary is outdated"
		ui_print "--Installing su binary v3.0.3.2"
		$chmod 06755 /tmp/system/xbin/su
		$cp -fp /tmp/system/xbin/su $su_location
		#$chown root:root $su_location
	fi
fi
if [ -e "/sdcard/etana.conf" ]; then
	fontallow=`grep -c "^install_roboto_font" /sdcard/etana.conf`
else
	ui_print "-Kernel config file not found..."
	ui_print "--Installing roboto font by default"
	fontallow="1"
fi
if [ "$fontallow" -gt "0" ]; then
ui_print "-Installing Roboto font"
cp -f /tmp/system/fonts/* /system/fonts/
fi
if [ -e "/sdcard/etana.conf" ]; then
	sqliallow=`grep -c "^install_sqlite_patch" /sdcard/etana.conf`
else
	ui_print "-Kernel config file not found..."
	ui_print "--Installing sqlite patch by default"
	sqliallow="1"
fi
if [ "$sqliallow" -gt "0" ]; then
ui_print "-Installing SqLite patch"
cp -f /tmp/system/lib/libsqlite.so /system/lib/libsqlite.so
$chmod 0644 /system/lib/libsqlite.so
fi
if [ -e "/sdcard/etana.conf" ]; then
	adblockallow=`grep -c "^install_adblock_host" /sdcard/etana.conf`
else
	ui_print "-Kernel config file not found..."
	ui_print "--Installing ADblock host file by default"
	adblockallow="1"
fi
if [ "$adblockallow" -gt "0" ]; then
ui_print "-Installing ADblock host file"
cp -f /tmp/system/etc/hosts /system/etc/hosts
fi
ui_print "-Install TweakAIO config editor app"
rm -f /data/app/*tweakaio*.apk
cp -f /tmp/data/app/ETaNa-kernel-tweakaio.apk /data/app/ETaNa-kernel-tweakaio.apk
$chmod 0644 /data/app/ETaNa-kernel-tweakaio.apk
$chown system:system /data/app/ETaNa-kernel-tweakaio.apk

# Unmount partitions
ui_print ""
ui_print "Umount Partitions"
ui_print "*****************"
umount /data
umount /system
ui_print ""
ui_print "################################"
ui_print "#   CM7 Kang Kernel is ready!  #"
ui_print "################################"
