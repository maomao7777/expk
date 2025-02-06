#!/bin/sh

CONTENT_LENGTH=$(env | grep CONTENT_LENGTH | cut -d= -f2)
[ -z "$CONTENT_LENGTH" ] && echo "Content-Length not found" && exit 1

tail -n +5 > /tmp/rpi4fw.rom
echo "Content-type: text/html"
echo ""
echo "<html><head>"
echo "<meta http-equiv='refresh' content='10;url=/index.html'>"
echo "</head>"
echo "<body><h1>fw upload successfull</h1>"
echo "<p>fw update starting</p>"
echo "</body></html>"
/etc/fwupd.sh -i /tmp/rpi4fw.rom > /dev/console &