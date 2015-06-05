#################MERGE TEMPLATES#####################
.PHONY : merge

#------DEFAULT PARAMTERS-------
dest_file ?= template.json

#stack_params ?= FrontEnd:ddt:aabb DB:db:abc

temp_file ?= temp_template.json  # temp file that can be ignor

#------FUNCTIONS------

#-------common functions----

define get_resource
< $(1) $(SED) "s/@@##(\w+)##@@/$(2)/g" 
endef

define insert_file
if [ -e $(1) ]; then < ${dest_file} $(SED) "/@@##$(2)##@@/r $(1)" | $(SED) "/@@##$(2)##@@/a ," > ${temp_file}; mv ${temp_file} ${dest_file}; else exit 1; fi
endef

define get_az_cand
ec2-describe-availability-zones --region $(region) | cut -d$$'\t' -f2
endef

define specify_az
$(SED) -i "s/##AZ##/$(2)/g" $(1)
endef

define get_az
cat $(1) | xargs -I {} bash -c '[ -n "`echo {} | cut -d'-' -f3 | grep '$(2)'`" ] && echo {}'
endef


#---------------------

merge :
	$(call checkvar,stack_name)
	$(call checkvar,stack_params)
	$(call checkvar,dest_file)
	cd $(stack_name); cp main.json ${dest_file} 
	cd $(stack_name); tags=`< main.json grep "@@##" | $(SED) 's/##/:/g' | cut -d : -f 2  | xargs -d ' '`; \
	$(call get_az_cand) > az_cand; \
	for tag in $${tags}; do \
	    for param in ${stack_params}; do \
	        pair="$${param}"; \
            template_name=`echo $${pair} | cut -d : -f 1`; \
            resource_name=`echo $${pair} | cut -d : -f 2`; \
            resource_id=1; \
            azs=`echo $${pair} | cut -d : -f 3 | $(SED) 's/./& /g'`; \
	        [ -e $${tag}.$${template_name}.json ] && (for i in $${azs}; do \
                    $(call get_resource,$${tag}.$${template_name}.json,$${resource_name}$${resource_id}) > temp_resource; \
                    $(call get_az,az_cand,$$i) > az; \
                    [ -n "`cat az`" ] || (echo 'can not find specified AvailabilityZone' $$i.; exit 1); \
                    $(call specify_az,temp_resource,$$(cat az)); \
                    $(call insert_file,temp_resource,$${tag}); \
                    resource_id=`expr $${resource_id} + 1`; \
                    rm -f temp_resource; \
            done) \
	    done; \
	    < ${dest_file} $(SED) "/@@##$${tag}##@@/d" > ${temp_file}; \
        mv ${temp_file} ${dest_file}; \
        rm -rf az az_cand; \
	done;
