#!/bin/sh

echo '正在关闭SELinux. . .'

setenforce 0

echo '正在导入安装源. . .'

rpm -Uvh --force http://mirror.centos.org/centos-7/7.9.2009/os/x86_64/Packages/centos-release-7-9.2009.0.el7.centos.x86_64.rpm

yum clean all

yum makecache

yum install epel-release -y

yum update -y

yum install yum-plugin-copr -y

sleep 3

yum copr enable dsommers/openvpn-release -y

sleep 3

echo '正在执行安装. . .'

yum install openvpn iptables iptables-services -y

cd /opt/

wget https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.8/EasyRSA-3.0.8.tgz -O EasyRSA-3.0.8.tgz

tar xf EasyRSA-3.0.8.tgz

cp -r EasyRSA-3.0.8 /etc/openvpn/easy-rsa3

cp /etc/openvpn/easy-rsa3/vars.example /etc/openvpn/easy-rsa3/vars

cd /etc/openvpn/easy-rsa3/

./easyrsa init-pki

echo '正在生成证书与密钥文件. . .'

./easyrsa build-ca nopass

echo '询问Common Name时请保持输入一致即可!'

./easyrsa gen-req server nopass

echo yes | ./easyrsa sign-req server server

./easyrsa gen-req client nopass

echo yes | ./easyrsa sign-req client client

./easyrsa gen-dh

openvpn --genkey --secret /etc/openvpn/ta.key

cd /etc/openvpn/easy-rsa3/pki/

cp ca.crt dh.pem /etc/openvpn/

cp private/server.key issued/server.crt /etc/openvpn/server/

cp private/client.key issued/client.crt /etc/openvpn/client/

wget https://raw.githubusercontent.com/HXHGTS/OpenVPN-Server-Create/master/server.conf -O /etc/openvpn/server.conf

wget https://raw.githubusercontent.com/HXHGTS/OpenVPN-Server-Create/master/client.conf -O /etc/openvpn/client.ovpn

chown root.openvpn /etc/openvpn/* -R

echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf

echo "net.ipv6.conf.all.forwarding = 1" >> /etc/sysctl.conf

sysctl -p

echo "IPV6FORWARDING=yes" >> /etc/sysconfig/network

iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o eth0 -j MASQUERADE

service iptables save

systemctl restart iptables

systemctl restart network

systemctl start openvpn-server@server.service

systemctl enable openvpn-server@server.service

netstat -lntp|grep openvpn

ps -aux|grep openvpn

echo '请在/etc/openvpn/目录中将ca.crt、client.crt、client.key、ta.key、client.ovpn文件拷贝到客户端中使用!'

echo 'client.ovpn需要手动填入服务器ip地址!'

exit 0
