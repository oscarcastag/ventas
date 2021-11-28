{iedpoliza-definition.i tt-edpoliza}
/*------------------------------------------------------------------------
    File            : pbridgefilledpoliza_stpoliza1_10.p
    Purpose         : Called from stpoliza1.p
    Syntax          :
    Description     : 
    Author(s)       : 
    Created By      : Rahul Mitra.
    Created Date    : 11/27/2015
    Modified By     : Sourav Das, Sanghamitra Mondal.
    Modified Date   : 02/01/2016
    Modification    : 15039
                       1.Included {addlog.i} to display error log message.
                       2.Included {pbridgeappserverconecta9.i} for connecting and disconnecting appserver.
                       3.Included {iedpoliza-definition.i tt-edpoliza} for the definition of tt-edpoliza same as database table endosos.edpoliza.
                       4.Creation of bridge pbridgefilledpoliza_stpoliza1_11.p for table endosos.edpoliza. 
    Notes           :                    
-------------------------------------------------------------------------*/
{addlog.i}
{pbridgeappserverconecta9.i}

DEFINE INPUT  PARAMETER ichrconnection      AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER ichrcveramodivision AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER iintnumpoliza       AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER iintnumrenovacion   AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-edpoliza.

DEFINE VARIABLE vlogConecto AS LOGICAL NO-UNDO.

RUN pConnectAppServer(INPUT {&ASBGMM2000},
                      INPUT ichrconnection,
                      OUTPUT vlogConecto).   /*connecta appserver*/
IF vlogConecto THEN
DO:
    RUN pbridgefilledpoliza_stpoliza1_11.p ON SERVER vhndAppServer [{&ASBGMM2000}] TRANSACTION DISTINCT (INPUT ichrcveramodivision,
                                                                                                         INPUT iintnumpoliza,
                                                                                                         INPUT iintnumrenovacion,
                                                                                                         OUTPUT TABLE tt-edpoliza)NO-ERROR.
    IF ERROR-STATUS:ERROR THEN                                                                                                   
        RUN addLog( ERROR-STATUS:GET-MESSAGE(1) + " : pbridgefilledpoliza_stpoliza1_10.p : " + ENTRY({&ASBGMM2000},{&IDAPPSERVE})).                                                                                                          
                                                                                        
    RUN pDisConnectAppServer(INPUT {&ASBGMM2000}).  /*desconecta un appserver*/
END.
ELSE
DO:
    RUN addLog("No se pudo conectar al servidor de "  + " : pbridgefilledpoliza_stpoliza1_10.p : " +  ENTRY({&ASBGMM2000},{&IDAPPSERVE})).
    RETURN.
END.
