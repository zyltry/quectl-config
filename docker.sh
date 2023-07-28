#!/bin/sh
#参考文档：https://docs.docker.com/install/linux/docker-ce/centos/
yum remove -y docker \
	docker-client \
	docker-client-latest \
	docker-common \
	docker-latest \
	docker-latest-logrotate \
	docker-logrotate \
	docker-selinux \
	docker-engine-selinux \
	docker-engin
yum install -y yum-utils \
	device-mapper-persistent-data \
	lvm2
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum makecache fast
yum install -y docker-ce-19.03.5-3.el7


# 官方软件源默认启用了最新的软件，您可以通过编辑软件源的方式获取各个版本的软件包。例如官方并没有将测试版本的软件源置为可用，你可以通过以下方式开启。同理可以开启各种测试版本等。
# vim /etc/yum.repos.d/docker-ce.repo
#   将 [docker-ce-test] 下方的 enabled=0 修改为 enabled=1
#
# 安装指定版本的Docker-CE:
# Step 1: 查找Docker-CE的版本:
# yum list docker-ce.x86_64 --showduplicates | sort -r
#   Loading mirror speeds from cached hostfile
#   Loaded plugins: branch, fastestmirror, langpacks
#   docker-ce.x86_64            17.03.1.ce-1.el7.centos            docker-ce-stable
#   docker-ce.x86_64            17.03.1.ce-1.el7.centos            @docker-ce-stable
#   docker-ce.x86_64            17.03.0.ce-1.el7.centos            docker-ce-stable
#   Available Packages
# Step2 : 安装指定版本的Docker-CE: (VERSION 例如上面的 17.03.0.ce.1-1.el7.centos)
# sudo yum -y install docker-ce-[VERSION]
# 注意：在某些版本之后，docker-ce安装出现了其他依赖包，如果安装失败的话请关注错误信息。例如 docker-ce 17.03 之后，需要先安装 docker-ce-selinux。
# yum list docker-ce-selinux- --showduplicates | sort -r
# sudo yum -y install docker-ce-selinux-[VERSION]

# 通过经典网络、VPC网络内网安装时，用以下命令替换Step 2中的命令
# 经典网络：
# sudo yum-config-manager --add-repo http://mirrors.aliyuncs.com/docker-ce/linux/centos/docker-ce.repo
# VPC网络：
# sudo yum-config-manager --add-repo http://mirrors.could.aliyuncs.com/docker-ce/linux/centos/docker-ce.repo


modprobe br_netfilter
#echo "net.bridge.bridge-nf-call-ip6tables = 1" >> /etc/sysctl.conf
#echo "net.bridge.bridge-nf-call-iptables = 1" >> /etc/sysctl.conf
#sysctl --system
#时间同步
echo "*/3 * * * * /usr/sbin/ntpdate ntp1.aliyun.com > /dev/null 2>&1 &" >> /var/spool/cron/root
systemctl restart crond
#crontab -u root -l; echo "*/3 * * * * /usr/sbin/ntpdate ntp1.aliyun.com > /dev/null 2>&1 &" | crontab -u root -

mkdir -p /opt/docker
mkdir -p /etc/docker
cat > /etc/docker/daemon.json  << EOF
{
  "registry-mirrors": ["https://fozxkv57.mirror.aliyuncs.com"],
  "insecure-registries": ["192.168.25.69"],
  "data-root": "/home/docker/",
  "log-driver": "json-file",
  "max-concurrent-downloads":20,
  "live-restore":true,
  "max-concurrent-uploads":10,
  "debug":true,
  "log-opts": {
    "max-size": "300m",
    "max-file": "1"
  }
}
EOF
systemctl daemon-reload && systemctl enable docker && systemctl restart docker
