
Building OpenEdge Oracle 4GL Clients and Servers on UNIX
-----------------------------------------------------------

NOTE:  Scripts to build oracle client and dataserver are only
       available on IBM AIX, HP-UX (32 bit), and SCO UnixWare
       installations.

1. Open a terminal and invoke a Bourne shell (/bin/sh)
   on the system where OpenEdge and the supported compiler
   and operating system is installed

2. Change to user 'root'

3. Set and export the variable DLC to the OpenEdge installation
   directory
       Example:
       > DLC=/usr/OpenEdge/dlc
       > export DLC

4. [Optional] Set and export the variable IMAGE to the full
   pathname of the executable to be generated.  By default
   the new executable will be built in $DLC/oebuild/.
       Example:
       > IMAGE=/tmp/orarx
       > export IMAGE

5. Make sure that the variable PATH contains the directory
   to the supported compiler/linker

6. Unset the library path variable for your operating system.
       Example:
       > unset LIBPATH (IBM AIX)
       OR
       > unset SHLIB_PATH (HP-UX)
       OR
       > unset LD_LIBRARY_PATH (SCO Unixware)

7. Set the variable ORACLE_HOME to the top level installation
   directory of Oracle.
       Example:
       > ORACLE_HOME=/usr/oracle/8.1.7
       > export ORACLE_HOME

8. Run the script:
   $DLC/oebuild/make/build_orarx.sh (The Oracle 4GL client)
   - installed executable name : $DLC/bin/orarx
   $DLC/oebuild/make/build_orasrv.sh (The Oracle dataserver)
   - installed executable name : $DLC/bin/_orasrv
   $DLC/oebuild/make/build__oraapsv.sh (The Oracle appserver)
   - installed executable name : $DLC/bin/_oraapsv
       Example:
       > $DLC/oebuild/make/build_orarx.sh

9. Backup the original executable
       Example:
       > cp $DLC/bin/orarx $DLC/bin/orarx.orig

10. Copy the newly built executable.
       Example:
       > rm -f $DLC/bin/orarx
       > cp -f $DLC/oebuild/ora8rx $DLC/bin/orarx

11. Change permissions to add SUID bit.
       Example:
       > chmod u+s $DLC/bin/orarx

Building the standard OpenEdge 4GL client or AppServer with customized objects
-----------------------------------------------------------------
l. Follow steps 1-6 of "Building OpenEdge Oracle 4GL Client and dataservers
   on UNIX"

2. Backup the original link options script and 4GL tie-in object.
       Example:
       > cp $DLC/oebuild/make/build_rx.sh $DLC/oebuild/make/build_rx.sh.orig
       > cp $DLC/oebuild/obj/hlprodsp.o $DLC/oebuild/obj/hlprodsp.o.orig

3. Edit $DLC/oebuild/hlc/hlprodsp.c to tie in C functions to the 4GL
   as explained in the comments of the C file.

4. Compile the new file.
       Example:
       > cc -c -o $DLC/oebuild/hlc/hlprodsp.o $DLC/oebuild/hlc/hlprodsp.c

5. Set and export the environment variable HLC_OBJS to contain all of the
   objects that need to be included in the new executable, including the the
   object built in step 4.
       Example:
       > HLC_OBJS="/home/foo.o /home/foo1.o $DLC/oebuild/hlc/hlprodsp.o"
       > export HLC_OBJS

NOTE: If the script that executes the link is edited as opposed to using
      the HLC_OBJ environment variable, the changes may be overwritten in
      a service pack or hotfix that is applied to the installation area

6. Run the script:
   $DLC/oebuild/make/build_rx.sh (The standard 4GL client)
   - installed executable name : $DLC/bin/_progres
       Example:
       > $DLC/oebuild/make/build_rx.sh

7. Follow steps 9-11

Building and Running the 'hlc' Examples
-----------------------------------------------------------------
l. Follow steps 1-6 of "Building OpenEdge Oracle 4GL Client and dataservers
   on UNIX"

2. Copy the entire $DLC/oebuild/hlc/examples directory to a non-installation
   user directory.
       Example:
       > cp $DLC/oebuild/hlc/examples /home/examples

3. Change to non-installation directory when hlc examples were copied.
       Example:
       > cd /home/examples/

4. Run the test script "testhlc".
       Example:
       > ./testhlc

