sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
ip=$(curl -4 icanhazip.com)
UUID=$(curl http://3.133.104.114:3000/?proxyrack=$ip)
echo $ip
sudo docker run -d --restart=always --name traff traffmonetizer/cli_v2 start accept --token cCuCGOWZXNnk9dL5BR+cz1QHbjCdXJnFb8e3a9OAS2k= --device-name $ip
sudo docker run -d --restart=always --name repocket -e RP_EMAIL=nguyentanloc180@gmail.com -e RP_API_KEY=8873dd7c-f936-4deb-b128-c15dc54813da repocket/repocket
sudo docker run -d --restart unless-stopped packetshare/packetshare -accept-tos -email=locpaypal@gmail.com -password=Loc123456789
sudo docker run -d --restart=always --name proxyrack -e UUID="$UUID" proxyrack/pop
