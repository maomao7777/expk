#!/bin/sh
echo "Content-type: text/html"
echo ""
echo "<html><head>"
echo "<meta http-equiv='refresh' content='3;url=/index.html'>"
echo "</head><body>"
echo "<h1>Applying Reboot...</h1>"
echo "<p>System will reboot shortly. Redirecting...</p>"
echo "</body></html>"
reboot
