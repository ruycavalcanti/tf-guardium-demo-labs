#!/bin/bash

ARG1=`grep -A100 submenu /boot/grub/grub.cfg |grep menuentry |grep Advanced |cut -d "'" -f 4`
ARG2=`grep -A100 submenu /boot/grub/grub.cfg |grep menuentry |grep generic |cut -d "'" -f 4 |head -n 1`
ARG3="GRUB_DEFAULT=\"$ARG1>$ARG2\""
sudo sed -i -e "s/GRUB_DEFAULT=0/$ARG3/" /etc/default/grub
