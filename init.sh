#!/bin/bash

### add dtoverlay=dwc2 to /boot/config.txt
sudo echo "dtoverlay=dwc2" >> /boot/config.txt

### add modules-load=dwc2 to /boot/cmdline.txt
sudo echo "modules-load=dwc2" >> /boot/cmdline.txt

### create /boot/ssh
sudo touch /boot/ssh

### add libcomposite to /etc/modules
sudo echo "libcomposite" >> /etc/modules

### add denyinterfaces usb0 to /etc/dhcpcd.conf
sudo echo "denyinterfaces usb0" >> /etc/dhcpcd.conf

### install dnsmasq with sudo apt-get install dnsmasq
sudo apt-get install dnsmasq

### create /etc/dnsmasq.d/usb
sudo touch /etc/dnsmasq.d/usb
sudo echo "interface=usb0" >> /etc/dnsmasq.d/usb
sudo echo "dhcp-range=10.55.0.2,10.55.0.6,255.255.255.248,1h" >> /etc/dnsmasq.d/usb
sudo echo "dhcp-option=3" >> /etc/dnsmasq.d/usb
sudo echo "leasefile-ro" >> /etc/dnsmasq.d/usb

### create /etc/network/interfaces.d/usb0
sudo touch /etc/network/interfaces.d/usb0
sudo echo "auto usb0" >> /etc/network/interfaces.d/usb0
sudo echo "allow-hotplug usb0" >> /etc/network/interfaces.d/usb0
sudo echo "iface usb0 inet static" >> /etc/network/interfaces.d/usb0
sudo echo "  address 10.55.0.1" >> /etc/network/interfaces.d/usb0
sudo echo "  netmask 255.255.255.248" >> /etc/network/interfaces.d/usb0

### create /root/usb.sh
sudo touch /root/usb
sudo echo "#!/bin/bash" >> /root/usb
sudo echo "cd /sys/kernel/config/usb_gadget/" >> /root/usb
sudo echo "mkdir -p pi4" >> /root/usb
sudo echo "cd pi4" >> /root/usb
sudo echo "echo 0x1d6b > idVendor # Linux Foundation" >> /root/usb
sudo echo "echo 0x0104 > idProduct # Multifunction Composite Gadget" >> /root/usb
sudo echo "echo 0x0100 > bcdDevice # v1.0.0" >> /root/usb
sudo echo "echo 0x0200 > bcdUSB # USB2" >> /root/usb
sudo echo "echo 0xEF > bDeviceClass" >> /root/usb
sudo echo "echo 0x02 > bDeviceSubClass" >> /root/usb
sudo echo "echo 0x01 > bDeviceProtocol" >> /root/usb
sudo echo "mkdir -p strings/0x409" >> /root/usb
sudo echo "echo \"fedcba9876543211\" > strings/0x409/serialnumber" >> /root/usb
sudo echo "echo \"Ben Hardill\" > strings/0x409/manufacturer" >> /root/usb
sudo echo "echo \"PI4 USB Device\" > strings/0x409/product" >> /root/usb
sudo echo "mkdir -p configs/c.1/strings/0x409" >> /root/usb
sudo echo "echo \"Config 1: ECM network\" > configs/c.1/strings/0x409/configuration" >> /root/usb
sudo echo "echo 250 > configs/c.1/MaxPower" >> /root/usb
sudo echo "# Add functions here" >> /root/usb
sudo echo "# see gadget configurations below" >> /root/usb
sudo echo "# End functions" >> /root/usb
sudo echo "mkdir -p functions/ecm.usb0" >> /root/usb
sudo echo "HOST=\"00:dc:c8:f7:75:14\" # \"HostPC\"" >> /root/usb
sudo echo "SELF=\"00:dd:dc:eb:6d:a1\" # \"BadUSB\"" >> /root/usb
sudo echo "echo $HOST > functions/ecm.usb0/host_addr" >> /root/usb
sudo echo "echo $SELF > functions/ecm.usb0/dev_addr" >> /root/usb
sudo echo "ln -s functions/ecm.usb0 configs/c.1/" >> /root/usb
sudo echo "udevadm settle -t 5 || :" >> /root/usb
sudo echo "ls /sys/class/udc > UDC" >> /root/usb
sudo echo "ifup usb0" >> /root/usb
sudo echo "service dnsmasq restart" >> /root/usb

### make /root/usb.sh executable
sudo chmod +x /root/usb.sh

### /root/usb.sh to /etc/rc.local before exit 0
sudo sed -i 's/exit 0/\/root\/usb.sh\n\nexit 0/g' /etc/rc.local

# EOF
