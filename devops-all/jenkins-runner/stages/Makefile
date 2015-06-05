export MKROOT=$(realpath $(dir $(firstword $(MAKEFILE_LIST))))
export APP_ROOT=$(realpath $(dir $(MKROOT)))
SHELL := /bin/bash
MAKE  := make
SED := sed -r
AWK := awk
GIT := git 
NULL :=#eol
NO_OUTPUT := 1>/dev/null 2>&1

ifeq ($(proxychains),true)
PROXYCHAINS := proxychains
else
PROXYCHAINS :=$(NULL)
endif

.PHONY: deploy build 
############# COMMON DEFINITION ##########{
## deployer repo config
gitlab_host := 192.168.0.26
gitlab_port := 32200

SSH:= ssh -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no
repo_host ?= deployer-test.opvalue.com
repo_port ?= 38022
repo_user := ec2-user
branches := develop release hotfix
repo_dir := /home/ec2-user/git_repo
repo_addr_prefix := ssh://$(repo_user)@$(repo_host):$(repo_port)$(repo_dir)
repo_ssh := $(SSH) $(repo_user)@$(repo_host) -p$(repo_port)

remote_name := deployer
default_name := origin
MASTER := master
branch ?= master

##runner jenkins command config
runner_home := /home/gitlab_ci_runner
jenkins_cli := $(runner_home)/lestore-runner/stages/jenkins-cli.jar
jenkins_key := $(runner_home)/.awstools/keys/opsman_jenkins
jenkins_url := http://192.168.0.5:8080/jenkins
jenkins_job ?= lestore-syncRepo
jenkins_cmd := java -jar $(jenkins_cli) -s $(jenkins_url) -i $(jenkins_key)
############# COMMON DEFINITION ##########}

#----- check and print required variables ----- {
define checkvar
@if [ "$($(1))" == "" ]; then \
	echo "'$(1)' not defined!"; exit 1; else echo "use: '$(1)'='$($(1))'"; fi
endef
#----- check and print required variables ----- }

#----- get command return value ----{
define get_result
$(1) $(NO_OUTPUT); echo $$?
endef
#----- get command return value ----}

#----- git related functions ----{
define get_repo
$(GIT) remote -v  | grep fetch | grep $(default_name) | awk '{print $$2}' | head -1 | $(SED) 's|([[:digit:]]{1,3}\.){3}[[:digit:]]{1,3}|$(gitlab_host)|'
endef

define rm_branch
$(GIT) branch | $(SED) 's/^(\*|\s)//' | grep -v $(MASTER) | xargs -I {} $(GIT) branch -D {}
endef
define rm_repo
$(GIT) remote | grep -v $(default_name) | xargs -I {} $(GIT) remote rm {}
endef
define add_repo
$(GIT) remote add $(1) $(2)
endef
##create remote repo if not exists
define create_remote_repo
$(PROXYCHAINS) $(repo_ssh) "if [ ! -d $(1) ]; then echo create remote repo; $(GIT) init --bare $(1); fi"
endef

##get remote branch
define get_remote_branch
$(PROXYCHAINS) $(GIT) ls-remote $(1) 2>&1 | $(SED) '/^From.*/d' | grep -v 'HEAD' | $(AWK) '{print $$2}' | $(SED) "s#^refs/heads/##" | xargs
endef

##sync branch both in remote branch and branch defined in variable.
##Parameter branches local_repo remote_repo
define sync_branches
    remote_branch=$$($(call get_remote_branch,$(2))); \
    for b in $(1); do \
     if [ $$(echo $${remote_branch} | grep $${b} $(NO_OUTPUT); echo $$?) -eq 0 ]; then \
       $(GIT) checkout -b $${b} --track $(2)/$${b}; if [ $$($(call get_result, $(PROXYCHAINS) $(GIT) push --tags $(3) $${b})) -ne 0 ]; then \
	   echo "Pushing branch error on $(project)"; exit 1; fi; \
     fi; \
    done
endef

