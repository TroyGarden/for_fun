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

    systemctl enable fcm
    systemctl enable fcmweb
    systemctl start fcm
    systemctl start fcmweb
fi


if [ -e /data/workspace/one-shot.sh ]; then
    bash /data/workspace/one-shot.sh
fi


# 清理
grep -v /root/one-shot.sh /etc/rc.local > rc.local
chmod a+x rc.local
mv rc.local /etc/rc.d/rc.local
rm /root/one-shot.sh

