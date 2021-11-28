/* PROGRAM: chkdotd.p                                         */
/* This program reads an input file and counts the number     */
/* of occurrances of each character in the file               */
/* the resulting output can be examined to determine which    */
/* codepage was used to represent the data in the file        */
/* The program prompts for 2 filenames,                       */
/*    1) the name of the file to be analyzed                  */
/*    2) the output filename where the report will be written */
/**************************************************************/

DEF VAR occurs AS INT EXTENT 255.
DEF VAR charnum     AS INT.
DEF VAR filen  AS CHAR FORMAT "x(40)".

filen = ?.
MESSAGE "Enter the filename you wish to analyze" UPDATE filen.

INPUT FROM VALUE(filen) NO-CONVERT NO-MAP NO-ECHO.
REPEAT:
        READKEY.
        IF LASTKEY < 0 THEN LEAVE.
        occurs[LASTKEY] = occurs[LASTKEY] + 1.
END.
INPUT CLOSE.

filen = ?.
MESSAGE "Analysis complete. Enter the output filename" UPDATE filen.

OUTPUT TO VALUE(filen).
REPEAT charnum = 1 to 255:
    IF occurs[charnum] > 0
    THEN DISPLAY charnum occurs[charnum].
END.
