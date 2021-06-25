# 基于develop
FROM troygarden/fcm:develop


# 安装组件
RUN yum groupinstall -y "X Window System" \
    && yum groupinstall -y "Xfce" \
    && yum groupinstall -y Fonts \
    && yum install -y https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm \
    && yum clean all \
    && rm -rf /var/cache/yum


# chrome-driver
RUN wget http://chromedriver.storage.googleapis.com/70.0.3538.16/chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip \
    && mv /chromedriver /usr/local/bin/ \
    && chmod +x /usr/local/bin/chromedriver \
    && rm /chromedriver*.zip


# 安装 python package & 清理
COPY requirements.txt /root
RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple \
    && pip3 install -r /root/requirements.txt \
    && rm -rf /root/.cache/pip


# 配置文件
COPY google-chrome-root /usr/bin
RUN chmod a+x /usr/bin/google-chrome-root


# 一过性程序
COPY one-shot.sh /root


