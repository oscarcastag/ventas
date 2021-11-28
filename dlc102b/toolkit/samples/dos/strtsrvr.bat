echo off
rem strtsrvr.bat
rem sample batch file to start the multi-user server
rem Usage         strtsrvr  dbname
rem
set propath=\APPLrel
%PROSRV% %1  %2 %3 %4 %5 %6 %7 %8 %9
set propath=
