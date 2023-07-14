#!/bin/bash

echo "hdtemp.sh v0.1 - bash script displays the temperature of hd/nvme disks"
echo " "
echo "--help show usage of script"
echo " "

get_disk_temperature() {
    local disk_path=$1
    local temperature=$(smartctl -a "$disk_path" 2>/dev/null | awk '/Temperature_Celsius/ { print $10 }')

    if [[ -n $temperature ]]; then
        echo "$temperature°C"
    else
        echo "Disk temperature is not available."
    fi
}

display_usage() {
    echo "Usage: $0 [disk_name]"
    echo "disk_name (optional): Name of the disk to display the temperature."
    echo "If not provided, temperatures for all eligible disks will be displayed."
    echo "Package smartmontools is mandatory."
}

main() {
    if [[ $1 == "--help" ]]; then
        display_usage
        exit 0
    fi

    if [[ -n $1 ]]; then
        local disk_path="/dev/$1"
        if [[ -e $disk_path ]]; then
            get_disk_temperature "$disk_path"
        else
            echo "Error: Disk $1 does not exist."
            exit 1
        fi
    else
        local disks_output=$(lsblk -d -n -o NAME)
        for disk in ${disks_output[@]}; do
            if [[ $disk == sd* || $disk == nvme* ]]; then
                local disk_path="/dev/$disk"
                echo "Disk temperature for $disk: $(get_disk_temperature "$disk_path")"
            fi
        done
    fi
}

main "$@"
