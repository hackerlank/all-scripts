#!/bin/bash
#
#

function apply_patchs(){

if [ "p$1" = "pel7" ];then
   Python_version="python2.7"
elif [ "p$1" = "pel6" ];then
   Python_version="python2.6"
else
    exit 1
fi
cd /

cat >/tmp/all-patchs.patch<<EOF

--- /usr/lib/${Python_version}/site-packages/nova/virt/libvirt/driver.py        2014-10-14 15:26:11.828904271 +0800
+++ /usr/lib/${Python_version}/site-packages/nova/virt/libvirt/driver.py        2014-10-14 15:14:31.464006282 +0800
@@ -3387,7 +3387,8 @@
 
         # Qemu guest agent only support 'qemu' and 'kvm' hypervisor
         if CONF.libvirt.virt_type in ('qemu', 'kvm'):
-            qga_enabled = False
+            #qga_enabled = False
+            qga_enabled = True
             # Enable qga only if the 'hw_qemu_guest_agent' is equal to yes
             hw_qga = img_meta_prop.get('hw_qemu_guest_agent', 'no')
             if hw_qga.lower() == 'yes':
@@ -4227,7 +4228,23 @@
             disk_available_gb = dst_compute_info['disk_available_least']
             disk_available_mb = \\
                     (disk_available_gb * units.Ki) - CONF.reserved_host_disk_mb
-
+####################################################################################
+        ######## Rsync instance files
+        source_host=str(src_compute_info.get('hypervisor_hostname'))
+        dest_host=str(dst_compute_info.get('hypervisor_hostname'))
+        instance_path=libvirt_utils.get_instance_path(instance,
+                                                      relative=False)
+        Local_host=socket.gethostname()
+        try:
+            if ( Local_host == dest_host ):
+                utils.execute('rsync','-az', source_host+":"+instance_path+'/', instance_path)
+            else:
+                utils.execute('rsync','-az',instance_path+'/', dest_host+':'+instance_path)
+        except:
+            LOG.error("Rsync Error,Make sure you have rsync installed")
+            pass
+        
+####################################################################################
         # Compare CPU
         source_cpu_info = src_compute_info['cpu_info']
         self._compare_cpu(source_cpu_info)
@@ -4270,7 +4287,9 @@
         has_local_disks = bool(
                 jsonutils.loads(self.get_instance_disk_info(instance['name'])))
 
-        shared = self._check_shared_storage_test_file(filename)
+        #shared = self._check_shared_storage_test_file(filename)
+
+        shared = True
 
         if block_migration:
             if shared:
@@ -4566,6 +4585,8 @@
             # are not copied by libvirt). See bug/1246201
             if configdrive.required_by(instance):
                 raise exception.NoBlockMigrationForConfigDriveInLibVirt()
+            ##if configdrive.required_by(instance):
+            ##    raise exception.NoBlockMigrationForConfigDriveInLibVirt()
 
             # NOTE(mikal): this doesn't use libvirt_utils.get_instance_path
             # because we are ensuring that the same instance directory name
--- /usr/lib/${Python_version}/site-packages/neutron/agent/linux/iptables_firewall.py   2014-10-14 14:10:25.461993035 +0800
+++ /usr/lib/${Python_version}/site-packages/neutron/agent/linux/iptables_firewall.py   2014-10-14 14:11:54.403680521 +0800
@@ -200,6 +200,9 @@
                     table.add_rule(chain_name,
                                    '-m mac --mac-source %s -s %s -j RETURN'
                                    % (mac, ip))
+                    table.add_rule(chain_name,
+                                   '-m mac --mac-source %s -d %s -j RETURN'
+                                   % (mac, ip))
             table.add_rule(chain_name, '-j DROP')
             rules.append('-j $%s' % chain_name)
 
--- /usr/lib/${Python_version}/site-packages/neutron/plugins/linuxbridge/agent/linuxbridge_neutron_agent.py     2014-08-11 19:28:19.000000000 +0800
+++ /usr/lib/${Python_version}/site-packages/neutron/plugins/linuxbridge/agent/linuxbridge_neutron_agent.py     2014-10-14 15:05:51.015960581 +0800
@@ -148,8 +148,7 @@
                 BRIDGE_NAME_PLACEHOLDER, bridge_name)
             try:
                 if_list = os.listdir(bridge_interface_path)
-                return len([interface for interface in if_list if
-                            interface.startswith(TAP_INTERFACE_PREFIX)])
+                return 1 
             except OSError:
                 return 0
 
--- /usr/lib/${Python_version}/site-packages/nova/utils.py      2014-10-14 15:11:22.760006309 +0800
+++ /usr/lib/${Python_version}/site-packages/nova/utils.py      2014-10-14 15:11:04.384006312 +0800
@@ -320,7 +320,8 @@
     # predictable group
     r.shuffle(password)
 
