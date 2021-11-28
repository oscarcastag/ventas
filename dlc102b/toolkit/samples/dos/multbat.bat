echo off
rem multbat.bat
rem sample batch file to run a multi-user batch job
rem Usage         multbat  dbname  batchpgm
rem
set propath=\APPLrel

if x%DLC%==x set DLC=%RDL%\dlc
if x%PROEXE%==x set PROEXE=%DLC%\bin\_progres.exe

%PROEXE% %1 -b -p %2  %3 %4 %5 %6 %7 %8 %9
set propath=
