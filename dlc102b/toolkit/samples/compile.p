/* compile.p */
/* A Procedure to compile application procedures */
/* If this procedure is to be used to upgrade an existing installation */
/* only those procedures that reference tables that have been modified */
/* (new table, changed deleted fields or indexes).                     */
/*                                                                     */
/* This procedure should be encrypted along with the application       */
/* procedures, or precompiled into r-code, prior to deployment.        */

DEFINE VARIABLE proc-name AS CHARACTER FORMAT "x(78)".
DEFINE VARIABLE error-index AS INTEGER.

DISPLAY "Compiling Application Procedures..." WITH NO-BOX.

/* Open log file for tracking compliation status information */
OUTPUT TO "compile.log" KEEP-MESSAGES.

/* loginupg.p should be modified to reflect valid a Application System */
/* Administrator userid and password.                                  */
RUN loginupg.p.

/* Open the input file containing the list of procedures to compile. */
INPUT FROM VALUE("compile.inp") NO-ECHO.
REPEAT:
   /* Cycle through the procedure; compile and report and status */
   SET proc-name.
   COMPILE VALUE(proc-name) SAVE XCODE SUBSTR("abc",2,1) + CHR(76) NO-ERROR.
   IF COMPILER:ERROR THEN
   DO:
     /* Bad compile, display the associated error messages */
     MESSAGE "Compile of" proc-name "Failed with the following ERRORS:" .
     DO error-index = 1 TO ERROR-STATUS:NUM-MESSAGES:
       MESSAGE "  " ERROR-STATUS:GET-MESSAGE(error-index).
     END.
     MESSAGE "".
   END.
   ELSE IF COMPILER:WARNING THEN
   DO:
     /* Produced r-code but recieved warnings in the process. Report them. */
     MESSAGE "Compile of" proc-name "Succeeded with WARNINGS:".
     DO error-index = 1 TO ERROR-STATUS:NUM-MESSAGES:
       MESSAGE "  " ERROR-STATUS:GET-MESSAGE(error-index).
     END.
     MESSAGE "".
   END.
   ELSE
     /* Had a clean compile, produced r-code */
     MESSAGE "Compile of" proc-name "Succeeded.".
END.

/* Do the right thing: Close all input and output files before exiting. */
INPUT CLOSE.
OUTPUT CLOSE.

QUIT.
