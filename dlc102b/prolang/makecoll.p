/* makecoll.p                                                          */
/*                                                                     */
/* This program will build a collation table and add it to convmap.dat */
/*                                                                     */
/* USAGE:                                                              */
/*    1) make a copy of the current convmap.dat in your working        */
/*       directory.                                                    */
/*    2) Make sure it contains correct UPPERCASE and LOWERCASE maps    */
/*       for the desired codepage.                                     */
/*    3) RUN prolang/makecoll.p                                        */
/*       It will create an output file newcoll.dat which you should    */
/*       append to the end of convmap.dat                              */
/*    4) Use proutil -C codepage-compiler convmap.dat convmap.cp       */
/*       to compile and then test the collation tables you have built  */
/*    5) If you want to create a .df file to load the collation tables */
/*       into a database, use $DLC/prolang/makedf.p                    */
/*    6) If you want to convert the collation table to a different     */
/*       codepage, you can repeat this process, but it is easier to    */
/*       use prolang/convpage.p to convert newcoll.dat to the new      */
/*       codepage                                                      */
/*                                                                     */
/* makecoll.p will prompt for:                                         */
/*  - the codepage-name for which you will create a collation table    */
/*  - the collation-name you want to give to your new collation table  */
/*  - the CASETABLE-NAME which defines your upper and lower case rules */
/*                                                                     */
/* NOTE: this program is very sensitive to the exact format of         */
/* the convmap.dat file.  This program will not work properly if       */
/* the convmap.dat file entrys do not have exactly the same            */
/* as those provided in the standard convmap.dat provided by           */
/* Progress Software Corporation                                       */

DEFINE STREAM instrm.
DEFINE STREAM outstrm.

DEFINE VAR i             AS INT                 NO-UNDO.
DEFINE VAR j             AS INT                 NO-UNDO.
DEFINE VAR k             AS INT                 NO-UNDO.
DEFINE VAR chr-val       AS INT                 NO-UNDO.
DEFINE VAR inline        AS CHAR FORMAT "x(80)" NO-UNDO.
DEFINE VAR codepage-name AS CHAR FORMAT "x(19)" NO-UNDO.
DEFINE VAR case-name     AS CHAR FORMAT "x(19)" NO-UNDO INIT "Basic".
DEFINE VAR collate-namE  as char fORMAT "x(19)" NO-UNDO.
DEFINE VAR entry-found   AS LOG                 NO-UNDO.
DEFINE VAR keyval        AS CHAR                NO-UNDO.
DEFINE VAR dataval       AS CHAR                NO-UNDO.

DEFINE VAR uptable	 AS INT  EXTENT 255     NO-UNDO INIT 0.
DEFINE VAR dntable	 AS INT  EXTENT 255     NO-UNDO INIT 0.
DEFINE VAR islower       AS LOG  EXTENT 255     NO-UNDO.

DEF VAR chr-list   AS CHAR    EXTENT 200 FORMAT "x(3)" NO-UNDO.
DEF VAR cs-weight  AS INT     EXTENT 255 INIT ?        NO-UNDO.
DEF VAR cis-weight AS INT     EXTENT 255 INIT ?        NO-UNDO.

DEF VAR next-weight AS INT     INIT 0                  NO-UNDO.
DEF VAR ss-offset   AS INT     INIT 0                  NO-UNDO.
DEF VAR equiv-chr   AS CHAR             FORMAT "x(3)"  NO-UNDO.
DEF VAR this-chr    AS CHAR             FORMAT "x(3)"  NO-UNDO.
DEF VAR outname     AS CHAR             FORMAT "x(19)" NO-UNDO.
DEF VAR ssharp      AS LOGICAL                         NO-UNDO.
DEF VAR ssharp-chr  AS INT                             NO-UNDO.



