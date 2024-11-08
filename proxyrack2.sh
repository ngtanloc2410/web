UUID=$(cat /dev/urandom | LC_ALL=C tr -dc 'A-F0-9' | dd bs=1 count=64 2>/dev/null && echo)
sudo docker run -d --name proxyrack --restart always -e UUID="$UUID" proxyrack/pop
ip=$(curl -4 icanhazip.com)
echo $ip
for dem in $(seq 1 90)
do
clear
echo "Time remaining : $((90 - dem)) seconds"
sleep 1
done
echo "\nTime's up!"
curl -X POST https://peer.proxyrack.com/api/device/add -H "Api-Key: NQ9WEFFMDQ8TTUUKDLHMPW6IEXVEBBB8RGDCPIOU" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"device_id":"'"$UUID"'","device_name":"'"$ip"'"}'
