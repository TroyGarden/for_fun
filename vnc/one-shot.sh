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
    sed -i s/replace_with_license/$FCM_LICENSE/ /lib/systemd/system/fcm.service
    sed -i s/replace_with_license/$FCM_LICENSE/ /lib/systemd/system/fcmweb.service
    sed -i s/replace_with_license/$FCM_LICENSE/ /lib/systemd/system/jupyter.service
fi


# 初始化 jupyter
if [ ! -e /root/.jupyter/jupyter_notebook_config.py ]; then
    jupyter notebook --generate-config
    sed -i '/c.NotebookApp.ip/c\c.NotebookApp.ip="0.0.0.0"' /root/.jupyter/jupyter_notebook_config.py
    jupyter contrib nbextension install --sys-prefix
    systemctl enable jupyter
    systemctl start jupyter
fi


# 初始密码为空
if [ ! -e /root/.jupyter/jupyter_notebook_config.json ]; then
    echo '{"NotebookApp": {"password": "argon2:$argon2id$v=19$m=10240,t=10,p=8$OS9CmL1yKN2Muo52wKxPxg$ASw/zU5dZzpLZauJWQYxxQ"}}' > /root/.jupyter/jupyter_notebook_config.json
fi


# 启动vnc端口1服务
yum groupinstall -y "X Window System"
yum groupinstall -y "Xfce"
yum install -y vnc-server
(echo "deepcyto"; echo "deepcyto"; echo n) | vncpasswd
export HOME=/root
vncserver > /dev/null 2>&1
echo "geometry=1920x986" >> /root/.vnc/config
sed -i '/xinitrc/c\exec startxfce4' /root/.vnc/xstartup
cat /lib/systemd/system/vncserver@.service | sed s/\<USER\>/root/ > /etc/systemd/system/vncserver@:1.service
systemctl enable vncserver@:1
systemctl start vncserver@:1


# 运行 /data/workspace 下的 one-shot.sh
if [ -e /data/workspace/one-shot.sh ]; then
    bash /data/workspace/one-shot.sh
fi


# 清理
sed -i /one-shot.sh/d /etc/rd.d/rc.local
chmod a+x /etc/rd.d/rc.local
rm /root/one-shot.sh /root/requirements.txt

