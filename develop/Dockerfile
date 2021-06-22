# 基于 production
FROM troygarden/fcm:production


# 前置配置


# 安装组件 & 清理
RUN yum install -y git \
    && yum clean all \
    && rm -rf /var/cache/yum


# 配置文件
COPY requirements.txt /root
COPY jupyter.service /lib/systemd/system/


# 安装 python package & 清理

RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple \
    && pip3 install -r /root/requirements.txt \
    && rm -rf /root/.cache/pip


# 启用服务


# 一过性程序
COPY one-shot.sh /root
RUN echo 'bash /root/one-shot.sh' >> /etc/rc.local