/* prompt the user for the info needed to build the correct collation table */
DO WHILE codepage-name = ? OR codepage-name = ""
      OR collate-name  = ? OR collate-name  = "":
    UPDATE 
	   "Desired database codepage name:" codepage-name SKIP
	   "Desired collation name:"         collate-name SKIP
	   "German Sharp-S processing?"      ssharp	  SKIP
	   "Value of the Sharp-S character?" ssharp-chr
	WITH FRAME f1 CENTERED ROW 3 NO-LABELS.
END.

/* prompt the user for the info needed to find the upcase & downcase tables */
DO ON ERROR UNDO, RETRY:
    UPDATE "You must have a local copy of convmap.dat which" SKIP
	   "contains an UPPERCASE-MAP and a LOWERCASE-MAP"   SKIP
	   "for your codepage.  Those upper and lowercase"   SKIP
	   "maps are identified in convmap.dat with a field" SKIP
	   "CASETABLE-NAME (which is usually ~"Basic~")"     SKIP(1)
	   "Enter the CASETABLE-NAME:"         case-name
	WITH FRAME f2 CENTERED ROW 3 NO-LABELS.

    INPUT STREAM instrm CLOSE.
    INPUT STREAM instrm FROM convmap.dat.

    STATUS DEFAULT "Searching for entry...".

    /* search the input file for 
		CASE
		CODEPAGE-NAME  <desired name>
		CASETABLE-NAME <desired name>
    */
    entry-found = no.
search-case:
    REPEAT:
	IMPORT STREAM instrm UNFORMATTED inline.
	IF inline = "CASE"
	THEN REPEAT:
	    /* a CASE entry was found,  check if it is the right one */
	    IMPORT STREAM instrm keyval dataval.
	    IF    (keyval = "CODEPAGE-NAME" and dataval <> codepage-name)
	       OR (keyval = "CASETABLE-NAME" and dataval <> case-name)
	    THEN NEXT search-case.  /* wrong entry, skip it */
	    IF keyval = "UPPERCASE-MAP"
	    THEN DO:
		entry-found = yes.
		LEAVE search-case.
	    END.
	END.
    END.
    IF NOT entry-found
    THEN DO:
	Message "The desired CASETABLE-NAME was not found in convmap.dat".
	UNDO, RETRY.
    END.
END.

STATUS DEFAULT "".

/* read the UPPERCASE table */
IMPORT STREAM instrm ^ ^ uptable[1 FOR 15].
DO i = 16 TO 240 BY 16:
    IMPORT STREAM instrm ^ uptable[i FOR 16].
END.

/* skip forwards to the LOWERCASE table and copy it */
DO WHILE inline <> "LOWERCASE-MAP":
    IMPORT STREAM instrm UNFORMATTED inline.
END.
IMPORT STREAM instrm ^ ^ dntable[1 FOR 15].
DO i = 16 TO 240 BY 16:
    IMPORT STREAM instrm ^ dntable[i FOR 16].
END.

INPUT  STREAM instrm  CLOSE.

/* determine which characters are lower case */
DO i = 1 to 255:  /* legal chars 1-255 */
    IF uptable[i] <> i
    THEN islower[i] = yes.
    ELSE islower[i] = no.
END.

/* fill in the basic, uppercase sort order */
DISPLAY
   "Please enter the upper-case characters in the order you wish them to appear"
   "In each field, you may type the letter, or the letter's 3 digit"
   "decimal value" skip
   "DO NOT enter any lower case letters" skip
   "For 2 letters which are equivalent, such as E and E-accent-grave"
   "Please enter the letter only once."
	SKIP(3)
    WITH FRAME f3 CENTERED ROW 5 NO-LABELS.

UPDATE chr-list WITH FRAME f3.

/* convert to upper-case */
STATUS DEFAULT "Converting to uppercase and eliminating duplicates...".
DO i = 1 to 200:
    IF chr-list[i] = "" THEN NEXT.
    IF LENGTH(chr-list[i]) = 1
    THEN chr-list[i] = CHR(uptable[ASC(chr-list[i])]).
    ELSE chr-list[i] = STRING(uptable[INTEGER(chr-list[i])], "999").
