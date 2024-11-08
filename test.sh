#!/bin/bash

UUID=$(cat /dev/urandom | LC_ALL=C tr -dc 'A-F0-9' | dd bs=1 count=64 2>/dev/null && echo)
sudo docker run -d --name proxyrack --restart always -e UUID="$UUID" proxyrack/pop
ip=$(curl -4 icanhazip.com)

clear
echo "IP Address: $ip"
echo "UUID: $UUID"

countdown_time=120
for ((i=$countdown_time; i>0; i--)); do
  echo -ne "Time remaining: $i seconds\r"
  sleep 1  # Wait for 1 second
done

echo -e "\nTime's up!"
curl -X POST https://peer.proxyrack.com/api/device/add -H "Api-Key: SYNVQSYZKHMA9IYBFA95A30OMONZXF3RKPFWDHWL" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"device_id":"'"$UUID"'","device_name":"'"$ip"'"}'
