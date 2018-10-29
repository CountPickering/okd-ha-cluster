# Create an OSEv3 group that contains the master, nodes, etcd, and lb groups.
# The lb group lets Ansible configure HAProxy as the load balancing solution.
# Comment lb out if your load balancer is pre-configured.
[OSEv3:children]
masters
nodes
etcd
lb

# Set variables common for all OSEv3 hosts
[OSEv3:vars]

#Force firealld
os_firewall_use_firewalld=True

ansible_ssh_user=ansible
openshift_deployment_type=origin


# uncomment the following to enable htpasswd authentication; defaults to DenyAllPasswordIdentityProvider
#openshift_master_identity_providers=[{'name': 'htpasswd_auth', 'login': 'true', 'challenge': 'true', 'kind': 'HTPasswdPasswordIdentityProvider'}]
# Allow all auth
openshift_master_identity_providers=[{'name': 'allow_all', 'login': 'true', 'challenge': 'true', 'kind': 'AllowAllPasswordIdentityProvider'}]

openshift_release="3.11"

# Native high availability cluster method with optional load balancer.
# If no lb group is defined installer assumes that a load balancer has
# been preconfigured. For installation the value of
# openshift_master_cluster_hostname must resolve to the load balancer
# or to one or all of the masters defined in the inventory if no load
# balancer is present.
openshift_master_cluster_method=native
openshift_master_cluster_hostname=openshift-internal.ocp.local
openshift_master_cluster_public_hostname=openshift-cluster.ocp.local
openshift_master_default_subdomain=apps.ocp.local

# Manage openshift example imagestreams and templates during install and upgrade
openshift_install_examples=true

# Specify a list of block devices to be formatted and mounted on the nodes
# during prerequisites.yml. For each hash, "device", "path", "filesystem" are
# required. To add devices only on certain classes of node, redefine
# container_runtime_extra_storage as a group var.
container_runtime_extra_storage='[{"device":"/dev/sdc","path":"/var/lib/origin/openshift.local.volumes","filesystem":"xfs","options":"gquota"}]'

# host group for masters
[masters]
ose-master[1:3].ocp.local

# host group for etcd
[etcd]
ose-master[1:3].ocp.local

# Specify load balancer host
[lb]
ose-lb.ocp.local

# host group for nodes, includes region info
[nodes]
ose-master[1:3].ocp.local openshift_node_group_name='node-config-master'
ose-app[1:3].ocp.local openshift_node_group_name='node-config-compute'
ose-infra[1:3].ocp.local openshift_node_group_name='node-config-infra'


