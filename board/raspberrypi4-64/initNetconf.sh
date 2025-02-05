#!/bin/sh

BRIDGE_NAME="br0"
WIFI_INTERFACE="wlan0"
ETHERNET_INTERFACE="eth0"
INIT_STATIC_IP="192.168.0.15"
INIT_WL_FILE="/storage/hostapdStor.conf"
TARGET_WL_LINK="/etc/hostapdTest.conf"


mkdir -p /run/network

case "$1" in
  start)
	printf "init network config: "
	modprobe brcmfmac
	modprobe cfg80211
	sleep 0.5
	ifconfig $WIFI_INTERFACE down
	ifconfig $ETHERNET_INTERFACE down
	brctl addbr $BRIDGE_NAME
	brctl addif $BRIDGE_NAME $WIFI_INTERFACE
	brctl addif $BRIDGE_NAME $ETHERNET_INTERFACE
	ifconfig $WIFI_INTERFACE up
	ifconfig $ETHERNET_INTERFACE up
	ifconfig $BRIDGE_NAME $INIT_STATIC_IP up
	ifconfig lo up
	udhcpc -i $BRIDGE_NAME -s /etc/exdhcpc.script -b
	if [ -f "$INIT_WL_FILE" ]; then
		if [ -e "$TARGET_WL_LINK" ]; then
			rm -f "$TARGET_WL_LINK"
			echo "Removed existing $TARGET_WL_LINK."
		fi
		ln -s "$INIT_WL_FILE" "$TARGET_WL_LINK"
		echo "Linked $INIT_WL_FILE to $TARGET_WL_LINK."
	else
    	echo "$INIT_WL_FILE does not exist using orig_df."
	fi
	hostapd -B $TARGET_WL_LINK
	httpd -h /root/web -c /etc/httpd.conf -v
	telnetd
	;;
  stop)
	printf "uninit network config: "
	;;
  restart|reload)
	"$0" stop
	"$0" start
	;;
  *)
	echo "Usage: $0 {start|stop|restart}"
	exit 1
esac

exit $?
