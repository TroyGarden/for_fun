# 基于develop
FROM troygarden/fcm:develop


# 安装组件
RUN yum groupinstall -y "X Window System" \
    && yum groupinstall -y "Xfce"
    && yum install -y vnc-server \
    && (echo "deepcyto"; echo "deepcyto"; echo n) | vncpasswd \
    && cat /lib/systemd/system/vncserver@.service | sed s/\<USER\>/root/ > /etc/systemd/system/vncserver@:1.service \
    && yum clean all \
    && rm -rf /var/cache/yum


# chrome and chrome-driver
RUN wget http://chromedriver.storage.googleapis.com/70.0.3538.16/chromedriver_linux64.zip \
    && yum install -y https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm \
    && mv chromedriver /usr/local/bin/ \
    && chmod +x /usr/local/bin/chromedriver
    && rm chromedriver*.zip \


# 安装 python package & 清理
COPY requirements.txt /root
RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple \
    && pip3 install -r /root/requirements.txt \
    && rm -rf /root/.cache/pip


# 配置文件
COPY xstartup /root/.vnc
COPY google-chrome-root /usr/bin
RUN chmod a+x /root/.vnc/xstartup \
    && chmod a+x /usr/bin/google-chrome-root


# 一过性程序
COPY one-shot.sh /root
RUN echo 'bash /root/one-shot.sh' >> /etc/rc.local


