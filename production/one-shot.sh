#/usr/bin/bash
# 一过性程序


# 初始化数据库
systemctl is-active mongod || systemctl start mongod
if [ `systemctl is-active mongod 2 > /dev/null; echo $?` -eq 0 ]
then 
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
fi


# 初始化 FCM_LICENSE
if [ -e /data/workspace/FCM_LICENSE ]; then
    sed -i s/replace_with_license/`cat /data/workspace/FCM_LICENSE`/ /lib/systemd/system/fcm*.service
    systemctl enable fcm fcmweb
    systemctl start fcm fcmweb
fi


if [ -e /data/workspace/one-shot.sh ]; then
    bash /data/workspace/one-shot.sh
fi


# 清理
sed -i /one-shot.sh/d /etc/rc.d/rc.local
chmod a+x /etc/rc.d/rc.local
rm /root/one-shot.sh /root/requirements.txt

