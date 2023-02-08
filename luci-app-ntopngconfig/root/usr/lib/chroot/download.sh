#!/bin/sh

free=$(df /usr/lib/ -P | awk 'NR==2{print$4}')

if [ $free -le 3145728 ]; then
        echo "Not enough space available"
else
        echo "Removing existing image"
        rm /usr/lib/chroot/smoothwan.img
        echo "Downloading image..."
        aria2c -x3 https://github.com/SmoothWAN/SmoothWAN-chroot-imagebuilder/releases/download/main/smoothwan_debuster_$(uname -m).img.gz -d /usr/lib/chroot -o smoothwan.img.gz
        echo "Extracting image..."
        gunzip -c /usr/lib/chroot/smoothwan.img.gz > /usr/lib/chroot/smoothwan.img
        /etc/init.d/ntopngconf restart
        echo "ntopngconf service restarted."
fi