# fcm docker images for all kinds of environments
## basic
能够通过fcm运行后端病例
>   docker run -it --name **fcm-basic**
>   -v /data/**workspace_${id:-120}**:/data/workspace
>   -p ${id:-120}22:22
>   -p ${id:-120}80:80
>   -p ${id:-120}88-${id:-120}93:8888-8893
>   -p ${id:-120}01-${id:-120}03:5901-5903
>   --shm-size=1g 
>   --privileged=true 
>   -d troygarden/fcm:**basic**
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
>   docker run -it --name **fcm-production**
>   -v /data/**workspace_${id:-130}**:/data/workspace
>   -p ${id:-130}22:22
>   -p ${id:-130}80:80
>   -p ${id:-130}88-${id:-130}93:8888-8893
>   -p ${id:-130}01-${id:-130}03:5901-5903
>   --shm-size=1g 
>   --privileged=true 
>   -d troygarden/fcm:**production**
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

1. 包含所需的组件
    1. pip package
    2. git

2. 服务配置
    1. jupyter

3. 一过性脚本
    1. /data/workspace/one-shot.sh
    2. 初始化 mongodb
    3. 初始化 jupyter
    4. 将 root 的 home 从 /root 换到 /home



