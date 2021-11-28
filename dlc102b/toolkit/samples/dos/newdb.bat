echo off
rem newdb.bat
rem sample batch file to copy the basic application database
rem
rem usage:        newdb dbname
rem
if %1x == x echo You must enter the name of the database to be created
if %1x == x goto done
prodb %1 APPLbasic
:done
