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
    && yum clean all \
    && rm -rf /var/cache/yum


# 安装 python package & 清理
COPY requirements.txt /root
RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/ \
    && pip3 install -r /root/requirements.txt \
    && rm -rf /root/.cache/pip


# 配置文件
COPY nginx.conf /etc/nginx/
COPY mongod.conf /etc
COPY fcmweb.service fcm.service mongod.service autossh.service /lib/systemd/system/


# 启用服务
RUN systemctl enable redis \
    && systemctl enable mongod \
    && systemctl enable nginx \
    && systemctl enable crond


# 一过性程序
COPY one-shot.sh /root
RUN echo 'if [ -e /root/one-shot.sh ]; then bash /root/one-shot.sh; fi' >> /etc/rc.d/rc.local

