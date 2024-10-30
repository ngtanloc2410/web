#!/bin/bash

# Get the IP addresses from the command output
ip_addresses=$(ip addr show enX0 | awk '/inet / {print $2}' | cut -d'/' -f1)

# Convert the string to an array (optional)
ip_addresses_array=(${ip_addresses// / })  # Split by spaces (if needed)

# Print the IP addresses
echo "IP Addresses:"
for ip in "${ip_addresses[@]}"; do
  echo "- $ip"
done
