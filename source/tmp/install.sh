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
ui_print "-Battery friendly 3G"
add ro.ril.hsxpa = 2
add ro.ril.gprsclass = 10
add ro.ril.hep = 1
add ro.ril.hsdpa.category = 8
add ro.ril.enable.3g.prefix = 1
add ro.ril.htcmaskw1.bitmask = 4294967295
add ro.ril.htcmaskw1 = 14449
add ro.ril.hsupa.category = 6
add ro.ril.def.agps.mode = 2
add ro.ril.def.agps.feature = 1
add ro.ril.enable.sdr = 1
add ro.ril.enable.gea3 = 1
add ro.ril.enable.fd.plmn.prefix = 23402,23410,23411
add ro.ril.disable.power.collapse = 0
add ro.ril.enable.a52 = 0
add ro.ril.enable.a53 = 0
add ro.ril.enable.dtm = 0
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
		ui_print "--TweakAIO params file found..."
		ui_print "...skipping install param file"
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
cpuuv=`$grep -c "CPU_UV=" /data/tweakaio/tweakaio.conf`
if [ "$cpuuv" -gt "0" ]; then
	ui_print "-CPU UV patch is already present"
else
	ui_print "-Applyed CPU UV patch"
	echo -e "\n#***************************************" >> /data/tweakaio/tweakaio.conf
	echo "#**********< CPU Undervolt >************" >> /data/tweakaio/tweakaio.conf
	echo "#***************************************" >> /data/tweakaio/tweakaio.conf
	echo "#" >> /data/tweakaio/tweakaio.conf
	echo "# You  can  define  the  voltage  levels" >> /data/tweakaio/tweakaio.conf
	echo "# The  init  script  limited the minimum" >> /data/tweakaio/tweakaio.conf
	echo "# voltage   levels   for  safety  reason" >> /data/tweakaio/tweakaio.conf
	echo "# so   you   cant  undervolt  too  much." >> /data/tweakaio/tweakaio.conf
	echo "#" >> /data/tweakaio/tweakaio.conf
	echo "# The  first value is the CPU freq level" >> /data/tweakaio/tweakaio.conf
	echo "# The   second   is  the  voltage  level" >> /data/tweakaio/tweakaio.conf
	echo "#" >> /data/tweakaio/tweakaio.conf
	echo -e "# CPU  undervolt  is disabled by default\n" >> /data/tweakaio/tweakaio.conf
	echo "CPU_UV=\"off"\" >> /data/tweakaio/tweakaio.conf
	echo -e "\nCPU216MHZ=\"780"\" >> /data/tweakaio/tweakaio.conf
	echo "CPU324MHZ=\"790"\" >> /data/tweakaio/tweakaio.conf
	echo "CPU503MHZ=\"840"\" >> /data/tweakaio/tweakaio.conf
	echo "CPU655MHZ=\"870"\" >> /data/tweakaio/tweakaio.conf
	echo "CPU800MHZ=\"900"\" >> /data/tweakaio/tweakaio.conf
	echo "CPU1015MHZ=\"1000"\" >> /data/tweakaio/tweakaio.conf
	echo "CPU1100MHZ=\"1050"\" >> /data/tweakaio/tweakaio.conf
	echo "CPU1216MHZ=\"1150"\" >> /data/tweakaio/tweakaio.conf
	echo "CPU1408MHZ=\"1250"\" >> /data/tweakaio/tweakaio.conf
fi
cpuuv1=`$grep -c "CPU324MHZ=" /data/tweakaio/tweakaio.conf`
if [ "$cpuuv1" -gt "0" ]; then
	ui_print "-389Mhz already modifyed to 324Mhz"
else
	ui_print "-Change 389Mhz to 324Mhz"
	$sed -i "s/CPU389/CPU324/g" /data/tweakaio/tweakaio.conf
fi
cpu655mhz=`$grep -c "CPU655MHZ=" /data/tweakaio/tweakaio.conf`
if [ "$cpu655mhz" -gt "0" ]; then
	ui_print "-655Mhz CPU step already exsist"
else
	ui_print "-Add 655Mhz CPU step"
	cpu800mhz=`$grep "CPU800MHZ=" /data/tweakaio/tweakaio.conf`
	$sed -i "/$cpu800mhz/ i\CPU655MHZ=\"870"\" /data/tweakaio/tweakaio.conf
fi
cpu1408mhz=`$grep -c "CPU1408MHZ=" /data/tweakaio/tweakaio.conf`
if [ "$cpu1408mhz" -gt "0" ]; then
	ui_print "-1408Mhz CPU step already exsist"
else
	ui_print "-Add 1408Mhz CPU step"
	cpu1216mhz=`$grep "CPU1216MHZ=" /data/tweakaio/tweakaio.conf`
	$sed -i "/$cpu1216mhz/ a\CPU1408MHZ=\"1250"\" /data/tweakaio/tweakaio.conf
fi
dvcleaner=`$grep -c "DALVIK_CLEANER=" /data/tweakaio/tweakaio.conf`
if [ "$dvcleaner" -gt "0" ]; then
	ui_print "-Dalvik-Cleaner patch is already present"
