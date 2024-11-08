list=()
if ip link show enX0 > /dev/null 2>&1; then
  # Get IP addresses for enX0
  ip_addresses=$(ip addr show enX0 | awk '/inet / {print $2}' | cut -d'/' -f1)
  i=3
  # Print the IP addresses and execute Docker commands
  echo "IP Addresses:"
  for ip in $ip_addresses; do
    container_id=$(sudo docker run -d --network my_network_$i alpine/curl curl -s -4 icanhazip.com)
    sleep 2
    ip=$(sudo docker logs $container_id)
    sleep 2
    UUID=$(cat /dev/urandom | LC_ALL=C tr -dc 'A-F0-9' | dd bs=1 count=64 2>/dev/null && echo)
    sudo docker run -d --network my_network_$i --name proxyrack_$i --restart always -e UUID="$UUID" proxyrack/pop
    list=("${list[@]}" "$UUID|$ip")
    i=$((i + 1))
  done
else
  # Get IP addresses for ens5
  ip_addresses=$(ip addr show ens5 | awk '/inet / {print $2}' | cut -d'/' -f1)
  i=3
  # Print the IP addresses and execute Docker commands
  echo "IP Addresses:"
  for ip in $ip_addresses; do
    container_id=$(sudo docker run -d --network my_network_$i alpine/curl curl -s -4 icanhazip.com)
    sleep 2
    ip=$(sudo docker logs $container_id)
    sleep 2
    UUID=$(cat /dev/urandom | LC_ALL=C tr -dc 'A-F0-9' | dd bs=1 count=64 2>/dev/null && echo)
    sudo docker run -d --network my_network_$i --name proxyrack_$i --restart always -e UUID="$UUID" proxyrack/pop
    list=("${list[@]}" "$UUID|$ip")
    i=$((i + 1))
  done
fi
for dem in $(seq 1 90)
do
clear
echo "Time remaining : $((90 - dem)) seconds"
sleep 1
done
echo "\nTime's up!"
for i in "${list[@]}"; do
echo "$i"
b=${i%|*}
c=${i##*|}
curl -X POST https://peer.proxyrack.com/api/device/add -H "Api-Key: NQ9WEFFMDQ8TTUUKDLHMPW6IEXVEBBB8RGDCPIOU" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"device_id":"'"$b"'","device_name":"'"$c"'"}'
for dem in $(seq 1 30)
do
printf "%d\r" "$((30 - dem))"
sleep 1
done
done
