     README
     Progress(R) DataDirect(R)
     DataDirect Connect(R) for ODBC
     DataDirect Connect XE (Extended Edition) for ODBC
     Windows Platforms
     Release 6.1.2
     June 2011


***********************************************************************
Copyright (c) 1990-2011 Progress Software Corporation and/or its 
subsidiaries or affiliates. All Rights Reserved.  
***********************************************************************

This README file contains information not included in the DATADIRECT 
CONNECT(R) SERIES FOR ODBC documentation.

IMPORTANT: You must have version 2.6 or higher of the Microsoft Data 
Access Components (MDAC) installed to use this product. Depending on 
the version of your Windows operating system, these components may 
already be installed. You can download a utility that determines 
whether MDAC is installed and its version from the following Microsoft 
site:

http://msdn.microsoft.com/en-us/data/aa937730.aspx

You can also download MDAC from the same site.


CONTENTS

Changes for Service Pack 2
Changes for Service Pack 1
Release 6.1 Features
Available ODBC Drivers
Disk Space Requirements
Driver WorkAround Options
Notes, Known Problems, and Restrictions
Using the Online Documents
Installed Files


     Changes for Service Pack 2

* New Salesforce Driver provides access to Salesforce.com and Force.com 
  data sources. It supports the following features:

  - Secure Socket Layer (SSL) Data Encryption
  - Failover
  - DataDirect Bulk Load
  - Connection pooling
  - Report execution using stored procedures
  - Parameter arrays
  - Login timeout

  For more information about these features, refer to the 
  DATADIRECT CONNECT FOR ODBC SERIES USER'S GUIDE.


     Changes for Service Pack 1

DB2
---
* The DB2 Wire Protocol driver has been certified against the following 
  databases:
  - DB2 V10 for z/OS
  - DB2 V7R1 for iSeries

* For DB2 V7R1 for iSeries, the driver supports the following features:
  - XML data type. You use the XMLDescribeType (XDT) connection option 
    to specify whether the XML data type is mapped to the ODBC 
    SQL_WLONGVARCHAR or SQL_LONGVARBINARY type. Refer to the 
    description in the DATADIRECT CONNECT SERIES FOR ODBC USER'S GUIDE.

  - AES encryption during authentication. You use the 
    AuthenticationMethod (AM) connection option to specify the 
    authentication method. Refer to the description in the DATADIRECT 
    CONNECT SERIES FOR ODBC USER'S GUIDE.

   - ConcurrentAccessResolution (CAR) connection option. This option 
    determines the driver's behavior for read transactions when 
    committed rows are locked by a write transaction when the 
    application's isolation level is Read Committed or Repeatable 
    Read. DB2 V7R1 for iSeries does not currently support reading 
    currently committed data when operating on a table containing 
    LOBs. In this scenario, transactions always wait for a commit or 
    rollback operation if they encounter data that is being updated or 
    deleted. Refer to the description in the DATADIRECT CONNECT FOR 
    ODBC USER'S GUIDE.

* For DB2 V10 for z/OS, the driver supports the following features:
  - Data type support for:
    * Timestamp data type with variable precision. Timestamp values 
      with a fractional seconds precision > 9 are described as the ODBC 
      SQL_VARCHAR data type.

    * Timestamp with Time Zone data type. For more information, see the 
      description for the FetchTSWTZasTimestamp connection option in 
      this README file.

    * XML data type, including the ability to use XML data as input or 
      output parameters.

  - ConcurrentAccessResolution (CAR) connection option. This option 
    determines the driver's behavior for read transactions when 
    committed rows are locked by a write transaction when the 
    application's isolation level is Read Committed or Repeatable Read.
    DB2 V10 for z/OS does not currently support reading currently 
    committed data while performing UPDATE statements. In this 
    scenario, transactions always wait for a commit or rollback 
    operation if they encounter data that is being updated or deleted. 
    Refer to the description in the DATADIRECT CONNECT FOR ODBC USER'S 
    GUIDE.

  - New FetchTSWTZasTimestamp connection option. This option determines 
    whether the driver returns Timestamp with Time Zone columns as an 
    ODBC SQL_TYPE_TIMESTAMP or SQL_VARCHAR data type. If set to 1, the 
    driver maps Timestamp with Time Zone columns to the ODBC 
    SQL_TYPE_TIMESTAMP data type, which can result in time zone 
    information being truncated. If set to 0, they are mapped to 
    SQL_VARCHAR, allowing your application to retrieve the information 
    as a String. The default value is 0 (map to SQL_VARCHAR).