## get the pushed branch
define get_refs
if [ -z "$$(echo $(CI_BUILD_REF_NAME) | grep -E '^refs/tags')" ]; then \
    echo $(CI_BUILD_REF_NAME); \
else \
    echo "pushtags"; \
fi
endef

## get remote branch
## parameter remote repo name
define get_repo_branch
$(PROXYCHAINS) $(GIT) ls-remote $(1) | awk '{print $$2}' | grep -E -v "^refs/tags" | $(SED) 's#^refs/heads/##' | grep -v "HEAD" | grep -v "master" | sort
endef

## get remote tag
## parameter remote repo name
define get_repo_tag
$(PROXYCHAINS) $(GIT) ls-remote $(1) | awk '{print $$2}' | grep -E '^refs/tags' | grep -v '\^{}' | $(SED) 's#refs/tags/##' | sort
endef

## get diff
## parameter file name to be compared, note that local file name must be the first parameter
define get_diff
awk '{a[$$1]++}END{for(i in a){if(a[i]==1)print i}}' $(1) $(2) | xargs -I {} bash -c 'if [ -n "$$(grep -E "^$$0$$" $(2))" ]; then echo $$0; fi' {}
endef

## clean repo tags
## parameter file name containing remote tags
define clean_local_tags
$(GIT) tag | xargs -I {} bash -c 'if [ -z "$$(grep -E "^$$0$$" $(1))" ]; then echo "remove tag $$0"; $(GIT) tag -d $$0; fi' {}
endef

## remove remote refs
## parameter file name containing tags or branches
## parameter remote repo name
define remove_refs
cat $(1) | xargs -n 1 -P 3 -I {} bash -xec '$(PROXYCHAINS) $(GIT) push --delete $(2) $$0' {}
endef

## disable ssh asking known_hosts
define disable_ask_known_hosts
test -f $(1) || (mkdir -p $$(dirname $(1))); \
grep StrictHostKeyChecking $(1) >/dev/null || echo "StrictHostKeyChecking no" >> $(1); \
grep CheckHostIP $(1) >/dev/null || echo "CheckHostIP no" >> $(1); \
grep UserKnownHostsFile $(1) >/dev/null || echo "UserKnownHostsFile=/dev/null" >> $(1); \
chmod 700 $$(dirname $(1)); \
chmod 600 $(1)
endef
#----- git related functions ----}

