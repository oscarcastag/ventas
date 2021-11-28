/* Function that returns the code page name used by MIME and defined by
    IANA, give a Progress code page name 
    
    input Progress code page name
    returns MIME code page name
    
    error:
    if there is no MIME code page for the given Progress code page
    then returns an empty string, i.e. "" 
    
    The code page list is accurate as of 2001/Feb/07.
    
    EXAMPLE:
    display the MIME code page name for -cpinternal code page:
    
    display Get-MIME-CodePage(session:cpinternal).
    
    The MIME code page name is what you would use in HTTP CHARSET,
    or in an HTML META statement to define the code page of your HTML
    file.
    For example:
    <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1252">
    
    The MIME code page can be used in the 4GL function output-http-header
    as in this example:
    
      DEF VAR mimecp as CHAR.
      mimecp = Get-MIME-CodePage(session:cpinternal).
      
      if mimecp <> "" then
         output-http-header("Content-Type":U, "text/html;charset=":U + mimecp).
      else
         output-http-header("Content-Type":U, "text/html":U).

*/

    
FUNCTION Get-MIME-CodePage RETURNS CHARACTER (INPUT progress-CodePage AS CHARACTER).

def var pro-cplist as char init
"1250,1251,1252,1253,1254,1255,1256,1257,1258,620-2533,BIG-5,EUCJIS,GB2312,IBM037,IBM273,IBM277,IBM278,IBM284,IBM297,IBM437,IBM500,IBM850,IBM851,IBM852,IBM857,IBM858,IBM861,IBM862,IBM866,ISO8859-1,ISO8859-10,ISO8859-15,ISO8859-2,ISO8859-3,ISO8859-4,ISO8859-5,ISO8859-6,ISO8859-7,ISO8859-8,ISO8859-9,KOI8-R,KSC5601,ROMAN-8,SHIFT-JIS,UCS2,UTF-8" .

def var MIME-cplist as char init
"windows-1250,windows-1251,windows-1252,windows-1253,windows-1254,windows-1255,windows-1256,windows-1257,windows-1258,TIS-620,Big5,EUC-JP,GB_2312-80,IBM037,IBM273,IBM277,IBM278,IBM284,IBM297,IBM437,IBM500,IBM850,IBM851,IBM852,IBM857,IBM00858,IBM861,IBM862,IBM866,ISO-8859-1,ISO-8859-10,ISO-8859-15,ISO-8859-2,ISO-8859-3,ISO-8859-4,ISO-8859-5,ISO-8859-6,ISO-8859-7,ISO-8859-8,ISO-8859-9,KOI8-R,KS_C_5601-1987,hp-roman8,Shift_JIS,UTF-16,UTF-8".

DEF VAR i AS INT.
i = LOOKUP(progress-CodePage,pro-cplist).
IF i = 0 THEN RETURN "".
ELSE RETURN ENTRY(i,MIME-cplist).
END FUNCTION.


/* the following code tests the function for every value
and also an illegal value */

DEF VAR i AS INT format ">>9" label "Entry".
def var pro-cplist as char init
"1250,1251,1252,1253,1254,1255,1256,1257,1258,620-2533,BIG-5,EUCJIS,GB2312,IBM037,IBM273,IBM277,IBM278,IBM284,IBM297,IBM437,IBM500,IBM850,IBM851,IBM852,IBM857,IBM858,IBM861,IBM862,IBM866,ISO8859-1,ISO8859-10,ISO8859-15,ISO8859-2,ISO8859-3,ISO8859-4,ISO8859-5,ISO8859-6,ISO8859-7,ISO8859-8,ISO8859-9,KOI8-R,KSC5601,ROMAN-8,SHIFT-JIS,UCS2,UTF-8" .

DISPLAY session:CPINTERNAL Get-MIME-CodePage(SESSION:CPINTERNAL) FORMAT "x(40)" SKIP.
DISPLAY "Tesing bad CP returns null:" Get-MIME-CodePage("bad") FORMAT "x(40)".

DO  I = 1 TO NUM-ENTRIES(pro-cplist) WITH DOWN FRAME f-test title "Test them all!":
    DISPLAY i 
        ENTRY(i, pro-cplist) FORMAT "X(20)" LABEL "Progress CP"
        Get-MIME-CodePage(ENTRY(i, pro-cplist)) FORMAT "X(20)" LABEL "MIME CP".
END.
