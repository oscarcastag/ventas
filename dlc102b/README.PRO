
Progress OpenEdge 10.2B Readme

Ports: All
Date: December, 2009
--------------------------------
Copyright (c) 1984-2009 Progress Software Corporation and/or its subsidiaries or affiliates. All rights reserved.

To access third party product licenses, go to the 'licenses' directory 
located in the OpenEdge installation directory. For example, go to 
C:/OpenEdge/licenses.


Read these On-line Release Notes
================================

It is important to read these on-line release notes. They are the 
primary release notes. The hard-copy release notes supplement them, 
but do not replace them.

The on-line release notes are on the distribution medium as two
text files:

  *	readme.wri, which is for Windows platforms
  *	readme.pro, which is for UNIX platforms

These readme files have identical content that includes a list of known issues followed by a list of the issues fixed in this release. 
In addition, the distribution medium includes the following HTML report 
files which list the issues addressed in this release -  organized by version, 
issue number (CR ID), or product component.  

  * oe-<release#>-version.htm (Lists fixed issues by Version)
  * oe-<release#>-issue.htm (Lists fixed issues by Issue Number)
  * oe-<release#>-component.htm (Lists fixed issues by Component)

---------------------------------------


1.	Installation
		Install
2.	ABL
		COMPSRV
		DataType
		DLL
		Internationalization
		Language Issues
		Object-oriented ABL
		ProDataSet
		Security
		Web Services client
		Web services client
		Web Services client
		XML
3.	Adapter for Sonic ESB
		Tools
4.	Adapter for SonicMQ
		Broker Connect
5.	ADE Tools and Runtime
		Data Dictionary
		Deployment
		GUI Rendering
		Services
		Tools
		Translation Manager
		Web Rendering
6.	Auditing
		Tools
7.	Command Line Tools
8.	Database
		Database Utilities
		Failover Clusters
		RDBMS
		Security
9.	DB Nav
		Other
10.	DataServers
		DB2
		MS-SQL
		ODBC
		ORACLE
11.	Documentation
		Electronic Documentation
		Help
12.	Graphical User Interface
		ABL
		ActiveX
13.	Management
14.	Message Number Change
15.	Open Client
		.NET
		Dynamic API
		Proxygen
		Web Services Provider
16.	OpenEdge Architect
		AppBuilder Support
		Debugger
		Editing
		Project
		Visual Designer
17.	OpenEdge GUI for .NET
		.NET UI Language
		Data Binding
		Data type
18.	OpenEdge Replication
19.	Porting
20.	progress explorer
21.	Server Technology
22.	SQL
		ESQL92
		Interoperability
		Server
		SQL
		Tools
23.	Web Services Adapter
24.	Web Services Client
25.	WebClient
26.	WebSpeed
		Diagnostics
		Tools

================================================
Installation - 
================================================


Note: OE00121569    Type: Limitation
OpenEdge installation may install Sonic client and container code
---------------------------------
RN#: 101A-00291
===============
The OpenEdge installation program may install Sonic Software client and
container code depending on which products get installed. Because the
installation program requires it run as ROOT on Unix, the Sonic Software code
gets installed with those permission set. The OpenEdge installation program
attempts to set the correct permissions for the Sonic code, but this fails on
the HPUX operating system. This will cause the Sonic ESB Container created by
OpenEdge to fail when started unless it is started as ROOT. To resolve this,
run the command 'chmod -R o+w *' from $DLC/sonic as ROOT.


Note: OE00146967    Type: Known Issue
Shared Network install issue
---------------------------------
This is a Shared Network install (netsetup) issue only.  If AnswerWorks 4.0 is
already installed on a server system prior to  installing OpenEdge, the
answerworks install folder is not copied into the %DLC%\bin\3party to be
available for a shared network install, and AnswerWorks 4.0 is not installed on
a shared network client system.
To ensure that the %DLC%\bin\3party\answerworks install folder exists for a
shared network install, a user can either:
   1. Prior to installing OpenEdge, delete the "C:\Program Files\Common
Files\AnswerWorks 4.0" folder (if it exists), OR
   2. After installing OpenEdge and the %DLC%\bin\3party\answerworks install
folder does not exist, copy the  3party\answerworks folder from the CDROM into
the %DLC%\bin\3party folder.


Note: OE00163769    Type: Workaround
Unknown Publisher message with a Netsetup Install
---------------------------------
After performing a Netsetup install on Windows the user may see an Unknown
Publisher message when running any OpenEdge .EXE files from a network drive. To
resolve this issue, add the network drive share to the client's trusted zone.

To add the network drive to your trusted zone:

1. Open the Internet Options Dialog Box from an Internet Explorer session.
2. Select the Security Tab.
3. Select the Local Intranet icon from the zones shown.
4. Click the Sites command button, which opens a Local Intranet Dialog Box.
5. Click the Advanced command button, which opens a dialog box where you 
add and remove websites from your intranet.
6. Add \\servername\ to the list of websites. Click Close, then OK to return to
the main Internet Options Dialog Box.

You may have to reboot the client for this to take effect.


Note: OE00168104    Type: Known Issue
Sonic container startup shortcut requires quotes for directories with spaces
---------------------------------
If you install OpenEdge into a directory with a space in the name (e.g.
C:\Program Files\OpenEdge), the shortcut to start up the sonic container does
not function properly.	You can fix the problem by editing the shortcut and
enclosing the Target: and Start in: fields in double quotes.


Note: OE00187147    Type: Known Issue
The WebClient One-Click install fails as a Non-Admin User
---------------------------------
The WebClient One-Click install (OCI) (over-the-web install) fails when run by
a non-admin on a system that does not already have the Installshield Setup
Player installed as an Add-On.	For this to work, the add-on must already be
installed/registered by an Administrator. Running the WebClient One-Click
install as Administrator just one time will get the Setup Player installed.
After this is done the WebClient One-Click install can be run as a
Non-Administrator. This issue only occurs when installing Over-the-Web. This
issue does not occur when running the WebClient installation directly via the
setup.exe file.


================================================
Installation - Install
================================================


Note: OE00147494    Type: Known Issue
Installation of Failover Clusters -- Windows
---------------------------------
You must ensure there are no active instances of the Cluster Administrator
utility prior to installation. To do this, use the Windows Task Manager to
check for processes running the cluadmin.exe image.  If a user associated with
an instance of the Cluster Administrator is not readily identifiable, these
processes can be forcefully terminated as follows:

1.	Within Task Manager, select the cluadmin.exe process and press the End
Process button.

2.	Answer yes to the popup dialog asking if you really want to terminate
the process.

Failure to shut down all instances of the Cluster Administrator tool results in
a partial installation and fails to properly register the resource and
administrator extension DLLs, causing cluster management to fail.


Note: OE00163889    Type: Known Issue
.Net Framework not installed with unknown default language
---------------------------------
OpenEdge Architect and OpenEdge Advanced UI Controls have a dependency on the
Microsoft .NET Framework v3.0.

The OpenEdge installation media includes the English version of the Microsoft
.NET Framework, and the OpenEdge installation process will automatically
install the framework if it is not already your system, provided that your
system's locale is set to English.  

If the locale on your system is set to something other than English and the
.NET Framework 3.0 for your locale is not already installed, then OpenEdge
Architect and OpenEdge Advanced UI Controls do not install properly.  OpenEdge
will not install the English version of the .NET Framework when the system
locale is not English, and the Advanced UI controls will not install without
the .NET Framework installed.

To work around this problem, install the Microsoft .NET Framework v3.0 for your
locale, prior to installing OpenEdge.  

To download different languages of the .NET Framework 3.0 as well as the
Windows 64-bit version:
  - Login to http://www.progress.com/esd
  - Choose "Progress OpenEdge Deployment Components"
  - Choose "Microsoft .NET Framework" download page


Note: OE00165220    Type: Limitation
Windows 2003 Support requires Service Pack 2
---------------------------------
Due to a bug in the Windows Installer Program provided by Microsoft, base
support for the Windows 2003 platform is Service Pack 2 for OpenEdge Release
10.1C.


Note: OE00165583    Type: Migrated
Application fails to initialize on Windows
---------------------------------
If you get the following error using some of OE products, for example ProxyGen,
"The application failed to initialize properly ....", check to see that you
have the Microsoft .NET Framework 3.0 installed on the machine.  You can do
this by going into Control Panel -> Add/Remove Programs and looking for the
.NET Framework 3.0.  If you do not have the .NET Framework 3.0 installed, you
can install the English version from the OpenEdge cdimage by running
3party\dotnetfx\eng\dotnetfx.exe.

To download different languages of the .NET Framework 3.0 as well as the
Windows 64-bit version:
  - Login to http://www.progress.com/esd
  - Choose "Progress OpenEdge Deployment Components"
  - Choose "Microsoft .NET Framework" download page


Note: OE00174454    Type: Known Issue
Microsoft .NET Framework 3.0 must be installed manually on Windows 2008
---------------------------------
If you are installing on a Windows 2008 machine, and plan to run an application
that was built using the OpenEdge Ultra Controls for .NET, you must first
manually install the .NET Framework 3.0 prior to running the OpenEdge
installer.

To download different languages of the .NET Framework 3.0 as well as the
Windows 64-bit version:
  - Login to http://www.progress.com/esd
  - Choose "Progress OpenEdge Deployment Components"
  - Choose "Microsoft .NET Framework" download page


Note: OE00175812    Type: Known Issue
Windows 64-bit Silent Install does not work
---------------------------------
The Windows 64-bit Silent Install does not work.  To install  the Windows
64-bit OpenEdge product, you must run the install interactively. 


Note: OE00176073    Type: Known Issue
Embedded Microsoft .NET Framework will not install in a Windows 64-bit OS
---------------------------------
OpenEdge embeds a 32-bit  English version of the Microsoft .NET Framework in
the OpenEdge installer.  This 32-bit .NET Framework does not install on any
Windows 64-bit operating system.  If you require the .NET Framework (for
ProxyGen or using the OpenEdge Ultra Controls for .NET, for example), you must
first install a 64-bit version of the .NET Framework.  You must install the
64-bit .NET Framework when using either the 32-bit or 64-bit versions of
OpenEdge.

To download different languages of the .NET Framework 3.0 as well as the
Windows 64-bit version:
  - Login to http://www.progress.com/esd
  - Choose "Progress OpenEdge Deployment Components"
  - Choose "Microsoft .NET Framework" download page


Note: OE00183985    Type: Limitation
Compatibility messages displayed during OpenEdge install on Windows 7
---------------------------------
Two messages stating that the programs have known compatibility issues are
displayed during the install of all OpenEdge products on Windows 7. Both of
these issues are related to the Microsoft JVM.

After the messages are displayed, you are prompted to "Check for solutions
online, run program or cancel."  Choose "run program" and the install
successfully completes from this point.


================================================
ABL - 
================================================


Note: OE00052051    Type: Known Issue
Shared library compilation style mismatch causes memory violation
---------------------------------
Calling a function in a UNIX shared library may result in a memory violation if
that function includes a parameter of type FLOAT and the file was compiled
"Kernighan and Ritchie" style. A K&R style declaration does not include
parameter data types in the function definition. A workaround is to write the
ABL function declaration with DOUBLE, rather than FLOAT, as the parameter data
type. 

It is possible that this problem could occur with BYTE and CHAR data types, but
no problem has been seen in testing.


Note: OE00104223    Type: Known Issue
To access large objects remotely, client and server must be OpenEdge 10.0B
---------------------------------
Prior to OpenEdge Release 10.0B, LOBs could not be exchanged between a client
and a server on machines with different hardware architectures. In order to
access large objects remotely, both the client and server must be OpenEdge
10.0B or higher.  Use of prior OpenEdge versions will result in error messages
indicating a failure to update or retrieve a large object.


Note: OE00147330    Type: Behavior Change
Windows Help (.hlp) Format is not supported on Vista Platform
---------------------------------
Microsoft does not include the WinHelp executable with Vista (see
http://support.microsoft.com/kb/917607). Even though the SYSTEM-HELP statement
supports the .HLP format, this does not apply to Vista. If your OpenEdge
applications will run on the Vista platform, your help must be in .CHM format,
not .HLP format. 


Note: OE00177626    Type: Behavior Change
DECIMALS attribute for TEMP-TABLE field now returns expected value
---------------------------------
If a TEMP-TABLE DECIMAL field was defined with DECIMALS 0, the DECIMALS
attribute used to return 30, instead of 0 as expected.	It now returns the
correct value of 0.


Note: OE00179248    Type: Behavior Change
GEt CURRENT [table] NO-LOCK for a TEMP-TABLE sometimes refreshes the record
---------------------------------
Prior to OpenEdge Release 10.1C, GET-CURRENT(NO-LOCK) would not refresh a
record if it had been previously updated, because an update implies an
EXCLUSIVE-LOCK. From Release 10.1C through Release 10.2A, a TEMP-TABLE record
was sometimes refreshed incorrectly, due to a difference in certain TEMP-TABLE
assignments.  If the assignment to the TEMP-TABLE record was very simple
(ttField = x), then the lock upgrade to EXCLUSIVE-LOCK was optimized out. This
behavior has been changed, such that future releases will behave the same as
releases prior to Release 10.1C.

Note that updates to database fields, followed by GET-CURRENT(NO-LOCK), have
always worked correctly and are unaffected by this issue.


Note: OE00180844    Type: Behavior Change
Get-Signature function no longer shows -32767 for indefinite extents
---------------------------------
Prior to Release 10.2B if a signature contained a parameter with an indefinite
extent, the format used was "EXTENT -32767".  For 10.2B the format is "EXTENT".


Note: OE00192261    Type: Behavior Change
Field names now have precedence over static references
---------------------------------
For Releases 10.1C through 10.2A, field names and static references had equal
precedence. Any name collision results in a compile-time ambiguity error. For
10.2B field names have been given precedence over static references. If a name
collision occurs the field name will be chosen.


Note: OE00193780    Type: Known Issue
SUBSTRING, ENTRY, and LENGTH statements fail w/ colon syntax
---------------------------------
For the SUBSTRING, ENTRY and LENGTH statements, if the target argument is
qualified using colon syntax, the statement compiles but does nothing at run
time. This does not apply to the SUBSTRING, ENTRY, and LENGTH functions, which
work correctly.

This is true whether the qualifier is an object reference, THIS-OBJECT system
reference, a handle variable referring to an attribute, or a double-colon
reference to a table field (e.g., BUFFER buff-tt::Field1). For example, the
following has no effect on the data member "x":

SUBSTRING(THIS-OBJECT:x, 1, 1024) = "".


================================================
ABL - COMPSRV
================================================


Note: OE00106742    Type: Behavior Change
Minor r-code version change when passing LONGCHAR parameter
---------------------------------
In OpenEdge version 10.0B and higher, parameters of LONGCHAR data type are
passed by value instead of by reference, in order to provide the same behavior
as for parameters of CHARACTER data type. This change forced a minor r-code
version change for code that uses LONGCHAR parameters. R-code compiled with
version 10.0A or 10.0A01 that contains LONGCHAR parameters must be recompiled
with a version 10.0B or higher client in order to run it with a version 10.0B
or higher client or AppServer.


================================================
ABL - DataType
================================================


Note: OE00165736    Type: Behavior Change
PUT CONTROL now supports dynamic references
---------------------------------
A dynamic reference in PUT CONTROL, such as a BUFFER-FIELD-HANDLE:BUFFER-VALUE,
used to fail for data types such as RAW and LONGCHAR.  It now succeeds.


Note: OE00181699    Type: Behavior Change
Class method does not deep copy a MEMPTR internal structure return type
---------------------------------
Prior to Release 10.2A, a function or a class method returning a MEMPTR data
type would not deep copy either the MEMPTR or the internal structure used to
track the MEMPTR, up to the caller MEMPTR and caller internal structure.
Instead, the AVM would use the caller's internal structure and MEMPTR
"by-reference" implicitly.

For Release 10.2A the internal structure used to track MEMPTR memory is now
deep copied, so that a function or a class method can return a MEMPTR array to
an indeterminate target array. The internal structure that maintains the
SET-SIZE settings is now treated differently, resulting in two copies of the
internal structure--one in the called routine and one in the caller.  Note that
there is still only one copy of the MEMPTR memory itself.


================================================
ABL - DLL
================================================


Note: OE00086877    Type: Behavior Change
Support for running member of shared library on AIX
---------------------------------
AIX supports loading shared libraries that are stored in archives. For example,
/usr/lib/libc_r.a is really an archive and not a shared library. Starting in
10.2B, you must use the syntax required by AIX, with the member name in
parenthesis, to call a function in an object stored in the archive. For
example, to call the atoi() function, you must define the external library as
"/usr/lib/libc_r.a(shr.o)".


Note: OE00167888    Type: Limitation
Cannot load a relative path shared library
---------------------------------
Modern operating systems, such as Solaris, are enhancing security. This impacts
how an application can load a shared object. On these operating systems, a root
owned executable, such as the ABL client, is not allowed to load a shared
library using a relative path. If you receive an error when invoking an
external shared library from the ABL, try specifying an absolute path to the
library.


================================================
ABL - Internationalization
================================================


Note: OE00073374    Type: Known Issue
Thai (complex scripts) display in command prompt
---------------------------------
The Command Prompt or Console is not enabled for Thai (complex scripts) on any
version of Windows NT.	Progress testing proved that it is an issue also
present on Windows 2000. To be able to view Thai and complex scripts in an
MS-DOS window, you can choose to:
* Use the English promsgs when running the Windows NT or Windows 2000.
* Use the Thai (or complex script) promsgs, but pipe the output of the command
to a file that can be read using any Windows editor.


Note: OE00124868    Type: Behavior Change
EBCDIC codepages no longer provided in convmap.cp
---------------------------------
For OpenEdge 10.0A, EBCDIC codepages are not provided in convmap.cp shipped
with the product. For example, there is no codepage conversion possible from
IBM278 to ISO8859-1. 

Customers who require codepage conversions to or from EBCDIC codepages can use
the following steps to allow these conversions:

1. Uncomment "INCLUDE weuroebc.dat" in
[install-dir]/prolang/convmap/convmap.dat.
2. Rebuild convmap.dat into a new convmap.cp with the proutil utility.

proutil -C codepage-compiler <path-to-convmap.dat> <path-to-new-convmap.cp>

3. If the new convmap.cp is not in the [install-dir], make sure the PROCONV
environment variable is set to point to the location of the new convmap.cp.

EBCDIC codepages are provided only for conversion to a supported OpenEdge
codepage. The EBCDIC codepages must not be used for the AVM codepage
(-cpinternal), a CLOB codepage in a table, or as the database codepage.


Note: OE00125227    Type: Behavior Change
Pasting Unicode text into GUI widgets might require font and codepage changes
---------------------------------
For the GUI client (prowin32.exe), text widgets such as editors and fill-ins
are Unicode-enabled. If you enter characters into these widgets that are not
supported by the font in use or are not available in the -cpinternal codepage,
the widget value might contain a question mark (?). 
 
For example, if the user were to copy a quoted string from another
Unicode-enabled application, the double quotes copied might be U+201C and
U+201D, the left and right double quotation marks respectively. When copying
these into an OpenEdge editor, the quotation characters might not display
correctly in the editor, and might be converted to question mark (?) when
accessing the value of the editor. 

The default font OpenEdge uses for widgets is MS Sans Serif. MS Sans Serif does
not provide a visual representation for these quotation characters. Changing
the editor's font to Courier New instead will allow the characters to display
correctly. 

Many customers use ISO8859-1 as the -cpinternal codepage. The ISO8859-1 
codepage does not contain these quotation characters, so they will be 
converted to "?" when accessing the value of the editor. Changing -cpinternal
to 1252 instead of ISO8859-1 will allow these characters to be displayed
correctly. 

You should set your font and -cpinternal codepage according to the 
characters you will be using in your application. 

Prior to OE10, the GUI client used ANSI widgets. If non-ANSI characters 
were pasted to ANSI widgets, Windows would provide a conversion from 
these characters to ANSI characters. The characters were visually 
similar, but not the same.


================================================
ABL - Language Issues
================================================


Note: OE00147609    Type: Known Issue
CAN-FIND X field-list problem
---------------------------------
The FIELDS clause does not guarantee the inclusion or exclusion of fields in
any given query.  The AVM may require additional fields, for example, to
accommodate a key value required by an index. 

The application must not reference fields that are missing from the FIELDS
list. In most cases when this occurs a run-time error is generated indicating
that the field is unavailable.	

There are situations, for example with a function that includes the NO-ERROR
attribute by default, where it is legitimate to satisfy function requirements
using a field that is missing from the FIELDS list.  Such instances equate the
missing field to the Unknown value (?) or null (for DataServers) in order to
resolve an expression. In other words, the ABL attempts to detect missing
fields with run-time errors where possible. However, there are cases where it
is legitimate to use a missing field in an expression.	In such cases, the
missing field will resolve to the Unknown value (?) or native data source null.


Note: OE00147611    Type: Known Issue
Incompatibility between 32-bit r-code and 64-bit r-code
---------------------------------
For OpenEdge Release 10.1A, 32-bit r-code only runs with the 32-bit product,
and 64-bit r-code only runs with the 64-bit product. This change provides
performance benefits for the 64-bit product, such as very large memory.
However, it breaks the portability of r-code between 32-bit and 64-bit
platforms. If portability between platforms is more important than 64-bit
performance, you can use the Release 10.1A 32-bit product, which can run
Release 10.0x 32-bit and 64-bit generated r-code as well as Release 10.1A
32-bit generated r-code. The Release 10.1A 32-bit product can be installed and
run on 64-bit hardware, but you will not see the performance benefits of the
64-bit product. For more  information about this change, see the "OpenEdge
Getting Started: New and Revised Features" 
and "OpenEdge Deployment: Managing 4GL Applications" manuals.


Note: OE00147775    Type: Known Issue
Dynamic query with a RECID in a WHERE clause fails 10.1A client to 10.1B server
---------------------------------
A dynamic query with a RECID in the WHERE clause from a 10.1A client and a
10.1B or greater server will fail. This is due to the fact that 10.1B RECIDs
are 64-bit, but 10.1A and prior version RECIDs are 32-bit. This is only a
problem with RECIDs, which have been deprecated. A workaround is to use ROWID
or the buffer method FIND-BY-ROWID.


Note: OE00147778    Type: Limitation
INT64 ActiveX support requires oleaut32.dll version 5.1.2600.2180 or later
---------------------------------
To support the INT64 data type with ActiveX controls or ActiveX Automation
objects, C:\windows\system32\oleaut32.dll must be version 5.1.2600.2180 or
later. If your application uses an earlier version of oleaut32.dll and a
parameter of INT64 data type is passed to a COM object, the results are
unpredictable and may result in an error.  This is true even if it is an input
parameter and the number in the variable is within the 32-bit range. 
Therefore, if you do not have the correct version of oleaut32.dll, you should
not use the INT64 data type with COM objects.


Note: OE00177422    Type: Behavior Change
Unnecessary STRING references removed in the XREF file
---------------------------------
Prior to Release 10.2B, the XREF file optionally produced by the COMPILE
statement may contain unnecessary STRING references toward the end of the file.
These references are for index names used to resolve queries in the program
being compiled. For 10.2B these STRING references are not written to the XREF
file.


Note: OE00190994    Type: Behavior Change
Structured error handling no longer suppresses warning messages
---------------------------------
When an ABL code block uses structured error handling, in which the block has
either a CATCH block associated with it or has an ON ERROR, UNDO THROW clause,
all system messages generated in the block are automatically placed in a
Progress.Lang.ProError object. 

If the system message is an error message, a Progress.Lang.ProError is thrown.
If the system message is a warning message, no Progress.Lang.ProError is
thrown, but the warning message is not immediately seen. Instead, the warning
message is eventually passed up to the enclosing ABL block for handling, which
can result in the warning message being displayed at the end of the block. If
the enclosing ABL block uses structured error handling, the warning message is
further delayed. For Release 10.2B this behavior has changed such that the AVM
immediately outputs the warning message, and does not put it in a
Progress.Lang.ProError object.


================================================
ABL - Object-oriented ABL
================================================


Note: OE00154242    Type: Behavior Change
Built-in ABL class properties implemented internally as properties
---------------------------------
Prior to OpenEdge 10.2A, properties of built-in ABL classes were implemented as
variable data members. For 10.2A the implementation has been changed to that of
a property. This change has no visible affect on user-defined classes. 

Classes compiled with version 10.1C or later result in r-code that is
incompatible with the pre-10.1C client. If you run r-code for a class compiled
with 10.1C or later and try to run it with a pre-10.1C client, the following
error is generated:

"'Next-Sibling' of class'Progress.Lang.Object' using object of type <class
name> - compilation is out of date (12882) ".


Note: OE00167806    Type: Behavior Change
STATIC positioning for OOABL data members has been relaxed
---------------------------------
Prior to Release 10.2B, the position of the STATIC access modifier for the
DEFINE VARIABLE, the DEFINE BUFFER, the DEFINE TEMP-TABLE, the DEFINE QUERY,
the DEFINE DATASET, and the DEFINE DATA-SOURCE statements was required to
appear between the [ PUBLIC | PROTECTED | PRIVATE ] access modifier and the
defined type. For 10.2B these can appear in either order, for example PROTECTED
STATIC or STATIC PROTECTED.


Note: OE00178012    Type: Behavior Change
GetClass() method for .NET object-reference
---------------------------------
For Release 10.2B, the GetClass() method supports reflection in .NET classes.
The GetClass() method returns the object reference for a Progress.Lang.Class
object if the current object is valid and is an instance of a .NET class. For
example: 

DEFINE VARIABLE dotnetobj AS System.Text.StringBuilder NO-UNDO.
DEFINE VARIABLE myclass   AS Progress.Lang.Class       NO-UNDO.

dotnetobj = NEW System.Text.StringBuilder().

/* For 10.2B the following invocation of dotnetobj:GetClass() returns
   a valid Progress.Lang.Class object instead of the Unknown value (?) */
myclass = dotnetobj:GetClass().


Note: OE00184960    Type: Behavior Change
Progress.Lang.Class:GetClass() method returns an error with message on failure
---------------------------------
For Release 10.2B the Progress.Lang.Class:GetClass() method generates an error
message and raises error when it fails.  Prior to 10.2B the method failed
quietly, returning the Unknown value (?).


Note: OE00186350    Type: Behavior Change
Subscribing non-VOID method handler to class event now causes compiler error
---------------------------------
Beginning with OpenEdge Release 10.2B, attempting to subscribe a non-VOID
method as a handler for a class event generates the following compiler error:
"Event handler '%s' returns type '%s', but must be VOID for Subscribe (15630)"

In previous releases, ABL does not catch this error at compile time, but raises
a run-time error instead.


Note: OE00188267    Type: Behavior Change
Changes to INVOKE entry in XREF output
---------------------------------
Prior to Release 10.2A02, if a call was made to a method in the class where it
was defined, and the method had a TABLE or DATASET parameter, the INVOKE entry
for the call in XREF output (COMPILE statement) might omit the name of the
table or ProDataSet. For Release 10.2A02 the entry includes the name.

For Release 10.2B, the INVOKE entry for a method call with a BUFFER parameter
in XREF output includes the word "BUFFER" before the name.


Note: OE00190039    Type: Behavior Change
XREF output now uses SUBSCRIBE instead of INVOKE for subscribing to .NET event
---------------------------------
For Release 10.2B, XREF output includes a SUBSCRIBE or UNSUBSCRIBE entry for
each Subscribe or Unsubscribe of a .NET event. Prior to 10.2B, XREF used INVOKE
entries in these cases, with the name of the invoked method shown as 
"_psc_Subscribe_NET" (and variations on the name for Unsubscribe and for
operations on static .NET events). These INVOKE entries are no longer included.


Note: OE00190605    Type: Behavior Change
OVERRIDE with mismatched EXTENT raises compile-time error
---------------------------------
If you attempt to override a method and the extents do not match, the AVM
generates a compile-time error that the OVERRIDE signatures do not match. Prior
to Release 10.2B this would compile, but lead to inconsistent run-time
behaviour.


Note: OE00190729    Type: Behavior Change
STATIC PROTECTED temp-tables and ProDataSets behave differently
---------------------------------
In Release 10.2B, a STATIC PROTECTED temp-table or ProDataSet behaves
differently when used in a static hierarchy as a receiving BY-REFERENCE
parameter.  Prior to 10.2B the parameter data in the table or ProDataSet was
not propagated around the whole STATIC hierarchy, leaving an inconsistency in
what some parts of the STATIC hierarchy were seeing. With this change the whole
STATIC hierarchy sees the same data. This is similar to what happens when a
static variable is changed and the whole hierarchy sees that change.

PROTECTED STATIC tables or ProDataSets near the top of a large STATIC hierarchy
will be slower than normal when used with BY-REFERENCE parameters, because of
the need to get the whole STATIC hierarchy looking at the same table(s).

It is no longer valid to pass a BY-REFERENCE table or ProDataSet parameter
where the target table or dataset is STATIC, unless the method being called is
also STATIC.  This did not work properly prior to Release 10.2B.

Because BY-REFERENCE only applies to a single instance, the propagation of
STATIC by-reference data extends only to the STATIC instance hierarchy and not
to any related, non-static instance hierarchies.


Note: OE00191456    Type: Behavior Change
STATIC methods no longer can have non-STATIC table and ProDataSet parameters
---------------------------------
Prior to Release 10.2B a STATIC method would incorrectly compile even though it
defined non-STATIC tables or ProDataSets as parameters. At run time the data
would have been totally missing from the table or ProDataSet parameter. For
10.2B, attempting to define a STATIC method with non-STATIC table or ProDataSet
parameters causes the ABL compiler to generate an error.


Note: OE00193897    Type: Known Issue
Error handling in a constructor may require a re-compile
---------------------------------
When an error occurs inside a class constructor, the object should fail to be
instantiated. If an error occurs in a constructor for Release 10.2B, it may be
thrown to the caller (a descendant in a multi-level class) and handled there.
The object may then be successfully instantiated. Prior to 10.2B the object was
not instantiated and the error was thrown all the way out to the NEW statement
or function.

To get the former, correct behavior, you must re-compile the class using 10.2B.
This problem manifests itself only if you are running r-code compiled by an
earlier release of the product.


================================================
ABL - ProDataSet
================================================


Note: OE00177805    Type: Behavior Change
Miscellaneous ProDataSet object changes
---------------------------------
The following ProDataSet object changes were made for OpenEdge Release 10.2B:

1. The requirement for source and target temp-tables to be named differently in
several methods has been relaxed

When executing some methods for temp-tables and ProDataSets, you can get
message 12750:

Cannot generate automatic FIND for REPLACE, etc. when the source and target
tables have the same buffer name <name>. (12750)

This error message has been removed from the following methods:
- Dataset-handle:GET-CHANGES() in get-parent-mode 
- Dataset-handle:MERGE-CHANGES()
- Buffer-handle:MERGE-CHANGES()
- Buffer-handle:MERGE-ROW-CHANGES()
- Dataset-handle:COPY-DATASET() in replace-mode
- Temp-table-handle:COPY-TEMP-TABLE() in replace-mode

2. Temp-table-handle:NAME is writeable

3. COPY-DATASET() and COPY-TEMP-TABLE() now preserve ORIGIN-HANDLE

When COPY-DATASET() and COPY-TEMP-TABLE() are copying a temp-table, they used
to only copy the ORIGIN-HANDLE attribute from the source to the target if the
source had before-table records. Now they will copy the ORIGIN-HANDLE in all
cases.

4. BEFORE-ROW-FILL event runs after the replace-mode FILL has retrieved the
existing row, instead of before

During FILL, if the table being processed has FILL-MODE = 'replace', then the
AVM attempts to get any existing dataset  row copied into the current
still-empty row of the target ProDataSet table. Previously, the AVM ran the
BEFORE-ROW-FILL event handler (if any) before this occurred.  The problem with
that is that during the event handler, SELF is set to the buffer of that
current row. If the event handler runs before the replaced row is copied, then
SELF has nothing to look at, since the buffer is still empty.  If the event
handler runs after the replaced row is copied, then the SELF buffer is
populated with the old existing record and the BEFORE-ROW-FILL event handler
has something more useful than an empty buffer to work with.


Note: OE00188709    Type: Behavior Change
Setting XML-NODE-NAME to the Unknown Value (?) is now supported
---------------------------------
Prior to Release 10.2B, setting the XML-NODE-NAME attribute to the Unknown
value (?) resulted in the following error: 

"**Unable to assign UNKNOWN value to attribute XML-NODE-NAME on <object>
widget. (4083)".  

The AVM now resets XML-NODE-NAME to the actual name of the ProDataSet,
TEMP-TABLE, or TEMP-TABLE field without raising error.


================================================
ABL - Security
================================================


Note: OE00186732    Type: Behavior Change
SECURITY-POLICY:SET-CLIENT() no longer overrides database user-id
---------------------------------
Prior to Release 10.2B the SECURITY-POLICY:SET-CLIENT() method overrides
explicitly set database user-ids. For example, if your database identity had
been established:

- Using -U and -P startup parameters from the command line or the CONNECT
statement, the SET-CLIENT method overrides these

- Using the SET-DB-CLIENT ABL function with no database connect number or
logical database name, the SET-CLIENT method overrides these identities

For Release 10.2B both of these cases have been fixed such that explicitly set
database user-ids are not overridden.


================================================
ABL - Web Services client
================================================


Note: OE00147860    Type: Known Issue
Xmethods Web services used for demonstration in samples
---------------------------------
This product and accompanying documentation contain references to the Weather -
Temperature and StockQuotes XMethods Demo services provided by XMethods, Inc.
(www.xmethods.net). Copyright 2003 XMethods, Inc.  All rights reserved. Any use
of these services by you shall be for demonstration purposes only.


================================================
ABL - Web services client
================================================


Note: OE00147863    Type: Limitation
Solaris 9 requires a patch for web service clients to work properly
---------------------------------
The web service consumer may require a patch on Solaris 9.		       
					       
	 
If, when calling a Web service from OpenEdge you receive an error similar to: 
Could not open Dynamic Library: 	       

    /usr1/stat/progress/101b/dlc/lib/libprosoap.so (8013) 
    DLL Error : ld.so.1: /usr1/stat/progress/101b/dlc/bin/_progres: fatal:  
    libm.so.1: version `SUNW_1.1.1' not found (required by file 	    
   /usr1/stat/progress/101b/dlc/lib/libprosoap.so) (8014)		       
   SOAP processor initialization error. Could not load prosoap.dll or	    
   libprosoap.so (11457)						   

You will need to apply a Sun Solaris patch 111722-04. This updates the C math
library (libm.so).


================================================
ABL - Web Services client
================================================


Note: OE00149139    Type: Behavior Change
Error creating SOAP Call parameter
---------------------------------
Under certain circumstances related to XML Schema definitions appearing in the
web service description, the following message is received when an ABL
procedure calls a web service:

Error creating SOAP Call parameter: The requested 'WASP_DII_String' C++ type
for the {http://www.qas.com/web-2005-02}EngineType XML type cannot be
instantiated. Mapping to 'PSCAnyType' was found. (11797)

If a SOAP parameter is defined as a complex data type and contains a simple
value with attributes, the AVM ignores the attribute definition and treats the
parameter as a simple type. For example, while 

<element>value</element> 

is a simple XML data value, 

<element att='val'>value</element> 

is considered a complex value.

In 10.2B the form of complex value is correctly treated as complex.


Note: OE00165645    Type: Behavior Change
Empty numeric parameter and array elements cause error
---------------------------------
Sometimes you must use a CHARACTER, LONGCHAR, CHARACTER EXTENT, or LONGCHAR
EXTENT variable as an input parameter to a Web service where that parameter is
defined as an XML numeric type or an array of numeric values. Examples of XML
numeric types are integer, float, and decimal.

Prior to Release 10.2B, if the string (or an element of the extent) is not
initialized when passed to the Web service, you receive the following error:

"Invalid 4GL longchar value for XML type float (11788)"

The issue has been fixed for 10.2B.


Note: OE00174178    Type: Behavior Change
Incorrect SOAP Request sent with complex input parameter
---------------------------------
When calling a Web service operation with two parameters, one input LONGCHAR
and one output LONGCHAR, an incorrect SOAP request could be sent.

This problem occurred when the SOAP messages used the Wrapped Document/Literal
convention and the input parameter was a complex value. An input parameter that
is a complex value must be sent as a text value containing XML.

The incorrect SOAP message might look something like the following. Note the
second, nested, occurrence of the parameter element:

<soap:Body>
    <request>
	<parameter>
	    <parameter>testing</parameter>
	</parameter>
    </request>
</soap:Body>

The message should look something like the following:

<soap:Body>
    <request>
	<parameter>testing</parameter>
    </request>
</soap:Body>

This problem has been fixed.


Note: OE00190989    Type: Limitation
Web Services client crashes with an invalid SOAP request header
---------------------------------
Prior to Release 10.2B, if an invalid XML document is passed as an argument to
the SET-SERIALIZED( ) method on the SOAP-header-entryref object handle, the AVM
crashes. This issue has been fixed for 10.2B.


================================================
ABL - XML
================================================


Note: OE00171318    Type: Behavior Change
WRITE-XML serializes temp-table rows with all fields as attributes differently
---------------------------------
If you have a temp-table with all fields having XML-NODE-TYPE="Attribute", and
the temp-table row is not the parent in a NESTED DATA-RELATION, the XML
serialization for the row will be slightly different. This change provides XML
more compatible with validation tools.

Before this release, the resulting XML is a set of open and closed tags with no
content:

  <ttRow field1="val1" field2="val2">
  </ttRow>

Now, the result is a single empty tag:

 <ttRow field1="val1" field2="val2" />


Note: OE00176229    Type: Known Issue
LONGCHAR codepage ignored during XML parse
---------------------------------
If you load an XML document encoded in one code page into a LONGCHAR set to a
different codepage it's possible to corrupt the content of the XML document.
Attempts to parse, then save the XML document may then fail.

To work around this either set the encoding in the xml and the codepage for the
longchar to match -cpinternal.


Note: OE00178945    Type: Behavior Change
XML-NODE-NAME support in WRITE-XMLSCHEMA when min-xmlschema = TRUE
---------------------------------
Prior to Release 10.2B, when the min-xmlschema argument on the
WRITE-XMLSCHEMA() method for a ProDataSet or TEMP-TABLE is TRUE, and
XML-NODE-NAME is defined for a ProDataSet, TEMP-TABLE, or TEMP-TABLE field, the
actual object names are not written to the XML Schema.	For 10.2B this
information is included in the XML Schema for the object.


Note: OE00182485    Type: Behavior Change
X-DOCUMENT:SAVE( ) declares namespaces
---------------------------------
X-DOCUMENT:SAVE( ) creates an XML document by walking the DOM tree and writing
it to the target. This approach may generate invalid XML, related to namespace
declarations. 

A DOM tree can be built using namespaces by way of the
X-DOCUMENT:CREATE-NODE-NAMESPACE( ) method, for example:

hDoc:CREATE-NODE-NAMESPACE(hRoot, "urn:ns1", "prefix1:root", "element").
hDoc:APPEND-CHILD(hRoot).
hDoc:CREATE-NODE-NAMESPACE(hChild, "urn:ns2", "prefix2:child", "element").
hRoot:APPEND-CHILD(hChild).

There is no need to explicitly declare each namespace. Each node contains that
information. 
However, a hDoc:SAVE( ) results in the following document:

<prefix1:root>
  <prefix2:child/>
</prefix1:root>

This document is not well-formed, because it uses undeclared prefixes. The
well-formed version looks like this:

<prerix1:root xmlns:prefix1="urn:ns1">
  <prefix2:child xmlns:prefix2="urn:ns2"/>
</prefix1>

For Release 10.2B X-DOCUMENT:SAVE( ) includes the required namespace
declarations.


Note: OE00191182    Type: Known Issue
X-DOCUMENT:SAVE to LONGCHAR fails silently
---------------------------------
When the SAVE method of the X-document handle fails to save to a LONGCHAR
variable, no error is indicated:  the method returns TRUE, the
ERROR-STATUS:ERROR is FALSE, and ERROR-STATUS:NUM-MESSAGES is 0 after the
method completes. However, the LONGCHAR variable contains no data; its length
is zero bytes.. 

You can work around this issue by checking the LONGCHAR variable for a length
of zero bytes to determine whether the save is successful.


================================================
Adapter for Sonic ESB - 
================================================


Note: OE00176052    Type: Limitation
OpenEdge Adapter for Sonic ESB requires Java 1.5
---------------------------------
The OpenEdge Adapter for Sonic ESB uses features found in Java 1.5 and will not
run on earlier JVMs. On Windows, Sonic ESB installs and uses IBM's Java 1.4
JVM, even if you specify a Java 1.5 JVM during install. This causes failures
when starting a container containing the OpenEdge Adapter for Sonic ESB. To fix
this situation, you need to ensure your Sonic Domain Manager is using Java 1.5
by editting the SONIC_HOME/MQ7.x/bin/setenv.bat file, where SONIC_HOME is the
root directory of your Sonic install, and MQ7.x is either MQ7.5 or MQ7.6
depending on the version of Sonic you are running. If you open this files, you
will see the following environment variables defined:

rem Path to Java executables
set SONICMQ_JRE=C:\Progress\Sonic7.5.1-10.1C\MQ7.5\ibmjre14-win32\bin\java.exe
set
SONICMQ_JREW=C:\Progress\Sonic7.5.1-10.1C\MQ7.5\ibmjre14-win32\bin\javaw.exe
set MGMTCONSOLE_JRE=C:\Progress\Sonic7.5.1-10.1C\MQ7.5\jre15-win32\bin\java.exe


Modify SONICMQ_JRE and SONICMQ_JREW to be the same as MGMTCONSOLE_JRE, and your
Sonic installation will use the Java 1.5 JVM you specified at install time.


Note: OE00192621    Type: Limitation
Agents remain locked when ESB Adapter returns a Fault in Sonic Workbench
---------------------------------
When using the OpenEdge Adapter for Sonic ESB with a session-free AppServer and
persistent procedures, it is important that you release the persistent
procedure when your ESB process completes, to prevent having a locked agent. 

When the adapter returns a fault, you must ensure the Release operation is done
in your Fault process. This requires you to keep track of your process ID and
have access to it in your Fault process.

In the OpenEdge Architect/Sonic Workbench development environment, Sonic
intercepts all fault returns so that it can display the result.  Consequently,
Fault processes are never run. Setting the Command Parameter ESB Fault Return
Mode to "Continue Process with Fault"  discards the original message where your
Procedure ID is stored, so this is not a viable solution.

To free up locked agents on the AppServer, you must restart your development
container.

Using Persistent Procedures within Sonic ESB processes is discouraged because
it greatly complicates the handling of Faults and makes your session-free
AppServer operate no differently than a session-managed AppServer.


================================================
Adapter for Sonic ESB - Tools
================================================


Note: OE00159087    Type: Limitation
Sonic Workbench 7.5 doesn't know about .esboe invocation files
---------------------------------
Sonic Workbench 7.5 was released before support for the OpenEdge Adapter for
Sonic ESB using the Native Invocation method was available. Sonic has released
a 7.5.1 service pack that contains support for the Native Invocation .esboe
files as well as bug fixes.  Progress Software Corporation recommends that you
apply this service pack to your Sonic installation. If installing the service
pack is not possible, you can perform the following steps to configure Sonic
Workbench to recognize esboe invocation files.

From Sonic Workbench:

1. Select Window->Preferences
2. Select General->Content Types from the tree view control
3. Select ESB Command Content Type in the Content Types window
4. Select the Add button and add a new file type for *.esboe

If you already see an entry for *.esboe, then you are using Sonic 7.5.1 or
later and you do not need to do anything.


================================================
Adapter for SonicMQ - Broker Connect
================================================


Note: OE00186235    Type: Product Notice
The bundled Sonic client is updated to 7.5.2
---------------------------------
The Sonic client bundled with OpenEdge is updated to version 7.5.2.


================================================
ADE Tools and Runtime - 
================================================


Note: OE00108492    Type: Behavior Change
Generic comment deletion code removed from triggers
---------------------------------
Deletion triggers have been updated to not generically remove comments,
security allocation and multi-media records due to performance impact. A new
ERWin trigger template db/af/erw/afercustrg.i has been provided that customers
can use to re-generate their own triggers without the generic deletion code.
Customers can also update their triggers with specific code to do the deletion
in such a specific way that should not have any performance impact.


Note: OE00169682    Type: Known Issue
SlickEdit Product Notice
---------------------------------
OpenEdge Studio and WebSpeed Workshop include software SlickEdit (c) 1998-2004
SlickEdit Inc.	All rights reserved.  CONFIDENTIAL AND PROPRIETARY.  SLICKEDIT
and VISUAL SLICKEDIT are trademarks of SlickEdit Inc.  The VISUAL SLICKEDIT
software product and related copyrights and trademarks are under license from
SlickEdit Inc.


================================================
ADE Tools and Runtime - Data Dictionary
================================================


Note: OE00126947    Type: Behavior Change
Mandatory fields are not marked as NOT NULL during protoodbc
---------------------------------
When running a pro-to-odbc migration against a DB2 data source, fields marked
as "mandatory" in the OpenEdge database were being created in generated SQL
script and the foreign data source without the NOT NULL syntax.  This leads to
a situation where these fields are null capable in the foreign database.  

To make DB2 consistent with the MS SQL Server and Oracle DataServers, the
OpenEdge DataServer for ODBC will now set the NOT NULL constraint on SQL
columns derived from mandatory fields for DB2 data sources.


Note: OE00167056    Type: Behavior Change
Migration of cyclic sequences through OpenEdge DB-to-Oracle utility
---------------------------------
The OpenEdge DB-to-Oracle utility generated an incorrect .sql for a cyclic
sequence. The utility added the START WITH clause with the sequence's initial
value, instead of a value based on the sequence's current value. 
The utility now generates the SQL statement based on the current value of the
sequence.


Note: OE00168857    Type: Known Issue
Initial value rules for logical fields in the GUI Dictionary
---------------------------------
By default, when you create a logical field through the GUI Data Dictionary, it
sets the Initial Value as the first value in the Format. For example, if the
Format is "male/female", the Initial value defaults to male. The exception to
the first item rule is when the format is "yes/no" or "true/false". For those
cases, the tool uses the OpenEdge default value for a logical field, "no" and
"false", respectively.


Note: OE00177721    Type: Behavior Change
RECID Support in ODBC DataServers
---------------------------------
In releases prior to 10.2B, the Data Dictionary migration utility for the ODBC
DataServer does not provide complete RECID support. The migration dialog has a
toggle-box labeled "Create 4GL Compatible Objects" that is only enabled if the
"Foreign DBMS Type" field is set to "Sybase". Selecting this option adds the
RECID field to the table definition in the foreign schema.

The OE 10.2B release enhances this utility to provide RECID support in the ODBC
DataServer, specifically for DB2/400 data-sources. To align the ODBC DataServer
with other DataServers, the toggle-box is now labeled "Create RECID Column" and
is enabled for both Sybase and DB2/400 foreign DBMS types. The toggle-box is
checked by default when the DBMS type is Sybase, but it is unchecked for
DB2/400 to preserve existing default behavior.

The migration dialog also has a new radio-set under the "Create RECID Column"
toggle-box with the options: "All Tables" and "Tables Without Unique Key". The
radio-set is enabled if "Create RECID Column" is checked and the DBMS type is
"DB2/400". By default, the "Tables Without Unique Key" option is selected. For
DB2/400 data sources, RECID is implemented using IDENTITY columns.

If the user selects the "Create RECID Column" toggle-box and leaves the
radio-set selected to Tables Without Unique Key", the migration utility creates
an additional PROGRESS_RECID column, as well as a unique INDEX on that column
for all tables that do not already contain a unique key constraint. This new
index is used for RECID support. If the user changes the radio-set selection to
"All Tables", the new PROGRESS_RECID column (and index) is added to all table
definitions. Users should be aware that selecting this option might result in a
change of behavior when the table already has a unique index on it.


Note: OE00177726    Type: Behavior Change
DROP TABLE statements in .sql generated during migration using ODBC DataServers
---------------------------------
This is done to mainatin conformity with Oracle and MSS DataServers. 
Prior to Release 10.2A02, users had to manually delete the tables in the
foreign data source before a protoodb migration to ensure that the tables and
associated objects are created properly. In OpenEdge Releases 10.2B and
10.2A02, all existing tables on the foreign data source which have the same
name as the OpenEdge tables being pushed ,will be deleted and DROP TABLE
statements will be present in the .sql file generated during migration. 


Note: OE00178256    Type: Behavior Change
Default Collection/Library name gets populated with iSeries native driver
---------------------------------
This pertains to populating the default 'Collection/Library' name when using
the 'OpenEdge to ODBC Conversion' utility, specifically for DB2/400 data
sources using a DSN created with iSeries Access for Windows driver.

If no entry is specified under 'SQL default library' in the DSN, the user id
will be considered as the default Collection/Library.

If a collection is specified under 'SQL default library' and 'Library list' is
empty or provided, then the first space or comma-separated name (excluding the
space/comma character) from 'SQL default library' will be displayed as the
default Collection/Library. 

If no collection is specified under 'SQL default library' and one or list of
collection(s) is specified under 'Library list', then the first space or
comma-separated name (excluding the space/comma character) from 'Library list'
list will be displayed as the default Collection/Library.

This behavior change will be visible in 10.2B for gui as well as tty client
using iSeries driver. 


================================================
ADE Tools and Runtime - Deployment
================================================


Note: OE00088123    Type: Known Issue
Notes on using the Deploy Static Objects tool
---------------------------------
When deploying static objects using the Deploy Static Objects tool, please note
the following:

1) You must specify the following extra directories in the Deploy Static
Objects tool, in order for a standard Progress Dynamics WebClient install to
work:
    adeicon 
    ry/img
    adm2/image	

adeicon.pl can be used instead of the adeicon directory, but you must manually
copy this file into the target directory. These image directories are not
required for a server install (AppServer of Web).

2) You must manually copy the adm2/dyntreew.wrx file into the target directory,
for WebClient installs.

3) You must manually copy adecomm.pl into the target directory for a WebClient
install.


Note: OE00116351    Type: Behavior Change
Static Object Deployment Tool - Option to generate source listing
---------------------------------
The Deploy Static Objects tool has the ability to produce a listing file of all
the files that are packaged into a deployment produced by the tool. 

The listing file is specified in the UI before the deployment starts building.
If no listing file is specified, then the listing will not be produced. A
default value is provided by the tool, and is for a file called 'listing.log'
in the session's temporary directory.

The listing file consists of the following fields, tab-delimited:
File name
Relative path
Deployment type
Design-only flag

This functionality can be used to determine which files are required for
compilation on 64-bit platforms. A Dynamics client is only supported on
Windows, which is a 32-bit platform, and customers may connect to an AppServer
running on a 64-bit platform; in such a case the code would need to be compiled
against the 64-bit platform, and the listing file will give the ability to
determine which files are required.


Note: OE00132914    Type: Behavior Change
DCU enforces MinVersion with migrations
---------------------------------
If a setup XML file has migration setup types (defined by having a
migration_source_branch session property with a non-blank value), then a check
is performed to ensure that the DB version sequence matches that of the
MinimumVersion in the Database node of the setup_type. If these 2 versions
don't match an error is raised and a message shown.

This message is a new message and has a code of 'MSG_cannot_migrate', and
appears in the shipped setup101B.xml. If customers have created their own
setup.xml files, they need to add this message to all the setup types contained
in those XML files.


Note: OE00177976    Type: Product Notice
Migrating Progress Dynamics to Release 10.2B
---------------------------------
Migrating Progress Dynamics to Release 10.2B:
-------------------------------------------
Before attempting any migration, convert the physical database to Release
10.2B, using the proutil command. PSC recommends making a backup at this time.

Before migrating to Release 10.2B, Progress Dynamics customers currently using
Version 2.1B must upgrade to Version 2.1B02. The following steps are the only
supported path to migrate a Version 2.1B Repository to OpenEdge 10.2B:
- Ensure the Repository is upgraded to Version 2.1B02 (db version: 020030). The
migration does not work properly on earlier versions of the Repository.
- Create a new shortcut for the Dynamics Configuration Utility (DCU), based on
the existing shortcut from the install.
- Modify the -icfparam parameter in the target. Change
DCUSETUPTYPE=ProgressSetup to DCUSETUPTYPE=Migrate21Setup.  
- Running the DCU from this shortcut upgrades the Repository from Version
2.1B02 to Release 10.2B.


To migrate from Release 10.0B05 to Release 10.2B, follow these steps:
- Ensure the Repository is upgraded to Release 10.0B05 (db version: 100005).
The migration does not work properly on earlier versions of the Repository.
- Create a new shortcut for the Dynamics Configuration Utility (DCU), based on
the existing shortcut from the install.
- Modify the -icfparam parameter in the target. Change
DCUSETUPTYPE=ProgressSetup to DCUSETUPTYPE=Migrate100Setup.  
- Running the DCU from this shortcut upgrades the Repository from Release
10.0B05 to Release 10.2B.


To migrate from Release 10.1A02 to Release 10.2B, follow these steps:
- Ensure the Repository is upgraded to Release 10.1A02 (db version: 101002).
The migration does not work properly on earlier versions of the Repository.
- Create a new shortcut for the Dynamics Configuration Utility (DCU), based on
the existing shortcut from the install.
- Modify the -icfparam parameter in the target. Change
DCUSETUPTYPE=ProgressSetup to DCUSETUPTYPE=Migrate101ASetup.  
- Running the DCU from this shortcut upgrades the Repository from Release
10.1A02 to Release 10.2B.


To migrate from Release 10.1B03 to Release 10.2B, follow these steps:
- Ensure the Repository is upgraded to Release 10.1B03 (db version: 101101).
The migration does not work properly on earlier versions of the Repository.
- Create a new shortcut for the Dynamics Configuration Utility (DCU), based on
the existing shortcut from the install.
- Modify the -icfparam parameter in the target. Change
DCUSETUPTYPE=ProgressSetup to DCUSETUPTYPE=Migrate101BSetup.  
- Running the DCU from this shortcut upgrades the Repository from Release
10.1B03 to Release 10.2B.

To migrate from Release 10.1C to Release 10.2B, follow these steps:
- Ensure the Repository is upgraded to Release 10.1C (db version: 101201). The
migration does not work properly on earlier versions of the Repository. The
migration will also work for service packs 1 and 2.
- Create a new shortcut for the Dynamics Configuration Utility (DCU), based on
the existing shortcut from the install.
- Modify the -icfparam parameter in the target. Change
DCUSETUPTYPE=ProgressSetup to DCUSETUPTYPE=Migrate101CSetup.  
- Running the DCU from this shortcut upgrades the Repository from Release 10.1C
to Release 10.2B.


To migrate from Release 10.2A to Release 10.2B, follow these steps:
- There were no updates made to the Repository between 10.2A and 10.2B, and so
no migration is necessary.


================================================
ADE Tools and Runtime - GUI Rendering
================================================


Note: OE00020074    Type: Limitation
Print Preview and Export to Excel do not work when the data source is an SBO
---------------------------------
Print Preview and Export to Excel options available on various browse	  
toolbars are not supported for visual objects whose data sources are	      
SmartBusinessObjects. These options will do nothing when chosen.


Note: OE00024747    Type: Limitation
Static data objects do not get initial value from Repository
---------------------------------
Static SDO proxies (<sdo>_cl) do not get the INITIAL-VALUE from the
Repository's EntityField DefaultValue at run time. The temp-table's
INITIAL-VALUE attribute is a read-only attribute that is compiled into the SDO
temp-table definition from the SDO include.


Note: OE00059495    Type: Behavior Change
RowObjUpd.ChangedFields is obsolete
---------------------------------
Prior to Version 10.0A, the RowObjUpd.ChangedFields field was used to figure
out which fields to save in an SDO. This is now obsolete and no longer used.
The SDO now figures out which fields to save to the database tables based on a
comparison of the before-image and the changed record. The ChangedFields field
is not used in any logic, except for a call to bufferCollectChanges, which
updates this field. Since it does not capture all changes, this update is not
reliable and the method will be deprecated in the future.


Note: OE00060333    Type: Known Issue
New records can be duplicated when reading new batch if added while batching
---------------------------------
If new records are created that sort higher than the last record in the current
batch, the new record is duplicated when a batch includes the new record. 

To prevent this, either ensure that the user is at the last batch when adding
the new records that will get key values that sort higher than the currently
last record or avoid batching when such records can be created.


Note: OE00061359    Type: Known Issue
WebSpeed detail program called from a WebSpeed report program hangs
---------------------------------
A WebSpeed detail program called from a WebSpeed report program might hang when
the Add button is used a second time or the Delete button is used. If the
detail program is used separately from the report program, the problem does not
occur.


Note: OE00076414    Type: Limitation
ADM2 does not support the READ-ONLY attribute on browse columns
---------------------------------
The ADM2 does not support setting the READ-ONLY attribute directly on browse
columns as a way to disable fields.  

Field enabling is controlled by the EnabledFields property, that is, you make
columns read-only by removing them from the enabled fields list. 

This is not considered to be a bug. Dynamic browser columns are all read-only
at start up, so it would be very difficult to implement a solution to detect if
the READ-ONLY attribute has been set in initializeObject. 


Note: OE00087999    Type: Known Issue
Loss of data when changing page while browse is in add
---------------------------------
When adding a new record in a browser that is part of a tabbed user interface,
the entered data can be lost or appended to the next record in the browser
under the following conditions:

- The browser is the update source for an SDO. 
- The user did not enter all of the required fields in the browser row. 
- The user selects a different page before saving the new record.


Note: OE00088005    Type: Limitation
A single toolbar cannot switch navigation between SDOs and SBOs
---------------------------------
In a paged container where a SDO is the Data-source of a SBO, you cannot use a
single toolbar to navigate both the SDO and the SBO.


Note: OE00088184    Type: Limitation
Static browsers/browsers in static windows don't get Repository column labels
---------------------------------
Browsers running in static windows linked to a static SDO on an AppServer will
not get the column-label from the Repository's EntityField. Instead, the
browser gets the column-label from the database schema. This problem also
applies to any static browser.	 


Note: OE00094575    Type: Limitation
Error 4054  (.. does not fit..) if ToolbarDrawDirection is "vertical"
---------------------------------
The Dynamics layout manager does not handle toolbars where the
ToolbarDrawDirection is set to 'vertical'.


Note: OE00102910    Type: Behavior Change
Read only SDO tables can be specified to remain NO-LOCKed  during transaction
---------------------------------
The NoLockReadOnlyTables property can hold a comma-separated list of read-only
(non-updatable) tables that should remain NO-LOCKed during the transaction. A
value of 'ALL' means that all read-only tables should remain NO-LOCKed. Note
that read-only tables defined by this property also are excluded from the
optimistic lock check of changes.


Note: OE00104047    Type: Limitation
CallerProcedure, CallerObject, and CallerWindow are not set in createObjects
---------------------------------
The Session Manager's launch in Progress Dynamics sets properties like
CallerProcedure, CallerObject, and CallerWindow in the launched container.
These properties are set before the container is initialized and can thus be
used in an initializeObject override. However, they are not intended for use
during the construction (the execution of the main block) of the container. 
The createObjects call is typically done as part of the construction. However,
in previous releases, static non-window containers, like SmartFames and
SmartDataViewers, did call createObjects from initializeObject allowing these
properties to be used also in createObjects. 
Now, createObjects is called during the construction of almost all containers.
If a createObject override uses these properties, it is unlikely to work. Any
logic referring to these properties in createObjects should be moved to an
initializeObject override instead. Moving this logic to initializeObject should
not cause any change in behaviour.


Note: OE00107469    Type: Known Issue
SmartFrame objects stored with .w in object name may need two translations
---------------------------------
For SmartFrames or SmartWindows that are launched from a static container, the
object name for Title and Page Label translations is resolved from the
procedure:FILE-NAME without path and extension. Therefore, SmartFrame objects
that have the .w extension in their Repository object names might need two
translations, one without the extension for usage in static containers and one
with the extension for dynamic containers.


Note: OE00107568    Type: Known Issue
Error messages for child SDO not returned when CLOB involved
---------------------------------
A detailed error message may not be returned to the client while adding a
record to a SmartDataObject under the following circumstances:

- the SDO is running on AppServer
- the SDO contains large object fields
- AutoCommit is false (commit is used to commit multiple updates at once)

The client does receive an "update cancelled" message but should have a
detailed error.  The detailed error is written to the AppServer log file.  

This situation is more likely to occur with an SDO that is part of a
SmartBusinessObject.


Note: OE00109030    Type: Behavior Change
Changes in how Dynamics Window dimension profiles store WINDOW-MAXIMIZED
---------------------------------
Progress Dynamics windows now store the WINDOW-MAXIMIZED state together with
the previously stored dimensions in the user profile. The state is stored as a
5th entry in the profile value. In previous versions, this state just overwrote
the old profile. If you close a maximized window and no dimensions have been
saved previously, the window still stores "WINDOW-MAXIMIZED" as the only entry.


With the new behavior, a window can store the WINDOW-MAXIMIZED state without
loosing the stored dimensions for the previously saved WINDOW-NORMAL state. The
next time you launch the window, it displays maximized. But, when the
WINDOW-NORMAL state is applied, the window resumes its previously stored size.


Note: OE00109275    Type: Limitation
The SmartDataBrowser sort profile is not used with SBO data-sources
---------------------------------
The sort profile saved for a SmartDataBrowser with a SmartBusinessObject as its
data-source is not used upon restart.


Note: OE00109286    Type: Known Issue
Translation tool does not include SmartDataBrowser search field
---------------------------------
The optional search field of a SmartDataBrowser doesn't show up in the
translation window to allow you to add a translation.	    


Note: OE00110402    Type: Known Issue
Setting of BaseQuery in initializeObject requires synchronization of QueryWhere
---------------------------------
If any other query manipulation has been done before changes to the BaseQuery
are made, you need to synchronize QueryWhere and possibly the QueryString. If
the BaseQuery is set in an initializeObject override before SUPER, you might
also need to synchronize QueryWhere in an SDO without any custom query
manipulation. The only cases where BaseQuery can be set without synchronizing
the QueryWhere are on the client (AsDivision = 'client') and in dynamic SDOs on
the server (AsDivision = 'server'). Static SDOs calls setOpenQuery, which calls
setQueryWhere, from the main block (query.i) when connected to the database.
Dynamic objects that are connected to the database will call prepareQuery from
createObjects.

Background: 
The BaseQuery is the design-time, fixed part of the query. It is part of the
object definition. The design philosophy is that runtime query manipulation can
be done without violating the integrity of this part of the expression.
Consequently, the BaseQuery should not be changed after any query manipulation
has been done.
However, it is quite common for applications to need to set this when an SDO
instance is launched. (For example, to filter data on department or company key
based on the userid.) 
Various examples and documentation have shown and stated that this can be done
in an initializeObject override before the call to SUPER. In particular, older
documentation examples showed this being done with setOpenQuery, which also
synchronizes the physical query by calling QueryWhere. This was a problem on a
client since setQueryWhere used to always prepare the physical query.
setQueryWhere has since become more lightweight, but setOpenQuery still calls
the server and should still be avoided in an AppServer session.


Note: OE00110532    Type: Known Issue
stripLookupfields is not used in the new lookup API
---------------------------------
In previous versions, the stripLookupFields procedure was called on each
display to figure out if the SmartDataFields could be resolved by the viewer's
DataSource. The new lookup API does not use this procedure.


Note: OE00111488    Type: Limitation
SDO Cache does not include Auditing & Comments tick-information
---------------------------------
The data caching and data sharing support does not always cache auditing and
comment information. This information is retrieved only for certain instances
and would only be cached if the actual object that did the initial server
retrieval was set up to include this information. Data objects that retrieve
their data from the cache may thus be unable to show the correct tick-mark in
the toolbar if the initial server request did not include this information.


Note: OE00112018    Type: Limitation
Sharing data object, browse and viewer out of sync showing data
---------------------------------
The support for SharedData does not actively refresh viewers or browse
viewports when data is changed by another DataObject. To refresh a browse, you
must currently scroll the record out of the viewport. To refresh a viewer, you
must currently navigate to another record and back. Note that a viewer on a
hidden page does not refresh itself if it is on the same record as when it was
hidden. So, in this case, it does not help to navigate to another record and
back in the browser.


Note: OE00112062    Type: Limitation
DynCombo support for a DataObject as data source does not include static SDO
---------------------------------
The option to define an SDO DataSource for a DynCombo is not supported for
static SDOs.


Note: OE00112320    Type: Known Issue
BaseQuery must have NO-LOCK after WHERE
---------------------------------
A child SDO loses parent filter criteria if its BaseQuery has the NO-LOCK
option before the WHERE criteria.

When two SmartDataObjects are linked in a parent/child relationship, with or
without a SmartBusinessObject, the child SDO might lose its filtering by the
parent SDO. In previous versions, this happened if the child SDO was generated
by the Object Generator with Follow joins turned on. This generated a BaseQuery
with NO-LOCKs before the join criteria and caused the ADM to add the
foreignfield criteria to the query incorrectly. 

As a workaround, opening and saving the SDO in the AppBuilder alters the
BaseQuery to put the NO-LOCKs after the join criteria as expected by the ADM.


Note: OE00112600    Type: Limitation
Widgets on static SmartDataBrowser are not enabled on dynamic containers
---------------------------------
When a static SmartDataBrowser contains other objects on its frame, those
objects are not enabled when the static SmartDataBrowser is run on a dynamic
container.  When that static SmartDataBrowser is run on a static container,
those objects are enabled.


Note: OE00112836    Type: Known Issue
assignNewValue w/ invalid values behaves different in new lookup API
---------------------------------
The old and new lookup APIs behave differently when passing invalid value
parameters to assignNewValue if the lookup key field is different from the
lookup displayed field.

With the old API (pre-2.1B/10.0B02 behavior and 2.1B/10.0B02 behavior with
keep_old_api set to TRUE), passing an invalid key field value or an invalid
displayed field value to assignNewValue displays blank in the lookup field when
assignNewValue is invoked. If changes to the record are saved, blank is stored
in the record's key field.  

With the new API (2.1B/10.0B02 default behavior), passing an invalid key field
parameter displays blank in the lookup field when assignNewValue is invoked. If
changes to the record are saved, the previous value displays in the lookup
field and the value is not changed in the record's key field. Passing an
invalid displayed field parameter displays the invalid value in the lookup
field when assignNewValue is invoked. If changes to the record are saved, the
previous value displays in the lookup


Note: OE00115074    Type: Behavior Change
Changes to how decimal values are managed in dynamic combos
---------------------------------
There were several problems in previous releases developing decimal dynamic
combos with default flag values that contain a numeric decimal point and
deploying with different numeric formats.

Default flag values were always stored in the format used during development. 
This prevented deployment to numeric formats other than the one used for
development.  Either errors displayed and no data displayed in the combo or
incorrect data was stored in the repository for the <None> or <All> option.

With 2.1B01, 10.0B03 and 10.1A this has changed to store default flag values
with American numeric format.  They should be entered in the SmartDataField
maintenance tool using the session's format but the tool will replace the
numeric decimal point with a period in the stored value.  At runtime, any
stored periods in the data are replaced with the current session's numeric
decimal point.

A fix program runs as part of the DCU Upgrade to convert existing default flag
values for decimal dynamic combos to American format.  The DCU must run in the
format that was used to develop dynamic combos.

The fix program writes a message to the log file for each default flag value it
attempts to convert.  It writes a message when a value is converted
successfully or writes a message if the conversion fails.  Review the DCU log
file after the upgrade and manually correct any failures.  Any failures that
are not corrected may not behave properly at runtime as the runtime has changed
to attempt to convert stored American formats to the format of the running
session.

There are several Dynamics objects in the repository that store blank default
flag value instance attributes and give messages in the log file.  These are
for the cbSCMTool dynamic combo on the following viewer objects:

gsmsxgenviewv
gsmsxotviewv
gsmsxpmviewv

The messages for these objects are expected and you can ignore them.

Any dynamic combo instance attributes stored in static viewer code in your
application must be converted manually to American numeric format.


Note: OE00116096    Type: Known Issue
IndexInformation property only contains information for primary table(s)
---------------------------------
The IndexInformation property has been changed to only contain index
information for the table(s) that are uniquely represented in one row in the
SDO query. The default table(s) are the EnabledTables or the first table for
read-only SDOs. 

The getIndexInfoTables function determines which tables' info is added to the
property. This is not implemented as a property, but can be overridden if
different behavior is needed. If you want the old behavior all data objects,
then add a custom version that returns the value from getTables (all tables in
the query).


Note: OE00121140    Type: Behavior Change
Progress Dynamics and ADM2 filters upgraded for outer join management
---------------------------------
Release 10.2A upgrades the outer join management in ADM2 and Progress Dynamics
filters and the query manipulation methods that they use, assignQuerySelection
and removeQuerySelection. These now work as follows:

1) Removes a buffer's OUTER-JOIN when the first query field expression is added
to the buffer.
2) Adds the OUTER-JOIN back when the last field expression is removed.

This only happens if the buffer is defined with an OUTER-JOIN in the design
time query, that is, the SDO's BaseQuery or the DataView's DataQueryString. 

In Progress Dynamics, this behavior replaces the usage of the Session Manager's
filterEvaluateOuterJoins and fixes two problems. First, the Clear action in the
Progress Dynamics Filter now adds the original outer-join back. Second, the
outer-join is only removed when needed, rather than for any table that happens
to be later in the query.  

In previous releases, standard ADM2 applications (non-Dynamics) would not do
anything with the OUTER-JOIN. As a result, the SDO's result set would not
distinguish between non-existent data or filtered out data. In most cases, this
behavior would prevent the usage of filter criteria on outer joined tables. 

This change constitutes a behavior change for standard ADM2 applications. You
can turn off this new automatic OUTER-JOIN management by overriding
getToggleOuterJoin to return FALSE in a custom class or static instance.
Because it is assumed that this property will rarely be used, the property is
only implemented with the get function and not as a standard ADM2/Dynamics
property. You should only need to override this get function if you have ADM2
customizations that manage outer joins in a way that conflicts with the new
behavior. Note that making this return FALSE also turns off the behavior for
Progress Dynamics users.  
 
There are two new underlying methods, assignBufferOuterJoin and
removeBufferOuterJoin, that assign or remove the OUTER-JOIN in the specified
buffer in the current query, or in the optionally specified query. You can use
these new methods directly in code if you want to add and remove outer joins
when the BaseQuery does not have outer join.


Note: OE00121218    Type: Known Issue
The Export to Excel functionality removes leading zeros from character strings
---------------------------------
The Export to Excel functionality removes leading zeros from character strings.


Note: OE00124494    Type: Behavior Change
UndoChange action added to all tableio toolbars
---------------------------------
Beginning with version 10.1B all shipped toolbars and tableio bands contain a
new UndoChange action. This action replaces the old Reset action as the default
in these toolbars.  

This constitutes a behavior change (label and accelerator) for existing
applications that use the shipped toolbars or bands, since the caption is
changed to "Undo" instead of "Reset" and the accelerator is changed to "CTRL-Z"
from "ALT-R". 

The new UndoChange action defines some of the translatable text needed for the
context sensitive text in the admmsgs.i include, message number 97.    

Customers that use the shipped toolbars or bands and want to remove the new
action and get the old one back need to customize the class or toolbar.
Customers that already have specific toolbars might need changes either to be
able to use the new action or to remove it.
 
To remove (hide) the new UndoChange action and get Reset back in shipped
toolbar or band:
-------------------------------------------------------------------
The Reset action is already present in the toolbar, so in order to make the
Reset into default, the UndoChange needs to be added to the comma-separated
HiddenActions property.   

Existing customer toolbars
--------------------------
Existing customer toolbars may or may not get the new UndoChange action. If the
toolbar or menu is defined with the "Tableio" category or one of the tableio
bands, then the action is added automatically. But, many toolbars add tableio
actions specifically in initAction() or initMenu() overrides in order to
control the order and add rules. The "UndoChange" will need to be added to
these.	 

customized initAction
---------------------
Since the getTableioUndoNew may need to load the actions if it is called from a
visual object before the toolbar is initialized, the toolbar initAction has
been changed to setIsActionsLoaded(true). Overrides of initAction that do not
call super must add the same call, using dynamic-function or the {set~ include.


Note: OE00135094    Type: Limitation
DynLookup limit on number of joins may vary on DataServers
---------------------------------
In Release 10.1C, the DynLookup supports a join with up to 18 tables instead of
10. But, this limit might not apply when using a DataServer, because there also
is a limit decided by the size of the ROWIDs in the tables. The ROWIDs of the
tables are added to an indexed RowIdent field and the ABL has a limit on the
size of an index. 

Starting with Release 10.1B, as long as -tmpbsize 4 (default) or larger is
used, temp-tables use large index keys and can store up to 1970 characters.
This means that, in theory, you can store and index up to 16 ROWIDs returned
from MSSQL server ( 16 * ( 116 + 1 ) - 1 = 1871 characters for rowids +
separators). The different DataServers will return ROWIDs with different
lengths, so the limit will vary. 

If this limit is an issue, then you can edit the af/app/afgettemp.p procedure
and remove the following index definition.
 
----
hTT:ADD-NEW-INDEX("idxRowIdent":U,FALSE,FALSE).
hTT:ADD-INDEX-FIELD("idxRowIdent":U,"RowIdent":U,"asc":U).
----

The index is used in certain reposition operations on the client. Removing it
has an affect on performance, but this might be unnoticeable or acceptable
since the operation is done on the temp-table on the client.


Note: OE00161453    Type: Limitation
Toolbar never creates a Band more than once per toolbar instance
---------------------------------
The toolbar creates only a single instance of each Band for a toolbar instance.
However, the Repository allows multiple instances of the same Band on a
toolbar. Before Release 10.1C, the toolbar created the multiple instances of
the same Band, but the second instance had no menu items. In Release 10.1C, the
second instance of a Band is ignored completely.


Note: OE00162048    Type: Workaround
**Widget ID <n> not unique (<widget-name>) error for recursive Dyn TreeViews
---------------------------------
The "Runtime Widget-ID Assignment" tool assigns default gap values for the
imported SmartObjects.
These default values should work without problems in most cases. But, for
Dynamic TreeViews with structure nodes, the default gap value of 2000 for
"TreeNode" might not be large enough.
Since the nodes are created at runtime according to the database data, it is
impossible to know how many tree node levels are going to be created in the
Dynamic TreeView. If this happens and the default gap value of 2000 is not
enough, that default value should be increased as specified in the "Application
Development Environment (ADE) Addenda" Web paper in the "Widget IDs for ADM2
and Progress Dynamics" section.


Note: OE00176891    Type: Limitation
dynlaunch.i fails in thin client with DATETIME, DATETIME-TZ, RAW or ROWID param
---------------------------------
Calling a PLIP using dynlaunch.i fails in a thin-client environment if the
procedure call includes DATETIME, DATETIME-TZ, RAW or ROWID parameters.

The client will report this error:
Mismatched number of parameters passed to routine <name>. (3234)

The AppServer agent will report these errors:
BUFFER-FIELD was not found in buffer ttSeqType. (7351)
Lead attributes in a chained-attribute expression (a:b:c) must be type HANDLE
or a user-defined type and valid (not UNKNOWN). (10068)

The workaround is to implement calls with these data types to run as external
procedure calls on the AppServer.  

e.g. RUN xxx on gshAstraAppServer (INPUT ...)

Alternatively, you might add CASE statements for the 4 data types in
obtainInitialValueField in adm2/caller.p. (This has not been tested, but is
assumed to be the problem.)


Note: OE00179996    Type: Behavior Change
Read-only table availability not included in optimistic lock check on deletions
---------------------------------
The SDO's optimistic locking check for deletions no longer includes checking
for the availability of read-only tables that are joined to the updatable
table. This changes the behavior from 10.1C, which extended optimistic locking
to also work for deletions. The 10.1C behavior prevented deletions of the
updatable table in cases where the "begin" transaction hook would delete a
joined table. Deleting joined tables in "begin" transaction hooks is commonly
used to avoid errors with a table whose database trigger disallows deletions
when a join exists.
The checkReadOnlyAvailOnDelete function controls this behavior. To retain the
10.1C behavior of including joined table availability in the optimistic lock
check for deletes, you can override the function to return TRUE.


Note: OE00191743    Type: Known Issue
Dynamic SDO with join require calculated fields to be defined in table order
---------------------------------
In a Dynamic SDO based on a join, calculated fields will behave incorrectly
under these circumstances:
- Both tables in the join have calculated fields defined in the Repository's
entity definitions.
- Both tables also have one or more of these SDO Entity calculated fields
included in the SDO.
- The calculated fields from the right-hand table of the join appear before
those of the left-hand table in the list of fields in the SDO.

Symptoms include incorrect formatting and incorrect initial values being
provided, as well as calls to the SDO data logic procedure failing with errors
relating to temp-table schema mismatches.


================================================
ADE Tools and Runtime - Services
================================================


Note: OE00016261    Type: Limitation
Record level transaction hooks must be implemented in the Data Logic Procedure
---------------------------------
You must implement a static SmartDataObject's record level transaction hooks
(create*, write*, and delete*) in the Data Logic Procedure. They will only fire
from the SDO if the SDO does not have a Data Logic Procedure.


Note: OE00106187    Type: Known Issue
Static SmartDataFields (e.g. SmartSelect) cannot be translated.
---------------------------------
SmartSelect objects are not presented for translation in the Translation window
at runtime.

The work around is to enter translations of SmartSelects in the Translation
Control tool. The same naming convention as for Lookups is used. You must
specify the Widget Type as 'FILL-IN' and the Widget Name as 'fiLookup' in all
cases. You must enter the Object Name as <viewer-name>:<field-name>.

If the static SmartDataViewer containing the SmartSelect is used in a static
container, you must enter the file name of the viewer, including the extension
(.w), in the Object Name. If the viewer is used in a dynamic container, you
must enter the object name of the viewer, without any extension.

This is an example based on a viewer for the Warehouse table using a
SmartSelect for the 'State' field. The file name of the viewer is
'warehousesdv.w'.

Translation for use in a static container:

Object Name: warehousesdv.w:state
Widget Type: Fill In
Widget Name: fiLookup

Translation for use in a dynamic container:

Object Name: warehousesdv:state
Widget Type: Fill In
Widget Name: fiLookup


Note: OE00108151    Type: Behavior Change
Info for all users sent to client
---------------------------------
When a user attempts to login in a client-AppServer configuration, the entire
list of users is sent from the AppServer back to the client. This may be an
expensive operation when there is a large number of users in the repository. To
reduce this overhead, adding the session property "abbreviatedUserTable" to all
client and AppServer session types and setting its value to "YES" will result
in only the user that is logging in having his data shipped across from the
AppServer, thereby reducing the traffic.


Note: OE00123050    Type: Limitation
The DataView does not support Dynamics Comments and Auditing
---------------------------------
There is no default support for Comments and Auditing when DataViews and
ProDataSets are used.

The following error is returned when attempting to save a comment for a
DataView:
									     
BUFFER-FIELD RowUserProp was not found in buffer <dataset-buffer-name>.(7351)

The Server Interface implementation could define a RowUserPropfield in the
entity temp-table to store the information needed to trigger Auto Comment and
show tick marks in the Dynamics toolbar's Auditing and Comment actions, similar
to how the SDO handles it. Using this field might make it easier to use
existing Repository Manager APIs and reuse existing SDO code. Note that the
Auditing and Comment information is stored with delimiters in the field. This
makes it difficult to use outside of the ADM and difficult to populate. The
population have to be done for each record and will likely affect performance.


Note: OE00125984    Type: Behavior Change
Translated labels and widgets on same row but different column
---------------------------------
When translating static viewers where KeepChildPositions=Yes, translated labels
now use the existing label's width only. Also when translating static viewers,
the label's font, rather than the widget's font, is used to determine the width
of the label.

The translation of simple (LIST-ITEMS) combo-box labels is now supported for
dynamic viewers.

When translating dynamic viewers with KeepChildPositions=Yes, the label moves
to the bottom (back) so that it doesn't overlay any widgets to its left. The
label is not truncated, unless it is longer than the space available.


Note: OE00127924    Type: Known Issue
Progress Dynamics can't find the help file during AppServer sessions
---------------------------------
When the help file is set in the "security control" window, Progress Dynamics
can't find the help file using the help-menu-item in an AppServer session.


Note: OE00128539    Type: Behavior Change
Dynamics translated application: performance problems on login
---------------------------------
Support has been added for a session property called "cached_translations_only"
which is set via the session definition (in the XML file and/or repository). In
the absence of such a property in the session, the default is YES (the
historical value). If cached_translations_only is false, then translations are
not retrieved at startup, but rather on demand when an object is translated.


================================================
ADE Tools and Runtime - Tools
================================================


Note: OE00021013    Type: Known Issue
scm_checks_on in Security Control is not supported
---------------------------------
In Security Control, there is a toggle that switches on and off checks for the
use of an SCM tool. The use of this setting is not yet implemented in all the
places where it is relevant to check for this setting. SCM functionality is
always enabled when the SCM tool (Roundtable) is in use with Progress Dynamics.


Note: OE00024983    Type: Known Issue
Fields hidden on DynView master layout in design mode if custom layout exists
---------------------------------
If a field on a master layout has its HIDDEN attribute set to TRUE, the viewer
typically displays the field in design mode. However, if a customized layout is
made for the viewer, the viewer does not display the hidden field when the
viewer reopens. This is inconsistent with the normal behavior for displaying
hidden fields in master layouts. If you need to modify a hidden field in this
situation, use the ROM tool. Do not modify the hidden field by using the 'List
Objects' button to bring up the property sheet. Doing so removes the field
instance.


Note: OE00035615    Type: Known Issue
Netscape Default HTTPS and SSL Support
---------------------------------
The AppBuilder uses two OCX controls for remote file management (RFM) for
WebSpeed. One of these controls, CIHTTP v4.00.002, comes from Crescent.
According to current Crescent FAQ documentation on their Web site, OCX controls
do not work with a secured server.


Note: OE00045969    Type: Known Issue
Double Dot Path Notation Causes Failure
---------------------------------
When using Netscape WebServers with an NSAPI messenger, the WebServer might
general protection fault if passed a .gif file location that uses a double dot
path notation that goes higher than the docroot, for example,
..\msthemes\auto.gif.

To avoid this problem when using an NSAPI messenger, do not specify .gif file
locations using double dots if that notation goes higher than the docroot.


Note: OE00070627    Type: Known Issue
Toolbar object modifications are not updated in the Toolbar
---------------------------------
011A90108
Toolbar data are cached on the client as soon as they have been read once    
from the server, so when actions, bands and/or toolbars are changed in the   
Toolbar and menu designer these changes will not always be reflected in new 
instances of toolbars.							       
       
Running the Dynamic Launcher and checking the 'Destroy ADM super-procedures' 
option will ensure that toolbar data are refreshed. The other option is to   
restart the session.						    


Note: OE00086609    Type: Known Issue
HTML after WSTag not sent if WSTag runs another WebSpeed object
---------------------------------
If a SpeedScript file contains a WSTag tag that runs another WebSpeed
object, the remaining HTML after the WSTag tag is not sent to the Web
browser.


Note: OE00088031    Type: Known Issue
DataFields cut/copied then pasted are associated with RowObject
---------------------------------
There is an issue when you cut or copy DataFields from one dynamic viewer and
then paste them to another dynamic viewer built from the same SDO. Until you
save and reopen the second viewer, the AppBuilder shows the new fields as being
associated with the RowObject table instead of their actual database table.


Note: OE00093984    Type: Known Issue
Copy-Paste in DynView is not keeping all the attributes of the widgets
---------------------------------
When copying widgets from a DynView to another DynView, some widget attribute
values are missed. For example, when a fill-in is copied, the values of the
ShowPopup and Label attributes are missed in the target DynView. This happens
for all attributes that are read from the Repository.


Note: OE00097484    Type: Known Issue
Client cache viewer tool returns errors
---------------------------------
The client cache viewer tool no longer works when run against a current version
of the Repository API.


Note: OE00098133    Type: Known Issue
Error 560 Generating Objects From SDO
---------------------------------
Error 560 (Entry outside the range of list) is raised when the Object Generator
is used to create dynamic objects from a prebuilt SDO when the SDO has been
created by the Object Generator, and has subsequently had other tables manually
added, and the product module has sublevels in the path.


Note: OE00103384    Type: Known Issue
RTB: Problems when dyn object and super proc in different module
---------------------------------
When modifying a dynamic object where the dynamic object and its super
procedure were created in different product modules, the following error may
occur:

The product module <product-module1> and the product module <product-module2>
must be the same. (AF:110)


Note: OE00107793    Type: Known Issue
Dynamic Lookup maintenance window does not destroy its maintenenance SDO
---------------------------------
The Dynamic Lookup maintenance window does not destroy its SDO and associated
Data Logic Procedure

Whenever you open the maintenance window of the dynamic lookup from the dynamic
lookup browse, the system launches a new instance of the maintenance window's
SDO and its associated DLP. However, these objects are not destroyed upon
closing the maintenance window.


Note: OE00107875    Type: Known Issue
Cascading security allocations does not work for Data Security
---------------------------------
The option to cascade security allocations from a profile user does not   
work for Data security.


Note: OE00109408    Type: Limitation
Help cannot be mapped to static container run from the AppBuilder
---------------------------------
It is not possible to map help for a static container that has been run from
the AppBuilder.  The container must be run from the Dynamic Launcher to map
help for it.


Note: OE00168684    Type: Known Issue
Error 7452 in Dynamics Dataset Export Filter
---------------------------------
Customers using European numeric settings might see the 7452 error when
pressing the filter button on the Dataset Export screen.


Note: OE00170170    Type: Known Issue
Error: The Root node code must be specified. (AF:1) when creating Dyn TreeViews
---------------------------------
When entering data in the "Dynamic TreeView Builder" tool, you must enter the
"Object filename" value first. If you do not enter the Object filename first,
you see the "Root node code must be specified. (AF:1)" error upon saving the
data.


================================================
ADE Tools and Runtime - Translation Manager
================================================


Note: OE00102201    Type: Known Issue
Changing the TranMan Language combo may cause error (132)
---------------------------------
Changing the selected language on the TranMan Data Tab combo does not display
the correct translations after using the 'View', 'Sort' option from the pull
down Menu.

Double clicking on some rows might give the following error:
** This Translation already exists with Sequence number <number> Instance
Number <number> Language  Name "<language>". (132)


================================================
ADE Tools and Runtime - Web Rendering
================================================


Note: OE00040946    Type: Limitation
Avoid changing Foreign Keys in Web Objects with joined queries
---------------------------------
When you use the Detail Wizard to create a Web object that contains a join, do
not make the foreign key field updateable. If you change the value of the
foreign key in a record, the next stateless request might not be able to find
that record.

When this happens, you get an error that the query could not reposition to that
record.

If your application needs the ability to update the value of the foreign key in
a joined query, you must make sure that the list of ROWIDs in the
"CurrentRowids" attribute contains ROWIDs of the newly joined table, instead of
the originally-joined table.


Note: OE00135596    Type: Known Issue
Two undo/reset buttons on the Standardtoolbar
---------------------------------
The new UndoChange toolbar action is not supported in Dynamics Web.

By default, UndoChange replaces the Reset action in shipped toolbars and
Tableio bands. When these toobars and bands are realized in the Web, the Reset
button and menu item remain and function correctly. However, the UndoChange
action may also be realized at runtime as a non-functioning button and menu
item, labeled "Undo 1 (CTRL-Z)".

In order to suppress the UndoChange button and menu item, the UndoChange action
can be set to Hidden, or added to the HiddenActions property, for the toolbar.
For additional information, please see the note for the new UndoChange action
under GUIRENDR / SmartToolbar in this document.


================================================
Auditing - Tools
================================================


Note: OE00183212    Type: Behavior Change
Change auditing passKey after procopy -newinstance
---------------------------------
When an audited OpenEdge database, with a passKey set, is copied with procopy
-newinstance, the passKey value is not carried forward.  To continue using the
auditing record-level data integrity checks, you must input a new passKey value
with the Data Dictionary.


================================================
Command Line Tools - 
================================================


Note: OE00188518    Type: Limitation
certuil -verbose and pkiutil -verbose cause core on Aix64
---------------------------------
Displaying verbose certificate information using certutil -verbose or pkiutil
-verbose on Aix64 results in a core dump.

The core is the result of a known OpenSSL issue, bug #1272.  For information on
the OpneSSL issue, see:
http://rt.openssl.org/Ticket/Display.html?id=1272&user=guest&pass=guest


================================================
Database - Database Utilities
================================================


Note: OE00070876    Type: Known Issue
PROUTIL IDXFIX -silent is not silent
---------------------------------
Running PROUTIL IDXFIX with the -silent parameter does not suppress the display
of repetitive messages or prevent repetitive messages from being written to the
log file.


Note: OE00153461    Type: Limitation
On overflow condition, specified binary dump does not dump as expected.
---------------------------------
While dumping data for a column with datatype BIGINT, an overflow condition
occurs when the specified column value is larger than the max BIGINT value.  No
error message is generated, and the dump continues as if the number specified
is a negative number.  


Note: OE00153473    Type: Limitation
Negative integers are not supported by specified binary dump.
---------------------------------
Negative integers are not supported by the specified binary dump utility as
input parameters.   You can dump all negative values by specifying a value
range as  "LT 0" for the column, but specifying any negative integer, such as
"LT -1", fails.  The specified binary dump utility cannot interpret command
lines with a "-" negative sign in the input parameter on command line.


Note: OE00192654    Type: Known Issue
Control-c at passphrase prompt leaves echo turned off
---------------------------------
For a database enabled for encryption with manual start, echo of the entered
characters is turned off during the passphrase prompt.	If you enter a
control-c at the passphrase prompt,  character echo remains turned off for the
window.  Close the window and open another one to continue your database
administration with echo turned on.


Note: OE00192738    Type: Workaround
dbutil.bat supports nine command line parameters
---------------------------------
dbutil.bat supports 9 command line parameters.	Use proutil.bat if your command
line requires more than 9 parameters.  proutil.bat supports 27 parameters.  


================================================
Database - Failover Clusters
================================================


Note: OE00077124    Type: Limitation
Failover clusters and multiple APWs
---------------------------------
Configurations where there are multiple APWs enabled may find that only one APW
will restart when fail over of a database resource occurs to the same node on
which the failure has occurred.


Note: OE00077583    Type: Known Issue
Manually stopping an APW on MS Windows Server 2003 running Clusters
---------------------------------
When manually stopping a pagewriter on a Windows 2003 Server cluster (after a
PROCLUSTER enable and PROCLUSTER start), the cluster administrator does not
properly show the updated (failed) status of the particular pagewriter.


Note: OE00083648    Type: Limitation
Clusters -- the hour might be incorrect in the db.Appserver.log file (AIX only)
---------------------------------
The hour position time value displayed in the db.Appserver.log file might be
incorrect for some messages.  This usually occurs when database related
processes/ancillary processes that were enabled with the database are dead or
killed.


Note: OE00085049    Type: Known Issue
Pagewriter error message on PROCLUSTER start can be ignored
---------------------------------
When executing a PROCLUSTER start, and no pagewriters were specified in your
PROCLUSTER enable, a grep error message is displayed looking for the
{db-name}Resources.cluster file.  This file only exists if pagewriters are
specified during the PROCLUSTER enable.  This error message is harmless and can
be ignored.


Note: OE00085074    Type: Known Issue
First PROCLUSTER enable must complete
---------------------------------
The first database register, i.e. PROCLUSTER enable, must be allowed to
complete before issuing additional PROCLUSTER enable commands.	This is to
allow the proper registration of the Progress Cluster type (PRGS.clstr).  Once
the PRGS.clstr registration is complete, PROCLUSTER commands can be entered
without any restrictions.


Note: OE00147497    Type: Limitation
Failover Clusters -- limited multiple login brokers support
---------------------------------
Clusters has limited support for multiple login brokers (_mprsrv -m3).
Secondary login brokers must be started as described in the documentation, or
they will not restart in the event of a failover.


Note: OE00147498    Type: Limitation
Failover Clusters node ordering
---------------------------------
The node the cluster chooses to fail over to is a default preference Clusters
accepts from the cluster manager. If you want to tailor this, you must use your
operating system cluster management utilities. Clusters does not alter node
ordering.


Note: OE00147499    Type: Limitation
Failover Clusters excluding nodes from fail over
---------------------------------
All clustered systems provide a means for disallowing hosts from hosting a
resource. You must use your operating system cluster management utilities to do
this. Clusters does not provide a means to disallow a host.


Note: OE00147500    Type: Known Issue
Watch Dog should be enabled for Clusters
---------------------------------
When enabling a database for clusters using the PROCLUSTER enable command, the
Watch Dog must always be enabled.

For example:
procluster /usr/wrk/foo enable WDOG


Note: OE00147501    Type: Limitation
Failover clusters helper processes that do not start on another machine
---------------------------------
If any of the helper (APW, BIW, or AIW) processes or the watchdog process
specified to start with a particular database fails, they will not be started
on another machine during a failover.  They will produce an OFFLINE status.


Note: OE00147507    Type: Product Notice
Clusters -- two databases using the same port (AIX only)
---------------------------------
A cluster-enabled database attempting to use a port currently in use fails to
come ONLINE because the port is already in use.  The database retries the
attempt to come ONLINE the number of times specified by the restart count. 
During the period of time that the retries occur, querying PROCLUSTER <dbname>
isalive/looksalive or HACMP clfindres for status of resource group returns
ALIVE/UP as the status. This is correct because there are other resources in
the resource group that have been brought ONLINE at that time. After the
database resource has unsuccessfully retried the specified number of times, the
status of the resource group is updated to DOWN.


Note: OE00147509    Type: Product Notice
Failover Clusters Sun Cluster uses global devices
---------------------------------
Clusters only supports databases stored on global devices.  The Sun Cluster
uses global devices to provide cluster-wide, highly available access to any
device in a cluster, from any node, without regard to where the device is
physically attached.  In general, if a node fails while providing access to a
global device, the Sun Cluster software automatically discovers another path to
the device and redirects the access to that path. The local disks on each
server are not multi-ported, and thus are not highly available devices. 
Multi-ported global devices provide more than one path to a device. In the case
of multi-host disks, because the disks are part of a disk device group hosted
by more than one node, the multi-host disks are made highly available.


Note: OE00147833    Type: Known Issue
Clusters -- simultaneous enable of two different databases
---------------------------------
If you simultaneously execute a PROCLUSTER enable command for two databases,
you get the following error for one of the databases:

Unable to synchronize cluster resources, Perform synchronization manually and
identify error cluster REGISTER command was UNSUCCESSFUL.

Though the cluster registration reported it was unsuccessful, both databases
are successfully registered and automatically brought online by the cluster
manager/administration tools.  To avoid this error message, disallow multiple
cluster administrators from having access to the cluster administration at the
same time, and execute PROCLUSTER commands one at a time.


Note: OE00147834    Type: Known Issue
Clusters -- startup fails when the database lock file is not removed (AIX only)
---------------------------------
If your database was shutdown in a way that did not remove the database lock
(<dbname>.lk) file, the database may not be able to startup. Work around this
issue by adding the following script fragment to the beginning of your cluster
master start script, /etc/cluster/<resource_group>/MASTER.START:
 
 !/bin/ksh

 # Replace <DBNAME> by the full path of the database without any extension.
 # eg. DBNAME="/usr3/testdb"
 DBNAME="<DBNAME>"
 LKFILE="$DBNAME.lk"

# a check to make sure that the database is not in use.
 CHECK_ALIVE=`proutil $DBNAME -C HOLDER`  
 RETURN_CODE=$?

# a return code of 0 means that the database is not in use.
 if [ $RETURN_CODE -eq	0 ]; then 
 rm -f $LKFILE

# continue with the body of the MASTER.START script here.


Note: OE00163001    Type: Known Issue
Restarting on the same node -- HPUX only
---------------------------------
A package that fails, attempts to switch to the next node on which it is
configured to run.  If you wish the package to restart on the node where the
failure occurred, you must use the MC/ServiceGuard cmmodpkg utility to
re-enable the package to run on that node.   See your MC/ServiceGuard
documentation for details regarding the syntax of this utility.


Note: OE00192361    Type: Known Issue
An encryption-enabled, manual start db cannot be started by failover clusters
---------------------------------
You cannot start a database enabled for failover clusters with your operating
system cluster resource manager if it is also enabled for transparent data
encryption and configured for manual start.

Failover cluster and encryption-enabled databases must be configured for
autostart to be started by the cluster resource manager.

If you attempt to start an encryption-enabled database configured for manual
start with the operating system cluster resource manager, the actual startup
fails, 
but the cluster resource manager may incorrectly report that the database has
been started.  


================================================
Database - RDBMS
================================================


Note: OE00161719    Type: Behavior Change
Members of the Windows Administrator group can perform unconditional shutdown
---------------------------------
The privilege to perform unconditional shutdown of a database is granted to all
members of the Administrators group on the system where the database is
running.


================================================
Database - Security
================================================


Note: OE00185467    Type: Limitation
A crash during a keystore rebind operation can leave inconsistent guids
---------------------------------
If the PROUTIL EPOLICY MANAGE KEYSTORE REBIND command crashes, it can leave the
database with a new guid 
and the keystore with the old guid.  The following messages appear:

dbecRecoveryLoad: Internal security service error {3} (dksp) Key store load
failed (15014)
dbecRecoveryLoad: Internal security service error {3}  (keystore) invalid
database binding {02021b2a} (15014)
SYSTEM ERROR: dbecRecoveryLoad: Unable to load security policy -101 (15082)

Fix this problem as follows:

1. Choose one of the following:
	a. Obtain a copy of the database with PROCOPY -newinstance
	b. Obtain a new copy of the old keystore (.ks) file 

2. Rebind the database and keystore again with the the PROUTIL EPOLICY MANAGE
KEYSTORE REBIND command.


================================================
DataServers - DB2
================================================


Note: OE00191143    Type: Behavior Change
New Dsrv PRGRS_MAPFIXEDCHAR switch for right-trimming fixed-length CHAR fields
---------------------------------
A new -Dsrv startup switch called "PRGRS_MAPFIXEDCHAR" is provided for ODBC
DataServers. This switch will internally map the fixed-length CHAR in the
foreign data source to the behavior of an OpenEdge CHAR type which is variable
length and consistent with the SQL VARCHAR data type. 


================================================
DataServers - MS-SQL
================================================


Note: OE00169420    Type: Workaround
New QUERY-TUNING switches to enable/disable firehose cursors for a query
---------------------------------
Firehose cursors are used by default in the DataServer for MS SQL Server to
handle NO-LOCK queries.  Although, in  most cases, use of firehose cursors
results in the improvement of query performance, there are certain scenarios
where the use of firehose cursors can be viewed as causing performance
degradation.  Specifically, the case whereby a query returns a very large
result set but not all records in that result need to be processed.  The
upfront latency to process such a query with a firehose cursor can make the
subsequent processing of that small percentage of results a costly proposal. 
Microsoft recommends avoiding the use of firehose cursors in such cases.

There are two connection level "-Dsrv" switches made available, QT_FIREHOSE and
QT_NO_FIREHOSE.  QT_FIREHOSE turns firehose on by default for all cursors in a
given session and QT_NO_FIREHOSE turns it off.	By default, all sessions will
attempt to use firehose cursors so the QT_FIREHOSE connection setting should be
considered the default.  

This fix provides new QUERY-TUNING options to allow users to disable/enable the
use of firehose cursors.  The connect level "-Dsrv" settings described above
can be overridden at the query level by setting a QUERY-TUNING switch.	So if
"-Dsrv QT_NO_FIREHOSE" was set at connection time, the
QUERY-TUNING(FIREHOSE-CURSOR) option could be specified on a partcular NO-LOCK
query to override the connection level setting and use a firehose cursor for
that particular query.

However, the primary expectation is that users will chose to leave firehose
cursors on for their DataServer sessions and utilize the QUERY-TUNING option if
they observe slow query performance during NO-LOCK reads of large result sets.
In such cases, the QUERY-TUNING(NO-FIREHOSE-CURSOR) option is available for
that particular query. 

Sample ABL query with NO-FIREHOSE-CURSOR query tuning option is as follows:
FIND FIRST customer NO-LOCK QUERY-TUNING(NO-FIREHOSE-CURSOR).


Note: OE00178470    Type: Behavior Change
Possible misssing records from Dictionary Load with the MSS DataServer resolved
---------------------------------
Due to MS SQL Server trigger limitations, the INSERT trigger that fires when an
MS SQL Server record is inserted would not always insert the record into the
database when the ABL CREATE statement is used or when the Dictionary .d load
routine is used.  In addition, no error was being reported about the msising
insert.  The missing records occurred because of native record contention from
a process known as the "ghost cleanup task" in MS SQL Server.  It was
unreported because the MS SQL Server trigger is not capable of reporting the
error condition from a trigger implementation.	The situation was not likely to
occur except in a tight ABL loop performing bulk CREATEs, such as the
Dictionary load routine.

The INSERT trigger used by the DataServer for MS SQL Server has been rewritten
to compensate for native trigger limitations.  The new trigger tries to resolve
contention with the ghost cleanup task and would reliably report contention if
it could not.  

In addition, starting in version 10.2B FCS, a new and faster alternative to
RECID generation known as the "computed column RECID" is available during
migration if the target foreign data source is MS SQL Server 2005 or later. 
When the computed column RECID option is selected, the INSERT trigger is no
longer needed and is removed altogether from the DataServer implementation.


Note: OE00181255    Type: Behavior Change
Schema update required when MSS table contains 'timestamp' fileld
---------------------------------
A native "timestamp" data was not previosly allowed to be present in a database
table pulled into a schema holder for MS SQL Server.  The OpenEdge DataServer
for MS SQL Server can now accept such columns into a schema holder as an
non-updateable column. 

You should re-build your schema holders (or perform update schema) on MSS table
containing 'timestamp' columns that you could not previously pull.


Note: OE00184174    Type: Limitation
VARBINARY(MAX) column with NOT NULL constraint
---------------------------------
A VARBINARY(MAX) column that is mapped to OE BLOB in the schema holder, will be
created with a NULL value and then will be updated with a user supplied value, 
if any.  Therefore it is a limitation to create a record, update a record or
load a .d file in a table with VARBINARY(MAX) column with a NOT NULL
constraint.


Note: OE00184300    Type: Behavior Change
r-code compatibility
---------------------------------
R-code changes have occurred for DataServers in OpenEdge Release 10.2B that may
cause compatibilty problems when 10.2B r-code is executed using a run-time
environment prior to 10.2B.  A new client startup switch ("-oldrccds") provides
old r-code compatibility for DataServers.  By default, 10.2B r-code will not be
compatible with prior releases.  The value assigned to the -oldrccds switch
will increase each time a new release has r-code changes that are not backward
compatible.  Since 10.0A, only 10.2B is incompatible with earlier r-code.

-oldrccds,0 - If unset, r-code will be compiled for the current release
-oldrccds,1 - r-code is compatible 10.0A through 10.2B
-oldrccds,2 - r-code is compatible 10.2B until the next higher r-code change
release.

The following matrix shows this compatibility:

                 | Compiled bits from:
-----------------|------------------------------------------------
Running bits     | 10.2B rcode | 10.2B rcode     | 10.2B rcode
from             | by default  | w.oldrccds set  | w/oldrccds set
                 |             | to = 10.2B      | to < 10.2B
                 |             | -oldrccds,2     | -oldccds,1
__________________________________________________________________ 
10.2B            | compatible  | compatible      | compatible
                 |             |                 |  
<= 10.2A         | *not compat | *not compat     | compatible

* not compat - while not entirely predictable, incompatibility will typically
mean that upon application execution with incompatible bits, you will
experience run-time error, "Array subscript is out of range (2715)".


Note: OE00186542    Type: Workaround
Techniques to load .d file when table has non-updatable column on MSSQLServer
---------------------------------
In MSS DataServers, there is a restriction to a load operation from a .d file
when the table has non-updatable columns (i.e. columns on MS SQL server are of
type 'identity' or 'timestamp' or 'rowguid').
You can work-around this restriction by following one of the two options
described below.

Option 1:-
Use dump/load tools of the foreign data source instead of data from a .d file
to load your foreign table.

Note: This is the only way to retain the original values from non-updatable
columns.

Option 2:-
If the user wants newly generated values for non-updatable columns stored along
side updatable fields from the given '.d' file, write an ABL program to read
data from the .d file into a temp table and then skip non-updatable fields
while writing the temp table records to the foreign table.

Sample ABL code provided below to perform this task.

Conside a table named "test" on SQL Server side with the sturcture as,

TABLE [test](
[fld1] [int] IDENTITY(1,1) NOT NULL,
[fld2] [varchar](50) NULL,
[fld3] [varchar](50) NULL
)

****** sample ABL code ******

/* define temp table with the name Temptbl for table test */
define temp-table Temptbl like test.

/* pouplate temp-table Temptbl from the records in the .d file name test.d */
INPUT FROM test.d.
REPEAT:
CREATE Temptbl.
IMPORT Temptbl.
/* create a record in the foreign DB */
CREATE test.
BUFFER-COPY Temptbl EXCEPT fld1 TO test.
END.
INPUT CLOSE.

*****************************


Note: OE00187486    Type: Limitation
Unique Index for BLOB operations
---------------------------------
In OpenEdge Release 10.2B, OpenEdge DataServer for MS SQL Server has been
enhanced to support ABL BLOB data type and restricted BLOB operations using ABL
phrases COPY-LOB and ASSIGNMENT. 

BLOB operations, including BLOB column read, write, create, delete via COPY-LOB
and ASSIGNMENT, will only work if a unique-index is present in the schema
holder for the table or the view. Based on the unique-index, DataServer for MS
SQL Server accesses the record from the database (e.g., for calculating the
length of the BLOB, Updating a BLOB on INSERT, etc.) and BLOB operatios are
performed on the BLOB column presented in the record.

The schema holder does not contain any unique-index information for views.
Because views do not have unique indexes, you cannot modify any of the data
that a view contains;
You are required to simulate a unique-index in the schema holder for the view
for any BLOB operation to be sucessful.


Note: OE00187938    Type: Known Issue
DataDirect driver 6.0 is not consistent with other ODBC drivers with MSS2008
---------------------------------
The behavior of the Data Direct driver 6.0 is inconsistent with other drivers
in MSS 2008. There is difference in behaviour between Data Direct driver 5.3
and 6.0.

The Data Direct 6.0 driver keeps running a transaction after setting AutoCommit
OFF in case of SQL Server 2008.


Note: OE00188308    Type: Behavior Change
The DataServer log output is improved to provide conn-id,cursor-id & stmt-id
---------------------------------
The DataServer log output is improved to provide
(*) Unique cursor identifiers needed for log tracking - with format as
<CURS-ID> (in angle brackets)
(*) Unique statement identifiers for tracking reusability - with format as
[STMT-ID (in square brackets)
 
For example, 

Old log entry (10.2A) - 

  [09/08/24@18:54:51.431+2300] P-023140 T-014524 1 MSS -- Execute on 0x4591a20
Master Connection new: SELECT "custnum", "country", "name", "address",
"address2", "city", "state", "postalcode", "contact", "phone", "salesrep",
"creditlimit", "balance", "terms", "discount", "comments", "fax",
"emailaddress", PROGRESS_RECID, PROGRESS_RECID_IDENT_ FROM
"na_2k"."nmanchal"."customer" WHERE ((PROGRESS_RECID = ?)) (15069)
[09/08/24@18:54:51.431+2300] P-023140 T-014524 1 MSS -- 	   Connect:
0x4591a20 MASTER Stmt: 0x35c2b40 Handle: 0x4593ac8 Crc: -28557 Proprty: BOUND
AUTOFETCH bind buffer unbound (15063)
   
New log entry (10.2B) - 
  
[09/08/24@18:41:35.082+2300] P-020588 T-006220 2 MSS	CURSOR	   Execute on
0x4a11b80 Master Connection new: SELECT "custnum", "country", "name",
"address", "address2", "city", "state", "postalcode", "contact", "phone",
"salesrep", "creditlimit", "balance", "terms", "discount", "comments", "fax",
"emailaddress", PROGRESS_RECID, PROGRESS_RECID_IDENT_ FROM
"na_2k"."nmanchal"."customer" WHERE ((PROGRESS_RECID = ?))  (15069)
[09/08/24@18:41:35.098+2300] P-020588 T-006220 2 MSS	CURSOR	   Connect:
0x4a11b80 MASTER   Stmt: 0x3881e50   Handle: 0x4a14028	 Crc: -28557 Proprty:
BOUND	 AUTOFETCH bind buffer unbound (15063)
[09/08/24@18:41:35.098+2300] P-020588 T-006220 2 MSS	CURSOR	   Connection
0x4a11b80 @{#1} Pcurs=0x3881894 <2>[2] cli_cur#0

where 
connection-id = 1 as specified by @{#1}
cursor -id    = 2 as specified by<2>
statement-id  = 2 as specified by [2]


Note: OE00190218    Type: Known Issue
SQLError not getting message with SNAC-10 driver.
---------------------------------
New trigger solution (CR#OE00178470) generates 'PSC-init' and 'PSC-end'
messages on trigger execution. Modified DataServer code gets these messages
using SQLFetch()- SQLError - api calls for 2 times. Observed that SNAC-10
driver is not returning the PSC-end message as part of the 2nd time SQLFetch()
with SQLError()- API calls.

This is a 3rd party SNAC-10 driver issue. Confirmed the same by using a sample
ODBC program.

Note: This behavior has NO impact on DataServer functionality. 


Note: OE00192262    Type: Known Issue
DataDirect driver 6.0 does not fetch output parameter from MSS 2008 stored proc
---------------------------------
When Data Direct 6.0 driver is used with an MS SQL Server 2008 database, the
output parameter from a stored procedure is not fetched. This happens only when
using Data Direct driver 6.0 with an MS SQL Server 2008 database. With any
other combination of driver and database, the behavior does not occur.


Note: OE00193909    Type: Product Notice
MS SQL Server 2008 R2 Certified
---------------------------------
The DataServer for MS SQL Server release 10.2B has been certified for MSS 2008
R2 using the following drivers. 
  
(1) Distributed by Microsoft Corporation 
    (a) SQL Server (2000.85.1117.00) - SQLSRV32.DLL  (32-bit) 
    (b) SQL Server (2000.86.3959.00) - SQLSRV32.DLL  (64-bit) 
    (c) SQL Native Client 9 (2005.90.1399.00) - SQLNCLI.DLL (32-bit) 
    (d) SQL Native Client 9 (2005.90.1399.00) - SQLNCLI.DLL (64-bit) 
    (e) SQL Native Client 10 (2009.100.1352.12) - SQLNCLI10.DLL (32-bit) 
    (f) SQL Native Client 10 (2009.100.1352.12) - SQLNCLI10.DLL (64-bit) 
  
(2) Distributed via OpenEdge 10.2B installation 
   (a) Datadirect ODBC Wire Protocol driver for MS SQL Server (6.00.00.37) -
P1MSSS24.DLL (32-bit) 
   (b) Datadirect ODBC Wire Protocol driver for MS SQL Server (6.00.00.37) -
P2MSSS24.DLL (64-bit) 
  
  
This certification asserts that for all features tested, OpenEdge clients
exhibit consistent results using the DataServer for MS SQL Server to connect MS
SQL Server 2008 R2 and	all earlier supported database versions. 


================================================
DataServers - ODBC
================================================


Note: OE00164101    Type: Behavior Change
Dsrv AUTOCOMMIT,1 setting not required for Sybase data source
---------------------------------
In OpenEdge Release 10.2B, migration to a Sybase data source does not require
the -Dsrv AUTOCOMMIT,1 setting. 


Note: OE00176790    Type: Product Notice
IBM Direct Access Driver Support
---------------------------------
IBM native driver (iSeries Access for Windows ODBC) has been certified for the
ODBC DataServer on Windows 32-bit and 64-bit configurations for accessing DB2
on iSeries v5r3 and v5r4.


Note: OE00177729    Type: Behavior Change
No PRGRS_NATIVE_LOCKWAIT warning in dataserv.lg for ODBC DataServers
---------------------------------
Prior to OE 10.2B release, PRGRS_NATIVE_LOCKWAIT warning for ODBC DataServers
was written to the dataserv.lg file. Since this warning message is specific to
MS SQL DataServers, it can be ignored in the ODBC DataServer and will no longer
be written to the log file in case of ODBC DataServers


Note: OE00179889    Type: Limitation
iSeries Access ODBC Driver Uses Default Userid and Password During Connection
---------------------------------
Customers should note that the iSeries Access ODBC driver saves the iSeries
navigator userid and password by default in the registry and they will be able
to connect to the ODBC DataServer without providing any userid and/or password
after the first time they have entered these details. This might be a security
concern to some customers. 

The default selection for 'Default user ID' under 'Connection Options' in the
'General' tab of the DSN created using iSeries Access ODBC driver is 'Use
iSeries Navigator default'. This selection saves the userid and password
entered once by the user. This is the default behavior and users are advised to
modify this selection if they do not want to store the default userid and
password. For more information, refer to the following IBM literature:
http://www-912.ibm.com/s_dir/slkbase.NSF/515a7ef1f8deef8c8625680b00020380/4900f
22587d32ed486256bdf0063a62f?OpenDocument


Note: OE00184576    Type: Limitation
DataDirect 5.3 DB2 wire protocol driver error when field data size is 512 char
---------------------------------
DataDirect 5.3 DB2 wire protocol Driver is expected to issue a general
protection fault when any table field is 512 characters. Any data less than or
more than 512 characters works as expected. 

Latest DataDirect DB2 driver dll version that does no have this issue is
5.30.00.182.


Note: OE00185808    Type: Behavior Change
Dataserver switch ZPRGRS_RECID_BUF_SIZE enhanced
---------------------------------
In OpenEdge versions 10.2B and 10.2A02, the limit on Dsrv ZPRGRS_RECID_BUF_SIZE
switch value has been extended and can now range from 44 to 1024 bytes for both
MS SQL Server and ODBC DataServers.


================================================
DataServers - ORACLE
================================================


Note: OE00150026    Type: Limitation
Oracle support with HP 32-bit product is dropped
---------------------------------
The last Oracle client that supports HP 32-bit is Oracle 8 which no longer
works with OpenEdge starting with 10.1C.  Any customer that needs to use Oracle
on HP must migrate to the HP 64-bit product.  The HP 64-bit product works on
all modern HP PA-RISC hardware.  Please contact your sale represntative if you
need to make this platform version change.


Note: OE00159050    Type: Behavior Change
Oracle DataServers default name spawned by the Unified Broker has changed
---------------------------------
As defined by the srvrExecFile attribute, the ubroker.properties default Oracle
Server executable spawned for Unified Broker Oracle DataServer broker instance
has changed from "_ora7srv.exe" to "_orasrv.exe" for Windows platforms and from
"_ora7srv" to "_orasrv" for Unix platforms.


Note: OE00166447    Type: Product Notice
Default behavior for client/server mode after INDEXED-REPOSITION has changed.
---------------------------------
The -Dsrv SRV-GET-PREV startup switch is now obsolete. 

In versions prior to 10.2B, the -Dsrv SRV-GET-PREV switch was required 
in order to instruct the Oracle DataServer to generate new SQL for 
Oracle that could satisfy a GET PREV request following a repositioned 
result set using the INDEXED-REPOSITION phrase. Without this switch, a 
GET PREV request immediately following an INDEXED-REPOSITION, in 
client/server mode, may erroneously find the NEXT rather than the 
PREVIOUS record.

Starting in 10.2B, the Oracle DataServer allows the GET PREV request to 
be correctly satisfied by default when requested subsequent to an 
INDEXED-REPOSITION. Due to improvements made to client caching, it may 
not be necessary to generate new SQL to satisfy a GET PREV request. 
These changes have resulted in the SRV-GET_PREV switch becoming obsolete 
so that it no longer affects application behavior.


Note: OE00167988    Type: Behavior Change
Date picture format validation for Oracle DATE mapped to OE Datetime(Char)
---------------------------------
DataServer for Oracle previously reported an Oracle Database error for a Date
column value that was not in the Oracle Session format 'YYYYMMDD[HH24MISS]'.
Sending an invalid date value to the server and receving a foreign database
error increased turnaround time for a request.

Beginning with OpenEdge Release 10.2B, DataServer for Oracle optimizes the
request for an invalid date value and reports an error for an invalid Date
format value from the client layer instead of sending the invalid date value to
the server, resulting in less turnaround time for a request but causing a
change in behavior for encountering the error condition.


Note: OE00169288    Type: Behavior Change
CLOB support limitations restricted in 10.2B
---------------------------------
New CLOB support in 10.2B includes:
1. LONGCHAR data types can now be passed as parameters to stored procedures.
2. CLOBs can now be defined in result sets that map to an Oracle VIEW record
format.
3. CLOBs can now be defined in result sets that map to temp table record
formats using LOAD-RESULTS-INTO with the RUN STORED-PROC command.
4. CLOBs can now be defined in result sets using LOAD-RESULTS-INTO with the RUN
STORED-PROC and an indeterminate temp table array handle.


Note: OE00170470    Type: Behavior Change
Oracle NLS TIMESTAMP/TIMESTAMP-TZ format support
---------------------------------
In OpenEdge Release 10.2A, if the Oracle DATETIME data types TIMESTAMP,
TIMESTAMP WITH TIME ZONE (TSTZ) and TIMESTAMP WITH LOCAL TIME ZONE (TSLTZ) were
mapped to OpenEdge CHARACTER data type in the schema holder, you were
restricted to assign and retrieve a DATETIME value to a column in a fixed
character format in your DataServer application.

In OE 10.2B Oracle DataServer is enhanced to remove the restriction of fixed
character formats and allows you to store and retrieve DATETIME values in the
NLS format of the Oracle client session of your DataServer application. This
assumes that you will be aware of the NLS TIMESTAMP/TIMESTAMP-TZ format of
their Oracle DataServer session. 

To better understand this behavior change, consider the following example in
which an Oracle Database has a table named 'testtab' with a column named
'testcol' of data type TSTZ and 'testcol' column is mapped to OpenEdge
CHARACTER after a PULL operation.

Previous to OE 10.2B, you were restricted to assigning a DATETIME-TZ value to
the 'testcol' column in a fixed format (YYYYMMDDHH24MISSTZH:TZM) and used the
following command to create a testtab record with a DATETIME-TZ value of
(2009/11/24 23:24:25.321 -04:00)

create testtab.
assign testcol = '20091124232425321-04:00'.

In OpenEdge Release 10.2B, you are allowed to send a value from OpenEdge client
in Oracle NLS format of your Oracle DataServer session. So to create a record
in 'testtab' table with same DATETIME-TZ value, you assign a DATETIME-TZ value
to 'testcol' field as follows:

create testtab.
assign testcol = '24-NOV-2009 11.24.25.321 PM US/Pacific'. 

where the Oracle Session parameter NLS_TIMESTAMP_TZ_FORMAT for the DataServer
session is assumed as 'DD-MON-RR HH.MI.SSXFF AM TZR' that is derived from
NLS_TERRITORY as 'AMERICA'.

If the Oracle Session parameter NLS_TIMESTAMP_TZ_FORMAT is different or changed
by the DataServer application to 'DD/MM/YYYY HH24:MI:SSXFF TZH:TZM' then the
DATETIME-TZ value should be provided as 

create testtab.
assign testcol = '24/11/2009 23:24:25.321 -04:00'.

The same rule applies to Oracle TIMESTAMP and TSLTZ data type that are mapped
to OE CHAR datatype.

The validation of the DATETIME value is deferred to the Oracle Database, so if
you send a DATETIME/DATETIME-TZ value that is not compatible to the Oracle
DATETIME session parameters for the DataServer session, the validation error
recieved by the OCI interface will be reported by the Oracle DataServer.


Note: OE00180196    Type: Product Notice
Buffer storage optimization for NUMBER columns in Oracle DataServers
---------------------------------
The Oracle DataServer translates numeric data types from Oracle as NUMBER
columns and then stores the character format of that NUMBER in OpenEdge record
buffers when used in an OpenEdge application.

Prior to changes for this fix, the Oracle DataServer used a fixed length buffer
size of 41 bytes to store the native Oracle type in an OpenEdge buffer column. 
This translation expands the storage requirements of the column in the OpenEdge
record buffer.	This may lead to unexpected overflow when an OpenEdge record
approaches the maximum record size of 30,000 bytes.

To minimize the expansion requirements, the Oracle DataServer now optimizes
buffer storage for NUMBER columns by considering the precision and scale of the
NUMBER column before expanding for character translation.  This means that
NUMBER columns whose precision and scale require less than 41 bytes in
character format will now be reduced in size.  41 bytes will still remain the
maximum translation size for a NUMBER column.  Please refer to the following
examples:

(1) NUMBER(1) -> buffer storage size is now 4 (previously it was 41)
(2) NUMBER(3,7) -> buffer storage size is now 10 (previously it was 41)
(3) NUMBER(10,-9) -> buffer storage size is now 22 (previously it was 41)
(4) NUMBER(*,10) -> buffer storage size is now 41 (previously it was 41)
(5) NUMBER  -> buffer storage size is now 41 (previously it was 41)
(6) FLOAT(5) -> buffer storage size is now 41 (previously it was 41) 


Consider NUMBER(p,s): When both 'p' and 's' are specified, buffer storage is
the size of whichever is the maximum, either 'p' or 's', plus 3 bytes (for the
sign, radix and NULL terminator).  When 's' is negative, storage size is the
sum of 'p' and the absolute value of 's' plus three (for the sign, radix and
NULL terminator).  If neither 'p' nor 's' is specified, or if the native column
is a floating point number, buffer storage will be 41 bytes.

Note:-
Stack overflow errors are most likely when dealing with very large tables.
Please increase stack size using '-s' startup parameter on getting stack
overflow errors.


Note: OE00181807    Type: Workaround
A new -Dsrv switch has been introduced
---------------------------------
The Oracle DataServer normally treats warnings received from Oracle as error
conditions and handles them as such.  Some Oracle DataServer applications may
either anticipate or want to overlook certain warning conditions returned from
Oracle.

Available in 10.2B, a new -Dsrv switch PRGRS_WARNING_SUPPRESSION has been added
to the Oracle DataServer.  The objective of this switch is to suppress the
Oracle warning codes specified by the user at connection time.	Users can
provide a maximum of 25 Oracle warning codes per connection with this new -Dsrv
switch.  The feature is not available by default so that backward compatibility
is maintained.	Warnings continue to be treated as errors by default.

Usage:
-Dsrv PRGRS_WARNING_SUPPRESSION,XXXXX,YYYYY;
where
 XXXXX,YYYYY are Oracle error codes(warnings). When supplying multiple error
codes use commas to separate them. Semicolon(;) at the end is optional.

For example:
-Dsrv PRGRS_WARNING_SUPPRESSION,24347 
This will suppress the Oracle error code ORA-23437(which is treated as warning
by Oracle).

Notes: 
1. The error codes will be suppressed ONLY IF Oracle treats them as warnings. 
Non-warning errors cannot be suppressed.
2. Error codes added to the PRGRS_SUPPRESS_WARNINGS list are unconditional. 
This means that wherever the warning occurs and by whatever means the Oracle
database produced it, it will be supressed by the DataServer. 
3. Not all OCI calls are testing for warning conditions.  If you enter a
warning error code for the PRGRS_SUPPRESS_WARNINGS switch that is not being
suppressed, contact technical support to have suppression expanded to the OCI
call that caused your warning condition.


Note: OE00194151    Type: Known Issue
Random Oracle error 3124 after upgrading to Oracle 11
---------------------------------
After upgrading Oracle to Version 11, you might encounter error ORA-03124:
"two-task internal error ---- (14944)" while running an application using the
OpenEdge DataServer for Oracle.  This message may get displayed to the screen,
or wherever I/O is redirected by your application, but is not written to the
DataServer log file (dataserv.lg).  Oracle has confirmed that the problem
resides in the OCI 11.1 driver and provides the following explanation and work
around:

Bug 8222774  "ORA_3124 PERFORMING SELECT , INSERT IN OCI 11.1"

Cause:
This issue occurs when an incorrect value is set for the init parameter "named
_enable_row_shipping". The value should be set to FALSE.  In Oracle version
10.2, for instance, this parameter is disabled by default but in Oracle 11g it
is turned on.  

Workaround:

Add the following line to your "init.ora" file and restart your Oracle
database:

       "_enable_row_shipping=FALSE"

An internal OpenEdge Kbase on this issue is filed under Progress ID: P155898.
Refer to bug number 8222774 with Oracle Support for further guidance on the
version, the platform, additional workarounds and any further bug explanation
needed.


================================================
Documentation - 
================================================


Note: OE00146970    Type: Known Issue
Microsoft Security Update may affect remote access of Online Help
---------------------------------
If you receive the following error when accessing the help remotely: 
"Action cancelled Internet Explorer was unable to link the web page you
requested. The page might be temporarily unavailable", see the Microsoft
Knowledge Base article titled: "Certain Web sites and HTML Help features may
not work after you install security update 896358 or security update 890175"
located at http://support.microsoft.com/kb/892675/. The article describes the
reasons for the issue and provides workarounds.


Note: OE00146971    Type: Known Issue
Online Help unavailable for editor's dialog boxes
---------------------------------
Online help for dialog boxes in the Procedure Editor is not available. The Help
buttons on the dialog boxes do not work because the color-coding editor control
only supports MicrosoftRTM WinHelp (.hlp) files and not MicrosoftRTM  HTML
(.chm) files.


================================================
Documentation - Electronic Documentation
================================================


Note: OE00146978    Type: Known Issue
Search of PDF files for UNIX Platforms
---------------------------------
On UNIX platforms, the search index is not automatically attached to the
documentation PDF files.  To attach the index file so that you will have search
capabilities, follow these steps:
 1. From the Adobe Acrobat Reader, click on the Search icon.  The Adobe Acrobat
Search dialog box appears.
 2. In the Adobe Acrobat Search dialog box, click on the Index button and
choose Add.
 3. From the drop down list of files, select the oeidx.pdx file and choose OK.


================================================
Documentation - Help
================================================


Note: OE00146973    Type: Known Issue
Accessing online help for CSSPIN ActiveX Control
---------------------------------
If you press F1 to get help on the CSSPIN ActiveX Control, you will get an
error indicating it cannot find the help file. To access the help for the
CSSPIN ActiveX Control, do the following:
 1. Select Start->Program->OpenEdge->Help. The OpenEdge Online Help file
appears.
 2. In the left pane, double-click the ActiveX Control Help folder to expand
it.  Then, select the CSSpin Control help topic.


Note: OE00146975    Type: Known Issue
Accessing online help for CSCOMBO ActiveX Control
---------------------------------
If you press F1 to get help on the CSCOMBO ActiveX Control, you will get an
error indicating it cannot find the help file. To access the help for the
CSCOMBO ActiveX Control, do the following:
  1.  Select Start->Program->OpenEdge->Help. The OpenEdge Online Help file
appears.
  2.  In the left pane, double-click the ActiveX Control Help folder to expand
it.  Then,   select the CSCombo Control help topic.


Note: OE00146976    Type: Known Issue
Non-existing examples mentioned in online help for CSSPIN
---------------------------------
The CSSpin Active X Control Help file mentions the following example:
   Example Location 
   Project File Form/Basic File
   SPINDEMO.VBP SPINDEMO.FRM
These example files do not exist.


================================================
Graphical User Interface - ABL
================================================


Note: OE00165299    Type: Behavior Change
ASSIGN on unmodified hidden editor moves data to record/variable
---------------------------------
If there is no data in the screen field, the ASSIGN statement does not move
data into a field or variable. There is no data in the screen field unless you
enter data in the screen field or DISPLAY data to that field. For example,
using an ASSIGN statement on an unmodified and hidden editor should not move
data into a target field or variable. 

However, in previous releases, the ASSIGN statement moved the Unknown value (?)
into the target. Release 10.1C01 fixes this incorrect behavior. You should
examine any application that might have relied on the previous behavior.


================================================
Graphical User Interface - ActiveX
================================================


Note: OE00178648    Type: Behavior Change
ENABLE-EVENTS can now generate an error message
---------------------------------
The ENABLE-EVENTS method on an ActiveX automation object returns a LOGICAL
value to indicate if it succeeded or failed.  Prior to Release 10.2B if the
method failed, there was no way to know what caused the failure.  For 10.2B an
error message is generated that contains more specific information. Your
application must use NO-ERROR or a CATCH-BLOCK if it needs to suppress the
error message.


================================================
Management - 
================================================


Note: OE00146518    Type: Known Issue
Working with Properties
---------------------------------
If an "-Xbootclasspath:", "-Xbootclasspath/a:", or "-Xbootclasspath/p:" entry
that contains spaces in the argument value has been added to the
JavaTools.properties or AdminServerPlugins.properties file, the entry must be
manually edited to include quotes around the entire argument value (value to
the right of the colon).


Note: OE00146951    Type: Known Issue
Random errors with mapped drives on MSW
---------------------------------
Due to Microsoft Knowledge Base Article #294816, we do not support the running
of a Progress application from a Network Share for Windows Terminal Services or
Citrix running on Windows 2000 Server or Windows 2000 Advanced Server. Terminal
Services users might see errors like "Disk or Network Error" or "C0000006: In
Page I/O Error", etc.  This happens due to a bug in the Windows operating
system where the network redirector only creates one file control block (FCB)
for all user connections so that when the first user to open the files logs
off, the other users lose their connections to files. To work around this
problem, place the program and associated data files on a localvolume, not
network share.


Note: OE00146953    Type: Known Issue
Error when default language not installed
---------------------------------
While adding a product after an installation has been completed, if you attempt
to change the default language to a language that has not yet been installed,
and the language is one listed with a non-alphabetic character (e.g. -, (, ))
an error will result that will not accurately reflect the problem. The error
should not prevent the installation from continuing. This problem is apparent
on Windows/NT platforms only and does not occur on UNIX.  The workaround is to
select entries from the pull-down list boxes.


Note: OE00146954    Type: Known Issue
Uninstall fails with Proshell.dll in use
---------------------------------
The uninstall will fail if any of the files it attempts to remove are busy. Use
of the Windows Explorer has been known to cause this condition of rendering the
file proshell.dll as in use, thus preventing the uninstall from succeeding,
however this may not be obvious at the time of uninstall.


Note: OE00146959    Type: Known Issue
ubroker.properties file is renamed ubroker.properties-sav
---------------------------------
When uninstalling the ubroker.properties file is renamed ubroker.properties-sav
and copied to the temp directory.


Note: OE00146965    Type: Known Issue
Cannot use an older version of PROMSGS with a current release
---------------------------------
Through the automated OpenEdge installation process, Progress Software
Corporation programmatically ensures that a current OpenEdge installation has
the most recent OpenEdge messages in the PROMSGS files. This approach also
ensures that you always have the most up-to-date OpenEdge messages throughout a
release's lifecycle. Do not perform any tasks related to the PROMSGS files
outside of the standard OpenEdge installation process; for example, attempting
to use the PROMSGS environment variable to point to any versions of a PROMSGS
will have unpredictable and potentially undesirable results.

For example, the PROMSGS files installed with the OpenEdge Release 10.1B
contain the most up-to-date messages to support OpenEdge Release 10.1B. After
the initial install, if you install add-on products, or OpenEdge install
service packs that are released after the 10.1B Release date, Progress again
programmatically provides any newer or more recently updated PROMSGS files. As
each OpenEdge add-on product or service pack is installed, the installation
program checks to ensure that the newest copy of the PROMSGS file is being used
by all products.


================================================
Message Number Change - 
================================================


Note: OE00154296    Type: Behavior Change
Message number change for message 13682
---------------------------------
To aid in problem diagnosis, the message number for message 13682 has changed
to 15747. Whenever diagnosis information is unavailable, error 13682 will
continue to be displayed.


================================================
Open Client - .NET
================================================


Note: OE00129730    Type: Behavior Change
Correct Behavior for CancelAllRequests() with .NET Open Client
---------------------------------
When calling CancelAllRequests(), an exception is now generated indicating that
a STOP has been received from the AppServer. This behavior is the intended
behavior and is compatable with the Java Open Client. In previous releases,
this API call would wait until a fixed timeout occurred before returning.


Note: OE00180718    Type: Behavior Change
OpenClient DLLs available in a strongly named but digitally unsigned version
---------------------------------
OpenEdge now ships a third version of the following OpenClient DLLs for
applications that need strongly named DLLs that are not digitally signed:

Progress.ssl.dll
Progress.o4glrt.dll
Progress.Messages.dll

These DLLS are located in the following directory:

<InstallDir>/dotnet/deploy/strongnamed. 

These new DLL versions are shipped in 10.1C04, 10.2A02, and 10.2B.

To support this choice, the ProxyGen tool was updated and made available in the
10.1C04 and 10.2A02 service packs, as well as version 10.2B.

The new version of ProxyGen replaces the "Use Strong-named Runtime" checkbox in
the .NET tab with a combo box. The combo box provides the following three
choices:

Digitally Signed
Strongnamed Signed
Strongnamed
	 
The new combo box is initially be set to "Digitally Signed", which is the
default behavior.


================================================
Open Client - Dynamic API
================================================


Note: OE00098615    Type: Behavior Change
Dates between ABL and .NET are now accurate
---------------------------------
All dates going from .NET to ABL and from ABL to .NET will be exactly the same
except for 12 days. These are the dates 2/29 in the leap years that are
represented by the Julian Calendar (on the Progress side) but not represented
by the Gregorian Calendar (on the .NET side).  
(Since the Gregorian Calendar was not created until 10/15/1582, the .NET
DateTime implementation is not correct.)
    
These dates are:
2/29/100
2/29/200
2/29/300
2/29/500
2/29/600
2/29/700
2/29/900
2/29/1000
2/29/1100
2/29/1300
2/29/1400
2/29/1500


================================================
Open Client - Proxygen
================================================


Note: OE00099231    Type: Known Issue
.NET Proxy and Client application must use same .NET version
---------------------------------
The .NET Framework requires that the .NET proxy and .NET client application are
built using the same version of the .NET Framework. ProxyGen determines the
version of the .NET Framework to use by examining the Windows registry. It
selects the latest version of the framework installed on the system running
ProxyGen. You can determine the version of the framework used by looking at the
bottom of the log file output by ProxyGen during generation. You will see an
entry similar to the following:

Compiling .NET proxies and creating .dll ...
\\server\i_100b_nt\dlc\bin\PathFinder /csc 
C:\WINDOWS\Microsoft.NET\Framework\v1.1.4322\csc /t:library 
"/r:\C:\Progress\OpenEdge\dotnet\Progress.o4glrt.dll" 
/out:C:\DynTTest\AppServerCode\DynTTest\proxy\nsDynTT\DynTTAO.dll 
C:\DynTTest\AppServerCode\DynTTest\proxy\nsDynTT\DynTTAO.cs C:\ 
DynTTest\AppServerCode\DynTTest\proxy\nsDynTT\AssemblyInfo.cs 

The text "v1.1.4322" above shows the version of the .NET framework used to
build the proxy. In this case it was version 1.1. If you have more than one
version of .NET installed on your system, you need to make sure that the client
application is built using the same version of the framework that was used to
generate the proxy. In the above example, you must build your client
application using version 1.1. If you had wanted to build your client
application using version 1.0, you would need to customize the version of the
framework used by ProxyGen. You can do this by specifying the full path to the
1.0 version of the C# compiler (csc.exe) and the XSD generator (xsd.exe) on
your system on the .NET tab of the Generate dialog in ProxyGen. Select	
the Custom Compiler radio button and enter the required information. For
example, enter the following Compiler Command:

C:\WINDOWS\Microsoft.NET\Framework\v1.0.3705\csc.exe 

You need to use the path specific to the 1.0 installation on your machine. The
text above shows the version of the .NET framework for 1.0. You need to change
this value to match the installation on your machine. You can determine the
correct value by looking for the path in the File Explorer or by looking in the
Windows registry at:

HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework\policy\v1.0

and enter the following XSD Generator:

C:\Program Files\Microsoft Visual Studio .NET\FrameworkSDK\Bin\xsd.exe

For version 1.0, you can determine the correct value for the path by looking in
the Windows registry at: 

     HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework\sdkInstallRoot 
 For version 1.1, you need to look on the Windows registry at: 
    
     HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework\sdkInstallRootv1.1 

In both cases, you would append the value found in the Windows registry with
"Bin\xsd.exe" to get the full path to the XSD Generator required by ProxyGen.
Caution: If you try to run using a proxy built with one version of the
framework and a client built using another version of the framework, you will
get runtime errors including "Specified cast is not valid."


Note: OE00147594    Type: Known Issue
Supporting localized messages for .NET client interfaces
---------------------------------
When ProxyGen builds a .NET proxy, it copies the required .NET runtime 
assemblies to the proxy generation output directory, but it does not copy any
Progress.Messages.resources.dll files. By default, Progress.Messages.dll
provides English as the default language resource. If you need to support a
different language resource, you must manually copy the desired language
resource file from:

      <OpenEdge_install_directory>\dotnet\deploy\strongnamed-signed   or
      <OpenEdge_install_directory>\dotnet\deploy\signed

depending upon your generation option.

For example, if you want to support a French deployment for a signed-only
environment, copy the fr directory from
<OpenEdge_install_directory>\dotnet\deploy\signed to your proxy generation
output directory.


================================================
Open Client - Web Services Provider
================================================


Note: OE00161041    Type: Limitation
Multiple Dataset parameters and RPC Encoded Web Services with Axis java clients
---------------------------------
When defining multiple INPUT DATASET parameters for an OpenEdge web service
that uses RPC/Encoded SOAP messages, do not use the NAMESPACE-URI option in the
DEFINE DATASET statements.

The Apache Axis Java client does not properly handle namepsace declarations
when it sends a SOAP request for an RPC/Encoded SOAP message. As a result, an
incorrect message will be sent and the data will not be loaded into the
ProDataSet.

Axis may have similar issues with OUTPUT DATASET parameters. SOAP responses
from OpenEdge may not be properly deserialized.

If the NAMESPACE-URI option is required, then either define the OpenEdge Web
service to use Document/Literal or RPC/Literal SOAP messages. Alternatively,
avoid the issue by passing only one dataset in the Web service call.


================================================
OpenEdge Architect - 
================================================


Note: OE00175229    Type: Product Notice
Saxon Product Notice
---------------------------------
OpenEdge includes XML Tools, which includes versions 8.9 of the Saxon XSLT and
XQuery Processor from Saxonica Limited	(http://www.saxonica.com/) which are
available from SourceForge (http://sourceforge.net/projects/saxon/).  The
Original Code of Saxon comprises all those components which are not explicitly
attributed to other parties.  The Initial Developer of the Original Code is
Michael Kay. Until February 2001 Michael Kay was an employee of International
Computers Limited (now part of Fujitsu Limited), and original code developed
during that time was released under this license by permission from
International Computers Limited. From February 2001 until February 2004 Michael
Kay was an employee of Software AG, and code developed during that time was
released under this license by permission from Software AG, acting as a
"Contributor". Subsequent code has been developed by Saxonica Limited, of which
Michael Kay is a Director, again acting as a "Contributor". A small number of
modules, or enhancements to modules, have been developed by other individuals
(either written especially for Saxon, or incorporated into Saxon having
initially been released as part of another open source product). Such
contributions are acknowledged individually in comments attached to the
relevant code modules. All Rights Reserved.  The contents of the Saxon files
are subject to the Mozilla Public License Version 1.0 (the "License"); you may
not use these files except in compliance with the License. You may obtain a
copy of the License at http://www.mozilla.org/MPL/ and a copy of the license
can also be found in the "licenses" directory located in the OpenEdge
installation directory.  Software distributed under the License is distributed
on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or implied.
See the License for the specific language governing rights and limitations
under the License.


Note: OE00175234    Type: Product Notice
Xs3p Product Notice
---------------------------------
OpenEdge includes XML Tools, which includes Xs3P v1.1.3. The contents of this
file are subject to the DSTC Public License (DPL) Version 1.1 (the "License");
you may not use this file except in compliance with the License. A copy of the
license can be found in the "licenses" directory located in the OpenEdge
installation directory. Software distributed under the License is distributed
on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or implied.
See the License for the specific language governing rights and limitations
under the License. The Original Code is xs3p. The Initial Developer of the
Original Code is DSTC. Portions created by DSTC are Copyright (c) 2001, 2002
DSTC Pty Ltd. All rights reserved.


Note: OE00183236    Type: Known Issue
Shutting down OpenEdge Architect when a console is active generates exceptions
---------------------------------
If there is an active console for a process when OpenEdge Architect is shut
down,	the .log file  for the workspace will contain many exceptions. These
exceptions are harmless and can be ignored. This is an Eclipse bug which is
listed as fixed in version 3.5.


Note: OE00187505    Type: Limitation
Modifying ProDataSet definitions in include files causes compile errors
---------------------------------
If a ProDataSet is defined in an include file  and is used as a parameter for a
method called from multiple .cls files, any modification to the dataset
definition results in the failure of each .cls to compile.  

To work around the issue, remove all existing r-code compiled from the .cls
files that references the include file that contains a modified ProDataSet
definition.


Note: OE00188215    Type: Known Issue
Null Pointer Exception can appear in AppServer .log file
---------------------------------
You can display a broker log file or a server log file for an active AppServer
from the Console view. (To access the Console from the Servers view, select a
specfic active AppServer, right-click, and choose Show In and then Console.) If
the AppServer was started outside of OpenEdge Architect, a NullPointerException
is recorded in the .log file for the workspace. This exception is related to
Eclipse WTP code and is fixed in WTP Version 3.1.


Note: OE00190889    Type: Known Issue
OpenEdge Architect may crash on startup in some configurations
---------------------------------
OpenEdge Architect may crash on startup under certain conditions. Opening
OpenEdge Architect with the -clean option for each workspace usually solves the
problem. 

If you are running the Eclipse that ships with OpenEdge Architect, use the
"OpenEdge Architect Clean" shortcut from the program menu. If you are running
OpenEdge Architect under an external instance of Eclipse, you can create a
shorcut to the eclipse.exe you are running and add the -clean argument to the
startup parameters.


Note: OE00193035    Type: Known Issue
Summary not available in Class Browser for methods with generic type arguments
---------------------------------
In the Class Browser, summary information is not displayed for methods in
generic classes that accept generic types as arguments.


================================================
OpenEdge Architect - AppBuilder Support
================================================


Note: OE00191910    Type: Known Issue
Configuring Appbuilder short cut keys when using an external Eclipse
---------------------------------
You can run OpenEdge Architect either under the Eclipse workbench that it ships
with or under an external Eclipse workbench.  If you run OpenEdge Architect
under an external Eclipse, you must perform the following configuration tasks
before enabling AppBuilder short cut keys:

1. Navigate to OpenEdge-install-dir/oeide/eclipse/plugins (the plug-ins folder
of the default OpenEdge Architect Eclipse workbench). 

2. Copy the folder com.openedge.keybinding.hook and the file
com.openedge.keybinding.hook_1.0.0.jar to the ../eclipse/plugins folder of the
external Eclipse workbench.

3. Open ../eclipse/configuration/config.ini in the external Eclipse
installation with a text editor. 

4. Set osgi.framework.extensions=com.openedge.keybinding.hook. 

When you restart the external Eclipse workbench, you can enable AppBuilder
shortcut keys.


Note: OE00192542    Type: Known Issue
Untitled AppBuilder files are created in .sharedavm directory and do not open
---------------------------------
AppBuilder creates "untitled" files when you select a template from the
File/New dialog. For example File/New/Blank might create a file named
Untitled0.html. 

When an OpenEdge project uses a shared AVM, these untitled AppBuilder files are
created in the .sharedavm directory in the workspace, rather than in a
directory in the project. In addition, the files do not open in the editor.

You can import the .sharedavm folder into your project in order to open the
untitled files.


================================================
OpenEdge Architect - Debugger
================================================


Note: OE00173335    Type: Known Issue
Architect Debugger may fail with a large number of breakpoints
---------------------------------
If you are debugging a program in which you have set a large number of
breakpoints, you might find that the OpenEdge Architect Debugger produces a
memory violation. The number of breakpoints at which the violation occurs is
dependent on several different factors, including the length of source file
names.


================================================
OpenEdge Architect - Editing
================================================


Note: OE00153282    Type: Behavior Change
ABL code generated from template code will now follow casing preference
---------------------------------
All ABL code created by template (macro) expansion and by OpenEdge Architect
code-generation wizards now conforms to the user-specified keyword casing
preference for the workspace.


Note: OE00163724    Type: Workaround
Auto casing doesn't work for Mouse events
---------------------------------
The option to apply your keyword casing preference automatically as you type
(selectable on the OpenEdge Architect Editor preferences page) does not work
for mouse events (for example, MOUSE-SELECT-DOWN, MIDDLE-MOUSE-CLICK). Use the
Correct Case command (Ctrl+Shift+F)  to apply the casing preference to
mouse-event keywords.


Note: OE00179432    Type: Product Notice
ABL Compare Editor font preference
---------------------------------
"ABL Compare Editor Font" was added to the Text Compare preference choices
(Window -> Preferences -> General -> Appearance -> Colors and Fonts -> Text
Compare).  You can use this preference to override the default font setting. 


Note: OE00184434    Type: Known Issue
Errors in generated code that overrides or implements indexed properties.
---------------------------------
ABL does not support overriding or implementing indexed properties. If you use
the New ABL Class wizard to generate code that overrides or implements indexed
properties, compilation errors will result. 


Note: OE00190678    Type: Known Issue
Code generation problems with APPEND and PRESELECT options
---------------------------------
When overriding a method that has APPEND or PRESELECT options, generated code
will not include these options and therefore will not compile.	


Note: OE00193628    Type: Known Issue
Some OpenEdge Architect events are not being published as expected
---------------------------------
Some events (which are described in the "Subscribing to OpenEdge Architect
events" topic in the online help) are not being published as expected.

The events and the cases when they are not published are:

1. After-save and Before-save events when class files are opened in Visual
Designer.

2. Before-run, After-run, Before-debug, and After-debug events when running or
debugging any .p or .cls file.

3. Before-compile, After-compile, Before-save, and After-save events when
saving T4BL files.

4. Before-compile and After-compile events when saving an AppBuilder file in
the Design view.


================================================
OpenEdge Architect - Project
================================================


Note: OE00186574    Type: Behavior Change
Class launcher generated by OpenEdge Architect catches application exceptions
---------------------------------
When it runs a class, OpenEdge Architect generates a small launcher program to
instantiate the class.	This launcher program now contains a CATCH block that
will display messages from any exceptions that are thrown by the constructor of
the class.


Note: OE00186751    Type: Behavior Change
OpenEdge run configurations no longer default to "Launch in background"
---------------------------------
Newly created OpenEdge Application run configurations no longer have  the
"Launch in background" option on the Common tab selected by default.  This
change does not affect existing run configurations.


Note: OE00192604    Type: Known Issue
Properties view is blank after converting a project to use a shared AVM
---------------------------------
If a form is open when you convert a project to use a shared AVM, the
Properties view becomes blank. Close and reopen the form to refresh the
Properties view.


Note: OE00193427    Type: Known Issue
Error dialog displays when migrating workspaces from 10.2A to 10.2B
---------------------------------
If you open a 10.2A workspace that contains open ABL forms, dialogs, MDI forms,
or user controls in OpenEdge Architect 10.2B, an error occurs during migration
of assemblies.


================================================
OpenEdge Architect - Visual Designer
================================================


Note: OE00174709    Type: Known Issue
SmartTag remains open when switching between editor tabs
---------------------------------
An open SmartTag for a control remains visible even after focus switches from
the design view to the source view or to another editor buffer. Press the Esc
key to close the SmartTag.


Note: OE00175524    Type: Limitation
ProBindingSource Designer does not support recursive relationships
---------------------------------
It is not possible to use the ProBindingSource Designer in the Visual Designer
to define a recursive relationship or to import an XSD file that contains a
recursive relationship. To set up recursive relationships, you must write ABL
code.


Note: OE00176460    Type: Known Issue
Delete key in UltraToolBar deletes entire control, not just tool
---------------------------------
When working with an UltraToolbarsManager control, selecting a toolbar item and
pressing the Del key deletes the entire control instead of the selected item.

To avoid this problem, use the Delete command on the context (right-click) menu
instead of the keyboard.


Note: OE00176744    Type: Known Issue
Ellipsis for UltraExplorerBar Groups collection disappears from property grid
---------------------------------
After you edit the collection associated with the Groups property of an
UltraExplorerBar control, the ellipsis (...) button may no longer be available
for that property in the Properties view, so that you cannot re-open the
Designer for the control by clicking the button.

To work around this issue, open the UltraExplorerBar Designer from either the
control's SmartTag or the link at the bottom of the Properties view.


Note: OE00184858    Type: Known Issue
Visual Designer unable to open a derived .cls file after it is moved
---------------------------------
When you move a .cls file that inherits from another .cls file to a different
directory, the ABL compiler generates r-code for both the base class and the
derived class. The result can be multiple copies of r-code for the base class
in multiple directories. Due to PROPATH settings,
the AVM may find r-code in a directory that is not appropriate for the base
class and will not be able to open the derived .cls file.

To work around the issue, refresh all projects in the workspace and be sure to
remove all the extra copies of	r-code for base classes.


Note: OE00188449    Type: Known Issue
Cannot drag and drop database schema to control on non-first page of TabControl
---------------------------------
Drag-and-drop of a database schema source fails (that is, the ProBindingSource
Designer does not open) if the target is a control on a page within a Microsoft
TabControl, and that page is not the first tab.


Note: OE00188453    Type: Known Issue
Visual Designer hangs when certain controls are added to TabControl
---------------------------------
Adding an UltraCombo, UltraTextEditor, or any of certain other complex controls
to the second tab of a Microsoft TabControl that is part of a form, and then
traversing between tabs, causes OpenEdge Architect to hang.

To work around the issue, add the UltraCombo (or other control) to an ABL User
Control, and add the User Control to the tab; or, add the UltraCombo
programmatically to the tab without using Visual Designer-generated code.


Note: OE00188484    Type: Behavior Change
ResourceManager replaces ResXResourceSet for Visual Designer code generation
---------------------------------
The Visual Designer in OpenEdge Architect 10.2B uses a new class called
Progress.Util.ResourceManager to generate references to external resources in
the InitializeComponent method of forms and user controls. This change was made
to properly support the use of multiple .resx resource files. Previous versions
of the Visual Designer used System.Resources.ResXResourceSet, which is limited
to the use of a single .resx resource file.

Since the ResourceManager class does not exist in earlier versions of the
Progress NetUI Assembly, code generated by the Visual Designer is not
compatible with previous versions of OpenEdge. The Visual Designer can still
open and modify forms and user controls from previous versions, and those forms
run as before, but once the form or user control is modified and saved, the
saved code becomes incompatible with previous versions.


Note: OE00189499    Type: Behavior Change
.NET's DestroyHandle method cannot be overridden
---------------------------------
It is longer possible to override the DestroyHandle method of
System.Windows.Forms.Control.


Note: OE00191666    Type: Behavior Change
Code generated by Visual Designer always ignores -zn parameter
---------------------------------
In prior releases of OpenEdge Architect, the Visual Designer generated certain
variable names with the prefix "m_", unless the -zn parameter was used when
starting the AVM, in which case these variable names were prefixed with just
the underscore character (i.e., the "m" was dropped). In 10.2B this behavior
changes such that the "m" prefix is added to any variable name that begins with
an underscore, regardless of whether the -zn parameter is used.


Note: OE00192189    Type: Limitation
ProBindingSource Designer cannot import recursive dataset
---------------------------------
An error occurs if you try to import a dataset containing a recursive
relationship into the ProBindingSource Designer. An error message appears if
the data source is an XSD file; with any other type of data source, however,
the screen simply remains blank.


Note: OE00192934    Type: Known Issue
Properties view does not show events with SIGNATURE syntax
---------------------------------
Only events that are defined with DELEGATE syntax appear in the Visual Designer
Properties view. Events defined with an ABL method signature are not shown.


Note: OE00193019    Type: Known Issue
Inherited image data wrongly added to .resx file
---------------------------------
For an inherited control that uses the default image of the parent control, the
Visual Designer improperly adds the image data to the resources (.resx) file.
Such data should be included in the resources file only if it differs from that
of the parent.


================================================
OpenEdge GUI for .NET - 
================================================


Note: OE00173368    Type: Workaround
Workaround for Elegant Ribbon control and IsolatedStorageException
---------------------------------
The Foss PersistentStateManager class automatically loads and saves application
state in isolated storage, which does not work with the current OpenEdge .NET
bridge architecture.  Setting the
LoadStateAutomaticallyFromIsolatedStorageForDomain property to FALSE disables
the automatic state loading at application startup.  Add this line to your
program that uses the Elegant Ribbon control:

Elegant.Ui.PersistentStateManager:LoadStateAutomaticallyFromIsolatedStorageForD
omain = FALSE.
 
This also means that changes in the quick access toolbar will not be loaded and
saved automatically.  If you need the changes to be kept, manually use the
Load() and Save() methods of the PersistentStateManager class.


Note: OE00180730    Type: Known Issue
ABL extended .NET object subscribed to .NET event may be deleted prematurely
---------------------------------
An ABL extended .NET object subscribed to a .NET event may be deleted
prematurely. This bug can be observed with the following conditions:

- An ABL extended .NET object, for example AForm, is visualized
- A .NET object, for example a button, is not on AForm, but one of AForm's
methods is subscribed as the handler for this button's event.
- There is no reference to the button in the implementation of AForm.

If AForm is closed, and therefore Disposed, and all ABL references to it go
away, it will be deleted even though the button subscription is still
outstanding.  In other words, the button, in essense, still has a reference to
the class due to the subscription.  But this does not prevent the object from
being deleted, as it should.


Note: OE00181806    Type: Behavior Change
All dates exchanged between ABL and .NET are now the same except 12
---------------------------------
All dates going from .NET to ABL and from ABL to .NET will be exactly the same
except for 12 days. These are the dates 2/29 in the leap years that are
represented by the Julian Calendar (on the Progress side) but not represented
by the Gregorian Calendar (on the .NET side).

(Since the Gregorian Calendar was not created until 10/15/1582, the .NET
DateTime implementation is not correct.)

These dates are:

2/29/100
2/29/200
2/29/300
2/29/500
2/29/600
2/29/700
2/29/900
2/29/1000
2/29/1100
2/29/1300
2/29/1400
2/29/1500


Note: OE00183351    Type: Behavior Change
Cannot bind query or buffer to multiple ProBindingSource objects
---------------------------------
You cannot bind a query or buffer to multiple ProBindingSource objects. The
relationship between OpenEdge data sources and the ProBindingSource was not
designed to allow this.

A query or buffer maintains private information to communicate with a
particular ProBindingSource. 

We now throw the following exception if a user tries to bind a query or buffer
to a different ProBindingSource when it is already bound to another
ProBindingSource: 

"Query or Buffer <name> is already bound to another BindingSource".


Note: OE00184734    Type: Behavior Change
Using ProBindingSource with Visual Designer requires use of new constructor
---------------------------------
A new constructor has been added to the Progress.Data.BindingSource class. 
This constructor is used in the InitializeComponent code for a user control
when the ProBindingSource is added to a form or user control from within Visual
Designer.

If your ABL class inherits from Progress.Data.BindingSource and you want to use
this derived class within the Visual Designer, you must implement the required
constructor in your class.  

Existing code will compile and run, but any modifications to a form that
contains a ProBindingSource will cause the Visual Designer to write out code
using the new constructor.

This change will cause the ProBindingSource to be added to the "components"
object that is part of every form and user control, as maintained by the Visual
Designer.  When the form or user control is garbage collected, the components
object will call the Dispose() method of the ProBindingSource object.


Note: OE00189937    Type: Product Notice
Infragistics NetAdvantage for .NET Product Notice
---------------------------------
OpenEdge includes Infragistics NetAdvantage for .NET v2009 Vol 2 Copyright (c)
1996-2009 Infragistics, Inc. All rights reserved.


Note: OE00190241    Type: Known Issue
R-code that uses the UltraControls for .NET is incompatible between versions
---------------------------------
The UltraControls for .NET version changed in between Release 10.2A, 10.2B
Beta, and 10.2B. You must recompile any r-code created in 10.2A or 10.2B Beta
before running it in 10.2B.


Note: OE00190705    Type: Behavior Change
CreateRowEventArgs, etc. now contain buffer info for bound query
---------------------------------
When your ProBindingSource is bound to a query and you subscribe to the
CreateRow and CancelCreateRow events, the CreateRowEventArgs.BufferName and
CreateRowEventArgs.BufferHdl properties are now set with the buffer information
from the query's buffer. For a join query these properties contain the buffer
name and buffer handle of the first buffer in the query. The same applies to
the CancelCreateRowEventArgs object.

In releases prior to 10.2B these properties contained the Unknown value (?).


================================================
OpenEdge GUI for .NET - .NET UI Language
================================================


Note: OE00168125    Type: Behavior Change
Compiler verifies if class satisfies implementation of an abstract class
---------------------------------
If an ABL class inherits from a .NET class that has abstract methods or
properties, it is required to implement those methods and properties.  The
compiler should verify whether it has done this or not. In 10.2A it did not --
a run-time error is raised if you try to instantiate the class.  In this
release a compiler error is raised if any of the abstract members are not
implemented.


Note: OE00176084    Type: Behavior Change
The AS <datatype> phrase can be used with an array parameter
---------------------------------
If you want to pass an ABL array to .NET, but the target array is a type that
the ABL does not support (e.g., SHORT), you can use the AS phrase on the method
parameter.  For example, if a .NET method IntArrayInput is overloaded to take
either a "System.Int32[] or a "System.Int16[]", you can call the method in ABL
where extInt is a native ABL integer array:

refObj:IntArrayInput(extInt AS SHORT).

This will call the overloaded method whose parameter is "System.Int16[].  The
AS type applies to the elements of the ABL array the same way as it would to a
scalar data type.
 
Before this change, to make this method call, you would not have been able to
use the ABL array directly as a parameter.  You would have needed code as in
this example:

refObj:IntArrayInput(CAST (BOX(extInt, "SHORT"), "System.Int16[]")).


Note: OE00177085    Type: Behavior Change
Changes to Debug Alert information (.NET stack and stack order)
---------------------------------
.NET exceptions can be thrown when working with .NET objects.  If there is no
code to trap an exception (e.g., no CATCH or no NO-ERROR), the messages it
contains may be displayed by the AVM in an alert box.  In addition, errors
thrown during execution of a .NET form cannot be caught on the WAIT-FOR (it
raises STOP).  Therefore, again, the exception messages will also be displayed
by the AVM in an alert box.  Since it would be helpful to have .NET StackTrace
information for a .NET Exception that occurs in these situations, the data
provided by Debug Alert (by setting the -debugalert startup parameter or
setting SESSION:DEBUG-ALERT = TRUE) has been enhanced to include .NET
StackTrace information where relevant.	

If Debug Alert is on, the .NET StackTrace is added to the Debug Alert
information after the ABL call stack both in the Debug Alert Help dialog box
and in the client log (if the Client Log (-clientlog) startup parameter is
specified).  Also, the ABL call stack is now shown in the Debug Alert Help
dialog box with the top of the stack (most recent call) at the top, instead of
at the bottom. This is now consistent with how the data appears in the client
log file.


================================================
OpenEdge GUI for .NET - Data Binding
================================================


Note: OE00173180    Type: Behavior Change
MaxDataGuess property allows grid to display data quickly when initialized
---------------------------------
When data is initially displayed in a grid bound to a ProBindingSource with a
very large  record set, there is a noticeable delay in the display while the
ProBindingSource computes the record count.

You can eliminate this delay by setting the value of the ProBindingSource's
MaxDataGuess property to the exact or best-guess number of records expected.
With this property set, the ProBindingSource does not compute the record count,
but instead uses the MaxDataGuess value as its initial record count. The
ProBindingSource sets its Count property to the value of MaxDataGuess, and the
grid data is displayed immediately.

A side effect of using the MaxDataGuess property is that the vertical scrollbar
thumb height in the grid is not accurate initially. As the user scrolls through
the records, the ProBindingSource updates its Count property with a more
accurate count for the number of records.  (As the Count property becomes more
precise, the vertical scrollbar thumb height is redisplayed more accurately.)
After all the records have been read, the vertical scrollbar thumb height is
accurate and the Count property contains the total number of records.


Note: OE00177925    Type: Known Issue
Set PBS:NoLOBs to TRUE if CLOB or BLOB field bound to PBS
---------------------------------
If you have a CLOB or BLOB field bound to a ProBindingSource, you should set
the new ProBindingSource:NoLOBs property to TRUE if you allow updates from the
bound .NET control.

Currently, the AVM cannot compare LOB fields to determine if the underlying
data has changed, so you cannot call the PBS:ASSIGN() method or the
CURRENT-CHANGED() function successfully unless ProBindingSource:NoLOBS is TRUE.
 
When the ProBindingSource:NoLOBs property is TRUE, the AVM ignores any LOB
field bound to the ProBindingSource when executing the CURRENT-CHANGED function
or the ASSIGN() method. When this property is FALSE (the default value), an
error message is displayed if a LOB field is bound to the ProBindingSource.


================================================
OpenEdge GUI for .NET - Data type
================================================


Note: OE00155094    Type: Known Issue
.NET types used as parameters for internal procedures are not validated
---------------------------------
If you RUN an internal procedure that has a class type as a parameter, and you
pass an incompatible type for that parameter, the AVM does not catch the error
when it invokes the procedure if either the parameter (as defined by the
procedure) or the argument that is actually passed is a .NET type. The error is
correctly caught if the internal procedure is expecting a reference to an ABL
class and the RUN passes an ABL class reference, but in the other three
possible cases there is no type check:

  Internal procedure expects .NET type, RUN passes ABL type
  Internal procedure expects ABL type, RUN passes .NET type
  Internal procedure expects .NET type, RUN passes (incorrect) .NET type


Note: OE00175760    Type: Behavior Change
Assignment of ABL array to .NET array now results in correct array type
---------------------------------
If you assign an ABL array to a variable defined as a .NET array type, the
result should be a .NET array that is typed based on the element type of the
source ABL array.  If the ABL array is an array of primitive types, it should
be converted to a .NET array containing elements of the closest mapped type. 
If it is an ABL array of objects, it should be converted to a .NET array based
on the element object type.  

In 10.2A, this was not the case; the array was converted to the array type of
the target variable.  If the target was System.Object or Sytem.Array, it was
converted to a "System.Object[]".  For example:

For the assignment <System.Windows.Forms.Control[] property> = <Button EXTENT
variable>:
	In 10.2A, the result was an object of type "Control[]" whose elements
were of type System.Windows.Forms.Button.
	Now, the result is an object of type "System.Windows.Forms.Button[]".

For the assignment <System.Object[] property> = <INTEGER EXTENT variable>:
	In 10.2A, the result was an object of type "System.Object[]" whose
elements were of type System.Int32.
	Now, the result is an object of type "System.Int32[]".


================================================
OpenEdge Replication - 
================================================


Note: OE00191754    Type: Workaround
Rename target database key store file after disabling TDE
---------------------------------
If you disable transparent data encryption (TDE) on a replication-enabled
source database, transparent data encryption is also disabled on the target
database as part of the replication process. However, the key store file on the
target database is not automatically renamed or deleted. You must manually
rename the key store file from database-name.ks to database-name.ks.sav.


================================================
Porting - 
================================================


Note: OE00133982    Type: Known Issue
Progress Explorer must "Run As Administrator" on Windows Vista
---------------------------------
On Windows Vista platforms, Progress Explorer fails to start when UAC is
enabled (by default, UAC is enabled). To start Progress Explorer, select the
Progress Explorer shortcut, right-click and choose "Run As Administrator." Use
this procedure when logged in as a normal user or as an administrator.


Note: OE00152834    Type: Known Issue
On Windows Vista platforms, sqlexp only works with a numeric port number
---------------------------------
On Windows Vista platforms, sqlexp can only connect to the database server if
the port is numeric. For example, specify the port number as 4050 rather than
using a service name like "mydbservice".


Note: OE00166210    Type: Limitation
Progress Explorer does not work on Windows 2008
---------------------------------
Progress Explorer does not work on the Windows 2008 operating system, both
Windows 2008 32bit and Windows 2008 64bit.  In order to administer the
Administration Server running on a Windows 20008 machine, use OpenEdge Explorer
or run Progress Explorer remotely on a separate Windows machine like Windows
XP, Windows 2003, or Windows Vista.

As a temporary workaround  you can make the following registry entry:
HKEY_CURRENT_USER\Software\Microsoft\Java VM\EnableJIT= 00 00 00 00 

While this workaround allows Progress Explorer to function when run as
Administrator, the impact to other applications is unknown.  Use this work
around cautiously and test all applications thoroughly.


Note: OE00172068    Type: Known Issue
fmconfig fails on Red Hat Linux 5 when libX.so is missing
---------------------------------
fmconfig fails on Red Hat Linux 5 when the library libX.so is missing.	To
resolve the missing library,  download and install 
libXp-1.0.0-8.1.el5.i386.rpm or higher, available at the ftp site listed below.
 You can then run the fmconfig command.

To get the library:
1. Navigate to:
ftp://mirror.switch.ch/pool/1/mirror/scientificlinux/5rolling/x86_64/SL/libXp-1
.0.0-8.1.el5.i386.rpm

2. rpm -Uv libXp-1.0.0-8.1.el5.i386.rpm


Note: OE00172320    Type: Known Issue
Long connection times on Windows 64bit
---------------------------------
Occasionally connecting a process to an OpenEdge database on Windows 64bit
takes a long time.  

This is an open issue Progress Software is working with Microsoft to resolve
(Microsoft Support Case: SRX080707601602).  

Conditions that appear to cause the slow connection include:
* The database buffer pool that is larger than 1.7 GB.
* The C: drive on the machine is smaller than 14 GB.

If you encounter slow connection times, please report the conditions to
Progress Software so that more data can be provided to Microsoft to help
resolve the issue.


Note: OE00172459    Type: Limitation
Windows 32-bit and 64-bit do not support Open Client for Java CAB files
---------------------------------
The Windows 32-bit and 64-bit platforms do not provide the following Open
Client for Java runtime packages:

o4glrt.cab
o4glrth.cab
o4glrths.cab
o4glrthsl.cab
o4glrts.cab

Thus, the Windows 32-bit and 64-bit platforms do not provide support for Java
applets using the Internet Explorer browser running a Microsoft JVM.  In order
to run applets in IE, you must use the .jar file distribution of the Open
Client Runtime.


Note: OE00177172    Type: Known Issue
Windows 64bit requires more memory for the Operating System
---------------------------------
In Windows 64-bit, the operating system requires 2GB of free memory for
acceptable OpenEdge performance.  If your shared memory allocation (database
buffer pool) leaves less that 2GB of free memory, then performing even simple
operations, such as finding a record that is in memory, is extremely slow.


Note: OE00186006    Type: Workaround
Running Actional Agent with 64-bit JVM on Windows64
---------------------------------
The Uplink File (uplink.cfg), is not found by the Actional Interceptor on
64-bit Windows if the Actional Agent is deployed with a 32-bit JVM.  

The Uplink File is used by the Actional Agent to communicate with the
interceptor(s), and must be in a location where both the Actional Agent and the
Intercepter can look at it.

If the Actional Agent is deployed in the 32-bit Java Virtual Machine on 64-bit
Windows, the Uplink File is created in the folder
/WINDOWS/SYSWOW64/LG.Interceptor.  The 64-bit Actional Interceptor SDK looks
for the Uplink File in the /WINDOWS/SYSTEM32/LG.Interceptor folder.

Use the following steps to resolve the issue:

1) Locate the 64-bit Java Runtime Environment or Java SDK installed with
OpenEdge (typically under %DLC%/jdk/bin or %DLC%/jre/bin).

2) In the "common\scripts" subdirectory of the Actional Agent installation
folder, 
create a text file called post-custom.conf.

3) Edit the post-custom.conf file and add the following:
wrapper.java.command=[location of the java executable in the 64-bit JRE found
in Step 1] 
For example:
wrapper.java.command=C:/Progress/OpenEdge/jre/bin/java.exe

4) Save and close the post-custom.conf file.


These steps are based on information from the Actional Installation Guide.  
See the "Using Jetty with 64-bit JVM" section in Chapter 3, "Deploying," of the
Actional Installation Guide for more information.


Note: OE00187121    Type: Known Issue
10.2A Windows 64-bit r-code must be recompiled in 10.2B
---------------------------------
When moving from OpenEdge 10.2A for Windows 64-bit  to OpenEdge 10.2B for
Windows 64-bit, you must recompile your ABL application because the r-code
between these two releases is not compatible.  If you do not recompile your
application, and run r-code generated with OpenEdge Windows 64-bit 10.2A, you
will get unexpected results.  

Starting in Release 10.2B, the OpenEdge Windows 64-bit product can run r-code
compiled on any OpenEdge 64-bit platform with Release 10.1X or Release 10.2X.


Note: OE00192368    Type: Workaround
Debugger does not work with WebSpeed on Windows Server 2008 R2
---------------------------------
In Windows Server 2008 and Windows Server 2008 R2, the Debugger cannot be
displayed when initiated by the WebSpeed agent because the WebSpeed Agent runs
as a service in session 0.   Session 0 is a non-interactive session, reserved
for services, and cannot send the GUI to the user's session.

To workaround for this issue, do one of the following:
1) Start the Microsoft Interactive Service Detection Service in Administrative
Tools>Services.  (Note that Mircosoft intends to remove this service in the
next Windows OS Release.)
2) Use the attachable debugger option to debug the WebSpeed applications.


Note: OE00194126    Type: Limitation
SQL Explorer fails to load Java library while building schema on Windows 64-bit
---------------------------------
When SQL Explorer attempts to build the schema for an SQL OpenEdge database on
Windows 64-bit platforms, it fails and the following error is displayed:

SQLState=HY000
ErrorCode=-210022
[DataDirect][OpenEdge JDBC Driver][OpenEdge] Failed during dynamic load of Java
dynamic library. Reason = [126]The specified module could not be found.


================================================
progress explorer - 
================================================


Note: OE00193902    Type: Workaround
Archival Directory truncated when database started
---------------------------------
When using the AI File Management Utility for a database managed by the
AdminServer, the archivaldir= in the conmgr.properties file or the "After-image
archival directory list:" in OpenEdge Explorer and Management will be truncated
if more than 8 characters.

The work-around is to set the "-aiarchdir <path>" in the "Other Arguments" in
OpenEdge Explorer/Management or the "otherargs=" in conmgr.properties.


================================================
Server Technology - 
================================================


Note: OE00192459    Type: Known Issue
SonicMQ Interceptor generates extra service
---------------------------------
The SonicMQ interceptor generates an extra service named [Default].  This
service is viewable in the Actional Path Explorer. This problem occurs on Linux
64-bit, HP Itanium, HPUX11 64-bit, and Solaris 64-bit platforms


================================================
SQL - ESQL92
================================================


Note: OE00159192    Type: Limitation
ESQLC clients can specify an IP protocol version using a parameter
---------------------------------
ESQLC clients will default to using the IPv4 protocol.	The use of the IPv6
protocol can be selected by using the -ipv6 parameter on the connection URL. 
The following is an example of a connection URL where the use the of IPv6
protocol is desired:

progress:T:myhost:5000:mydb:[-ipv6]

The parameter is also available to use with connection URLs for the SQLDump,
SQLoad, and SQLSChema utilities.


================================================
SQL - Interoperability
================================================


Note: OE00186953    Type: Behavior Change
SQL collation definition syntax change in DDL
---------------------------------
1) When creating a field with case sensitivity, we used to accept any arbitrary
word after the COLLATE keyword. As of OpenEdge Release 10.2B, unsupported words
after the COLLATE keyword  are not accepted in DDL. To indicate a case
insensitive column, the correct syntax can only be _I, I or default database
collation with suffix _I (for example: COLLATE _I, COLLATE I or COLLATE
BASIC_I). To indicate a case sensitive column, the correct syntax can only be
_S, S or default database collation with suffix _S (for example: COLLATE _S,
COLLATE S or COLLATE BASIC_S).

2) Suffix _S or _I is no longer appended to the collation name	in schema
_Field._Collation. Instead, SQL uses _Field._Fld-case to determine case
sensitivity, like ABL. If you query _Field._Collation, you will see no suffix
for a newly 10.2B created table but will see a suffix for pre-10.2B created
tables. There is no underlying schema change at all, just purely display
difference.

3)When statement ALTER TABLE ALTER COLUMN SET PRO_CASE_SENSITIVE is executed,
the suffix to the collation name, in _Field._collation, will be removed in the
schema too.


================================================
SQL - Server
================================================


Note: OE00164322    Type: Known Issue
SET operator precedence not handled correctly
---------------------------------
OpenEdge SQL  regards all SET operators (such as INTERSECT) as having equal
precedence. OpenEdge SQL also does not "change precedence" when SET operators
are in parentheses. This behavior is not standard compliant. This problem will
be fixed in a future release.


Note: OE00168335    Type: Behavior Change
ODBC Convert function with parameter value
---------------------------------
When an ODBC Convert function is used with a SQL parameter marker "?" as the
value to be converted, and the result data type has decimal fraction digits,
OpenEdge SQL now provides a more accurate data type description to the client
for the parameter value. Specifically, for types with decimal fraction digits,
a "scale" default value is now returned. For the "numeric" datatype, the
default scale is 8.  Formerly, the scale was always 0, which could result in
decimal fraction roundoff.


Note: OE00179211    Type: Behavior Change
NOLOCK hint on SELECT nested under INSERT
---------------------------------
OpenEdge SQL now supports the use of a NOLOCK hint on a SELECT which is used on
an INSERT statement. 

The hint has the form  "WITH (NOLOCK)". The hint is used at the end of the
SELECT clause under INSERT.

Example:
	INSERT INTO PUB.CUSTOMER
	       SELECT * FROM  PUB.ARCHIVE_CUST	 WHERE ...   WITH (NOLOCK);


Note: OE00185888    Type: Known Issue
DBTool Error for _Sysseqauth Wrong Number of Fields
---------------------------------
DBTool's record validation option might return the following error for
sysseqauth table:
Number of fields mismatch Expected 8, got 9.
There were 1 error(s) found in 62885 of _Sysseqauth (-121).
This is fixed so that new records will have correct number of columns. Records
with above mentioned errors can be fixed by updating/deleting a sequence
privillege. This behavior does not impair proper functionality of database or
of SQL.


================================================
SQL - SQL
================================================


Note: OE00153600    Type: Known Issue
SQL uses the Java compiler to compile the Java code for a CREATE
---------------------------------
TRIGGER or CREATE PROCEDURE statement. If the Java compiler finds errors in
this Java source code, it outputs diagnostic information describing the errors.

A subset of the diagnostics is appended to the SQL-92 error
message which is returned to the client.

The entire set of diagnostics is stored on the server, in the SQL server's
WRKDIR (working directory).  If the owner of the stored procedure/trigger is
OWNER, and the procedure/trigger name is XX, then all the diagnostics are in
the file named OWNER.XX.LST in the SQL server's WRKDIR (working directory).

The WRKDIR is identified by either the environment variable $WRKDIR, or on NT
by the registry entry WRKDIR under the registry key for the Progress software
installation.


Note: OE00167446    Type: Known Issue
UPDATE statement SET clause restriction
---------------------------------
Prior to OpenEdge Release 10.2A02, OpenEdge SQL did not correctly support
correlated subqueries in the SET clause of an UPDATE statement. A correlated
subquery is a subquery which refers specifically to the records of the table
being updated. 

This issue is fixed as of OE 10.2A02.


Note: OE00177294    Type: Known Issue
Array as join key not detected
---------------------------------
OpeEdge SQL does not support the use of an entire array (all its extents) as a
JOIN key between two tables.  Prior to OpenEdge Release 10.2B, OpenEdge did not
always detect this error, and produced internal errors.
As of OpenEdge 10.2B, OpenEdge SQL does detect this situation at runtime and
produces an error about inconsistent datatypes.


Note: OE00182091    Type: Behavior Change
Display of null array is changed.
---------------------------------
The ARRAY data type is a composite data value that consists of zero or more
elements of a specified data type (known as the element type). If the result
returned from an ARRAY data type is null, it used to be displayed as a string
that consists of ? for each element and seperated by ;. To be consistent with
all other data types, it will be changed to be displayed as null instead of a
string with above format now. Same for the result returned from pro_element
function.


Note: OE00188678    Type: Behavior Change
Default SQL Stack Size on Itanium
---------------------------------
Starting in OpenEdge Release 10.2B, the default SQL stack size for Itanium will
be changed from 1MB to 2MB.

The SQL stack size can be explicitly set by using the startup parameter
-SQLStack.


================================================
SQL - Tools
================================================


Note: OE00179164    Type: Behavior Change
SQLSCHEMA will dump COLLATE for case-insensitive field
---------------------------------
The SQLSCHEMA utility will now dump the COLLATE attribute of a column which is
case insensitive. This enables the  dumped column definition to accurately
describe the column's actual definition.


Note: OE00182028    Type: Behavior Change
SQLSCHEMA will not create GRANT to blank user id
---------------------------------
The SQLSCHEMA utility will no longer create a GRANT to the blank user id.


Note: OE00183536    Type: Behavior Change
SQLDUMP and SQLLOAD's -C parameter can be used to specify code page name.
---------------------------------
SQLDUMP and SQLLOAD's  -C <code_page_name> parameter now works and can be used
to specify load file, dump file's code page name.


================================================
Web Services Adapter - 
================================================


Note: OE00193013    Type: Behavior Change
Web Services Adapter logging behavior change
---------------------------------
Prior to Release 10.2B of the Web Services Adapter, the Log Entry Types
property was ignored, and all logging types were added to the default. This
caused very verbose logs when the logging level was increased, making it
difficult to debug issues. 

For 10.2B, the Log Entry Types property for the WSA is enabled, and the entry
types related to debugging issues are removed. As a result you may notice
missing log entries related to these types that were previously available.

Additional entry types you can now set include the following:

- "Actional" - Log Actional monitoring information
- "4GLProvider" - Logs client messages for running a procedure
- "MsgDebug" - Logs the raw SOAP messages sent and received


================================================
Web Services Client - 
================================================


Note: OE00100789    Type: Known Issue
Time zone information lost for some XML datatypes
---------------------------------
The XML Schema datatypes, gYearMonth, gYear, gMonthDay, gDay, and gMonth, can
optionally include time zone information. OpenEdge does not handle time zone
information correctly for these datatypes. Any time zone input from the ABL is
lost, as is any time zone information returned from a Web service for these
datatypes. For example, "1953-10-4:00" becomes "1953-10". The one exception is
that Z, indicating Universal Time (UTC), is retained (for example, 1953-10Z
remains 1953-10Z).


Note: OE00103414    Type: Known Issue
Data types defined in imported schemas are not seen by the WSDL Analyzer
---------------------------------
RN# 100B-00168
==============
When a WSDL document contains an XML Schema import element, the type and
element definitions of the imported schema are not seen by the analyzer. A
message indicating that a type or element definition could not be found will
appear in the generated documentation.

To work around the problem, copy the xsd:schema elements (and their contents)
from the imported schema document and paste them as children of the wsdl:types
element of the WSDL document.  Also comment out the xsd:import element in the
xsd:schema element.

Double check namespace prefix definitions to ensure the prefixes in the copied
XML are properly defined and can be referenced by other parts of the WSDL
document.


Note: OE00123804    Type: Known Issue
Memory violation when connecting to a Web Service on AIX 5.3
---------------------------------
In order to use WebServices on AIX 5.3, the minimum Operating System
requirement is AIX 5.3.04. You can find the version of AIX you are running
using the oslevel -r command.


================================================
WebClient - 
================================================


Note: OE00146960    Type: Known Issue
The WebClient install does not accurately calculate disk space required
---------------------------------
The WebClient install does not accurately calculate the amount of disk space
required on the client side to do the install.	Prior to the install the user
should probably have around 25 meg of available disk space. Some of this is for
temporary storage of installation files.


Note: OE00147868    Type: Known Issue
Do Not Use Notepad to Edit .htm Files
---------------------------------
Do not use Notepad to edit the webclient.htm file or bootstrap.htm file for
customizing your application install. When Notepad saves the file, it changes
the line terminator characters and may make the file work improperly in the
browser.


Note: OE00147869    Type: Known Issue
DLLs and EXEs That You May Have to Package with Your Application
---------------------------------
Be aware that there may be Progress-supplied DLLs or EXEs that are used by your
application that are not included in the end-user WebClient install. Strictly
speaking, these DLLs and EXEs are not a part of ABL.  For example, there are
some DLLS or EXEs only used during application installation. Other DLLS may be
required if the application uses procedures in the adecomm or adeshar
directories that indirectly use DLLs.  Progress  excludes them from the install
to keep WebClient as small as possible and keep install time over the Internet
as fast as possible. If you need any of these files to install or run your
application, include them in your application installation.  Examples of these
files are listed below by category.

DLLs used by some procedures in adecomm/adeshar:
    dirsrch.dll
    fileinfo.dll
    proprint.dll

EXEs that could be used by your install:
* ini2reg.exe
* regsvr32.exe (A Microsoft tool usually, but not always, installed on a
typical PC)


Note: OE00148079    Type: Known Issue
Codepage Issues with Strings Entered into the WebClient Assembler
---------------------------------
There are several strings entered into the WebClient Assembler that may be
shown to the end-user when the application is installed.  Notably, these are
the Vendor Name, Application Name, and End-User Description strings as well as
the names of application shortcuts.  WebClient Assembler saves these strings in
the application configuration file using the default codepage of the
development machine. If the application is installed on an end-user machine
that has a different default codepage, some of these strings may contain
strange or unreadable characters.


Note: OE00163255    Type: Product Notice
MD5 Encryption Library Product Notice
---------------------------------
OpenEdge includes the RSA Data Security, Inc. MD5 Message-Digest Algorithm.
Copyright (c)1991-2, RSA Data Security, Inc. Created 1991. All rights reserved.


================================================
WebSpeed - Diagnostics
================================================


Note: OE00172879    Type: Behavior Change
WebSpeed agent logs messages when it shuts down
---------------------------------
Starting with 10.1C, upon auto trimming or shut down of WebSpeed agents, two
new messages are written to the log file to record the fact that the agents are
shutting down gracefully. The messages are:

- Shutdown request received. (5465)
- WTA Shutdown. (5476)

These messages are written when logging level is 3 and above.


================================================
WebSpeed - Tools
================================================


Note: OE00096070    Type: Known Issue
The compileAll option in WebTools has a limitation of URL length of 4096 chars
---------------------------------
The compileAll option on AppManager in WebTools has a limitation of URL length
being more than 4096 chars, depending of what web browser is being used. Try to
limit the size of the compiles, number of files if you run into this problem.


Note: OE00160917    Type: Known Issue
Syntax checks of HTML files larger than 18KB hangs WebSpeed Workshop
---------------------------------
The web browser-based WebSpeed Workshop hangs when you use the Editor tool to
check the syntax of an HTML file larger than 18KB. (Note that you can save and
compile files larger than 18KB without hanging.)




LIST OF ISSUES ADDRESSED IN THIS RELEASE:

================================================
Adapter for SonicESB Other
================================================
Issue Number: OE00180436
     WSM's AppServer settings ignored by the Web Service ESB adapter

When configuring the OE Web Service ESB adapter you need to specify a WSM
file that contains the configuration for the AppServer. It appears though
that the ESB service does not take the AppServer info from the WSM file,
and instead you have to set the AppServer settings manually in the Sonic
Management Console (SMC) for that specific ESB service instance.

Issue Number: OE00182129
     "Initializing WSA adapter" message is labeled as severe

The message "Initializing WSA adapter" during SonicESB adapter startup is
labeled as  SEVERE which is reserved for fatal errors.

Issue Number: OE00187234
     Not possible to generate to Unix portable esboe with  proxygen

Proxygen generated esboe files with subdirectory info fail with
<message>Fault String: ERROR condition: ** "test\testIk" was not found.
(293) (7211)</message> on Unix platforms.

Issue Number: OE00189732
     Passing temp-tables with array field through ESB adapter fails

Passing temp-tables with array field through ESB adapter fails with
java.lang.ClassCastException

Issue Number: OE00190122
     Passing TT with date field through ESB Native Adapter fails

When you try to pass a Temp-Table that includes a DATE field through the
Sonic ESB Native Adapter, the following exception is thrown:

com.progress.open4gl.dynamicapi.ClientException: Invalid input result set
object: class java.util.Date. (7186) There might be a mismatch between an
input result set and the schema in the proxy. (7228) (7176)

================================================
Adapter for SonicMQ Other
================================================
Issue Number: OE00181008
     Receiving non-ASCII from SonicMQ corrupts data if using UTF-8

If non-ASCII characters are present in a CDATA section of an XML document
received from SonicMQ, an OpenEdge client using -cpinternal UTF-8 will
incorrectly interpret them, causing them to be corrupted.

================================================
ADE Tools and Runtime Auditing Policy Manager
================================================
Issue Number: OE00181502
     Changes in Audit Policy are not applied as expected

If you make changes to an audit policy (such as disabling a policy) in the
Audit Policy Maintenance Tool, save and commit changes, these changes are
not applied until the client session disconnects and reconnects to the DB.

================================================
ADE Tools and Runtime Data Dictionary
================================================
Issue Number: OE00118136
     Can-Write user list field fails if trailing spaces exist

When setting the data security user list for a field and the user list
contains trailing spaces, they are not trimed and causes the errror"**
Insufficient access privilege for Field <field-name>. (233)"  for the last
user in the list.

Issue Number: OE00120101
     Dump .d converts to local client code page before dumping data

"Data dump" utility does not warn about possible data corruption when
database codepage is UTF-8 and session codepage is not UTF-8.

Issue Number: OE00154917
     Dumping df needs POSITION awareness for binary load in Admn Tool

When dumping a df file from the Administration Tool, there is a field that
mentions that POSITION is needed for .r Compatibility, but it is also
needed for Binary Load compatibility and should state so.

Issue Number: OE00163260
     TTY Dictionary aborts with errors 12371 and 142

Unable to bring up the TTY Data Dictionary when the database has a large
schema

Issue Number: OE00175772
     Mandatory and default value not set by MSS delta.sql utility

The delta .sql script created by the MS SQL Server DS delta sql utility
does not 
contain the 'NOT NULL' clause for new mandatory fields. Also the .sql does
not populate the new fields with the specified default value when there
are existing records when applied to the MS SQL Server.  The fields is
left with the NULL value.

Issue Number: OE00176198
     Delta sql utility for MSS has issues with extent fields & Width

The Generate delta.sql utility for MSS does not append the ##n suffix to
the field name in the .sql file and the column width is not re-calculated
if the field is an extent field and the 'For field widths use" option is
set to 'Width'.

Issue Number: OE00176833
     Loading df doesn't commit the last index when errors are ignored

When loading a df file that contains errors and you select the option
"Commit Even with Errors", the	definitions for the object prior to the
command with error will not be saved.

Issue Number: OE00177164
     Format change in .ds file from a data load by Data Dictionary

The .ds file generated by the load data utility in the Data Dictionary
tool does not contain the number of loaded records anymore.

Issue Number: OE00177533
     Codepage change for CLOB field not caught by incremental .df

The incremental .df utility does not generate the correct syntax for a
clob column that has codepage and/or collation differences.

Issue Number: OE00177558
     Index name changes in .sql file if dropped/recreated w/same name

If you specify a delta .df file in the 'Generate delta.sql' utility for
MSS or ORALCE that contains an index which is dropped and re-created with
the same name, but with different index components, the tool appends the
number '1' to the foreign name of the index (in the .sql and the generated
.df files) instead of keeping the previous name.

Issue Number: OE00177587
     Error 138 delta.df for MSS w/ logical field and Width specified

The Generate delta.sql utility for DataServer for MSS generates error 138
when the .df file has a logical field and you select the 'Width' option.
Bad sql is generated in the output .sql file.

Issue Number: OE00178936
     ASCII load of incomplete .d file doesn't produce any warning

Loading incomplete .d file, where actual number of records doesn't match
expected number, succeeds without any errors

Issue Number: OE00180473
     DB runtime security flag does not get set if more than 1 _Db

Database runtime security flag does not get set if the db has more than
one _Db of type PROGRESS.

Issue Number: OE00180842
     delta.sql utility not adding info for newly added sequence

A bug in the delta.sql utility results in not adding some info for the
sequence, this causes error (4505) when recompiling the application
against the new database schema. 

Issue Number: OE00182261
     Protomss doesn't warn about table with unsupported data type

Protomss does not warn when migrating table with unsupported data type.

Issue Number: OE00182275
     PRO2*** creates ISO8859-1 schema if Unicode Types not selected

When using DataServer utility to migrate a Progress database to the
foreign datasource (PRO2***), if "Codepage for Schema Image" is set to
UTF-8 but "Use Unicode Types" is not selected then a schema holder with
code-page ISO8859-1 is generated.

Issue Number: OE00183240
     Error 1006 when running protoMSS in batch mode

Error 1006 when running protoMSS, protoODB or protoORA utility in batch
mode without connecting to the OpenEdge db from the command line, even
though the PRODBNAME and PROCONPARMS variables are correctly set.

================================================
ADE Tools and Runtime GUI Rendering
================================================
Issue Number: OE00178238
     Navigation Panel and SmartDataViewer are not updated after delet

If an SDO only has two records and the first one is deleted, the SDO does
not publish the change and the Navigation Panel and the SmartDataViewer
will not reflect the new state.

Issue Number: OE00179468
     debugging messages left in fetchrowobject.i

Some debugging messages have been left in fetchrowobject.i in 10.2A FCS
and will show up in the server log file for each data request.

Issue Number: OE00179996
     SDO w. join query fails to delete parent record if child deleted

If an SDO query is based on a join, deleting the joined  (child) record
for the query in deleteBeginTransValidate will cause the delete of the
main (parent) record to fail even if the fields of the joined (child)
table are non-updateable and the table is in the NoLockReadOnlyTables
list.

Issue Number: OE00180817
     findRowWhere function returns True when record does not exist

findRowWhere function returns True when the record does not exist when
RebuildOnReposition is set to true .

Issue Number: OE00181208
     ADM2 saving a record with a BLOB deletes the image file

When using a SmartLobField to visualize and/or change BLOBs, the image
file on the operating system is deleted when it is in or under the TEMP
directory. The assumption is that the image file was written there by the
SmartLobField in order to be displayed, but this also happens if the image
was added there manually in order to be loaded into the BLOB.

Issue Number: OE00183329
     SmartObject with translatable properties breaks container

If a SmartObject has translatable properties and there are other character
properties that contain quoted strings then these quotes are not handled
correctly. An invalid call to constructObject is generated in the
adm-create-objects procedure generated for the container of the
SmartObject, preventing the container from running.

Issue Number: OE00184456
     Records can be saved without firing validation in an SDO

When a field is ? (unknown value), no field values are sent through to the
submitValidation procedure and hence no validation fires for the
SmartDataObject.

Issue Number: OE00187820
     getInstanceNames returns wrong names using PGEN code

When running from 4GL Generated code (PGEN), the getInstanceNames API for
a container will return the object names, not the instance names as
specified in the container definitions.

This breaks any logic that relies on these instance names, as typically
seen in containers where multiple instances of the same object are used.

Issue Number: OE00188547
     selectPage/pendingPage/hideOnOnit behavior change since 10.1B02

A change was introduced in 10.1B02 ADM2 where SmartWindows contained in
another SmartWindow flashes and disappears when calling the viewPage
procedure.

Issue Number: OE00189058
     Korean labels are truncated in the SmartFilter

In a SmartFilter labels are truncated when korean characters are used.

Issue Number: OE00189861
     Toolbar&Menu designer can't translate menu-items with same lang

Dynamics: Toolbar and Menu designer provides no way to translate
menu-items without different source and target languages.  This is allowed
in other dynamics interfaces for the purpose of localization but no
support was added for this in the Toolbar and Menu Designer.

Issue Number: OE00192817
     afmessaged.w renders unusable UI if message has too many lines

Afmessaged.w does not impose a size limit on the editor widget used to
display the message text. 
As a result the dialog can become larger than practical if the message
text has enough lines. 
And if the message text is long enough to push the size of the dialog over
that of the session's maximum size, it will break and render an unusable
UI: An error "**Unable to set <attribute>.  <widget id> does not fit in
<parent widget id>. (4054)" is raised for the buttons in the frame, and
the buttons will be rendered behind the editor widget, making them almost
unreachable.

One practical example where this may be seen is when deleting a row from
an SDO with many fields, with delete confirmation active. The record
deletion will then call the askQuestion API in Session Manager, which
calls Afmessaged.w. The message used will be list of label:value pairs for
the fields in the SDO, so with enough fields this issue will be seen.

================================================
ADE Tools and Runtime Tools
================================================
Issue Number: OE00113812
     Error 80 with TEMP-DB Maint tool and -d dmy

When importing a file with German format, you get error 80 in TEMP-DB
Maint tool if -d is set to dmy.

Issue Number: OE00174995
     Dynamics physical service maintenance corrupts connection string

When using a host name that includes the string '-a' in the name, the
connection string that will be written to the icfconfig.xml file may
become corrupted.

Issue Number: OE00181669
     Can't add BLOB or CLOB calculated field to dynSDO

Adding a new calculated field with BLOB or CLOB datatype to a dynamic SDO 
always fails with the error "The format is invalid for the calculated
field data type. "

Issue Number: OE00182559
     Declarative statements not supported in AppBuilder

When a .w file defines a temp table or a buffer or is Appserver aware, the
declarative statements USING and ROUTINE LEVEL ERROR cannot be added in
the definition section (or anywhere) through the Appbuilder without
causing the file not to compile.

To address this issue the Procedure Settings Dialog now has additional
functionality that allows the user to add  declarative statements like
USING and ROUTINE LEVEL ERROR. A new button on the right hand side opens a
dialog that allows you to add this code in an editor. 

The declarative statements added here are generated into a new section in
the source code. This section is written before both the optional
temp-table definitions and the optional appserver include, thus ensuring
that these statements always are added before any definitional and
executable statement as required for the file to compile.

Issue Number: OE00182845
     There is a code error in the adecomm\_mfldlst.p procedure

The statement:
 ASSIGN cTTName = ENTRY(2, ENTRY(iNumTT, p_TT), "|":U)
	       cType   = ENTRY(2, ENTRY(iNumTT, p_TT), "|":U).
has an error.  It should be:
  ASSIGN cTTName = ENTRY(2, ENTRY(iNumTT, p_TT), "|":U)
	       cType   = ENTRY(3, ENTRY(iNumTT, p_TT), "|":U).
Because the the Type is the third entry of the list.

Issue Number: OE00187237
     Saving Source code in AppBuilder can return error 148

When saving source code in AppBuilder error 148 ("Numeric Format ddd
provides for no digits") is raised intermittently. When the error occurs,
the application crashes and a stack trace is produced.

================================================
ADE Tools and Runtime WebTools
================================================
Issue Number: OE00122746
     WebSpeed can't process form with list of fields bigger than 32K

WebSpeed can't process a form with a list of fields that is longer than
32k.

================================================
AdminServer AdminServer
================================================
Issue Number: OE00183507
     OEE: AdminServer fails to start after adding CPU memory resource

AdminServer fails to restart after adding CPU or memory resources to
server. CPU and memory resources should not be available in OpenEdge
Explorer

Issue Number: OE00190631
     10.2A01 AdminServer fails to convert V9 ubroker.properties file

A 9.1D09 ubroker.properties file is not converted when upgrading it by
starting the 10.2A01 AdminServer.

================================================
AppServer Agent
================================================
Issue Number: OE00176777
     Multiple async requests on Statefree AppServer causes Error 8111

Multiple asynchronous request on statefree AppServer passing large number
of temp-table parameters causes errors 8111.

Issue Number: OE00187056
     Second AppServer agent can't open dataserver log file

When the first agent is started a dataserv.00001.lg is created. After the
second is started, it creates the dataserv.lg and produces the errors: 
Cannot open log file dataserv.lg, errno 32 (11076)
Unable to open dataserver log file. (2683)
Failed to connect to ORACLE database <db-name>. (1451)

Issue Number: OE00187177
     Appserver agent fail to start when server log file is 2 GB

AppServer or WebSpeed broker reports errors trying to start an agent when
the log file reaches 2 GB in size.

Issue Number: OE00190124
     Client crash on call-back from asynchronous AppServer call

The session crashes when running on session handle, but not on server
handle, the temp-table on the AppServer for output table-handle is not
prepared.

================================================
AppServer Broker
================================================
Issue Number: OE00184165
     Invalid priority weight can cause NameServer to crash.

Invalid priority weight can cause NameServer to crash.	Setting an
AppServer broker to have a priority weight which is negative will cause
the NameServer to crash the first time the NameServer is queried to
connect to the AppServer broker with the negative priority weight.

Issue Number: OE00184981
     AppServer Broker dies log indicates could not create thread

AppServer Broker dies and the AppServer broker log shows this error:
java.lang.OutOfMemoryError: unable to create new native thread

================================================
AppServer Other
================================================
Issue Number: OE00180722
     The jvmStart.exe utility is vulnerable to buffer overflow

The progress jvmStart.exe utility on Windows crashes when very long values
are provided in its parameters.

================================================
DATASERVER DataServer
================================================
Issue Number: OE00183297
     SQL Server DS crashes doing find prev if  no record is available

SQL Dataserv crashes doing find prev if  there was no record available

Issue Number: OE00187031
     Error 3279 loading delta df generated by DataServer's delta tool

Loading a. df file that contains a new field with an assign trigger into a
DataServer schema may generate error 3279.

Issue Number: OE00192231
     build__ora10apsv.sh buildora9apsv.sh scripts miss orsys.o object

on 64 bit AIX,build__ora10apsv.sh buildora9apsv.sh scripts miss orsys.o
object

Issue Number: OE00192476
     Error 3263 when assigning buffer-field value on DataServer table

Updating a field using buffer-handle syntax causes the following errors
when table is in some DataServer schema and there is an assign trigger on
the field.

Array subscript <index> is out of range. (2715)
Error extracting field at record position <rpos> from buffer <buffer> for
running an ASSIGN trigger. (3263)

================================================
DATASERVER DB2
================================================
Issue Number: OE00128393
     Unable to create a Server Schema with name containing 'as400'

Error 293 when creating a Server Schema with logical name containing
'as400' string

Issue Number: OE00135486
     MAX_ROWS parameter causes performance degradation

Setting -Dsrv MAX_ROWS parameter in ODBC DataServers results in
unnecessary SQL statements and performance degradation.

Issue Number: OE00176055
     Data gets corrupted when using UTF-8 client with ODBC DataServer

When insterting extended characters from a client session started with
-cpstream utf-8 -cpinternal utf-8 the string is appended with additional
trailing, random characters.

Issue Number: OE00191143
     ODBC DataServer for AS/400 does not right trim CHAR fields

ODBC DataServer for AS/400 does not right trim fixed-length character
fields

================================================
DATASERVER MSSQLSRV
================================================
Issue Number: OE00169420
     Record read is very slow with MSSDS

Record read with NO-LOCK is very slow with Microsoft SQL Server DataServer

Issue Number: OE00176360
     find prev finds the first record after find current exc lock

find prev finds the first record after find current is run with exclusive-
lock

Issue Number: OE00176635
     MS SQL GPF when using field-list joining 4 tables

MS SQL Dataserver crashes (GPF) while  joining 4 tables with field-list.

Issue Number: OE00178470
     dictionary load large table >1M records randomly missing records

dic load large table > 1M records into MS SQL server randomly missing
records

Issue Number: OE00180241
     GPF when running/compiling code against MSS

Progress session crashes when compiling/running code against SQL
DataServer schema holder; problem does not occur when compiling/running
the same code against a Progress database.

Issue Number: OE00181014
     Client hang/crashes after REPOSITION with MSS DataServer

The client may crash or hang after it has executed a REPOSITION on a table
with a fields with non-default collation and when you turn off binding.

Issue Number: OE00181255
     ABL client gpf with a simple query if timestamp field is present

ABL client gpf with a simple query syntax check if timestamp field is
present on the MS SQL server database.	The timestamp field is removed
from schema holder for non-support.

Issue Number: OE00181560
     SYSTEM ERROR: Date in where clause with native client 10 driver

When the given ABL is executed with SQL native client 10 driver it raises
errors, for example:
- SYSTEM ERROR:Assignment error.(6177)
- 22005:[Microsoft][SQL Server Native Client 10.0][SQL Server]Operand type
clash: datime2 is incompatible with int.
- 37000: [Microsoft][SQL Server Native Client 10.0][SQL
Server]Statement(s) could not be prepared.

Issue Number: OE00182302
     getting sequence number randomly writes irrelevant data

when two sessions concurrently running getting sequence number randomly
writes irrelevant data

Issue Number: OE00183323
     Preselect query with by clause with non-indexed field crashes

Running a PRESELECT query with a BY clause that includes a field that
isn't part of an index causes the client to crash

Issue Number: OE00183774
     Buffer-value returns 14/02/01 when Initial value is Today

Temp-Table buffer-value always returns the initial value Today of a date
field as 14/02/01  when connecting to the SQL Database Schema Holder

Issue Number: OE00184300
     Error 9010 compiling large .p file against SQL server

Error 9010 compiling large .p object file against SQL server

Issue Number: OE00185731
     Query reposition corrupts browse sorting

When performing a search with a query reposition on the query of a browse,
the searched record is found but the following records are not sorted
properly.

Issue Number: OE00186215
     SQL statement gets corrupted when using UTF-8 dataserver schema

The SQl statement send to the MS SQL server database is corrupted when the
string to search for contains more than one extended character and when
the dataserver schema is set to UTF-8

Issue Number: OE00186593
     Use Computed Columns to maintain progress_recid

Use Computed Columns to maintain progress_recid in MS SQL 2005 and above

Issue Number: OE00186961
     update inside "for each" causes many SQL sent to MSS SQL

When "update exclusive-lock" is inside "for each", even the tables are not
related, and there is single update, many many SQL statements are
generated and sent to execute by SQL server causing performance decrease

Issue Number: OE00188693
     unable to create record in migrated unicode MSS schema holder.

unable to create record in migrated unicode MSS schema holder since the MS
SQL Serve Progress recid trigger is missing on each table.

Issue Number: OE00188806
     Error 6176 when parameter length exceeds MSS field length

Error 6176 and SQL error 22001 are displayed when the length of a query
parameter exceeds the length of the field in MSS or DSRVR-PRECISION and
DSRVR-LENGTH values

Issue Number: OE00189115
     Error 6175 comparing dates against 12/31/9999.

Error 6175 comparing dates against specific date 12/31/9999.

Issue Number: OE00189701
     protoMSS fails to create tbl if initial value has a single quote

ProtoMSS fails to create a table with Unicode type fields on the MS SQL
Server Database if a OE field contains a single quote (') for the initial
value

Issue Number: OE00191096
     Date fields displayed as empty with MS SQLServer

Date fields with Initial value TODAY displayed as empty with MS SQLServer

Issue Number: OE00192848
     GPF after error 6170 after MS SQL connection pooling turned off

cursor error 6170 using CONNECTION_POOLING,0,PRGRS_CACHE_CONN,30

Issue Number: OE00193679
     Lock wait timeout error when using Forced connection

Error 2624 when connection pooling is turned off

================================================
DATASERVER ORACLE
================================================
Issue Number: OE00077432
     Errors 3782 & 480 using FIELDS option with DataServer for ORACLE

The error messages below appear when using the FIELDS option in a query
with buffer against an Oracle database :
   Field 6 from b_cust2 record (recid -718) was missing from FIELDS phrase
(3782)
   umBrowseGetCellValue was not successful (480)

Issue Number: OE00110472
     Errors 2715, 2717, 4920, 4952 when using RAW-TRANFER

When using RAW-TRANSFER method with a dynamic buffer object against an
Oracle database, the following errors can occur:

RAW-TRANSFER - from XXX buffer to YYY field 
"Array subscript 0 column name missing. (2717)"
"Could not update target field in RAW-TRANSFER statement. (4920)"

RAW-TRANSFER - from YYY field to XXX buffer
"Array subscript 0 is out of range. (2715)"
"Could not extract raw value from source field of RAW-TRANSFER. (4952)"

Issue Number: OE00159050
     Ubroker.properties contain wrong default value for Oracle Server

When creating a new Oracle DataServer broker in Progress Explorer, the
entry will contain the wrong default value for Oracle Server Executable
file

Issue Number: OE00172778
     Error 48 when using FIELDS option and QRYINFO and ORACLE DS

Error 48 when using FIELDS option and QRYINFO and ORACLE Dataserver.
Corrected a issue with memory alignment on 64-bit solaris arch.

Issue Number: OE00175232
     find next can not find record if find first uses "use index"

If these is a "use -index" in find first, find next can not find specific
record, this only occurs to specific record

Issue Number: OE00177154
     find next skips records with indexed null columns

when index has many components and records has null values for the indexed
columns, find next does not find these records

Issue Number: OE00177420
     Data gets corrupted when using UTF-8 client with Oracle DS

When connecting a UTF-8 client to an Oracle database via the DataServer
product this causes data corruption due to incorrect codepage conversions.

Issue Number: OE00177602
     FIND with EXCLUSIVE-LOCK unsuccessful on Oracle Dataserver

There is a rare situation where, when a FIND with EXCLUSIVE-LOCK can fail
even though the same find with NO-LOCK is successful.  This occurs when
the dataserver level code confuses cursors and executes the find against
the incorrect table.  To workaround this issue one could use the -Dsrv
skip-schema-check.

Issue Number: OE00180196
     Buffer overflow errors when a foreign table contains many fields

The following errors are eager to occur when querying an Oracle table that
contains a large number of columns (array extents):
ORACLE row may exceed 32k - can't allocate buffer for table ADMINOPALE.PRO
(328) (6447)
Insufficient memory to allocate buffer for ORACLE (5038)

Issue Number: OE00181807
     Warning from Oracle causes RUN STORED-PROC to fail

Warning of a NULL column in an aggregate function from Oracle causes RUN
STORED-PROC to fail.

Issue Number: OE00182056
     Oracle ORA-01841 seen in certain situations with date in where

In certain situations error "ORA-01841: (full) year must be between -4713
and +9999, and not be 0" is seen using bind variables and having date in
the where clause. In the dataserver log it can be seen that the wrong
variable type is being used for the query.

Issue Number: OE00182856
     BLOB field prevents correct display of other fields

Oracle Dataserver: A BLOB field created before fields with other datatypes
may prevent these other fields being displayed correctly in a FOR EACH
...NO-LOCK query. 

Issue Number: OE00184406
     High CPU usage after disconnection when using external credentia

When executing "select * from v$session", the session was still be there.

Issue Number: OE00184464
     Frequent connects/disconnects to Oracle DB cause memory leak

If a process repeatedly connects to/ disconnects from an Oracle databases
it is leaking memory.

Issue Number: OE00186735
     Client crashes w/err 49 when >1 SH is connected at startup

The ABL character client gives warning error 1012 and then upon pressing
enter on the OK, the client crashes with error 49.

Issue Number: OE00187059
     CAN-FIND with shadow columns causes loop

Executing a CAN-FIND query against an Oracle DB using shadow columns
appears to cause an infinite loop

Issue Number: OE00190509
     Error 1444 updating an int field

Error 1444 updating an int field with Oracle Dataserver.

================================================
DATASERVER Other
================================================
Issue Number: OE00184262
     Error 11076 connecting more than 31 DataServer schemas

Error 11076 connecting the 31st DataServer schema reported in the
dataserv.lg file, with o.s error 0 (zero)

================================================
DATASERVER PODBC
================================================
Issue Number: OE00176741
     ODBC err 23000 inserting records on DB2/400 for "?" init value

When creating records on the DB2/400 through OE10 ODBC DataServer using
DataDirect wire protovol driver get ODBC error 23000.

Issue Number: OE00185808
     Err 3165 trying to reposition records on the browse using ROWID

Error 3165 when trying to reposition records during browse using ROWID

Issue Number: OE00189853
     ODBC driver does not pull column labels from DB2/400

ODBC Driver or IBM client access driver does not pull column label and
description information from DB2/400 datasource.

Issue Number: OE00189927
     Errs 6199 & 6200 pulling tbl w/fld data type Time frm DB2/400

Errors 6199 and 6200 when pulling a table with field that has TIME data
type from DB2/400.  The table is not pulled because of the errors.

Issue Number: OE00192165
     x(1) char field data is truncated with ODBC DataServer

Single char field data is truncated when displaying with a simple query
using -Dsrv PRGRS_MAPFIXEDCHAR against ODBC  DataServer.  This CR is
related to the FIX for the CR OE00191143.

================================================
DB 4GL
================================================
Issue Number: OE00179995
     Server may terminate if query contains SUBSTITUTE function

If a query contains the SUBSTITUTE function and gets executed by a 64-bit
client or against a 64-bit server, it may cause the server to terminate
abnormally.

Issue Number: OE00183802
     Enabling Statement Caching Can Cause Client Crash

Enabling statement caching via promon can cause 4GL client code to crash
while holding a latch on the database which in turn causes the database to
be shut down.

================================================
DB bm
================================================
Issue Number: OE00180138
     Database connection takes longer in 10.1C

The time it takes for a process to connect to a database has increased
when a large -B is specified when the database is started.

Issue Number: OE00183719
     TYPE II not reusing space after table delete

Chanalys reports error 14160 after chains are rebuilt through dbrpr
following table schema deletion, which leads to clusters being unavailable
for re-use.

================================================
DB Cluster
================================================
Issue Number: OE00186557
     procluster enable with -pf fails and produces coredump

When trying to make a DB cluster aware on HP-UX 11.23 Itanium 64-Bit and
specifying the -pf file, procluster fails and produces a coredump /
protrace.

================================================
DB cx
================================================
Issue Number: OE00177223
     DB crashes with error 645 and cxDoSplit - data too long errors

Database crashes with (645) error and cxDoSplit - data too long errors

Issue Number: OE00188662
     (1422) errors when deleting records while running idxactivate

Clients that are deleting records from a database while an online
idxactivate is being run may get " (1422) Index <name> in <table> for
recid # could not be deleted" errors upon completion of the idxactivate.

================================================
DB db
================================================
Issue Number: OE00161719
     DB started via AdmSrv w/System Account has proshut issues

Databases started by the AdminService on Windows that  is owned by "System
Account" allows forced shutdowns but not unconditional shutdowns.

Issue Number: OE00166346
     Unable to use UNC pathing

AI Extents cannot be archived to a Windows UNC path.

Issue Number: OE00175844
     dbrpr not scanning all areas if ais are mixed in w/ data extents

Database structure with ai files interspersed in between data and index
areas causes dbrpr to not scan all areas.

Issue Number: OE00176456
     Attempt to return record with DBKEY > 32-bits to an older client

When trying to query a table in a 10.1C database from a remote client
running 10.1A, the for each query fails and the following error appears in
the database log file:

 (-----) Attempted to return record with DBKEY > 32-bits to an older
client.

The record, however, does not have a DBKEY > 32 bits and can be retrieved
with a find statement using the recid of the record.

Issue Number: OE00177177
     memory leak in database connection

Processes, for example _proapsv, which repeatedly connect and disconnect
to the database grow very large. Error 5402 (Unable to create thread for
proshut, error = 8. ) may be seen in the database log. Eventually
application errors related to memory may be seen, for example, error 9104
(Unable to allocate memory for token array.)

Issue Number: OE00179544
     promon / proshut login/logout is not in the log file

promon and proshut utilities do not log their login or logout into
database log file

================================================
DB DBRPR
================================================
Issue Number: OE00172122
     dbscan falsely reports index corruption

dbscan falsely reports index corruption.  idxcheck and idxfix do not
report this corruption.

================================================
DB DBTLS
================================================
Issue Number: OE00183665
     DBTool failure to fix SQL-WIDTH causes Query to fail

DBTool failure to fix the SQL WIDTH of a decimal field causes SQL query to
fail

Issue Number: OE00185026
     Error 49 truncating "Old Default Area" area

Unable to truncate "Old Default Area" area 

================================================
DB dbutil
================================================
Issue Number: OE00182083
     Prodb fails to mapped vm drive with (8265) and (4524) errors

Prodb/procopy fail  with (8265) and (4524) errors when creating a database
without an existing void structure on a mapped vm drive.

Issue Number: OE00191546
     Memory violation with idxcompact and long indexes

Memory violation wth idxcompact on some long indexes (characters > 300).

================================================
DB dsm
================================================
Issue Number: OE00180634
     On-line index activation causes (1422) system error

If you add an inactive index on-line and put it in the "prepare to
activate" mode, then when anyone tries to update the fields that
participate in the index, you get system error (1422).

Issue Number: OE00186640
     (1422) errors when deleting records while running idxactivate

Clients that are deleting records from a database while an online
idxactivate is being run may get " (1422) Index <name> in <table> for
recid # could not be deleted" errors upon completion of the idxactivate.

================================================
DB Encryption
================================================
Issue Number: OE00190344
     Prorest with -newinstance is not rebinding keystore for TDE

The key store 'rebind' operation fails after restoring a TDE database with
the -newinstance option.

================================================
DB lat
================================================
Issue Number: OE00184551
     Latch performance benefit by changing select() to nanosleep().

Improved latch performance can be achieved by changing select() to
nanosleep()

================================================
DB maj version
================================================
Issue Number: OE00179620
     Binary load fails with message -1223.

Getting error when performing a binary load of data.
Error creating record <record number>, error -1223.
Binary Load failed. (6255)

Issue Number: OE00184191
     CreateLimit TossLimit violation on Type I Storage Areas

If the CreateLimit/TossLimit is changed from the defaults:
1. When a table is moved TO the Type I area, that Table's create /
tosslimits are preserved
2. When a new table is loaded to the Type I area, the default createlimit/
tosslimit is set

================================================
DB NET
================================================
Issue Number: OE00176760
     (14829) SYSTEM ERROR: Invalid key length encountered

Defensive code has been added to identify and deflect attempts by a client
to pass keys with invalid lengths for the index key. 

================================================
DB Other
================================================
Issue Number: OE00177639
     4GL connections to a database are leaking memory

4GL connections are not releasing memory that were allocated on their
behalf.

Issue Number: OE00182956
     The VST _Logging-AiJournal is not accurate

The VST _Logging-AiJournal always shows after imaging as enabled, even if
it is disabled.

Issue Number: OE00183518
     DateTime-TZ Field in audit data has wrong format

When enabling auditing for a DATETIME-TZ field the value that is actually
written to the audit tables has a colon between the seconds and
milliseconds part of the value instead of the expected period.

================================================
DB probkup
================================================
Issue Number: OE00187004
     prorest will not enable large files

Prorest of normal database to .st with > 2GB extent will not enable large
files

================================================
DB prolog
================================================
Issue Number: OE00180941
     prolog fails if lg file > 2 GB

prolog (offline and online) fails if the lg file > 2 GB

================================================
DB PROSTRCT
================================================
Issue Number: OE00175730
     Adding extent online doesn't allow for EGID on new extent

Sometimes doing a prostrct addonline fails even though all clients could
access the new extent due to the use of a script with setgid setting up an
EGID on the users process

================================================
DB proutil
================================================
Issue Number: OE00165601
     auditarchive with -directory of c:\ give authorization error

Running auditarchive with a user that has permissions to archive and
-directory c:\ you get the message "The user is not authorized to perform
auditarchive operations"

Issue Number: OE00176164
     Binary load table with UTF-8 CLOB crashes session

When attempting to binary load a table which contains a  UTF-8 CLOB the
binary load session crashes

Issue Number: OE00178790
     Bulkload inserts extra CR character when run against UTF8 db

When loading records into a UTF8 database via bulkload and with
-cpinternal UTF-8, the CHR(13) character is added to some records (2 out
of 10 records).

Issue Number: OE00179310
     idxcompact requires more bi file space in 10.1x than 9.1E

Using idxcompact with tables where a large number of records are deleted
and the indexes are not freed up at record delete time (leaving blocks
associated with them), can exhaust bi during the idxcompact operation.

Issue Number: OE00185539
     updateschema doesn't add the _sysprocbin and _sysproctext tables

The updateschema option of the proutil utility will load the newest
meta-schema for the current release of OpenEdge that you are running. In
10.1C, support for SQL stored procedures was added to the 64 bit releases
of OpenEdge. Prior to that, support for stored SQL stored procedures was
not available. If you run the 10.1C proutil utility with the updateschema
qualifier on a 10.1B database, it does not add the meta-schema tables
(_sysprocbin and _sysproctext) needed for stored procedures.

================================================
DB rc
================================================
Issue Number: OE00181132
     Error 11425 after binary load into a type II storage area

A table residing in a type I storage area was binary dumped then the table
definitions were loaded into a type II storage area and data was binary
loaded back. 
RAW-TRANSFER statement fails on any records binary loaded.

================================================
DB rfutil
================================================
Issue Number: OE00181957
     Roll forward AI fails fails when sequence is larger than 65535

When the ai sequence number is larger than 65535, rolling forward fails
with an (8019) error.

Issue Number: OE00188661
     Database hangs when performing rfutil aimage new

The database may hang when performing rfutil aimage new under some
conditions.


================================================
DB Nav Other
================================================
Issue Number: UNUM00000709
	DB Navigator>Edit Column>Finish button not enabled after Edit

When using the Edit button > Text Editor to enter text into the View As or Validation
fields in the Edit Column dialog of DB Navigator, the Finish button is not immediately
enabled.


================================================
Diagnostics 4GL Debugger
================================================
Issue Number: OE00181505
     AVM terminates unexpectedly when debugging code in Architect

The OpenEdge AVM may terminate unexpectedly when debugging code in the
Debug perspective of OpenEdge Architect; the same code will execute
correctly when not debugging. This issue occurs when the code being
debugged includes a dataset as a parameter.

================================================
Diagnostics 4GL Trace
================================================
Issue Number: OE00179035
     Client may crash if 4GLTrace is enabled with level 3 or higher

Client may crash when 4GLTrace is enabled with level 3 or higher and
procedure / method returns an output dataset BIND. It may also crash when
procedure / mehtod returns a dynamic dataset with no name defined.

Issue Number: OE00183279
     Client logging does not report INPUT-OUTPUT buffer

BUFFER parameters are not logged anymore by the client 4GLTrace return
logging

================================================
Diagnostics GUI Debugger
================================================
Issue Number: OE00112321
     Using Debugger causes crash with error 16

When using the Debugger, under specific circumstances the Progress session
will crash with error "SYSTEM ERROR: bffld: nxtfld: scan past last field.
(16)" at the moment the Debugger is given control.

Issue Number: OE00173335
     Architect Debugger may fail with a large number of breakpoints

If you are debugging a program in which you have set a large number of
breakpoints, you might find that the OpenEdge Architect Debugger produces
a memory violation. The number of breakpoints at which the violation
occurs is dependent on several different factors, including the length of
source file names.

Issue Number: OE00174204
     Debugger raises SE 290 when debugging r-code with UTF-8 client

When r-code compiled in a session with -cpinternal 1252 is run in a UTF-8
client (-cpinternal UTF-8), an attempt to run the debugger will crash the
session with system error 290.

Issue Number: OE00186889
     Form does not paint correctly when debugging

The controls on a .NET form may not be displayed correctly when debugging
the application using the OpenEdge Architect Debugger or the ABL Debugger.

================================================
Diagnostics Other
================================================
Issue Number: OE00164148
     PROEVENTS logging crash on end of READ-RESPONSE trigger

When logging of types ProEvent.* is turned on, the session crashes when
logging the end of a READ-RESPONSE trigger, if the socket is deleted (e.g.
DELETE OBJECT SELF).

Issue Number: OE00173256
     Client generates 11076 error too many times with -logthreshold

Client generates 11076 error too many times when specifiying -logthreshold
if -clientlog is set to a file that is already in use by some other
session.

================================================
Doc ABL
================================================
Issue Number: OE00113958
     BATCH-SIZE and LAST-BATCH reference entries are incorrect

BATCH-SIZE and LAST-BATCH reference entries in the documentation are
incorrect, referring to 'Temp-table Object handle' instead of 'Buffer
Object handle'.

Issue Number: OE00114199
     The use of "(", ")" & "*" missing from CONTAINS reference entry

The use of "(" and ")" to determine expression precedence, and "*" at the
end of words to indicate wildcards is not mentioned in the 4GL CONTAINS
operator.

Issue Number: OE00116884
     QUERY-PREPARE & GET-* methods are NO-LOCK

The documentation does not make it clear that the QUERY-PREPARE and GET-*
methods for dynamic queries default to using NO-LOCK if no lock status is
specified.  This behavior is different than the default for static
queries.

Issue Number: OE00121279
     LENGTH function does not return bytes in a RAW or BLOB field

Documentation issue. The following statement from the LENGTH function
definition is incorrect:
"Returns the number of bytes in an expression of type RAW or a BLOB
field."
The LENGTH function returns the number of characters in the expression
rather than the number of bytes.

Issue Number: OE00129242
     GET-STRING() function description in documentation is incorrect

The GET-STRING() function in ABL Reference contains the following syntax
description: 

numbytes 
... If position plus numbytes is greater than the length of source,
Progress returns the Unknown value (?).

This should read: 

... If position is greater than the length of source, Progress returns the
Unknown value (?).

Issue Number: OE00134889
     Wrong documentation example for the ADD-SUPER-PROCEDURE() method

An example for the ADD-SUPER-PROCEDURE() method entry in ABL Reference is
incorrectly coded. It uses the following syntax which causes the AVM to
return a compile-time error:

RUN add-record('customer') IN my-proc-hdl. 

In this example, you must use the following format to pass parameters to
the super procedure:

RUN add-record IN my-proc-hdl ('customer'). 

Issue Number: OE00135812
     Documentation updates for DEFINE TEMP-TABLE statement

The reference entry for the DEFINE TEMP-TABLE statement does not mention
the following points:
BEFORE-TABLE cannot be used with SHARED when defining a static TEMP-TABLE.

TEMP-TABLES must be defined with a BEFORE-TABLE in order to use
TRACKING-CHANGES.

Issue Number: OE00136216
     Multi-level REPOSITION does not guarantee record availability

Fixed documentation on multi-level REPOSITION and record availability.

Issue Number: OE00136236
     COLOR-TABLE Entries must be Dynamic for SET-* Methods

The documentation was not clear that when using any of the SET-* methods
of the COLOR-TABLE handle, the color that is being manipulated must first
be made dynamic by using the SET-DYNAMIC method,.

Issue Number: OE00151996
     Documentation incomplete for DEFINE TEMP-TABLE syntax

The keyword "AS" is accepted as an alternative to "IS" for INDEX
definitions.

Issue Number: OE00162590
     x-noderef object UNIQUE-ID is unique only for an x-document

The UNIQUE-ID attribute of an x-noderef object is unique only for
consecutively created x-noderef objects of a single x-document object. 
Thus, for x-noderef objects of different x-document objects created in the
same ABL session, the UNIQUE-ID attribute is not unique.

Issue Number: OE00173470
     Doc for QUERY-PREPARE( ) method contains misleading statement

In both OpenEdge Development: ABL Essentials, as well as in the online
documentation, the following statement is both ambigious and misleading:

"If the QUERY-PREPARE method encounters an error, it returns FALSE and
does not raise an error."

Issue Number: OE00174889
     Dataset/Temp-Table method doc should mention buffer state

When executing one of the following methods on a temp-table or ProDataSet,
and the default buffer of one of the contained temp-tables is available,
there is no guarantee as to the state of that buffer after the method has
finished executing:

WRITE-XML
READ-XML
FILL
SAVE
Any Reject/Accept type activity 

The default buffer is needed for read/create/write operations and its
momentary contents are not guaranteed after the operation is completed.  

For example, table contents before and after execution of the WRITE-XML
method should be the same. However, when using the default buffer to
handle the write, its position and state are not guaranteed. A named
buffer should be used if there is any expectation of buffer availability
after the method completes.  

For the other methods listed above, there is no guarantee that the
temp-table is going to contain the same data afterward, so no such
expectation is even considered reasonable.

Issue Number: OE00176800
     Missing comma in DEFINE DATA-SOURCE doc (ABL Reference)

The DEFINE DATA-SOURCE statement description in ABL Reference, page 315,
describes the source buffer phrase as follows:

source-buffer-phrase [ source-buffer-phrase ] ...

It should include a comma as follows:

source-buffer-phrase [, source-buffer-phrase ] ...

Issue Number: OE00177363
     Example provided in documentation leads to buggy source code

In the "QUERY-PREPARE( ) method" section of the ABL reference manual,
there is an example which uses the STRING function, where it should use
QUOTER to avoid potential issues.

Using the ABL QUOTER function instead of the STRING function has the
following two advantages:

1) For the DECIMAL and DATE data types, the constant referred to with the
QUOTER function is OK in non-american format

2) QUOTER transforms the Unknown value to the question mark (?) character.

Issue Number: OE00177881
     Doc says: DBTYPE function returns OpenEdge instead of Progress

The reference entry for the DBTYPE function incorrectly states that it
returns "OpenEdge", instead of "Progress".

Issue Number: OE00178888
     DOC: ProBindingSource SetFields() method syntax error

In "OpenEdge Development: GUI for .NET Programming", page 4-17, the syntax
of SetFields()	method is given as:

SetFields( INPUT include-fields AS CHARACTER, INPUT except-fields AS
CHARACTER, {""|INPUT parent-buffer-hdl AS CHARACTER|INPUT
parent-buffer-name AS CHARACTER} )

Since the "parent-buffer-hdl" is a HANDLE, the correct syntax should be:

SetFields( INPUT include-fields AS CHARACTER, INPUT except-fields AS
CHARACTER, {""|INPUT parent-buffer-hdl AS HANDLE|INPUT parent-buffer-name
AS CHARACTER} )

Issue Number: OE00178889
     DOC: Syntax error in ProBindingSource code sample.

The locally defined variable hRelation sample code given for "PROCEDURE
recursiveRelationCreateRow" on Page 4-38 of the "OpenEdge Development: GUI
for .NET Programming" manual is referenced before it is assigned a valid
value.

Issue Number: OE00178890
     Syntax error in Introducing Visual Designer code sample.

In the sample code on page 3-16 of the "OpenEdge Getting Started:
Introducing the OpenEdge Architect Visual Designer", the sample code has a
syntax error.  It uses an OpenQuery() statement after the END CATCH
statement.

Issue Number: OE00179258
     OS-ERROR doc page contains error in example code

In the ABL Reference, the "OS-ERROR function" page contains the example
procedure, r-os-err.p. This code contains the line:

OS-DELETE filename.

It should be:

OS-DELETE VALUE(filename).

Issue Number: OE00180231
     CLOB & BLOB restriction on initial value not documented

In the Data types section of the ABL reference, "Table 21: Default ABL
data type initial values and display formats" does not show that BLOB and
CLOB data types cannot have an initial value defined. 

The restriction "3. You cannot use the INITIAL option to specify an
initial value for this data type as part of the definition of a variable,
procedure parameter, or class-based property." applies to these datatypes.

Issue Number: OE00183609
     The TITLE-FONT attribute cannot be modified

Contrary to what some sections of the documentation state, the TITLE-FONT
attribute of a frame widget uses the default font and cannot be modified. 
It is writeable only for backward compatibility and setting this attribute
has no effect on its value.

Issue Number: OE00183654
     Keyword Index Help Missing Entries

The MTIME function is missing in the Keyword Index help.

Issue Number: OE00184312
     ERROR-STATUS handle reference entry has bad example

The sample code in the ABL Reference entry for the ERROR-STATUS system
handle has flawed logic.

The line:
 IF ERROR-STATUS:ERROR AND ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:

should be changed to:
 IF ERROR-STATUS:ERROR OR ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:

As written, it fails to catch display messages for which the
ERROR-STATUS:ERROR attribute is not set to TRUE.  There are many such
messages raised within ABL, such as most messages raised by ABL functions
or handle methods.

Issue Number: OE00189949
     Some ABL statements omit Windows-only notations in Online Help

Some ABL statements (such as LOAD, GET-KEY-VALUE, USE, etc.) omit
Windows-only notations in Online Help. The ABL Reference manual does
include the Windows-only notation for such statements.

Issue Number: OE00191460
     ABL Reference states that ROWID as the key is not supported

The ABL Reference entry for the DEFINE DATA-SOURCE statement should not
contain the following warning:

"Note: Using ROWID as the key is not currently supported."

(10.2A documentation, ABL Reference, page 320)

Issue Number: OE00191730
     Example in Programming Interfaces manual does not compile

The decryption example in OpenEdge Development: Programming Interfaces,
page 2-58, does not compile and generates the following error:

** Incompatible data types in expression or assignment (223)

================================================
Doc AppServer
================================================
Issue Number: OE00156973
     New Appserver properties documented in Ubroker.properties.README

Previous versions did not have pointers to the ubroker.properties.readme
file as the place to look for new AppServer startup parameters.

================================================
Doc Database
================================================
Issue Number: OE00120842
     A clearer explanation of how -io works with probkup

More details are required regarding how the -io flag disregards full
backup
boundaries backing up into the full backup blocks.

Issue Number: OE00182241
     Proutil Dump qualifier doc says code page is not recorded

In OpenEdge Data Management: Database Administration, the PROUTIL DUMP
qualifier documentation notes entry states, "PROUTIL DUMP does not record
the code page of the data it writes to the dump file."
 
This is no longer correct in OpenEdge.

Issue Number: OE00185256
     The size value in the prorest -list output is undefined

In the output of the prorest -list command, used for creating .st file
from a backup, it is not immediately obvious how the size value relates to
anything.

================================================
Doc DB Util
================================================
Issue Number: OE00182561
     -verbose option missing in the PROREST syntax

The -verbose option is missing from the syntax portion of the "PROREST
utility" section in the Database Administration manual. This is incorrect,
as the -verbose option can in fact be used with prorest.

================================================
Doc Dynamics
================================================
Issue Number: OE00182824
     Relation between Dynamics services and connections unclear

The documentation for Progress Dynamics doesn't clearly state the
relationship between Dynamics logical services,  Dynamics physical 
services, and the actual connections the ABL client will make at runtime.
Specifically, a single physical service maps to a single connection from
the client to a server, regardless of how many logical services depend on
the physical service.

================================================
Doc EDOC
================================================
Issue Number: OE00183533
     Inaccurate documentation example in ABL Essentials

OpenEdge Getting Started: ABL Essentials, p. 10-2, contains the following
text:

"The update of the Order and its OrderLines happens as a single
transaction. If any errors are encountered in any of the updates, the
entire transaction is backed out."

Errors inside the "FOR EACH ttOline:" will be handled by the FOR EACH,
since the FOR has default error handling of UNDO, RETRY (or UNDO, NEXT
with infinite loop protection). The example code will undo the whole
transaction in the event of a system crash or if the error occurs outside
the FOR block, and not for any and all errors as the text suggests.

Issue Number: OE00183547
     The _file.filename is missing a dash on pages 76-78 of dpspr.pdf

The examples shown in the startup parameter descriptions of -baseindex and
-basetable, on pages 76 and 78 of dpspr.pdf and in the HTML version, are
missing a dash in _file.filename.

================================================
Doc Installation
================================================
Issue Number: OE00188024
     Silent install fails due to EULA MS Document Explorer 2005

Microsotf Document Explorer cannot be installed silently due to the EULA
that must be accepted interactively.

Issue Number: OE00189245
     Electronic License Addendum usage on UNIX install vague

The instructions for performing an installation on UNIX with an electronic
license addendum file are very vague in regard to how to proceed once the
file is accepted,  and then, if even possible, how to remove products
listed within the addendum via the installation utility.

================================================
Doc Other
================================================
Issue Number: OE00129089
     Documentation of permission enforcement for sequences is unclear

Permission settings for the_Sequence metaschema table  (CAN-READ,
CAN-WRITE, etc.) are enforced both at compile time and at run time. ABL
documentation does not clearly state that these settings apply in both
cases.

Issue Number: OE00192793
     AIMAGE END function does not zero out After Image files

The documentation incorrectly states that the AIMAGE END function zeroes
out the After Image files when in fact it's the AIMAGE BEGIN function that
zeroes out the After Image files.

================================================
Doc Replication
================================================
Issue Number: OE00190087
     Replication source and target need matching startup parms

Replication source and target need to have matching startup parameters to
avoid potential problems.  The documentation makes no mention of this.	

================================================
GUI 4GL
================================================
Issue Number: OE00122111
     Mouse-wheel scroll fails on browse with 3 rows or less

It is not possible to scroll a browse widget with the mouse wheel if the
browse widget has three visible rows or fewer. The browse scrolls as
expected if the browse has 4 or more visible rows.

Issue Number: OE00133400
     INPUT-VALUE for large longchar editor can fail

In some circumstances, for a dynamic editor that has LARGE = TRUE and
DATA-TYPE = "LONGCHAR", assigning its INPUT-VALUE to a longchar variable
fails with error "DITEM is not large enough to hold string. (4043)".

Issue Number: OE00134265
     Changing font truncates radio-set label

If a radio-set font is changed to a larger font, in some cases the font
label will be truncated.  This happens even if AUTO-RESIZE is set to TRUE.

Issue Number: OE00173348
     Strange behavior updating integer field w/ unknown initial value

A fill-in with an initial value of unknown (?) may display an incorrect
value if the user types a digit when the cursor is placed after the
question mark.

Issue Number: OE00173817
     Dynamic widget not fitting the frame causes the client to crash

OpenEdge may crash when a dynamic widget with a width that does not fit
the frame becomes visible. This issue occurs when the length of the
widget's NAME attribute exceeds about 50 characters.

Issue Number: OE00176716
     Events lost if MULTITASKING-INTERVAL greater than 0

The OpenEdge AVM ignores events from keyboard input if they are inserted
too fast. This occurs when the MULTITASKING-INTERVAL value is greater than
0 and an ABL trigger is performing a long operation.

Issue Number: OE00179158
     Object Attribute Reference PRO*Tool crashes session

When using the Object Attribute Reference tool from the PRO*Tools palette
and selecting the browse column object, the tool will crash the session.

Issue Number: OE00179223
     Formatting dynamic browse column in ROW-DISPLAY crashes session

Formatting the columns of a dynamic browse within a ROW-DISPLAY trigger
procedure may crash the session and generate a protrace file.

Issue Number: OE00179652
     Fill-in may display corrupted value

When a LEAVE event fires for a fill-in, the fill-in may display a
corrupted value.  This is more likely to occur when events are applied to
the fill-in programmatically.

Issue Number: OE00179795
     Fill-in formats destroyed when deleting characters

When using a format string with fixed fill characters on a fill-in (ie.
"xx-x-xxxx-xxx") pressing the BACKSPACE or DELETE keys to delete some
characters can also delete the fixed characters in the format.

Issue Number: OE00180108
     Unable to display content of variable using READ-FILE and ASSIGN

When using READ-FILE() and ASSIGN to read data into an editor, the data is
not displayed if the editor is not enabled.

Issue Number: OE00180337
     Combo-box with LIST-ITEM-PAIRS is slow to populate

A combo-box with LIST-ITEM-PAIRS is slow to populate not only when adding
items to the combo-box one at a time via the ADD-FIRST or ADD-LAST
methods, but also when adding the full list all at once by setting the
LIST-ITEM-PAIRS attribute.

Issue Number: OE00181543
     Session hangs when setting the format of a browse column

Setting the format of a browse column to a longer format may cause the
session to crash or hang.

Issue Number: OE00181858
     ASYNC evt-proc never fires when called from OCX trig

ASYNC event-procedure callback never fires when the ASYNC call is fired
from an OCX event procedure when the event is the result of user
interaction.

Issue Number: OE00181895
     INPUT FROM CLIPBOARD fails with large clipboards

INPUT FROM "CLIPBOARD" doesn't retrieve data when the clipboard contains
more than 32K of text. Error 4043 ("DITEM is not large enough to hold
string") is generated.

Issue Number: OE00182094
     Silent crash with INPUT THROUGH and large editor

The OpenEdge session silently crashes when receiving a long string through
INPUT-THROUGH and displaying it with a large editor.

Issue Number: OE00182118
     Return error on db  trigger generates wrong events on the UI

Return error on database trigger generates wrong events on the UI

Issue Number: OE00182809
     Using browse scrollbar arrows truncates column values

When the browse scrollbar arrows are used to scroll up and down the
browse, some values in the browse may be truncated.  Scrolling the browse
by moving the scrollbar's thumb or paging up or down by clicking above or
below the thumb  redisplays the correct values

Issue Number: OE00186591
     4GL Stack trace appears with F1 key regardless of key assignment

When pressing F1, the ABL debug stack trace dialog box appears even if the
F1 key is assigned to another function instead of help. This occurs when
SESSION:DEBUG-ALERT is set to TRUE.

Issue Number: OE00188503
     First line of DISPLAY output is transparent, but rest are opaque

An ABL procedure contains an OUTPUT TO PRINTER statement and several
DISPLAY statements in a REPEAT loop. The output is sent to a PDF file
through a third-party PDF writer program that installs as a printer
driver. The PDF writer applies a background image which the output from
any program sending its output to the printer is intended to write over.
The first line of the output from the ABL procedure appears transparent,
but the subsequent lines appear with an opaque background that obscures
the underlying image.

Issue Number: OE00188747
     UPDATE option of MESSAGE statement changes value on AppServer

If an ABL procedure running on an AppServer executes the MESSAGE ...
UPDATE <variable> statement, the value of the variable may be changed. The
variable's value should stay the same because there is no user interaction
on an AppServer.

Issue Number: OE00188982
     Restoring focus to window with deleted field causes crash

When focus switches from a window, the field that had focus is saved, so
that focus is put back into that field when the window regains focus. It
is possible that this field might be programmatically deleted. The field
information was not removed from the window. The memory for this field
information is then available for re-use. If this memory is re-used for
another field, the AVM can crash when restoring focus to the window.

Issue Number: OE00190954
     Focus rectangles not displayed when using DATA-ENTRY-RETURN

When DATA-ENTRY-RETURN is TRUE and the ENTER key is used to navigate
between controls, the focus rectangles are not turned on as expected.

Issue Number: OE00191167
     Flickering during moving and resizing widgets

Flickering occurs during runtime resizing and moving of ABL widgets in a
dialog box.

Issue Number: OE00192202
     Session hangs when applying ENTRY event to a temp-table field

The OpenEdge AVM hangs when an ABL program applies the ENTRY event to a
temp-table field. 

================================================
GUI ActiveX
================================================
Issue Number: OE00163824
     Error when a byte array > 32K is passed to an event handler

An error occurs when an ActiveX control attempts to pass a byte array that
is more than 32K as a parameter to an event handler.

Issue Number: OE00166851
     File_search method of DIRSRCH.DLL causes GPF with UNC target

The File_search method of DIRSRCH.DLL causes a GPF when a UNC path is
specified for the target or working directory.

Issue Number: OE00170079
     ABL fails to handle IUnknown return from COM object method

If a method from a COM object returns an IUnknown instead of an IDispatch,
the ABL client will fail to treat this as a COM-HANDLE. Calling subsequent
methods or attributes on this COM-HANDLE will generate the following
error:
Invalid component-handle referenced while processing method/statement:
<method>. (5884)
This same COM object works correctly with VisualBasic.

Issue Number: OE00173480
     COM event with OUTPUT parameters causes error 65 and hangs

If a COM event occurs where the event handler has one or more OUTPUT
parameters, error 65 can occur (SYSTEM ERROR: copditm -- maxdlen, data
item too large, try to increase -s.) and then the session will hang or
shut down.  One example is the MS TreeView v6 OLEDragOver event which
occurs when trying to drag/drop a child node.

Issue Number: OE00173726
     App Crashes After Exit When Migrated to 10.1C

Application appears to run normally in 10.1C/10.1C01 but when the user
exits the application normally a crash is generated if the application
uses COM objects due to an interaction between newer and older versions of
the Microsoft C Runtime library (specifically when the COM object uses an
older version of this library).

Issue Number: OE00178227
     Memory leak calling transformNode method of MSXML6.DLL

Memory usage of PROWIN32.EXE increases when calling  the transformNode
method of MSXML6.DLL, despite issuing the required RELEASE OBJECT
statements.

Issue Number: OE00178648
     Progress does not detect events from Camos COM object

Progress does not detect events from the Camos COM object despite
ENABLE-EVENTS being in place; VB6 and VBA can handle Camos events since it
can be written to use strong typing.

================================================
GUI ALL OTHER WIDGETS
================================================
Issue Number: OE00148769
     Wrong character in editor widget with UTF-8 and ANY-PRINTABLE

When a session is started with -cpinternal UTF-8, an editor widget
displays incorrect results when adding extended characters if an
ANY-PRINTABLE trigger is defined.

Issue Number: OE00181252
     VALUE-CHANGED event does not fire on EDIT-PASTE() in an editor

The VALUE-CHANGED event does not fire when clipboard data is pasted into
an editor widget with the editor's EDIT-PASTE method. VALUE-CHANGED does
fire when clipboard data is pasted into the editor with the Ctrl-V
keyboard shortcut. Both methods should work.

Issue Number: OE00182735
     HEIGHT-CHARS and HEIGHT-PIXELS don't modify the frame widget

When a dynamic frame is created, HEIGHT-CHARS and HEIGHT-PIXELS don't
modify the size of the frame. If the contents of the frame are output to a
file, the file will be empty.

================================================
GUI BROWSE
================================================
Issue Number: OE00148390
     Scrollbar cuts off data in last column in browse

The vertical scrollbar cuts off two pixels of the last column in a
horizontally scrolling browse.

Issue Number: OE00177267
     GPF in browse when cpinternal is UTF-8 and query has outer join

OpenEdge session may GPF when setting the SCREEN-VALUE of a browse cell to
blank if  using -cpinternal UTF-8 and there is an outer join in the browse
query.

Issue Number: OE00178473
     Crash in Browse widget on Vista

The session may crash when selecting the scrollbar down arrow on the
BROWSE widget.	The crash occurs when the browse widget does not contain
more rows than are able to fit in the viewport at one time.

Issue Number: OE00183221
     VALUE-CHANGED trigger gets fired twice when selecting a record

When multiple selection is enabled on Browse widgets, selecting a record
with the mouse will cause the VALUE-CHANGED trigger to be fired twice. For
example:
>> A message box is supposed to appear stating "value changed". You will
see this box appear a second time after you have clicked away the first
instance
>> This problem only appears when multiple selection is enabled
>> This problem only occurs with mouse actions

Issue Number: OE00184750
     BROWSE widget causes crash if trigger is fired recursively

Using a browse widget can lead to a crash under the following
circumstances:
- The browse has one or more enabled fields
- The browse has a ROW-DISPLAY trigger which changes the format for one or
more fields

- The browse has a trigger procedure set for another event (ie. 'END')
- This trigger procedure causes the browse query to be re-opened with a
different where-clause
- The trigger procedure also APPLY's the event it fired for to the browse
widget. (ie. causing trigger to be called recursively)

Issue Number: OE00188229
     Color is only refreshed when browse cell loses focus

If the background color of a browse cell is modified while the cell has
focus, the cell will not display the new color correctly until the cell
loses focus.

Issue Number: OE00188249
     Crash using PostMessage WM_LBUTTONDOWN with browse

The AVM can crash if using the Win PostMessage function with
WM_LBUTTONDOWN to set focus into a browse widget. This happens under the
following circumstances:
- the mouse cursor was located over a column separator (e.g. to resize the
column) in another browse on another window.
- the browse to which focus is being set has fewer columns than the browse
in the other window.

Issue Number: OE00189525
     Incorrect cursor behavior when resizing browse columns

When an attempt is made to resize the columns of a column-resizable browse
in a resizable frame by dragging the column border, the cursor changes
from the pointer to the double arrow as expected, but the border does not
move. If the cursor is moved outside the browse and then back over the
column border, it remains a pointer. However, if the point is placed over
the column border and an attempt is made to drag the border, it does move.
If the RESIZABLE attribute of the frame is made false, column resizing
works normally.

================================================
GUI COMBO
================================================
Issue Number: OE00131394
     Inconsistent results when canceling selection in a combo-box

If the user opens a combo-box's list and positions the mouse pointer over
an item but doesn't click to select the item, and then presses the Tab key
(thus canceling the selection), the combo-box's SCREEN-VALUE may be
incorrectly updated with that item. The VALUE-CHANGED event will not be
generated in this case.

================================================
GUI Combo
================================================
Issue Number: OE00175359
     Drop-down combo-box with mouse-event trigger crashes on WinXP

A drop-down combo-box with a mouse-event trigger (e.g.,
mouse-select-click) will cause the session to crash when clicked if
Windows XP themes are active.

Issue Number: OE00182076
     VALUE-CHANGED trigger of a drop-down combo-box fires too early

The VALUE-CHANGED trigger of a drop-down combo-box in a window embedded in
a .NET form fires before the combo-box's SCREEN-VALUE is updated.

================================================
GUI GUI
================================================
Issue Number: OE00174464
     GUI client crashes display images in a Citrix environment

The OpenEdge GUI client can crash when displaying images in a Citrix
environment. This can happen if images are stored in individual files,
rather than a procedure library. The protrace file will show a crash in
snbd12dm.dll.

Issue Number: OE00182635
     Dynamic flat button is added to the frame's tab items

When a dynamically created flat button is added to a frame, the button is
included in the frame's tab order unless the button's NO-FOCUS attribute
is explicitly set to TRUE.

================================================
Install Batch
================================================
Issue Number: OE00126898
     -psc_f1 setup parameter does not work with double quotes

When double quotes are used with -psc_f1 parameter during setup, the value
is not correctly handled.

================================================
Install Core Install
================================================
Issue Number: OE00163497
     Silent Installation of OpenEdge 102A is unable to read hyphen(-)

Silent Installation of OpenEdge 102A fails without error if the path to
the response or log file contains a hyphen / dash (-)

================================================
Install Install
================================================
Issue Number: OE00180895
     Error 193 when configuring the 10.2A ODBC driver on Win 64-bit

The following error message appears when creating a System DSN from the
ODBC Data Source Administrator:
    The setup routines for Progress OpenEdge 10.2A Driver ODBC driver
could not be loaded due to system error 193 

Issue Number: OE00183729
     Loading PSDN renewal file fails with -5011 : 0x80040707

Attempting to load a License Addendum file using License Update (or normal
setup.exe) fails with error when file contains PSDN license renewal
information

Issue Number: OE00188850
     OEManagement install requires non-existent destination directory

When performing an OEManagement installation, it expects that the
destination directory does not exist.  If it does, then erroneous
installation error messages are given to lead to believe there is a
terminal emulator issue or disk space limitation when it does not.

================================================
Install WebClient
================================================
Issue Number: OE00187242
     WebClient boostrap install fails to proceed with app install

Web deployed 10.2A WebClient and application fail to install using the
bootstrap.htm.
WebClient executable is installed, but application installation does not
proceed.

================================================
LANG 4GL
================================================
Issue Number: OE00067909
     DELETE trigger not disabled with ALLOW-REPLICATION

DISABLE TRIGGERS using the ALLOW-REPLICATION clause was disabling only
CREATE, ASSIGN, and WRITE triggers, and not DELETE triggers.

Issue Number: OE00087562
     CALL object cannot invoke .DLL procedure

CALL object was extended to also support dynamic invocation of DLL or 
shared library procedures. Unlike static invocation, there is no need  for

a user to first declare the procedure prototype before invoking it.  
To support DLL or shared library dynamically invocation using CALL object,

new attributes: LIBRARY, ORDINAL, RETURN-VALUE-DLL-TYPE  and
LIBRARY-CALLING-CONVENTION  were added to CALL object.

Issue Number: OE00115567
     ClientTimeOut parameter can't be read from a .ini file

The settings for ClientTimeOut parameter cannot be specified in the .ini
file.

Issue Number: OE00121269
     XREF file doesn't show the table name used in a frame query.

XREF fails to show the used table name when it is used in a frame query
and the query is not opened. 

Issue Number: OE00147739
     Messages 2252/2253 on state-reset AppServer with temp-tables

Messages 2252 and 2253 might be logged when a session on a state-reset
AppServer is disconnected with a temp-table passed by value.

Issue Number: OE00152295
     RUN STORED-PROC does not appear in the XREF listing

When compiling a .p with Xref the statement "RUN STORED-PROC
database.procedure" in 4GL/ABL the "RUN" reference does not appear in the
XREF listing for the statement.

Issue Number: OE00165068
     Crash on REPOSITION of joined query with Dsrv and OE tables

If you REPOSITION  a query with joined tables, where one or more tables
are from a DataServer schema and others are from a OE (or temp-tables)
database, the Client may crash.

================================================
LANG 4gl
================================================
Issue Number: OE00165718
     Debugger throws off error handling

If the debugger steps into or stops in code that is running in response to
a thrown error, sometimes the thrown error object is deleted by the
debugger and so appears to the system to have been handled. This only
happens when an error has been thrown and the debugger then needs to
evaluate an expression (for example, to display the value of a property).

================================================
LANG 4GL
================================================
Issue Number: OE00167843
     Client can crash when calling GET-SIGNATURE()

The ABL client can crash when evaluating an expression involving the
<proc-handle>:GET-SIGNATURE method. This can happen in situations where
the client is swapping out r-code segments due to the -mmax being too low
for the appication. 
Increasing the -mmax value can resolve the problem.

Issue Number: OE00170718
     Error 4212 or 10831 followed by error 17 undoing sub-trans

Client might issue error 4212 (for DataServer) or 10831 followed by error
17 when undoing a sub-transaction with a record update.

Issue Number: OE00170884
     Unable to export dynamically blob/clob fields

When trying to export dynamically clob and blob fields the EXPORT
statement modifier doesn't allow BUFFER-VALUE clobs/blobs.

Issue Number: OE00173471
     Change in FILE-INFO:FILE-SIZE result if directory exists.

The FILE-INFO:FILE-SIZE now returns the unknown value ? instead of the
previous value 0 when the target is an existing file.

Issue Number: OE00173567
     BEFORE-ROWID not set when RAW-TRANSFER is used

When using RAW-TRANSFER to update a temp-table record in a table which has
a BEFORE-TABLE, the BEFORE-ROWID attribute of the buffer is not updated
but rather remains unknown (?).

If BUFFER-COPY is used to do the same then the BEFORE-ROWID attribute is
updated correctly.

Issue Number: OE00174673
     READ-XML reads data twice

The dataset:READ-XML() will create duplicate records when the DataSet's
temp-table has the same name as the DataSet, and the first child element
of the XML Document represents the DataSet node.

Issue Number: OE00174734
     String concatenation on large longchars is slow.

Building up a large LONGCHAR (a mega-byte or more) concatenating multiple
shorter strings ( more than a hundred), major performance drop can be
experienced as compared to performing this operation using a CHARACTER
variable. 

Issue Number: OE00174775
     Error 6028 after session received signal during CAN-FIND

Error 6028 may happen after the session receives a signal while processing
the CAN-FIND function.

Issue Number: OE00174821
     Client might crash when creating db rec after rec'ing a signal

Client session might crash when triying to create a record for a db table
after signal (hangup) 's been caught.

Issue Number: OE00174825
     Client might crash if signal is received during db disconnection

Client processes on Unix might crash when a signal is received during the
process of disconnecting databases during the session shutdown.

Issue Number: OE00175533
     Memory leak in the DISCONNECT of a state-free appserver

The ABL client has a memory leak when disconnecting from a state-free
appserver. Repeatedly connecting and disconnecting from a  state-free
appserver can eventually exhaust a processes memory.

Issue Number: OE00176022
     Error 'Error in file to longchar' when using COPY-LOB

Error 'Error in file to longchar' can occur when using COPY-LOB to load a
large file into a longchar variable

Issue Number: OE00176098
     Substitute does not properly substitute rowids

When a rowid is passed to the Substitute function it corrupts the
base-string.

Issue Number: OE00176259
     Undo of delete in subtransaction leaves corrupt index

Undo of a delete can leave corrupted index entries. This happens if within
the same transaction the record is created and key values are assigned in
a WRITE trigger in one subtransaction, the record is updated in a second
subtransaction and it is then deleted in a third subtransaction.

Issue Number: OE00176297
     memory violation during the load of data when row width >32K

Cllient crashes with System Error: Memory Violation (49) during data load
to Oracle through Oracle DataServer when the row width exceeds 32K limit,
after error 6447 is displayed: ORACLE row may exceed 32k - can't allocate
buffer for table <owner.table name>(328)(6447).

Issue Number: OE00177052
     Progress Data Dictionary appears to hang loading a .df file

When trying to load a .df file using the Data Dictionary on UNIX, the load
may hang if the database has a large number of extents.

Issue Number: OE00177268
     Changing report column labels at runtime causes memory violation

At runtime, if you change the column-label of a column in a report so that
it will finish beyond the width of the report, the client session can
crash with a memory violation, or fail with other memory-related messages.

For example, assume the following variable and frame definitions:
DEFINE VARIABLE dcredit AS DECIMAL
    FORMAT ">>>>>,>>>,>>9.99"
    COLUMN-LABEL "Credit"
    NO-UNDO.

DEFINE VARIABLE hframe AS HANDLE      NO-UNDO.

DEFINE FRAME fcredit
    dcredit
    WITH DOWN WIDTH 18 NO-BOX.

The width of the frame is 18 characters. If you programmatically change
the column label to be "This is a very long column-label", this can cause
the AVM to crash. 

Typical errors can be errors (48) or (49), or other operating system
errors such as (for Linux) "glibc detected *** /usr/dlc/bin/_progres:
double free or corruption (!prev):0x0000000013f25bb0 ***"

Issue Number: OE00177410
     -mmax incorrectly increasing over time gives error (5409)

The -mmax value (maximum memory for r-code segments) increases gradually
over time, although the same programs are being executed. This leads to
frequent (5409) messages in log files.

Even though the value of -mmax is shown to be increasing this does not
increase the actual allocation.  This is simply a reporting error which is
caused by a bug in the reporting code.	By increasing the initial -mmax
setting  to a reasonably high number this problem may go away completely.

Issue Number: OE00177422
     Unnecessary STRING references in the XREF file

Tthe XREF file may contain unnecessary STRING references toward the end of
the file, which are for the name of the indexes used to resolve queries in
the program compiled.

Issue Number: OE00177520
     Xref info incorrect when statement ends in include file

The xref file may contain incorrect file name and / or line number when a
statement starts in a file and ends in another file (include).

For instance:
IF customer.name = "A" then
    {myinclude.i}

(note that the dot that terminates the IF statement is in the include
file.)

customer.name appears as if it was in "myinclude.i" instead of the actual
file it is in.

Issue Number: OE00177532
     non-empty return-value from AppSvr connect proc returns as error

RETURN <string> sets RETURN-VALUE to the string in the client after the
server CONNECT statement.

Issue Number: OE00177591
     Errors 778 and 735 when running query.

Errors 778 and 735 when running query. The user is disconnected from the
9.1D database when running a query from 10.1C 02 client.  These errors
occur when a 10.1c client uses a where clause on an indexed field and the
expression produces a value for the index that exceeds the maximum key
size for 9.1d.	The 10.1c client was not enforcing the proper maximum key
size for a 9.1d database when forming a record-phrase to be sent the
server.

Issue Number: OE00177626
     Wrong value is returned when DECIMALS attribute is used

If a Temp-Table DECIMAL field is defined with DECIMALS 0, the DECIMALS
attribute will return 30 instead of 0.

Issue Number: OE00177863
     AVM crashes when assigning a BLOB or CLOB field with no record

When a temp-table is not available and an assignment is made to a BLOB or
CLOB field within a User-defined function or internal procedure, the AVM
will crash (gpf on windows and memory violation on unix).

Issue Number: OE00178327
     Error 51 when call:IN-HANDLE set using IF function

Setting the IN-HANDLE attribute of the CALL object triggers error "SYSTEM
ERROR: sizditm -- invalid type. (51)" crashes the session under these
specific circumstances:

- The IF function is used to determine the appropriate value
- The THEN branch references THIS-PROCEDURE
- The ELSE branch is a DYNAMIC-FUNCTION call.
- The IF expression resolves to TRUE, so the final value resolves to
THIS-PROCEDURE.

Issue Number: OE00178541
     COMPILE XREF/XREF-XML may hang client compiling inherited class

Progress session may hang when compiling a class file with XREF or
XREF-XML if the constructor does not have a explicit SUPER call for its
super class, and the constructor is placed somewhere after a method that
invokes other methods.

Issue Number: OE00179160
     Buffer-field method causes memory leak

There is a gradual performance degradation which occurs when accessing
buffer fields using the BUFFER-FIELD method within an internal procedure
that is called from a database trigger which passes the handle to the
buffer as a handle parameter.

Issue Number: OE00179248
     Get current no-lock sometimes refreshes temp-table records.

Because Get Current NO-LOCK for a temp-table may refresh the record, it
may lose any unwritten changes from before the get current.

Issue Number: OE00179471
     Small memory leak using REPLACE option in READ-XML

Small memory leak using REPLACE option in READ-XML but not APPEND, EMPTY
or MERGE options

Issue Number: OE00179826
     Static buffer on BIND temp-table can crash

If attaching a local static buffer for a BIND temp-table to a dynamic
query in an internal procedure, the AVM can crash at exit if the query is
not deleted.
To work around this, make sure the dynamic query is deleted once it is no
longer in use. Not deleting dynamic objects such as queries creates a
memory leak in the application, so deleting the dynamic query is a
recommmended practice.

Issue Number: OE00180112
     Application crashes with error 51 when MEMPTR() is used

Application crashes with SYSTEM-ERROR sizdtm - invalid type(51) when
MEMPTR() is used.

Issue Number: OE00180216
     Rfutil can hang database when doing an online schema load

Running rfutil while the data dictionary is in a wait status to load .df
online will hang both the rfutil and the data dictionary.

Issue Number: OE00180844
     GET-SIGNATURE() returns -32767 for variable array extents

Reference help for GET-SIGNATURE() mentions that when you use a variable
of variable extent, GET-SIGNATURE will only mention the extent keyword.
However, EXTENT -32767, is returned.

Issue Number: OE00180972
     RETURN ERROR from AppServer = No .NET Exception

Doing a RETURN ERROR from a 4GL program on the AppServer back to a .NET
Open Client will no longer raise Runtime4GLErrorException.

Issue Number: OE00181121
     EXP Function on HPUX IA64 can hang session

Invoking EXP(0,-1) on an HPUX IA64 (Itanium) machine will cause the
session to hang

Issue Number: OE00181523
     FILE-INFO:FULL-PATHNAME, PATHNAME sometimes incorrect

FILE-INFO:FULL-PATHNAME and FILE-INFO:PATHNAME incorrectly return the root
directory rather than the correct path under the following conditions:
    1. The file has a two-character name.
    2. PROPATH must be searched to find the file.
    3. PROPATH contains the directory that contains the file.
    4. The PROPATH entry is not relative to the OpenEdge working
directory.
This problem was introduced in 10.1C02 and 10.2A.

Issue Number: OE00181532
     BREAK BY error message is misleading

When you use BREAk BY with an OPEN QUERY statement, there is an error
message returned stating "Cannot LAST or PREV Query <name> when
FORWARD-ONLY or -noautoreslist enabled. (12393)".

Issue Number: OE00181799
     Errors with RAW-TRANSFER using Runtime Permission checking

If a database uses Runtime Permissions checking, RAW-TRANSFER can fail
with erroneous messages relating to permissions.

Issue Number: OE00182677
     Session crashes when adding then dropping table

Session crashes when adding and dropping tables in two seperate
transactions when the program or any of its callers have references to the
database.

Issue Number: OE00182839
     Exception not caught after CAN-FIND in same block

When there is a CAN-FIND in the same block as a statement that throws an
error, the error is not  caught by a CATCH in that block.

Issue Number: OE00182859
     GET-STRING() function returns unexpected error

When a piece of source code is run, there is a runtime error at the
GET-STRING() function that states "Wrong number of parameters for
function.  3 supplied,	2 expected. (573)
**  Could not understand line 10. (196)". The syntax, however, conforms to
the documented requirements

Issue Number: OE00183454
     RAW-TRANSFER with incompatible codepages corrupts data

Using RAW-TRANSFER from a raw field to a buffer can corrupt data if the
codepage of the source data has no conversion to the codepage of the
target database or -cpinternal. It will not be possible to delete or
modify the resulting record if the table has an index on any character
fields.
If the source data is UTF-8, and the -cpinternal and/or target codepage
are not UTF-8, the record can also be corrupted if the source contains
characters that are not present in the target/-cpinternal codepage.

Issue Number: OE00183567
     ACCESS VIOLATION while compiling ABL code using 10.2A

A program that compiled in 10.1C can crash during compilation in 10.2A
with a memory violation error (49). This can happen if the program being
compiled defines a top-level buffer for a temp-table after the temp-table
has been used in internal procedures.
e.g.
DEFINE TEMP-TABLE tt ...

PROCEDURE proc1:
    DEFINE OUTPUT PARAM TABLE FOR tt.
    ....
END.

DEFINE BUFFER btt FOR tt.

Moving the buffer definition before the internal procedure avoids the
error.

Issue Number: OE00183607
     Division fails w EXTENTof indeterminate array variable/parameter

Division fails when the EXTENTfunction is passed an indeterminate array
variable / parameter as its INPUT parameter.

Issue Number: OE00183734
     FIND CURRENT inside trigger may cause error 3168

FIND CURRENT inside a trigger may cause error 3168 (Attempt to CREATE a
<table> record in <procedure> while a trigger is executing) when creating
a record after the trigger returns.

Issue Number: OE00183894
     Using '-by-reference' with dynamic call object = 3230 error

Using the documented optional '-by-reference' option when passing a
table-handle in a dynamic call object will cause error 3230.

Issue Number: OE00184396
     Structured Error Handling does not catch errors in RETURN

If a RETURN statement causes a Progress.Lang.SysError to be thrown
(because of a Progress system error message), it was not always being
handled by the Structured Error Handling code. Now it is.

Issue Number: OE00185313
     RUN <System-Handle> Will Generate Weird 293 Error

Having a RUN statement which uses a 4GL keyword as the name of the program
to run will compile successfully but when executed will give error 293 and
the name of the program in double quotes will be a number.  For example,
RUN AUDIT-CONTROL or RUN SESSION or RUN THIS-PROCEDURE will all show the
problem.

Issue Number: OE00185925
     client.mon shows totals in negatives when large

When the numbers in the totals columns, in output from using -yc, grows
very large the numbers are shown inacurately.  They are shown as negative
numbers because the size of the integer used to store them is
insufficient.

Issue Number: OE00187017
     Client may crash when deleting query object after dataset:clear

The ABL client (prowin32.exe) may crash when deleting a query after the
application has executed the CLEAR method on a dataset that had its
top-nav-query attribute queried or that was part of a
Progress.Data.BindingSource object.

Issue Number: OE00188356
     Statement with more than 96 IF functions gets error 223

When a statement has more than 96 IF function it generates the error **
Incompatible data types in expression or assignment. (223)

Issue Number: OE00188450
     Longchar concatenation fails with error if memory is exhausted

Running the attached LongCharIssueMain.p file will grab data from a large
(446 MB) XML file and pass the field data to a temp-table.

After the procedure runs for some time (between 15 minutes and 2 hours),
the error 11677 is returned.

Issue Number: OE00189027
     Client session crashes when modifying corrupted schema

Client might crash trying to add a field to a table that has a specific
type of schema corruption (Field map field).

Issue Number: OE00189873
     Procs with new error handling crashes if in mem mapped library

Procedures using the new error handling catch & catch end statements crash
if they are being run from within a memory mapped procedure library.

Issue Number: OE00190562
     Session crashes when compiling tick event of PSTimer control

Crash occurs when the tick event of a PSTimer Control fires during a
compile.

Issue Number: OE00190838
     LOAD-RESULT-INTO statement does not accept indeterminate array

LOAD-RESULT-INTO raises the following error if the array variable passed
as input was initially defined as indeterminate:

Only -32767 handles supplied but there are at least 0 result-sets (12209)

Issue Number: OE00190994
     Warning Messages Not Suppressed in Structured Error Handling

Warning messages which are generated inside a block of ABL code that is
using the Structured Error handling (CATCH or NO-ERROR on the statement)
used to be suppressed and displayed at somewhat unpredictable times. Now
they are immediately displayed.

Issue Number: OE00191568
     AVM crashes with large field POSITION

If the POSITION of a field in a table is larger than the number of fields
in the table, the AVM can crash in the following circumstances:
- if -checkwidth 1 or -checkwidth 2 is specified
- if runtime permission checking is enabled in the database

The following .df extract shows a table which will have the problem.
ADD TABLE "t1"
  AREA "Schema Area"
  DUMP-NAME "t1"

ADD FIELD "f1" OF "t1" AS integer 
  FORMAT "->,>>>,>>9"
  INITIAL "0"
  POSITION 2
  MAX-WIDTH 4
  ORDER 10

ADD FIELD "f2" OF "t1" AS character 
  FORMAT "x(8)"
  INITIAL ""
  POSITION 300
  MAX-WIDTH 16
  ORDER 20

There are only 2 fields in the table, but the f2 field has a POSITION of
300.

Issue Number: OE00191907
     Client may crash when running with -q

If you use the -q startup parameter and run a given external procedure
with and without the extension in the same session (i.e. run test.p and
run test), it can cause the client to crash.

Issue Number: OE00192261
     Improve compiler performance when using temp-table HANDLE fields

Starting with 10.1C a performance bottleneck can be seen when compiling
code that refers to an attribute of a handle stored in a temp-table
(<table>.<handle field>:<attribute>) where handle can be an ABL HANDLE
type or a COM-HANDLE.

Issue Number: OE00192593
     Cannot bind shared source table using BY-REFERENCE

When binding a BY-REFERENCE parameter temp-table when the source table is
NEW SHARED the following error is returned:

<program-name> Cannot bind BY-REFERENCE parameter tables or datasets
unless column datatypes, positions, extents and indexes match for tables
<name> and <name>. (12766) 

This worked in 10.1B and no longer works in 10.1C or later.

================================================
LANG AUDITING
================================================
Issue Number: OE00183531
     CLIENT-PRINCIPAL:GET-PROPERTY crashes with too much property dat

Calling CLIENT-PRINCIPAL:GET-PROPERTY() method will crash if the
client-principal is sealed, and has a large amount of property data (many
properties, large property values or a combination of both).

In a few rare cases, no crash occurs; Instead the properties return a
blank value.

================================================
LANG COMPSRV
================================================
Issue Number: OE00176208
     Duplicate MEMPTR deallocation occurring in state-reset AppServer

If an internal procedure recursively calls itself, MEMPTRs defined within
the internal procedure are incorrectly being put onto the list of MEMPTRs
to be freed when the AppServer resets itself.

Issue Number: OE00192436
     Returning a LONGCHAR From an Open Client may cause hang

If an Open Client returns a longchar as an INPUT-OUTPUT or OUTPUT
parameter it is possible that the next request would cause a hang
(infinite loop).

================================================
LANG DATASET
================================================
Issue Number: OE00162004
     READ-XML Method not reading correctly from nested XML

READ-XML Method not reading correctly from nested(Parent,Children) XML
nodes when the foreign key is not in the XML, and the primary key value
comes after the nested child in the XML.

Issue Number: OE00166863
     Inconsistent shared record lock during save-row-change

A save-row-changes tries to put a share lock on the record when connected
via TCP/IP to the database. This causes error 12300.

Issue Number: OE00177696
     QUERY-PREPARE on static query may randomly crash

A dynamic QUERY-PREPARE for a DATASET on a static query may randomly crash

Issue Number: OE00178384
     kmkinit -- idx not found. (131) with BIND temp-table

If a procedure defines a BY-REFERENCE temp-table, and within an internal
procedure BINDs it to another temp-table, the AVM can crash if
subsequently accessing this temp-table outside this internal procedure.
This crash typically displays the following error:
    SYSTEM ERROR: kmkinit -- idx not found. (131)
This happens only in 10.2A FCS.

For example:

DEFINE TEMP-TABLE tt NO-UNDO REFERENCE-ONLY ...

PROCEDURE BindTT:
    DEFINE INPUT PARAMETER hproc AS HANDLE NO-UNDO.
    RUN BindTT IN hproc(OUTPUT TABLE tt BIND).
END.

PROCEDURE DoSomething:
    FIND FIRST tt EXCLUSIVE-LOCK.
    ...
END.

Issue Number: OE00178787
     Session crash assigning a buffer's data-source query attribute

Session crashes during buffer:detach-data-source when a buffer's
data-source query is set to a local query, then set back to the default
query created by OpenEdge.

Issue Number: OE00178788
     APPLY-CALLBACK for BEFORE-FILL fails to execute more than once.

APPLY-CALLBACK for BEFORE-FILL fails to execute more than once.  On second
iteration the following error is generated:

FILL requires an attached data-source for buffer ttMyOrder, or an active
before-fill callback procedure. (11874)

Issue Number: OE00180838
     NO-ERROR does not suppress errors from SAVE-ROW-CHANGES

Using NO-ERROR with SAVE-ROW CHANGES() method does not suppress errors
when the database has triggers.

Issue Number: OE00180934
     READ-XML error when SimpleType derived from another SimpleType

When the type of a potential temp-table field is an xsd:SimpleType, and
that type is derived from another xsd:SimpleType, READ-XML fails with an
error similar to the following:

Unable to map simpleType dtBOOLEAN to Progress data type. (13853)

Issue Number: OE00182778
     prowin32 session crashes after closing .cls window

The OpenEdge session terminate abnormally when closing a .cls window

Issue Number: OE00183285
     Detach-datasource crashes after fill with recursive relation

If a dataset has a recursive relation on one buffer, and a regular
relation from the same buffer to another, the session crashes when tying
to detach the data-source from the buffer with the recursive relation
after a FILL().

Issue Number: OE00183910
     Crash if ProDataSet callback object inherits from .NET

The AVM can crash if the object passed for the ProDataSet event callback
inherits from a .NET class. 

For example:
  SET-CALLBACK("AFTER-ROW-FILL","afterRowFill",hObject) 
If hObject inherits from a .NET class, the AVM can crash processing the
ProDataSet event.

Issue Number: OE00190427
     Memory Violation using READ-XMLSCHEMA method on IA

A Memory Violation occurs when using the READ-XMLSCHEMA method on a
proDataSet  or temp-table on HP-UX Itanium when the session code page is
utf-8.

================================================
LANG DATATYPE
================================================
Issue Number: OE00165736
     PUT CONTROL with dynamic field reference fails

PUT CONTROL is a construct that specifically allows direct output of RAW
variables or table fields.
However, using a buffer-field:BUFFER-VALUE reference fails at runtime with
errors:

Incompatible datatypes found during runtime conversion. (5729)
** Unable to evaluate expression for PUT statement. (564)

even if the buffer-field handle points to a  buffer-field of type RAW -
meaning the BUFFER-VALUE will be of the RAW datatype.

Issue Number: OE00175729
     Get 11677 when assigning a substring of a longchar to put-string

Get error 11677 when assigning a substring of a longchar to put-string.

Issue Number: OE00179049
     Memory leak using ENTRY function with LONGCHAR in function call

A memory leak occurs when using the ENTRY function on a LONGCHAR variable
in-line in a function call.

This results in the following error:

Error converting LONGCHAR variable. (11674)

Issue Number: OE00179556
     COPY-LOB from a db CLOB to a LONGCHAR resulting LONGCHAR truncat

COPY-LOB from a database CLOB in one codepage to a LONGCHAR variable in a
different codepage may not result in a longchar containing the entire
clob.  One way this can happen is with the convchar utility and you do:
proutil <db> -C convchar convert undefined.
proutil <db> -C convchar convert utf-8.
You'll end up with a dbcodepage clob column in iso8859-1 and a database
codepage of utf-8 and then copy-lobs will retrieve only half of your clob.

Issue Number: OE00179930
     r-index searches above 32k on longchars display wrong result

If you try to r-index a LONGCHAR, the results obtained are wrong when
searching above 32K. 

Issue Number: OE00181541
     NEW GLOBAL SHARED LONGCHAR has initial value of TXS

When a NEW GLOBAL SHARED LONGCHAR variable is defined it seems to inherit
the initial value TXS.

Issue Number: OE00181699
     set-size() = 0 in a Method fails with successive calls

The memptr retains the size from the previous method call and set-size() =
0 fails.

Issue Number: OE00182095
     Entry function returns errors when updating longchar variable

If the entry function is used to update a longchar variable, error 11669
or 560 are returned

Issue Number: OE00183571
     Error referencing array with indexer outside of its class file

Referencing an array property that is a type with an indexer from outside
of the class hierarchy results in either an error (11389) or a session
crash.

Issue Number: OE00186538
     Automatic parameter conversion differs for char and longchar

When automatic conversion of a non character data type to a character data
type is done, when the receiving parameter was a longchar, the conversion
produces an incorrect result.

Issue Number: OE00188565
     Getting error message 223 when using date subtraction operator

Getting error message 223 when using date subtraction operator with buffer
fields.

Issue Number: OE00190112
     TODAY & NOW functions fail to INITIAL NEW GLOBAL SHARED VARIABLE

TODAY & NOW functions fail to INITIALize NEW GLOBAL SHARED VARIABLEs when
used in DEFINE NEW GLOBAL SHARED VARIABLE statement with the  INITIAL
option.

Issue Number: OE00190199
     INPUT-OUTPUT THROUGH with LONGCHAR causes session to crash

Session crashes when using INPUT-OUTPUT THROUGH and LONGCHAR.

Issue Number: OE00190413
     System Error (49) caused by TRIM function on LONGCHAR variable

Session crashes when using the TRIM function on a LONGCHAR variable with
an empty string value

Issue Number: OE00190991
     DATETIME subtraction incorrect if result time part is 0ms

When subtracting from a DATETIME, if the time part of the resulting value
is midnight (0ms), then the date will be one day too early. 
e.g.
DEFINE VARIABLE dt AS DATETIME NO-UNDO INITIAL 9/1/2009.

/* 86400000 ms in a day */
MESSAGE dt - 86400000 VIEW-AS ALERT-BOX. 

will display the date as 08/30, not 08/31.

================================================
LANG DLL
================================================
Issue Number: OE00086877
     Client can't load libraries on AIX stored as archives

Errors 8013 and 8014 when trying lo load a library stored in an archive on
AIX, such as libc_r.a.

================================================
LANG I18N
================================================
Issue Number: OE00124868
     Unable to convert to codepage IBM278 in OpenEdge 10.x

Conversions to codepage IBM278 fails with error 6063 in OpenEdge 10:
Code page conversion table for <codepage> to IBM278 was not found in
convmap.cp. (6063)

Issue Number: OE00131849
     Misleading error for LONGCHAR codepage conversion

Progress generates "Could not obtain LONGCHAR (11316)" error when loading
a file into a LONGCHAR variable if one or more characters cannot be
converted to the appropriate codepage. A more specific error should be
generated.

Issue Number: OE00149791
     FILE-INFO size and  timestamps return ? with non-ASCII filenames

If using FILE-INFO to get information about a file where the filename
contains non-ASCII characters, the FILE-INFO:FILE-SIZE,
FILE-INFO:FILE-*-DATE and FILE-INFO:FILE-*-TIME attributes will return
UNKNOWN (?).

Issue Number: OE00175811
     Cursor skips characters in UTF-8/double-byte fillin

If using -cpinternal UTF-8 or another double-byte codepage with the
Windows GUI client, the cursor can skip over a character when entering a
multi-byte character in a CHARACTER fillin. This puts the cursor at the
incorrect edit position. For example: if the fillin contained "ABCDE", and
you insert a multi-byte character (U-umlaut) between B and C, the new
character will appear, but the cursor will appear between C and D, instead
of after the new character.

Issue Number: OE00176662
     Logical field with non-ASCII format displays wrong value

When using -cpinternal UTF-8, if a logical fields has a non YES/NO format,
and that format contains any non-ASCII characters, then a toggle box
defined on this field will not display the correct value.  At display time
this also results in the 4059 error:

**Attribute SCREEN-VALUE for the TOGGLE-BOX has an invalid value of TRUE.
(4059)

Issue Number: OE00177119
     Corrupted strings using UTF-8 r-code with non-UTF-8 client

It is possible that some string values in the text segment can be
corrupted when executing r-code compiled for UTF-8 with an ABL client not
using -cpinternal UTF-8. 
The corruption might manifest itself as strings with the beginning
characters truncated. This corruption can cause error (1494), with a
truncated filename e.g.:
  prog.p --Could not find file ustomer in database sports2000. (1494)

Issue Number: OE00178726
     READKEY after IMPORT breaks multi-byte UTF-8 characters

If a session is running with UTF-8 codepage, an IMPORT followed by a
READKEY/LASTKEY  may cause the LASTKEY to return incorrect values. This
happens when the READKEY reads a multi-byte character. 

Valid UTF-8 byte sequences may be seen as invalid, which results in
LASTKEY returning -1 and the character being droppped.

In some cases, invalid multi-byte characters will be read, in which case
the LASTKEY returns a value between 128 and 255 where it should return -1.

Issue Number: OE00179233
     SET/UPDATE with "-" can fail with -cpinternal UTF-8

If using the SET or UPDATE statements to read input from a file, and the
input field contains the "skip" character ("-"), the ABL client might fail
to correctly handle the data if using -cpinternal UTF-8. 

If there is a LOGICAL field in the SET or UPDATE frame, the program might
generate the following errors:
** Input value:  should be yes/no. (87)
** <program>: Unable to evaluate field for assignment. (143)

For other datatypes, if the fields in the SET frame are pre-filled (e.g.
with a DISPLAY statement), each field that is skipped with "-" will be
empty.

Issue Number: OE00183540
     Incorrect conversion table from IBM866 to ISO8859-5

The conversion table from IBM866 to ISO8859-5 is not correct. The NUMERO
SIGN and NO-BREAK SPACE characters are mapped to incorrect codepoints in
ISO8859-5. As there is no direct conversion from IBM866 to UTF-8, OpenEdge
uses the IBM866->ISO8859-5 conversion when converting IBM866 to UTF-8.
Consequently, NUMERO SIGN and NO-BREAK SPACE are not handled correctly
when using IBM866 data with UTF-8.

Issue Number: OE00186282
     PROMSGS statement does not change language for all messages

After using the PROMSGS statement to change the current promsgs file, some
messages will still be translated in the language loaded on client
startup.

Issue Number: OE00188600
     Cannot display Euro symbol in OE10 with CP936

The Euro symbol is missing in the codepage conversion from CP936 to UTF-8.
It cannot be displayed in the GUI client if using -cpinternal CP936. 
The workaround is to use -cpinternal UTF-8 instead.

Issue Number: OE00189819
     Idxbuild crash w/ UTF-8 database and ICU collation on HP Itanium

On HP Itanium, and idxbuild on a UTF-8 database with an ICU collation will
crash.

================================================
LANG OO4GL
================================================
Issue Number: OE00160501
     RETURN NO-APPLY in a VOID method does not compile

Using a RETURN NO-APPLY statement in a VOID method raises the following
compile-time error:

    Cannot RETURN a value from a void method. (13454)

Because of this, when you use a method as a callback handler, the event
cannot be aborted, for example, in order to prevent a record from being
fetched during a ProDataSet FILL operation using a BEFORE-ROW-FILL event
handler.

Issue Number: OE00167628
     Constructor with buffer parameter throws compile error

The existence of a constructor with a buffer parameter is causing
confusion in the compiler. When a class has multiple constructors and one
of the constructors contains a buffer parameter, the compiler has trouble
disambiguating between the constructor with the buffer parameter and other
constructors.  The result is usually some compiler error messages that are
difficult to understand.

Issue Number: OE00173970
     Warning  (12625) is generated under certain conditions.

IF the code references a table, ANDa directory in the PROPATH is the same
as the table name, AND the name of a compiled .r procedure in that
directory is the same as the name of a field, AND the code references any
attribute of that field, THEN the warning: "Could not find source class
file . (12625)"  is generated.

Issue Number: OE00175207
     Changing method from private to public in session causes error

For a method  that appears in a hierarchy, changing an option or name at
runtime can cause error 12882 to occur.

Issue Number: OE00177551
     WebClient doesn't support static class members or DYNAMIC-NEW

Code which works under regular Progress will fail when run in WebClient.

Issue Number: OE00178107
     Session crash accessing field from buffer via an Object instance

Progress session crashes when attempting to access a field from a buffer
via an Object instance in a database query.

================================================
LANG oo4gl
================================================
Issue Number: OE00178390
     Session crashes when calling method from super class

Session crashes when compiling subclass that calls method contained in
another class.

================================================
LANG OO4GL
================================================
Issue Number: OE00178631
     Getting error message 12767 when running procedure.

Getting error message 12767 when running procedure.
If an inherited temp-table has multiple indexes, it is possible that the
components of the latter indexes overwrite earlier ones during the
unpacking of a .r, causing a mismatch in the descriptions of the table.

Issue Number: OE00178645
     GPF instantiating child class accessing BEFORE-TABLE from super

Client crashes when instantiating a child class with a method that
attempts to access the before-table of a protected temp-table defined in
the super class.

Issue Number: OE00179623
     Crash when compiling class with inherited temp-table

The AVM can crash when compiling a class if the class uses a temp-table
inherited from a class other than the immediate predecessor. This is a
complex situation that requires the following circumstances:
- C inherits from B inherits from A.
- A defines a protected temp-table tt1.
- B does not reference tt1 in any way.
- C has a reference to tt1.
- A.r and B.r exist, but C.r does not exist.
An attempt to compile a program that uses C will force a compile of C.cls,

and the AVM will crash.
This can happen when performing compilations of large numbers of programs
at a time
e.g. using the Application Compiler. To avoid this at runtime, make sure
all classes are compiled.

Issue Number: OE00180047
     IF...THEN...ELSE function fails to assign ? to a DotNet object

When the IF...THEN...ELSE function is used to assign the unknown value ?
to a DotNet object, the assignment fails with the error:

** Incompatible data types in expression or assignment. (223)

Issue Number: OE00180107
     Compile time memory leak with classes

Compilation of an inherited class shows a memory leak if a super class
references an include file

Issue Number: OE00181344
     Reference Static in Transaction = Temp Memory Increase

Referencing a static property inside of a transaction can cause a
temporary memory increase.

Issue Number: OE00181972
     DYNAMIC-NEW gives error 14291 with PUBLIC and STATIC constructor

DYNAMIC-NEW gives error 14291 when instantiating a class with both a
PUBLIC and STATIC constructor with the same signature.

Issue Number: OE00182323
     Method override calls incorrect method signature

When casting an object down from within a method that takes the higher
class as parameter, and calling a same named method with the derived
object as input, the original method is called recursively.

i.e. 
METHOD foo ( INPUT o AS base ):
  foo(CAST(o,derived)).
END METHOD.

METHOD foo ( INPUT o AS derived ):
 ...
END METHOD.

If the variable used to define the class passed to the method with the
base input is defined as bsae but NEWd as derived, the first method is the
only one ever called... and it is done recursively till it blows the
stack.

Issue Number: OE00182982
     Crash calling static method if class inherits from non-static

The session may crash if you try to run a static method that is defined in
a class that inherits from another class which has no static methods,
after the session runs	out of -D entries.

Issue Number: OE00183044
     Compiling a class file with SAVE XREF hangs compilation

Compiling a class file with SAVE XREF hangs the compilation:
-- It is a NEW statement in a constructor that causes this to happen when
an XREF file is being generated.
-- The compilation keeps running, without stopping until the prowin32.exe
process is killed in Task Manager
-- The output XREF file keeps growing until the prowin32.exe process is
killed
-- About 50% of the CPU's resources are used during this period
-- The problem did not occur in 10.2A FCS.

Issue Number: OE00183993
     Client may crash after deleting OO object

Client may crash after deleting OO object.

Issue Number: OE00184394
     Valid-object function doesn't consider dynamic-cast input valid

Output of dynamic-cast function is not considered valid input for the
valid-object function. 

Issue Number: OE00185417
     Session crashes using REFERENCE-ONLY TEMP-TABLE in a class.

Defining a BUFFER for a derived REFERENCE-ONLY TEMP-TABLE in a class can
result in a run-time error which crashes the session.

Issue Number: OE00187926
     Compilation crashes when trying to choose overloaded constructor

When the compiler tries to choose the right constructor to run (based on
the parameters used), if the unqualified name of the class matches a
built-in class, then the compiler may incorrectly choose the built-in
class constructor and crash when it tries to generate code for it.

Issue Number: OE00188267
     Compiling class with XREF crashes

A crash occurs when compiling a class (with the XREF option) that has a
call within the class to a method with a BUFFER parameter.

Issue Number: OE00188942
     Crash in 10.2A02 when deleting OO Object

In 10.2A02, when deleting a persistent procedure that contains an OO
object and temp-table/database references, the AVM can crash.

Issue Number: OE00189328
     Crash when accessing static method using -yd

When attempting to access a static method in a pre-compiled class, when
the -mmax soft limit is reached; if the session was started using the -yd
startup parameter a crash may occur.

Issue Number: OE00191129
     Garbage Collection May Cause C stack overflow

If lots of deleted objects (thousands) are garbage collected all at once,
it may cause enough recursion to overflow the C Runtime stack.

Issue Number: OE00191134
     Error 14347 is raised when creating too many objects

When a procedure creates many OO objects of the same type, the following
error is raised "Usecount of the segment is <= 0 (14347)".

Issue Number: OE00192156
     Syntax errors when accessing Static method from mem mapped pl

When accessing a static method in a OOABL class from a memory mapped
procedure library there may be either a syntax error or a file not found
error returned:

** "filename" was not found. (293)

or...

**  Could not understand line <lineno>. (196)

This same behavior is not reproducible when using a standard (non-memory
mapped) library.

Issue Number: OE00192544
     Unable to use qualified property reference as index for an array

When using a property as index for an array, getting error message:
"Cannot update <property name> because it is a property that is read-only.
(13824)"
This happens only if the property name is qualified with an object
reference or type name.

================================================
LANG Other
================================================
Issue Number: OE00174992
     Creation of temp-tables is slower in OE10

Creation of temp-tables is slower in OE10 compared to V9.1. 

Issue Number: OE00181377
     Non-English PROMSGS may be truncated

If using a non-English PROMSGS file, long messages might be truncated if
the AVM's -cpinternal does not match the codepage of the PROMSGS file. 
The first occurrence of the message is displayed correctly, but all
subsequent occurrences will appear truncated.

Issue Number: OE00185124
     Table name changing on some calls to OPENCLIENT_TT

Under a very specific situation when passing a static temp-table to a
remote procedure on a OE10 AppServer, the table name on the server side is
received as OPENCLIENT_TT.

Issue Number: OE00185905
     Increase directory size limit (-D)

The -D (directory size) limitation is arbitrary and too small.	When the
limit is reached this causes r-code not in use to be removed from memory,
which must be subsequently reloaded when needed again.

================================================
LANG Procedure Library
================================================
Issue Number: OE00177174
     RCODE-INFO:TABLE-LIST garbled if rcode is in memory-mapped .pl

RCODE-INFO:TABLE-LIST attribute can return garbled data if the .r file
referenced is located in a memory-mapped procedure library.
It shows seemingly random table names, in some cases no table name at all
(just a logical db name).


In some cases the r-code will also fail to run with error "<program>
--Could not find file <name> in database <db>. (1494) "

where <name> is one of the incorrect names instead of the actual one

Issue Number: OE00179082
     Loading large memory mapped pl files crash session

When trying to load very large memory mapped .pl files into memory the
following errors occur followed by a crash and no protrace is ever
generated.

Unable to memory map procedure library <libname>.  System call:
MapViewOfFile. Error number: 8. (9245)

Can't open library <libname>. (1930)

================================================
LANG Security
================================================
Issue Number: OE00186732
     SET-CLIENT( ) method unexpectedly overrides db connection id

The SECURITY-POLICY:SET-CLIENT( ) method overrides the DB connection IDs
that have been previously established using the command line -U & -P
parameters, the CONNECT statement -U & -P parameters, or the SET-DB-CLIENT
function.  This is contrary to the documented decription of the behavior
of this method.

Specifically, the "OpenEdge Development: Programming Interfaces" manual
suggests on page 3-4 that the SECURITY-POLICY:SET-CLIENT( ) method can NOT
override a DB connection ID that has been previously established using the
command line -U & -P parameters, the CONNECT statement -U & -P parameters,
or the SET-DB-CLIENT function.

================================================
LANG Web Services Client
================================================
Issue Number: OE00119592
     Client or analyzer crashes when a WSDL contains mime:content tag

When running the Web services client or WSDL Analyzer against a WSDL that
contains the <mime:content> tag, the program crashes. 

This element appears in HTTP bindings for the web service, such as the
HTTP-GET and HTTP-POST bindings. This only happens on the HPUX11 platforms
and only with HTTP bindings. OpenEdge does not support these bindings.

Issue Number: OE00149139
     Calling webservice using parameters fails with error 11797

Under certain circumstances, calling a webservice with a RUN statement
that uses parameters for input and output parameters fails with error
11797.

Issue Number: OE00169465
     WebService client sometimes does not time-out during Async call

Web Service client sometimes does not time-out when performing an
Asynchronous call after the defined time-out period has expired.  The
client waits for the response when the request should be canceled.

Issue Number: OE00171854
     Performance degradation after multiple connections to a WSDL

When a WSDL is connected a create connection is created and never deleted.
 When more are connected/created, the client has to search through the
ever growing list of connections until it finds the one it's looking for. 
This causes a sever performance drain after many WSV calls in a given
session.

Issue Number: OE00174178
     Incorrect SOAP Request sent with complex input parameter

When calling a web service operation with two parameters, one input
LONGCHAR and one output LONGCHAR, an incorrect SOAP request may be sent.

This occurs when the SOAP messages use the wrapped document/literal
convention and the input parameter is a complex value. When the input
parameter is a complex value, it must be sent as a text value containing
XML.

The SOAP message may look something like the following. Note the second,
nested, occurance of the parameter element.

<soap:Body>
    <request>
	<parameter>
	    <parameter>testing</parameter>
	</parameter>
    </request>
</soap:Body>


The message should look something like the following instead.

<soap:Body>
    <request>
	<parameter>testing</parameter>
    </request>
</soap:Body>

Issue Number: OE00178005
     -SOAPEndpoint CONNECT value truncated if > 128 chars

The -SOAPEndpoint parameter of the Web Service CONNECT statement is
truncated if the parameter is longer than 128 characters.

Issue Number: OE00178777
     Web Service client support for schema extension attributes

The OpenEdge Web Service client and the WSDL Analyzer do not interpret
extension attributes correctly in the XML Schema of a WSDL document.

Issue Number: OE00178937
     Parameter is mapped to LONGCHAR instead of ProDataSet

The WSDL Analyzer maps a ProDataSet parameter to LONGCHAR if the name of
the underlying ProDataSet, temp-table, or temp-table field is a reserved
keyword.

Issue Number: OE00180710
     Memory leak with WSO CONNECT

Client leaks memory when connecting/disconnecting to Web Services

Issue Number: OE00181528
     LONGCHAR parameters cause memory leak with Web Services client

The OpenEdge Web Service client has a memory leak when repeatedly calling
a Web Service with LONGCHAR parameters.

Issue Number: OE00189005
     OUTPUT EXTENT parameters cause OE Web Service client memory leak

The OpenEdge Web Service client has a memory leak when repeatedly calling
a Web Service with OUTPUT EXTENT parameters.

Issue Number: OE00189662
     Web Service client crashes when recreating Port Type

Under certain circumstances, the Web Service client crashes when setting
the handle to the Port Type for the second time after it has been deleted
the first time around.

Issue Number: OE00190989
     Web Services client crashes due to invalid SOAP Request header

If an invalid XML document is passed as an argument to the
SET-SERIALIZED() method of a SOAP-header-entryref object, then the
OpenEdge client will crash.

================================================
LANG XML
================================================
Issue Number: OE00163835
     bproxsdto4gl should give same errors as READ-XML

The bproxsdto4gl utility does not report the same errors as the READ-XML
and READ-XMLSCHEMA methods when using a schema file.

Issue Number: OE00178485
     Error 13036 & 13064 occur on READ-XML with LongChar from ActiveX

Errors 13036 and 13064 occur when attempting to load XML from a longchar
that has been populated by an ActiveX Automation object.

Issue Number: OE00178945
     WRITE-XMLSCHEMA min-xmlschema=true omits important information

When the min-xmlschema argument to WRITE-XMLSCHEMA method for a ProDataSet
or Temp-table is TRUE, and XML-NODE-NAME is defined for a ProDataSet,
Temp-Table, or Temp-Table field, information on the actual names for the
objects is not written to the XML Schema.  This causes errors when reading
the XML Schema back into a ProDataSet or Temp-Table definition.

Issue Number: OE00182285
     Errors (13121) and (13137)  when parsing a nested XML schema

When using the xsdto4GL utility, errors (13121) and (13137) occur. The xsd
includes references to other xsd files. The xsd file generating the errors
is valid according to other XML validators.

Issue Number: OE00182485
     CREATE-NODE-NAMESPACE does not create namespace

Saving a document in which nodes were created using the
CREATE-NODE-NAMESPACE( ) does not include proper namespace declarations
until SET-ATTRIBUTE( ) is use to create the declaration on the node.

Issue Number: OE00183425
     READ-XML fails with BLOB and succeeds with CLOB

UTF-8 data extracted from a  table into a temp-table and written back as
XML from a LONGCHAR into a BLOB field can not be properly retrieved. 
COPY-LOB from the LONGCHAR to the BLOB field truncates the XML, then the
READ-XML fails to read the same data back into a temp-table after
extracting it from the database table to a LONGCHAR or a FILE.

Issue Number: OE00185231
     Client crash in SAX-WRITER:RESET()

If you have a SAX-WRITER object that has a longchar as the output
destination, and you reset the longchar, the client may crash when you
call the RESET() method. Or the longchar may get messed up (such as having
the wrong length).

Issue Number: OE00188044
     READ-XML( ) fails to load TEMP-TABLE data from some  XML files

READ-XML fails to load nested data when temp-table rows have no fields. 
These rows are considered fields in the outer parent row, and not empty
rows of the nested child.  Sometimes, when a carriage return is inserted
into a specific place in the XML file, nested child rows are loaded
correctly.  Inserting the magic CR in the right spot of the xml file
causes the READ-XML to load the data as expected.

Issue Number: OE00191089
     An Error Inside WRITE-XML Does Not Reset SESSION:DATE-FORMAT

If there is an error inside of the WRITE-XML statement when serializing a
DataSet to XML, it is possible that the WRITE-XML statement will not
return an error and will not reset the SESSION:DATE-FORMAT attribute back
to whatever value it had prior to WRITE-XML being invoked.  The
SESSION:DATE-FORMAT attribute will have a value of "ymd".

================================================
Management CORE
================================================
Issue Number: OE00186109
     db agents will not report the database is down

When database is abnormally terminated, database agents do not alert OE
Management that the database is down.  The alert is now sent when the
database is configured to run with the watch dog process.

Issue Number: OE00189785
     Dbagent poll crashes AdminServer after restart

A dbagent poll appears to crash the AdminServer after the AdminServer has
been restarted after running for several days.

================================================
Management Explorer
================================================
Issue Number: OE00182929
     OpenEdge Explorer: missing AppServer statistics views

The AppServer and WebSpeed resources were both missing the summary screen
that was previously available in the Progress Explorer.  This
functionality has been added to both AppServer and WebSpeed home pages
under the "Status" link.

Issue Number: OE00183049
     AdminServer startup delay when binding resource to surrogate

AppServer Brokers cause AdminServer startup delay during "binding resource
to surrogate" phase with OpenEdge Explorer installed.

Issue Number: OE00183484
     OEE: Task Scheduler threads are started

Task Scheduling is only available in the OpenEdge Management product. Task
Scheduler threads do not need to be started in OpenEdge Explorer. 

Issue Number: OE00183488
     OEE:  Database resources status not shown in treeview

When sorting by resource type, the status for database resources is not
shown in the OpenEdge Explorer tree overview.

Issue Number: OE00183529
     Log File Monitor option has wrong image

The Log File Monitor option in Openedge Explorer shows the image for when
the option is enabled, the image should be grayed out since the option is
disabled.

Issue Number: OE00187703
     Display issues with IE 8 and OpenEdge Explorer

Add resources link from menu bar inside the OE Explorer console brings up
a directory listing for /resutil/ rather than the New submenu.

================================================
Management Management
================================================
Issue Number: OE00174110
     OEM: Page Writers > "BI Summary" > "Cluster size" is incorrect

Field Page Writers > "BI Summary" > "Cluster size" is reported
incorrectly.
Field DB Start Parameters > "BI cluster size (-bi)" is correct.

Issue Number: OE00176285
     Fathom configuration database hits limit for number of objects

The fathom.odb PSE Pro database prevents OE Management from starting if it
has reached the maximum number of objects in the databsae.

Message (excp): PSE Pro can store a maximum of 16777212 objects.
Committing this transaction will exceed that limit.

The fathom.od* files total  more than one GB in size.

Issue Number: OE00180526
     Scripted database doesn't send abnormal shutdown alert

When a scripted database has an abnormal shutdown, no alert is sent from
Management.

Issue Number: OE00182072
     fathom.odb database is growing over time

Storage of file monitor and log file monitor information causes the
fathom.odb database to grow and eventually reach it's hard limit.

Issue Number: OE00184733
     OpenEdge Management users Lock Status Details is alway empty.

The OpenEdge management Users Activity screen report for Lock status
details for a user is alway empty.

Issue Number: OE00184936
     waitio isn't reported correctly on linux

The waitio cpu statistic is not available on some Linux operating systems
i.e. 2.4.9 but is available on the newer Linux operating systems like
2.6.9.	When the  waito is available, it wasn't being reported correctly
in the CPU detail graph in Management.

Issue Number: OE00185097
     Unable to get more than 20 jobs running simultaneously on OE Mgt

By default, OpenEdge Mgmt allows only 20 jobs to be run concurrently. 
This default can be configured by the user by setting the
'fathomTaskSchedulerThreads' property  in fathom.init.params to the
desired number of jobs.

Issue Number: OE00186263
     fathom -dump does not work offline

Calling fathom -dump offline causes error "Could not load Fathom
configuration database".

Issue Number: OE00186922
     Unable to set "Always throw new alert" to true if set to false

OpenEdge Management is not saving  change made to the "Always throw new
alert" when changed from false to true.

Issue Number: OE00187336
     Migrating 3.1C OEM config to 10.2A fails due to missing classes

OEM 3.1C configuration migration to 10.2A will fail with regards to log
file monitors due to missing class files.

Issue Number: OE00187474
     OE Man console shows phantom OE Resources

The 3.2A OE Management console will display phantom OE Resources (adapter,
or, od) if migrating from 10.1C/3.1C to 10.2A/3.2A.  

Issue Number: OE00191468
     Limit number of resources has no values if accessed via menu bar

When accessing the Create Report Template via the menu bar (instead of the
Reports -> Create Report Template Links), the pull down for "Limit how
many resources can be included in the report" has no values to pick from. 
It is blank.

Issue Number: OE00191572
     User created report via report template shows only managed dbs

When creating a new report via the create report template, only managed
databases are available for reporting. Scripted databases are not shown.

Issue Number: OE00191835
     OpenEdge Management won't allow more AppServers than licensed

OpenEdge Management/OpenEdge Explorer won't allow more AppServers than
there are licensed users.  However, you can do the add from the command
line.

Issue Number: OE00191880
     Scripted Database resource page Properties has blank info

Scripted databases manually entered into the smdatabase.properties file,
instead of via the OE Management console, have blank "Properties" in the
Scripted Database resources page.

Issue Number: OE00192229
     Db migration utility fails to activate db resource with .pf file

If there are invalid values in the .pf file used when using the Database
Migration utility, the database will be enabled and then disabled as a
resource.  Error messages do not indicate what is the actual problem.

================================================
Management Sonic
================================================
Issue Number: OE00178119
     fmconfig requires DISPLAY variable to be set

The fmconfig command may generate a "DISPLAY variable must be set"
message/error.	Set the DISPLAY variable to some value and re-run the
command.

================================================
NETUI Data Binding
================================================
Issue Number: OE00177925
     ProBindingSource ASSIGN method fails with CLOB field

When using the ProBindingSource ASSIGN method to assign changes made in
the UI (UltraGrid) and there is a CLOB or BLOB	field in the table and
that lob field has data in it, the ASSIGN method fails (returns FALSE).

Issue Number: OE00178351
     Memory leak using ProBindingSource with grid and BLOB fields

Memory leak occurs when using ProBindingSource bound to the UltraGrid
displaying BLOB fields; Memptrs are allocated by the UI but never
de-allocated.

Issue Number: OE00181436
     UltraComboEditor always has  4 entries when bound to ABL query

The Infragistics UltraComboEditor (supplied with OpenEdge Ultra Controls) 
always has 4 entries when it uses a ProBindingSource which is bound to an
ABL query.
If the table queried has more than 4 records. only the first 4 are shown.
If it has less than 4, the control will have empty entries in it's
drop-down list.

This does not happen when the ProBindingSource uses a ProDataSet as the
datasource instead.

Issue Number: OE00181806
     Date 01/01/0001 in dataset causes InvalidOperationException

Date value 01/01/0001 in dataset causes InvalidOperationException when
using bindingsource 

Issue Number: OE00182590
     Setting BindingSource:NoLOBs causes System.AccessViolation

When setting the new NoLOBs property of the Progress.Lang.DataBinding
object, prior to binding the object to a data source (i.e. a QUERY or
proDataSet object), the following error is returned and a STOP condition
is generated.

e.g. 
THIS-OBJECT:bindingsource1:NoLOBs = TRUE.
THIS-OBJECT:bindingSource1:Handle = QUERY qCust:HANDLE.

System.AccessViolation: Attempted to read or write protected memory.  This
is often an indication that other memory is corrupt.

To workaround this issue simply move the line of code that sets the NoLOBs
property to after the bindingsource is bound to a data source.

e.g. 
THIS-OBJECT:bindingSource1:Handle = QUERY qCust:HANDLE.
THIS-OBJECT:bindingsource1:NoLOBs = TRUE.

Issue Number: OE00183187
     Application with Progress.Data.BindingSource may crash randomly

Application using Progress.Data.BindingSource object may crash randomly
(for instance, when closing the session).

Issue Number: OE00183351
     Bind qry/buf to mult BindingSource--System.AccessViolationExcptn

When a query or buffer is bound to multiple ProBindingSources, invoking
methods on one of the ProBindingSources can result in the following error:


System.AccessViolationException: Attempted to read or write protected
memory.

Note: You never want to bind a query or buffer to more than one
bindingSource.	This is akin to browsing the same query with multiple
Browse widgets and simply should never be done.

Issue Number: OE00185022
     ProBindingSource methods should be protected and not public.

ProBindingSource methods OnCancelCreateRow and OnCreateRow should be
PROTECTED, not PUBLIC.

Issue Number: OE00185471
     Ultragrid LoadOnDemand gives exception IndefOff not implemented

Getting exception Progress.Data.DataSource.IndexOff method not implemented
when the Ultragrid:DisplayLayout:LoadStyle is set to LoadOnDemand.

Issue Number: OE00185511
     BindingSource doesn't work correctly on Assign or EndEdit

On EndEdit it will correctly assign the changed values to the
recordbuffer, but it sometimes it also assigns values from other records
to the fields that are not changed on the user interface.

Issue Number: OE00185729
     System.NullReferenceException in DataGrid with PBS attached

If you try to add a new row to a proBindingSource with no dataset, query
or other data-source attached, this results in untrapped errors.  The
errors that are returned may include a System.IndexOutOfRangeException or
a NullReferenceException error.

Issue Number: OE00187358
     ProBindingSource unable to access child tables with no data

A control that uses the ProBindingSource class with a multi-level dataset
may be able to access only the top-level tables. Attempts to use the
ProBindingSource with lower-level tables with no data rows may result in
the following exception:

System.ArgumentOutOfRangeException: Index was out of range. Must be
non-negative and less than the size of the collection

Issue Number: OE00187789
     Crash when attaching PBS to temp-table with different name

Defining a ProBindingSource object with the schema for a specific
temp-table, then attaching it to a dataset with a temp-table with the same
schema but a different name crashes the prowin32.exe client session.

================================================
NETUI Hybrids
================================================
Issue Number: OE00178100
     SYSTEM ERROR when invoking ABL method WndProc from .NET

If an ABL extended .NET object inherits from Progress.Windows.Form or
System.Windows.Forms.Form and overrides the WndProc method, the Progress
client generates exceptions whenever a Windows event occurs that causes
this overridden method to be called.

Issue Number: OE00178326
     Memory is not released after MDI child window is closed

Memory is not released when MDI child form is closed. The memory allocated
for the MDI child form and objects it instantiates is released only after
the MDI container (MDI parent) is closed.

Issue Number: OE00182169
     VD Fails to load form using derived user controls

If a form has usercontrols that are derived from other controls the Visual
Designer will fail to load the form and complain that the usercontrols
need to be recompiled.

Issue Number: OE00193511
     Design canvas exception if derived form has member of same type

A child form cannot be opened in the Visual Designer if the inherited form
has a data member of the same type as itself.

================================================
NETUI netui language
================================================
Issue Number: OE00177864
     Crash of prowin32 when checking syntax or compiling pointer type

If the code contains a reference to a .NET class that has a method,
property, or public field that uses a pointer type such as void* (e.g.)
this would cause a crash of the procedure editor upon syntax checking or
compiling.

================================================
NETUI NetUI Language
================================================
Issue Number: OE00179554
     Classes containing ComImport filtered out

If a class contains a ComImport property suggesting it is a Interop for a
Com Object it is filtered out.

Issue Number: OE00182447
     WAIT-FOR Progress.Windows.Form.Application:RUN() blocks triggers

The TAB and RETURN events are not functional with enabled browse-cells
when .NET is activated.

Issue Number: OE00182587
     Mouse right-click in embedded window crashes session

Right-clicking in a window embedded in a .NET form may crash the client
session if there is a pop-up menu defined for the window or one of its
descendents.

Issue Number: OE00182789
     .NET Array types not seen as compatible with Array interfaces

Although an array such as System.String[] implements interfaces like
ICollection, it is seen as an incompatible type when calling a constructor
or method that takes the interface.

Issue Number: OE00183002
     Error 143 when launching the Procedure Editor from an ABL Form

Launching the Procedure Editor (_edit.r) from an ABL form generates error
143:
** adecomm/_adeevnt.p: Unable to evaluate field for assignment. (143)

Issue Number: OE00183087
     Unable to read more than 32K from :TEXT property

Getting System.NullReferenceException when reading a :TEXT property and
the length of the text exceeds 32K.

Issue Number: OE00183192
     Error 5897 when proc editor start from an form with Timer

If an ABL form containing a Microsoft Timer object launches the Procedure
Editor, any program run from there that causes the "Press spacebar to
continue" message when it ends will cause error 5897:

Input blocking statement is invalid in event handler: timer1_Tick (5897)

Issue Number: OE00183194
     ABL event behavior may change after handling a .NET event

When mixing ABL windows and .NET forms, the behavior of ABL events in an
ABL window may be different after handling an intervening .NET event.

Issue Number: OE00183907
     ESC key exits application when OE window is embedded in .Net frm

When an OpenEdge window is embedded in a .Net form, typing the ESC key may
cause the application to exit.

Issue Number: OE00185024
     WAIT-FOR Application:RUN() blocks triggers

Some key events (ESC, TAB, RETURN, F1, F2, ...) are not correctly
propagated from OCX controls to ABL if .Net is involved through WAIT-FOR
Application.Run().

Issue Number: OE00185269
     System.__ComObject are not always evaluated correctly

The AVM does not CAST objects of type System.__ComObject correctly.  For
example, attempting to CAST an Outlook.Items collection to interface
Microsoft.Office.Interop.Outlook.Items fails with:

Invalid cast from System.__ComObject to
Microsoft.Office.Interop.Outlook.Items, Microsoft.Office.Interop.Outlook,
Version 11.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c.
(12869)

Issue Number: OE00185732
     WAIT-FOR Application:RUN() blocks triggers

Some key events are not propagated to ABL code if .Net is involved through
WAIT-FOR Application.Run().

Issue Number: OE00186641
     Process Events with NetUI can cause program to end prematurely.

Using PROCESS EVENTS in a .NET event handler can cause the Progress client
to end prematurely.  The process simply ends.  It does not crash,
therfore, there is no protrace file generated.

Issue Number: OE00192300
     Invoking .NET WAIT-FOR Can Cause Error 14067

If you invoke the WAIT-FOR Application:Run() method when no .NET forms
have been instantiated and you are running from r-code you will
incorrectly receive this error:
The WAIT-FOR format (WAIT-FOR x:y()) cannot be used without any
instantiated .NET objects. (14067)

================================================
NETUI Other
================================================
Issue Number: OE00191199
     EventArgs objects not deleted

The EventArgs objects passed to .NET event handlers are not being garbage
collected.

Issue Number: OE00192873
     Some decimal values from .NET are not displayed correctly

When trying to convert decimal value from Microsoft or Infragistics
numeric data entry control to a Progress decimal value, this conversion is
incorrect. 

================================================
NETUI User Interface
================================================
Issue Number: OE00177387
     Code generation errors with inheritted ABL form

When creating a new form in the Visual Designer which inherits from an ABL
form that has Handle or Rowid properties the following error is returned:

Code generation for property '<propertyname>' failed. Error was:
'Property accessor '<propertyname>' on object '<formname>' threw the
following exception: 'Object reference not set to an instance of an
object.'

Issue Number: OE00182090
     Tooltips don't appear when embedding ABL window in .NET form

No help text is displayed when the mouse pointer hovers over widgets in a
window embedded in a .NET form. 

Issue Number: OE00182434
     SYSTEM-DIALOG cancels the modal mode of a dialog form

When a system dialog is displayed (using the SYSTEM-DIALOG statement) from
a .NET form shown as a modal dialog box (using ShowDialog), upon closing
the system dialog the .NET dialog box is no longer modal.

Issue Number: OE00182591
     User Control that Inherits UltraGrid fails to paint properly

Using a User Control that inherits from the UltraGrid control may fail to
paint properly.

Issue Number: OE00182666
     Mouse events don't work in ABL dialog displayed from a .NET form

When an ABL dialog is run from a .NET form containing a ToolStrip object,
mouse events will not work until the dialog frame is clicked.

Issue Number: OE00183328
     GPF may occur on application shutdown if using a BindingSource

If using a BindingSource, when the application shuts down, a GPF can occur
due to interaction of cleaning up the BindingSource and doing garbage
collection of some ABL extended .NET object.

Issue Number: OE00184102
     AVM crash when opening form in VD where parent throws exception

When opening a form in visual designer that inherits from another ABL
class, if, during the NEWing of the parent class, STOP is raised in the
AVM due to a coding error such as attempting to run a procedure that does
not exist, then the Visual Designer will unexpectedly exit the WAIT-FOR
that it maintains, and the AVM will crash.

Issue Number: OE00188194
     It is possible to bypass .NET Dialog using Windows TaskBar

If a .NET Form displays a modal .NET Dialog it is possible to bypass the
.NET Dialog and send keystrokes to the .NET Form by clicking on the .NET
Form icon in the Windows Task Bar.

Issue Number: OE00188381
     System.InvalidCastException when setting wait state

System.InvalidCastException occurs when an application which uses .NET
forms executes the SESSION:SET-WAIT-STATE method. After the error message
is displayed, prowin32.exe continues running and it appears to be hung.
This issue occurs when a form of a class other than Progress.Windows.Form
or System.Windows.Forms.Form is used in the application.

Issue Number: OE00189260
     LEAVE doesn't fire in ABL window when focus given to .NET form

When both .NET forms and ABL windows are part of the same application, the
LEAVE event does not fire in an ABL window when focus is given to a.NET
form. This is not consistent with what the user experiences when focus is
shifted from one ABL window to another.

Issue Number: OE00189788
     Focus issues between UltraTree and ABL window

After launching an ABL window from a .NET form containing an UltraTree
with a MouseOver event defined, clicking on or mousing over the whitespace
on the UltraTree component forces focus back to the ABL Window.

Issue Number: OE00191149
     ABL Window gains focus after closing .NET Dialog

If an ABL window is displayed when closing a dialog that was launched
using the ShowDialog method, focus is returned to the ABL window rather
than the parent of the dialog or the last window which had focus.

================================================
OEIDE Editing
================================================
Issue Number: OE00134914
     OEA doesn't evaluate LIKE option of a temp-table definition

Temp-tables defined LIKE another table are not handled correctly by
Architect. The fields and indexes inherited through the LIKE option do not
appear in the Outline view or in the code completions.

Issue Number: OE00153282
     Template expansion in OEA doesn't observe the lower case

The OpenEdge Architect Editor template expansion doesn't observe the lower
case keyword switch.

Issue Number: OE00158192
     Hover help for error reference in CATCH statement is incomplete.

A CATCH statement must define an object reference for the error object
caught. When using this error reference inside the CATCH block, hover help
for it is incomplete.

Issue Number: OE00159602
     FILE-INFO Becomes FILE-INFORMATION

If the preference 'Expand keywords as you type' is checked, then typing
FILE-INFO will be expanded to FILE-INFORMATION. 

Issue Number: OE00159751
     Architect compiler cannot read UTF-8 characters corrently

If source code is written using the UTF-8 code page and this code is
opened in the OpeEdge Architect, provided -cpstream is set correctly, the
code will compile and run.  However, if check syntax is performed on the
code, the compile will issue the error 133.

Issue Number: OE00175506
     OEA Editor shortcut keys fail unless a Help menu is opened

The OpenEdge Architect Editor shortcut keys fail to work unless the Help
or the drop down context menu has already been opened and closed.

Issue Number: OE00178057
     Syntax coloring incorrect for DOT at end of a statement in OEA

In OE Architect ABL Editor, syntax coloring for DOT character at end of a
statement is not done correctly. When there is no space separating DOT and
the preceding word, the DOT is not colored as a statement terminator, it
is colored as a continuation of the last word. This is an issue with
syntax coloring only.  Parsing and other editor functionality doesn't have
this problem. 

Issue Number: OE00178341
     Outline doesnt work for Include references with quoted strings

The outline view stops being updated if there is an include file reference
which contains a nested quoted string like "substitute('name',var)". Any
modifications in the code will not be reflected in the outline, and if the
file is just being opened from disk, the outline stays blank.

Issue Number: OE00178871
     Keyword Expansion & Content Assist fail w ASC() function.

The content assist fails to list the ASCENDING attribute as an option when
the developer types the string ASC followed by (CTRL + Space Bar).

The Keword expansion does not allow the developer to type the ASC()
function and insistes on expanding it to the ASCENDING attribute when the
developer types the string ASC followed by the space character or the left
bracket character.

Issue Number: OE00179432
     Configured Compare Editor font is not used to compare resources

In OpenEdge Architect, the text font configured for the Compare Editor is
not used when comparing OpenEdge resources.

Issue Number: OE00180182
     OutlineView becomes empty for unformatted code

The outline view becomes empty or will stop updating if a call to the
AVAILABLE function is incomplete or not properly formatted. For example :

if not available .... 
     or something then do:
  
end.

Issue Number: OE00180244
     &ENDIF preprocessor followed by bracket breaks outline view

If an &ENDIF preprocessor is immediately followed by a closing bracket,
this can break the outline view. It will appear empty or stop updating.

Code sample:
    &IF LOOKUP("MC":U, "MC":U) > 0 &THEN
	    /* some code */
     &ENDIF) then

Issue Number: OE00180437
     OutlineView hides func defns due to "Do on error " block

Outline view hides function definitions after clicking 'Expand Include
file contents ...' in outline view. This happens when the code includes a
"Do on error ..." block, for example:

 " do on error	undo Main, leave Main
     on endkey undo Main, leave Main: "

Issue Number: OE00180516
     Outline breaks due to QUERY with preproc. in an IF stmt

QUERY containing the preprocessor word	{&BROWSE-NAME}, which is a part of
an IF statement(as following), blocks off the outline view.
e.g.
 if	query {&BROWSE-NAME}:current-result-row = 1
	   and cCurrentOffset = cRequestedOffset then ...

Issue Number: OE00180525
     Outline not shown with proc that has a calc in IF,THEN,ELSE

One line of code that does a calculation within an IF... THEN... ELSE
statement causes the AST build to fail resulting in no outline view for a
program.

Issue Number: OE00180528
     Outline view breaks when using CURRENT-CHANGED wo parens

Using the CURRENT-CHANGED function without parenthesis breaks parsing and
results in the outline view being empty or incomplete.

Issue Number: OE00180654
     Incomplete outline due to encrypted include file.

Outline view fails to show some of the internal procedures in a procedure
file if that file refers to an encrypted (XCODE) include file.

Issue Number: OE00180724
     Method with dataset-handle param generated wrong from interface

Automatic generation of a method definition from an implemented interface
(either while using the New -> ABL Class wizard or via Source ->
Override/Implement method ...) generates invalid code if the method
definition in the interface has a dataset-handle parameter.

The parameter definition in the generated code is written as "<MODE>
<name> AS DATASET-HANDLE", where it should be "<MODE> DATASET-HANDLE
<name>".

Issue Number: OE00180936
     Apply Keywords casing on save does not work for all keywords

Turning on the preference in OpenEdge Architect 'Apply keyword(s) casing
on save' does not properly apply casing preferences to all ABL keywords.

Issue Number: OE00181270
     Spaces inserted before string attributes with auto-indent

When using the Auto-Indent on paste option, along with the "Enable Tabular
Formatting" option, in "Window >> Preferences >> OpenEdge Architect >>
Editor" and you paste in lines with string attributes, a space is inserted
between the close quote and the colon.

Issue Number: OE00181798
     OE AppBuilder EDIT > INSERT > TRIGGER fails for DIALOG frames

The  'Choose Trigger'  dialog is not open on selecting Edit > Insert >
Trigger from the OpenEdge Architect AppBuilder Perspective to add a
trigger for a DIALOG frame.

Issue Number: OE00183753
     Architect Editor performance drops with designer class

When the source and design editors of the same form, or source editors of
a form and its super class are open in Visual Designer, and architect is
restarted, performance of the editing ABL files will be greatly reduced.

This is manifested as very slow response time when typing or highlighting
code with the mouse.  The response times of of code completion using
ctrl+space will also be greatly degraded.

Issue Number: OE00185352
     Incomplete BUFFER-COPY ASSIGN causes Java OutOfMemoryError

When editing a BUFFER-COPY ... ASSIGN statement in Architect, the
incomplete statement causes the parsing logic to fail, and it consumes all
the available memory and  architect crashes with OutOfMemoryError. 

Issue Number: OE00187070
     Auto completion for class names fails when inside statements

Within a number of statements, context assist/auto completion fails to
propose ABL class names even if there are one or more classes matching the
string the auto completion is activated for.

Issue Number: OE00187379
     Auto-format fails in OEA if table name same as database name

Architect auto-format (Ctrl-I) can improperly format a DEFINE BUFFER
statement if the database name is same as the table name.

Issue Number: OE00191476
     Outline view broken for Procedures with nested includes

Outline view is broken for procedures containing nested includes. On
opening the file outline is shown, but on modifying the file (like adding
a procedure/ renaming a procedure) outline is not updated. 

This happens because on opening the file, includes are not expanded by the
parser. On modifying the file, includes are expanded, and the parser
aborts on detecting nested includes, and the changes are not reflected in
outline.

================================================
OEIDE Migration tool
================================================
Issue Number: OE00190708
     Migration of the assemblies.xml fails for users of SCM tools

Assemblies update process (the automated process that will migrate the
assemblies.xml automatically when starting a workspace the first time
after an upgrade) will fail for users of restrictive SCM tools. 

================================================
OEIDE OE Support
================================================
Issue Number: OE00182674
     _idestartup.p doesn't fire all events

Some IDE events that such as close-file are not published for all of the
OpenEdge supported editors.

Issue Number: OE00185876
     Translation attribute missing in adecomm/oeideservice.i

The adecomm/oeideservice.i include, used to allow access to OpenEdge
Architect from within the project runtime, is missing a translation
attribute. This leaves a hard-coded procedure name as a translateable
string.

Line 36:
DEFINE VARIABLE cProcName		    AS CHARACTER  NO-UNDO INITIAL
"adecomm/oeideservice.p".

should read:
DEFINE VARIABLE cProcName		    AS CHARACTER  NO-UNDO INITIAL
"adecomm/oeideservice.p":U.

Issue Number: OE00186155
     Buffer in persistent procedure loaded at startup goes unavailabl

If the session startup procedure called from OpenEdge Architect loads a
peristent procedure, and this procedure finds a database record in a
global buffer, this record can become unavailable even if there is no code
executed which would cause the buffer to be released.

================================================
OEIDE OEIDE
================================================
Issue Number: OE00178127
     esboe files are not always generated in the correct folder

The esboe invocation files are not generated in the correct Project folder
when the .p file is located within a sub-folder.

Issue Number: OE00179796
     Wrong Smart Indentation in OpenEdge Architect

Smart Indentation in OpenEdge Architect does not work as expected when
using statements that are terminated within one line (e.g. "if ... then").

Issue Number: OE00180381
     Architect hanging on Initialize OpenEdge tooling updating model

If the FilterOperatorDropDownItems property for an UltraGridColumn is set
to "All" in the property sheet for the UltraGridColumn, the code generated
by Visual Designer will cause both the ABL compiler and OpenEdge Architect
to hang when attempting to compile the file.

Issue Number: OE00180939
     OE Arch. Add Function has no CLASS in the list of return types

When adding a new function in code using the 'Add Function' dialog, one
can't select a class or interface as a return type. However this is
supported by the ABL.

Issue Number: OE00181378
     AbstractMethodError exception when starting AVM for the project

A java.lang.AbstractMethodError exception may occur when starting OpenEdge
Architect after installing Service Pack 1.

Issue Number: OE00181629
     Procedure names with "+" character are truncated  in outline.

-- Using the + character in a procedure name will cause everything to the
right of the character to be truncated from the outline view.
-- If everything to the left of the + character is identical another
procedure name, or if the left side of two different procedures is
identical, then the outline view is broken. Only the first occurrence of
that procedure name is displayed in the outline view. Clicking on it will
take you to the first instance of that procedure name.

Issue Number: OE00181715
     OE Architect may freezes with project on network drive

OpenEdge Architect may freezes when editing files on a large project
located on a network drive and r-code is not present.

Issue Number: OE00182054
     "Enable auto indent on paste" option inserts too much white spac

When the "Enable auto indent on paste" option is enabled in the OpenEdge
Architect Editor Preferences, pasting source code inside a DO block will
always paste it  directly underneath the colon of the "DO:". Therefore, if
the colon is found half way down the line, then all pasted source code
will be indented until it starts helf way down the line it was pasted in.
The attached "autoindent.jpg" screenshot illustrates this.

Issue Number: OE00183135
     Eclipse knows nothing about WRX written by the AppBuilder

The WRX file created by the AppBuilder, for a .w file using OCXs, is not
refreshed in Architect and does not show in the Resources view.

Issue Number: OE00184301
     closeEditor API from oeideservice does not close a file

after installing 10.2A Service Pack 1, closeEditor function in
adecomm/oeideservice.i does not close files opened outside the AppBuilder.

Issue Number: OE00186308
     Product Tour link in Architect Welcome page is broken

When the Progress web site was updated, the OpenEdge Product Tour was also
updated and moved to a new URL. Existing releases of OpenEdge Architect
have links to previous locations of the product tour on the Welcome page.

Issue Number: OE00189960
     OpenEdge Architect builds project in reverse alphabetical order

When compiling a project, OpenEdge Architect processes source files in
reverse alphabetical order.

Issue Number: OE00190919
     Inconsistency on source and r-code destination in Architect

When selecting 'package root' and 'rcode directory' in the 'New OpenEdge
Project" dialog, both 'src' and 'bin' directories are created but the
rcode destination and source destination remains the project root folder.
To change from the default project root folder, specify "Project build
destination" and "Static file destination" in Project->Properties ->
OpenEdge -> Build dialog.

Issue Number: OE00191720
     DB alias not created launching a configuration in architect

Error reported saying that the database is not connected because alias not
created launching a configuration in architect.

Issue Number: OE00192401
     Toggle comment function destroys the last selected line of code

OE Architect Toggle comment function destroys the last line of code if it
only contains }
If the } is not in a separate line, the problem does not occur.

================================================
OEIDE Project IDE
================================================
Issue Number: OE00182615
     -assemblies param pointing to dir in a project cannot be shared

If the -assemblies parameter is set to a directory inside the project,
cannot share project settings. In the generated project.xml the path
specified for the -assemblies is converted to a virtual path
(@{ROOT}\directory format). On importing, this virtual path is not
resolved correctly. As a result the imported project runtime cannot be
started. 

Issue Number: OE00183723
     Too many 'Initialzing OpenEdge Tooling' instances are queued

When running a program after making many changes to a project without the
Build Automatically option, a large number of "Initializing OpenEdge
Tooling" jobs are queued in the Progress view when starting a run
configuration.

Issue Number: OE00184717
     OpenEdge Architect does not mark folders as derived

The builder in OpenEdge Architect marks all r-code generated by the
builder as derived resources, but the folders created by the builder that
contain r-code are not marked as derived.

Issue Number: OE00188997
     Function is not shown in the outline view

The function implementation is not shown in the outline view after the
Include files are expanded in the view.

================================================
OEIDE T4BL
================================================
Issue Number: OE00181086
     T4BL generates TT code with fields in different order to schema

Tools for Business Logic generates temp-table include code with fields in
a different order to the database table.

================================================
OEIDE Template Engine
================================================
Issue Number: OE00187415
     Template(Macro) generates positioning error

Template(Macro) using same custom variable twice generates positioning
error when added to a class if cursor is not positioned at the far left of
the screen

================================================
OEIDE Visual Designer
================================================
Issue Number: OE00169229
     Add Controls Dialog does not restore window position

After opening the "Add Controls" dialog, resizing and repositioning to
make the UI more friendly, one would expect it to retain those settings
the next time it is viewed.  This currently does not happen.

Issue Number: OE00177075
     Double-click to add events causes errors on Vista with UAC

If User Access Control (UAC) is enabled on Vista (which is the default)
and an Architect user double-clicks a control on a form to add a default
event handler, the following error is returned:

System.TypeInitializationException: The type initializer for
'OpenEdge.Designer.Util' threw an exception. -->
System.Security.SecurityException: The source was not found, but some or
all event logs could not be searched. Inaccessible logs: Security.

To workaround this behavior, temporarily disable UAC.  After disabling UAC
you can then re-enable it and the problem will still be gone.

Issue Number: OE00178449
     Extended characters raise errors 257 or 274 in generated code

If a variable name generated from a text or label property from within
Visual Designer contains extended characters, a syntax check raises errors
257 or 274 depending on the position of the character in the variable
name.

Issue Number: OE00179395
     Referencing classes in a .NET Form where classes are on NFS

The Visual Designer will fail to load if the Form references classes which
exist on an NFS share which is in the PROPATH.

Issue Number: OE00179462
     Instance variable generated by Visual Designer missing NO-UNDO

Some instance variables generated by the Visual designer wizards do not
have the NO-UNDO option.

Issue Number: OE00179752
     Unable to save changes to form due to Serialize Error

Unable to save changes to a form in Visual Designer perspective of
OpenEdge Architect due to Serialize Error "An exception occurred when
serializing the design surface."

Issue Number: OE00179804
     Visual Designer fails to load classes containing rowid variables

If you define a private variable as ROWID, the Visual Designer will fail
to load the form, or, if the form is being edited an error will be
generated when you switch from the source code view back to the design
view.

Issue Number: OE00180006
     Visual Designer fails to load form with logical defined as LOG

Visual Designer fails to recognize "LOG" as the logical ABL data type
resulting in an error when loading an ABL Form or user control:

Visual Designer cannot load this class 
Line 20: Unable to resolve type information for type LOG for field <field
name>

Issue Number: OE00181071
     UltraDockManager Custom Property can crash AVM with User Control

The AVM can crash when selecting Custom Property Pages of UltraDockManager
control when form contains a Docked User Control.

Issue Number: OE00181707
     Cancel button in Collections Editor hangs Visual Designer

When the ColumnsCollection property of an UltraGrid band is editied in
Visual Designer, but the edits are cancelled, Visual Designer will hang
for some period of time if there are already unsaved changes in the source
file. The hang can last anywhere from less than a minute to over an hour
(possibly indefinitely - the process has to be killed), but it is most
likely to be a few minutes.

Issue Number: OE00182558
     System Error when NEWing an ABL/.NET hybrid class

If a STOP is raised in the AVM associated with a project while opening a
form in Visual Designer, then that AVM will terminate or subsequently not
behave properly.  A common cause of STOP being raised while opening a form
in the Visual Designer is a property setter attempting to run a .p that is
not available from within the development environment.

Issue Number: OE00183356
     Changes to ABL Inherited Control disappear from Design view

When an ABL inherited control based on UltraGrid is created in Visual
Designer and the column appearance settings are modified for one or more
columns, these changes are lost when the control is used on a form when
switching between the ABL editor and the Visual Designer.

Issue Number: OE00183732
     Error when dropping an User Control on a form

Error "The class [SomeUserControl] needs to be recompiled because it uses
a references to the class [System.Windows.Forms.Control] that has been
modified" when a User Control is dropped on a Form.  This may happen if
the form initialization code changes property values on the user control.

Issue Number: OE00183851
     Shift+F9 to open Visual Designer Sometimes Fails

Pressing Shift+F9 to open a class file in the Visual Designer sometimes
fails with the error "Object reference not set to an instance of an
object".  Re-attempting the Shift+F9 will usually work.

Issue Number: OE00184276
     Changing properties of a control can generate incorrect code

If after changing the property definitions of an ABL control that is
present on another component, another instance of that control is added to
the same component, the code generated by the Visual Designer may not
properly reflect the updated property values for both the original
instance and the new instance of the modified user control.

Issue Number: OE00191101
     10.2A02 Toolbox with ABL user controls takes too long to show up

10.2A02 Toolbox group containing ABL user controls takes too long to
expand in Visual Designer

Issue Number: OE00191666
     Generated code depends on presence of -zn parameter

Code generated by the Visual Designer is affected by the use of the -zn
parameter.  When this parameter is no used, Visual Designer would ensure
that any variables generated by UI controls that begin with an underscore
would be prepended with an "m" to ensure the generated code compiles.  If
the -zn parameter is used then Visual Designer would not add the "m" in
front of variables resulting in the required use of the -zn parameter for
all sessions with the generated code is used.

================================================
Open Client .NET
================================================
Issue Number: OE00148964
     Setting Properties on Connection Object does Nothing

Setting the TcpClientRetry and TcpClientRetryInterval properties on the
connection object and then passing that object to the constructor of an
AppObject has no effect.

Issue Number: OE00165128
     progress.ssl.dll does not contain version information

The assembly progress.ssl.dll, used for OpenClient Deployment, does not
contain any version information unlike the the progress.o4glrt.dll 
assembly.

Issue Number: OE00171828
     Out DataSets in .NET Send Schema Information

An Output DataSet or DataTable parameter in .NET will still send schema
information even if the SetNoSchemaMarshal method is used and the
AppServer is running with the -ttmarshal parameter set to 4.

Issue Number: OE00180718
     AppServer connection from .NET open client takes one minute

When there is no Internet connection on the server, the .NET open client
takes over 60 secs to connect to the AppServer due to the validation of
the digital signatures of the signed DLLs.

================================================
Open Client Dynamic API
================================================
Issue Number: OE00098615
     Dates prior 10/15/1582 passed to .NET Open Client are corrupted

When passing dates prior 10/15/1582 from AppServer to .Net open client
causes dates to become corrupted. 

================================================
Open Client Java
================================================
Issue Number: OE00172110
     Java null integer and logical not unknown when passing dataset

Java null value (or the unknown value on the Progress side) integers and
logicals come through as 0 and false, respectively, when passing datasets
between Java and Progress via the AppServer.

Issue Number: OE00181499
     Java OpenClient ResultSet not fully JDBC compliant

The temp-table ResultSet returned by a java OpenClient proxy does not
provide a fully JDBC 2 compliant java.sql.ResultSet interface. JDBC
clients expecting full JDBC compliance will fail with an exception calling
the following methods:
  getBigDecimal(int columnIndex)
  getBigDecimal(String columnName)
  getRow()
  getType()
  getConcurrency()
  getFetchDirection()

There is no commitment from Progress Software to make the ResultSet fully
JDBC compliant.

Issue Number: OE00182038
     Java Open Client setNoHostVerify problem

The setNoHostVerify option of the RuntimeProperties class in Java Open
Client does not suppress SSL host name verification.

================================================
Open Client Web Services Provider
================================================
Issue Number: OE00176644
     Web service returns incorrect values in TEMP-TABLE DATE fields

When more than one web service client simultaneously request TEMP-TABLEs
from the same WSA, it is possible for DATE fields in the TEMP-TABLEs to
become corrupt. Specifically, if more than one of the returned TEMP-TABLEs
contained a DATE field.

Issue Number: OE00178425
     OE ESB Adapter returns ProDataset containing empty XML tags

ProDataset returned from the OE Native Adapter to the Sonic process
contains an empty XML tag when an OUTPUT DATASET-HANDLE is not assigned a
NAME attribute.

Issue Number: OE00189337
     .NET client not able to read data from DATASETHANDLE param

A client  .NET application for WSA is not able to build a dataset from
DATASET-HANDLE output parameter when the DATASET-HANDLE has an unknown or
empty string  NAMESPACE-URI attribute.

================================================
Porting Dev
================================================
Issue Number: OE00186187
     ICU_DATA in proadsv script causes wrong time on AIX 6.1

ICU_DATA in the proadsv script on AIX 6.1 causes the wrong time to be
recorded when using the TIME statement.

Issue Number: OE00186844
     Progress.ssl.dll assembly not a pure .NET assembly

Progress.ssl.dll assembly is not a true assembly and has mixed managed
code which prevents to create assembly within MS SQL Server 2008 for
instance.

Issue Number: OE00190434
     ODBC folder missing for HPUXIA64 in 10.2A

ODBC folder missing for HPUXIA64 deployment in 10.2A.

================================================
Porting Windows64
================================================
Issue Number: OE00188918
     error 11073 when doing schema pull using GUI client

error 11073 when doing schema pull using GUI client
 COULD NOT CONNECT: enhlog.dll. Logging is disabled (11073)

Issue Number: OE00190891
     DB inaccessible after loading ICU collation rules

Loading any ICU collation rules into a UTF-8 database renders the database
inaccessible.

================================================
PROMSGS Translation
================================================
Issue Number: OE00167648
     The Swedish translation for Error 12668 is not correct

The Swedish translation for the following error message is not correct:

Unable to spawn SonicMQ ClientConnect process. (12668)

Issue Number: OE00180055
     Incorrect swedish translation of message 11678

The Swedish translation of the following message is not correct:

REPLACE/CONCAT may not result in data > 32000 bytes. (11678)

================================================
QPE PROBUILD
================================================
Issue Number: OE00177296
     Building executable in 10.1C02 Solaris fails with error

When building an executable in 10.1C02 on Solaris using the scripts from
$DLC/oebuild/make, you get the following error:

Undefined first referenced symbol in file  dbut_utsetmemfunctions

================================================
QPE QPE
================================================
Issue Number: OE00179257
     Standalone install of the WSA is missing versioninfo.dll file

Standalone install of the WSA deployment component is missing
versioninfo.dll file

================================================
Replication AGENT
================================================
Issue Number: OE00181622
     RPLA crashes when DB table has a recid over 4 billion

Replication agent will crash when processing recid over 4 billion (2^32)
range, producing 'RPLA	(435) SYSTEM ERROR: lkrels record not locked'
error messages.

Issue Number: OE00188527
     Replication Agent wrongly states online backup terminated.

The Replication Agent wrongly states online backup has terminated
abnormally when the backup has already reported it completed successfully.

================================================
Replication Other
================================================
Issue Number: OE00183953
     Querying _Repl VST causes session crash

Querying the _ReplSrv VSTs of the target, then the source and then the
target again causes the session to crash.

Issue Number: OE00189205
     Access to target DB possible without Repl Plus license

Access to target DB possible without Repl Plus license but it shouldn't
be.

================================================
Replication Replication
================================================
Issue Number: OE00188438
     Ports above 32768 cannot be used when using Replication

When you implement OE Replication and use a port greater than 32768, you
receive an error 10822 stating that the port range must be between 1024
and 32768 on NT.  It works fine if Replication is not in use.

================================================
Replication SERVER
================================================
Issue Number: OE00187385
     transition failover fails with internal error

dsrutil db -C transition failover fails with creation date mismatch errors
9214, 9212 and 9216

================================================
Server Technology Other
================================================
Issue Number: OE00167116
     ABL Session crash using HTTP/1.1 with chunking

ABL session crashes when receiving data from AppServer through AIA
deployed on server using HTTP/1.1 chunked response, with specific length
of data and specific response headers length.

Issue Number: OE00181157
     Client persistance not released after incorrect hostname is used

Client persistance keeps sending messages to local store after incorrect
hostname is used.

================================================
SQL ESQL92
================================================
Issue Number: OE00180766
     "Already existing value specified" error when running SQL query

A query that works in 10.1C and 10.1C01 fails in 10.1C02, 10.1C03, and
10.2A with:
    [DataDirect][OpenEdge JDBC Driver][OpenEdge] Already existing value
specified.

================================================
SQL ODBC Drivers
================================================
Issue Number: OE00175958
     The SQLGetData ODBC API returns invalid data length

The SQLGetData ODBC function returns invalid data length in the 
StrLen_or_IndPtr output parameter when retrieving data in multiple parts,
for example from a CLOB field.

================================================
SQL Server
================================================
Issue Number: OE00125436
     Bad performance with INNER JOINs and range predicates

Performance degradation using INNER JOINS with SQL-92 clients	when join
predicates involve range operators such as BETWEEN, "<", "<",  ">", ">=".

Issue Number: OE00175214
     _sqlsrv2 process not allowing clients to connect

ODBC and JDBC clients are receiving messages indicating no more SQL
servers available for connection (8839), when there should be servers
available based on current client load.
_sqlsrv2 process is showing users connected, when in fact no users are
connected to the _sqlsrv2 process that is not responding to client
connection requests.

Issue Number: OE00175855
     Internal error executing a complex query

Internal error in opt_anl2.cxx executing a complex query

Issue Number: OE00176682
     Internal error in SQL engine when select max is in a join query

Error "Encountered internal error in SQL ENGINE at 389 in
Z:/vobs_sql/sql/src/rds/vm.cxx. Contact Progress Technical Support" when
there is a SELECT MAX on a date field on the left outer join.

Issue Number: OE00177877
     OESQL encounters internal error with multiple left outer joins

SQL query with multiple left outer joins fail with the following error:

"=== SQL Exception 1 ===
SQLState=HY000
ErrorCode=-211022
[DataDirect][OpenEdge JDBC Driver][OpenEdge] Encountered internal error in
SQL ENGINE at 47 in Z:/vobs_sql/sql/src/rds/psr_dtbl.cxx. Contact Progress
Technical Support

Issue Number: OE00178438
     OESQL server crashes after connection failure

SQL Server crashes with a rapid succession of connect and disconnects,
after receiving connection failure and error 10093.

Issue Number: OE00178930
     Performance of SQL query worse after UPDATE STATISTICS 10.1C

Performance of a query degrades dramatically after running UPDATE
STATISTICS in 10.1C, going from less than a second to +/- 50 minutes.

Issue Number: OE00180243
     SQL92 server dies with complex UNION queries

The SQL92 server dies with complex UNION queries that worked in 10.1C and
regressed in 10.1C02 and 10.2A.

Issue Number: OE00180311
     SQL Crashes on a select query

SQL Crashes on a select query when duplicate field in the index 

Issue Number: OE00181154
     SQL-92 ROUND returns wrong results with negative numbers

ROUND function can incorrectly round negative values, generating incorrect
results.

Issue Number: OE00182790
     Server crash is likely error with 10.1C03

Server crash is likely error with 10.1C03 when running the attached SELECT
statement

Issue Number: OE00183274
     Encountered internal error at 1934 in rds/xec_qfns.cxx

The error  Encountered internal error in SQL ENGINE at 1934 in
Z:/vobs_sql/sql/src/rds/xec_qfns.cxx.  is caused by the following 
caused by LEFT OUTER JOIN with SELECT in the ON clause

Issue Number: OE00184777
     Unable to write Russian Numero symbol to DB via JDBC/ODBC

Wrong character is written to database in place of Russian Numero symbol
when inserting/updating data via JDBC/ODBC

Issue Number: OE00187265
     _sqlsrv2 has excess threads for failed connection attempts

_sqlsrv2 process creates a thread for client connection attempts.  If a
client does not make / complete the connection, the Open Edge SQL server
will time out the pending connection.  The server will	then cause the
unused thread to end its execution.

Issue Number: OE00188383
     UPDATE query fails with memory allocation error in stub_idx.cxx

Executing an UPDATE statement against a UTF-8 database fails with error
-211023:
Insufficient Memory. Memory allocation failed at #### in
Z:/vobs_sql/sql/src/progstub/stub_idx.cxx

Issue Number: OE00191097
     Internal error when deleting records with array fields, triggers

When deleting records from a table containing an array field and a SQL92
delete trigger one might experience the following error:
SQLState=HY000
ErrorCode=-219901
[DataDirect][OpenEdge JDBC Driver][OpenEdge] Internal error -2 (a column
with th
e specified column id does not exist in the row) in SQL from subsystem
RECORD SE
RVICES function rec_to_data called from stub_tpl_hdl_t::extract_fields on
PUB.Sa
lesrep for MonthQuota. Save log for Progress technical

================================================
SQL SQL
================================================
Issue Number: OE00162246
     SQL False uniqueness constraint violation updating multiple rows

OE SQL incorrectly enforces a uniqueness constraint when updating multiple
rows within a table.

Issue Number: OE00164474
     selecting specific view causes dead server

If a query contains predicates using Oracle-style outer join comparisons
such as "table1.key1 = table1.key1 (+)", and both sides of the outer join
predicate refer to the same table, then query may cause a server crash.

Issue Number: OE00167327
     Query with ArrayFieldName LIKE %exp% in WHERE clause fails

SQL stopped supporting array columns on the left hand side of a LIKE
predicate, e.g.,
SELECT * FROM PUB.TableName WHERE TableName.ArrayName like '%SomeString%'
was failing with Syntax error (7587).

Issue Number: OE00167446
     unjustified: Subquery returns multiple rows (7529) error

Running a select for feeding the set column returns an unjustified 7529
error although the  specific tables are related via a primary key. This
occurs when an UPDATE statement contains a SET assignment which is a
correlated subquery.  A correlated subquery is a subquery which references
data from the row being updated.

Issue Number: OE00171196
     ALTER TABLE creates constraint indexes in the Schema Area

When using ALTER TABLE statement to add a constraint, all related indexes
are created in the Schema Area. ALTER TABLE syntax doesn't include the
"AREA" clause.

Issue Number: OE00175556
     UPDATE STATISTICS degrades query performance in 10.1C01

SQL query runs much more slowly after UPDATE STATISTICS is executed
against the database than it did before.

Issue Number: OE00178647
     [DataDirect][OpenEdge JDBC Driver][OpenEdge] Internal error -2

[DataDirect][OpenEdge JDBC Driver][OpenEdge] Internal error -2 (a column
with the specified column id does not exist in the row) in SQL from
subsystem

Issue Number: OE00178954
     OE SQL CAST of logical col. into char(1) returns incorrect data

OpenEdge SQL CAST of logical column into char(1) does not return correct
data.

Issue Number: OE00181695
     Internal error in SQL ENGINE when comparing fields with =

Getting an internal error in sql engine when evaluating a query that
compares fields in derived tables.  If the match is anything but an
equality match then the problem doesn't occur.

The error that is returned follows:

=== SQL Exception 1 ===
SQLState=HY000
ErrorCode=-211022
[DataDirect][OpenEdge JDBC Driver][OpenEdge] Encountered internal error in
SQL ENGINE at 338 in Z:/vobs_sql/sql/src/rds/opt_jfn1.cxx. Contact
Progress Technical Support

Issue Number: OE00182091
     Null array will be displayed as null instead of a string.

The ARRAY data type is a composite data value that consists of zero or
more elements of a specified data type (known as the element type). If the
result returned from an ARRAY data type is null, it used to be displayed
as a string that consists of ? for each element and seperated by ;. To be
consistent with all other data types, it will be changed to be diaplayed
as null instead of a string with above format now. Same for the result
returned from pro_element function.

Issue Number: OE00182153
     Query that ran OK under 10.1B crashes under 10.1C03

A query that ran error free under 10.1B03, 10.1C, 10.1C01 crashes the ODBC
and the JDBC clients when executed under 10.1C02 and 10.1C03.

Issue Number: OE00182556
     SQL DELETE statement fails with WORD indexed ARRAY fields

Internal error -2 error is generated by the SQL DELETE statement if the
result set is not empty and a WORD indexed ARRAY field exists in table.

Issue Number: OE00182639
     Using delete with nested queries and derived tables causes crash

Running a Delete or Update statement that includes 3 levels of nested
queries involving at least one derived table may cause a server crash.

Issue Number: OE00183245
     Better error message for PRIMARY KEY constraint violation

PRIMARY KEY constaints may not specify nullable columns. That is, any
column specified as part of a PRIMARY KEY constraint must have the "NOT
NULL" attribute. Attempt to specify a PRIMARY KEY constraint with a
nullable column results in return of an error message, "Constraint
Violation" (7595), which does not make clear the reason for the violation.

Issue Number: OE00185321
     Error 7481 Inconsistent types; scalar function on array data typ

The following functions are enhanced to support ARRAY data type

Functions supported:

1) INITCAP
2) INSERT
3) INSTR
4) LEFT
5)  LOCATE
6)  LPAD
7) LTRIM
8) PREFIX
9) REPEAT
10) RIGHT
11) RPAD
12) RTRIM
13) SUBSTR
14) SUFFIX
15) UPPER

Issue Number: OE00186839
     _sqlsrv2 crashes when processing complex query

_sqlsrv2 crashes when executing a specific, complex query involving a
CROSS JOIN on the customer's database. 

Issue Number: OE00186877
     SQL Query containing CASE expression results in server crash

When a SQL query contains a CASE expression the query may cause the SQL92
server process to crash.  This problem can occur when the sql query
contains a combination of CASE expressions and a subquery.

Issue Number: OE00189406
     internal error  at 1834 in Z:/vobs_sql/sql/src/rds/psr_tree.cxx

Creating complex, large  view fails with internal error  at 1834 in
Z:/vobs_sql/sql/src/rds/psr_tree.cxx

Issue Number: OE00190823
     SQL query with 2 equality matches and IS NULL returns wrong resu

In particular cases, a query with two equality matches and one IS NULL
match does not return any data even though data that satisfies the query
exists. The first equality match is between two fields, and the second
equality match is between a field and a constant.

Issue Number: OE00190948
     SQL INSERT statement fails with memory violation

A SQL INSERT statement fails with memory violation error under 10.1C04 and
later when an array column is word indexed and the value for the column is
null.

Issue Number: OE00191724
     Executing SQL DELETE statement against a VIEW returns error

When a certain SQL DELETE statement is executed against an SQL VIEW object
using an JDBC or ODBC client under linuxx86 platform, one of the following
error may be returned:

Internal error 2 (A buffer other than the NLS system handle memory was not
large enough) in SQL from subsystem NLS SERVICES function nlsSortKey
called from pro_idxkey_t::ix_bld_key on . for . Save log for Progress
technical support.

or Internal error -1214 (see dsmret.h) in SQL from subsystem DSM SERVICES
function dsmKeyDelete called from ix_delete on PUB.tsscc for PUB.k-entry.
Save log for Progress technical support.

or Column values too big to make key.

================================================
SQL SQL Explorer
================================================
Issue Number: OE00176806
     sqlexp fails when using -ssl parameter with error (8933)

The old sqlexp ssl parameters: ssl, nosessionreuse, nsr, nohostverify,
nhv, have been deprecated.  They are been replaced by keywords on a new
sqlexp -driverUrl option.  The basic format of this new option is as
follows:  - driverurl
"jdbc:datadirect:openedge://<host>:<port>;databaseName=<dbName>;User=<user
>;Password=<password;"

This is the minimum amount of information required to make a connection. 
To enable an ssl connection, the JDBC driver paramaters, encryptionMethod,
validateServerCertificate, trustStore, trustStorePassword should be added
to the url string.  For example, the enable ssl encryption without
authentication the following driverUrl string would be used.

sqlexp -driverUrl
"jdbc:datadirect:openedge://<host>:<port>;databaseName=<dbName>;User=<user
>;Password=<password;EncryptionMethod=ssl;validateServerCertificate=false"

See JSQL DBC ssl documentation for an explanation of these ssl keywords.

Issue Number: OE00181460
     SQL Explorer fails to connect to multiple databases

Sqlexplorer (JDBC client) had an issue that would prevent it from
dynamically connecting to multiple databases by specifying configuration
name in the url. 
Eg.
jdbc:datadirect:openedge://localhost:6790;databaseName=empty[-mdbq:Mlb
Sales]

The part in the square brackets "[-mdbq:Mlb Sales]" caused sqlexplorer to
return NULL and fail connection . If the part in the url is not used, the
connection to the database would succeed

The issue was specific to sqlexplorer and limited to using the dynamic
connection feature in an MDBQ (multi database query) environment which
uses property files.

Issue Number: OE00182382
     Conv910 causes SQLWidth errors

Converting  a 9.1D database to 10.1C02 or 10.2A with proutil dbname -C
conv910 causes sqlexp or ODBC or JDBC app no resultset contents to be
returned but ErrorCode=-210012
[DataDirect][OpenEdge JDBC Driver][OpenEdge] Column  in table  has value
exceedi
ng its max length or precision.

================================================
SQL Tools
================================================
Issue Number: OE00160618
     SQLLOAD fails with large records

SQLLOAD fails to import data if records are extremely large.

Issue Number: OE00179164
     Sqlschema doesn't dump COLLATE case_insensitive field definition

Sqlschema doesn't dump COLLATE case_insensitive field definition.

Issue Number: OE00182028
     sqlschema creates entries for blank user name

sqlschema creates entries (GRANT statements) for blank user name which
would then cause errors upon loading the sqlschema output file into the
new DB.
This can occur when the database contains table definitions created in the
ABL in an ABL sessin run under the blank user id.

================================================
TTY 4GL
================================================
Issue Number: OE00181109
     Incorrect events may be generated upon leave of a fill-in

Incorrect events may be generated when a fill-in loses focus.  This issue
is more likely to occur when events are programmatically applied to the
fill-in in response to the ENTRY or LEAVE events.

================================================
UI Controls Embedded
================================================
Issue Number: OE00188059
     Incorrect Infragistics functionality using Windows Classic Theme

When the FormDisplayStyle is set to RoundedSizable or RoundedFixed, the
message boxes that should pop-up do not appear unless the mouse cursor is
moved out of the form.

================================================
Web Services Adapter Other
================================================
Issue Number: OE00176788
     WebServices adapter hangs on security/intrusion test

A security/intrusion test by sending a hex 08 inside an SOAP Envelope as
DTD command
causes Tomcat to loop at a high CPU and to block until restarted

================================================
WebClient Other
================================================
Issue Number: OE00159745
     Missing adm2 files from WebClient sportspro.wcp sample file

Some adm2 files are missing from WebClient sportspro.wcp sample file. 
This causes some features in the example to produce errors and not
function.
The workaround is to use the WebClient Application Manager to add the
following three files to the main component:
gui\adm2\dataextapi.r
gui\adm2\dataquery.r
gui\adm2\lookupfield.r

================================================
WebClient WebClient Deployment Pkgr
================================================
Issue Number: OE00183712
     WebClient Deployment Packager fails with OE GUI for .NET

The WebClient Deployment Packager will fail to open a prowcapc file if the
WebClient applications contains any OpenEdge GUI for .NET information
(e.g. if the application packages any OpenEdge Ultra Controls for .NET).
The WebClient Deployment Packager will fail with the following message:
Unable to open <prowcapc file>.The prowcapp file you are trying to open
uses a format that this version of the tool does not recognize.

================================================
WebClient WebClient Executable
================================================
Issue Number: OE00191972
     DYNAMIC-NEW does not download lazy component

If you invoke a class with DYNAMIC-NEW() running with WebClient, and the
class is in some "As Needed" component that hasn't been downloaded yet,
the component will not get downloaded and the client will not be able to
find the class.

================================================
WebClient WebClient Initializer
================================================
Issue Number: OE00176570
     WebClient Authentication Dialog isn't always visible.

When the WebClent application prowcapp file or cab files are on a server
that requires authentication (such as web server), the initializer may
hang before it gets a chance to prompt for user/password info, and
prowcini.exe or prowc.exe will show in the Task Manager. This has been
seen on on 64-bit Windows platforms (both 2003 and Vista) and on Vista
32-bit.

================================================
WebSpeed Agent
================================================
Issue Number: OE00167251
     Error 6388 after 6402 with WebSpeed

In a specific situation, the agent generated error 6388 and 6389 after
error 6402 with error 0.

Issue Number: OE00183588
     WS Agents stuck BUSY during probkup or ai switch

WebSpeed Agents are getting stuck in BUSY state during their startup when
database freezes for short periods of time (ai switch, online probkup,
general client access freeze).

Issue Number: OE00188550
     WebSpeed agent crashes when loading multiple binary files

WebSpeed agent may crash while loading multiple binary files.

Issue Number: OE00191904
     Empty file fields error and stop form processing on WebSpeed

If you have a file upload field on a HTML form, and it is POSTed to
WebSpeed with no file in it, the content of the form after this field will
be unavailable to the WebSpeed agent. The following error will appear in
the server log:
  ERROR: Unable to open file <uploaddir>/. File upload failed. (8869)

