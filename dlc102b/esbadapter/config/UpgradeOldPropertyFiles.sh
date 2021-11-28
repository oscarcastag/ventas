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
DS_JVM_ARGS="-Xbootclasspath/p:[[install-dir]]/esbadapter/lib/xercesImpl.jar:[[install-dir]]/esbadapter/lib/xmlParserAPIs.jar -Dverbose=true"

echo Importing files...

# Add XQ containers to MF containers
"$JAVA_HOME/bin/java" $DS_JVM_ARGS -classpath "$DS_LIB" com.sonicsw.xqimpl.tools.install.config.SonicFSImport -url [[ds-url]] -domain [[ds-domain]] -user [[ds-user]] -password [[ds-password]] -sourceDir [[sonic-esb]]/explorer/ext/servicetypes -targetDir /System/SonicESB/[[sonic-version]]/properties/serviceTypes -exclusionRegExps "AuditServiceType\..*;BPEType\..*;CBRType\..*;DatabaseServiceType\..*;OrchestrationServiceType\..*;OSCheckAvailabilityType\..*;ProcessSearchServiceType\..*;WorklistServiceType\..*;WSInvocationComponentType\..*;XFORMType\..*;XMLServiceType\..*" -inclusionRegExps .*\.properties