/* convattr.p                                           */
/*                                                      */
/* This program reads a codepage attribute table        */
/* converts the data in it to a different codepage      */
/* This program prompts for:				*/
/*	1) The input file name (eg. v7.dat)		*/
/*	2) The output file name to APPEND to		*/
/*	3) The codepage to convert to			*/
/* The output file is in the correct format to create a */
/* codepage definition file using:			*/
/*   proutil -C codepage-compiler <filename> convmap.cp */

DEF VARIABLE i       AS INT.
DEF VARIABLE j       AS INT.
DEF VARIABLE target  AS INT.
DEF VARIABLE result  AS INT.

DEF VARIABLE inpage  AS CHAR FORMAT "x(19)".
DEF VARIABLE outpage AS CHAR FORMAT "x(19)".

DEF VARIABLE infile  AS CHAR FORMAT "x(30)".
DEF VARIABLE outfile AS CHAR FORMAT "x(30)".

DEF VARIABLE typename AS CHAR.

DEF VARIABLE alphadata   AS INT extent 256 INIT ?.
DEF VARIABLE tmpdata  AS INT extent 256 INIT ?.

DEF VARIABLE dummy AS CHAR EXTENT 4.

DEF STREAM indat.
DEF STREAM outdat.

UPDATE  "Enter the input file name:"   infile  AT 30 SKIP
	"Enter the output file name:"  outfile AT 30 SKIP
	"Enter the new codepage name:" outpage AT 30 
    WITH CENTERED ROW 4 NO-LABELS.

INPUT STREAM indat FROM VALUE(infile).

/* read all the input data */
REPEAT:
    dummy[1] = "".
    IMPORT STREAM indat dummy.
    IF dummy[1] = "CODEPAGE-NAME"
    THEN DO:
	IF     inpage <> ""
	   AND inpage <> dummy[2]
	THEN DO:
	    MESSAGE "The input file contains more than one codepage".
	    MESSAGE "No output was created".
	    RETURN.
	END.
	inpage = dummy[2].
    END.
    ELSE
    IF dummy[1] = "TYPE"
    THEN typename = dummy[2].
    ELSE
    IF dummy[1] = "ISALPHA"
    THEN DO i = 0 to 240 BY 16:
	    IMPORT STREAM indat ^ alphadata[i + 1 FOR 16].
    END.
END.

/* do the codepage conversion on the isalpha table */
alphadata[1] = 0.
tmpdata[1] = 0.
DO i = 1 to 255:
    target = asc( codepage-convert(chr(i), outpage, inpage) ).
    tmpdata[target + 1] = alphadata[i + 1].
END.
DO i = 1 to 256:
    alphadata[i] = tmpdata[i].
END.



/* write the output file */
OUTPUT STREAM outdat TO VALUE(outfile) APPEND.

PUT STREAM outdat SKIP(1).
PUT STREAM outdat "CODEPAGE" SKIP.
PUT STREAM outdat "CODEPAGE-NAME "  outpage   SKIP.
PUT STREAM outdat "TYPE "           typename  SKIP.

/* write the alpha attribute table */
PUT STREAM outdat "ISALPHA" SKIP.
DO i = 0 to 240 by 16:
  PUT STREAM outdat "  /*" i FORMAT "999" "-" i + 15 FORMAT "999" "*/  ".
  DO j = 0 to 15:
    PUT STREAM outdat alphadata[i + j + 1] FORMAT "999" SPACE(1).
  END.
  PUT STREAM outdat SKIP.
END.
PUT STREAM outdat "ENDTABLE" SKIP.
PUT STREAM outdat "ENDCODEPAGE" SKIP.

OUTPUT STREAM outdat CLOSE.
