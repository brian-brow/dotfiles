#!/bin/bash

# Get unique networks (deduplicate by SSID, keep highest signal)
networks=$(nmcli -t -f SSID,SECURITY,SIGNAL dev wifi list |
  awk -F: '
  {
    ssid = $1;
    sec = $2;
    sig = $3;
    
    # Skip empty SSIDs
    if (ssid == "") next;
    
    # Keep only the highest signal for each SSID
    if (!seen[ssid] || sig > signal[ssid]) {
      seen[ssid] = 1;
      signal[ssid] = sig;
      security[ssid] = sec;
      data[ssid] = ssid ":" sec ":" sig;
    }
  }
  END {
    for (ssid in seen) {
      print data[ssid];
    }
  }' | sort -t: -k3 -rn)

# Format for display
formatted=$(echo "$networks" | awk -F: '{
    ssid = $1;
    sec = $2;
    sig = $3;
    
    # Format security
    if (sec == "") sec_icon = "   ";
    else if (sec ~ /802.1X/) sec_icon = " ";
    else sec_icon = " ";
    
    # Format signal bars
    if (sig >= 75) bars = "▂▄▆█";
    else if (sig >= 50) bars = "▂▄▆ ";
    else if (sig >= 25) bars = "▂▄  ";
    else bars = "▂   ";
    
    printf "%s%s %s (%s%%)\n", sec_icon, ssid, bars, sig;
}')

# Show in rofi
selected=$(echo "$formatted" | rofi -dmenu -i -p "WiFi" -format "s")

if [ -n "$selected" ]; then
  # Extract SSID from formatted line - more robust extraction
  # Remove security icon, signal bars, and percentage
  ssid=$(echo "$selected" | sed -E 's/^( | |   )//; s/ [▂▄▆█ ]+ \([0-9]+%\)$//')

  # Get security type for this SSID
  security=$(echo "$networks" | awk -F: -v s="$ssid" '$1 == s {print $2; exit}')

  # Handle 802.1X (enterprise) networks
  if echo "$security" | grep -q "802.1X"; then
    notify-send "WiFi" "Enterprise networks (802.1X) like eduroam require special configuration. Use your university's SecureW2 script or nmtui."
  elif [ "$security" != "" ]; then
    password=$(rofi -dmenu -password -p "Password for $ssid")
    if [ -n "$password" ]; then
      nmcli dev wifi connect "$ssid" password "$password" &&
        notify-send "WiFi" "Connected to $ssid" ||
        notify-send "WiFi" "Failed to connect to $ssid"
    fi
  else
    nmcli dev wifi connect "$ssid" &&
      notify-send "WiFi" "Connected to $ssid" ||
      notify-send "WiFi" "Failed to connect to $ssid"
  fi
fi