Greenplum
---------
* The Greenplum Wire Protocol driver has been certified against the 
  following database:

  - Greenplum 4.0

Informix
--------
* The Informix Wire Protocol driver has been certified against 
  Informix 11.7.

MySQL
-----
* The MySQL Wire Protocol driver has been certified against MySQL 5.5.

PostgreSQL
------------
* The PostgreSQL Wire Protocol driver has been certified against 
  PostgreSQL 9.0.

Teradata
--------
* The driver for the Teradata database has been certified against 
  Teradata 13.10.

Installation Directory
----------------------
* The default installation directory for DataDirect Connect for ODBC 
  is:

  C:\Program Files\Progress\DataDirect\Connect_for_ODBC_61


     Release 6.1 Features

New Features
------------
* Bulk streaming sample application

New Database Version Support
----------------------------
* DB2 V9.7 for Linux, UNIX, Windows (LUW)
* Greenplum 3.3
* Oracle 11gR2
* PostgreSQL 8.4
* Sybase 15.5
* Teradata 13

New Operating System Support
----------------------------
* Windows 7

New Driver
----------
* MS SQL Server Wire Protocol driver (former SQL Server Native Wire 
  Protocol driver)
  -Dynamic, Keyset Server Support
  -Named Parameter Support

DB2 Wire Protocol Driver Enhancements
-------------------------------------
* DB2 V9.7 LUW features support:
  -AES encryption of UserID and Password
  -Currently committed transaction semantics
  -Statement concentrator
  -Inline LOB storage
  -New data type aliases
  -New SQL syntax
  -New scalar functions

Oracle Wire Protocol Driver Enhancements
----------------------------------------
* Oracle 11gR2 features support:
  -IPv6
  -Editions
  -Direct path no index errors
  -Oracle RAC grid naming service
  -Client information


Enhancement Requests and Fixes
------------------------------
DD00052846 | Added advanced options for TXT datatype to the Greenplum 
Driver.

DD00052519 | Added support for DB2 READ_ONLY cursors.

DD00052146 | Enhanced the Greenplum Wire Protocol driver to support 
additional data types.

DD00052145 | Added support to the Greenplum Wire Protocol driver for 
MONEY data type.

DD00051912 | Enhanced the PostgreSQL Wire Protocol driver to describe 
NUMERIC(1000) as NUMERIC.

DD00051446 | Added PDB files for Sybase Wire Protocol and MySQL Wire 
Protocol drivers.

DD00051139 | Silent installer added for UNIX/Linux platforms.

DD00050902 | Enhanced the Greenplum Wire Protocol driver to describe 
NUMERIC(1000) as NUMERIC.

DD00050829 | Added option to configure transactional behavior when bulk 
load was enabled.

DD00049750 | Dropped the use of the Windows-specific LONG from 
sqlunx.h.

DD00049501 | Added 64-bit 6.0 Progress OpenEdge ODBC driver.

DD00049025 | Removed 64K limit for parameter batches with the DB2 Wire 
Protocol driver.

DD00048888 | Enhanced the Text driver to return empty string instead of 
NULL for empty varchar columns.

DD00048885 | Enhanced the Text driver to return trailing spaces from 
FIXED table types.

DD00048583 | Enhanced the drivers to provide a means by which to make 
parameter array inserts non-atomic.

DD00048281 | Enhanced the drivers to accept strings with "N" prefix in 
time, date, and timestamp escapes.

