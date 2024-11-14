sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
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
    UUID=$(curl http://3.133.104.114:3000/?proxyrack=$ip1)
    sleep 2
    echo $ip1
    sleep 2
    sudo docker run -d --network my_network_$i --restart=always --name traff_$i traffmonetizer/cli_v2 start accept --token cCuCGOWZXNnk9dL5BR+cz1QHbjCdXJnFb8e3a9OAS2k= --device-name $ip1
    sudo docker run -d --network my_network_$i --restart=always --name repocket_$i -e RP_EMAIL=nguyentanloc180@gmail.com -e RP_API_KEY=8873dd7c-f936-4deb-b128-c15dc54813da repocket/repocket
    sudo docker run -d --network my_network_$i --restart unless-stopped --name packetshare_$i packetshare/packetshare -accept-tos -email=locpaypal@gmail.com -password=Loc123456789
    sudo docker run -d --network my_network_$i --restart=always --name proxyrack_$i -e UUID="$UUID" proxyrack/pop
    i=$((i + 1))
  done
else
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
    UUID=$(curl http://3.133.104.114:3000/?proxyrack=$ip1)
    sleep 2
    echo $ip1
    sleep 2
    sudo docker run -d --network my_network_$i --restart=always --name traff_$i traffmonetizer/cli_v2 start accept --token cCuCGOWZXNnk9dL5BR+cz1QHbjCdXJnFb8e3a9OAS2k= --device-name $ip1
    sudo docker run -d --network my_network_$i --restart=always --name repocket_$i -e RP_EMAIL=nguyentanloc180@gmail.com -e RP_API_KEY=8873dd7c-f936-4deb-b128-c15dc54813da repocket/repocket
    sudo docker run -d --network my_network_$i --restart unless-stopped --name packetshare_$i packetshare/packetshare -accept-tos -email=locpaypal@gmail.com -password=Loc123456789
    sudo docker run -d --network my_network_$i --restart=always --name proxyrack_$i -e UUID="$UUID" proxyrack/pop
    i=$((i + 1))
  done
fi
