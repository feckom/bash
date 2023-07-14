#!/bin/bash

# Get all disk devices
disk_devices=$(lsblk -ndo NAME)

# Iterate through each disk device
for device in $disk_devices; do
  # Skip non-disk devices (e.g., partitions)
  if [[ ! $device =~ ^[sh]d[a-z]$ ]]; then
    continue
  fi

  echo "Disk: /dev/$device"

  # Get disk serial number
  serial_number=$(smartctl -i /dev/$device | awk '/Serial Number:/ {print $3}')
  echo "SN: $serial_number"

  # Get disk power-on hours
  hours_on=$(smartctl -a /dev/$device | awk '/Power_On_Hours/ {print $10}')
  echo "Hours On: $hours_on"

  # Get disk size
  disk_size=$(lsblk -nbdo SIZE /dev/$device)
  echo "Disk Size: $disk_size"

  # Get disk model
  model=$(smartctl -i /dev/$device | awk '/Device Model:/ {print substr($0, index($0,$3))}')
  echo "Model: $model"

  # Get disk health status
  health_status=$(smartctl -H /dev/$device | awk '/SMART overall-health/ {print $NF}')
  echo "Health Status: $health_status"

  echo
done
