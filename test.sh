#!/bin/bash

# Get the IP addresses from the `ip addr` command
ip_addresses=($(ip addr show enX0 | awk '/inet / {print $2}' | cut -d'/' -f1))

# Iterate through each IP address
for ip_address in "${ip_addresses[@]}"; do
  echo "IP address: $ip_address"
  # You can add your desired actions here, like writing to a file, executing commands, etc.
  # For example, to write each IP address to a new line in a file named "ip_addresses.txt":
  echo "$ip_address" >> ip_addresses.txt
done