DD00048161 | Enhanced the Teradata driver to accept ODBC 3.0 C data 
types as arguments to SQLBindParameter when running in ODBC 2.0 
compatibility mode.

DD00044950 | Enhanced configuration of TCP socket attributes in SQL 
Server driver.

DD00044402 | Added option to indicate that the application is calling 
Unicode functions.


     Available ODBC Drivers

Database drivers are continually being added to each operating 
environment. For the latest information about the specific drivers 
available for your platform, refer to the Progress DataDirect database 
support matrix Web page at:

www.datadirect.com/products/odbc/matrix/connectodbc.htm


     Disk Space Requirements

The following available disk space requirements assume a full 
installation of all drivers and options.

DataDirect Connect for ODBC Drivers: 52 MB

DataDirect Connect XE for ODBC Driver: 54 MB


     Driver WorkAround Options

Progress DataDirect has included non-standard connection options 
(workarounds) for the drivers that enable you to take full advantage of 
packaged ODBC-enabled applications requiring non-standard or extended 
behavior.

Refer to the chapter "WorkAround Options" in the DATADIRECT CONNECT 
SERIES FOR ODBC REFERENCE for a description of these options.


     Notes, Known Problems, and Restrictions

The following are notes, known problems, or restrictions with 
Release 6.1.2 of the DataDirect Connect Series for ODBC drivers.

SQL Server Wire Protocol Driver
--------------------------------------
The SQL Server Wire Protocol driver requires an application to specify 
the size of timestamp parameters when they are bound. Setting the 
option WorkArounds2 to WorkArounds2=2 enables this behavior.

In addition, the driver does not allow an application to change the 
size of parameter bindings between execute calls. Setting the option 
WorkArounds to WorkArounds=536870912 enables this behavior.

Refer to the chapter "WorkAround Options" in the DATADIRECT CONNECT 
SERIES FOR ODBC REFERENCE for a description of these options.

Internet Explorer and Google Toolbar Users
------------------------------------------
Internet Explorer with the Google Toolbar installed sometimes displays 
the following error when the browser is closed: "An error has occurred 
in the script on this page." This is a known issue with the Google 
Toolbar and has been reported to Google. When closing the DataDirect 
Connect Series for ODBC help system, this error may display.

Upgrading from an Evaluation to a Licensed Installation
-------------------------------------------------------
If you have installed an evaluation copy of the drivers and want to 
upgrade to a licensed version, you must use the Modify option of the 
installation program. See the DATADIRECT CONNECT SERIES FOR ODBC 
INSTALLATION GUIDE for details about using the Modify option.

Installing and Removing Default Data Sources
--------------------------------------------
When you first install a driver, you are given the option to install a 
default data source for that driver. We recommend that you install 
default data sources when you first install the drivers. If you do not 
install the default data source at this time, you will be unable to 
install a default data source for this driver later even though this 
choice is available with the "Modify" window. To install a default data 
source for a driver after the initial installation, you must uninstall 
the driver and then reinstall it.

If you uninstall a 6.0 product after you have installed a 6.1 product, 
default data sources that were created by the installer and share the 
same name for both product versions will be removed from your machine.

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
to use SQL_C_NUMERIC parameters must set the precision and scale values 
of the corresponding structure and the descriptor fields in the 
Application Parameter Descriptor.

For Informix Users
------------------
Restriction: Some Informix error messages may contain more than one 
error. All errors displayed may not be valid.

For Oracle 8 Server Users
-------------------------
The driver uses the XA protocol support in Oracle 8 to provide 
distributed transaction support. For recovery to work correctly, you 
must grant appropriate privileges on any server that will participate 
in a distributed transaction. You must grant the SELECT privilege on 
SYS.DBA_PENDING_TRANSACTIONS to all users that will use MTS. Refer to 
the Oracle 8 documentation for details on using Oracle XA.

For Microsoft SQL Server Users
------------------------------
If you have problems with the catalog functions returning incorrect 
data, you may need to upgrade your catalog stored procedures. Make 
sure that you have installed the latest version of the stored  
procedures, which are available from your database vendor. Refer to 
your Microsoft SQL Server documentation for more information.

