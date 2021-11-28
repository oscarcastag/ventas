#!/bin/sh
#
# This script is used to initialize the SonicMQ environment
# for use with SonicMQ extensions
#
XQ_HOME=/dlc/dlc102b/sonic/ESB7.5
if [ -f "$XQ_HOME/bin/setenv.sh" ]
then
    . "$XQ_HOME/bin/setenv.sh"
fi
