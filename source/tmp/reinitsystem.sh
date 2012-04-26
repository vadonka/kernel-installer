#!/sbin/sh
#
# LG O2X script for 3.0 kernels to re-initialize system partition 
# with mke2fs and tune2fs after CM7 install
# 
# why is this necessary?
#

echo="ui_print"

ui_print() {
	echo ui_print "$@" 1>&$UPDATE_CMD_PIPE;
	if [ -n "$@" ]; then
		echo ui_print 1>&$UPDATE_CMD_PIPE;
	fi
}
log () { echo "$@"; }
fatal() { ui_print "$@"; exit 1; }

REINIT=0
ui_print "checking if system partition needs re-init"

if tune2fs -l /dev/block/mmcblk0p1 | grep -q resize_inode; then 
		$echo "system partition needs re-init"
		REINIT=1
else
		if e2fsck -n /dev/block/mmcblk0p1; then
				$echo "system partition is OK"
				exit 0
		else
				$echo "system partition contains errors, repairing..."
				if $e2fsck -fp /dev/block/mmcblk0p1; then
						$echo "system partition repaired"
				else
						$echo "could not repair system partition"
						REINIT=1
				fi
		fi
fi

if [ $REINIT -eq 1 ]; then
		$echo "trying to re-initialize system partition"
		if ! mount | grep -q system && ! mount /system; then
				fatal "could not mount /system, aborting"
		fi
		if ! mount | grep -q sdcard && ! mount /sdcard; then
				fatal "could not mount /sdcard, aborting"
		fi;
		$echo "this will take a minute"
		$echo "DO NOT INTERRUPT!"
		$echo "saving system contents";
#		echo "show_progress 0.4 20" 1>&$UPDATE_CMD_PIPE
		if ! tar cvf /sdcard/system.tar /system; then
				fatal "tar exited with error, aborting"
		fi;
		$echo "formatting system"
#		echo "show_progress 0.2 10" 1>&$UPDATE_CMD_PIPE
		umount /system
		mke2fs /dev/block/mmcblk0p1
		tune2fs -O extents,uninit_bg,dir_index,has_journal /dev/block/mmcblk0p1
		e2fsck -pfC0 /dev/block/mmcblk0p1
		tune2fs -o journal_data_writeback /dev/block/mmcblk0p1
		e2fsck -pfDC0 /dev/block/mmcblk0p1
		$echo "mounting system"
		mount /dev/block/mmcblk0p1 /system
		$echo "restoring system contents";
#		echo "show_progress 0.4 20" 1>&$UPDATE_CMD_PIPE
		if /sbin/tar -C / -xvf /sdcard/system.tar; then
				$echo "restore successful"
				rm /sdcard/system.tar
		else
				$echo "restore NOT successful"
				$echo "keeping /sdcard/system.tar"
				$echo "try to restore manually with:"
				$echo "/sbin/tar -C / -xvf /sdcard/system.tar"
		fi
		$echo "unmounting system and sdcard"
		umount /system
		umount /sdcard
fi
exit 0