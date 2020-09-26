#!/bin/bash

### add dtoverlay=dwc2 to /boot/config.txt
echo "dtoverlay=dwc2" >> /boot/config.txt

### add modules-load=dwc2 to /boot/cmdline.txt
echo "modules-load=dwc2" >> /boot/cmdline.txt

### create /boot/ssh
touch /boot/ssh

### add libcomposite to /etc/modules
echo "libcomposite" >> /etc/modules

### add denyinterfaces usb0 to /etc/dhcpcd.conf
echo "denyinterfaces usb0" >> /etc/dhcpcd.conf

### install dnsmasq with apt-get install dnsmasq
apt-get install -y dnsmasq

### create /etc/dnsmasq.d/usb
touch /etc/dnsmasq.d/usb
echo "interface=usb0" >> /etc/dnsmasq.d/usb
echo "dhcp-range=10.55.0.2,10.55.0.6,255.255.255.248,1h" >> /etc/dnsmasq.d/usb
echo "dhcp-option=3" >> /etc/dnsmasq.d/usb
echo "leasefile-ro" >> /etc/dnsmasq.d/usb

### create /etc/network/interfaces.d/usb0
touch /etc/network/interfaces.d/usb0
echo "auto usb0" >> /etc/network/interfaces.d/usb0
echo "allow-hotplug usb0" >> /etc/network/interfaces.d/usb0
echo "iface usb0 inet static" >> /etc/network/interfaces.d/usb0
echo "  address 10.55.0.1" >> /etc/network/interfaces.d/usb0
echo "  netmask 255.255.255.248" >> /etc/network/interfaces.d/usb0

### create /root/usb.sh
touch /root/usb.sh
echo "#!/bin/bash" >> /root/usb.sh
echo "cd /sys/kernel/config/usb_gadget/" >> /root/usb.sh
echo "mkdir -p pi4" >> /root/usb.sh
echo "cd pi4" >> /root/usb.sh
echo "echo 0x1d6b > idVendor # Linux Foundation" >> /root/usb.sh
echo "echo 0x0104 > idProduct # Multifunction Composite Gadget" >> /root/usb.sh
echo "echo 0x0100 > bcdDevice # v1.0.0" >> /root/usb.sh
echo "echo 0x0200 > bcdUSB # USB2" >> /root/usb.sh
echo "echo 0xEF > bDeviceClass" >> /root/usb.sh
echo "echo 0x02 > bDeviceSubClass" >> /root/usb.sh
echo "echo 0x01 > bDeviceProtocol" >> /root/usb.sh
echo "mkdir -p strings/0x409" >> /root/usb.sh
echo "echo \"fedcba9876543211\" > strings/0x409/serialnumber" >> /root/usb.sh
echo "echo \"Ben Hardill\" > strings/0x409/manufacturer" >> /root/usb.sh
echo "echo \"PI4 USB Device\" > strings/0x409/product" >> /root/usb.sh
echo "mkdir -p configs/c.1/strings/0x409" >> /root/usb.sh
echo "echo \"Config 1: ECM network\" > configs/c.1/strings/0x409/configuration" >> /root/usb.sh
echo "echo 250 > configs/c.1/MaxPower" >> /root/usb.sh
echo "# Add functions here" >> /root/usb.sh
echo "# see gadget configurations below" >> /root/usb.sh
echo "# End functions" >> /root/usb.sh
echo "mkdir -p functions/ecm.usb0" >> /root/usb.sh
echo "HOST=\"00:dc:c8:f7:75:14\" # \"HostPC\"" >> /root/usb.sh
echo "SELF=\"00:dd:dc:eb:6d:a1\" # \"BadUSB\"" >> /root/usb.sh
echo "echo \$HOST > functions/ecm.usb0/host_addr" >> /root/usb.sh
echo "echo \$SELF > functions/ecm.usb0/dev_addr" >> /root/usb.sh
echo "ln -s functions/ecm.usb0 configs/c.1/" >> /root/usb.sh
echo "udevadm settle -t 5 || :" >> /root/usb.sh
echo "ls /sys/class/udc > UDC" >> /root/usb.sh
echo "ifup usb0" >> /root/usb.sh
echo "service dnsmasq restart" >> /root/usb.sh

### make /root/usb.sh executable
chmod +x /root/usb.sh

### /root/usb.sh to /etc/rc.local before exit 0
sed -i 's/exit 0/\/root\/usb.sh\n\nexit 0/g' /etc/rc.local

# EOF
