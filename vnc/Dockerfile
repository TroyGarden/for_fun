# 基于develop
FROM troygarden/fcm:develop


# 安装组件
RUN yum groupinstall -y "GNOME Desktop" "X Window System" "Desktop" \
    && yum install -y tigervnc-server tigervnc vnc vnc-server \
    && (echo "deepcyto"; echo "deepcyto"; echo n) | vncpasswd \
    && cat /lib/systemd/system/vncserver@.service | sed s/\<USER\>/root/ > /etc/systemd/system/vncserver@:1.service \
    && yum clean all \
    && rm -rf /var/cache/yum


# 一过性程序
COPY one-shot.sh /root
RUN echo 'bash /root/one-shot.sh' >> /etc/rc.local


