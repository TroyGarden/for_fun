# 基于 production
FROM troygarden/fcm:production


# 前置配置


# 安装组件 & 清理
RUN yum install -y git \
    && yum install -y unar \
    && yum install -y gcc \
    && yum install -y net-tools \
    && yum install -y unzip \
    && yum clean all \
    && rm -rf /var/cache/yum


# 安装 python package & 清理
COPY requirements.txt /root
RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple \
    && pip3 install -r /root/requirements.txt \
    && rm -rf /root/.cache/pip


# 配置文件
COPY jupyter.service /lib/systemd/system/


# 启用服务


# 一过性程序
COPY one-shot.sh /root
RUN mv /root /root.bk \
    && echo 'if [ ! -d /root ]; then mv /root.bk /root; bash /root/one-shot.sh; fi' >> /etc/rc.local \
    && echo 'if [ ! -e /root/one-shot.sh ]; then mv /root.bk/* /root.bk/.* /root; rmdir /root.bk; bash /root/one-shot.sh; fi' >> /etc/rc.local
