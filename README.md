## 警告⚠：此技术仅限用于个人搭建游戏加速器使用！！！若用于其他违法目的，后果自负！！！

### SoftEther稳定版（9680）搭建教程

海外服务器运行(wget失败可以从链接下载后自行上传，也可以考虑修改hosts 151.101.248.133 raw.githubusercontent.com)：

yum install wget gcc gcc-c++ automake autoconf libtool make zlib-devel openssl-devel readline-devel ncurses-devel -y

wget https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.29-9680-rtm/softether-vpnserver-v4.29-9680-rtm-2019.02.28-linux-x64-64bit.tar.gz

tar -zvxf softether-vpnserver-v4.29-9680-rtm-2019.02.28-linux-x64-64bit.tar.gz

cd vpnserver

make

./vpnserver start

./vpncmd

ServerPasswordSet

### SoftEther最新版搭建教程

海外服务器运行(wget失败可以从链接下载后自行上传)：

yum install wget gcc gcc-c++ automake autoconf libtool make zlib-devel openssl-devel readline-devel ncurses-devel -y

wget https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.34-9745-beta/softether-vpnserver-v4.34-9745-beta-2020.04.05-linux-x64-64bit.tar.gz

tar -zvxf softether-vpnserver-v4.34-9745-beta-2020.04.05-linux-x64-64bit.tar.gz

cd vpnserver

make

./vpnserver start

./vpncmd

ServerPasswordSet

### 设置自启：

#### 方案一：

vi /etc/rc.d/rc.local

cd /root/vpnserver

./vpnserver start

chmod +x /etc/rc.d/rc.local

#### 方案二：

vi /etc/systemd/system/vpnserver.service

--------------------------------------------------

[Unit] 

Description=SoftEther Server 

After=network.target 

[Service] 

Type=forking 

ExecStart=/root/vpnserver/vpnserver start 

ExecStop= /root/vpnserver/vpnserver stop

[Install] 

WantedBy=multi-user.target

--------------------------------------------------

systemctl start vpnserver

systemctl enable vpnserver



### 安装nslookup（用于测试服务器DNS服务器好坏）：

yum install bind-utils

### 修改DNS：

vim /etc/resolv.conf

nameserver 8.8.8.8

nameserver 8.8.4.4

vim /etc/sysconfig/network-scripts/ifcfg-eth0

DNS1=8.8.8.8

DNS2=8.8.4.4

service network restart

### 关闭防火墙

systemctl status firewalld.service

systemctl disable firewalld.service

### OpenVPN Access Server搭建（CentOS7）

yum install wget gcc gcc-c++ automake autoconf libtool make zlib-devel openssl-devel readline-devel ncurses-devel -y

yum -y install https://as-repository.openvpn.net/as-repo-centos7.rpm

yum -y install openvpn-as

全部默认回车

访问https://your_server_ip:943

### OpenVPN Access Server搭建（CentOS8）

yum -y install https://as-repository.openvpn.net/as-repo-centos8.rpm

yum -y install openvpn-as

全部默认回车

访问https://your_server_ip:943

### 服务器禁ping:

vi /etc/sysctl.conf

net.ipv4.icmp_echo_ignore_all=1

sysctl -p

### 暂停日志系统：

timedatectl set-timezone Asia/Shanghai

wget https://github.com/hxhgts/OpenVPN-Server-Create/raw/master/softetherlogpurge.sh

crontab -e

*/180 * * * * bash softetherlogpurge.sh

crontab -l

### SSH端口修改（修改默认22）

vi /etc/ssh/sshd_config

port 10012

systemctl restart sshd

### 常用平台OpenVPN客户端下载地址

[Linux版服务器端](https://lanzous.com/ic2bw2j)               [Win版服务器端](https://lanzous.com/ic2bx7a)

[Win7版OpenVPN客户端](https://www.lanzous.com/i9q7ykb)       [Win10版OpenVPN客户端](https://www.lanzous.com/i9mr48f)

[Mac版OpenVPN客户端](https://www.lanzous.com/i9q7ylc)        [Android版OpenVPN客户端（第三方版）](https://www.lanzous.com/i9mrdfg)

#### 分享密码：a4CXjk


### 国内跳转服务器NAT配置（操作系统适用于CentOS7+）

systemctl status firewalld.service

systemctl start firewalld.service

sudo firewall-cmd --zone=public --permanent --add-port 本机端口号/tcp

sudo firewall-cmd --zone=public --permanent --add-port 本机端口号/udp

sudo firewall-cmd --zone=public --permanent --add-forward-port=port=本机端口号:proto=tcp:toport=目标端口号:toaddr=目标地址

sudo firewall-cmd --zone=public --permanent --add-forward-port=port=本机端口号:proto=udp:toport=目标端口号:toaddr=目标地址

sudo firewall-cmd --zone=public --permanent --add-masquerade

sudo firewall-cmd --reload


### 卸载安骑士（阿里云服务器必须执行！！！）
--------------------------------------------------------------
wget http://update.aegis.aliyun.com/download/uninstall.sh

chmod +x uninstall.sh

./uninstall.sh

wget http://update.aegis.aliyun.com/download/quartz_uninstall.sh

chmod +x quartz_uninstall.sh

./quartz_uninstall.sh

pkill aliyun-service

rm -fr /etc/init.d/agentwatch /usr/sbin/aliyun-service

rm -rf /usr/local/aegis*

iptables -I INPUT -s 140.205.201.0/28 -j DROP

iptables -I INPUT -s 140.205.201.16/29 -j DROP

iptables -I INPUT -s 140.205.201.32/28 -j DROP

iptables -I INPUT -s 140.205.225.192/29 -j DROP

iptables -I INPUT -s 140.205.225.200/30 -j DROP

iptables -I INPUT -s 140.205.225.184/29 -j DROP

iptables -I INPUT -s 140.205.225.183/32 -j DROP

iptables -I INPUT -s 140.205.225.206/32 -j DROP

iptables -I INPUT -s 140.205.225.205/32 -j DROP

iptables -I INPUT -s 140.205.225.195/32 -j DROP

iptables -I INPUT -s 140.205.225.204/32 -j DROP

--------------------------------------------------------------
