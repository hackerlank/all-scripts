#stack_access ?= test.aws
region ?= us-east-1#eol

STACK_STATUS := stack-status#eol
STATUS_LIVE := live#eol
STATUS_DOWN := down#eol
STATUS_TEST := test#eol

define retrieve_stack_output
cfn-describe-stacks $(1) --region $(region) --show-xml \
| $(XML) sel -N x="http://cloudformation.amazonaws.com/doc/2010-05-15/" -T -t \
-m "/x:DescribeStacksResponse/x:DescribeStacksResult/x:Stacks/x:member/x:Outputs/x:member" \
-v "concat(x:OutputKey,'=',x:OutputValue)" -n
endef

define get_frontend
grep ',frontend,'
endef

define check_tag
xargs -I {} ec2-describe-tags --region $(region) -F "resource-id={}" -F "key=$(1)" -F "value=$(2)"
endef

define check_live
	if [ -n "`< $(2) grep '^TAG' | grep '$(STACK_STATUS)' | grep '$(STATUS_LIVE)'`" ]; then \
	        echo [ERR] There is live instance in $(1); exit 1; fi
	@echo $(1) live check passed!
endef
