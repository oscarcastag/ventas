{addlog.i}/*Prints error log message*/
{pbridgeappserverconecta9.i}/*connecting and disconnecting appserver*/
{ittcrecibocob-definition.i tt-ttcrecibocob}/*Defines tt-ttcrecibocob like database table interesis.ttcrecibocob.*/ 

/*--------------------------------------------------------------------------------------------------------
File         : pbridgefillttcrecibocob_correvalidacion_10.p
Purpose      : Called from correvalidacion.p
Syntax       :
Description  : 
Author(s)    : Tanya Saxena,Sanghamitra Mandal
Created By   : Tanya Saxena,Sanghamitra Mandal
Created Date : 03/16/2016
Modified by  :  
Modified Date: 
Modification : 15039
               1.Included {pbridgeappserverconecta9.i} for connecting and disconnecting appserver.
               2.Included {ittcrecibocob-definition.i} for the definition of
                 tt-ttcrecibocob same as database table interesis.ttcrecibocob.
               3.Creation of bridge pbridgefillttcrecibocob_correvalidacion_11.p for table ttcrecibocob.  
               4.Included {addlog.i} to print error log message.
Notes        :  
--------------------------------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER ichrpoliza     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER ichrconnection AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-ttcrecibocob.

DEFINE VARIABLE vlogConecto AS LOGICAL NO-UNDO.

RUN pConnectAppServer(INPUT {&ASBGMM2000},
                      INPUT ichrconnection,
                      OUTPUT vlogConecto).   /*connecta appserver*/
IF vlogConecto THEN
DO:
    RUN pbridgefillttcrecibocob_correvalidacion_11.p ON SERVER vhndAppServer [{&ASBGMM2000}]TRANSACTION DISTINCT(INPUT ichrpoliza,
                                                                                                                 OUTPUT TABLE tt-ttcrecibocob)NO-ERROR.

    IF ERROR-STATUS:ERROR THEN   
       RUN addLog( ERROR-STATUS:GET-MESSAGE(1) + " : pbridgefillttcrecibocob_correvalidacion_11.p : " + ENTRY({&ASBGMM2000},{&IDAPPSERVE})) .
    RUN pDisConnectAppServer(INPUT {&ASBGMM2000}).  /*desconecta un appserver*/
END.
ELSE
DO:
     RUN addLog(" No se pudo conectar al servidor de " + " : pbridgefillttcrecibocob_correvalidacion_11.p: " +  ENTRY({&ASBGMM2000},{&IDAPPSERVE})).                                            
     RETURN.
END.



