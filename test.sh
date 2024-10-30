#!/bin/bash

# Get the IP addresses from the command output
ip_addresses=$(ip addr show enX0 | awk '/inet / {print $2}' | cut -d'/' -f1)

# Print the IP addresses
echo "IP Addresses:"
for ip in "${ip_addresses[@]}"; do
  echo "- $ip"
done
