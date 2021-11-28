/*
** File:	demoodbc.c
**
** Purpose:	To demonstrate some of the ODBC function calls used to
**		fetch some simple data from a SQL database.
**
** DataDirect Technologies, Inc. 1993-2003
**
** ODBC Functions Used:
**
**	SQLAllocConnect
**	SQLAllocEnv
**	SQLAllocStmt
**	SQLBindCol
**	SQLConnect
**	SQLDisconnect
**	SQLError
**	SQLExecute
**	SQLFetch
**	SQLFreeConnect
**	SQLFreeEnv
**	SQLFreeStmt
**	SQLPrepare 
**	SQLSetConnectOption
*/

/*
** The Header File qeodbc.h when included before the MS ODBC header files
** define data types used by the ODBC Header files.
*/
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include <string.h>
#include <sqlext.h>

/*
** Define Some useful defines
*/
#if !defined (NULL)
#define	NULL	0
#endif


/*
** function: ODBC_error
**
** Purpose:	Display to stdout current ODBC Errors
**
** Arguments:	henv    _ ODBC Environment handle.
**		hdbc    - ODBC Connection Handle error generated on.
**		hstmt	- ODBC SQL Handle error generated on.
**
** Returns:	void
**
*/

void ODBC_error (		/* Get and print ODBC error messages */
	HENV henv,		/* ODBC Environment */
	HDBC hdbc,		/* ODBC Connection Handle */
	HSTMT hstmt)		/* ODBC SQL Handle */
{
	UCHAR	sqlstate[10];
	UCHAR	errmsg[SQL_MAX_MESSAGE_LENGTH];
	SDWORD	nativeerr;
	SWORD	actualmsglen;
	RETCODE	rc;

loop:  	rc = SQLError(henv, hdbc, hstmt,
		sqlstate, &nativeerr, errmsg,
		SQL_MAX_MESSAGE_LENGTH - 1, &actualmsglen);

	if (rc == SQL_ERROR) {
		printf ("SQLError failed!\n");
		return;
	}

	if (rc != SQL_NO_DATA_FOUND) {
		printf ("SQLSTATE = %s\n",sqlstate);
		printf ("NATIVE ERROR = %d\n",nativeerr);
		errmsg[actualmsglen] = '\0';
		printf ("MSG = %s\n\n",errmsg); 
		goto loop;
	}
}

/*
** function: ODBC_Connect
**
** Purpose:	Allocates ODBC HENV and HDBC.
**
** Arguments:	henv    _ Pointer to environment handle
**		hdbc    - Pointer to connection handle
**
** Returns:	RETCODE - Return status from last ODBC Function.
**
*/

RETCODE ODBC_Connect(			/* Perform Driver Connection	*/
	HENV henv,			/* ODBC Environment Handle	*/
	HDBC hdbc,			/* ODBC Connection Handle	*/
	UCHAR *driver,			/* Data Source Name		*/
	UCHAR *uid,			/* User ID			*/
	UCHAR *pwd)			/* User Password		*/
{
	RETCODE	rc;
	int	retries;

#if defined(TRACING)
	rc = SQLSetConnectOption(hdbc, SQL_OPT_TRACE, 1);
	if ((rc != SQL_SUCCESS) && (rc != SQL_SUCCESS_WITH_INFO))
		return (rc);
#endif
/*
** try connecting up to 3 times
*/
	for (retries = 1; retries <= 3; retries++) {
		rc = SQLConnect (hdbc, driver, SQL_NTS,
		         uid, SQL_NTS, pwd, SQL_NTS); 
		if ((rc == SQL_SUCCESS) || (rc == SQL_SUCCESS_WITH_INFO))
			return (rc);
                else {
			printf("SQLConnect: Failed...\n");
			ODBC_error (henv, hdbc, SQL_NULL_HSTMT);
			printf("SQLConnect: Retrying Connect.\n");
		}
	}
/*
** Attempt to obtain a meaningful error as to why connect failed.
*/
        printf("No connection could be established.\n");
	ODBC_error (henv, hdbc, SQL_NULL_HSTMT);
	return (SQL_INVALID_HANDLE);
}

/*
** function:	EnvInit
**
** Purpose:	Allocates ODBC HENV and HDBC.
**
** Arguments:	henv    _ Pointer to environment handle
**		hdbc    - Pointer to connection handle
** Returns:	RETCODE status from ODBC Functions.
*/
RETCODE EnvInit(HENV *henv, HDBC *hdbc)
{
	RETCODE rc;

	rc = SQLAllocEnv (henv);
	if ((rc == SQL_SUCCESS) || (rc == SQL_SUCCESS_WITH_INFO))
		rc = SQLAllocConnect (*henv, hdbc);
	return (rc);
}

/*
** function:	EnvClose
**
** Purpose:	Frees environment and connection handles.
**
** Arguments:	henv    _ environment handle
**		hdbc    - connection to handle
*/
void EnvClose(HENV henv, HDBC hdbc)
{
	SQLDisconnect (hdbc);
	SQLFreeConnect (hdbc);
	SQLFreeEnv (henv);

}
/*
** Defines Used by ArgParse and Parent.
*/
#define	PWD_ARG		1
#define	UID_ARG		2
#define	DSN_ARG		3
#define	HELP_ARG	4
#define XML_ARG		5

