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
chown="$BB chown"
tr="$BB tr"
find="$BB find"
sha1sum="$BB sha1sum"
sleep="$BB sleep"

ui_print "################################"
ui_print "#       TweakAIO Installer     #"
ui_print "################################"
ui_print ""

ui_print "-Checking installer config..."
if [ -f "/sdcard/etana.conf" ]; then
	ui_print "-Installer config found!"
	ui_print "-Reading variables..."
	bpallow=`grep -c "^enable_build.prop_tweaks" /sdcard/etana.conf`
	adblockallow=`grep -c "^install_adblock_host" /sdcard/etana.conf`
	$sleep 3
else
	ui_print "-Installer config NOT found!"
	ui_print "-Use default values..."
	bpallow=1
	adblockallow=0
	$sleep 3
fi

ui_print "-Backup build.prop."
cp /system/build.prop /system/build.prop.`date +%d%m%y%H%M`


if [ "$bpallow" -gt 0 ]; then
ui_print "-Applying build.prop tweaks"
cp -f /tmp/system/build.prop /system/build.prop
chmod 0666 /system/build.prop
fi

# Installing modules, tweaks, mods
ui_print ""
ui_print "-Installing AIO tweak"
cp -f /tmp/system/etc/init.d/90tweakaio /system/etc/init.d/
$chmod 0755 /system/etc/init.d/90tweakaio
ui_print "-Installing zram_stats binary"
cp -f /tmp/system/xbin/zram_stats /system/xbin/zram_stats
$chmod 0755 /system/xbin/zram_stats
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
if [ "$adblockallow" -gt 0 ]; then
	ui_print "-Installing ADblock host file"
	cp -f /tmp/system/etc/hosts /system/etc/hosts
fi
ui_print "-Install TweakAIO config editor app"
rm -f /data/app/*tweakaio*.apk
rm -f /system/app/*tweakaio*.apk
cp -f /tmp/data/app/ETaNa-kernel-tweakaio.apk /system/app/ETaNa-kernel-tweakaio.apk
$chmod 0644 /system/app/ETaNa-kernel-tweakaio.apk

# Unmount partitions
ui_print ""
ui_print "Umount Partitions"
ui_print "*****************"
umount /data
umount /system
ui_print ""
ui_print "Done!"
