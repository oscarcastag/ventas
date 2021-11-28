     README
     DataDirect Technologies
     DataDirect Connect64 for ODBC
     DataDirect Connect64 XE (Extended Edition) for ODBC
     Windows Platforms
     Release 5.3 Service Pack 2
     June 2008


***********************************************************************
Copyright (c) 2007 DataDirect Technologies Corp. All rights reserved. 
 
DataDirect Connect is a registered trademark of DataDirect Technologies 
Corp. in the U.S. and other countries. Any other trademarks or service 
marks contained herein are the property of their respective owners.
***********************************************************************

This README file contains information not included in the DATADIRECT 
CONNECT64 AND CONNECT64 XE FOR ODBC USER'S GUIDE.

IMPORTANT: You must have version 2.8 (64-bit) or higher of the Microsoft 
Data Access Components (MDAC) installed to use this product. Depending on 
the version of your Windows operating system, these components may already 
be installed. You can download a utility that determines whether MDAC is 
installed and its version from the following Microsoft site:

http://msdn2.microsoft.com/en-us/data/aa937730.aspx

You can also download MDAC from the same site or install it from the 
DataDirect CD. To install from the CD, navigate from the root directory 
to \mdac64 and run MDAC_TYP.EXE.


CONTENTS

Changes for Service Pack 2 since Release 5.3 SP1
Changes for Service Pack 1 since Release 5.3
Release 5.3 Features
Available ODBC Drivers
Disk Space Requirements
Driver WorkAround Options
Notes, Known Problems, and Restrictions
Using the Online Documents
Installed Files
Third-Party Vendor License Agreement


     Changes for Service Pack 2 since Release 5.3 SP1

See fixes.txt for a detailed list of issues addressed since
Release 5.3 SP1.

New Database Version Support
----------------------------
* DB2 V9.5 for Linux/UNIX/Windows

New Operating System Support
----------------------------
* Windows Vista SP1
* Windows Server 2008
 
DB2 Wire Protocol Driver Enhancements
-------------------------------------
* SSL support for DB2 V9.5 Linux/UNIX/Windows and z/OS


     Changes for Service Pack 1 since Release 5.3

See fixes.txt for a detailed list of issues addressed since 
Release 5.3.

New Driver
----------
* MySQL Wire Protocol driver for the MySQL 5.0.x database.


New Database Version Support
----------------------------
* DB2 V9.1 for z/OS.
* DB2 V9.1 for Linux/UNIX/Windows Fixpack 2.
* Informix 11
* Oracle 11g


DB2 Wire Protocol Driver Enhancements
-------------------------------------
* DB2 V9.1 for z/OS new data type support
* DB2 V9.1 for z/OS native SQL procedure support


Oracle Wire Protocol Driver Enhancements
----------------------------------------
* Oracle 11g server result set cache support
* Oracle 11g XQuery support


     Release 5.3 Features


New Database Version Support
----------------------------
* DB2 V9.1 for Linux, UNIX, Windows
* DB2 UDB V5R4 for iSeries
* Sybase 12.5.4
* Teradata V2R6.2
	

New Operating System Support
----------------------------
* Windows Vista, all editions


DB2 Wire Protocol Driver Enhancements
-------------------------------------
* Support for SSL data encryption on iSeries
* Support for XML data type and XQuery statements
* Support for DB2 data encryption on Linux, UNIX, Windows and z/OS


Oracle Wire Protocol Driver Enhancements
--------------------------------------------
* Support for SSL data encryption
* Kerberos authentication


Sybase Wire Protocol Driver Enhancements
----------------------------------------
* Support for SSL data encryption


New Features
------------
* Support for IPv6


Enhancement Requests
--------------------
5.3 enhancements include the following requests:

DEF0000251     DEF0002638
DEF0002486     DEF0002907
DEF0002425     DEF0003045
DEF0002790     DEF0002818


     Available ODBC Drivers

See the DATADIRECT CONNECT64 AND CONNECT64 XE FOR ODBC INSTALLATION 
GUIDE for a complete list of supported databases and client 
requirements.

