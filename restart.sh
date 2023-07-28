
#!/bin/bash


JAVA_HOME=/usr/local/java
JRE_HOME=${JAVA_HOME}/jre
CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
PATH=${JAVA_HOME}/bin:$PATH

COMMAND="/home/$1/$1".jar"" #运行命令,不同应用修改此次
jvmm="-Xms1024m -Xmx1024m -Xmn256m -XX:MaxTenuringThreshold=15 -XX:NewRatio=4 -XX:SurvivorRatio=4 -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:CMSFullGCsBeforeCompaction=5"


if [ -n  "$1" ];then
        echo $1
else
        exit
fi

cd /home/$1
PID=`ps -ef | grep java | grep -v grep | grep "$1"".jar"  |awk '{ print $2 }'`
echo "当前进程ID："$PID
if [ -z "$PID" ];then
        echo "no process PID....."
else
        echo "停止java进程"
        kill -9 $PID

fi

echo "java -jar /home/$1/$1".jar""
#nohup /usr/local/jdk1.8.0_181/bin/java -jar -Duser.timezone=Asia/Shanghai $jvmm $COMMAND  &
nohup /usr/local/java/bin/java -jar -Duser.timezone=Asia/Shanghai $jvmm $COMMAND  > /dev/null 2>&1 &
echo "启动java进程"
NPID=`ps -ef | grep java | grep -v grep | grep "$1"".jar"  |awk '{ print $2 }'`
echo "正在运行进程ID："$NPID