END.

/* eliminate duplicates */
DO i = 1 to 199:
    IF chr-list[i] = "" THEN NEXT.
    DO j = i + 1 to 200:
	DO WHILE chr-list[i] = chr-list[j]:
	    DO k = j to 199:
		chr-list[k] = chr-list[k + 1].
	    END.
	    chr-list[200] = "".
	END.
    END.
END.
STATUS DEFAULT "".

DISPLAY chr-list WITH FRAME f3.

/* determine what shift is necessary to make S have collation 83 */
/* this makes the German ssharp work properly			 */
ss-offset = 0.
IF ssharp
THEN DO:

    /* validate the ssharp-chr value */
    cs-weight[ssharp-chr] = 0.
    cis-weight[ssharp-chr] = 0.

    next-weight = 65.
    DO i = 1 to 200:
	IF chr-list[i] = "" THEN NEXT.

	IF LENGTH(chr-list[i]) = 1
	THEN chr-val = ASC(chr-list[i]).
	ELSE chr-val = INTEGER(chr-list[i]).

	IF chr-val = 83  /* S */
	THEN LEAVE.

	next-weight = next-weight + 1.
	IF dntable[chr-val] <> chr-val
	THEN next-weight = next-weight + 1.
    END.
    ss-offset = next-weight - 83.
    IF ss-offset > 31
    THEN DO:
	DISPLAY "There are too many characters before S to do" SKIP
		"correct German Sharp-S processing.".
	RETURN.
    END.
END.

/* Generate the CASE-SENSITIVE SORT WEIGHTS */
DO i = ss-offset + 1 to 64:
    cs-weight[i] = i - ss-offset.
END.
next-weight = 65 - ss-offset.
DO i = 1 to 200:
    IF chr-list[i] = "" THEN NEXT.

    IF LENGTH(chr-list[i]) = 1
    THEN chr-val = ASC(chr-list[i]).
    ELSE chr-val = INTEGER(chr-list[i]).

    cs-weight[chr-val] = next-weight.
    next-weight = next-weight + 1.

    /* insert the lower case letter immediately after the uppercase letter */
    IF dntable[chr-val] <> chr-val
    THEN DO:
	cs-weight[dntable[chr-val]] = next-weight.
	next-weight = next-weight + 1.
    END.
END.

/* ask about uppercase letters which haven't yet been assigned */
DO i = 1 + ss-offset to 255:
    IF islower[i] OR cs-weight[i] <> ?
    THEN NEXT.

    this-chr = CHR(i).
    equiv-chr = "".
    DISPLAY "WARNING: The characters you see displayed may be incorrect" SKIP
	    "In case of a discrepancy, believe the decimal values" SKIP
	    "which are displayed, and ignore the displayed character" SKIP(1)
	    "This character has not been assigned a sort position" SKIP(1)
	    SPACE(20) "character:" this-chr "decimal value:" i SKIP(1)
	    "If you want to add it to the end of the sort list, press GO"
	    "If you want it to be treated as equivalent to another character"
	    "then enter that character, or its 3-digit decimal value"
	WITH FRAME f4 CENTERED NO-LABELS.
    UPDATE equiv-chr WITH FRAME f4.

    /* nothing entered, use next available value */
    IF LENGTH(equiv-chr) = 0
    THEN DO:
	cs-weight[i] = next-weight.
	next-weight = next-weight + 1.

	/* put the lower case letter immediately after the uppercase letter */
	IF dntable[i] <> i
	THEN DO:
	    cs-weight[dntable[i]] = next-weight.
	    next-weight = next-weight + 1.
	END.

	NEXT.
    END.

    /* something was entered, use its sort weight */
    IF LENGTH(equiv-chr) = 1
    THEN chr-val = uptable[ASC(equiv-chr)].
    ELSE chr-val = INTEGER(equiv-chr).
    cs-weight[i] = cs-weight[chr-val].

    /* put the lower case letter immediately after the uppercase letter */
    IF dntable[i] <> i
    THEN cs-weight[dntable[i]] = cs-weight[dntable[chr-val]].
