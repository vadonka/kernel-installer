#!/sbin/sh
device=LGP990

# Supported ROM flags separated with one space(!)
romflags="cyanogen miui GRJ22"

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
sed="$BB sed"
awk="$BB awk"
grep="$BB grep"
chmod="$BB chmod"
chown="$BB chown"
tr="$BB tr"

ui_print "################################"
ui_print "#    LGE Kernel Installer      #"
ui_print "#    rewrited by  vadonka      #"
ui_print "#   UI is optimized for the    #"
ui_print "#       New Touch CWM          #"
ui_print "################################"
ui_print ""
ui_print "** Installing LGE kernel Kang **"
ui_print "**  Based on lge-kernel-star  **"
ui_print "**      by the CM team        **"
ui_print ""
ui_print "** compiled and cherry picked **"
ui_print "**         by vadonka         **"
ui_print ""

ui_print "Checking ROM"
ui_print "************"

romflagsnums=`echo $romflags | $tr -s ' ' '\n' | $grep -c "."`
romtest="0"
for a in `seq 1 $romflagsnums`; do
    romflag=`echo $romflags | $awk 'BEGIN {FS=" "} {print $'$a'}'`
    romflagtrue=`$grep -c $romflag /system/build.prop`
    let romtest=$romtest+$romflagtrue
done

if [ "$romtest" == "0" ]; then
	ui_print "This ROM is not supported!"
	fatal "Aborting..."
else
	ui_print "** Installing on MIUI/CM7 **"
fi

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
# General
ui_print "-General"
add ro.wifi.channels = 14
add dalvik.vm.heapsize = 48m
add ro.telephony.call_ring.delay = 1000
# Battery save
ui_print "-Battery save"
add wifi.supplicant_scan_interval = 320
add pm.sleep_mode = 1
add ro.ril.disable.power.collapse = 0
# Helps scrolling responsiveness
ui_print "-Scroll hack"
add windowsmgr.max_events_per_sec = 150
# Fix BSOD issue after a call
ui_print "-Endcall BSOD workaround"
add ro.lge.proximity.delay = 25
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
ui_print "-Removing RIL tweak if any"
del ro.ril.hsxpa =
del ro.ril.gprsclass =
del ro.ril.hep =
del ro.ril.enable.dtm =
del ro.ril.hsdpa.category =
del ro.ril.enable.a53 =
del ro.ril.enable.3g.prefix =
del ro.ril.htcmaskw1 =
del ro.ril.htcmaskw1.bitmask =
del ro.ril.hsupa.category =
add net.tcp.buffersize.default = 4096,87380,256960,4096,16384,256960
add net.tcp.buffersize.wifi = 4096,87380,256960,4096,16384,256960
add net.tcp.buffersize.umts = 4096,87380,256960,4096,16384,256960
add net.tcp.buffersize.edge = 4096,87380,256960,4096,16384,256960
# Disable the setup wizard
ui_print "-Disable the setup wizard"
add ro.setupwizard.mode = DISABLED

# Kernel flashing
ui_print ""
ui_print "Flashing the kernel"
ui_print "*******************"
ui_print "-zeroed mmcblk0p5"
$BB dd if=/dev/zero of=/dev/block/mmcblk0p5
ui_print "-write boot.img"
$BB dd if=$bd/boot.img of=/dev/block/mmcblk0p5
if [ "$?" -ne 0 ]; then
    fatal "ERROR: Flashing kernel failed!"
else
	ui_print "* Kernel flashed Succesfully! *"
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
	    ui_print "TweakAIO params file found! Skipping"
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
	    ui_print "...skipping install param file"
	fi
fi
ui_print "-Installing zram_stats binary"
cp -f /tmp/system/xbin/zram_stats /system/xbin/zram_stats
$chmod 0755 /system/xbin/zram_stats
ui_print "-Installing Roboto font"
cp -f /tmp/system/fonts/* /system/fonts/
ui_print "-Installing SqLite patch"
cp -f /tmp/system/lib/libsqlite.so /system/lib/libsqlite.so
$chmod 0644 /system/lib/libsqlite.so

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
