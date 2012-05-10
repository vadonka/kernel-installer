#!/sbin/sh
device=LGP990

ui_print() {
    echo ui_print "$@" 1>&$UPDATE_CMD_PIPE;
    if [ -n "$@" ]; then
        echo ui_print 1>&$UPDATE_CMD_PIPE;
    fi
}
log () { echo "$@"; }
fatal() { ui_print "$@"; exit 1; }

# Define cyanogenmod for specific parts
cyanogen=`$grep -c "cyanogenmod" /system/build.prop`

# build.prop backupen
cp /system/build.prop /system/build.prop.bat

# build.prop Tweaks
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
