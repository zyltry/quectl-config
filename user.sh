#!/bin/bash
#创建用户并设置密码
name=ops
pass=!a63FbKaT4y52qBZe^y!
#echo "you are setting username : ${name}"
#echo "you are setting password : $pass for ${name}"
#调用name变量创建用户
useradd $name
if [ $? -eq 0 ];then
    echo -e "\033[32m用户${name}:创建成功\033[0m"
else
    echo -e "\033[31m用户${name}:创建失败\033[0m"
    exit 1
fi
echo $pass | passwd $name --stdin  &>/dev/null
if [ $? -eq 0 ];then
    echo -e "\033[32m用户${name}:密码设置成功!!!"
else
    echo -e "\033[31m用户${name}:密码密码设置失败\033[0m"
fi

#追加用户至sudoers设置sudo免密调用
sed -i '/^root.*ALL=(ALL).*ALL/a\'$name'\tALL=(ALL) \tNOPASSWD:ALL' /etc/sudoers
names=`cat /etc/sudoers | grep -w $name| wc -l`
if [ $names -eq 0 ];then
    echo -e "\033[31m用户$name:sudoers修改失败，请检验\033[0m"
else
    echo -e "\033[32m用户$name:sudoers修改成功\033[0m"
fi
bash