The SQL Server Wire Protocol drivers return stored procedure names with 
the version number appended to them. For example, a procedure defined 
as "proc1" will be returned as "proc1;1".

The SQL Server Legacy Wire Protocol driver does not support multiple 
active statements on a single connection by default. See the Microsoft 
document for information about how to enable multiple active statements 
on a single connection using server-side cursors:

http://support.microsoft.com/kb/q140896/

When using the SQLDescribeParam method, the SQL Server Legacy Wire 
Protocol driver describes parameters that map to the Microsoft SQL 
Server 2008 date, time, datetime2, and datetimeoffset data types as 
SQL_WVARCHAR.

The options listed in the "WorkAround Options" chapter of the 
DATADIRECT CONNECT SERIES FOR ODBC REFERENCE cannot be used with the 
SQL Server Legacy Wire Protocol driver.

For Sybase Users
----------------
You may experience a problem using catalog stored procedures when 
running the Sybase Wire Protocol driver with Sybase Adaptive Server 
11.5. Contact Sybase and ask for the latest version of their catalog 
stored procedures.

For Btrieve Users
-----------------
The Btrieve driver may experience problems if the Btrieve Microkernel 
Engine's communication buffer size is smaller than the Btrieve driver's 
Array Size attribute. You can increase the communication buffer size 
with the BTI Database Setup Utility. You can decrease the array size 
option when you configure a data source using the ODBC Btrieve Setup 
dialog, or when passing a connection string.

For Text Users
--------------
Restriction: When the Text driver encounters an invalid file, you may 
receive duplicate or multiple errors.

For Flat-File Users
-------------------
If you are using a DataDirect Connect for ODBC flat-file driver, such 
as dBASE under MSDASQL, use WorkArounds2=24 as described in the Driver 
WorkAround Options chapter of the DATADIRECT CONNECT(R) SERIES FOR ODBC 
REFERENCE.

Installing the XML Driver
-------------------------
You cannot have side-by-side installations of the DataDirect Connect 
for ODBC XML 6.1 driver and the DataDirect Connect for ODBC XML 6.0 
driver on your machine. After you install the 6.1 XML driver, the 6.0 
XML driver will not work. If you uninstall the 6.0 XML driver after 
installing the 6.1 driver, you must self-register the following two 
XML files:

INIADX09.DLL
INXMLX09.DLL

For example, to self-register INIADX09.DLL, enter:

regsvr32 INIADX09.DLL

You must also have the Microsoft XML Parser installed. If you are 
downloading the parser, as instructed in the DATADIRECT CONNECT SERIES 
FOR ODBC USER'S GUIDE, be sure to download the complete package, 
MSXML.MSI, not the sub-packages also available on the site.

