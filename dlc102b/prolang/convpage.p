/* convpage.p                                              */
/*                                                         */
/* This program reads the output of convcoll.p or          */
/* makecoll.p and converts the data in it to a different   */
/* codepage                                                */
/* This program prompts for:				   */
/*	1) The input file name (eg. v7.dat or newcoll.dat) */
/*	2) The output file name to APPEND to		   */
/*	3) The codepage to convert to			   */
/* The output file is in the correct format to create a    */
/* codepage definition file using:			   */
/*   proutil -C codepage-compiler <filename> convmap.cp    */

DEF VARIABLE i       AS INT.
DEF VARIABLE j       AS INT.
DEF VARIABLE target  AS INT.
DEF VARIABLE result  AS INT.

DEF VARIABLE inpage  AS CHAR FORMAT "x(19)".
DEF VARIABLE outpage AS CHAR FORMAT "x(19)".

DEF VARIABLE infile  AS CHAR FORMAT "x(30)".
DEF VARIABLE outfile AS CHAR FORMAT "x(30)".

DEF VARIABLE casename AS CHAR.
DEF VARIABLE collname AS CHAR.
DEF VARIABLE typename AS CHAR.
DEF VARIABLE versname AS CHAR.

DEF VARIABLE updata   AS INT extent 256 INIT ?.
DEF VARIABLE dndata   AS INT extent 256 INIT ?.
DEF VARIABLE csdata   AS INT extent 256 INIT ?.
DEF VARIABLE cisdata  AS INT extent 256 INIT ?.
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
    IF dummy[1] = "CASETABLE-NAME"
    THEN casename = dummy[2].
    ELSE
    IF dummy[1] = "COLLATION-NAME"
    THEN collname = dummy[2].
    ELSE
    IF dummy[1] = "TYPE"
    THEN typename = dummy[2].
    ELSE
    IF dummy[1] = "COLLATION-TRANSLATION-VERSION"
    THEN versname = dummy[2].
    ELSE
    IF dummy[1] = "UPPERCASE-MAP"
    THEN DO i = 0 to 240 BY 16:
	    IMPORT STREAM indat ^ updata[i + 1 FOR 16].
    END.
    ELSE
    IF dummy[1] = "LOWERCASE-MAP"
    THEN DO i = 0 to 240 BY 16:
	    IMPORT STREAM indat ^ dndata[i + 1 FOR 16].
    END.
    IF dummy[1] = "CASE-INSENSITIVE-SORT"
    THEN DO i = 0 to 240 BY 16:
	    IMPORT STREAM indat ^ cisdata[i + 1 FOR 16].
    END.
    IF dummy[1] = "CASE-SENSITIVE-SORT"
    THEN DO i = 0 to 240 BY 16:
	    IMPORT STREAM indat ^ csdata[i + 1 FOR 16].
    END.
END.

/* do the codepage conversion on the upper-case table */
updata[1] = 0.
tmpdata[1] = 0.
DO i = 1 to 255:
    target = asc( codepage-convert(chr(i), outpage, inpage) ).
    result = asc( codepage-convert( chr(updata[i + 1]), outpage, inpage) ).
    tmpdata[target + 1] = result.
END.
DO i = 1 to 256:
    updata[i] = tmpdata[i].
END.

/* do the codepage conversion on the lower-case table */
dndata[1] = 0.
tmpdata[1] = 0.
DO i = 1 to 255:
    target = asc( codepage-convert(chr(i), outpage, inpage) ).
    result = asc( codepage-convert( chr(dndata[i + 1]), outpage, inpage) ).
    tmpdata[target + 1] = result.
END.
DO i = 1 to 256:
    dndata[i] = tmpdata[i].
END.

/* do the codepage conversion on the case-insensitive table */
cisdata[1] = 0.
tmpdata[1] = 0.
DO i = 1 to 255:
    target = asc( codepage-convert(chr(i), outpage, inpage) ).
    tmpdata[target + 1] = cisdata[i + 1].
END.
DO i = 1 to 256:
    cisdata[i] = tmpdata[i].
END.

/* do the codepage conversion on the case-sensitive table */
csdata[1] = 0.
tmpdata[1] = 0.
DO i = 1 to 255:
    target = asc( codepage-convert(chr(i), outpage, inpage) ).
    tmpdata[target + 1] = csdata[i + 1].
END.
DO i = 1 to 256:
    csdata[i] = tmpdata[i].
END.



/* write the output file */
OUTPUT STREAM outdat TO VALUE(outfile) APPEND.

IF updata[2] <> ?
THEN DO:
    PUT STREAM outdat SKIP(1).
    PUT STREAM outdat "CASE" SKIP.
    PUT STREAM outdat "CODEPAGE-NAME "  outpage   SKIP.
    PUT STREAM outdat "CASETABLE-NAME " casename  SKIP.
    PUT STREAM outdat "TYPE "           typename  SKIP.

    /* write the upper case table */
    PUT STREAM outdat "UPPERCASE-MAP" SKIP.
    DO i = 0 to 240 by 16:
      PUT STREAM outdat "  /*" i FORMAT "999" "-" i + 15 FORMAT "999" "*/  ".
      DO j = 0 to 15:
	PUT STREAM outdat updata[i + j + 1] FORMAT "999" SPACE(1).
      END.
      PUT STREAM outdat SKIP.
    END.
    PUT STREAM outdat "ENDTABLE" SKIP.

    /* write the lower case table */
    PUT STREAM outdat "LOWERCASE-MAP" SKIP.
    DO i = 0 to 240 by 16:
      PUT STREAM outdat "  /*" i FORMAT "999" "-" i + 15 FORMAT "999" "*/  ".
      DO j = 0 to 15:
	PUT STREAM outdat dndata[i + j + 1] FORMAT "999" SPACE(1).
      END.
      PUT STREAM outdat SKIP.
    END.
    PUT STREAM outdat "ENDTABLE" SKIP.
    PUT STREAM outdat "ENDCASE" SKIP.
END.

PUT STREAM outdat                                           SKIP(1).
PUT STREAM outdat UNFORMATTED
		   "# Collation tables for code page "
		    outpage
		   " and collation " collname               SKIP.
PUT STREAM outdat "COLLATION" SKIP.
PUT STREAM outdat "CODEPAGE-NAME "                 outpage  SKIP.
PUT STREAM outdat "COLLATION-NAME "                collname SKIP.
PUT STREAM outdat "COLLATION-TRANSLATION-VERSION " versname SKIP.

/* write the case-insensitive collation table */
PUT STREAM outdat "CASE-INSENSITIVE-SORT" SKIP.
DO i = 0 to 240 by 16:
  PUT STREAM outdat "  /*" i FORMAT "999" "-" i + 15 FORMAT "999" "*/  ".
  DO j = 0 to 15:
    PUT STREAM outdat cisdata[i + j + 1] FORMAT "999" SPACE(1).
  END.
  PUT STREAM outdat SKIP.
END.
PUT STREAM outdat "ENDTABLE" SKIP.

/* write the case-sensitive collation table */
PUT STREAM outdat "CASE-SENSITIVE-SORT" SKIP.
DO i = 0 to 240 by 16:
  PUT STREAM outdat "  /*" i FORMAT "999" "-" i + 15 FORMAT "999" "*/  ".
  DO j = 0 to 15:
    PUT STREAM outdat csdata[i + j + 1] FORMAT "999" SPACE(1).
  END.
  PUT STREAM outdat SKIP.
END.
PUT STREAM outdat "ENDTABLE" SKIP.
PUT STREAM outdat "ENDCOLLATION" SKIP.

OUTPUT STREAM outdat CLOSE.
