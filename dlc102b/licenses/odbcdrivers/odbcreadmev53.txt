     README
     DataDirect Technologies
     DataDirect Connect for ODBC
     DataDirect Connect XE (Extended Edition) for ODBC
     Windows Platforms
     Release 5.3 Service Pack 1
     September 2007


***********************************************************************
Copyright (c) 2007 DataDirect Technologies Corp. All rights reserved. 
 
DataDirect Connect is a registered trademark of DataDirect Technologies 
Corp. in the U.S. and other countries. Any other trademarks or service 
marks contained herein are the property of their respective owners.
***********************************************************************

This README file contains information not included in the DATADIRECT 
CONNECT AND CONNECT XE FOR ODBC USER'S GUIDE or the online help.

IMPORTANT: You must have version 2.6 or higher of the Microsoft Data 
Access Components (MDAC) installed to use this product. Depending on the 
version of your Windows operating system, these components may already be 
installed. You can download a utility that determines whether MDAC is 
installed and its version from the following Microsoft site:

http://msdn2.microsoft.com/en-us/data/aa937730.aspx

You can also download MDAC from the same site or install it from the 
DataDirect CD. To install from the CD, navigate from the root directory 
to \mdac and run MDAC_TYP.EXE.


CONTENTS

Changes for Service Pack 1 since Release 5.3
Release 5.3 Features
Available ODBC Drivers
Disk Space Requirements
Driver WorkAround Options
Notes, Known Problems, and Restrictions
Using the Online Documents
Installed Files
Third-Party Vendor License Agreements


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
----------------------------------------
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

See the DATADIRECT CONNECT AND CONNECT XE FOR ODBC INSTALLATION GUIDE 
for a complete list of supported databases and client requirements.

DataDirect Connect for ODBC Drivers
-----------------------------------
Btrieve (IVBTR23.DLL)

DB2 Wire Protocol (IVDB223.DLL)

dBASE (IVDBF23.DLL)

FoxPro 3.0 DBC (Built into the dBASE driver)

Informix Wire Protocol (IVIFCL23.DLL)

MySQL Wire Protocol (IVMYSQL23.DLL) 

Oracle Wire Protocol (IVORA23.DLL)

Paradox   (IVIDP23.DLL)

SQL Server Wire Protocol (IVMSSS23.DLL) 

Sybase Wire Protocol (IVASE23.DLL)

Text (IVTXT23.DLL)

XML (IVXML23.DLL)

Informix (IVINF23.DLL)

Oracle (IVOR823.DLL)


DataDirect Connect XE for ODBC Driver
-------------------------------------
Teradata (IVTERA23.DLL)


     Disk Space Requirements

The following disk space requirements assume a full installation of
all drivers and options.

DataDirect Connect for ODBC Drivers
-----------------------------------
46 MB of available hard disk space. 

DataDirect Connect XE for ODBC Driver
-------------------------------------
27 MB of available hard disk space.


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
workaround reverses the order in which types are returned so that 
Access will use the most appropriate native type.

WorkArounds2=8. This workaround causes the driver to add the bindoffset 
in the ARD to the pointers returned by SQLParamData. This is to 
work around a MSDASQL problem.

WorkArounds2=16. This workaround causes the drivers to ignore calls 
to SQLFreeStmt(RESET_PARAMS) and only return success without taking 
other action. It also causes parameter validation not to use the bind 
offset when validating the charoctetlength buffer. This is to work 
around a MSDASQL problem.

WorkArounds2=24. If you are using a DataDirect Connect for ODBC flat-
file driver, such as dBASE, under MSDASQL, you must use this workaround 
for the driver to operate properly.

WorkArounds2=32. Microsoft Access requires "DSN" to be included in a 
connection string. This workaround appends "DSN=" to a connection 
string if it is not already included.

WorkArounds2=128. Some applications will open extra connections if 
SQLGetInfo(SQL_ACTIVE_STATEMENTS) does not return 0. This workaround 
causes SQLGetInfo(SQL_ACTIVE_STATEMENTS) to return 0 to avoid the 
overhead of these extra connections.

WorkArounds2=256. Workaround for MSDASQL. Causes the drivers to return 
Buffer Size for Long Data on calls to SQLGetData with a buffer size of 
0 on columns whose SQL type is SQL_LONGVARCHAR or SQL_LONGVARBINARY. 
Applications should always set this workaround when using MSDASQL and 
retrieving long data.

