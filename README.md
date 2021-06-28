# fcm docker images for all kinds of environments
## basic
能够通过fcm运行后端病例

>   name=fcm-basic; id=120
>   docker run -it --name $name
>   --hostname $name
>   -v /data/workspace_$name:/data/workspace
>   -p ${id:-120}22:22
>   --shm-size=1g 
>   --privileged=true 
>   -d troygarden/fcm:basic
>   /sbin/init


1. 包含基础系统设置
    1. 时区, utf-8
    2. ssh

2. 基础的组件
    1. python 3.6
    2. pip package

3. 服务配置
    1. rc-local
    2. sshd


## production
能够运行deepflow平台

>   name=fcm-production; id=120
>   docker run -it --name $name
>   -v /data/workspace_$name:/data/workspace
>   -p ${id}22:22
>   -p ${id}80:80
>   --shm-size=1g 
>   --privileged=true 
>   -d troygarden/fcm:production
>   /sbin/init

1. 包含所需的组件
    1. nginx, redis, crontab, mongodb 等
    2. wkhtmltopdf, wget
    3. pip package

2. 服务配置
    1. mongodb, nginx, crontab, redis 以及自启动
    2. rc-local

3. 一过性脚本
    1. /data/workspace/one-shot.sh
    2. 初始化 mongodb
    3. 设置 FCM_LICENSE 到 fcm/fcmweb
    4. 自启动 fcm/fcmweb


## develop
能够通过jupyter运行fcm

>   name=fcm-develop; id=130
>   docker run -it --name $name
>   -v /data/workspace_$name:/data/workspace
>   -p ${id}22:22
>   -p ${id}80:80
>   -p ${id}88-${id}93:8888-8893
>   -p ${id}01-${id}03:5901-5903
>   --shm-size=1g 
>   --privileged=true 
>   -d troygarden/fcm:develop
>   /sbin/init

1. 包含所需的组件
    1. pip package
    2. git

2. 服务配置
    1. jupyter

3. 一过性脚本
    1. /data/workspace/one-shot.sh
    2. 初始化 mongodb
    3. 初始化 jupyter
    4. 将 /root 备份到 /root.bk, 转移文件, 方便/root的mount


## vnc
能够通过 vnc 访问系统

>   name=fcm-develop; id=150
>   docker run -it --name $name
>   -v /data/workspace_$name:/data/workspace
>   -p ${id}22:22
>   -p ${id}80:80
>   -p ${id}88-${id}93:8888-8893
>   -p ${id}01-${id}03:5901-5903
>   --shm-size=1g 
>   --privileged=true 
>   -d troygarden/fcm:vnc
>   /sbin/init

1. 包含所需的组件
    1. vncserver
    2. X Window System
    3. Xfce4
    4. google-chrome
    5. chrome-drive
    6. selenium

2. 服务配置
    1. vncserver@:1

3. 一过性脚本
    1. /data/workspace/one-shot.sh
    2. 初始化 mongodb
    3. 初始化 jupyter
    4. 启动 vncserver
