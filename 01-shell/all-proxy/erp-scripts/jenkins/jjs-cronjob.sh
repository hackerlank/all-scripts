#!/bin/bash

#!/bin/bash
#发布的版本
VERSION=${version}

#项目的名称
APPNAME='jjshouse_cronjob'

#项目是发到正式还是测试，如果是测试在路径后面加上_TEST
TYPE=${type}
if [ $TYPE == 'formal' ];then
        ENV='cronjob'
else if [ $TYPE == 'test' ];then
        ENV='cronjob_test'
        else
                echo 'type error ...'
                exit 1
        fi
fi

echo “start deploy $APPNAME  $TYPE ...................................................................................................”

#SVN地址信息
SVN_ADDR='https://svn.digi800.com/svn/src/web/trunk/jjshouse_cronjob'

#SVN账号信息
SVN_OPT='--username erpcheckout0930 --password vp25Dy6LCQ7z9C78  --trust-server-cert --non-interactive'

SSH="ssh -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no"

if [ -f /svn/${ENV}/${APPNAME}/success ];then
            sudo rm -f /svn/${ENV}/${APPNAME}/success
fi

if [  ! -d /svn/${ENV}/${APPNAME} ]; then
        mkdir -p /svn/${ENV}/${APPNAME}
        cd /svn/${ENV}/${APPNAME};svn checkout ${SVN_ADDR} . ${SVN_OPT}
        if [ $? -eq 0 ];then
                cd /svn/${ENV}/${APPNAME};
                new_revision=`svn info |grep "Last Changed Rev" |awk '{print $4}'`
                touch version
                echo $new_revision > version
                touch flag ; echo 1 > flag
                echo "Now version is : $new_revision"
                echo "checkout success"
        else
                echo "SVN checkout Failed ...  script exit."
                exit 1
        fi
else
        cd /svn/${ENV}/${APPNAME};

        if [ -f flag ];then
                rm flag
        fi

        svn update -r $VERSION ${SVN_OPT}

        if [ $? -eq 0 ];then

                if [ $VERSION == "HEAD" ];then
                        VERSION=`svn info |grep "Last Changed Rev" |awk '{print $4}'`
                fi
                echo "Version is ${VERSION} now"
                echo $VERSION > version
                touch flag ; echo 1 > flag
                echo "Update ${VERSION} success" 
        else
                echo "svn update ${VERSION} Failed"
                exit 1
        fi
fi

sudo chmod -R 777 /svn/${ENV}/${APPNAME}

/usr/bin/ssh -p38022 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -oConnectTimeout=15 syncer@101.231.200.238 "echo $VERSION > /tmp/deploy${APPNAME}"

sudo /usr/bin/rsync -qzrtopg --progress --delete -e 'ssh -p38022 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null' /svn/${ENV}/${APPNAME} syncer@101.231.200.238:/tmp 

if [ $? != 0 ];then
    echo "rsync code from 192.168.0.230 to 192.168.1.51  Failed!!!"
    exit 1
else
    echo "rsync code from 192.168.0.230 to 192.168.1.51  OK!!!"
fi

count=0
timeout=30
while [ $count -lt $timeout ];do
    return=`sudo  /usr/bin/ssh  -p38022 -oConnectTimeout=15 syncer@101.231.200.238 "cat /tmp/success${APPNAME}"`
    if [ $return == "OK" ];then
        /usr/bin/ssh -p38022 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -oConnectTimeout=15 syncer@101.231.200.238 "echo 0 > /tmp/success${APPNAME}" 
        echo "Deploy to target machine OK!"             
        break;
   else
        let count++
        sleep 10
        echo "Please continue to wait for the deployment of the results"
  fi
done


if [ $count -eq 30 ] ; then

	echo "deploy failed ...................."
	
	exit 1

else 
    echo "deploy success ...................."

fi