##install lestore-runner to jenkins
install: branch ?= master
install: jenkins_user_home := /var/jenkins
install: known_hosts := $(jenkins_user_home)/.ssh/known_hosts
install: jenkins_home := /var/jenkins/repo/jenkins
install: runner_dir := $(jenkins_home)/lestore-runner
install: key_dir := $(jenkins_home)/repo/keys
install:
	@echo "Install lestore-runner to jenkins."
	$(call checkvar,runner_dir)
	
	mkdir -p $(runner_dir)
	rm -fr $(runner_dir)/*
	cp -fr $(APP_ROOT)/stages $(runner_dir)

_key:
	ssh-keygen -f $(known_hosts) -H -F $(repo_host) | grep found || ssh-keyscan -p $(repo_port) -t rsa $(repo_host) >> $(known_hosts)
	mkdir -p $(key_dir)
	cp -f $(APP_ROOT)/keys/* $(key_dir)
	ls $(APP_ROOT)/keys/* | xargs -I {} ssh-add $(key_dir)/{}

deploy: export ROOT := ../src
deploy: lock := $(ROOT)/$(project_name).lock
deploy:
	test -d $(ROOT) || mkdir -p $(ROOT)
	flock -x $(lock) -c "$(MAKE) _deploy -f $(firstword $(MAKEFILE_LIST))"

_deploy: repo := $(repo)
_deploy: project := $(project_name)
_deploy: ssh_config := ~/.ssh/config
_deploy: 
	$(call checkvar,repo)
	$(call checkvar,project)
	$(call checkvar,refspec)
	test -d $(ROOT)/$(project) || mkdir -p $(ROOT)/$(project)
	$(call disable_ask_known_hosts,$(ssh_config))
	cd $(ROOT)/$(project); if [ $$($(call get_result,$(GIT) status)) -ne 0 ]; then $(GIT) clone $(repo) .; fi
	cd $(ROOT)/$(project); if [ $$($(get_repo)) != "$(repo)" ]; then ls -al | sed -r '1,3d' | awk '{print $$9}' | xargs -I {} rm -fr {}; $(GIT) clone $(repo) .;fi 
	cd $(ROOT)/$(project); $(GIT) checkout $(MASTER); $(GIT) reset --hard; $(rm_branch); $(rm_repo); 
	cd $(ROOT)/$(project); $(call create_remote_repo,$(repo_dir)/$(project).git)
	@echo "remote repo addr $(repo_addr_prefix)/$(project_name).git"
	cd $(ROOT)/$(project); $(GIT) fetch --all 
	cd $(ROOT)/$(project); $(GIT) checkout $(MASTER); $(GIT) merge $(default_name)/$(MASTER); 
	cd $(ROOT)/$(project); $(call add_repo,$(remote_name),$(repo_addr_prefix)/$(project_name).git)
	cd $(ROOT)/$(project); $(PROXYCHAINS) $(GIT) push --tags $(remote_name) $(MASTER)
	if [ "$(refspec)" == "all" ]; then \
	  cd $(ROOT)/$(project); $(call sync_branches,$(branches),$(default_name),$(remote_name)); \
	elif [ "$(refspec)" == "pushtags" ]; then \
	  cd $(ROOT)/$(project); $(PROXYCHAINS) $(GIT) push --tags $(remote_name); \
	elif [ "$(refspec)" != "master" ]; then \
	  cd $(ROOT)/$(project); $(GIT) checkout -b $(refspec) --track $(default_name)/$(refspec); $(PROXYCHAINS) $(GIT) push --tags $(remote_name) $(refspec); \
	fi
ifeq ($(clean_repo),true)
	$(MAKE) _clean -f $(firstword $(MAKEFILE_LIST)) project=$(project_name)
endif

#remove obsolete branch and tag on deployer 
_clean: project := $(project_name)
_clean: default_name_list := _$(default_name)_list
_clean: remote_name_list := _$(remote_name)_list
_clean:
	$(call checkvar,project)
	cd $(ROOT)/$(project); $(call get_repo_branch,$(default_name)) > $(default_name_list)
	cd $(ROOT)/$(project); $(call get_repo_branch,$(remote_name)) > $(remote_name_list)
	cd $(ROOT)/$(project); $(call get_diff,$(default_name_list),$(remote_name_list)) > _delete_branch
	@echo "-------- Obsolete branches --------"
	@cd $(ROOT)/$(project); cat _delete_branch
	@echo "-----------------------------------"
	cd $(ROOT)/$(project); $(call remove_refs,_delete_branch,$(remote_name))
	cd $(ROOT)/$(project); $(call get_repo_tag,$(default_name)) > $(default_name_list)
	cd $(ROOT)/$(project); $(call get_repo_tag,$(remote_name)) > $(remote_name_list)
	cd $(ROOT)/$(project); $(call get_diff,$(default_name_list),$(remote_name_list)) > _delete_tag
	@echo "-------- Obsolete tags ----------"
	@cd $(ROOT)/$(project); cat _delete_tag
	@echo "---------------------------------"
	cd $(ROOT)/$(project); $(call remove_refs,_delete_tag,$(remote_name))
	cd $(ROOT)/$(project); $(call clean_local_tags,$(default_name_list))
	cd $(ROOT)/$(project); rm -fr $(default_name_list) $(remote_name_list)

build: repo ?= $(shell if [ "$(MAKECMDGOALS)" == "build" ]; then $(get_repo); fi)
build: project := $(project_name)
build: branch := $(shell if [ "$(MAKECMDGOALS)" == "build" ]; then $(get_refs); fi)
build:
	$(call checkvar,project)
	$(jenkins_cmd) build $(jenkins_job) -p repo=$(repo) -p project=$(project) -p refspec=$(branch)

