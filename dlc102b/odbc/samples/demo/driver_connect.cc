//////////////////////////////////////////////////////////////////////////////-
//
//	Title:	T
//	Date:	12/21/96
//	Author:	Randy Buckland
//
//	XWindows test for DriverConnect
//
//////////////////////////////////////////////////////////////////////////////-
extern "C" {
#define String XString

#include <Xm/Xm.h>
#include <Xm/MainW.h>
#include <Xm/RowColumn.h>
#include <Xm/PushB.h>
    
#undef String
}
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <locale.h>
#include <sqlext.h>

XtAppContext app;
Widget shell, dialog;

#define errchk(rc) if (rc != SQL_SUCCESS) odbc_error();

HENV henv;
HDBC hdbc;
HSTMT hstmt;

char *connect_str = (char *) "DSN=Sybase";



//////////////////////////////////////////////////////////////////////////////
//
// Print an error message
//
//////////////////////////////////////////////////////////////////////////////
void odbc_error ()
{
    UCHAR sqlstate[10];
    UCHAR   errmsg[SQL_MAX_MESSAGE_LENGTH];
    SDWORD  nativeerr;
    SWORD   actualmsglen;
    RETCODE rc;

    while (1) {
	rc = SQLError(henv, hdbc, hstmt,
		      sqlstate, &nativeerr, errmsg,
		      SQL_MAX_MESSAGE_LENGTH - 1, &actualmsglen);

	if (rc == SQL_ERROR) {
	    printf ("SQLError failed!\n");
	    break;
	}

	if (rc == SQL_NO_DATA_FOUND)  break;
	
	printf ("SQLSTATE = %s\n",sqlstate);
	printf ("NATIVE ERROR = %d\n",nativeerr);
	errmsg[actualmsglen] = '\0';
	printf ("MSG = %s\n\n",errmsg);
    }
}



///////////////////////////////////////////////////////////////////////////////
//
// Connect to the database
//
///////////////////////////////////////////////////////////////////////////////
void connectCB (Widget, XtPointer, XtPointer)
{
    RETCODE rc;
    SQLCHAR instr[256];
    SQLCHAR outstr[256];
    SQLSMALLINT outlen;

    rc = SQLAllocEnv (&henv);
    errchk(rc);
    
    rc = SQLAllocConnect (henv, &hdbc);
    errchk(rc);
    
    strcpy ((char*)instr, connect_str);
    rc = SQLDriverConnect (hdbc, (SQLHWND)shell, instr, strlen((char*)instr),
			   outstr, sizeof(outstr), &outlen,
			   SQL_DRIVER_COMPLETE);
    errchk(rc);
    fprintf (stderr, "outstr = '%s'\n", outstr);

    if (rc == SQL_SUCCESS)
	fprintf (stderr, "Connected\n");
    else
	fprintf (stderr, "Failure\n");
    
    SQLDisconnect (hdbc);
    SQLFreeConnect (hdbc);
    SQLFreeEnv (henv);
}



///////////////////////////////////////////////////////////////////////////////
//
// Quit the program
//
///////////////////////////////////////////////////////////////////////////////
void quitCB (Widget, XtPointer, XtPointer)
{
    XtDestroyApplicationContext (app);
    exit(0);
}



///////////////////////////////////////////////////////////////////////////////
//
// Build the window
//
///////////////////////////////////////////////////////////////////////////////
void build_window ()
{
    Widget main, form, w;
    Arg args[20];
    int n;


    /*
     * Main window
     */
    n = 0;
    main = XmCreateMainWindow (shell, (char *) "main", args, n);
    XtManageChild (main);


    /*
     * Make rowcolumn for buttons
     */
    n = 0;
    form = XmCreateRowColumn (main, (char *) "row", args, n);
    XtManageChild (form);

    //
    // Make buttons
    //
    n = 0;
    w = XmCreatePushButton (form, (char *) "Connect", args, n);
    XtManageChild (w);
    XtAddCallback (w, XmNactivateCallback, connectCB, NULL);
  
    n = 0;
    w = XmCreatePushButton (form, (char *) "Quit", args, n);
    XtManageChild (w);
    XtAddCallback (w, XmNactivateCallback, quitCB, NULL);
}



///////////////////////////////////////////////////////////////////////////////
//
// Main program
//
///////////////////////////////////////////////////////////////////////////////
int main (int argc, char *argv[])
{
    // This is make sure that OS string functions work correctly with DBCS
    setlocale(LC_ALL,"");

    shell = XtAppInitialize (&app, "t", NULL, 0, &argc, argv, NULL, NULL, 0);

    if (argc > 1)
	connect_str = argv[1];
    
    build_window ();

    XtRealizeWidget (shell);
    XtAppMainLoop (app);

    return 0;
}

