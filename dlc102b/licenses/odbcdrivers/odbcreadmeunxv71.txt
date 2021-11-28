     README
     Progress(R) DataDirect(R)
     DataDirect Connect(R) for ODBC
     DataDirect Connect XE (Extended Edition) for ODBC

     DataDirect Connect64(R) for ODBC
     DataDirect Connect64 XE (Extended Edition) for ODBC

     Progress OpenEdge Wire Protocol Driver

     UNIX and Linux Platforms

     Release 7.1.1  
     May 2013

***********************************************************************
Copyright (c) 1990-2013 Progress Software Corporation and/or its 
subsidiaries or affiliates. All Rights Reserved.  
***********************************************************************

This README file contains information not included in the DATADIRECT 
CONNECT(R) SERIES FOR ODBC documentation.


CONTENTS

Progress OpenEdge Wire Protocol Driver
Required Operating System Patches
Configuring Data Sources
Driver WorkAround Options
Notes, Known Problems, and Restrictions
Using the Online Documents
Installed Files
Third-Party Acknowledgements


 
Progress OpenEdge Wire Protocol Driver

The driver on all UNIX/Linux platforms has the same file name, 
pgoe27.xx, where xx represents the extension. The extension is .so, 
except for HP-UX PA-RISC, which uses the extension .sl.
     
New Operating System Certification
----------------------------------
* Red Hat 6.3


     Required Operating System Patches

For HP-UX 11 aCC Users Only
---------------------------
The ODBC drivers for HP-UX 11 aCC are supported on HP-UX 11.0
when running with HP-UX applications built using the HP aCC 
compiler version 3.05 or higher.

The ODBC drivers require certain runtime library patches. HP-UX 
patches are publicly available from the HP Web site (www.hp.com). The 
required patch is:

PHSS_14577

HP updates the patch database regularly; therefore, the patch 
numbers in this file may be superseded by newer versions. If you 
search for any of the specified patches on an HP site and receive 
a message that a patch has been superseded, download and install 
the replacement patch.


     Driver WorkAround Options

Progress DataDirect has included non-standard connection options 
(workarounds) for the drivers that enable you to take full advantage of 
packaged ODBC-enabled applications requiring non-standard or extended 
behavior.

Refer to the chapter "WorkAround Options" in the DATADIRECT CONNECT 
SERIES FOR ODBC REFERENCE for a description of these options.


     Notes, Known Problems, and Restrictions

The following are notes, known problems, or restrictions with Release 
7.1.1.

NOTE: For maximum compatibility, the version of the DataDirect Connect 
Series for ODBC drivers and the version of the DataDirect Connect Series 
for ODBC Driver Manager must match.


For Linux Users of Motif Versions Prior to 2.0.3
----------------------------------------------------
When running the Linux ODBC Administrator with versions of Motif prior 
to 2.0.3 using multi-byte locale settings, such as UTF-8, warning 
messages may appear because of a problem in Motif. These messages 
explain that certain characters are not supported in the current font. 
You may also experience problems with being unable to type values into 
some fields on tabs of the ODBC administrator. If you experience such 
problems, we recommend that you set your locale to a single-byte code 
page, such as en_US, to work around the problem. You can also upgrade 
your system to Motif 2.0.3, where this issue has been resolved.

For SSL Users
-------------
When trying to connect to a database using SSL encryption, you may 
receive an error message similar to: "PRNG not seeded". This is because 
certain versions of some operating systems do not generate truly random 
numbers necessary for encryption. For more information about this error 
and available patches, please refer to the Web site:

http://www.openssl.org/support/faq.html#USER1

On SUSE Linux Enterprise Server 10.0, attempts by the drivers to 
connect using SSL Encryption will not succeed due to a problem loading 
the SSL libraries.

SSL and the Linux ODBC Administrator
-----------------------------------
The Linux ODBC Administrator does not correctly save the encrypted 
truststore password, keystore password, and key password in the 
odbc.ini file when specifying them on the Security tab of the driver 
Setup dialog boxes. To set these connection options, you must edit the 
odbc.ini file directly and use the appropriate connection string 
attributes to store these passwords in the file. You cannot use the 
driver Setup dialog boxes. See the DATADIRECT CONNECT SERIES FOR ODBC 
USER'S GUIDE for details about the Security tabs and the odbc.ini file.

ODBC Development on UNIX and Linux Platforms
--------------------------------------------
All of the Release 7.1 Core Components (header files, etc.) needed for 
development of ODBC applications on UNIX and Linux are installed into 
the /include directory created by the product installer.

Please read the notices.txt file in the installation directory for 
licensing information regarding the ODBC Core Components. Contact your 
Progress DataDirect representative if you have any questions.

Developers using programming languages other than C++:
The DataDirect ODBC Driver Manager is a C++ shared library. The ODBC 
Driver Manager can be used with any language that supports loading a 
C++ shared library; however, if you are using a programming language 
other than C++, you must take additional steps to ensure that the C++ 
libraries are initialized properly when loaded. If you are not using 
C++, consult your compiler documentation for instructions on using C++ 
shared libraries with your application.

