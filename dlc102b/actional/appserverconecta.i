/*------------------------------------------------------------------------
    File        : appserverconecta.i
    Purpose     : Estandarizar las conexiones a las DB's y appserver's
    Author(s)   : FJMG 
    Created     : Tue Feb 03 13:40:14 CST 2015
    Notes       :
  ----------------------------------------------------------------------*/
/* ********************  Preprocessor Definitions  ******************** */
/*&Glob Todos        -1*/
&Glob asbcobrangm    1
&Glob asbemicolgm  	 2
&Glob asbdxngm       3
&Glob asbgralgm      4
&Glob asbconsatz1gm  5
&Glob asbredpresgm   6
&Glob asbvida        7
&Glob asbsigamegm    8
&Glob asbconsatzgm   9
&Scop ExtSize        10
/*&Scop DbMask         "*spd&1_*,*spt&1_*,*spe&1_*,*spp&1_*"
&Scop HomeBase       "/cxc/central/objetos"
&Scop addPropath     ",/conexion_db/ver114"*/
&Scop IdAppServe     "asbcobrangm,asbemicolgm,asbdxngm,asbgralgm,asbconsatz1gm,asbredpresgm,asbvida,asbsigamegm,asbconsatzgm"

/* ***************************  Definitions Globals ************************** */
DEFINE NEW GLOBAL SHARED VARIABLE vhndAppServer    AS HANDLE EXTENT {&ExtSize}.

FUNCTION Find-File      CHARACTER (inchrPathList AS CHARACTER, inchrInList    AS CHARACTER) FORWARD.
FUNCTION Get-FileName   CHARACTER (inchrDirName  AS CHARACTER, inchrFiltList  AS CHARACTER) FORWARD.
FUNCTION Valid-Dir      LOGICAL   (inchrDirName  AS CHARACTER) FORWARD.
FUNCTION Is-Matched     LOGICAL   (inchrToken    AS CHARACTER, inchrMatchList AS CHARACTER) FORWARD.

/* ***************************  Procedures  *************************** */  
/*      
PROCEDURE DBConnect:
    DEFINE INPUT  PARAMETER vchrDbId AS CHARACTER NO-UNDO.   
    DEFINE OUTPUT PARAMETER vlgConne AS LOGICAL   NO-UNDO.
    
    DEFINE VARIABLE vchrFileMask AS CHARACTER.
    DEFINE VARIABLE vchrFileList AS CHARACTER.
    DEFINE VARIABLE vchrPropath  AS CHARACTER INIT {&addPropath}.

    IF INDEX(PROPATH,vchrPropath) = 0 THEN PROPATH = PROPATH + vchrPropath.
    
    vchrPropath = PROPATH.

    IF OPSYS = "UNIX" THEN
        IF NOT CAN-DO(vchrPropath,{&HomeBase}) THEN vchrPropath = vchrPropath + "," + {&HomeBase}.
    ASSIGN
        vchrFileMask = SUBSTITUTE({&DbMask},vchrDbId)     
        vchrFileList = Find-File(vchrPropath,vchrFileMask)
        vlgConne     = TRUE.
                
    IF vchrFileList NE "" THEN 
    DO:
        RUN VALUE(vchrFileList) ("") NO-ERROR.
        vlgConne = ERROR-STATUS:ERROR.
    END.
    
END PROCEDURE.
*/
PROCEDURE pConnectAppServer:
    DEFINE INPUT  PARAMETER inintAppServer  AS INTEGER.
    DEFINE OUTPUT PARAMETER outlogConectado AS LOGICAL.

    DEFINE VARIABLE vchrNameServer AS CHARACTER NO-UNDO.
    DEFINE VARIABLE vchrConexion   AS CHARACTER NO-UNDO.
    
    ASSIGN outlogConectado = FALSE
           vchrNameServer  = ENTRY(inintAppServer,{&IdAppServe}) NO-ERROR.
    IF vchrNameServer NE "" THEN DO:
        RUN pFolio.p (vchrNameServer, OUTPUT vchrConexion).
        IF vchrConexion NE "" THEN DO:
            CREATE SERVER vhndAppServer[inintAppServer].
            outlogConectado = vhndAppServer[inintAppServer]:CONNECT(vchrConexion).
            IF NOT VALID-HANDLE(vhndAppServer[inintAppServer]) THEN
                outlogConectado = FALSE. 
        END.             
    END.  
END PROCEDURE.

