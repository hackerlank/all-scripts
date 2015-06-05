#!/bin/bash
# auto install jenkins in Ubuntu14.04
# First: install_jenkins.sh and jenkins.war and jenkins.tar.gz should be in same directory!
# $1 = jenkins.war  Jenkins's installbar
# $2 = jenkins.tar.gz  All jobs will deploy in Jenkins
#echo  "First: install_jenkins.sh and jenkins.war and jenkins.tar.gz should be in same directory!"
echo -e "\033[01;31m"
echo "==> 此脚本运行在Ubuntu机器上，且install_jenkins.sh jenkins.war jenkins.tar.gz在同一个目录下！<=="
echo -e "\033[0m"

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"

# JKS_HOME(Jenkins_home)
JKS_HOME=/var/lib/tomcat6/webapps/jenkins
if [ $# != 2 ]; then
	echo  "Please Usage: install_jenkins.sh jenkins.war jenkins.tar.gz" 
	exit 1
fi
# install tomcat6
sudo apt-get install tomcat6 -y 

# copy jenkins.war 
sudo cp $1 /var/lib/tomcat6/webapps/
sleep 10
sudo sed -i '/^JAVA_OPTS/a\\JAVA_OPTS="-DJENKINS_HOME=/var/lib/tomcat6/webapps/jenkins/"' /etc/default/tomcat6

# Unpack the jenkins.tar.gz and copy all files
sudo tar -zxvf $SCRIPT_DIR/$2 >/dev/null
sudo cp -rf ${SCRIPT_DIR}/jenkins/* $JKS_HOME
sudo chown -R tomcat6:tomcat6 $JKS_HOME
sudo /etc/init.d/tomcat6 restart
