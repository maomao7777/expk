#!/bin/sh
echo "Content-type: text/html"
echo ""

read POST_DATA
CMD=$(echo "$POST_DATA" | sed -n 's/.*remote_cmd=\([^&]*\).*/\1/p')
myctrl $CMD > /tmp/myout
echo "<html><body><h1>Remote Device</h1>"
echo "<p>CMD: $CMD</p>"
echo "<p>"
cat /tmp/myout
echo "</p>"
echo "<button onclick='location.href=\"/index.html\"'>Go Back</button>"
echo "</body></html>"