WorkArounds2=512. Workaround for Microsoft Query 2000. Causes the 
flat-file drivers to return old literal prefixes and suffixes for 
date, time, and timestamp data types. Query 2000 does not correctly 
handle the ODBC escapes that are currently returned as literal prefix 
and literal suffix.

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

Microsoft Access and Visual Basic Users
---------------------------------------
We recommend that users of Microsoft Access and Visual Basic add the 
value pair WorkArounds=25 (1+8+16) for each data source they use with 
Access and Visual Basic. For data sources that support a single 
connection, add the line WorkArounds=29 (1+4+8+16). Also, add
WorkArounds2=8192.


     Notes, Known Problems, and Restrictions

The following are notes, known problems, and restrictions with Release 
5.3 Service Pack 1 of DataDirect Connect and Connect XE for ODBC on 
Windows.

Upgrading from an Evaluation to a Licensed Installation
-------------------------------------------------------
If you have installed an evaluation copy of the drivers and want to 
upgrade to a licensed version, you must use the Modify option of the 
installation program. See the DATADIRECT CONNECT AND CONNECT XE FOR 
ODBC INSTALLATION GUIDE for details about using the Modify option.

Installing and Removing Default Data Sources
--------------------------------------------
When you first install a driver, you are given the option to install a 
default data source for that driver. If you do not install the default 
data source at this time, and run the installer again later using the 
"modify" option, you will not be able to install a default data source 
for this driver even though this choice is available on the modify 
window. To install a default data source for a driver after the 
initial installation, you must uninstall the driver and then reinstall 
it.

If you uninstall a 5.2 product after you have installed a 5.3 product, 
default data sources that were created by the installer and share the 
same name for both product versions will be removed from your machine.

Installation Issues on Windows 98 and Windows Me
------------------------------------------------
When you install DataDirect Connect for ODBC, the installer modifies 
the AUTOEXEC.BAT file to include a SET PATH statement that specifies 
the path to the DataDirect Connect for ODBC installation. If you have 
installed DataDirect Connect for ODBC on Windows 98 or Windows Me, and 
then modify, upgrade, or uninstall it, the original SET PATH statement 
is not removed from AUTOEXEC.BAT. You must manually remove it with a 
text editor.

Installing the XML Driver
-------------------------
You cannot have side-by-side installations of the DataDirect Connect 
for ODBC XML 5.3 driver and the DataDirect Connect for ODBC XML 5.2 
driver on your machine. After you install the 5.3 XML driver, the 5.2 
XML driver will not work. If you uninstall the 5.2 XML driver after 
installing the 5.3 driver, you must self-register the following two 
XML files:

*INIADX09.DLL
*INXMLX09.DLL

For example, to self-register INIADX09.DLL, enter:

regsvr32 INIADX09.DLL

You must also have the Microsoft XML Parser installed. If you are 
downloading the parser, as instructed in the DATADIRECT CONNECT AND 
CONNECT XE FOR ODBC USER'S GUIDE, be sure to download the complete 
package, MSXML.MSI, not the sub-packages also available on the site.

For SSL Users
-------------
When trying to connect to a database using SSL encryption, you may 
receive an error message similar to: "PRNG not seeded". This is because 
certain versions of some operating systems do not generate truly random 
numbers necessary for encryption. For more information about this error 
and available patches, please refer to the Web site:

http://www.openssl.org/support/faq.html#USER1

SQLColAttribute(s)
------------------
The column attributes 1001 and 1002, which were assigned as DataDirect-
specific attributes, were inadvertently used as system attributes by 
the Microsoft 3.0 ODBC implementation. Applications using those 
attributes must now use 1901 and 1902, respectively.

SQL_C_NUMERIC
-------------
Because of inconsistencies in the ODBC specification, users attempting 
to use SQL_C_NUMERIC parameters must set the precision and scale 
values of the corresponding structure, and the descriptor fields in the 
APD.

