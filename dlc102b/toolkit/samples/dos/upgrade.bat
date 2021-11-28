echo off

rem This is a template for a dos-script which automatically upgrades
rem an installed PROGRESS application.
rem See the Toolkit manual for more details
rem
rem Step 1:  Unfreeze db-files, make new db-definitions and freeze files
rem
rem          Programs/files involved:
rem
rem          upgrade.p  : Progress start-up procedure.
rem          loginupg.p : Special version of login.p to provide userid and 
rem                       password for security-administrator.
rem                       (Security-administrator must have read/write access to
rem                        all files/fields in the database you want to access).
rem          unfreeze.p : Progress procedure unfreezing db-files.
rem          upgrade.df : ASCII-file with all db-changes (produced by
rem                       dictionary option Dump Incremental Data Definitions
rem          upgrade.inp: ASCII-file with the name of the  input .df-file
rem          upgrade.log: ASCII-file with all output from the upgrade-run
rem          freeze.p   : Progress procedure freezing db-files.
rem
rem      NOTE:  upgrade.p loginupg.p unfreeze.p freeze.p and compile.p
rem             must be encrypted before running upgrade on a runtime-system.

if x%DLC%==x set DLC=%RDL%\dlc
if x%PROEXE%==x set PROEXE=%DLC%\bin\_progres.exe

type Load new db-definitions
%PROEXE% -rx %1 -1  -p upgrade.p 
type Loading completed


rem Step 2:  Rebuild indexes (if you have dectivated)
rem
rem          Programs/files involved:
rem
rem          rebuild.inp: ASCII-file with input to idxbuild
rem          rebuild.log: ASCII-file with all output from the rebuild-run

_proutil %1 -C idxbuild < rebuild.inp > rebuild.log 
   
type Index-rebuild completed



rem Step 3:  Recompile Progress-procedures affected by the upgrade
rem
rem          Programs/files involved:
rem
rem          compile.p  : Progress-procedure with your compile-statements
rem          compile.inp: ASCII-file with all procedures to be recompiled
rem          compile.log: ASCII-file with all output from the compile-run
    
type Compile Progress-procedures

%PROEXE% -rx %1 -1 -p compile.p

type Compilation completed
