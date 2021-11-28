#!/bin/sh
MACHINE="linuxx86_64"
export MACHINE
if [ x$RDL = x -a -f `pwd`/buildenv.log ] ; then
    rm -f `pwd`/buildenv.log
fi
if [ x$RDL = x ]; then
(
  echo "Build Environment: `date`"
  echo "------------------------------------------------------------"
  echo "                                                            "
  echo "User:                           `id`"
  echo "Working Directory:              `pwd`"
  echo "Machine OS:                     `uname -s`"
  echo "Machine OS Version:             `uname -r`"
  echo "Machine Type:                   `uname -m`"
  echo "DLC Setting:                    $DLC"
  echo "                                                            "
  echo "User Defined ORALIB: $UDORA"
  echo "                                                            "
  echo "ORALIB Setting:                                             "
  echo "------------------------------------------------------------"
  echo "$ORALIB"
  echo "                                                            "
  echo "ORACLE_HOME Setting:                                        "
  echo "------------------------------------------------------------"
  echo "$ORACLE_HOME"
  echo "                                                            "
  echo "LD_LIBRARY_PATH Setting:                                    "
  echo "------------------------------------------------------------"
  echo "$LD_LIBRARY_PATH"
  echo "                                                            "
  echo "LD_RUN_PATH Setting:                                        "
  echo "------------------------------------------------------------"
  echo "$LD_RUN_PATH"
  echo "                                                            "
  echo "PATH Setting:                                               "
  echo "------------------------------------------------------------"
  echo "$PATH"
  echo "                                                            "
  echo "PROPATH Setting:                                            "
  echo "------------------------------------------------------------"
  echo "$PROPATH"
) > `pwd`/buildenv.log
fi

