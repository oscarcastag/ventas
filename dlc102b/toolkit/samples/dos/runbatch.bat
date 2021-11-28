echo off
rem runbatch.bat
rem sample batch file to run a single-user batch job
rem Usage         runbatch  dbname  batchpgm
rem
set propath=\APPLrel
%PROEXE% %1 -b -p %2  %3 %4 %5 %6 %7 %8 %9
set propath=
