echo off
rem runmenu.bat
rem sample batch file to enter a single-user application's main menu
rem Usage         runmenu  dbname
rem
set propath=\APPLrel
%PROEXE% %1 -p APPLmenu %2 %3 %4 %5 %6 %7 %8 %9
set propath=