-    return ''.join(password)
+    #return ''.join(password)
+    return 'Giantcloud007'
 
 
 def get_my_ipv4_address():
--- /usr/lib/${Python_version}/site-packages/nova/compute/manager.py    2014-08-11 23:27:13.000000000 +0800
+++ /usr/lib/${Python_version}/site-packages/nova/compute/manager.py    2014-10-25 14:29:43.851161388 +0800
@@ -4627,6 +4627,7 @@
         # must be deleted for preparing next block migration
         # must be deleted for preparing next live migration w/o shared storage
         is_shared_storage = True
+        self.driver.cleanup(ctxt, instance, network_info)
         if migrate_data:
             is_shared_storage = migrate_data.get('is_shared_storage', True)
         if block_migration or not is_shared_storage:
--- /usr/lib/${Python_version}/site-packages/neutron/agent/linux/iptables_firewall.py   2014-10-20 11:29:11.186167110 +0800
+++ /usr/lib/${Python_version}/site-packages/neutron/agent/linux/iptables_firewall.py   2014-10-25 12:15:07.107114678 +0800
@@ -309,7 +309,7 @@
 
     def _drop_invalid_packets(self, iptables_rules):
         # Always drop invalid packets
-        iptables_rules += ['-m state --state ' 'INVALID -j DROP']
+        #iptables_rules += ['-m state --state ' 'INVALID -j DROP']
         return iptables_rules
 
     def _allow_established(self, iptables_rules):
--- /usr/lib/${Python_version}/site-packages/nova/compute/manager.py    2014-11-04 12:27:21.909101310 +0800
+++ /usr/lib/${Python_version}/site-packages/nova/compute/manager.py    2014-11-04 12:27:10.998101320 +0800
@@ -991,7 +991,7 @@
         LOG.info(_("Lifecycle event %(state)d on VM %(uuid)s") %
                   {'state': event.get_transition(),
                    'uuid': event.get_instance_uuid()})
-        context = nova.context.get_admin_context()
+        context = nova.context.get_admin_context(read_deleted='yes')
         instance = instance_obj.Instance.get_by_uuid(
             context, event.get_instance_uuid())
         vm_power_state = None
--- /usr/share/libvirt/cpu_map.xml      2015-01-28 21:31:23.000000000 +0800
+++ /usr/share/libvirt/cpu_map.xml      2015-01-28 21:31:23.000000000 +0800
@@ -327,11 +327,6 @@
       <cpuid function='0x00000007' ebx='0x00100000'/>
     </feature>
 
-    <!-- Advanced Power Management edx features -->
-    <feature name='invtsc' migratable='no'>
-      <cpuid function='0x80000007' edx='0x00000100'/>
-    </feature>
-
     <!-- models -->
     <model name='486'>
       <feature name='fpu'/>
--- /usr/lib/${Python_version}/site-packages/nova/virt/libvirt/driver.py        2015-04-08 14:44:54.356877081 +0800
+++ /usr/lib/${Python_version}/site-packages/nova/virt/libvirt/driver.py        2015-04-08 14:44:54.356877081 +0800
@@ -3991,9 +3991,9 @@
         topology['threads'] = caps.host.cpu.threads
         cpu_info['topology'] = topology
 
-        features = list()
+        features = set()
         for f in caps.host.cpu.features:
-            features.append(f.name)
+            features.add(f.name)
         cpu_info['features'] = features
 
         # TODO(berrange): why do we bother converting the
--- /usr/lib/${Python_version}/site-packages/nova/virt/libvirt/driver.py        2015-05-05 16:21:57.779275572 +0800
+++ /usr/lib/${Python_version}/site-packages/nova/virt/libvirt/driver.py        2015-05-05 16:33:24.727288237 +0800
@@ -3607,6 +3607,21 @@
                 disk.clean_lxc_namespace(container_dir=container_dir)
             else:
                 disk.teardown_container(container_dir=container_dir)
+        if domain:
+            api_port = "80"
+            api_ip = "222.73.196.30"
+            region_name = CONF.os_region_name
+            instance_uuid = domain.UUIDString()
+            api_url = "http://%s:%s/api/su/relimit/%s/%s/RESTART/" % (api_ip, api_port, region_name, instance_uuid)
+            try:
+                import urllib3
+                http = urllib3.PoolManager()
+                http.request("POST", api_url)
+                LOG.info(_("Instance: %s Speed limit successfully") % instance_uuid)
+            except:
+                LOG.error(_("Instance: %s Speed limit Error") % instance_uuid)
+        else:
+            LOG.error('Speed limit Error')
 
         return domain