DataDirect Connect64 for ODBC Drivers
-------------------------------------
DB2 Wire Protocol (DDDB223.DLL)

Informix Wire Protocol (DDIFCL23.DLL)

MySQL Wire Protocol (DDMYSQL23.DLL) 

Oracle Wire Protocol (DDORA23.DLL)

SQL Server Wire Protocol (DDMSSS23.DLL) 

Sybase Wire Protocol (DDASE23.DLL)

Oracle (DDOR823.DLL)

DataDirect Connect64 XE for ODBC Driver
---------------------------------------
Teradata (DDTERA23.DLL) [not available on Windows for x64]


     Disk Space Requirements

The following disk space requirements assume a full installation of
all drivers and options.

DataDirect Connect64 for ODBC Drivers for x64
---------------------------------------------
37 MB of available hard disk space. 

DataDirect Connect64 for ODBC Drivers for Itanium
-------------------------------------------------
46 MB of available hard disk space. 

DataDirect Connect64 XE for ODBC Driver
---------------------------------------
31 MB of available hard disk space.


     Driver WorkAround Options

DataDirect has included non-standard options for the drivers that 
enable you to take full advantage of packaged ODBC-enabled 
applications requiring non-standard or extended behavior.

NOTE: These options are not available for use with the SQL Server 
Wire Protocol driver.

To use these options, we recommend that you create a separate data 
source for each application. Using the registry editor (REGEDIT), 
open the ODBC.INI section in the registry. In the section for the 
data source you created, add the string WorkArounds= (or WorkArounds2=) 
with a value of n (WorkArounds=n or WorkArounds2=n). The value n is the 
cumulative value of all options added together.

Note that each of these options has potential side effects related 
to its use. An option should only be used to address the specific 
problem for which it was designed. For example, WorkArounds=2 causes 
the driver to report that database qualifiers are not supported, 
even when they are. As a result, applications that use qualifiers 
may not perform correctly when this option is enabled.

WorkArounds=1. If an ODBC driver reports that its 
SQL_CURSOR_COMMIT_BEHAVIOR or SQL_CURSOR_ROLLBACK_BEHAVIOR is 0, 1 is 
returned instead and statements are prepared again by the driver.

WorkArounds=2. Some applications cannot handle database qualifiers. If 
this option is on, the driver reports that qualifiers are not 
supported.

WorkArounds=8. If an ODBC driver cannot determine the number of rows 
affected by an INSERT, UPDATE, or DELETE, it may return -1 in 
SQLRowCount. This may cause an error in some products. Turning this 
option on causes the driver to return 1 instead.

WorkArounds=16. For SQLStatistics, if an ODBC driver reports an 
INDEX_QUALIFIER that contains a period, some applications raise a 
"tablename is not a valid name" error. Turning this option on causes 
the driver to return no INDEX_QUALIFIER.

WorkArounds=32. Turning this option on forces the driver to re-bind
columns after calling SQLExecute for prepared statements.

WorkArounds=64. This option results in a column name of C<position> 
where <position> is the ordinal position in the result set. For 
example, "SELECT col1, col2+col3 FROM table1" produces the column names 
"col1" and C2. SQLColAttributes/SQL_COLUMN_NAME returns an empty string 
for result columns that are expressions. Use this option for 
applications that cannot handle empty string column names. 

WorkArounds=256. Forces SQLGetInfo/SQL_ACTIVE_CONNECTIONS to be 
returned as 1.

WorkArounds=512. To prevent ROWID results, this option forces the 
SQLSpecialColumns function to return a unique index as returned from 
SQLStatistics.

WorkArounds=2048. Microsoft Access performs more efficiently when the 
output connection string of SQLDriverConnect returns DATABASE= instead 
of DB= for some data sources. This option forces DATABASE= to be 
returned.

WorkArounds=65536. This option strips trailing zeros from decimal 
results, which prevents Microsoft Access from issuing an error when 
decimal columns containing trailing zeros are included in the unique 
index.