For Developers Using IIS
------------------------
One of the most common connectivity issues encountered while using IIS 
(Microsoft's Internet Information Server) concerns the use and settings 
of the account permissions. If you encounter problems using DataDirect 
drivers with an IIS server, refer to KnowledgeBase document number 4274 
on the Progress DataDirect web site:

http://knowledgebase.datadirect.com.

For Microsoft Access Users
--------------------------
Some SQL implementations, such as PROGRESS, do not allow queries to 
contain the COUNT function without the DISTINCT set quantifier. For 
example, "SELECT COUNT(empid) FROM employees" is not a valid SQL query 
for PROGRESS. This type of query can be generated using Microsoft 
Access and results in an error.


     Using the Online Documents

The DataDirect Connect Series for ODBC books are provided in PDF and 
HTML versions. The PDF versions are provided on the Progress DataDirect 
Web site:

http://web.datadirect.com/techres/odbc.html

You can view the PDF versions using Adobe Reader.

NOTE: To download Adobe Reader, visit the Adobe Web site at 
http://www.adobe.com.

The HTML versions of the books are installed in the help subdirectory 
of your product installation directory.


     Installed Files

Database drivers are continually being added to each operating 
environment. For the latest information about the specific drivers 
available for your platform, refer to the Progress DataDirect database 
support matrix Web page at:

www.datadirect.com/products/odbc/matrix/connectodbc.htm

This file list assumes a full installation of all drivers and 
documentation. Your installation may vary from this list depending on 
driver availability for your platform.

The installer copies the following files to the Windows system 
directory:

CTL3D32.DLL           Visual C Runtime Library
MFC42.DLL             Visual C Runtime Library
IVTRC25.DLL           DataDirect trace library

The installer copies the following files and subdirectories to the 
product installation directory, by default, C:\Program 
Files\Progress\DataDirect\Connect_for_ODBC_61:

NOTICES.TXT           Third-party vendor license agreements
LICENSE.TXT           Progress DataDirect license agreement
ODBCFIXES.TXT         List of fixes since last release
ODBCREADME.TXT        This file


\BIND:

\LUW\DDODBC_LUW.LST        DB2 list files for Linux/UNIX/Windows
\LUW\DDOC510A.BND
\LUW\DDOC510B.BND
\LUW\DDOC510C.BND
\LUW\DDOR510A.BND
\LUW\DDOR510B.BND
\LUW\DDOR510C.BND
\LUW\DDOS510A.BND
\LUW\DDOS510B.BND
\LUW\DDOS510C.BND
\LUW\DDOU510A.BND
\LUW\DDOU510B.BND
\LUW\DDOU510C.BND

\iSeries\DDODBC_400.LST    DB2 list files for iSeries
\iSeries\DDOC510A.BND
\iSeries\DDOC510B.BND
\iSeries\DDOC510C.BND
\iSeries\DDON510A.BND
\iSeries\DDON510B.BND
\iSeries\DDON510C.BND
\iSeries\DDOR510A.BND
\iSeries\DDOR510B.BND
\iSeries\DDOR510C.BND
\iSeries\DDOS510A.BND
\iSeries\DDOS510B.BND
\iSeries\DDOS510C.BND
\iSeries\DDOU510A.BND
\iSeries\DDOU510B.BND
\iSeries\DDOU510C.BND
\iSeries\DDOV5R2.SAVF
\iSeries\DDOV5R3.SAVF
\iSeries\DDOV5R4.SAVF
\iSeries\DDOV6R1.SAVF
\iSeries\DDOV7R1.SAVF
\iSeries\CfODBC AS400 Manual Package Creation Instructions.txt

\zOS\DDODBC_ZOS.LST        DB2 list files for z/OS
\zOS\CNTLFILE.XMIT
\zOS\DBRMFILE.XMIT
\zOS\DDOC510A.BND
\zOS\DDOC510B.BND
\zOS\DDOC510C.BND
\zOS\DDOR510A.BND
\zOS\DDOR510B.BND
\zOS\DDOR510C.BND
\zOS\DDOS510A.BND
\zOS\DDOS510B.BND
\zOS\DDOS510C.BND
\zOS\CfODBC zOS Manual Package Creation Instructions.txt


\DRIVERS:

Resource library file names end in R; setup library file names end 
in S.

DDEXTWIN.EXE          License Extender utility
INIADX09.DLL          Support DLL for XML driver
INIADX09R.DLL
INXMLX09.DLL          Support DLL for XML driver
INXMLX09R.DLL
IVASE25.DLL           Sybase Wire Protocol driver
IVASE25R.DLL
IVBTR25.DLL           Btrieve (Pervasive.SQL) driver
IVBTR25R.DLL
IVBTR25S.DLL
IVDB225.DLL           DB2 Wire Protocol driver
IVDB225R.DLL
IVDBF25.DLL           dBASE driver
IVDBF25R.DLL
IVGPLM25.DLL          Greenplum Wire Protocol driver
IVGPLM25R.DLL
IVICU25.DLL           Unicode conversion tables
IVIFCL25.DLL          Informix Wire Protocol driver
IVIFCL25R.DLL
IVINF25.DLL           Informix driver
IVINF25R.DLL
IVINF25S.DLL
IVINFDTC25.DLL
IVMSSS25.DLL          SQL Server Legacy Wire Protocol driver
IVMSSS25R.DLL
IVMYSQL25.DLL         MySQL Wire Protocol driver
IVMYSQL25R.DLL
IVODBC.LIC            DataDirect driver license file
IVOR825.DLL           Oracle driver
IVOR825R.DLL
IVOR825S.DLL
IVOR8DTC25.DLL
IVORA25.DLL           Oracle Wire Protocol driver
IVORA25R.DLL
IVPSQL25.DLL          PostgreSQL Wire Protocol driver
IVPSQL25R.DLL
IVSFRC25.DLL          Salesforce driver
IVSFRC25R.DLL
IVSFRC25S.DLL
IVSQLS25.DLL          SQL Server Wire Protocol driver
IVSQLS25R.DLL
IVSSL25.DLL           SSL support file
IVTERA25.DLL          Teradata driver (DataDirect Connect XE for ODBC)
IVTERA25R.DLL
IVTERA25S.DLL
IVTRN25.DLL           DataDirect sample translation DLL
IVTXT25.DLL           Text driver
IVTXT25R.DLL
IVXML25.DLL           XML driver
IVXML25R.DLL
IVXML25S.DLL
LICENSE.INI           License information file
QESQLEXT.H            Header file for DataDirect-specific ODBC
                      Definitions


\HELP: 

HELP.HTM              HTML help system entry file
WWHSEC.HTM            HTML help system support file
\*.*                  Support folders for the HTML help system


\JAVA\LIB:

SFORCE.JAR            Java components for the Salesforce driver


\SAMPLES: 

\BULK\BULK.C            Bulk example source
\BULK\BULK.EXE          Bulk application
\BULK\BULK.SLN          Bulk example solution file
\BULK\BULK.VCPROJ       Bulk example project file
\BULK\BULK.TXT          Bulk example description
\BULK\DDLOG.PROPERTIES  Log configuration file for the Salesforce 
                        driver

\BULKSTRM\BULK.CPP                Bulk streaming example source
\BULKSTRM\BULK.HPP                Bulk streaming example header
\BULKSTRM\BULK.RC                 Bulk streaming example resource file
\BULKSTRM\BULKSTRM.TXT            Bulk streaming description
\BULKSTRM\BULKSTREAMING.SLN       Bulk streaming example solution file
\BULKSTRM\BULKSTREAMING.VCPROJ    Bulk streaming example project file
\BULKSTRM\BULKSTRM.EXE            Bulk streaming example application
\BULKSTRM\DDLOG.PROPERTIES        Log configuration file for the 
                                  Salesforce driver
\BULKSTRM\MSGPRINTF.HPP           Bulk streaming example header file
\BULKSTRM\PROGRESSDATADIRECT.BMP
\BULKSTRM\PROGRESSDATADIRECT.ICO
\BULKSTRM\WINMAIN.CPP             Bulk streaming example source file

\EXAMPLE\DDLOG.PROPERTIES  Log configuration file for the Salesforce 
                           driver
\EXAMPLE\EXAMPLE.C         Example source
\EXAMPLE\EXAMPLE.EXE       Example application
\EXAMPLE\EXAMPLE.H         Example header
\EXAMPLE\EXAMPLE.SLN       Example solution file
\EXAMPLE\EXAMPLE.VCPROJ    Example project file
\EXAMPLE\EXAMPLE.TXT       Example description

\TRANSLAT\LIBMAIN.C
\TRANSLAT\README.TRN    Translation Library example description
\TRANSLAT\TRANSLAT.C    Translation Library example source file
\TRANSLAT\WINNT.MAK     Translation Library example make file


\TOOLS:

DDPROCINFO.EXE          Processor Information utility
DSNCONVERTERSIL.EXE     Data Source Converter utility
XMLP.EXE                A GUI demo tool that persists a result set to 
                        An XML data file


\WIZARDS:

INDEX.HTML
ODBCPERF.JAR            Performance wizard
\IMAGES\*.*


~~~~~~~~~~~~~~
End of README
