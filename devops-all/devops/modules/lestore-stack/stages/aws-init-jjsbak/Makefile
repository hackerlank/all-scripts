ifeq (Darwin,$(shell uname -s))
SED := sed -E
else
SED := sed -r
endif

REGION ?=

ADMIN_ACCESS ?= 118.242.38.78/32

DEPLOYER_SG ?= lestore-devops-deployer
MONITOR_SG ?= lestore-devops-monitor
TESTBED_SG ?= lestore-testbed
PRODUCTION_SG ?= lestore-production

SSH_PORT ?= 38022
MONITOR_PORT ?= 5666
BBCP_PORT ?= 39000-39010

basesg:
	ec2-create-group --region $(REGION) $(MONITOR_SG)
	ec2-authorize --region $(REGION) $(MONITOR_SG) -P tcp -p $(SSH_PORT) -s $(ADMIN_ACCESS) 
	ec2-create-group --region $(REGION) $(DEPLOYER_SG)
	ec2-authorize --region $(REGION) $(DEPLOYER_SG) -P tcp -p $(SSH_PORT) -s $(ADMIN_ACCESS) \
		-P tcp -p $(SSH_PORT) -u $(DEPLOYER_SG) \
		-P tcp -p $(MONITOR_PORT) -u $(MONITOR_SG) \
		-P tcp -p $(BBCP_PORT) -u $(DEPLOYER_SG) 

testsg:
	ec2-create-group --region $(REGION) $(TESTBED_SG)
	ec2-authorize --region $(REGION) $(DEPLOYER_SG) -P tcp -p $(BBCP_PORT) -u $(TESTBED_SG) 
	ec2-authorize --region $(REGION) $(TESTBED_SG) -P tcp -p $(SSH_PORT) -u $(ADMIN_ACCESS) \
		-P tcp -p $(SSH_PORT) -u $(DEPLOYER_SG) \
		-P tcp -p $(MONITOR_PORT) -u $(MONITOR_SG)

prodsg:
	ec2-create-group --region $(REGION) $(PRODUCTION_SG)
	ec2-authorize --region $(REGION) $(DEPLOYER_SG) -P tcp -p $(BBCP_PORT) -u $(PRODUCTION_SG) 
	ec2-authorize --region $(REGION) $(PRODUCTION_SG) -P tcp -p $(SSH_PORT) -u $(ADMIN_ACCESS) \
		-P tcp -p $(SSH_PORT) -u $(DEPLOYER_SG) \
		-P tcp -p $(MONITOR_PORT) -u $(MONITOR_SG)

keys:
	ls -1 keys/*.pub | $(SED) 's/(.*)\.pub/\1/' | xargs -I {} ec2-import-keypair --region $(REGION) {} -f keys/{}.pub

cleanall:
