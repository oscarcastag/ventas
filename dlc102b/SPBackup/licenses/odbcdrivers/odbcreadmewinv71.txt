
     README
     Progress(R) DataDirect(R)
     DataDirect Connect(R) for ODBC
     DataDirect Connect XE (Extended Edition) for ODBC
     
     DataDirect Connect64(R) for ODBC
     DataDirect Connect64 XE (Extended Edition) for ODBC

     Progress OpenEdge Wire Protocol Driver

     Windows Platforms
     Release 7.1.1 
     May 2013

***********************************************************************
Copyright (c) 1990-2013 Progress Software Corporation and/or its 
subsidiaries or affiliates. All Rights Reserved.  
***********************************************************************

This README file contains additional driver information not 
included in the DataDirect Connect(R) for ODBC(TM) documentation for 
Progress OpenEdge(R).

IMPORTANT: You must have the Microsoft Data Access Components (MDAC) 
installed to use this product.
 
* For 32-bit Windows systems, version 2.6 or higher is required.
* For 64-bit Windows systems, version 2.8 or higher is required.

Depending on the version of your Windows operating system, these 
components may already be installed. You can download a utility that 
determines whether MDAC is installed and its version from the following 
Microsoft site:

http://msdn.microsoft.com/en-us/data/aa937730.aspx

You can also download MDAC from the same site.


CONTENTS

Progress OpenEdge Wire Protocol Driver
Driver WorkAround Options
Notes, Known Problems, and Restrictions
Using the Online Documents
Installed Files
Third-Party Acknowledgements


     Progress OpenEdge Wire Protocol Driver

The file name of the Progress OpenEdge Wire Protocol driver is 
pgoe27.dll.


New Operating System Support
----------------------------
* Certified with Windows 8 and Windows Server 2012. 


     Driver WorkAround Options

Progress DataDirect has included non-standard connection options 
(workarounds) for the drivers that enable you to take full advantage of 
packaged ODBC-enabled applications requiring non-standard or extended 
behavior.

Refer to the chapter "WorkAround Options" in the DATADIRECT CONNECT 
SERIES FOR ODBC REFERENCE for a description of these options.


     Notes, Known Problems, and Restrictions

The following are notes, known problems, or restrictions with 
Release 7.1.1.


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
installation program. 

Installing and Removing Default Data Sources
--------------------------------------------
When you first install a driver, you are given the option to install a 
default data source for that driver. We recommend that you install 
default data sources when you first install the drivers. If you do not 
install the default data source at this time, you will be unable to 
install a default data source for this driver later. To install a 
default data source for a driver after the initial installation, you 
must uninstall the driver and then reinstall it.

If you uninstall a 7.0 product after you have installed a 7.1 product, 
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


