sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
ip=$(curl -4 icanhazip.com)
echo $ip
sudo docker run -d --name traff traffmonetizer/cli_v2 start accept --token cCuCGOWZXNnk9dL5BR+cz1QHbjCdXJnFb8e3a9OAS2k= --device-name $ip
sudo docker run -d --name repocket -e RP_EMAIL=nguyentanloc180@gmail.com -e RP_API_KEY=8873dd7c-f936-4deb-b128-c15dc54813da --restart=always repocket/repocket
UUID=$(cat /dev/urandom | LC_ALL=C tr -dc 'A-F0-9' | dd bs=1 count=64 2>/dev/null && echo)
sudo docker run -d --name proxyrack --restart always -e UUID="$UUID" proxyrack/pop
for dem in $(seq 1 90)
do
clear
echo "Time remaining : $((90 - dem)) seconds"
sleep 1
done
curl -X POST https://peer.proxyrack.com/api/device/add -H "Api-Key: NQ9WEFFMDQ8TTUUKDLHMPW6IEXVEBBB8RGDCPIOU" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"device_id":"'"$UUID"'","device_name":"'"$ip"'"}'
