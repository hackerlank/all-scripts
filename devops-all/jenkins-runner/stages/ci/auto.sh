#!/bin/bash

#configuration
APPNAME="lestore-runner"
#DEPLOYER="54.196.132.127"
#PORT="38022"
#KNOWN_HOSTS="${USER_HOME}/.ssh/known_hosts"
USER_HOME="/home/gitlab_ci_runner"
KEY_DIR="${USER_HOME}/.awstools/keys"
APP_ROOT=$(pwd)
STAGE_PATH=$(pwd)/stages

#add deployer to ssh known_hosts
#ssh-keygen -f ${KNOWN_HOSTS} -H -F ${DEPLOYER} | grep found || ssh-keyscan -p ${PORT} -t rsa ${DEPLOYER} >> ${KNOWN_HOSTS}

#copy keys to target directory
test -d ${KEY_DIR} || mkdir -p ${KEY_DIR}
rm -fr ${KEY_DIR}/*
cp -f ${APP_ROOT}/keys/* ${KEY_DIR}/
chmod 600 ${KEY_DIR}/*

#copy ssh config
#cp -f ${APP_ROOT}/config ${USER_HOME}/.ssh/
#chmod 600 ${USER_HOME}/.ssh/config

#test ssh connection
#ssh ec2-user@${DEPLOYER} -p38022 -t -t "echo ok"

#install lestore-runner
mkdir -p ${USER_HOME}/${APPNAME}
rm -fr ${USER_HOME}/${APPNAME}/*
cp -fr stages ${USER_HOME}/${APPNAME}/
