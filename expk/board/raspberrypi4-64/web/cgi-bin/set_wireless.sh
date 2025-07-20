#!/bin/sh
IS_WLAP_CONF=/storage/is_wlap.conf
IS_WLCLT_CONF=/storage/is_wlclt.conf

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
        echo "update_config=1" > $IS_WLCLT_CONF
        echo "country=TW" >> $IS_WLCLT_CONF
        echo "network={" >> $IS_WLCLT_CONF
        echo "   ssid=\"$SSID\"" >> $IS_WLCLT_CONF
        echo "   key_mgmt=WPA-PSK" >> $IS_WLCLT_CONF
        echo "   psk=\"$PASS\"" >> $IS_WLCLT_CONF
        echo "}" >> $IS_WLCLT_CONF
        echo "<html><body><h1>WL Client Updated</h1>"
        echo "<p>Conneting SSID : $SSID</p>"
        echo "<p>Conneting Password: $PASS</p>"
        echo "<button onclick='location.href=\"/index.html\"'>Go Back</button>"
        echo "</body></html>"
        ;;
    "Update AP")
        rm $IS_WLCLT_CONF
        echo "SSID=$SSID" > /etc/ap_config
        echo "PASS=$PASS" >> /etc/ap_config
        echo "interface=wlan0" > $IS_WLAP_CONF
        echo "bridge=br0" >> $IS_WLAP_CONF
        echo "driver=nl80211" >> $IS_WLAP_CONF
        echo "ssid=$SSID" >> $IS_WLAP_CONF
        echo "hw_mode=g" >> $IS_WLAP_CONF
        echo "channel=11" >> $IS_WLAP_CONF
        echo "wpa=2" >> $IS_WLAP_CONF
        echo "wpa_passphrase=$PASS" >> $IS_WLAP_CONF
        echo "wpa_key_mgmt=WPA-PSK" >> $IS_WLAP_CONF
        echo "rsn_pairwise=CCMP" >> $IS_WLAP_CONF
        echo "ieee80211n=1" >> $IS_WLAP_CONF
        echo "<html><body><h1>AP Updated</h1>"
        echo "<p>New SSID: $SSID</p>"
        echo "<p>New Password: $PASS</p>"
        echo "<button onclick='location.href=\"/index.html\"'>Go Back</button>"
        echo "</body></html>"
        ;;
    *)
        ;;
esac