WorkArounds=131072. This option turns all occurrences of the double 
quote character ("") into the accent grave character (`). Some 
applications always quote identifiers with double quotes. Double 
quoting causes problems for data sources that do not return 
SQLGetInfo/SQL_IDENTIFIER_QUOTE_CHAR = <double quote>.

WorkArounds=524288. The Microsoft Foundation Classes (MFC) bind all 
SQL_DECIMAL parameters with a fixed precision and scale, which causes 
truncation errors. Set this option to force the maximum 
precision/scale settings.

WorkArounds=1048576. Some applications incorrectly specify a precision 
of 0 for character types when the value will be SQL_NULL_DATA. This 
option overrides the specified precision and sets the precision to 256.

WorkArounds=2097152. Some applications incorrectly specify a precision 
of -1 for character types. This option overrides the specified 
precision and sets the precision to 2000.

WorkArounds=4194304. For PowerBuilder users, this option converts all 
catalog function arguments to uppercase unless they are quoted.

WorkArounds=536870912. This option allows for re-binding parameters 
after calling SQLExecute for prepared statements.

WorkArounds=1073741824. If your application assumes that ORDER BY 
columns do not have to be in the SELECT list, this assumption may be 
incorrect for data sources such as Informix. This workaround addresses 
that assumption.

WorkArounds2=2. Some applications incorrectly specify the 
ColumnSize/DecimalDigits when binding timestamp parameters. This 
workaround causes the driver to ignore the ColumnSize/DecimalDigits 
specified by the application and use the database defaults instead.

WorkArounds2=4. Microsoft Access uses the last native type 
mapping, as returned by SQLGetTypeInfo, for a given SQL type. This 
workaround reverses the order in which types are returned, so that 
Access will use the most appropriate native type.

WorkArounds2=8. This workaround causes the driver to add the bindoffset 
in the ARD to the pointers returned by SQLParamData. This is to 
work around a MSDASQL problem.

WorkArounds2=16. This workaround causes the drivers to ignore calls 
to SQLFreeStmt(RESET_PARAMS) and only return success without taking 
other action. It also causes parameter validation not to use the bind 
offset when validating the charoctetlength buffer. This is to work 
around a MSDASQL problem.

WorkArounds2=32. Microsoft Access requires "DSN" to be included in a 
connection string. This workaround appends "DSN=" to a connection 
string, if it is not already included.

WorkArounds2=128. Some applications will open extra connections if 
SQLGetInfo(SQL_ACTIVE_STATEMENTS) does not return 0. This workaround 
causes SQLGetInfo(SQL_ACTIVE_STATEMENTS) to return 0 to avoid the 
overhead of these extra connections.

WorkArounds2=256. Workaround for MSDASQL. Causes the drivers to return 
Buffer Size for Long Data on calls to SQLGetData with a buffer size of 
0 on columns whose SQL type is SQL_LONGVARCHAR or SQL_LONGVARBINARY. 
Applications should always set this workaround when using MSDASQL and 
retrieving long data.

WorkArounds2=1024. Workaround for ADO. ADO incorrectly interprets the 
SQLGetInfo(SQL_MULT_RESULT_SETS) to mean that the last result set 
returned from a stored procedure is the output parameters for the 
stored procedure. Setting this workaround causes the driver to return 
"N" for this SQLGetInfo call.

WorkArounds2=2048. Workaround for the ODBC cursor library. ODBC 3.x 
applications that use the ODBC cursor library receive errors on 
bindings for SQL_DATE, SQL_TIME, and SQL_TIMESTAMP columns. The cursor 
library incorrectly rebinds these columns with the ODBC 2.x type 
defines. Setting this workaround causes the drivers to accept these 
2.x SQL types as valid.

WorkArounds2=4096. The ODBC Driver Manager incorrectly translates 
lengths of empty strings when a Unicode-enabled application uses a 
non-Unicode driver. This workaround causes the DataDirect Connect64 for 
ODBC drivers to internally adjust the length of empty strings. Use this 
workaround only if your application is Unicode enabled.

WorkArounds2=8192. Workaround for Microsoft Access 2000 when it calls 
SQLStatisticsW and SQLGetData for column number 10. Microsoft Access 
only asks for the data as a two-byte SQL_C_WCHAR, which is insufficient 
buffer to store the UCS2 character and the null terminator. Thus, 
the driver returns a warning, "01004 Data truncated", and returns a 
null character to Microsoft Access. Microsoft Access then passes 
error -7748. Setting this workaround causes Microsoft Access to not 
pass the error -7748.


     Notes, Known Problems, and Restrictions

The following are notes, known problems, or restrictions with 
DataDirect Connect64 and Connect64 XE for ODBC Release 5.3 Service 
Pack 1 on Windows.

Upgrading from an Evaluation to a Licensed Installation
-------------------------------------------------------
If you have installed an evaluation copy of the drivers and want to 
upgrade to a licensed version, you must use the Modify option of the 
installation program. See the DATADIRECT CONNECT AND CONNECT XE FOR 
ODBC INSTALLATION GUIDE for details about using the Modify option.

For Itanium Users
-----------------
The 64-bit Windows ODBC Driver Manager on the Itanium platform has an 
inconsistency with other 64-bit platforms regarding the 
SQL_DIAG_ROW_NUMBER field of the diagnostics record.  On other 64-bit 
platforms, the Driver Manager treats SQL_DIAG_ROW_NUMBER as a 64-bit(8-
byte) field; on Windows Itanium, it is treated as a 32-bit(4-byte) 
field.  The result of this inconsistency is that the 
SQL_DIAG_ROW_NUMBER field of any error records generated by the Driver 
Manager appears corrupt to 64-bit applications.

Installing and Removing Default Data Sources
--------------------------------------------
When you first install a driver, you are given the option to install a 
default data source for that driver. If you do not install the default 
data source at this time, and run the installer again later using the 
"modify" option, you will not be able to install a default data source 
for this driver even though this choice is available on the modify 
window . To install a default data source for a driver after the 
initial installation, you must uninstall the driver and then reinstall 
it.

If you uninstall a 5.2 product after you have installed a 5.3 product, 
default data sources that were created by the installer and share the 
same name for both product versions will be removed from your machine.

Test Connect Button
-------------------
When the Setup dialog box for any of the drivers is open, a Test 
Connect button is available. Clicking this button opens a Logon dialog 
box, which contains a Help button. For the Wire Protocol drivers only, 
clicking this Help button causes an error and opens a blank browser 
window. The Help button does not exhibit this behavior when the Logon 
dialog box is opened by a method other than through the Test Connect 
button.

Translate Button
----------------
All of the Setup dialog boxes have a "Translate" button on the Advanced 
tab. Clicking this button displays a list of translators from which to 
choose. If you choose the "<no translator>" option and then 
click OK, the ODBC Administrator returns an "unhandled win32 exception" 
and closes. This appears to be a problem within the ODBC Administrator.

For SSL Users
-------------
When trying to connect to a database using SSL encryption, you may 
receive an error message similar to: "PRNG not seeded". This is because 
certain versions of some operating systems do not generate truly random 
numbers necessary for encryption. For more information about this error 
and available patches, please visit the Web site:

http://www.openssl.org/support/faq.html#USER1

SQLColAttribute(s)
------------------
The column attributes 1001 and 1002, which were assigned as DataDirect-
specific attributes, were inadvertently used as system attributes by 
the Microsoft 3.0 ODBC implementation. Applications using those 
attributes should now use 1901 and 1902, respectively.

SQL_C_NUMERIC
-------------
Because of inconsistencies in the ODBC specification, users attempting 
to use SQL_C_NUMERIC parameters should set the precision and scale 
values of the corresponding structure and the descriptor fields in the 
APD.

For Informix Users
------------------
Restriction: Some Informix error messages may contain more than one 
error. All errors displayed may not be valid.

For 64-Bit Oracle Client Interface (OCI) Users
----------------------------------------------
During tests of the DataDirect Connect64 for ODBC Oracle driver, the 
OCI in some cases returned incorrect data for several columns in a 
particular row, while in other cases, it returned the row correctly. 
DataDirect has determined that the OCI default of pre-fetching a row 
is the source of the problem.

Consequences of the problem can be as severe as a core dump. Disabling 
pre-fetching is the recommended workaround. A connection string 
attribute is available that does not appear in the driver configuration 
dialog boxes or the documentation: EnablePreFetch (EPF). The default 
for this attribute is 1 (enable pre-fetching). Setting this option to 0 
in a connection string or a data source 
(HKEY_CURRENT_USER\Software\ODBC\.odbc.ini in the Windows Registry) 
causes the driver to disable pre-fetching in the OCI.

If you have issues using DTC with the Oracle driver, use the Oracle 
Wire Protocol driver as an alternative.

For Oracle8 Server Users
------------------------
The DataDirect Connect64 for ODBC Oracle driver uses the XA protocol 
support in Oracle8 to accomplish distributed transaction support. For 
recovery to work correctly, you must grant appropriate privileges on 
any server that will participate in a DTC transaction. You must grant 
the SELECT privilege on SYS.DBA_PENDING_TRANSACTIONS to all users that 
will use MTS. Refer to the Oracle8 documentation for details on using 
Oracle XA.

For Microsoft SQL Server Users
------------------------------
The SQL Server Wire Protocol driver supports SQL Server 7.0, 2000, 
and 2005.

The SQL Server Wire Protocol driver does not support multiple active 
statements on a single connection by default. See the Microsoft 
Knowledgebase document explaining how to enable multiple active statements 
on a single connection with SQL Server using server-side cursors at the 
following URL:

http://support.microsoft.com/support/kb/articles/q140/8/96.asp

The SQL Server Wire Protocol driver returns stored procedure names with 
the version number appended to them. For example, a procedure defined 
as "proc1" will be returned as "proc1;1".

The WorkArounds listed in the "Driver Options" section of this README
cannot be used with the SQL Server Wire Protocol driver.

For Sybase Users
----------------
You may experience a problem using catalog stored procedures when 
running the driver with Sybase Adaptive Server 11.5. Contact Sybase 
and ask for the latest version of their catalog stored procedures.

On the Logon dialog box, there is a Database drop-down list that 
displays the database names specified on the Connection tab of the ODBC 
Sybase Wire Protocol Driver Setup dialog box. This functionality is 
available in all cases except when connecting through the Test Connect 
button on the Setup dialog box. When connecting through the Test 
Connect button, only the default database specified on the General tab 
of the Setup dialog box is available.


     Using the Online Documents

The DataDirect Connect for ODBC books are provided in PDF and HTML 
versions. The PDF versions are provided on the product CD and also on 
the DataDirect Technologies Web site:

http://www.datadirect.com/techres/odbcproddoc/index.ssp

You can view the PDF versions using Adobe Reader.

NOTE: To download Adobe Reader, visit the Adobe Web site at 
http://www.adobe.com.

The HTML versions of the books are installed in the help subdirectory 
of your product installation directory.


     Installed Files 

The file list below assumes a full installation of all drivers and 
documentation.

Running Setup copies the following files to the system directory, by 
default, C:\WINDOWS\SYSTEM32:

MFC42.DLL         Visual C Runtime Library
MSVCRT.DLL        Visual C 6.x Runtime Library

Setup copies the following files and subdirectories to the product 
installation directory, by default, C:\PROGRAM FILES\DATADIRECT
\ODBC64v53:

ICULICENSE.TXT     License agreement for ICU
MYSQLLICENSE.TXT   License agreement for MySQL
ODBC64FIXES.TXT    A text file that lists the fixes in the release
ODBC64README.TXT   This file

\BIND:

DDODBC_LUW.lst     DB2 list files for Linux/UNIX/Windows
DDODBC_400.lst     DB2 list files for iSeries
DDODBC_MVS.lst     DB2 list files for z/OS
DDOC510A.bnd
DDOS510A.bnd
DDOR510A.bnd
DDOU510A.bnd
DDON510A.bnd
DDOC510B.bnd
DDOS510B.bnd
DDOR510B.bnd
DDOU510B.bnd
DDON510B.bnd
DDOC510C.bnd
DDOS510C.bnd
DDOR510C.bnd
DDOU510C.bnd
DDON510C.bnd

\DRIVERS:

For the following files, resource files for each driver end in R.DLL; 
setup files for relevant drivers end in S.DLL.

DDEXTWIN.EXE
DDASE23.DLL       Sybase Wire Protocol driver
DDASE23R.DLL
DDCRYPTO23.DLL    SSL support file
DDDB232.DLL       DB2 Wire Protocol driver
DDDB223R.DLL
DDICU23.DLL       Unicode conversion tables
DDIFCL23.DLL      Informix Wire Protocol driver
DDIFCL23R.DLL
DDMSSS23.DLL      SQL Server Wire Protocol driver
DDMSSS23R.DLL
DDMYSQL23.DLL     MySQL Wire Protocol driver     
DDODBC.LIC        DataDirect license file
DDOR823.DLL       Oracle driver
DDOR823R.DLL
DDOR823S.DLL
DDOR8DTC23.DLL
DDORA23.DLL       Oracle Wire Protocol driver
DDORA23R.DLL
DDSSL23.DLL       SSL support file
DDTERA23.DLL      Driver for the Teradata database [only on Itanium II]
DDTERA23R.DLL
DDTERA23S.DLL
DDTRN23.DLL       DataDirect sample translation DLL
LICENSE.INI       License information file
QESQLEXT.H        Header file for DataDirect-specific ODBC
                  definitions

\EXAMPLE: 

EXAMPLE.C         Source file for example program
EXAMPLE.EXE       Executable file for example program
EXAMPLE.H         Header file for example program
EXAMPLE.MAK       Make file for example program
EXAMPLE64.TXT     Short description of the program

\HELP: 

HELP.HTM          HTML help system entry file
\*.*              Support folders for the HTML help system 

\TRANSLAT:

LIBMAIN.C
README.TRN        Translation Library information file
TRANSLAT.C        Sample Translation Library source file
WINNT.MAK         Makefile for the Sample Translation Library

\TOOLS:

DDPROCINFO.EXE         Processor Information utility

\WIZARDS:

INDEX.HTML
ODBCPERF.JAR
\LOGO\*.*


     Third-Party Vendor License Agreements 

This DataDirect product includes ICU Version 3.2 which is subject to 
the following license agreement:

ICU License - ICU 1.8.1 and later ICU License - ICU 1.8.1 and later
COPYRIGHT AND PERMISSION NOTICE

Copyright (c) 1995-2003 International Business Machines Corporation and 
others
All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, and/or sell copies of the Software, and to permit persons
to whom the Software is furnished to do so, provided that the above
copyright notice(s) and this permission notice appear in all copies of
the Software and that both the above copyright notice(s) and this
permission notice appear in supporting documentation.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT
OF THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
HOLDERS INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL
INDIRECT OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING
FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION
WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Except as contained in this notice, the name of a copyright holder
shall not be used in advertising or otherwise to promote the sale, use
or other dealings in this Software without prior written authorization
of the copyright holder.
-----------------------------------------------------------------------

This DataDirect product includes the OpenSSL Library which is subject 
to the following license agreements:

OpenSSL License

Copyright (c) 1998-2006 The OpenSSL Project. All rights reserved.

Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions are 
met:

1. Redistributions of source code must retain the above copyright 
notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright 
notice, this list of conditions and the following disclaimer in the 
documentation and/or other materials provided with the distribution.
 
3. All advertising materials mentioning features or use of this 
software must display the following acknowledgment:

"This product includes software developed by the OpenSSL Project for 
use in the OpenSSL Toolkit. (http://www.openssl.org/)"

4. The names "OpenSSL Toolkit" and "OpenSSL Project" must not be used 
to endorse or promote products derived from this software without prior 
written permission. For written permission, please contact openssl-
core@openssl.org.
 
 5. Products derived from this software may not be called "OpenSSL" nor 
may "OpenSSL" appear in their names without prior written permission of 
the OpenSSL Project.

6. Redistributions of any form whatsoever must retain the following 
acknowledgment:

"This product includes software developed by the OpenSSL Project for 
use in the OpenSSL Toolkit (http://www.openssl.org/)"

THIS SOFTWARE IS PROVIDED BY THE OpenSSL PROJECT ``AS IS'' AND ANY 
EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE OpenSSL PROJECT OR ITS 
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
----------------------------------------------------------------------- 

This DataDirect product includes cryptographic software written by Eric 
Young (eay@cryptsoft.com). This product includes software written by 
Tim Hudson (tjh@cryptsoft.com).

Original SSLeay License
-----------------------
Copyright (C) 1995-1998 Eric Young (eay@cryptsoft.com) All rights 
reserved.
 
This package is an SSL implementation written by Eric Young 
eay@cryptsoft.com). The implementation was written so as to conform 
with Netscapes SSL.

This library is free for commercial and non-commercial use as long as 
the following conditions are aheared to. The following conditions apply 
to all code found in this distribution, be it the RC4, RSA, lhash, DES, 
etc., code; not just the SSL code. The SSL documentation included with 
this distribution is covered by the same copyright terms except that 
the holder is Tim Hudson (tjh@cryptsoft.com).

Copyright remains Eric Young's, and as such any Copyright notices in 
the code are not to be removed. If this package is used in a product, 
Eric Young should be given attribution as the author of the parts of 
the library used. This can be in the form of a textual message at 
program startup or in documentation (online or textual) provided with 
the package.

Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions are 
met:

1. Redistributions of source code must retain the copyright notice, 
this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright 
notice, this list of conditions and the following disclaimer in the 
documentation and/or other materials provided with the distribution.

3. All advertising materials mentioning features or use of this 
software must display the following acknowledgement:

"This product includes cryptographic software written by Eric Young 
(eay@cryptsoft.com)"

The word 'cryptographic' can be left out if the routines from the 
library being used are not cryptographic related :-).

4. If you include any Windows specific code (or a derivative thereof) 
from the apps directory (application code) you must include an 
acknowledgement:

"This product includes software written by Tim Hudson 
(tjh@cryptsoft.com)"

THIS SOFTWARE IS PROVIDED BY ERIC YOUNG ``AS IS'' AND ANY EXPRESS OR 
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR 
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS 
OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING 
IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
POSSIBILITY OF SUCH DAMAGE.

The licence and distribution terms for any publically available version 
or derivative of this code cannot be changed. i.e. this code cannot 
simply be copied and put under another distribution licence [including 
the GNU Public Licence.]
-----------------------------------------------------------------------

If DataDirect Connect for ODBC is licensed for the Microsoft SQL Server 
database the following shall apply:  DataDirect Connect for ODBC 
contains a licensed implementation of the Microsoft TDS Protocol. You 
may only use DataDirect Connect for ODBC to communicate data to and 
from Microsoft SQL Servers.  You must separately obtain a license from 
Microsoft or its channel partners for any Microsoft software products 
used by you.
-----------------------------------------------------------------------

The DataDirect Connect64 for ODBC driver for MySQL Enterprise was 
developed using the MySQL Protocol Documentation whose copyright is 
owned by, and licensed by DataDirect from, MySQL AB. If DataDirect 
Connect64 for ODBC is licensed for the MySQL database the following shall 
apply: You must purchase commercially licensed MySQL database software 
or a MySQL Enterprise subscription in order to use the DataDirect 
Connect64 for ODBC driver for MySQL Enterprise with MySQL software.
-----------------------------------------------------------------------

All trademarks and registered trademarks mentioned herein are the 
property of their respective owners.


~~~~~~~~~~~~~~
End of README
