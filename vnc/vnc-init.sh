#/usr/bin/bash

# 启动vnc端口1服务
yum groupinstall -y "X Window System"
yum groupinstall -y "Xfce"
yum install -y vnc-server
(echo "deepcyto"; echo "deepcyto"; echo n) | vncpasswd
vncserver > /dev/null 2>&1
echo "geometry=1920x986" >> /root/.vnc/config
sed -i '/xinitrc/c\exec startxfce4' /root/.vnc/xstartup
cat /lib/systemd/system/vncserver@.service | sed s/\<USER\>/root/ > /etc/systemd/system/vncserver@:1.service
systemctl enable vncserver@:1
systemctl start vncserver@:1
