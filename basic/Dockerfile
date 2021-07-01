# 基于 centos7
FROM docker.io/centos:7


# 前置配置
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && localedef -c -f UTF-8 -i en_US en_US.UTF-8 \
    && mkdir /root/.ssh \
    && echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDN5eVLAN4vZca+EOJzW9yE9LrTbpiYZRitRLlYSpAteR5af0xuCZ7p7sPm3frStua7CvQSLI5HtEp+eMr2jfDBBWgc+AGpcBaFRW1AcayV91xff/8Roqi44eR4T7LD7sStiup6yjhOAbiyB6HLLgLG0ZI5THN0QgH0UWAsPQ3Ew/2O962UUd62yRSmQW/ylKmkw17cTxTdbs6ksMwBh3FZDURdB1pZmeCUpwI+oNQtFyy8+9105iEWX0wKZcT9HuM5her6DwkWqoI9z8w+OSi7QZVyckYascw/OjFMxG0PnL+xMtfnnqVpNG2OVO5ILB7XjF0dkZXktt3JGdjScltj hhy@deepcyto.cn" > /root/.ssh/authorized_keys
ENV LC_ALL=en_US.UTF-8


# 安装组件 & 清理
RUN yum -y update \
    && yum install -y openssh-server openssh-clients \
    && yum install -y which dmidecode unzip wget \
    && yum install -y urw-fonts openssl-devel \
    && yum install -y libXext libSM libXrender \
    && yum install -y https://repo.ius.io/ius-release-el7.rpm \
    && yum install -y python36u python36u-libs python36u-devel python36u-pip \
    && yum clean all \
    && rm -rf /var/cache/yum


# 安装中文字体
RUN wget https://static.zitijia.com/file/item/201912/24/281258939050380345/f.zip \
    && wget https://down7.pc6.com/qd3/simsun.zip \
    && unzip /f.zip \
    && unzip /simsun*.zip \
    && rm /*.txt /*.zip /*.url /simsun.ttf \
    && mkdir -p /usr/share/fonts/chinese \
    && mv /*.ttf /*.ttc /usr/share/fonts/chinese \
    && fc-cache 


# 安装 wkhtmltox
RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz \
    && tar -xvf wkhtmltox-*_linux-generic-amd64.tar.xz \
    && mv /wkhtmltox/bin/wkhtmltopdf /usr/local/bin/wkhtmltopdf \
    && chmod +x /usr/local/bin/wkhtmltopdf \
    && rm -rf /wkhtmltox*


# 安装 python package & 清理
COPY requirements.txt /root
RUN pip3 install --upgrade pip \
    && pip config set global.index-url https://mirrors.aliyun.com/pypi/simple \
    && pip3 install -r /root/requirements.txt \
    && rm -rf /root/.cache/pip


# 配置文件
COPY .bashrc /root/.bashrc


# 启动服务
RUN systemctl enable sshd \
    && chmod a+x /etc/rc.d/rc.local \
    && systemctl enable rc-local


