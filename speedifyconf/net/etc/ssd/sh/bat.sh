#!/bin/sh
INPUT="/sys/bus/i2c/devices/1-0042/hwmon/hwmon1/curr1_input"
if [ ! -f "$INPUT" ]; then
    echo NC
    exit 0
fi

if [[ $(cat "$INPUT" | cut -b 1) != "-" ]]; then
        echo "CHG"
else
        VC=$(cat /sys/bus/i2c/devices/1-0042/hwmon/hwmon1/in1_input)
        if [[ $VC -le 8000 ]]; then
                echo "scale=2; ($VC - 6000) / 2400 * 100" | bc | sed 's!\.0*$!!' | tr -d '\n'
        echo -n "%"
        else
                echo -n "100"
        fi
fi