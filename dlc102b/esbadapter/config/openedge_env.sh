#
# Sets up common environment variables for the OpenEdge ESB Adapter
#

# OpenEdge SSL Support
# These properties allow an OpenEdge Adapter to use SSL when connecting
# to an OpenEdge Server.

# Location of the OpenEdge certificate store. If not set, defaults to 
# [[install-dir]]\certs. If you are running the ESB Adapter remotely
# from your OpenEdge installation, copy the [[install-dir]]\certs directory
# to the machine where the Sonic container is running and set the
# environment variable below.
# Uncomment and specify the directory this to change the default.
# SET OE_SSL_CERTIFICATE_STORE= -DPROGRESS.Session.certificateStore=certs

# Sets any ESB Adapter system properties
JVM_ARGS_EXT="$JVM_ARGS_EXT -Dcom.progress.openedge.home=[[install-dir]] $OE_SSL_CERTIFICATE_STORE";export JVM_ARGS_EXT
DLC="[[install-dir]]";export DLC

# Adds the ESB Adpater libraries to our classpath
SMQ_CLASSPATH_EXT="$SMQ_CLASSPATH_EXT:[[install-dir]]/esbadapter/lib/esbadptr.jar:[[install-dir]]/esbadapter/lib/wsdl4j.jar:[[install-dir]]/esbadapter/lib/activation.jar:[[install-dir]]/esbadapter/lib/regexp.jar:[[install-dir]]/esbadapter/lib/servlet.jar";export SMQ_CLASSPATH_EXT
SMC_CLASSPATH_EXT="$SMC_CLASSPATH_EXT:[[install-dir]]/esbadapter/lib/esbadptr.jar:[[install-dir]]/esbadapter/lib/wsdl4j.jar";export SMC_CLASSPATH_EXT
