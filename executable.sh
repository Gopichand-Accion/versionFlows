#!/bin/bash

# Get the Container Id from the commandline.
# containerID=$(cat /proc/self/cgroup | awk -F/ '{print $3}' | sort -u | cut -c -12)
# echo "baseUrl=https://$containerID:8443" >> ${NIFI_TOOLKIT_HOME}/conf/cli.properties

echo "before wait"
sleep 60
echo "after wait"


cd ${NIFI_TOOLKIT_HOME}
touch ${NIFI_TOOLKIT_HOME}/conf/cli.properties
touch ${NIFI_TOOLKIT_HOME}/conf/cli-reg.properties
mkdir ${NIFI_TOOLKIT_HOME}/params

containerID=$(grep "nifi.web.https.host" ${NIFI_HOME}/conf/nifi.properties | awk -F "=" '{print $2}')
echo "baseUrl=https://$containerID:8443" >> ${NIFI_TOOLKIT_HOME}/conf/cli.properties

grep "nifi.security.keystorePasswd" ${NIFI_HOME}/conf/nifi.properties | awk -F "=" '{print "keystorePasswd="$2}' >> ${NIFI_TOOLKIT_HOME}/conf/cli.properties
grep "nifi.security.keyPasswd" ${NIFI_HOME}/conf/nifi.properties | awk -F "=" '{print "keyPasswd="$2}' >> ${NIFI_TOOLKIT_HOME}/conf/cli.properties
grep "nifi.security.truststorePasswd" ${NIFI_HOME}/conf/nifi.properties | awk -F "=" '{print "truststorePasswd="$2}' >> ${NIFI_TOOLKIT_HOME}/conf/cli.properties

echo 'keystore=/opt/nifi/nifi-current/conf/keystore.p12' >> ${NIFI_TOOLKIT_HOME}/conf/cli.properties
echo 'keystoreType=PKCS12' >> ${NIFI_TOOLKIT_HOME}/conf/cli.properties
echo 'truststore=/opt/nifi/nifi-current/conf/truststore.p12' >> ${NIFI_TOOLKIT_HOME}/conf/cli.properties
echo 'truststoreType=PKCS12' >> ${NIFI_TOOLKIT_HOME}/conf/cli.properties
echo 'proxiedEntity=' >> ${NIFI_TOOLKIT_HOME}/conf/cli.properties

${NIFI_TOOLKIT_HOME}/bin/cli.sh session clear
${NIFI_TOOLKIT_HOME}/bin/cli.sh session show
${NIFI_TOOLKIT_HOME}/bin/cli.sh session set nifi.props ${NIFI_TOOLKIT_HOME}/conf/cli.properties
${NIFI_TOOLKIT_HOME}/bin/cli.sh nifi get-root-id