For Developers Using IIS
------------------------
One of the most common connectivity issues encountered while using IIS 
(Microsoft's Internet Information Server) concerns the use and settings 
of the account permissions. If you encounter problems using DataDirect 
Connect and Connect XE for ODBC with an IIS server, please see 
KnowledgeBase document number 28541 on the DataDirect Technologies web 
site:

http://www.datadirect.com.

For Microsoft Access Users
--------------------------
Some SQL implementations, such as PROGRESS, do not allow queries to 
contain the COUNT function without the DISTINCT set quantifier. For 
example, "select COUNT(empid) from employees" is not a valid PROGRESS 
query. This type of query can be generated using Microsoft Access and 
will result in an error.

For MTS-DTC Users
-----------------
Distributed transaction support (MTS-DTC) is available only under 
Windows NT 4.x, Windows 2000, Windows XP, and Windows Server 2003.

On Windows NT, the Microsoft Transaction Server must be installed on 
the client on which you install the DTC-enabled ODBC drivers. 
Install the Microsoft Transaction Server as follows:

1. Make sure you have Windows NT Service Pack 3 or higher installed.
    This is required before you can install NT Options Pack 4.0.

2. Install NT Options Pack 4.0.

3. Install NT Service Pack 5 or higher. If you had NT Service Pack 5
    or higher installed before you installed NT Options 4.0, you must 
    reinstall the Service Pack.

Because MTS-DTC runs as an NT service, the DTC-enabled ODBC drivers 
and the database clients they require must be installed on a local hard 
drive. If you install the DTC-enabled ODBC drivers into a directory 
other than the \PROGRAM FILES\DATADIRECT\ODBC32v52\DRIVERS (default) 
directory, that directory must be on the System PATH.

On Windows 2000, the Microsoft Transaction Server is already installed.

For Btrieve Users
-----------------
The Btrieve driver may experience problems if the Btrieve Microkernel 
Engine's communication buffer size is smaller than the Btrieve driver's 
Array Size attribute. You can increase the communication buffer size 
with the BTI Database Setup Utility. You can decrease the array size 
option when you configure a data source using the ODBC Btrieve Setup 
dialog, or when passing a connection string.

For Flat-File Users
-------------------
If you are using a DataDirect Connect for ODBC flat-file driver, such 
as dBASE, under MSDASQL, you should use WorkArounds2=24 as described in 
the section "Driver Options" in this README.

For Informix Users
------------------
Restriction:  Some Informix error messages may contain more than one 
error. All errors displayed may not be valid.

Attempting to use Microsoft Query '95 with the Informix drivers will 
result in a protection fault from Query. This is because Query does 
not recognize the INTERVAL data types supplied by the drivers. Users 
will need to obtain Microsoft Query '97 to obtain the fix.

For Oracle8 Server Users
------------------------
The DataDirect Connect for ODBC Oracle driver uses the XA protocol 
support in Oracle8 to accomplish distributed transaction support. For 
recovery to work properly, you must grant appropriate privileges on 
any server that will participate in a DTC transaction. You must grant 
the SELECT privilege on SYS.DBA_PENDING_TRANSACTIONS to all users that 
will use MTS. Refer to the Oracle8 documentation for details on using 
Oracle XA.

For Microsoft SQL Server Users
------------------------------
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

For Text Users
--------------
Restriction:  When encountering an invalid file, you may receive 
duplicate or multiple errors from SQLError.


     Using the Online Documents

The DataDirect Connect for ODBC books are provided in PDF and HTML 
versions. The PDF versions are provided on the product CD and also on 
the DataDirect Technologies Web site:

http://www.datadirect.com/techres/jdbcproddoc/index.ssp

You can view the PDF versions using Adobe Reader.

NOTE: To download Adobe Reader, visit Adobe�s Web site at 
http://www.adobe.com.

The HTML versions of the books are installed in the help subdirectory 
of your product installation directory.


     Installed Files 

The file list below assumes a full installation of all drivers and 
documentation.

Running Setup copies the following files to the system directory, by 
default, C:\WINDOWS\SYSTEM:

CTL3D32.DLL       Visual C Runtime Library
MFC42.DLL         Visual C Runtime Library

Setup copies the following files and subdirectories to the product 
installation directory, by default, C:\PROGRAM FILES\DATADIRECT
\ODBC32v53:

401COMUPD.EXE
ICULICENSE.TXT    License agreement for ICU
MYSQLLICENSE.TXT  License agreement for MySQL
ODBCFIXES.TXT     A text file that lists the fixes in the release
ODBCREADME.TXT    This file
XMLP.EXE          A GUI demo tool that persists a result set to an
                  XML data file

\BIND:

DDODBC_LUW.LST   DB2 list files for Linux/UNIX/Windows
DDODBC_400.LST   DB2 list files for iSeries
DDODBC_MVS.LST   DB2 list files for z/OS
DDOC510A.BND
DDOS510A.BND
DDOR510A.BND
DDOU510A.BND
DDON510A.BND
DDOC510B.BND
DDOS510B.BND
DDOR510B.BND
DDOU510B.BND
DDON510B.BND
DDOC510C.BND
DDOS510C.BND
DDOR510C.BND
DDOU510C.BND
DDON510C.BND

\DRIVERS:

For the following files, resource files for a driver end in R.DLL; 
setup files for a driver end in S.DLL.

DDEXTWIN.EXE
INIADX09.DLL      Support DLL for XML driver
INIADX09R.DLL
INXMLX09.DLL      Support DLL for XML driver
INXMLX09R.DLL
IVASE23.DLL       Sybase Wire Protocol driver
IVASE23R.DLL
IVBTR23.DLL       Btrieve (Pervasive.SQL) driver
IVBTR23R.DLL
IVBTR23S.DLL
IVCRYPTO23.DLL    SSL support file
IVDB223.DLL       DB2 Wire Protocol driver
IVDB223R.DLL
IVDBF23.DLL       dBASE driver
IVDBF23R.DLL
IVICU23.DLL       Unicode conversion tables
IVIDP23.DLL       Paradox driver
IVIDP23R.DLL
IVIDP23S.DLL
IVIFCL23.DLL      Informix Wire Protocol driver
IVIFCL23R.DLL
IVINF23.DLL       Informix driver
IVINF23R.DLL
IVINF23S.DLL
IVINFDTC23.DLL
IVMSSS23.DLL      SQL Server Wire Protocol driver
IVMSSS23R.DLL
IVMYSQL23.DLL     MySQL Wire Protocol driver
IVMYSQL23R.DLL
IVODBC.LIC        DataDirect driver license file
IVOR823.DLL       Oracle driver
IVOR823R.DLL
IVOR823S.DLL
IVOR8DTC23.DLL
IVORA23.DLL       Oracle Wire Protocol driver
IVORA23R.DLL
IVSSL23.DLL       SSL support file
IVTERA1023.DLL    Teradata driver (Connect XE for ODBC)
IVTERA1023R.DLL
IVTERA1023S.DLL
IVTRN23.DLL       DataDirect sample translation DLL
IVTXT23.DLL       Text driver
IVTXT23R.DLL
IVXML23.DLL       XML driver
IVXML23R.DLL
IVXML23S.DLL
LICENSE.INI       License information file
QESQLEXT.H        Header file for DataDirect-specific ODBC
                  definitions
\EXAMPLE: 

EXAMPLE.C         Source file for example program
EXAMPLE.DSP       Project file for example program 
EXAMPLE.DSW       Workspace file for example program
EXAMPLE.EXE       Executable file for example program
EXAMPLE.H         Header file for example program
EXAMPLE.MAK       Make file for example program
EXAMPLE.TXT       Short description of the program

\HELP: 

HELP.HTM          HTML help system entry file
\*.*              Support folders for the HTML help system 

\TOOLS:

DSNCONVERTERSIL.EXE    Data Source Converter utility
DDPROCINFO.EXE         Processor Information utility

\TRANSLAT:

LIBMAIN.C
README.TRN        Translation Library information file
TRANSLAT.C        Sample Translation Library source file
WINNT.MAK         Makefile for the Sample Translation Library

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

The DataDirect Connect for ODBC driver for MySQL Enterprise was 
developed using the MySQL Protocol Documentation whose copyright is 
owned by, and licensed by DataDirect from, MySQL AB. If DataDirect 
Connect for ODBC is licensed for the MySQL database the following shall 
apply: You must purchase commercially licensed MySQL database software 
or a MySQL Enterprise subscription in order to use the DataDirect Connect 
for ODBC driver for MySQL Enterprise with MySQL software.
-----------------------------------------------------------------------

All trademarks and registered trademarks mentioned herein are the 
property of their respective owners.


~~~~~~~~~~~~~~
End of README
