#!/bin/sh

echo '正在关闭SELinux. . .'

setenforce 0

echo '正在导入安装源. . .'

wget -O /etc/yum.repos.d/epel-7.repo http://mirrors.aliyun.com/repo/epel-7.repo

echo '正在执行安装. . .'

yum install iptables iptables-services ip6tables ip6tables-services openvpn -y

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

iptables --table nat --append POSTROUTING --out-interface ens192 --jump MASQUERADE

ip6tables --table nat --append POSTROUTING --out-interface ens192 --jump MASQUERADE

service iptables save

systemctl restart iptables

systemctl restart network

systemctl start openvpn@server

systemctl enable openvpn@server

netstat -lntp|grep openvpn

ps -aux|grep openvpn

echo '请在/etc/openvpn/目录中将ca.crt、client.crt、client.key、ta.key、client.ovpn文件拷贝到客户端中使用!'

echo 'client.ovpn需要手动填入服务器ip地址即可使用!'

exit 0