else
	ui_print "-Applyed Dalvik-Cleaner patch"
	echo -e "\n#***************************************" >> /data/tweakaio/tweakaio.conf
	echo "#*******< Dalvik Cache Cleaner >********" >> /data/tweakaio/tweakaio.conf
	echo "#***************************************" >> /data/tweakaio/tweakaio.conf
	echo "#" >> /data/tweakaio/tweakaio.conf
	echo "# Clean  outdated  dalvik  cache entries" >> /data/tweakaio/tweakaio.conf
	echo "# modded   by  trev  for  synergykingdom" >> /data/tweakaio/tweakaio.conf
	echo "# additional   mods  by  bigrushdog  for" >> /data/tweakaio/tweakaio.conf
	echo "# Tiamat Xoom Rom" >> /data/tweakaio/tweakaio.conf
	echo "#" >> /data/tweakaio/tweakaio.conf
	echo "# thanks Team Synergy and TrevE" >> /data/tweakaio/tweakaio.conf
	echo -e "# you guys rock!\n" >> /data/tweakaio/tweakaio.conf
	echo "DALVIK_CLEANER=\"off"\" >> /data/tweakaio/tweakaio.conf
fi
sqlidefr=`$grep -c "SQLITE_DEFRAG=" /data/tweakaio/tweakaio.conf`
if [ "$sqlidefr" -gt "0" ]; then
	ui_print "-SQLite3 defrag patch is already present"
else
	ui_print "-Applyed SQLite3 defrag patch"
	echo -e "\n#***************************************" >> /data/tweakaio/tweakaio.conf
	echo "#**********< SQLite Defrag >************" >> /data/tweakaio/tweakaio.conf
	echo "#***************************************" >> /data/tweakaio/tweakaio.conf
	echo "#" >> /data/tweakaio/tweakaio.conf
	echo -e "# Defrag SQLite3 databases\n" >> /data/tweakaio/tweakaio.conf
	echo "SQLITE_DEFRAG=\"off"\" >> /data/tweakaio/tweakaio.conf
fi
ui_print "-Installing zram_stats binary"
cp -f /tmp/system/xbin/zram_stats /system/xbin/zram_stats
$chmod 0755 /system/xbin/zram_stats
ui_print "-Checking bash..."
if [ ! -f /system/xbin/bash ]; then
	ui_print "--Bash binary not found!"
	ui_print "--Installing Bash"
	cp -f /tmp/system/xbin/bash /system/xbin/bash
	$chmod 0755 /system/xbin/bash
else
	ui_print "--Bash binary found..."
	ui_print "...skipping install bash"
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
ui_print "-Tweakaio.conf Eyecandyzer :)"
noeyecandy=`grep -c "^#######################################" /data/tweakaio/tweakaio.conf`
if [ "$noeyecandy" -gt "0" ]; then
    ui_print "--No EyeCandy..baaad :-("
    ui_print "--Running EyeCandyzer"
    $sed -i "s/########################################/#***************************************/g" /data/tweakaio/tweakaio.conf
    sed1=`grep "Script mode" /data/tweakaio/tweakaio.conf`
    sed2=`grep "System logger" /data/tweakaio/tweakaio.conf`
    sed3=`grep "Low Memory Killer mode" /data/tweakaio/tweakaio.conf`
    sed4=`grep "Network Tweaks" /data/tweakaio/tweakaio.conf`
    sed5=`grep "VM Management and kernel tweaks" /data/tweakaio/tweakaio.conf`
    sed6=`grep "Mount Option Tweaks" /data/tweakaio/tweakaio.conf`
    sed7=`grep "CPU Undervolt" /data/tweakaio/tweakaio.conf`
    sed8=`grep "Dalvik Cache Cleaner" /data/tweakaio/tweakaio.conf`
    sed9=`grep "SQLite Defrag" /data/tweakaio/tweakaio.conf`
    $sed -i "s/$sed1/#***********< Script mode >*************/g" /data/tweakaio/tweakaio.conf
    $sed -i "s/$sed2/#**********< System logger >************/g" /data/tweakaio/tweakaio.conf
    $sed -i "s/$sed3/#******< Low Memory Killer mode >*******/g" /data/tweakaio/tweakaio.conf
    $sed -i "s/$sed4/#**********< Network Tweaks >***********/g" /data/tweakaio/tweakaio.conf
    $sed -i "s/$sed5/#**< VM Management and kernel tweaks >**/g" /data/tweakaio/tweakaio.conf
    $sed -i "s/$sed6/#*******< Mount Option Tweaks >*********/g" /data/tweakaio/tweakaio.conf
    $sed -i "s/$sed7/#**********< CPU Undervolt >************/g" /data/tweakaio/tweakaio.conf
    $sed -i "s/$sed8/#*******< Dalvik Cache Cleaner >********/g" /data/tweakaio/tweakaio.conf
    $sed -i "s/$sed9/#**********< SQLite Defrag >************/g" /data/tweakaio/tweakaio.conf
    ui_print "--EyeCandy Succesful :-)"
else
    ui_print "--Tweakaio.conf already EyeCandy"
fi
if [ -e "/data/app/etana-kernel-tweakaio-signed.apk" ]; then
    ui_print "-TweakAIO config editor already installer"
else
    ui_print "-Install TweakAIO config editor app"
    cp -f /tmp/data/app/etana-kernel-tweakaio-signed.apk /data/app/etana-kernel-tweakaio-signed.apk
    $chmod 0644 /data/app/etana-kernel-tweakaio-signed.apk
    $chown system:system /data/app/etana-kernel-tweakaio-signed.apk
fi

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
