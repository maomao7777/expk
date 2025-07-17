#!/bin/sh
echo "Content-type: text/html"
echo ""

read POST_DATA
ACTION=$(echo "$POST_DATA" | grep -oE 'action=[^&]+' | cut -d= -f2)
ACTION=$(echo "$ACTION" | sed 's/+/ /g')
decoded_data=$(echo -e "$(printf "%b" "${POST_DATA//%/\\x}")")
SSID=$(echo "$decoded_data" | sed -n 's/.*ssid=\([^&]*\).*/\1/p')
PASS=$(echo "$decoded_data" | sed -n 's/.*password=\([^&]*\).*/\1/p')

case "$ACTION" in
    "Update WL Client")
        echo "update_config=1" > /storage/is_wlclt.conf
        echo "country=TW" >> /storage/is_wlclt.conf
        echo "network={" >> /storage/is_wlclt.conf
        echo "   ssid=$SSID" >> /storage/is_wlclt.conf
        echo "   key_mgmt=WPA-PSK" >> /storage/is_wlclt.conf
        echo "   psk=$PASS" >> /storage/is_wlclt.conf
        echo "}" >> /storage/is_wlclt.conf
        echo "<html><body><h1>WL Client Updated</h1>"
        echo "<p>Conneting SSID : $SSID</p>"
        echo "<p>Conneting Password: $PASS</p>"
        echo "<button onclick='location.href=\"/index.html\"'>Go Back</button>"
        echo "</body></html>"
        ;;
    "Update AP")
        rm /storage/is_wlclt.conf
        echo "SSID=$SSID" > /etc/ap_config
        echo "PASS=$PASS" >> /etc/ap_config
        echo "interface=wlan0" > /storage/hostapdStor.conf
        echo "bridge=br0" >> /storage/hostapdStor.conf
        echo "driver=nl80211" >> /storage/hostapdStor.conf
        echo "ssid=$SSID" >> /storage/hostapdStor.conf
        echo "hw_mode=g" >> /storage/hostapdStor.conf
        echo "channel=11" >> /storage/hostapdStor.conf
        echo "wpa=2" >> /storage/hostapdStor.conf
        echo "wpa_passphrase=$PASS" >> /storage/hostapdStor.conf
        echo "wpa_key_mgmt=WPA-PSK" >> /storage/hostapdStor.conf
        echo "rsn_pairwise=CCMP" >> /storage/hostapdStor.conf
        echo "ieee80211n=1" >> /storage/hostapdStor.conf
        echo "<html><body><h1>AP Updated</h1>"
        echo "<p>New SSID: $SSID</p>"
        echo "<p>New Password: $PASS</p>"
        echo "<button onclick='location.href=\"/index.html\"'>Go Back</button>"
        echo "</body></html>"
        ;;
    *)
        ;;
esac