#!/bin/sh
#
# This script is used to seed an empty directory service for SonicXQ.
#

XQ_HOME=[[sonic-esb]]

# Setup up environment variables:
. "$XQ_HOME/bin/setenv.sh"

# The classes used by the directory service container
DS_LIB=$MGMT_LIB:$SONIC_LIB:$XQ_HOME/lib/xq_config.jar;

# Boot xerces first so that it doesn't get picked up in jvm's lib/ext:
DS_JVM_ARGS="-Xbootclasspath/p:[[install-dir]]/lib/xercesImpl.jar:[[install-dir]]/lib/xmlParserAPIs.jar -Dverbose=true"

echo Adding XQ container to MF container...
"$JAVA_HOME/bin/java" $DS_JVM_ARGS -classpath "$DS_LIB" com.sonicsw.xqimpl.tools.install.config.ContainerConfig -url [[ds-url]] -domain [[ds-domain]] -user [[ds-user]] -password [[ds-password]]  -containers [[container-name]] -installpath "[[sonic-esb]]" -mgmtnode not_set

