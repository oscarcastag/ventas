#!/bin/sh

XQ_HOME=[[sonic-esb]]

# Setup up environment variables:
. "$XQ_HOME/bin/setenv.sh"

# The classes used by the directory service container
DS_LIB=$MGMT_LIB:$SONIC_LIB:$XQ_HOME/lib/xq_config.jar:[[install-dir]]/install/tlr;

# Boot xerces first so that it doesn't get picked up in jvm's lib/ext:
DS_JVM_ARGS="-Xbootclasspath/p:$MQ_LIB/xercesImpl.jar:$MQ_LIB/xmlParserAPIs.jar -Dverbose=true"

echo Configuring [[container-name]] container...
"$JAVA_HOME/bin/java" $DS_JVM_ARGS -classpath "$DS_LIB" DomainManager -url [[ds-url]] -domain [[ds-domain]] -user [[ds-user]] -password [[ds-password]]  -containers [[container-name]] -installpath "[[install-dir]]"

