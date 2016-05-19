#!/bin/bash
#
# Use deploy Zookeeper(version=3.4.6)
# 
# dataDir=/opt/data/zookeeper/myid
# myid文件中的内容应该与zoo.cfg文件中server.*的数字一直：
# 例如：server.1=127.0.0.1:2888:3888
# 那么文件中就一定要是 1 
# 三种模式：
# 1. standalone
# 	server.1=127.0.0.1:2888:3888
# 2. pseduo-cluster
# 	server.1=127.0.0.1:2888:3888
# 	server.2=127.0.0.1:2889:3889
# 	server.3=127.0.0.1:2890:3890
# 3. cluster

date_time=`date +%Y%m%d_%H%M`
app="zookeeper"

# prod path
app_path="/opt/app/${app}"
# git path
app_repo="/opt/01-Gitlab/${app}"

fz_env="${app_repo}/stages/fz_env"
dc_sh="${app_repo}/stages/dc_sh"
m2_env="${app_repo}/stages/m2_env"

#*************************************************************
#  init env
#
_app_init_env(){
	# zookeeper data dir
	data_dir="/opt/data/${app}"
	if [ ! -d ${data_dir} ];then
		mkdir -p ${data_dir}
	fi

	# zookeeper logs dir
	yjb3_logs_dir="/yjb3_logs"
	if [ ! -f ${yjb3_logs_dir}/${app}/logs ];then
		mkdir -p  ${yjb3_logs_dir}/${app}/logs
	fi
}

