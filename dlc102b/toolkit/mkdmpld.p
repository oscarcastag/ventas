/*********************************************************************/
/* mkdmpld.p - Program to create  file dump and a file load program  */
/* This program creates and compiles 2 PROGRESS programs:            */
/*   filedump.p - dumps all data from all user files                 */
/*   fileload.p - reload all dumped data                             */
/*********************************************************************/

DEFINE VARIABLE outstr  AS CHARACTER FORMAT "x(75)".
DEFINE VARIABLE prefx   AS CHARACTER FORMAT "x(2)"  INITIAL "./" .

DEFINE STREAM p.

/* write the programs to dump each of the user files */
IF OPSYS = "UNIX" THEN
    UNIX SILENT "mkdir dmpprocs ldprocs >/dev/null 2>&1".
ELSE IF OPSYS = "MSDOS" THEN DO:
    prefx = "".
    dos mkdir dmpprocs.
    dos mkdir ldprocs.
END.
ELSE
IF OPSYS = "WIN32" THEN DO:
  prefx = "".
  OS-CREATE-DIR dmpprocs.
  OS-CREATE-DIR ldprocs.
END.
ELSE DO:
    MESSAGE "{0}  doesn't support this operating system (" opsys ")".
    BELL.
    RETURN.
END.
FOR EACH _File WHERE _File._File-number > 0
                 AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN"):
 
    OUTPUT STREAM p TO VALUE("dmpprocs/" + _file._dump-name + ".p").
    
    DISPLAY STREAM p
      SKIP(1) "/* dump code for file" _File._File-name "*/"
      SKIP    "OUTPUT TO """ + _File._Dump-name + ".d""." FORMAT "x(50)"
      SKIP    "FOR EACH " _File._File-name + ":"   FORMAT "x(45)"
      SKIP  "    EXPORT"
      WITH FRAME f1 STREAM-IO NO-BOX NO-LABELS.
    outstr = "          ".
    
    FOR EACH _Field OF _File BY _Field._order:
	outstr = "        " + _File._File-name + "." + _Field._Field-name.
	DISPLAY STREAM p SKIP  outstr WITH NO-BOX NO-LABELS FRAME f2 STREAM-IO.
    END.
    
    DISPLAY STREAM p  "        ." FORMAT "x(76)"
      SKIP "END." SKIP WITH NO-BOX NO-LABELS FRAME f3 STREAM-IO.
    OUTPUT STREAM p CLOSE.    
    COMPILE VALUE(prefx + "dmpprocs/" + _file._dump-name + ".p") SAVE. 
END.

/* write the dump controller program */
OUTPUT STREAM p TO filedump.p.
FOR EACH _File WHERE _File._File-number > 0
                 AND (_File._Owner = "PUB" OR _File._Owner = "FOREIGN"):
  DISPLAY STREAM p
    "RUN dmpprocs/" + _File._dump-name + ".p" + "." FORMAT "x(50)"
       WITH FRAME f4 STREAM-IO.
END.
OUTPUT STREAM p CLOSE.
COMPILE VALUE(prefx + "filedump.p") SAVE.


/* write the program to reload each of the user files */
FOR EACH _File WHERE _File._File-number > 0
                 AND (_File._Owner = "PUB" OR _File._Owner = "FOREIGN"):
  OUTPUT STREAM p TO VALUE("ldprocs/" + _file._dump-name + ".p").
    
  DISPLAY stream p
    "DEFINE VARIABLE ctr AS INTEGER." WITH NO-BOX NO-LABELS FRAME f5 STREAM-IO.
  DISPLAY STREAM p
    SKIP(1) "/* Reload Code for File" _File._File-name "*/"
    SKIP    "INPUT FROM """ + _File._Dump-name + ".d"" NO-ECHO." FORMAT "x(50)"
    SKIP    "LOOP:"
    SKIP    "REPEAT TRANSACTION:"
    SKIP    SPACE(4) "ctr = 0."
    SKIP    SPACE(4) "REPEAT WHILE ctr < 100 ON ENDKEY UNDO, LEAVE LOOP"
		     "WITH WIDTH 255 NO-BOX:"
    SKIP    SPACE(8) "CREATE" _File._File-name + "." FORMAT "x(45)"
    SKIP    SPACE(8) "IMPORT"
       WITH NO-BOX NO-LABELS FRAME f7 STREAM-IO.
       
    FOR EACH _Field OF _File BY _Field._Order:
      outstr = "        " + _File._File-name + "." + _Field._Field-name.
      DISPLAY STREAM p SKIP outstr WITH NO-BOX NO-LABELS FRAME f8 STREAM-IO.
    END.
    DISPLAY STREAM p SKIP SPACE (10) " ."
    SKIP SPACE(8) "ctr = ctr + 1."
    SKIP SPACE(4) "END."
    SKIP          "END."
       WITH NO-BOX NO-LABELS FRAME f9 STREAM-IO.
    OUTPUT STREAM p CLOSE.
        
    COMPILE VALUE(prefx + "ldprocs/" + _File._Dump-name + ".p") SAVE.
    
END.

/* write the load controller program */
OUTPUT STREAM p TO fileload.p.

FOR EACH _File WHERE _File._File-number > 0
                  AND (_File._Owner = "PUB" OR _File._Owner = "FOREIGN"):
  DISPLAY STREAM p
    "RUN ldprocs/" + _File._Dump-name + ".p" + "." FORMAT "x(50)"
        WITH FRAME f10 STREAM-IO.
END.
OUTPUT STREAM p CLOSE.
COMPILE VALUE(prefx + "fileload.p") SAVE.