LANG Environment Setting on UNIX and Linux Platforms
----------------------------------------------------
A default installation of the product on UNIX and Linux assumes that 
the value of the LANG environment setting is en_US. If your locale is 
not set to en_US, the drivers may not return error messages properly. 
In this case, you must create a symbolic link in the 
<Install_Dir>/locale directory that has the same value as the LANG 
environment setting. This link must point to the 
<Install_Dir>/locale/en_US directory.

SQLColAttribute(s)
------------------
The column attributes 1001 and 1002, which were assigned as DataDirect- 
specific attributes, were inadvertently used as system attributes by
the Microsoft 3.0 ODBC implementation. Applications using those 
attributes must now use 1901 and 1902, respectively.

SQLDriverConnect
----------------
SQLDriverConnect using options other than SQL_DRIVER_NOPROMPT is 
supported only on systems that include the Motif libraries 
libivmback.so or libddmback.so and vscnctdlg.so.

SQL_C_NUMERIC
-------------
Because of inconsistencies in the ODBC specification, users attempting 
to use SQL_C_NUMERIC parameters must set the precision and scale values 
of the corresponding structure and the descriptor fields in the 
Application Parameter Descriptor.

For AIX Users
------------------------------
Some IBM AIX C compilers, such as xlc 3.1.4, do not support the use 
of C++ build binaries. C developers on AIX should consult their 
compiler documentation and verify that their AIX C compiler supports 
the use of C++ shared libraries or the application could be unstable.

Unexpected behavior may occur randomly if the LIBPATH variable 
exceeds 178 characters AND the ORACLE_HOME variable is relatively 
long. To resolve this, create a shorter symbolic link for 
ORACLE_HOME.


     Using the Online Documents

The DataDirect Connect Series for ODBC books are provided in PDF and 
HTML versions. The PDF versions are provided on the Progress DataDirect 
Web site.

You can view the PDF versions using Adobe Reader.

NOTE: To download Adobe Reader, visit the Adobe Web site at 
http://www.adobe.com.

The HTML versions of the books are installed in the help subdirectory 
of your product installation directory.


     Installed Files

Setup copies the following files and subdirectories to the product 
installation directory:

license.txt          License agreement
fixes.txt            A text file that lists the fixes since the release
NOTICES.TXT          Third-Party Acknowledgements
ODBCREADME.TXT       This file (32-bit)
ODBC64README.TXT     This file (64-bit)
PGODBC.LIC           Driver license file


/bin:

pgtestlib             Test program to check that required libraries
                      are present and loadable 

/demo:

demoodbc              Standard demo executable
demoodbc.c            Source file to the standard demo program
driver_connect        Demo executable that uses Motif SQLDriverConnect
driver_connect.cc     Source file to Motif demo program
Makefile              Make script for building the demo programs            

/example

example               Example executable
example.c             Source file for example program
example.h             Header file for example program
example.mak           Make file for example program
example.txt           Short description of the program [32-bit]
example64.txt         Short description of the application [64-bit]

/help:

help.htm              HTML help system entry file
*.css                 Stylesheets for HTML help system
*.html                HTML help system
/images/*.*           Images for HTML help system
/wwhdata/*.*          Support files for HTML help system
/wwhelp/*.*           Support files for HTML help system
prog10_connect.txt    Help text for the Progress OpenEdge Wire Protocol
                      SQLDriverConnect dialog

/include:

odbcinst.h            Include files
qesqlext.h
sql.h
sqlext.h
sqltypes.h
sqlucode.h
sqlunx.h

/lib:

The following library files have the extension, .so, except for files 
installed on HP-UX PA-RISC, which have the extension .sl.

pgoe27.so             Progress OpenEdge Wire Protocol driver
libpgicu27.so         Unicode conversion tables [.a on AIX]
libpgmback.so         SQLDriverConnect Motif library [.a on AIX] 
libodbc.so            ODBC Driver Manager [.a on AIX]
libodbcinst.so        ODBC Installer [.a on AIX]
libpgssl27.so         SSL support file [.a on AIX]
odbc.so               ODBC Driver Manager (dynamically loadable) 
                      [AIX only]
odbccurs.so           ODBC Cursor library 
odbcinst.so           ODBC Installer (dynamically loadable) 
                      [AIX only]
pgtrac27.so           ODBC Tracing library
vscnctdlg.so          ODBC library for Motif operations

/locale/en_US/LC_MESSAGES:

pgmback.mo            Motif library message file
pgmback.po            Motif library message source
pgoe27.mo             Progress OpenEdge driver message file
pgoe27.po             Progress OpenEdge driver message source
odbc.m                ODBC Driver Manager message file
odbc.po               ODBC Driver Manager message source


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

