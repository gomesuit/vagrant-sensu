#!/bin/sh

echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4" > /etc/hosts
echo "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6" >> /etc/hosts
echo "192.168.33.10 server" >> /etc/hosts
echo "192.168.33.20 client01" >> /etc/hosts
