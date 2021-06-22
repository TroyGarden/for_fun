# 基于 basic
FROM troygarden/fcm:basic


# 前置配置
COPY mongodb-org.repo /etc/yum.repos.d/


# 安装组件 & 清理
RUN yum repolist \
    && yum install -y nginx \
    && yum install -y redis \
    && yum install -y cronie \
    && yum install -y mongodb-org \
    && yum install -y urw-fonts libXext openssl-devel \
    && yum clean all \
    && rm -rf /var/cache/yum


# 配置文件
COPY nginx.conf /etc/nginx/
COPY mongod.conf /etc
COPY fcmweb.service fcm.service mongod.service /lib/systemd/system/
COPY requirements.txt /root


# 安装 python package & 清理
RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/ \
    && pip3 install -r /root/requirements.txt \
    && rm -rf /root/.cache/pip


# 安装 wkhtmltox
RUN yum install -y wget \
    && wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz \
    && tar -xvf wkhtmltox-*_linux-generic-amd64.tar.xz \
    && mv /wkhtmltox/bin/wkhtmltopdf /usr/local/bin/wkhtmltopdf \
    && chmod +x /usr/local/bin/wkhtmltopdf \
    && rm -rf /wkhtmltox*


# 启用服务
RUN systemctl enable redis \
    && systemctl enable mongod \
    && systemctl enable nginx \
    && systemctl enable crond


# 一过性程序
COPY one-shot.sh /root
RUN echo 'bash /root/one-shot.sh' >> /etc/rc.local