/*
** function:	ArgParse
**
** Purpose:	To parse runtime arguments.
**
** Arguments:	argv which is a character string to be parsed.
**
*/
int ArgParse(char *argv)
{
	if (!strcasecmp(argv, "-help"))
		return (HELP_ARG);
	if (!strcasecmp(argv, "-pwd"))
		return (PWD_ARG);
	if (!strcasecmp(argv, "-uid"))
		return (UID_ARG);
	if (!strcasecmp(argv, "-xml"))
		return (XML_ARG);
	else
		return (DSN_ARG);
}

/*
** Defines used by main program.
*/
#define	PWD_LEN		32
#define	UID_LEN		32
#define	OPT1_LEN	255
#define	OPT2_LEN	255
#define	DSN_LEN		32
#define	PWD_MSG1 "Requested password exceeds compiled limit of %d.\n"
#define	PWD_ERR1 "Password not found after keyword -pwd on command line.\n"
#define	UID_MSG1 "Requested username exceeds compiled limit of %d.\n"
#define	UID_ERR1 "Username not found after keyword -uid on command line.\n"
#define	USAGE_MSG1 "Usage: %s [-uid username] [-pwd password] [-xml] DSN.\n"
#define	BANNER "%s DataDirect Technologies, Inc. ODBC Sample Application.\n"

