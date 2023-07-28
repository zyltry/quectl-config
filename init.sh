#!/bin/bash
/bin/echo "欢迎使用quec系统初始化脚本"
init_url="http://quec-ops-oss.oss-cn-shanghai.aliyuncs.com/system-init"
step_system_kernel(){
/bin/echo "1.正在执行系统内核优化"
/bin/mv /etc/sysctl.conf /etc/sysctl.conf.bak
/bin/echo "sysctl.conf备份为/etc/sysctl.conf.bak"
/bin/wget -O /etc/sysctl.conf ${init_url}/conf/sysctl.conf >/dev/null 2>&1 && /usr/sbin/sysctl -p  >/dev/null 2>&1
#limits.conf
/bin/mv /etc/security/limits.conf   /etc/security/limits.conf.bak
/bin/echo "limits.conf 备份为limits.conf.bak"
/bin/wget -O /etc/security/limits.conf ${init_url}/conf/limits.conf >/dev/null 2>&1
#20-nproc.conf
/bin/mv /etc/security/limits.d/20-nproc.conf   /etc/security/limits.d/20-nproc.conf.bak
/bin/echo "20-nproc.conf 备份为20-nproc.conf.bak"
/bin/wget -O /etc/security/limits.d/20-nproc.conf ${init_url}/conf/limits.conf >/dev/null 2>&1
#Stop Firewalld
/bin/echo "done"
}

step_system_profile(){
/bin/echo "正在优化系统设置"
/bin/cat >> /etc/profile << EOF
export HISTTIMEFORMAT='%y-%m-%d %H:%M:%S '
export HISTSIZE=1000
EOF
#/bin/echo "*/3 * * * * /usr/sbin/ntpdate ntp1.aliyun.com > /dev/null 2>&1 &" >> /var/spool/cron/root
systemctl restart crond
/bin/echo "done"
}

step_system_adduser(){
/bin/echo "正在新建用户"
useradd quec
useradd dev
/bin/echo "done"
/bin/echo "正在目录初始化"
mkdir /opt/server/
mkdir /opt/server/java/
mkdir /opt/logs/
mkdir /opt/scripts/
mkdir /opt/crash/
mkdir /opt/backup/
/bin/echo "done"
}
step_system_install_service(){
/bin/echo "正在安装常用软件"
yum install -y telnet nc iftop iotop tree tmux lrzsz ipmitool dstat htop python-devel screen lsof bind-utils rsync ack supervisor gcc-c++ openssl-devel zip unzip > /dev/null 2>&1
/bin/echo "正在安装jdk环境"
wget -O /tmp/jdk.zip ${init_url}/opt/jdk.zip >/dev/null 2>&1 && unzip -d /usr/local/ /tmp/jdk.zip >/dev/null 2>&1
java_profile='JAVA_HOME=/usr/local/jdk/
CLASSPATH=$JAVA_HOME/lib/
PATH=$PATH:$JAVA_HOME/bin
export PATH JAVA_HOME CLASSPATH'
/bin/cat >> /etc/profile << EOF
$java_profile
EOF
source /etc/profile
/bin/echo "安装成功"
}
yum install wget >/dev/null 2>&1
step_system_kernel
step_system_profile
step_system_adduser
step_system_install_service
echo "系统初始化完成"