#!/bin/sh

#
#  Start the container
#

SONICMQ_HOME="/dlc/dlc102b/sonic/MQ7.5"
. "$SONICMQ_HOME/bin/setenv"

usage ()
{
    echo
    echo "Usage: startcontainer [-w workingDir] [-c containerFile] [-d dsFile] [-p password] [-s {true | false}]  [-a {true | false}]"
    echo
    echo "Options:"
    echo
    echo "-w workingDir     The container's default working directory will be that"
    echo "                  specified by the SONICMQ_HOME environment variable"
    echo "                  (initially set to the install directory). Use the -w"
    echo "                  argument to start a container with an alternate working"
    echo "                  directory."
    echo
    echo "-c containerFile  The containerFile is the path for the container xml"
    echo "                  file used to start the SonicMQ Container (default is"
    echo "                  container.xml in the working directory). The path will"
    echo "                  be relative to the container's working directory."
    echo
    echo "-d dsFile         The dsFile is the path for the directory service xml"
    echo "                  file used by the container to locate the local"
    echo "                  directory service (default is ds.xml). Do not use this"
    echo "                  argument when the container will access a remote"
    echo "                  directory service."
    echo
    echo "-p password       An encryption key is derived from this password and"
    echo "                  used to decrypt the container and directory service"
    echo "                  xml files. If a -p option is provided, then the xml"
    echo "                  files are assumed to be encrypted. If no password is"
    echo "                  provided, then the files are assumed to be in"
    echo "                  clear-text format."
    echo
    echo "-s {true | false} If a broker in this container is a member of a"
    echo "                  replicated pair, force it to take the active role upon"
    echo "                  startup."
    echo "                  Please use with extreme caution."
    echo
    echo "-a {true | false} If a Directory Service in this container is a member"
    echo "                  of a replicated pair, force it to take the active role upon"
    echo "                  startup."
    echo "                  Please use with extreme caution."
    echo
}

# initialize the values.
WORKINGDIR="$SONICMQ_HOME"
CONTAINERFILE=/dlc/dlc102b/sonic/ESB7.5/config/bootlu2app87Container.xml
DSFILE=
PASSWORDPROPERTY=
STARTACTIVEPROPERTY=
DS_STARTACTIVEPROPERTY=

# parse the parameters
while getopts c:d:p:w:s:a: option
do
    case $option in
    w)  WORKINGDIR=$OPTARG
        ;;

    c)  CONTAINERFILE=$OPTARG
        ;;

    d)  DSFILE=$OPTARG
        ;;

    p)  PASSWORDPROPERTY=-Dsonicsw.mf.password=$OPTARG
        ;;

    s) STARTACTIVEPROPERTY=-Dsonicsw.mq.startactive=$OPTARG
        ;;

    a) DS_STARTACTIVEPROPERTY=-Dsonicsw.mf.DS.startactive=$OPTARG
        ;;

    [?]) usage
        exit 1
        ;;
    esac
done
shift `expr $OPTIND - 1`
if [ "$1" ]
then
	echo "$0: Illegal argument $1"
	usage
	exit 1
fi

# Change directory to the working directory
cd "$WORKINGDIR"

# A classpath that includes MF launch classes (with manifest entries to JMS client classes) and SSL classes
LAUNCHER_CLASSPATH=$SONICMQ_LIB/MFlaunch.jar${ps}$SONICMQ_SSL_LIB

if [ -f "ds.xml" ]
then
    if [ -z "$DSFILE" ]
    then
        DSFILE="ds.xml"
    fi
fi

PATH=.${ps}$PATH

# Start the container
EXITCODE=14
while [ $EXITCODE -eq 14 ]
do
    "$SONICMQ_JRE" "$SONIC_BOOT_CLASSPATH" -cp "$LAUNCHER_CLASSPATH" -Dsonicsw.mf.generate.sh=true -Dsonicsw.home="$SONIC_HOME" "$SONICMQ_SSL_CLIENT" $PASSWORDPROPERTY $DS_STARTACTIVEPROPERTY $STARTACTIVEPROPERTY -Dsonicsw.mf.allowRestart=true com.sonicsw.mf.framework.agent.ci.LaunchContainer $CONTAINERFILE $DSFILE
    if [ ! -f ${CONTAINERFILE}.sh ]
    then
        break
    fi
    . ${CONTAINERFILE}.sh
    EXITCODE=$?
done
