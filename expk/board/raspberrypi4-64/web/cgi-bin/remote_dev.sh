#!/bin/sh
echo "Content-type: text/html"
echo ""

read POST_DATA
decoded_data=$(echo "$POST_DATA" | sed 's/+/ /g')
decoded_data=$(echo -e "$(printf "%b" "${decoded_data//%/\\x}")")
CMD=$(echo "$decoded_data" | sed -n 's/.*remote_cmd=\([^&]*\).*/\1/p')
myctrl $CMD > /tmp/myout
echo "<html><body><h1>Remote Device</h1>"
echo "<p>CMD: $CMD</p>"
echo "<p>"
cat /tmp/myout
echo "</p>"
echo "<button onclick='location.href=\"/index.html\"'>Go Back</button>"
echo "</body></html>"