For Developers Using IIS
------------------------
One of the most common connectivity issues encountered while using IIS 
(Microsoft's Internet Information Server) concerns the use and settings 
of the account permissions. If you encounter problems using DataDirect 
drivers with an IIS server, refer to KnowledgeBase document number 3907 
on the Progress DataDirect web site:

http://knowledgebase.datadirect.com.

For Microsoft Access Users
--------------------------
Some SQL implementations, such as PROGRESS, do not allow queries to 
contain the COUNT function without the DISTINCT set quantifier. For 
example, "SELECT COUNT(empid) FROM employees" is not a valid SQL query 
for PROGRESS. This type of query can be generated using Microsoft 
Access and results in an error.

Driver Defects Resolved
-----------------------
PSC00093392 The driver took a long time to get the catalog of tables
for a typical application.


     Using the Online Documents


You can view the documentato using Adobe Reader.

NOTE: To download Adobe Reader, visit the Adobe Web site at 
http://www.adobe.com.

The HTML versions of the books are installed in the help subdirectory 
of your product installation directory.

     
     Installed Files

The installer copies the following files and subdirectories to the 
product installation directory:

NOTICES.TXT         Third-party vendor license agreements
FIXES.TXT           List of fixes since last release
ODBCREADME.TXT      This file (32-bit)
ODBCREADME64.TXT    This file (64-bit)

\DRIVERS:

PGICU27.DLL       Unicode conversion tables
PGODBC.LIC        Driver license file
PGOE27.DLL        Progress OpenEdge Wire Protocol driver
PGOE27R.DLL       Progress OpenEdge Wire Protocol driver resource file
PGSSL27.DLL       SSL support file
PGTRC27.DLL	  Progress OpenEdge Wire Protocol driver trace library

\HELP: 
HELP.HTM              HTML help system entry file
WWHSEC.HTM            HTML help system support file
\*.*                  Support folders for the HTML help system

\EXAMPLES: 


\EXAMPLE\EXAMPLE.C         Example source
\EXAMPLE\EXAMPLE.EXE       Example application
\EXAMPLE\EXAMPLE.H         Example header
\EXAMPLE\EXAMPLE.SLN       Example solution file
\EXAMPLE\EXAMPLE.VCPROJ    Example project file
\EXAMPLE\EXAMPLE.TXT       Example description
\EXAMPLE\EXAMPLE.MAK       Example make file (used instead of .SLN and 
                           .VCPROJ files on Itanium 64 only)


     Third-Party Acknowledgements

Third Party Acknowledgements: One or more products in the Progress DataDirect
Connect for ODBC v7.1, Progress DataDirect Connect64 for ODBC v7.1, 
Progress DataDirect Connect XE for ODBC v7.1, Progress DataDirect Connect64 XE
for ODBC v7.1 release includes third party components covered by licenses that
require that the following documentation notices be provided:
Progress DataDirect Connect for ODBC v7.1, Progress DataDirect Connect64 for 
ODBC v7.1, Progress DataDirect Connect XE for ODBC v7.1, Progress DataDirect 
Connect64 XE for ODBC v7.1 each incorporate ICU v4.2.1 from International 
Business Machines Corporation. Such technology is subject to the following 
terms and conditions: ICU License - ICU 1.8.1 and later ICU License - ICU 1.8.1
and later COPYRIGHT AND PERMISSION NOTICE. Copyright (c) 1995-2010 International
Business Machines Corporation and others. All rights reserved. Permission is
hereby granted, free of charge, to any person obtaining a copy of this software
and associated documentation files (the "Software"), to deal in the Software 
without restriction, including without limitation the rights to use, copy, 
modify, merge, publish, distribute, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, provided that the 
above copyright notice(s) and this permission notice appear in all copies of 
the Software and that both the above copyright notice(s) and this permission
notice appear in supporting documentation. THE SOFTWARE IS PROVIDED "AS IS",
WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
NONINFRINGEMENT OF THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER
OR HOLDERS INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL 
INDIRECT OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE 
OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE. Except as contained in this notice, the name of
a copyright holder shall not be used in advertising or otherwise to promote the
sale, use or other dealings in this Software without prior written 
authorization of the copyright holder. All trademarks and registered trademarks
mentioned herein are the property of their respective owners.

Progress DataDirect Connect for ODBC v7.1, Progress DataDirect Connect64 for 
ODBC v7.1, Progress DataDirect Connect XE for ODBC v7.1, Progress DataDirect 
Connect64 XE for ODBC v7.1 each incorporate HyperSQL database v1.8.0.10 from
The HSQL Development Group. Such technology is subject to the following terms
and conditions: Copyright (c) 2001-2005, The HSQL Development Group All rights
reserved. Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions are met: 
Redistributions of source code must retain the above copyright notice, this 
list of conditions and the following disclaimer. Redistributions in binary 
form must reproduce the above copyright notice, this list of conditions and
the following disclaimer in the documentation and/or other materials provided 
with the distribution. Neither the name of the HSQL Development Group nor the
names of its contributors may be used to endorse or promote products derived
from this software without specific prior written permission. THIS SOFTWARE
IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS
OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF 
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO 
EVENT SHALL HSQL DEVELOPMENT GROUP, HSQLDB.ORG, OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
Progress DataDirect Connect for ODBC v7.1, Progress DataDirect Connect64 for
ODBC v7.1, Progress DataDirect Connect XE for ODBC v7.1, Progress DataDirect
Connect64 XE for ODBC v7.1 each incorporate OpenSSL v1.0.0d from The OpenSSL
Project. Such technology is subject to the following terms and conditions:
LICENSE ISSUES ============== The OpenSSL toolkit stays under a dual license,
i.e. both the conditions of the OpenSSL License and the original SSLeay
license apply to the toolkit. See below for the actual license texts. 
Actually both licenses are BSD-style Open Source licenses. In case of any
license issues related to OpenSSL please contact 
openssl-core@openssl.org.
OpenSSL License ---------------
Copyright (c) 1998-2011 The OpenSSL Project. All rights reserved.
Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.
3. All advertising materials mentioning features or use of this software
   must display the following acknowledgment:    "This product includes 
   software developed by the OpenSSL Project for use
   in the OpenSSL Toolkit. (http://www.openssl.org/)"
4. The names "OpenSSL Toolkit" and "OpenSSL Project" must not be used to 
   endorse or promote products derived from this software without prior 
   written permission. For written permission, please contact 
   openssl-core@openssl.org.
5. Products derived from this software may not be called "OpenSSL" nor may 
   "OpenSSL" appear in their names without prior written permission of the 
   OpenSSL Project.
6. Redistributions of any form whatsoever must retain the following 
   acknowledgment: "This product includes software developed by the OpenSSL
   Project for use in the OpenSSL Toolkit (http://www.openssl.org/)"

THIS SOFTWARE IS PROVIDED BY THE OpenSSL PROJECT ``AS IS'' AND ANY EXPRESSED
OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN 
NO EVENT SHALL THE OpenSSL PROJECT OR ITS CONTRIBUTORS BE LIABLE FOR ANY 
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF 
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
====================================================================
This product includes cryptographic software written by Eric Young 
(eay@cryptsoft.com). This product includes software written by Tim Hudson
(tjh@cryptsoft.com).
Original SSLeay License ----------------------- Copyright (C) 1995-1998 
Eric Young (eay@cryptsoft.com) All rights reserved.
This package is an SSL implementation written by Eric Young (eay@cryptsoft.com).
The implementation was written so as to conform with Netscapes SSL. 
This library is free for commercial and non-commercial use as long as the
following conditions are aheared to. The following conditions apply to all code
found in this distribution, be it the RC4, RSA, lhash, DES, etc., code; not just
the SSL code. The SSL documentation included with this distribution is covered
by the same copyright terms except that the holder is Tim Hudson 
(tjh@cryptsoft.com). Copyright remains Eric Young's, and as such any Copyright 
notices in the code are not to be removed. If this package is used in a product,
Eric Young should be given attribution as the author of the parts of the library
used. This can be in the form of a textual message at program startup or in 
documentation (online or textual) provided with the package. Redistribution 
and use in source and binary forms, with or without modification, are permitted
provided that the following conditions are met:
1. Redistributions of source code must retain the copyright notice, this list
   of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice, 
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.
3. All advertising materials mentioning features or use of this software must
   display the following acknowledgement: "This product includes cryptographic
   software written by Eric Young (eay@cryptsoft.com)" The word 'cryptographic'
   can be left out if the routines from the library being used are not 
   cryptographic related :-).
4. If you include any Windows specific code (or a derivative thereof) from the
   apps directory (application code) you must include an acknowledgement: "This
   product includes software written by Tim Hudson (tjh@cryptsoft.com)"
THIS SOFTWARE IS PROVIDED BY ERIC YOUNG ``AS IS'' AND ANY EXPRESS OR IMPLIED 
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF 
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO 
EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
OTHERWISE)ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.
The licence and distribution terms for any publically available version or 
derivative of this code cannot be changed. i.e. this code cannot simply be copied
and put under another distribution licence [including the GNU Public Licence.]
Progress DataDirect Connect for ODBC v7.1, Progress DataDirect Connect64 for 
ODBC v7.1, Progress DataDirect Connect XE for ODBC v7.1, Progress DataDirect 
Connect64 XE for ODBC v7.1 each incorporate PostSQL Database Management System
v8.3.3. Such technology is subject to the following terms and conditions: 
PostgreSQL is released under the BSD license. PostgreSQL Database Management 
System (formerly known as Postgres, then as Postgres95) Portions Copyright 
(c) 1996-2005, The PostgreSQL Global Development Group Portions Copyright (c)
1994, The Regents of the University of California Permission to use, copy, 
modify, and distribute this software and its documentation for any purpose,
without fee, and without a written agreement is hereby granted, provided that
the above copyright notice and this paragraph and the following two paragraphs
appear in all copies. IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE
TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES,
INCLUDING LOST PROFITS, ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS
DOCUMENTATION, EVEN IF THE UNIVERSITY OF CALIFORNIA HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE. THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS
ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE PROVIDED
HEREUNDER IS ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO 
OBLIGATIONS TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
 MODIFICATIONS. Why not the GNU General Public License? People often ask why
 PostgreSQL is not released under the GNU General Public License. The simple
answer is because we like the BSD license and do not want to change it. If you
are keen to read more about this topic, then please take a look in the Archives
at any of the many threads on this subject, but please don't start yet another
debate on the subject!


~~~~~~~~~~~~~~
November 2013

End of README

