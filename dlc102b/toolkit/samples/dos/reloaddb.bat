echo off
rem reloaddb.bat
rem sample batch file to reload a database
rem Usage         reloaddb  dbname
rem
rem The user should have typed newdb first, to get a fresh basic database
rem
rem WARNING: The program fileload.p which is created by mkdump is not quite
rem suitable for this batch file.  That program is designed to be called from
rem an interactive menu.  If you wish to run it directly from this file,
rem you should insert the line:
rem               output to filename.
rem at the beginning of fileload.p and then compile it to create fileload.r
rem This file invokes progress with the -b option to make the job run
rem non-interactively without a terminal, so that Ctrl-C will kill it instead
rem of restarting the -p fileload.p program.
rem
set propath=\APPLrel
%PROEXE% %1 -p fileload.p -b %2 %3 %4 %5 %6 %7 %8 %9
set propath=

