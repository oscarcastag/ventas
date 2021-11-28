#!/bin/sh
#
# This script is used to do tailor the OpenEdge ESB Adapter.
#

XQ_HOME=/dlc/dlc102b/sonic/ESB7.5

# Setup up environment variables:
. "$XQ_HOME/bin/setenv.sh"

# The classes used by the directory service container
DS_LIB=$MGMT_LIB:$SONIC_LIB:$XQ_HOME/lib/xq_config.jar:/dlc/dlc102b/install/tlr:

# Boot xerces first so that it doesn't get picked up in jvm's lib/ext:
DS_JVM_ARGS="-Xbootclasspath/p:/dlc/dlc102b/sonic/MQ7.5/lib/xercesImpl.jar:/dlc/dlc102b/sonic/MQ7.5/lib/xmlParserAPIs.jar -Dverbose=true"

echo Tailoring the OpenEdge ESB Adapter...
cd /dlc/dlc102b/install/tlr
"$JAVA_HOME/bin/java" $DS_JVM_ARGS -classpath "$DS_LIB" mqadaptertlr offline