PROCEDURE pDisConnectAppServer:
    DEFINE INPUT  PARAMETER vintIdx AS INTEGER NO-UNDO.
    
    DEFINE VARIABLE vintCuenta AS INTEGER NO-UNDO.
    DEFINE VARIABLE vintInicio AS INTEGER NO-UNDO.
    DEFINE VARIABLE vintFinal  AS INTEGER NO-UNDO.
    IF vintIdx <= 0 THEN 
        ASSIGN vintInicio = 1 
               vintFinal  = {&ExtSize}.
    ELSE
        ASSIGN vintInicio = vintIdx
               vintFinal  = vintIdx.
    
    DO vintCuenta = vintInicio TO vintFinal:
        IF VALID-HANDLE(vhndAppServer[vintCuenta]) THEN 
        DO:
            vhndAppServer[vintCuenta]:DISCONNECT() NO-ERROR.
            DELETE OBJECT vhndAppServer[vintCuenta] NO-ERROR.
        END.
    END.    
END PROCEDURE.    
/* ***************************  Functions   *************************** */
FUNCTION Find-File CHARACTER(inchrPathList AS CHARACTER,
    inchrInList   AS CHARACTER):
    DEFINE VARIABLE vintIdx     AS INTEGER.
    DEFINE VARIABLE vintKdx     AS INTEGER.
    DEFINE VARIABLE vintFound   AS INTEGER.
    DEFINE VARIABLE vchrItmList AS CHARACTER.
    DEFINE VARIABLE vchrOutList AS CHARACTER.
    DEFINE VARIABLE vchrDirName AS CHARACTER.
  
    Loop:
    DO vintIdx = NUM-ENTRIES(inchrPathList) TO 1 BY -1:
        vchrDirName = ENTRY(vintIdx,inchrPathList).
        IF vchrOutList = "" THEN 
        DO:
            ASSIGN 
                vchrOutList = Get-FileName(vchrDirName,inchrInList).
            IF vchrOutList NE "" THEN vintFound = vintFound + 1.
        END.

        IF vintFound = NUM-ENTRIES(inchrInList) THEN LEAVE Loop.
    END.
 
    RETURN vchrOutList.
END.

FUNCTION Get-FileName CHARACTER(inchrDirName  AS CHARACTER,
    inchrFiltList AS CHARACTER):
    DEFINE VARIABLE vchrFileName AS CHARACTER.
    DEFINE VARIABLE vchrFullName AS CHARACTER.
    DEFINE VARIABLE vchrFileType AS CHARACTER.
    DEFINE VARIABLE vchrFindFile AS CHARACTER.

    IF Valid-Dir(inchrDirName) THEN 
    DO:
        INPUT FROM OS-DIR(inchrDirName).
        Loop:
        REPEAT:
            IMPORT vchrFileName vchrFullName vchrFileType.
            IF TRIM(vchrFileName,".") NE "" THEN 
            DO:
                IF vchrFileType = "F" THEN 
                DO:
                    IF Is-Matched(vchrFileName,inchrFiltList) THEN 
                    DO:
                        vchrFindFile = vchrFullName.
      
                        LEAVE Loop.
                    END.
                END. /*IF vchrFileType = "F"*/
            END. /*IF TRIM(vchrFileName,".")*/        
        END.
        INPUT Close.
    END.

    RETURN vchrFindFile.
END.


FUNCTION Valid-Dir LOG(inchrDirName AS CHARACTER):
    DEFINE VARIABLE vlogValidDir AS LOG.

    ASSIGN 
        FILE-INFO:FILE-NAME = inchrDirName.
    vlogValidDir        = (FILE-INFO:FILE-TYPE BEGINS "D").

    RETURN vlogValidDir.
END.

FUNCTION Is-Matched LOG
    (inchrToken     AS CHARACTER,
    inchrMatchList AS CHARACTER):

    DEFINE VARIABLE vlogMatches AS LOG     INIT YES.
    DEFINE VARIABLE vintIdx     AS INTEGER.
 
    inchrMatchList = REPLACE(inchrMatchList,".","~~.").

    Loop:
    DO vintIdx = 1 TO NUM-ENTRIES(inchrMatchList):
        vlogMatches = (inchrToken MATCHES Entry(vintIdx,inchrMatchList)).

        IF vlogMatches THEN LEAVE Loop.
    END.

    RETURN vlogMatches.
END.
FUNCTION String-Connect CHARACTER(inintAppServer AS INTEGER):
    DEFINE VARIABLE vchrConexion   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE vchrNameServer AS CHARACTER NO-UNDO.
    vchrNameServer  = ENTRY(inintAppServer,{&IdAppServe}).
    
    RUN pFolio.p (vchrNameServer, OUTPUT vchrConexion).
        
    RETURN vchrConexion.
END.