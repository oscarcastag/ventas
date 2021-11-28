echo off
rem multmenu.bat
rem sample batch file to enter a multi-user application's main menu
rem Usage         multmenu  dbname
rem
set propath=\APPLrel

if x%DLC%==x set DLC=%RDL%\dlc
if x%PROEXE%==x set PROEXE=%DLC%\bin\_progres.exe

%PROEXE% %1 -p APPLmenu %2 %3 %4 %5 %6 %7 %8 %9
set propath=
