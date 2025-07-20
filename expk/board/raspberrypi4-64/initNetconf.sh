#!/bin/sh

BRIDGE_NAME="br0"
WIFI_INTERFACE="wlan0"
ETHERNET_INTERFACE="eth0"
INIT_STATIC_IP="192.168.0.15"
TARGET_WL_LINK="/etc/hostapdTest.conf"
IS_WLAP_CONF=/storage/is_wlap.conf
IS_WLCLT_CONF=/storage/is_wlclt.conf


mkdir -p /run/network

case "$1" in
  start)
	printf "init network config: "
	modprobe brcmfmac
	modprobe cfg80211
	sleep 0.5
	ifconfig $WIFI_INTERFACE down
	ifconfig $ETHERNET_INTERFACE down
	if [ -f "$IS_WLCLT_CONF" ]; then
	echo "wireless client mode detected"
	else
	echo "wireless ap mode detected"
	brctl addbr $BRIDGE_NAME
	brctl addif $BRIDGE_NAME $ETHERNET_INTERFACE
	fi
	ifconfig $WIFI_INTERFACE up
	ifconfig $ETHERNET_INTERFACE up
	ifconfig $BRIDGE_NAME $INIT_STATIC_IP up
	ifconfig lo up
	if [ -f "$IS_WLCLT_CONF" ]; then
	wpa_supplicant -B -i $WIFI_INTERFACE -c $IS_WLCLT_CONF
	udhcpc -i $WIFI_INTERFACE -s /etc/exdhcpc.script -b
	else
	udhcpc -i $BRIDGE_NAME -s /etc/exdhcpc.script -b
	if [ -f "$IS_WLAP_CONF" ]; then
	echo "setup ap through $IS_WLAP_CONF."
	hostapd -B $IS_WLAP_CONF
	else
	echo "$IS_WLAP_CONF does not exist using orig_df."
	hostapd -B $TARGET_WL_LINK
	fi
	fi
	httpd -h /root/web -c /etc/httpd.conf -v
	telnetd
	rdate -s time.nist.gov &
	echo "export TZ=\"CST-8\"" > /etc/profile.d/tz.sh
	mytestd -a &
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