END.

/* ask about lower case letters which haven't yet been assigned */
DO i = 1 + ss-offset to 255:
    IF cs-weight[i] <> ?
    THEN NEXT.

    this-chr = CHR(i).
    equiv-chr = "".
    DISPLAY this-chr i
	WITH FRAME f4.
    UPDATE equiv-chr WITH FRAME f4.

    /* nothing entered, use next available value */
    IF LENGTH(equiv-chr) = 0
    THEN DO:
	cs-weight[i] = next-weight.
	next-weight = next-weight + 1.
	NEXT.
    END.

    /* something was entered, use its sort weight */
    IF LENGTH(equiv-chr) = 1
    THEN chr-val = ASC(equiv-chr).
    ELSE chr-val = INTEGER(equiv-chr).
    cs-weight[i] = cs-weight[chr-val].
END.

/* fill in all the low-end characters pushed out by the Sharp-S stuff */
DO i = 1 to ss-offset:
    cs-weight[i] = next-weight.
    next-weight = next-weight + 1.
END.

/* fill in the case-insensitive weights */
DO i = 1 to 255:
    cis-weight[i] = cs-weight[uptable[i]].
END.

/* insert the Sharp-S collation weight */
IF ssharp
THEN DO:
    cs-weight[ssharp-chr] = 0.
    cis-weight[ssharp-chr] = 0.
END.

/* check for overflow */
DO i = 1 to 255:
    IF cs-weight[i] > 255 OR cis-weight[i] > 255
    THEN DO:
	MESSAGE "FATAL ERROR: SORT WEIGHT IS GREATER THAN 255".
	LEAVE.
    END.
END.


DO ON ERROR UNDO, RETRY:
    OUTPUT STREAM outstrm CLOSE.
    OUTPUT STREAM outstrm TO newcoll.dat.
    PUT STREAM outstrm                                          SKIP(1).
    PUT STREAM outstrm UNFORMATTED
		       "# Collation tables for code page "
			codepage-name
		       " and collation " collate-name           SKIP.
    PUT STREAM outstrm "COLLATION"                              SKIP.
    PUT STREAM outstrm "CODEPAGE-NAME " codepage-name           SKIP.
    PUT STREAM outstrm "COLLATION-NAME " collate-name           SKIP.
    PUT STREAM outstrm "COLLATION-TRANSLATION-VERSION 1.0-16"   SKIP.
	    
    PUT STREAM outstrm "CASE-INSENSITIVE-SORT"                  SKIP.
    DO i = 0 to 240 by 16:
	PUT STREAM outstrm "  /*" i FORMAT "999" "-" i + 15 FORMAT "999" "*/  ".
	DO j = 0 to 15:
	    IF i + j = 0
	    THEN PUT STREAM outstrm "000 ".
	    ELSE PUT STREAM outstrm cis-weight[i + j] FORMAT "999 ".
	END.
	PUT STREAM outstrm SKIP.
    END.
    PUT STREAM outstrm "ENDTABLE"                               SKIP.
    PUT STREAM outstrm "CASE-SENSITIVE-SORT"                    SKIP.
    DO i = 0 to 240 by 16:
	PUT STREAM outstrm "  /*" i FORMAT "999" "-" i + 15 FORMAT "999" "*/  ".
	DO j = 0 to 15:
	    IF i + j = 0
	    THEN PUT STREAM outstrm "000 ".
	    ELSE PUT STREAM outstrm cs-weight[i + j] FORMAT "999 ".
	END.
	PUT STREAM outstrm SKIP.
    END.
    PUT STREAM outstrm "ENDTABLE"                               SKIP.
    PUT STREAM outstrm "ENDCOLLATION"                           SKIP.
    OUTPUT STREAM outstrm CLOSE.
END.
