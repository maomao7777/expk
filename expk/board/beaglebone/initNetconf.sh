#!/bin/sh

mkdir -p /run/network

case "$1" in
  start)
	printf "init network config: "
	# /sbin/ifup -a
	;;
  stop)
	printf "uninit network config: "
	# /sbin/ifdown -a
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