/*
** Program:	demo
**
** Purpose:	Demo ODBC routine using demo data EMP.
*/
int main(int argc, char * argv[])
{
	HDBC	hdbc;
	HENV	henv;
	HSTMT	hstmt;
	RETCODE	rc;
	UCHAR	uid[UID_LEN];
	UCHAR	pwd[PWD_LEN];
	UCHAR	driver[DSN_LEN];
	UCHAR	sql[255];
	UCHAR	table[255];
	UCHAR	emp_id[15],
		first_name[15],
		last_name[15],
		hire_date[30],
		salary[15],
		dept[15];
	SQLLEN	val_emp_id,
		val_first_name,
		val_last_name,
		val_hire_date,
		val_salary,
		val_dept;
	BOOL	persistAsXML = 0;

/*
** Define Table and Driver
*/
	printf(BANNER, argv[0]);
	uid[0] = 0;
	pwd[0] = 0;
	if (argc > 1) {
		int argIndex;	/* Input argument index		*/
		int argCount;	/* Running count of arguments	*/

		for (argCount=argc-1, argIndex=1; argCount > 0;
				argIndex++, argCount--) {
			switch (ArgParse(argv[argIndex])) {
			case HELP_ARG:
				printf(USAGE_MSG1, argv[0]);
				return(1);
			case PWD_ARG:
				argIndex++;
				if (argCount <= 1) {
					printf(PWD_ERR1);
					printf(USAGE_MSG1, argv[0]);
					return(1);
				}
				if (strlen(argv[argIndex]) > PWD_LEN) {
					printf(PWD_MSG1, PWD_LEN);
					return(1);
				}
				strcpy((char*)pwd, argv[argIndex]);
				argCount--;
				break;
			case UID_ARG:
				argIndex++;
				if (argCount <= 1) {
					printf(UID_ERR1);
					printf(USAGE_MSG1, argv[0]);
					return(1);
				}
				if (strlen(argv[argIndex]) > UID_LEN) {
					printf(UID_MSG1, UID_LEN);
					return(1);
				}
				strcpy((char*)uid, argv[argIndex]);
				argCount--;
				break;
			case DSN_ARG:
				strcpy((char*)driver, argv[argIndex]);
				break;
			case XML_ARG:
				persistAsXML = 1;
				break;
			}
		}
	} 
	else {
		printf(USAGE_MSG1, argv[0]);
		return(1);
	}

	if (strlen((char*)uid) == 0)
		strcpy ((char*)uid, "odbc01");
	if (strlen((char*)pwd) == 0)
		strcpy ((char*)pwd, (char*)uid);

	printf ("%s: will connect to data source '%s' as user '%s/%s'.\n", 
		argv[0], driver, uid, pwd);

#if !defined (__cplusplus) && defined (hppa)
/*
** C programs must call the HP C++ Object initializer function.
*/
	_main ();
#endif
	EnvInit (&henv, &hdbc);

#ifdef USE_CURSORS
/*
** Use cursor library
*/
	rc = SQLSetConnectAttr (hdbc, SQL_ATTR_ODBC_CURSORS, SQL_CUR_USE_ODBC,0);
        if ((rc != SQL_SUCCESS) && (rc != SQL_SUCCESS_WITH_INFO)) {
	    printf ("Unable to use cursor library!\n");
	    ODBC_error (henv, hdbc, hstmt);
	}
#endif
	
	rc = ODBC_Connect (henv, hdbc, driver, uid, pwd);
	if ((rc != SQL_SUCCESS) && (rc != SQL_SUCCESS_WITH_INFO))
		exit(255);	/* Exit with failure */

/*
** Allocate a HSTMT to communicate with ODBC DB Driver.
*/
	rc = SQLAllocStmt (hdbc, &hstmt);
	if ((rc != SQL_SUCCESS) && (rc != SQL_SUCCESS_WITH_INFO)) {
		printf ("Unable to Allocate a HSTMT:\n");
		ODBC_error (henv, hdbc, hstmt);
		EnvClose (henv, hdbc);
		exit (255);
	}
/*
** Build the SQL statement
*/
	strcpy ((char*)table, "EMP");
	strcpy ((char*)sql, "SELECT EMP_ID, FIRST_NAME, LAST_NAME, ");
	strcat ((char*)sql, "HIRE_DATE, SALARY, DEPT FROM ");
	strcat ((char*)sql, (char*)table);
/*
** Prepare our SQL Statement for Executions.
*/
	if (persistAsXML) {
/*
** In order to persist a result set as an XML file, the ODBC driver must support Static Cursors.
*/
        	rc = SQLSetStmtOption(hstmt,SQL_ATTR_CURSOR_TYPE,SQL_CURSOR_STATIC);
        	if ((rc != SQL_SUCCESS) && (rc != SQL_SUCCESS_WITH_INFO)) {
                	printf ("Driver does not support Static cursors. RC=%d\n", rc);
                	ODBC_error (henv, hdbc, hstmt);
                	EnvClose (henv, hdbc);
                	exit (255);
		}
        }

	rc = SQLPrepare (hstmt, sql, (SDWORD)strlen((char*)sql));
	if ((rc != SQL_SUCCESS) && (rc != SQL_SUCCESS_WITH_INFO)) {
		printf ("SQLPrepare has Failed. RC=%d\n", rc);
		ODBC_error (henv, hdbc, hstmt);
		EnvClose (henv, hdbc);
		exit (255);
	}
/*
** Bind variables to SQL Columns
*/
	rc = SQLBindCol (hstmt, 1, SQL_C_CHAR,
				&emp_id,
				(SDWORD)sizeof(emp_id),
				&val_emp_id);
	rc = SQLBindCol (hstmt, 2, SQL_C_CHAR,
				&first_name,
				(SDWORD)sizeof(first_name),
				&val_first_name);
	rc = SQLBindCol (hstmt, 3, SQL_C_CHAR,
				&last_name,
				(SDWORD)sizeof(last_name),
				&val_last_name);
	rc = SQLBindCol (hstmt, 4, SQL_C_CHAR,
				&hire_date,
				(SDWORD)sizeof(hire_date),
				&val_hire_date);
	rc = SQLBindCol (hstmt, 5, SQL_C_CHAR,
				&salary,
				(SDWORD)sizeof(salary),
				&val_salary);
	rc = SQLBindCol (hstmt, 6, SQL_C_CHAR,
				&dept,
				(SDWORD)sizeof(dept),
				&val_dept);
/*
** Execute Prepared SQL
*/
	rc = SQLExecute (hstmt);
	if ((rc != SQL_SUCCESS) && (rc != SQL_SUCCESS_WITH_INFO)) {
		printf ("......SQLExecute has Failed. RC=%d\n", rc);
		ODBC_error (henv, hdbc, hstmt);
		EnvClose (henv, hdbc);
		exit (255);
	}

	if (persistAsXML) {
		rc = SQLSetStmtOption(hstmt,1053,(SQLULEN)"./EMP.xml");
		if ((rc != SQL_SUCCESS) && (rc != SQL_SUCCESS_WITH_INFO)) {
               	 	printf ("......PersistAsXML has Failed. RC=%d\n", rc);
                	ODBC_error (henv, hdbc, hstmt);
                	EnvClose (henv, hdbc);
                	exit (255);
		}
		printf ("\nResult set persisted as './EMP.xml'.\n");
        }

/*
** Fetch Data
*/
	printf("\n");
	printf("%-15s %-15s %-20s %-15s %-15s\n",
	       "First Name", "Last Name", "Hire Date", "Salary", "Dept");
	printf("%-15s %-15s %-20s %-15s %-15s\n",
	       "----------", "---------", "---------", "------", "----");
	for (;;) {
		rc = SQLFetch (hstmt);
		if (rc == SQL_NO_DATA_FOUND) {
			printf ("SQLFetch returns: SQL_NO_DATA_FOUND\n");
			break;
		}
		if ((rc != SQL_SUCCESS) && (rc != SQL_SUCCESS_WITH_INFO)) {
			printf ("SQLFetch has Failed. RC=%d\n", rc);
			ODBC_error (henv, hdbc, hstmt);
			break;
		}
		printf("%-15s %-15s %-20s %-15s %-15s\n",
		       first_name, last_name, hire_date, salary, dept);
	}
	printf("\n");
/*
** Free Bind Buffers
*/
	rc = SQLFreeStmt (hstmt, SQL_UNBIND);
	EnvClose(henv, hdbc);
}

