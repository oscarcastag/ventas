/* convcoll.p                                           */
/*                                                      */
/* This program reads a procoll.dat file and generates  */
/* a file named v7.dat					*/
/* v7.dat is in the correct format to use to build the  */
/* codepage definition file using:			*/
/*    proutil -C codepage-compiler v7.dat convmap.cp    */

DEF VARIABLE i       AS INT.
DEF VARIABLE j       AS INT.
DEF VARIABLE ssharp  AS INT.
DEF VARIABLE userch  AS INT.
DEF VARIABLE byte1   AS INT.
DEF VARIABLE byte2   AS INT.

DEF STREAM dat.

INPUT FROM procoll.dat BINARY NO-CONVERT NO-MAP.
OUTPUT STREAM dat TO v7.dat.

/* read the 5- or 6-byte header and get the user-defined sort flag */
READKEY.
byte1 = LASTKEY.
READKEY.
byte2 = LASTKEY.
READKEY.

/* if this is a 6-byte header, read 1 extra byte */
IF byte1 = 6 OR byte2 = 6
THEN READKEY.

READKEY.
ssharp = LASTKEY.
READKEY.
userch = LASTKEY.

/* read the up-case table */
PUT STREAM dat "CASE" SKIP.
PUT STREAM dat "CODEPAGE-NAME ????" SKIP.
PUT STREAM dat "CASETABLE-NAME ~"Basic~"" SKIP.
PUT STREAM dat "TYPE ~"1~"" SKIP.
PUT STREAM dat "UPPERCASE-MAP" SKIP.
DO i = 0 to 240 by 16:
  PUT STREAM dat "  /*" i FORMAT "999" "-" i + 15 FORMAT "999" "*/  ".
  DO j = 0 to 15:
    READKEY.
    PUT STREAM dat LASTKEY FORMAT "999" SPACE(1).
  END.
  PUT STREAM dat SKIP.
END.
PUT STREAM dat "ENDTABLE" SKIP.

/* read the lower case table */
PUT STREAM dat "LOWERCASE-MAP" SKIP.
DO i = 0 to 240 by 16:
  PUT STREAM dat "  /*" i FORMAT "999" "-" i + 15 FORMAT "999" "*/  ".
  DO j = 0 to 15:
    READKEY.
    PUT STREAM dat LASTKEY FORMAT "999" SPACE(1).
  END.
  PUT STREAM dat SKIP.
END.
PUT STREAM dat "ENDTABLE" SKIP.
PUT STREAM dat "ENDCASE" SKIP(1).


PUT STREAM dat "COLLATION" SKIP.
PUT STREAM dat "CODEPAGE-NAME  ????"    SKIP.
PUT STREAM dat "COLLATION-NAME User-Defined" SKIP.

IF userch > 0
THEN PUT STREAM dat "COLLATION-TRANSLATION-VERSION 2.0-16" SKIP.
ELSE PUT STREAM dat "COLLATION-TRANSLATION-VERSION 1.0-16" SKIP.

/* read the case-insensitive collation table */
PUT STREAM dat "CASE-INSENSITIVE-SORT" SKIP.
DO i = 0 to 240 by 16:
  PUT STREAM dat "  /*" i FORMAT "999" "-" i + 15 FORMAT "999" "*/  ".
  DO j = 0 to 15:

    READKEY.

    /* v7.3 uses 0 to indicate ssharp*/
    IF ssharp > 0 AND LASTKEY = 254
    THEN PUT STREAM dat 0       FORMAT "999" SPACE(1).
    ELSE PUT STREAM dat LASTKEY FORMAT "999" SPACE(1).
  END.
  PUT STREAM dat SKIP.
END.
PUT STREAM dat "ENDTABLE" SKIP.

/* read the case-sensitive collation table */
PUT STREAM dat "CASE-SENSITIVE-SORT" SKIP.
DO i = 0 to 240 by 16:
  PUT STREAM dat "  /*" i FORMAT "999" "-" i + 15 FORMAT "999" "*/  ".
  DO j = 0 to 15:

    READKEY.

    /* v7.3 uses 0 to indicate ssharp*/
    IF ssharp > 0 AND LASTKEY = 254
    THEN PUT STREAM dat 0       FORMAT "999" SPACE(1).
    ELSE PUT STREAM dat LASTKEY FORMAT "999" SPACE(1).
  END.
  PUT STREAM dat SKIP.
END.
PUT STREAM dat "ENDTABLE" SKIP.
PUT STREAM dat "ENDCOLLATION" SKIP.

OUTPUT STREAM dat CLOSE.

DISPLAY "v7.dat has been created.  Please: "                   SKIP(1)
	"   1) Examine it carefully"		               SKIP
	"   2) Make any necessary corrections"	               SKIP
	"   3) Supply the proper codepage and collation names" SKIP(1)
	"You can then add it to $DLC/prolang/convmap.dat"      SKIP
	"and generate a new convmap.cp file"
    WITH FRAME f1 CENTERED ROW 4.

