#/usr/bin/bash
# 一过性程序


# 初始化数据库
systemctl start mongod
mongo --port 8892 --quiet -u hhy -p hehuanyu --eval "db.system.users.find({user:'deepflow'}).count()" admin --authenticationDatabase admin
if [ $? -ne 0 ]; then
    echo 'db.createUser({user: "hhy", pwd: "hehuanyu", roles: [{role: "root", db: "admin"}]})' | mongo \
        --port 8892 admin
    echo 'db.createUser({user: "deepflow", pwd: "hehuanyu", roles: [{role: "readWrite", db: "deepflow"}]})' | mongo \
        --port 8892 deepflow --username hhy --password hehuanyu --authenticationDatabase admin

    # 从文件夹导入初始数据库
    if [ -d /data/workspace/deepflow ]; then
        mongorestore --port 8892 -d deepflow --dir /data/workspace/deepflow/ \
            --username hhy --password hehuanyu --authenticationDatabase admin
    fi
fi


# 初始化 FCM_LICENSE
if [ -e /data/workspace/FCM_LICENSE ]; then
    FCM_LICENSE=`cat /data/workspace/FCM_LICENSE`
    cat /lib/systemd/system/fcm.service | sed s/replace_with_license/$FCM_LICENSE/ > fcm.bk ; mv fcm.bk /lib/systemd/system/fcm.service
    cat /lib/systemd/system/fcmweb.service | sed s/replace_with_license/$FCM_LICENSE/ > fcm.bk ; mv fcm.bk /lib/systemd/system/fcmweb.service
    cat /lib/systemd/system/jupyter.service | sed s/replace_with_license/$FCM_LICENSE/ > fcm.bk ; mv fcm.bk /lib/systemd/system/jupyter.service
fi


# 初始化 jupyter
if [ ! -e /root/.jupyter/jupyter_notebook_config.py ]; then
    jupyter notebook --generate-config
    cat /root/.jupyter/jupyter_notebook_config.py | sed s/#c.NotebookApp.ip\ =\ \'localhost\'/c.NotebookApp.ip=\'0.0.0.0\'/ > jp
    mv jp /root/.jupyter/jupyter_notebook_config.py
fi


# 初始密码为空
if [ ! -e /root/.jupyter/jupyter_notebook_config.json ]; then
    echo '{"NotebookApp": {"password": "argon2:$argon2id$v=19$m=10240,t=10,p=8$OS9CmL1yKN2Muo52wKxPxg$ASw/zU5dZzpLZauJWQYxxQ"}}' > /root/.jupyter/jupyter_notebook_config.json
fi


# 更改root home
if [ `ls -a /home | wc -l` -eq 2 ]; then
    mv /root/* /home
    mv /root/.* /home
else
    rm -rf /root/.*
    rm -rf /root/*
fi

grep ^root /etc/passwd | sed s'/\/root/\/home/' > passwd
grep -v ^root /etc/passwd >> passwd
mv passwd /etc/passwd


# 运行 /data/workspace 下的 one-shot.sh
if [ -e /data/workspace/one-shot.sh ]; then
    bash /data/workspace/one-shot.sh
fi


# 清理
grep -v /root/one-shot.sh /etc/rc.local > rc.local
chmod a+x rc.local
mv rc.local /etc/rc.d/rc.local
rm /root/one-shot.sh

