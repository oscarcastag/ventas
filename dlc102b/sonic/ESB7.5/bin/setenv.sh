#!/bin/sh
#
# This script is used to initialize the SonicXQ environment.
#
# Directory service properties. These are the properties used to connect
# to the SonicMQ broker hosting the directory service that contains
# configuration information.

XQ_HOME="/dlc/dlc102b/sonic/ESB7.5"
XQ_LIB="$XQ_HOME/lib"
XQ_CONFIG="$XQ_HOME/config"

MQ_LIB=/dlc/dlc102b/sonic/MQ7.5/lib

# The management framework classpath
MGMT_LIB="$MQ_LIB/jmxri.jar:$MQ_LIB/mgmt_client.jar:$MQ_LIB/sonic_mgmt_client.jar:$MQ_LIB/mgmt_config.jar:$MQ_LIB/MFdirectory.jar"

# Classpath for SonicMQ classes client subcomponents are referenced
# in sonic_Client.jar's manifest:
SONIC_LIB="$MQ_LIB/sonic_Client.jar"
SONIC_JVM_ARGS=

# 3rd party Supporting classes:
SUPPORT_LIB="$MQ_LIB/mail.jar:$MQ_LIB/soap.jar:$XQ_HOME/explorer:$MQ_LIB/js.jar:$XQ_HOME/lib/jsr173_api.jar:$XQ_HOME/lib/jaxp-1.3/jaxp-api.jar:$XQ_HOME/lib/saxon8-dom.jar:$XQ_HOME/lib/saxon8.jar:$XQ_HOME/lib/saxon8-xpath.jar"

# The home directory of jre version 1.4.
JAVA_HOME="/usr/java/jre1.5.0_22"

# The classpath to use with SonicMQ Broker Extensions:
SMQ_CLASSPATH_EXT="$XQ_CONTAINER_CLASSPATH_EXT:$SMQ_CLASSPATH_EXT:$XQ_LIB/xq_admin.jar:$XQ_LIB/xq_container.jar:$SUPPORT_LIB:$MQ_LIB/sonic_mgmt_client.jar:$MQ_LIB/mfcontext.jar"

# ESB classpath extensions for Sonic Management Console startup (picked up by MQ/bin/startmc.sh)
SMC_CLASSPATH_EXT="$SMQ_CLASSPATH_EXT"

# Hook for adding/modifying environment variables
if [ -d "$XQ_HOME/bin/setenv" ]
then
   for a in $XQ_HOME/bin/setenv/*.sh; do . "$a"; done
fi