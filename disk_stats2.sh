#!/bin/bash

# Detect disks
disks=$(lsblk -d -n -o NAME,TYPE | grep -E 'disk|nvme' | awk '{print "/dev/"$1}')

# Check if smartmontools package is installed
if ! command -v smartctl &> /dev/null; then
    echo "Please install smartmontools package."
    exit 1
fi

# Loop through each disk and display information
for disk in $disks; do
    echo "Disk: $disk"
    echo "--------------"

    # Extract disk information
    temperature=$(smartctl -A $disk | awk '/Temperature_Celsius/ {print $10}')
    status=$(smartctl -H $disk | awk '/SMART overall-health self-assessment/ {print $NF}')
    serial=$(smartctl -i $disk | awk '/Serial Number:/ {print $NF}')
    power_on_hours=$(smartctl -A $disk | awk '/Power_On_Hours/ {print $10}')
    device_model=$(smartctl -i $disk | awk '/Device Model:/ {print substr($0, index($0,$3))}')

    # Display disk information
    echo "Temperature: $temperature°C"
    echo "Status: $status"
    echo "Serial Number: $serial"
    echo "Power On Hours: $power_on_hours"
    echo "Device Model: $device_model"
    echo "--------------"
done