#*************************************************************
_app_myid(){
	case $1 in
                cluster)
			ip=`ifconfig |grep -i "inet addr" |grep -v "127.0.0.1" |awk '{print $2}' |awk -F":" '{print $2}'`
			ip_last=`echo $ip|awk -F"." '{print $4}'`
			if [ -e ${data_dir}/myid ];then
				ids=`cat ${data_dir}/myid`	
				if [ $ids == ${ip_last} ];then
					echo "OK"
				else
					#rm -rf ${data_dir}/*
					touch ${data_dir}/myid
					echo "${ip_last}" > ${data_dir}/myid
				fi
			else	
				echo "生成myid文件......."
				#rm -rf ${data_dir}/*
				echo "${ip_last}" > ${data_dir}/myid
			fi
		;;
                standalone)
			if [ -e ${data_dir}/myid ];then
				ids=`cat ${data_dir}/myid`	
				if [ $ids == 1 ];then
					echo "OK"
				else
					rm -rf ${data_dir}/*
					touch ${data_dir}/myid
					echo "1" > ${data_dir}/myid
				fi
			else
				echo "生成myid文件......." 
				rm -rf ${data_dir}/*
				echo "1" > ${data_dir}/myid
			fi
			
                ;;
		pseduo_cluster)
			mkdir -p ${data_dir}/{zk1,zk2,zk3}
			touch ${data_dir}/zk1/myid
			echo "1" > ${data_dir}/zk1/myid
			touch ${data_dir}/zk2/myid
			echo "2" > ${data_dir}/zk2/myid
			touch ${data_dir}/zk3/myid
			echo "3" > ${data_dir}/zk3/myid
			
		;;
		*)
			echo "Uage (standalone|pseduo_cluster)"
		;;
	esac
}
#*************************************************************

# 用于同步代码程序至目标机器的目标目录
_app_rsync_code(){
        echo "${date_time} Begin to deploy ${app}!!!"

	if [ "$1" = "pseduo_cluster" ];then
		echo "pseduo_cluster"
		for ((i=1; i<4; i++)); do
			pid=`netstat -tnlp| grep 218$i |awk -F"/" '{print $1}' |awk '{print $7}'`
			if [ "x$pid" != "x" ];then
				cd ${app_path}/bin; bash zkServer.sh stop zk$i.cfg
				sleep 3
			fi  
		done
		# 删除软连
		rm -rf ${app_path}/logs

	else
		pid=`netstat -tnlp| grep 2181 |awk -F"/" '{print $1}' |awk '{print $7}'`
		if [ "x$pid" != "x" ];then
			cd ${app_path}/bin; bash zkServer.sh stop
			sleep 3
			# 删除软连
			rm -rf ${app_path}/logs
		fi  
	fi
        cd /opt
        # 删除原有所有内容,主要用于保证生产环境的代码与git版本库中的代码一致:
        rm -rf ${app_path}
        mkdir -p  ${app_path}
        rsync -vaz -q -delete --exclude="stages*" ${app_repo}/  ${app_path}    
        # 删除git库中原有的logs目录：
        rm -rf ${app_path}/logs
	# logs存放路径
	ln -s ${yjb3_logs_dir}/${app}/logs ${app_path}/logs
}
# 处理配置文件 
_app_conf(){
	case $1 in
                standalone)
			cd ${app_path}/conf
			mv zoo_sample.cfg zoo.cfg
                ;;  
                pseduo_cluster)
			cd ${app_path}/conf
			echo "server.2=127.0.0.1:2889:3889" >> zoo_sample.cfg 
			echo "server.3=127.0.0.1:2890:3890" >> zoo_sample.cfg 
			cp zoo_sample.cfg zk1.cfg
			sed -i "s@^clientPort=2181@clientPort=2181@g" zk1.cfg
			sed -i "s@^dataDir=/opt/data/zookeeper@dataDir=/opt/data/zookeeper/zk1@g" zk1.cfg
			cp zoo_sample.cfg zk2.cfg
			sed -i "s@^clientPort=2181@clientPort=2182@g" zk2.cfg
			sed -i "s@^dataDir=/opt/data/zookeeper@dataDir=/opt/data/zookeeper/zk2@g" zk2.cfg
			mv zoo_sample.cfg zk3.cfg
			sed -i "s@^clientPort=2181@clientPort=2183@g" zk3.cfg
			sed -i "s@^dataDir=/opt/data/zookeeper@dataDir=/opt/data/zookeeper/zk3@g" zk3.cfg
                ;;  
                fz_env)
                        rsync -vaz --progress ${fz_env}/ ${app_path}/conf/
                        echo "fz-env"
                ;;  
                m2_env)
                        rsync -vaz --progress ${m2_env}/ ${app_path}/conf/
                        echo "fz-env"
                ;;  
                *)  
                        echo "usage {dc_sh|yc-env}"
                        exit 1
        esac
}

# 启动服务并检测服务状态
_app_start(){
        echo "${date_time} Begin to start ${app}......!!!"
	# logs存放路径
	if [ -e ${app_path}/logs -a -L ${app_path}/logs ];then
		file  ${app_path}/logs
	else
		ln -s ${yjb3_logs_dir}/${app}/logs ${app_path}/logs
	fi

	if [ "$1" = "pseduo_cluster" ];then
		cd ${app_path}/bin
		bash zkServer.sh start  zk1.cfg
		sleep 3
		bash zkServer.sh start  zk2.cfg
		sleep 3
		bash zkServer.sh start  zk3.cfg
		sleep 3

		ip=`ifconfig |grep -i "inet addr" |grep -v "127.0.0.1" |awk '{print $2}' |awk -F":" '{print $2}'`
		for ((i=2181;i<2184;i++));do
			result=`echo "ruok" | nc $ip $i`
			if [ "$result" = "imok" ];then
				echo "Start ${app} on $ip OK ^-^ " 
				# Show Zookeepr status
				echo "stat" | nc $ip $i
				echo "****************************"
			else
				echo "Start ${app} on $ip Failed !!!"
				exit 1
			fi 
		done
	else
		cd ${app_path}/bin; bash zkServer.sh start
		sleep 5

		ip=`ifconfig |grep -i "inet addr" |grep -v "127.0.0.1" |awk '{print $2}' |awk -F":" '{print $2}'`
		result=`echo "ruok" | nc $ip 2181`
		if [ "$result" = "imok" ];then
			echo "Start ${app} on $ip OK ^-^ " 
			# Show Zookeepr status
			echo "stat" | nc $ip 2181
			echo "****************************"
		else
			echo "Start ${app} on $ip Failed !!!"
			exit 1
		fi 
	fi
}
_app_stop(){
        echo "${date_time} Begin to stop ${app}......!!!"
	pid=`netstat -tnlp| grep 2181 |awk -F"/" '{print $1}' |awk '{print $7}'`
        if [ "x$pid" != "x" ];then
                cd ${app_path}/bin; bash zkServer.sh stop
                sleep 3
                # 删除软连
                rm -rf ${app_path}/logs
        fi  
        ip=`ifconfig |grep -i "inet addr" |grep -v "127.0.0.1" |awk '{print $2}' |awk -F":" '{print $2}'`
        result=`echo "ruok" | nc $ip 2181`
        if [ "$result" = "imok" ];then
                echo "Stop ${app} on $ip Failed ^-^ " 
                exit 1
        else
                echo "Stop ${app} on $ip OK !!!"
        fi 
}

_app_restart(){
	_app_stop
	_app_start
}

_app_status(){
	newpid=`netstat -tnlp|grep 2181 |awk -F"/" '{print $1}' |awk '{print $7}'`
	if [ "x$newpid" != "x" ];then
		echo "Start ${app} OK ^-^ " 
	else
		echo "Start ${app} Failed !!!"
		exit 1
	fi
	ps -ef | grep ${app} |grep -v grep
  	sleep 5
        cd ${app_path}/bin; bash zkServer.sh status
}

app_standalone(){
	_app_init_env
	_app_myid $1
	_app_rsync_code
	_app_conf $1
	_app_start
}
app_cluster(){
	_app_init_env
	_app_myid cluster
	_app_rsync_code
	_app_conf $1
	_app_start
}
app_pseduo_cluster(){
	_app_init_env
	_app_myid $1
	_app_rsync_code $1
	_app_conf $1
	_app_start $1
}

app_help() {
  echo "Usage: $ARG_0 [Options] [Arguments]"
  echo
  echo "- Options"
  echo "s, standalone		: 单机"
  echo "p, pseduo-cluster	: 伪集群"
  echo "c, cluster		: 集群"
  echo
  echo "- Arguments" 仅用于集群
  echo "fz_env			:仿真环境配置"
  echo "dc_env			:数据中心环境配置"
  echo
}

ARG_0="$0"
ops_action="$1"
stages_name="$2"

case ${ops_action} in
	s|standalone)
		app_standalone standalone
	;;
	p|pseduo-cluster)
		app_pseduo_cluster pseduo_cluster
	;;
	c|cluster)
		app_cluster ${stages_name}
	;;
	*)
		app_help
	echo "Please usage (cluster|standalone|pseduo-cluster) ^-^!!!"
	exit 1
esac
