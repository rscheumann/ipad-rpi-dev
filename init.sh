#!/bin/bash

### add dtoverlay=dwc2 to /boot/config.txt
if [ -f files/boot/config.txt ]; then rm files/boot/config.txt; fi
if [ ! -f trunk/boot/config.txt ]; then echo "initial content" > trunk/boot/config.txt; fi
cp trunk/boot/config.txt files/boot/config.txt
echo "dtoverlay=dwc2" >> files/boot/config.txt

### add modules-load=dwc2 to /boot/cmdline.txt
if [ -f files/boot/cmdline.txt ]; then rm files/boot/cmdline.txt; fi
if [ ! -f trunk/boot/cmdline.txt ]; then echo "initial content" > trunk/boot/cmdline.txt; fi
cp trunk/boot/cmdline.txt files/boot/cmdline.txt
echo "modules-load=dwc2" >> files/boot/cmdline.txt

### create /boot/ssh
if [ -f files/boot/ssh ]; then rm files/boot/ssh; fi
touch files/boot/ssh

### add libcomposite to /etc/modules
if [ -f files/etc/modules ]; then rm files/etc/modules; fi
if [ ! -f trunk/etc/modules ]; then echo "initial content" > trunk/etc/modules; fi
cp trunk/etc/modules files/etc/modules
echo "libcomposite" >> files/etc/modules

### add denyinterfaces usb0 to /etc/dhcpcd.conf
if [ -f files/etc/dhcpcd.conf ]; then rm files/etc/dhcpcd.conf; fi
if [ ! -f trunk/etc/dhcpcd.conf ]; then echo "initial content" > trunk/etc/dhcpcd.conf; fi
cp trunk/etc/dhcpcd.conf files/etc/dhcpcd.conf
echo "denyinterfaces usb0" >> files/etc/dhcpcd.conf

### install dnsmasq with sudo apt-get install dnsmasq
#sudo apt-get install dnsmasq

### create /etc/dnsmasq.d/usb
if [ -f files/etc/dnsmasq.d/usb ]; then rm files/etc/dnsmasq.d/usb; fi
touch files/etc/dnsmasq.d/usb
echo "interface=usb0" >> files/etc/dnsmasq.d/usb
echo "dhcp-range=10.55.0.2,10.55.0.6,255.255.255.248,1h" >> files/etc/dnsmasq.d/usb
echo "dhcp-option=3" >> files/etc/dnsmasq.d/usb
echo "leasefile-ro" >> files/etc/dnsmasq.d/usb

### create /etc/network/interfaces.d/usb0
if [ -f files/etc/network/interfaces.d/usb0 ]; then rm files/etc/network/interfaces.d/usb0; fi
touch files/etc/network/interfaces.d/usb0
echo "auto usb0" >> files/etc/network/interfaces.d/usb0
echo "allow-hotplug usb0" >> files/etc/network/interfaces.d/usb0
echo "iface usb0 inet static" >> files/etc/network/interfaces.d/usb0
echo "  address 10.55.0.1" >> files/etc/network/interfaces.d/usb0
echo "  netmask 255.255.255.248" >> files/etc/network/interfaces.d/usb0

### create /root/usb.sh
if [ -f files/root/usb ]; then rm files/root/usb; fi
touch files/root/usb
echo "#!/bin/bash" >> files/root/usb
echo "cd /sys/kernel/config/usb_gadget/" >> files/root/usb
echo "mkdir -p pi4" >> files/root/usb
echo "cd pi4" >> files/root/usb
echo "echo 0x1d6b > idVendor # Linux Foundation" >> files/root/usb
echo "echo 0x0104 > idProduct # Multifunction Composite Gadget" >> files/root/usb
echo "echo 0x0100 > bcdDevice # v1.0.0" >> files/root/usb
echo "echo 0x0200 > bcdUSB # USB2" >> files/root/usb
echo "echo 0xEF > bDeviceClass" >> files/root/usb
echo "echo 0x02 > bDeviceSubClass" >> files/root/usb
echo "echo 0x01 > bDeviceProtocol" >> files/root/usb
echo "mkdir -p strings/0x409" >> files/root/usb
echo "echo \"fedcba9876543211\" > strings/0x409/serialnumber" >> files/root/usb
echo "echo \"Ben Hardill\" > strings/0x409/manufacturer" >> files/root/usb
echo "echo \"PI4 USB Device\" > strings/0x409/product" >> files/root/usb
echo "mkdir -p configs/c.1/strings/0x409" >> files/root/usb
echo "echo \"Config 1: ECM network\" > configs/c.1/strings/0x409/configuration" >> files/root/usb
echo "echo 250 > configs/c.1/MaxPower" >> files/root/usb
echo "# Add functions here" >> files/root/usb
echo "# see gadget configurations below" >> files/root/usb
echo "# End functions" >> files/root/usb
echo "mkdir -p functions/ecm.usb0" >> files/root/usb
echo "HOST=\"00:dc:c8:f7:75:14\" # \"HostPC\"" >> files/root/usb
echo "SELF=\"00:dd:dc:eb:6d:a1\" # \"BadUSB\"" >> files/root/usb
echo "echo $HOST > functions/ecm.usb0/host_addr" >> files/root/usb
echo "echo $SELF > functions/ecm.usb0/dev_addr" >> files/root/usb
echo "ln -s functions/ecm.usb0 configs/c.1/" >> files/root/usb
echo "udevadm settle -t 5 || :" >> files/root/usb
echo "ls /sys/class/udc > UDC" >> files/root/usb
echo "ifup usb0" >> files/root/usb
echo "service dnsmasq restart" >> files/root/usb

### make /root/usb.sh executable
#chmod +x /root/usb.sh

### /root/usb.sh to /etc/rc.local before exit 0
if [ -f files/etc/rc.local ]; then rm files/etc/rc.local; fi
if [ ! -f trunk/etc/rc.local ]; then echo -e "initial content\n\nexit 0" > trunk/etc/rc.local; fi
cp trunk/etc/rc.local files/etc/rc.local
sed -i 's/exit 0/\/root\/usb.sh\n\nexit 0/g' files/etc/rc.local

# EOF
