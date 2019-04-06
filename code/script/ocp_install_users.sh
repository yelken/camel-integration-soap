#!/bin/sh
sudo iptables -F
# Following Env variables should exist:
# CHANGE THESE VALUES TO RIGHT OCP ENV BEFORE RUNNING THE SCRIPT

REGION=5ac0
OCP_DOMAIN=openshift.opentlc.com
OCP_SUFFIX=apps.$REGION.$OCP_DOMAIN
OCP_AMP_ADMIN_ID=api0


START_TENANT=1
END_TENANT=1

### Fuse Online

# Run setup script

	bash install_ocp_fuse_online.sh --setup

## LOOP FOR TENANTS

# loops from START_TENANT to END_TENANT to create tenant projects and applications.
# Each user is given admin rights to their corresponding projects.


for i in $(seq $START_TENANT $END_TENANT) ; do

	   
	tenantId=user$i;

	echo "Now starting deployment for user :" $tenantId;

        # Give users view access to the infra projects apicurito & 3scale-mt-api0

	oc adm policy add-role-to-user view $tenantId -n apicurito
	oc adm policy add-role-to-user view $tenantId -n 3scale-mt-api0


	# Create project for Fuse Online


    oc adm new-project $tenantId-fuse-online --admin=$tenantId  --description=$tenantId 

	sleep 5s;

	# Install Syndesis

	oc project $tenantId-fuse-online

	bash install_ocp_fuse_online.sh --grant $tenantId

	bash install_ocp_fuse_online.sh --route $tenantId-fuse-online.$OCP_SUFFIX 

	# Patch syndesis-server to add 3scale annotations to the services automatically.

       oc patch dc syndesis-server -p '{"spec":{"template":{"spec":{"containers":[{"name":"syndesis-server","env":[{"name":"CONTROLLERS_EXPOSE_VIA3SCALE","value":"true"}]}]}}}}'
done;	
