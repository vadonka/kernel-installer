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

##############################################################
# hier kannst du alles hinzufügen, was du ändern willst      #
# Man muss immer ein Leerzeichen vor und nach dem "=" machen #
# add befehl fügt Sachen hinzu oder ändert sie               #
# del befehl löscht build.prop Einträge                      #
##############################################################

# Beispiele

## Nitro Lag Notifier
add ENFORCE_PROCESS_LIMIT = false
add MAX_SERVICE_INACTIVITY = 
add MIN_HIDDEN_APPS = 
add MAX_HIDDEN_APPS = 
add CONTENT_APP_IDLE_OFFSET = 
add EMPTY_APP_IDLE_OFFSET = 
add MAX_ACTIVITIES = 
add ACTIVITY_INACTIVE_RESET_TIME = 
