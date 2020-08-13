## 警告⚠：此技术仅限用于个人搭建游戏加速器使用！！！若用于其他违法目的，后果自负！！！

## 搭建方式一：SoftEther Server

### SoftEther稳定版搭建教程
```
sudo yum update -y && sudo yum install wget gcc -y

wget https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.28-9669-beta/softether-vpnserver-v4.28-9669-beta-2018.09.11-linux-x64-64bit.tar.gz && tar -zvxf softether-vpnserver-v4.28-9669-beta-2018.09.11-linux-x64-64bit.tar.gz && cd vpnserver && make

sudo ./vpnserver start

./vpncmd

ServerPasswordSet
```
### 设置自启：

#### 方案一：
```
vi /etc/rc.d/rc.local

cd /root/vpnserver

./vpnserver start

chmod +x /etc/rc.d/rc.local
```
#### 方案二：
```
vi /etc/systemd/system/vpnserver.service
```
--------------------------------------------------
```
[Unit] 

Description=SoftEther Server 

After=network.target 

[Service] 

Type=forking 

ExecStart=/root/vpnserver/vpnserver start 

ExecStop= /root/vpnserver/vpnserver stop

[Install] 

WantedBy=multi-user.target
```
--------------------------------------------------
```
systemctl start vpnserver

systemctl enable vpnserver
```
## 搭建方式二：OpenVPN Access Server

### OpenVPN Access Server搭建（CentOS7）
```
yum update -y

yum -y install https://as-repository.openvpn.net/as-repo-centos7.rpm

yum -y install openvpn-as

passwd openvpn
```
设置密码

全部默认回车

访问https://your_server_ip:943
```
windows-driver wintun

duplicate-cn
```
### OpenVPN Access Server搭建（CentOS8）
```
yum update -y

yum -y install https://as-repository.openvpn.net/as-repo-centos8.rpm

yum -y install openvpn-as

passwd openvpn
```
设置密码

访问https://your_server_ip:943
```
windows-driver wintun

duplicate-cn
```
## 服务器端优化

### 安装nslookup（用于测试服务器DNS服务器好坏）：
```
yum install bind-utils
```
### 修改DNS：
```
vim /etc/resolv.conf

nameserver 8.8.8.8

nameserver 8.8.4.4

vim /etc/sysconfig/network-scripts/ifcfg-eth0

DNS1=8.8.8.8

DNS2=8.8.4.4

service network restart
```
### 关闭防火墙
```
systemctl status firewalld.service

systemctl disable firewalld.service
```
### 服务器禁ping:
```
vi /etc/sysctl.conf

net.ipv4.icmp_echo_ignore_all=1

sysctl -p
```
### 暂停日志系统（针对SoftEther Server）：
```
timedatectl set-timezone Asia/Shanghai

wget https://github.com/hxhgts/OpenVPN-Server-Create/raw/master/softetherlogpurge.sh

crontab -e

*/180 * * * * bash softetherlogpurge.sh

crontab -l
```
### SSH端口修改（修改默认22）
```
vi /etc/ssh/sshd_config

port 10012

systemctl restart sshd
```
### 常用平台OpenVPN客户端下载地址

[SoftEther Linux版服务器端](https://lanzous.com/ic2bw2j)               [SoftEther Win版服务器端](https://lanzous.com/ic2bx7a)

[Win7版](https://wwa.lanzous.com/i5DKOf2aj1c)       [Win10版](https://wwa.lanzous.com/iuQdyf2aj9a)

[Mac版](https://www.lanzous.com/i9q7ylc)        [Android版](https://www.lanzous.com/i9mrdfg)

#### 分享密码：a4CXjk

