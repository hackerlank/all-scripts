export appname := lestore-vm
export MKROOT=$(realpath $(dir $(firstword $(MAKEFILE_LIST))))
export APP_ROOT=$(realpath $(dir $(MKROOT)))
STAGE_PATH := $(APP_ROOT)/stages

.PHONY: deploy install

PUPPET_ROOT := /home/ec2-user/puppet

include $(MKROOT)/common/common.mak

#export stage := $(shell $(call get_stage,stack.output)) export stage := $(shell $(call fallback,$(stage_name)))

define fetch_rpms
if [ -e $(repo_dir) ]; then cp -r $(repo_dir)/rpms/$(1) $(2); \
else $(SSH_KEY_ENV) $(RSYNC) -e "$(repo_ssh)" $(repo_loc):$(repo_dir)/rpms/$(1) $(2); fi
endef

define init_host_name_conf
sudo bash -c 'echo "host_name=$$(cat /home/ec2-user/nodename \
		| $(SED) "s/^am-/aa-/" | $(SED) "s/^jenjen-/mje-/" | $(SED) "s/^jjs-/mjs-/" \
		| tr a-z A-Z)" > /var/job/host_name.conf'
endef

define install_bbcp
xargs -I {} bash -c "dns={}; \
	$(SSH_KEY_ENV) $(RSYNC) -e '$(stack_ssh)' $(MKROOT)/bbcp $(stack_user)@\$${dns}:~ ; \
	$(stack_ssh) -t -t $(stack_user)@\$${dns} \
	        '[ -e /usr/local/bin/bbcp ] || (sudo cp bbcp /usr/local/bin/; sudo chmod +x /usr/local/bin/bbcp)'"
endef

initialize:
	$(call checkvar,stack_fullname)
	$(call checkvar,stack_access)
	$(call checkvar,stack_port)
	< $(stack_vms) $(get_stack_vm_ips) > stack.ips
	@echo '------ install bbcp to instances ------'
	@cat stack.ips
	@echo '-----------------------------------'
	< stack.ips $(install_bbcp)


deploy: 
	echo deploy@stage : $(stage)
	#$(call fetch_rpms,nginx-*.rpm,$(APP_ROOT)/puppet/modules/lebbay/files/nginx/binaries)
	#$(call fetch_rpms,php-*.rpm,$(APP_ROOT)/puppet/modules/lebbay/files/php/binaries)
	$(MAKE) dispatch


install: nodename := /home/ec2-user/nodename
install: stack_vms := stack.vms
install: 
	echo install@stage : $(stage)
	$(call checkvar,stack_fullname)
	internal_ip=$$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4); \
		<$(stack_vms) grep -E '^INSTANCE' | grep "$${internal_ip}" | awk '{print $$2}' | xargs -I {} sudo bash -c '<$(stack_vms) grep -E "^TAG" | grep "Name" | grep $$0 | cut -f 5 > $(nodename)' {} 
	sudo mkdir -p /opt/data1
	#[ -e /dev/xvdf ] #better verification
	if [ -e /dev/xvdf ]&&[ -z "`sudo blkid /dev/xvdf`" ] ; then  sudo mkfs.ext4 -N 9830400 /dev/xvdf;fi
	if [ -n "$$(df -h | grep "/dev/xvda1" | grep "/")" ]; then sudo resize2fs /dev/xvda1; fi
	-[ -e /dev/xvdf ] && sudo mount /dev/xvdf /opt/data1
	-[ -e /dev/xvdf ] && sudo bash -c "cat /etc/fstab | grep -v /dev/xvdf > fstab.tmp; mv -f fstab.tmp /etc/fstab; echo '/dev/xvdf /opt/data1 ext4 defaults,noatime 0 0' >> /etc/fstab"
	mkdir -p $(PUPPET_ROOT)/modules
	mkdir -p $(PUPPET_ROOT)/manifests
	-rm -fr $(PUPPET_ROOT)/manifests/00.puppet.pp
	-rm -fr $(PUPPET_ROOT)/modules/lebbay
	cp -R $(MKROOT)/../puppet/manifests/* $(PUPPET_ROOT)/manifests/
	cp -R $(MKROOT)/../puppet/modules/* $(PUPPET_ROOT)/modules/
	sudo cp -fr $(STAGE_PATH)/$(stage_name)/aws.cms /root/.ssh/
	sudo chown root.root /root/.ssh/aws.cms
	sudo chmod 600 /root/.ssh/aws.cms
	sudo mkdir -p /var/job
	$(call init_host_name_conf);
	sudo cp -f $(PUPPET_ROOT)/modules/lebbay/files/os/var/job/run_puppet.sh /var/job/
	sudo chmod u+x /var/job/run_puppet.sh
	@#sudo /var/job/run_puppet.sh
	-[ ! -d /var/www ] && sudo mkdir -p /var/www
	sudo tar xzf $(MKROOT)/$$(ls xhprof*.tar.gz) -C /var/www
	sudo tar xzf $(MKROOT)/$$(ls jjshouse_monitor.tar.gz) -C /var/www 
