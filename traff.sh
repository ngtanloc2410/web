sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
list=()
if ip link show enX0 > /dev/null 2>&1; then
  # Get IP addresses for enX0
  ip_addresses=$(ip addr show enX0 | awk '/inet / {print $2}' | cut -d'/' -f1)
  i=3

  # Print the IP addresses and execute Docker commands
  echo "IP Addresses:"
  for ip in $ip_addresses; do
    sudo docker network create my_network_$i --driver bridge --subnet 192.168.3$i.0/24
    sudo iptables -t nat -I POSTROUTING -s 192.168.3$i.0/24 -j SNAT --to-source $ip
    sleep 2
    container_id=$(sudo docker run -d --network my_network_$i alpine/curl curl -s -4 icanhazip.com)
    sleep 2
    ip1=$(sudo docker logs $container_id)
    sleep 2
    echo $ip1
    sleep 2
    sudo docker run -d --network my_network_$i --name traff_$i traffmonetizer/cli_v2 start accept --token cCuCGOWZXNnk9dL5BR+cz1QHbjCdXJnFb8e3a9OAS2k= --device-name $ip1
    sudo docker run -d --network my_network_$i --name repocket_$i -e RP_EMAIL=nguyentanloc180@gmail.com -e RP_API_KEY=8873dd7c-f936-4deb-b128-c15dc54813da --restart=always repocket/repocket
    UUID=$(cat /dev/urandom | LC_ALL=C tr -dc 'A-F0-9' | dd bs=1 count=64 2>/dev/null && echo)
    sudo docker run -d --network my_network_$i --name proxyrack_$i --restart always -e UUID="$UUID" proxyrack/pop
    list=("${list[@]}" "$UUID|$ip1")
    #sudo docker run -d --restart unless-stopped --network my_network_$i --name packetshare_$i packetshare/packetshare -accept-tos -email=locpaypal@gmail.com -password=Loc123456789
    i=$((i + 1))
  done
else
  # Get IP addresses for ens5
  ip_addresses=$(ip addr show ens5 | awk '/inet / {print $2}' | cut -d'/' -f1)
  i=3

  # Print the IP addresses and execute Docker commands
  echo "IP Addresses:"
  for ip in $ip_addresses; do
    sudo docker network create my_network_$i --driver bridge --subnet 192.168.3$i.0/24
    sudo iptables -t nat -I POSTROUTING -s 192.168.3$i.0/24 -j SNAT --to-source $ip
    sleep 2
    container_id=$(sudo docker run -d --network my_network_$i alpine/curl curl -s -4 icanhazip.com)
    sleep 2
    ip1=$(sudo docker logs $container_id)
    sleep 2
    echo $ip1
    sleep 2
    sudo docker run -d --network my_network_$i --name tm_$i traffmonetizer/cli_v2 start accept --token cCuCGOWZXNnk9dL5BR+cz1QHbjCdXJnFb8e3a9OAS2k= --device-name $ip1
    sudo docker run -d --network my_network_$i --name repocket_$i -e RP_EMAIL=nguyentanloc180@gmail.com -e RP_API_KEY=8873dd7c-f936-4deb-b128-c15dc54813da --restart=always repocket/repocket
    UUID=$(cat /dev/urandom | LC_ALL=C tr -dc 'A-F0-9' | dd bs=1 count=64 2>/dev/null && echo)
    sudo docker run -d --network my_network_$i --name proxyrack_$i --restart always -e UUID="$UUID" proxyrack/pop
    list=("${list[@]}" "$UUID|$ip1")
    #sudo docker run -d --restart unless-stopped --network my_network_$i --name packetshare_$i packetshare/packetshare -accept-tos -email=locpaypal@gmail.com -password=Loc123456789
    i=$((i + 1))
  done
fi
for dem in $(seq 1 120)
do
clear
echo "Time remaining : $((120 - dem)) seconds"
sleep 1
done
echo "\nTime's up!"
for i in "${list[@]}"; do
echo "$i"
b=${i%|*}
c=${i##*|}
curl -X POST https://peer.proxyrack.com/api/device/add -H "Api-Key: SYNVQSYZKHMA9IYBFA95A30OMONZXF3RKPFWDHWL" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"device_id":"'"$b"'","device_name":"'"$c"'"}'
sleep 30
done
