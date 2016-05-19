#!/bin/bash
#
# Use deploy kafka_2.11-0.9.0.1
# /etc/hosts
# eg: 172.28.25.37  trade3-25.37 

date_time=`date +%Y%m%d_%H%M`
app="kafka"

# prod path
app_path="/opt/app/${app}"
# git path
app_repo="/opt/01-Gitlab/${app}"

fz_env="${app_repo}/stages/fz_env"
dc_sh="${app_repo}/stages/dc_sh"

#*************************************************************
# init env
# 
_app_init_env(){
	# kafka data dir
        data_dir="/opt/data/${app}"
        if [ ! -d ${data_dir} ];then
                mkdir -p ${data_dir}
        fi 
	
	meta_file="/opt/data/kafka/meta.properties"
	
	# kafka logs dir
	yjb3_logs_dir="/yjb3_logs"
	if [ ! -d ${yjb3_logs_dir}/${app}/logs ];then
		mkdir -p  ${yjb3_logs_dir}/${app}/logs
	fi
}

_app_meta() {
	# 获取IP  hostname 用于配置相关文件/etc/hosts  config/server.properties
	hostname=`hostname`
	ip=`ifconfig |grep -i "inet addr" |grep -v "127.0.0.1" |awk '{print $2}' |awk -F":" '{print $2}'`
	ip_last=`echo ${ip} |awk -F"." '{print $4}'`
	ipname=`grep ${ip} /etc/hosts | grep ${hostname} /etc/hosts`
	if [ -z "$ipname" ];then
		echo "$ip  $hostname" >> /etc/hosts
	fi
	
	if [ -e ${meta_file} ];then
		# bid = broker.id
		bid=`grep "broker.id" ${meta_file} | awk -F"=" '{print $2}'`
		if [ $bid != ${ip_last} ];then
			rm -rf ${meta_file}
		fi
	fi

	cd ${app_path}; sed -i "s/^broker.id=0/broker.id=${ip_last}/g" config/server.properties
}

_app_rsync_code() {
	echo "${date_time} Begin to deploy app!!!"

	pid=`ps ax | grep -i 'kafka\.Kafka' | grep java | grep -v grep | awk '{print $1}'`
	if [ "x$pid" != "x" ];then
		cd ${app_path}/bin; bash kafka-server-stop.sh
  		sleep 3
		# 删除软连
		rm -rf ${app_path}/logs
	fi
	cd /opt
	# 删除原有所有内容,主要用于保证生产环境的代码与git版本库中的代码一致:
	rm -rf ${app_path}
	mkdir -p  ${app_path}
	# 同步代码至目标目录
	rsync -vaz -q -delete --exclude="stages*" ${app_repo}/  ${app_path}	
	# 删除git库中原有的logs目录：
	rm -rf ${app_path}/logs
	# logs存放路径
        ln -s ${yjb3_logs_dir}/${app}/logs ${app_path}/logs
}
_app_conf() {
	case $1 in
                standalone)
			echo "Use ${app_path}/config/* files"
                ;;  
                dc_sh)
                        rsync -vaz --progress ${dc_sh}/ ${app_path}/
                        echo "dc_sh"
                ;;  
                fz_env)
                        rsync -vaz --progress ${fz_env}/ ${app_path}/
                        echo "fz_env"
                ;;  
                *)  
                        echo "usage {dc_sh|yc_env}"
                        exit 1
        esac
	_app_meta
}

_app_start() {
	echo "${date_time} Begin to start ${app}......!!!"
        # logs存放路径
        if [ -e ${app_path}/logs -a -L ${app_path}/logs ];then
                file  ${app_path}/logs
        else
                ln -s ${yjb3_logs_dir}/${app}/logs ${app_path}/logs
        fi
	# start kafka Server
        cd ${app_path}; bash bin/kafka-server-start.sh -daemon  config/server.properties
  	sleep 3

	ip=`ifconfig |grep -i "inet addr" |grep -v "127.0.0.1" |awk '{print $2}' |awk -F":" '{print $2}'`
	newpid=`ps ax | grep -i 'kafka\.Kafka' | grep java | grep -v grep | awk '{print $1}'`
	if [ "x$newpid" != "x" ];then
		echo "Start ${app} on $ip OK ^-^ " 
	else
		echo "Start ${app} on $ip Failed !!!"
		exit 1
	fi
	ps -ef | grep ${app} |grep -v grep
  	sleep 3
}	
_app_stop() {
	echo "${date_time} Begin to stop app!!!"

        pid=`ps ax | grep -i 'kafka\.Kafka' | grep java | grep -v grep | awk '{print $1}'`
        if [ "x$pid" != "x" ];then
                cd ${app_path}/bin; bash kafka-server-stop.sh
                sleep 3
                # 删除软连
                #rm -rf ${app_path}/logs
        fi  
}
	
app_standalone(){
        _app_init_env
        _app_rsync_code
        _app_conf $1
        _app_start
}

app_cluster(){
        _app_init_env
        _app_rsync_code
        _app_conf $1
        _app_start
}

app_help() {
  echo "Usage: $ARG_0 [Options] [Arguments]"
  echo
  echo "- Options"
  echo "s, standalone           : 单机"
  echo "c, cluster [Arguments]  : 集群"
  echo "start			: start"
  echo "stop			: stop"
  echo "restart			: restart"
  echo "status			: status"
  echo
  echo "- Arguments" 仅用于集群
  echo "fz_env                  :仿真环境配置"
  echo "dc_env                  :数据中心环境配置"
  echo
}

ARG_0="$0"
ops_action="$1"
stages_name="$2"

case ${ops_action} in
	s|standalone)
		app_standalone standalone
	;;
	c|cluster)
		app_cluster ${stages_name}
	;;
	start)
		_app_start	
	;;
	stop)
		_app_stop
	;;
	restart)
		_app_stop
		_app_start	
	;;
	status)
		_app_status
	;;
	*)
		app_help
		echo "Please usage (standalone) ^-^!!!"
		exit 1
esac
