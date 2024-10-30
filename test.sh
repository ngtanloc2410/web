#!/bin/bash
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y 
sudo apt update -y && sudo apt upgrade -y
# Get the IP addresses from the command output
ip_addresses=$(ip addr show ens5 | awk '/inet / {print $2}' | cut -d'/' -f1)
i=3
# Print the IP addresses
echo "IP Addresses:"
for ip in $ip_addresses; do
  sudo docker network create my_network_$i --driver bridge --subnet 192.168.3$i.0/24
  sudo iptables -t nat -I POSTROUTING -s 192.168.3$i.0/24 -j SNAT --to-source $ip
  sudo docker run -d --network my_network_$i --name tm_$i traffmonetizer/cli_v2 start accept --token cCuCGOWZXNnk9dL5BR+cz1QHbjCdXJnFb8e3a9OAS2k= && sudo docker run -d --network my_network_$i --name repocket_$i -e RP_EMAIL=nguyentanloc180@gmail.com -e RP_API_KEY=8873dd7c-f936-4deb-b128-c15dc54813da -d --restart=always repocket/repocket
  i=$((i + 1))
done
