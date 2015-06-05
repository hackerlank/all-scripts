export appname := lestore-db
export MKROOT=$(realpath $(dir $(firstword $(MAKEFILE_LIST))))
export APP_ROOT=$(realpath $(dir $(MKROOT)))

.PHONY: deploy install

include $(MKROOT)/common/common.mak

PARAM_NAMES += dbname

PUPPET_ROOT := /home/ec2-user/puppet
#export stage = $(shell $(call get_stage_fallback,stack.output))
export stage := $(shell $(call fallback,$(stage_name)))
export dataset := basedbdatatest
export dataset_sql := $(dataset).sql
export osticket_sql := osticket.sql
export dataset_chk := $(dataset)_checksum
export dataset_zip  := $(dataset).sql.tar.gz
export osticket_zip := $(osticket_sql).tar.gz
export dbname ?= jjshouse

onRepo := $(shell if [ -e $(repo_dir) ]; then echo true; else echo false; fi)

deploy:
	@echo deploy@stage : $(stage)
ifneq (filter,$(vm_action))
ifeq (true,$(onRepo))
	cp $(repo_dir)/testdb/$(dbname)/$(dataset_zip) $(APP_ROOT)/sql/
	cp $(repo_dir)/testdb/$(osticket_zip) $(APP_ROOT)/sql/
else
	$(call checkvar,repo_addr)
	$(SSH_KEY_ENV) $(RSYNC) -e "$(repo_ssh)" $(repo_loc):$(repo_dir)/testdb/$(dbname)/$(dataset_zip) $(APP_ROOT)/sql/
endif
endif
	$(call write_param,dbname)
	rm -fr $(APP_ROOT)/sql/*.sql
	$(MAKE) dispatch

install:
	@echo install@stage : $(stage)
	-rm -fr $(PUPPET_ROOT)/manifests/00.puppet.pp
	-rm -fr $(PUPPET_ROOT)/manifests/04.lestore-db.pp
	-rm -fr $(PUPPET_ROOT)/modules/testdb
	cp -fR $(APP_ROOT)/puppet/manifests/*.pp $(PUPPET_ROOT)/manifests/
	cp -fR $(APP_ROOT)/puppet/modules/testdb $(PUPPET_ROOT)/modules/
	sudo /var/job/run_puppet.sh
	$(MAKE) import

import: dbname := $(shell $(call get_param,dbname))
import:
	@echo import@stage : $(stage)
	$(call checkvar,dbname)
	rm -fr $(APP_ROOT)/sql/*.sql
	mysqldump -h localhost -P3306 -u$(dbname) -p'$(dbname)' --skip-lock-tables --skip-add-locks --skip-add-locks $(dbname) order_info order_goods goods_style goods_sku order_extension users > $(APP_ROOT)/sql/data.sql
	cd $(APP_ROOT)/sql ; ls $(dataset_zip) | xargs -I {} tar -xzf {}
	#cd $(APP_ROOT)/sql ; ls $(osticket_zip) | xargs -I {} tar -xzf {} #deprecated, not used for now, old structure
	cd $(APP_ROOT)/sql ; [ $$(md5sum $(dataset_sql) | cut -d' ' -f 1)  == $$(cat $(dataset_chk)) ]
	cd $(APP_ROOT)/sql ; ls *.sql | xargs -I {} bash -c "echo Importing {} ... ; < {} mysql -h localhost -u $(dbname) -p'$(dbname)' $(dbname)"
	if [ "$(dbname)" == "jjshouse" ]; then cd $(APP_ROOT)/sql/test.init; ls *.sql | xargs -I {} bash -c "echo Importing {} ... ; < {} mysql -h localhost -u jjshouse -p'jjshouse' jjshouse"; fi
	rm -fr $(APP_ROOT)/sql/*

filter:
	@echo build filter @$(stage)
	chmod u+x $(APP_ROOT)/filter/build.sh
	cd $(APP_ROOT)/filter; ./build.sh
