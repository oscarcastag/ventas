#!/bin/sh
#
# This script is used to do tailor the OpenEdge ESB Adapter.
#

XQ_HOME=[[sonic-esb]]

# Setup up environment variables:
. "$XQ_HOME/bin/setenv.sh"

# The classes used by the directory service container
DS_LIB=$MGMT_LIB:$SONIC_LIB:$XQ_HOME/lib/xq_config.jar:[[install-dir]]/install/tlr:

# Boot xerces first so that it doesn't get picked up in jvm's lib/ext:
DS_JVM_ARGS="-Xbootclasspath/p:[[sonic-mq]]/lib/xercesImpl.jar:[[sonic-mq]]/lib/xmlParserAPIs.jar -Dverbose=true"

echo Tailoring the OpenEdge ESB Adapter...
cd [[install-dir]]/install/tlr
"$JAVA_HOME/bin/java" $DS_JVM_ARGS -classpath "$DS_LIB" mqadaptertlr offline

