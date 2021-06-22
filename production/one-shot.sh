#/usr/bin/bash
# 一过性程序


# 初始化数据库
mongo --port 8892 --quiet -u hhy -p hehuanyu --eval "db.system.users.find({user:'deepflow'}).count()" admin --authenticationDatabase admin
if [ $? -ne 0 ]; then
    systemctl start mongod
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

    systemctl enable fcm
    systemctl enable fcmweb
    systemctl start fcm
    systemctl start fcmweb
fi


if [ -e /data/workspace/wkhtmltopdf.tar ]; then
    cd /data/workspace
    tar -xvf wkhtmltopdf.tar
fi


if [ -e /data/workspace/wkhtmltopdf ]; then
    mv /data/workspace/wkhtmltopdf /usr/local/bin/wkhtmltopdf
    chmod a+x /usr/local/bin/wkhtmltopdf
fi


if [ ! -e /usr/local/bin/wkhtmltopdf ]; then
    yum install -y wget
    cd /data/workspace
    wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
    tar -xvf wkhtmltox-0.12.3_linux-generic-amd64.tar.xz
    mv wkhtmltox/bin/wkhtmltopdf /usr/local/bin/wkhtmltopdf
    chmod +x /usr/local/bin/wkhtmltopdf
fi


if [ -e /data/workspace/one-shot.sh ]; then
    /data/workspace/one-shot.sh
fi


# 清理
grep -v /root/one-shot.sh /etc/rc.local > rc.local
chmod a+x rc.local
mv rc.local /etc/rc.d/rc.local
rm /root/one-shot.sh

