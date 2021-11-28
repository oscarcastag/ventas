echo off
rem dumpdb.bat
rem sample batch file to dump a database
rem Usage         dumpdb  dbname
rem
rem WARNING: The program filedump.p which is created by mkdump is not quite
rem suitable for this batch file.  That program is designed to be called from
rem an interactive menu.  If you wish to run it directly from this file,
rem you should insert the line:
rem               output to filename .
rem at the beginning of filedump.p and then compile it to create filedump.r
rem This file invokes progress with the -b option to make the job run
rem non-interactively without a terminal, so that Ctrl-C will kill it instead
rem of restarting the -p filedump.p program.
rem
set propath=\APPLrel
%PROEXE% %1 -p filedump.p -b %2 %3 %4 %5 %6 %7 %8 %9
set propath=
