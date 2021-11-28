     JDBCREADME.TXT
     Progress(R) DataDirect(R)
     DataDirect Connect(R) for JDBC(TM) Progress OpenEdge(R) Driver
     Release 4.2.1.006026
     March 2012


***********************************************************************
Copyright (c) 1994-2011 Progress Software Corporation and/or its 
subsidiaries or affiliates. All Rights Reserved.

***********************************************************************

This README file contains additional driver information not 
included in the DataDirect Connect(R) for JDBC(TM) Progress OpenEdge(R) 
documentation.

CONTENTS

Release 4.2 Features
Notes, Known Problems, and Restrictions
Using the Documentation
DataDirect Connect(R) for JDBC Progress OpenEdge(R) Driver Files
Third-Party License Agreements
   

     Release 4.2 Features

* Support for Progress OpenEdge 11.0.


     Notes, Known Problems, and Restrictions

The following are notes, known problems, or restrictions with 
this release of the Progress OpenEdge driver.

* The driver allows PreparedStatement.setXXX methods 
  and ResultSet.getXXX methods on Blob/Clob data types in addition 
  to the functionality described in the JDBC specification. 
  The supported conversions typically are the same as those for 
  LONGVARBINARY/LONGVARCHAR, except where limited by database support.

* Calling CallableStatement.registerOutputParameter(parameterIndex, 
  sqlType) with sqlType Types.NUMERIC or Types.DECIMAL sets the scale 
  of the output parameter to zero (0). 
  According to the JDBC specification, calling 
  CallableStatement.registerOutputParameter(parameterIndex, sqlType, 
  scale) is the recommended method for registering NUMERIC or 
  DECIMAL output parameters. 

* When attempting to create an updatable, scroll-sensitive result set 
  for a query that contains an expression as one of the columns, the 
  driver cannot satisfy the scroll-sensitive request. The driver 
  downgrades the type of the result returned to scroll-insensitive.

* The driver supports retrieval of output parameters from a 
  stored procedure before all result sets and/or update counts 
  have been completely processed. When CallableStatement.getXXX is 
  called, result sets and update counts that have not yet been 
  processed by the application are discarded to make the output 
  parameter data available. Warnings are generated when results 
  are discarded.

* The preferred method for executing a stored procedure that generates 
  result sets and update counts is using CallableStatement.execute(). 
  If multiple results are generated using executeUpdate, the first 
  update count is returned. Any result sets prior to the first update 
  count are discarded. If multiple results are generated using 
  executeQuery, the first result set is returned. Any update counts 
  prior to the first result set are discarded. Warnings are generated 
  when result sets or update counts are discarded. 

* The ResultSet methods getTimestamp, getDate, and getTime return 
  references to mutable objects. If the object reference returned from 
  any of these methods is modified, re-fetching the column using the 
  same method returns the modified value. The value is only modified in 
  memory; the database value is not modified.


     Using the Documentation

You can view the documentation using Adobe Reader.

NOTE: To download Adobe Reader from the Web, go to Adobe’s Web site 
at http://www.adobe.com.


     DataDirect Connect(R) for JDBC Progress OpenEdge(R) Files 

When you extract the contents of the provided ZIP file to a directory, 
you will notice the following files that are required to 
use the DataDirect Connect for JDBC Progress OpenEdge Driver: 

openedge.jar     Progress OpenEdge Driver and DataSource classes

pool.jar         DataDirect Connection Pool Manager classes

jdbcreadme.txt   This file 


     Third-Party License Requirements/Agreements

The DataDirect Connect for JDBC drivers include certain software 
products made available for distribution by Sun Microsystems, Inc. and 
are subject to the following limitation:
 
Java(R) Technology Restrictions. You may not modify the Java 
Platform Interface ("JPI", identified as classes contained within the 
"java" package or any subpackages of the "java" package), by creating 
additional classes within the JPI or otherwise causing the addition to 
or modification of the classes in the JPI. In the event that you 
create an additional class and associated API(s) which (i) extends 
the functionality of the Java Platform, and (ii) is exposed to third 
party software developers for the purpose of developing additional 
software which invokes such additional API, you must promptly publish 
broadly an accurate specification for such API for free use by all 
developers. You may not create, or authorize your licensees to create 
additional classes, interfaces, or subpackages that are in any way 
identified as "java", "javax", "sun" or similar convention as specified 
by Sun in any naming convention designation.


---------------------
End of JDBCREADME.TXT