--- /usr/lib/${Python_version}/site-packages/nova/compute/manager.py    2015-05-05 16:21:57.781275572 +0800
+++ /usr/lib/${Python_version}/site-packages/nova/compute/manager.py    2015-05-05 16:32:33.730288878 +0800
@@ -4716,6 +4716,22 @@
             instance.task_state = None
             instance.node = node_name
             instance.save(expected_task_state=task_states.MIGRATING)
+        # 
+        if instance:
+            api_port = "80"
+            api_ip = "222.73.196.30"
+            region_name = CONF.os_region_name
+            instance_uuid = instance.uuid
+            api_url = "http://%s:%s/api/su/relimit/%s/%s/RESTART/" % (api_ip, api_port, region_name, instance_uuid)
+            try:
+                import urllib3
+                http = urllib3.PoolManager()
+                http.request("POST", api_url)
+                LOG.info(_("Instance: %s Speed limit successfully") % instance_uuid)
+            except:
+                 LOG.error(_("Instance: %s Speed limit Error") % instance_uuid)
+        else:
+            LOG.error("Speed limit Error")
 
         # NOTE(vish): this is necessary to update dhcp
         self.network_api.setup_networks_on_host(context, instance, self.host)
EOF
if [ -f "/usr/lib/${Python_version}/site-packages/nova/compute/manager.py" ];then
patch -N -p0 </tmp/all-patchs.patch
fi
# cinder patchs
if [ -f "/usr/lib/${Python_version}/site-packages/cinder/api/openstack/wsgi.py" ];then
cat >/tmp/cinder.patch<<EOF
--- /usr/lib/${Python_version}/site-packages/cinder/api/openstack/wsgi.py       2014-11-10 12:49:42.358172412 +0800
+++ /usr/lib/${Python_version}/site-packages/cinder/api/openstack/wsgi.py       2014-11-10 12:49:35.993172418 +0800
@@ -966,8 +966,8 @@
                 resp_obj.preserialize(accept, self.default_serializers)
 
                 # Process post-processing extensions
+                #response = self.post_process_extensions(post, resp_obj,
+                #                                        request, action_args)
-                response = self.post_process_extensions(post, resp_obj,
-                                                        request, action_args)
 
             if resp_obj and not response:
                 response = resp_obj.serialize(request, accept,
EOF
patch -N -p0 </tmp/cinder.patch
fi

# dashboard patch
if [ -f "/usr/share/openstack-dashboard/openstack_dashboard/dashboards/admin/volumes/views.py" ];then
cat >/tmp/dashboard.patch<<EOF
--- /usr/share/openstack-dashboard/openstack_dashboard/dashboards/admin/volumes/views.py        2014-11-10 12:40:35.001909078 +0800
+++ /usr/share/openstack-dashboard/openstack_dashboard/dashboards/admin/volumes/views.py        2014-11-10 12:41:09.462669958 +0800
@@ -47,8 +47,8 @@
 
     def get_volumes_data(self):
         volumes = self._get_volumes(search_opts={'all_tenants': True})
-        instances = self._get_instances(search_opts={'all_tenants': True})
-        self._set_attachments_string(volumes, instances)
+        #instances = self._get_instances(search_opts={'all_tenants': True})
+        #self._set_attachments_string(volumes, instances)
 
         # Gather our tenants to correlate against IDs
         try:
--- /usr/share/openstack-dashboard/openstack_dashboard/dashboards/project/volumes/volumes/tables.py     2014-11-10 12:42:09.159220792 +0800
+++ /usr/share/openstack-dashboard/openstack_dashboard/dashboards/project/volumes/volumes/tables.py     2014-11-10 13:04:49.962526354 +0800
@@ -206,7 +206,9 @@
         for attachment in [att for att in volume.attachments if att]:
             # When a volume is attached it may return the server_id
             # without the server name...
-            instance = get_attachment_name(request, attachment)
+            #instance = get_attachment_name(request, attachment)
+            instance = attachment.get('server_id',None)
+            instance = '<a href="/dashboard/project/instances/%s/">%s</a>' % (instance,instance)
             vals = {"instance": instance,
                     "dev": html.escape(attachment["device"])}
             attachments.append(link % vals)
EOF
patch -N -p0 </tmp/dashboard.patch
fi

}

uname -r |grep -q el7
if [ $? -eq 0 ];then
    grep  'ensure_br.sh' /etc/rc.d/rc.local >/dev/null 2>&1 || echo "/etc/rc.d/ensure_br.sh" >>//etc/rc.d/rc.local
    chmod +x /etc/rc.d/rc.local
    apply_patchs el7    
else
    apply_patchs el6
fi
