	��V�ʂRx5  8��C              �                                 �� 357800EBundefined MAIN /vobs_possenet/src/adm2/dyndata.w,, PROCEDURE initializeObject,, PROCEDURE disable_UI,, PROCEDURE destroyObject,, PROCEDURE start-super-proc,,INPUT pcProcName CHARACTER PROCEDURE viewObject,, PROCEDURE toggleData,,INPUT plEnabled LOGICAL PROCEDURE showMessageProcedure,,INPUT pcMessage CHARACTER,OUTPUT plAnswer LOGICAL PROCEDURE returnFocus,,INPUT hTarget HANDLE PROCEDURE repositionObject,,INPUT pdRow DECIMAL,INPUT pdCol DECIMAL PROCEDURE removeLink,,INPUT phSource HANDLE,INPUT pcLink CHARACTER,INPUT phTarget HANDLE PROCEDURE removeAllLinks,, PROCEDURE modifyUserLinks,,INPUT pcMod CHARACTER,INPUT pcLinkName CHARACTER,INPUT phObject HANDLE PROCEDURE modifyListProperty,,INPUT phCaller HANDLE,INPUT pcMode CHARACTER,INPUT pcListName CHARACTER,INPUT pcListValue CHARACTER PROCEDURE hideObject,, PROCEDURE exitObject,, PROCEDURE editInstanceProperties,, PROCEDURE displayLinks,, PROCEDURE createControls,, PROCEDURE changeCursor,,INPUT pcCursor CHARACTER PROCEDURE applyEntry,,INPUT pcField CHARACTER PROCEDURE adjustTabOrder,,INPUT phObject HANDLE,INPUT phAnchor HANDLE,INPUT pcPosition CHARACTER PROCEDURE addMessage,,INPUT pcText CHARACTER,INPUT pcField CHARACTER,INPUT pcTable CHARACTER PROCEDURE addLink,,INPUT phSource HANDLE,INPUT pcLink CHARACTER,INPUT phTarget HANDLE PROCEDURE unbindServer,,INPUT pcMode CHARACTER PROCEDURE runServerObject,,INPUT phAppService HANDLE PROCEDURE disconnectObject,, PROCEDURE bindServer,, PROCEDURE transferDBRow,,INPUT pcRowIdent CHARACTER,INPUT piRowNum INTEGER PROCEDURE startFilter,, PROCEDURE releaseDBRow,, PROCEDURE refetchDBRow,,INPUT phRowObjUpd HANDLE PROCEDURE filterContainerHandler,,INPUT phFilterContainer HANDLE PROCEDURE fetchDBRowForUpdate,, PROCEDURE confirmContinue,,INPUT-OUTPUT pioCancel LOGICAL PROCEDURE compareDBRow,, PROCEDURE bufferCopyDBToRO,,INPUT phRowObj HANDLE,INPUT phBuffer HANDLE,INPUT pcExcludes CHARACTER,INPUT pcAssigns CHARACTER PROCEDURE assignDBRow,,INPUT phRowObjUpd HANDLE PROCEDURE updateState,,INPUT pcState CHARACTER PROCEDURE updateQueryPosition,, PROCEDURE updateAddQueryWhere,,INPUT pcWhere CHARACTER,INPUT pcField CHARACTER PROCEDURE undoTransaction,, PROCEDURE transferToExcel,,INPUT pcFieldList CHARACTER,INPUT plIncludeObj LOGICAL,INPUT plUseExisting LOGICAL,INPUT piMaxRecords INTEGER PROCEDURE synchronizeProperties,,INPUT pcPropertiesForServer CHARACTER,OUTPUT pcPropertiesForClient CHARACTER PROCEDURE submitValidation,,INPUT pcValueList CHARACTER,INPUT pcUpdColumns CHARACTER PROCEDURE submitForeignKey,,INPUT pcRowIdent CHARACTER,INPUT-OUTPUT pcValueList CHARACTER,INPUT-OUTPUT pcUpdColumns CHARACTER PROCEDURE submitCommit,,INPUT pcRowIdent CHARACTER,INPUT plReopen LOGICAL PROCEDURE startServerObject,, PROCEDURE setPropertyList,,INPUT pcProperties CHARACTER PROCEDURE serverFetchRowObjUpdTable,,OUTPUT phRowObjUpd TABLE-HANDLE PROCEDURE serverSendRows,,INPUT piStartRow INTEGER,INPUT pcRowIdent CHARACTER,INPUT plNext LOGICAL,INPUT piRowsToReturn INTEGER,OUTPUT piRowsReturned INTEGER,OUTPUT phRowObject TABLE-HANDLE PROCEDURE serverCommit,,INPUT-OUTPUT phRowObjUpd TABLE-HANDLE,OUTPUT pcMessages CHARACTER,OUTPUT pcUndoIds CHARACTER PROCEDURE saveContextAndDestroy,,OUTPUT pcContext CHARACTER PROCEDURE rowObjectState,,INPUT pcState CHARACTER PROCEDURE retrieveFilter,, PROCEDURE restartServerObject,, PROCEDURE remoteSendRows,,INPUT-OUTPUT piocContext CHARACTER,INPUT piStartRow INTEGER,INPUT pcRowIdent CHARACTER,INPUT plNext LOGICAL,INPUT piRowsToReturn INTEGER,OUTPUT pioRowsReturned INTEGER,OUTPUT phRowObject TABLE-HANDLE,OUTPUT pocMessages CHARACTER PROCEDURE remoteCommit,,INPUT-OUTPUT pcContext CHARACTER,INPUT-OUTPUT phRowObjUpd TABLE-HANDLE,OUTPUT pcMessages CHARACTER,OUTPUT pcUndoIds CHARACTER PROCEDURE refreshRow,, PROCEDURE printToCrystal,,INPUT pcFieldList CHARACTER,INPUT plIncludeObj LOGICAL,INPUT piMaxRecords INTEGER PROCEDURE isUpdatePending,,INPUT-OUTPUT plUpdate LOGICAL PROCEDURE initializeServerObject,, PROCEDURE home,, PROCEDURE genContextList,,OUTPUT pcContext CHARACTER PROCEDURE fetchPrev,, PROCEDURE fetchNext,, PROCEDURE fetchLast,, PROCEDURE fetchFirst,, PROCEDURE fetchBatch,,INPUT plForwards LOGICAL PROCEDURE endClientDataRequest,, PROCEDURE destroyServerObject,, PROCEDURE describeSchema,,INPUT pcSdoName CHARACTER,OUTPUT hTtSchema TABLE-HANDLE PROCEDURE dataAvailable,,INPUT pcRelative CHARACTER PROCEDURE copyColumns,,INPUT pcViewColList CHARACTER,INPUT phDataQuery HANDLE PROCEDURE commitTransaction,, PROCEDURE clientSendRows,,INPUT piStartRow INTEGER,INPUT pcRowIdent CHARACTER,INPUT plNext LOGICAL,INPUT piRowsToReturn INTEGER,OUTPUT piRowsReturned INTEGER PROCEDURE batchServices,,INPUT pcServices CHARACTER,OUTPUT pcValues CHARACTER FUNCTION Signature,CHARACTER,INPUT pcName CHARACTER FUNCTION showmessage,LOGICAL,INPUT pcMessage CHARACTER FUNCTION setUserProperty,LOGICAL,INPUT pcPropName CHARACTER,INPUT pcPropValue CHARACTER FUNCTION setUIBMode,LOGICAL,INPUT pcMode CHARACTER FUNCTION setTranslatableProperties,LOGICAL,INPUT pcPropList CHARACTER FUNCTION setSupportedLinks,LOGICAL,INPUT pcLinkList CHARACTER FUNCTION setRunAttribute,LOGICAL,INPUT cRunAttribute CHARACTER FUNCTION setPhysicalVersion,LOGICAL,INPUT cVersion CHARACTER FUNCTION setPhysicalObjectName,LOGICAL,INPUT cTemp CHARACTER FUNCTION setPassThroughLinks,LOGICAL,INPUT pcLinks CHARACTER FUNCTION setParentDataKey,LOGICAL,INPUT cParentDataKey CHARACTER FUNCTION setObjectVersion,LOGICAL,INPUT cObjectVersion CHARACTER FUNCTION setObjectParent,LOGICAL,INPUT phParent HANDLE FUNCTION setObjectName,LOGICAL,INPUT pcName CHARACTER FUNCTION setLogicalVersion,LOGICAL,INPUT cVersion CHARACTER FUNCTION setLogicalObjectName,LOGICAL,INPUT c CHARACTER FUNCTION setInstanceProperties,LOGICAL,INPUT pcPropList CHARACTER FUNCTION setDynamicObject,LOGICAL,INPUT lTemp LOGICAL FUNCTION setDesignDataObject,LOGICAL,INPUT pcDataObject CHARACTER FUNCTION setDBAware,LOGICAL,INPUT lAware LOGICAL FUNCTION setDataTargetEvents,LOGICAL,INPUT pcEvents CHARACTER FUNCTION setDataTarget,LOGICAL,INPUT pcTarget CHARACTER FUNCTION setDataSourceNames,LOGICAL,INPUT pcSourceNames CHARACTER FUNCTION setDataSourceEvents,LOGICAL,INPUT pcEventsList CHARACTER FUNCTION setDataSource,LOGICAL,INPUT phObject HANDLE FUNCTION setDataLinksEnabled,LOGICAL,INPUT lDataLinksEnabled LOGICAL FUNCTION setContainerSourceEvents,LOGICAL,INPUT pcEvents CHARACTER FUNCTION setContainerSource,LOGICAL,INPUT phObject HANDLE FUNCTION setContainerHidden,LOGICAL,INPUT plHidden LOGICAL FUNCTION setChildDataKey,LOGICAL,INPUT cChildDataKey CHARACTER FUNCTION reviewMessages,CHARACTER, FUNCTION propertyType,CHARACTER,INPUT pcPropName CHARACTER FUNCTION messageNumber,CHARACTER,INPUT piMessage INTEGER FUNCTION mappedEntry,CHARACTER,INPUT pcEntry CHARACTER,INPUT pcList CHARACTER,INPUT plFirst LOGICAL,INPUT pcDelimiter CHARACTER FUNCTION linkProperty,CHARACTER,INPUT pcLink CHARACTER,INPUT pcPropName CHARACTER FUNCTION linkHandles,CHARACTER,INPUT pcLink CHARACTER FUNCTION instancePropertyList,CHARACTER,INPUT pcPropList CHARACTER FUNCTION getUserProperty,CHARACTER,INPUT pcPropName CHARACTER FUNCTION getUIBMode,CHARACTER, FUNCTION getTranslatableProperties,CHARACTER, FUNCTION getSupportedLinks,CHARACTER, FUNCTION getRunAttribute,CHARACTER, FUNCTION getQueryObject,LOGICAL, FUNCTION getPropertyDialog,CHARACTER, FUNCTION getPhysicalVersion,CHARACTER, FUNCTION getPhysicalObjectName,CHARACTER, FUNCTION getPassThroughLinks,CHARACTER, FUNCTION getParentDataKey,CHARACTER, FUNCTION getObjectVersionNumber,CHARACTER, FUNCTION getObjectVersion,CHARACTER, FUNCTION getObjectParent,HANDLE, FUNCTION getObjectPage,INTEGER, FUNCTION getObjectName,CHARACTER, FUNCTION getObjectInitialized,LOGICAL, FUNCTION getObjectHidden,LOGICAL, FUNCTION getLogicalVersion,CHARACTER, FUNCTION getLogicalObjectName,CHARACTER, FUNCTION getInstanceProperties,CHARACTER, FUNCTION getDynamicObject,LOGICAL, FUNCTION getDesignDataObject,CHARACTER, FUNCTION getDBAware,LOGICAL, FUNCTION getDataTargetEvents,CHARACTER, FUNCTION getDataTarget,CHARACTER, FUNCTION getDataSourceNames,CHARACTER, FUNCTION getDataSourceEvents,CHARACTER, FUNCTION getDataSource,HANDLE, FUNCTION getDataLinksEnabled,LOGICAL, FUNCTION getContainerType,CHARACTER, FUNCTION getContainerSourceEvents,CHARACTER, FUNCTION getContainerSource,HANDLE, FUNCTION getContainerHidden,LOGICAL, FUNCTION getContainerHandle,HANDLE, FUNCTION getChildDataKey,CHARACTER, FUNCTION fetchMessages,CHARACTER, FUNCTION assignLinkProperty,LOGICAL,INPUT pcLink CHARACTER,INPUT pcPropName CHARACTER,INPUT pcPropValue CHARACTER FUNCTION anyMessage,LOGICAL, FUNCTION setServerOperatingMode,LOGICAL,INPUT pcServerOperatingMode CHARACTER FUNCTION setServerFileName,LOGICAL,INPUT pcFileName CHARACTER FUNCTION setASUsePrompt,LOGICAL,INPUT plFlag LOGICAL FUNCTION setASInitializeOnRun,LOGICAL,INPUT plInitialize LOGICAL FUNCTION setASInfo,LOGICAL,INPUT pcInfo CHARACTER FUNCTION setASHandle,LOGICAL,INPUT phASHandle HANDLE FUNCTION setASDivision,LOGICAL,INPUT pcDivision CHARACTER FUNCTION setAppService,LOGICAL,INPUT pcAppService CHARACTER FUNCTION runServerProcedure,HANDLE,INPUT pcServerFileName CHARACTER,INPUT phAppService HANDLE FUNCTION getServerOperatingMode,CHARACTER, FUNCTION getServerFileName,CHARACTER, FUNCTION getASUsePrompt,LOGICAL, FUNCTION getASInitializeOnRun,LOGICAL, FUNCTION getASInfo,CHARACTER, FUNCTION getASHasStarted,LOGICAL, FUNCTION getASHandle,HANDLE, FUNCTION getAsDivision,CHARACTER, FUNCTION getASBound,LOGICAL, FUNCTION getAppService,CHARACTER, FUNCTION whereClauseBuffer,CHARACTER,INPUT pcWhere CHARACTER FUNCTION setQueryWhere,LOGICAL,INPUT pcWhere CHARACTER FUNCTION setQueryString,LOGICAL,INPUT pcQueryString CHARACTER FUNCTION setQuerySort,LOGICAL,INPUT pcSort CHARACTER FUNCTION setQueryPosition,LOGICAL,INPUT pcPosition CHARACTER FUNCTION rowidWhereCols,CHARACTER,INPUT pcColumns CHARACTER,INPUT pcValues CHARACTER,INPUT pcOperators CHARACTER FUNCTION rowidWhere,CHARACTER,INPUT pcWhere CHARACTER FUNCTION resolveBuffer,CHARACTER,INPUT pcBuffer CHARACTER FUNCTION removeQuerySelection,LOGICAL,INPUT pcColumns CHARACTER,INPUT pcOperators CHARACTER FUNCTION removeForeignKey,LOGICAL, FUNCTION refreshRowident,CHARACTER,INPUT pcRowident CHARACTER FUNCTION newWhereClause,CHARACTER,INPUT pcBuffer CHARACTER,INPUT pcExpression CHARACTER,INPUT pcWhere CHARACTER,INPUT pcAndOr CHARACTER FUNCTION newQueryWhere,CHARACTER,INPUT pcWhere CHARACTER FUNCTION newQueryValidate,CHARACTER,INPUT pcQueryString CHARACTER,INPUT pcExpression CHARACTER,INPUT pcBuffer CHARACTER,INPUT pcAndOr CHARACTER FUNCTION newQueryString,CHARACTER,INPUT pcColumns CHARACTER,INPUT pcValues CHARACTER,INPUT pcOperators CHARACTER,INPUT pcQueryString CHARACTER,INPUT pcAndOr CHARACTER FUNCTION insertExpression,CHARACTER,INPUT pcWhere CHARACTER,INPUT pcExpression CHARACTER,INPUT pcAndOr CHARACTER FUNCTION indexInformation,CHARACTER,INPUT pcQuery CHARACTER,INPUT plUseTableSep LOGICAL,INPUT pcIndexInfo CHARACTER FUNCTION getTargetProcedure,HANDLE, FUNCTION getQueryWhere,CHARACTER, FUNCTION getQueryString,CHARACTER, FUNCTION getQuerySort,CHARACTER, FUNCTION getQueryPosition,CHARACTER, FUNCTION getForeignValues,CHARACTER, FUNCTION getDataColumns,CHARACTER, FUNCTION excludeColumns,CHARACTER,INPUT iTable INTEGER FUNCTION dbColumnHandle,HANDLE,INPUT pcColumn CHARACTER FUNCTION dbColumnDataName,CHARACTER,INPUT pcDbColumn CHARACTER FUNCTION columnValMsg,CHARACTER,INPUT pcColumn CHARACTER FUNCTION columnTable,CHARACTER,INPUT pcColumn CHARACTER FUNCTION columnQuerySelection,CHARACTER,INPUT pcColumn CHARACTER FUNCTION columnDbColumn,CHARACTER,INPUT pcColumn CHARACTER FUNCTION columnDataType,CHARACTER,INPUT pcColumn CHARACTER FUNCTION bufferWhereClause,CHARACTER,INPUT pcBuffer CHARACTER,INPUT pcWhere CHARACTER FUNCTION bufferCompareDBToRO,LOGICAL,INPUT phRowObjUpd HANDLE,INPUT phBuffer HANDLE,INPUT pcExcludes CHARACTER,INPUT pcAssigns CHARACTER FUNCTION assignQuerySelection,LOGICAL,INPUT pcColumns CHARACTER,INPUT pcValues CHARACTER,INPUT pcOperators CHARACTER FUNCTION addQueryWhere,LOGICAL,INPUT pcWhere CHARACTER,INPUT pcBuffer CHARACTER,INPUT pcAndOr CHARACTER FUNCTION getObjectType,character, FUNCTION updateRow,LOGICAL,INPUT pcKeyValues CHARACTER,INPUT pcValueList CHARACTER FUNCTION submitRow,LOGICAL,INPUT pcRowIdent CHARACTER,INPUT pcValueList CHARACTER FUNCTION rowValues,CHARACTER,INPUT pcColumns CHARACTER,INPUT pcFormat CHARACTER,INPUT pcDelimiter CHARACTER FUNCTION rowAvailable,LOGICAL,INPUT pcDirection CHARACTER FUNCTION prepareQuery,LOGICAL,INPUT pcQuery CHARACTER FUNCTION openQuery,LOGICAL, FUNCTION openDataQuery,LOGICAL,INPUT pcPosition CHARACTER FUNCTION hasForeignKeyChanged,LOGICAL, FUNCTION getLastCommitErrorType,CHARACTER, FUNCTION firstRowIds,CHARACTER,INPUT pcQueryString CHARACTER FUNCTION findRowWhere,LOGICAL,INPUT pcColumns CHARACTER,INPUT pcValues CHARACTER,INPUT pcOperators CHARACTER FUNCTION findRow,LOGICAL,INPUT pcKeyValues CHARACTER FUNCTION fetchRowIdent,CHARACTER,INPUT pcRowIdent CHARACTER,INPUT pcViewColList CHARACTER FUNCTION fetchRow,CHARACTER,INPUT piRow INTEGER,INPUT pcViewColList CHARACTER FUNCTION deleteRow,LOGICAL,INPUT pcRowIdent CHARACTER FUNCTION createRow,LOGICAL,INPUT pcValueList CHARACTER FUNCTION copyRow,CHARACTER,INPUT pcViewColList CHARACTER FUNCTION colValues,CHARACTER,INPUT pcViewColList CHARACTER FUNCTION columnProps,CHARACTER,INPUT pcColList CHARACTER,INPUT pcPropList CHARACTER FUNCTION closeQuery,LOGICAL, FUNCTION canNavigate,LOGICAL, FUNCTION cancelRow,CHARACTER, FUNCTION addRow,CHARACTER,INPUT pcViewColList CHARACTER FUNCTION setUpdatableColumns,logical,INPUT pcUpdatableColumns CHARACTER FUNCTION setRowObjectTable,logical,INPUT phHandle HANDLE FUNCTION getUpdatableColumns,character,                        �             _�    ��              H�              `2     +   8� �  Y   � �  Z   �� H  [   � �  \   ? ح �  undefined                                                                        (  �    �                                       �                   ��                   �        ο    p�              x�  �   �      �                                                         PROGRESS                         �            
        
                        �              �                                                                                                     
      `  �      �  
        
                      �  �             H                                                                                          �          
              �  
        
                      x  P                                                                                                                  
      �        H  
        
                      0               �                                                                                                    
      �  %         
        
                      �  �             p                                                                                          %          
      @  8      �  
        
                      �  x             (                                                                                          8          
      �  J      p  
        
                      X  0             �                                                                                          J          
      �  _      (  
        
                        �  	           �                                                                                          _          
      h  u      �  
        
                      �  �  
           P                                                                                          u          
         �      �                                 �  X                                                                                                       �                �  �      P                                8  	             �                                                                                          �                �	  �      	  
        
                      �  �	             x	                                                                                          �          
      H
  �      �	  
        
                      �	  �
             0
                                                                                          �          
         �      x
  
        
                      `
  8             �
                                                                                          �          
      �  �      0                                  �             �                                                                                          �                p  �      �                                �  �             X                                                                                          �                (  �      �                                �  `                                                                                                       �                    �      X                                @                 �                                                                                          �                              0�                                                   8�             X  8 P                                  �         
             
             
                                         
                                                                                    8   H   X   h   x   �   �   �   �   �   �   �   �       8   H   X   h   x   �   �   �   �   �   �   �   �    ��                                    ����                                    undefined                                                                       �           �   p       ��                    �����               �Dt                        O   ����    e�          O   ����    R�          O   ����    ��      �       �   �                  4   ����   (  /                                        3   ����(       $     X  ���                           P      
                           � ߱        �  �      `                 A              getUpdatableColumns     setRowObjectTable       setUpdatableColumns     ��    �      �      �           4   �����                 �                      ��                  �   �                   �?                           �   0  �  	  �   �                                            3   �����       O   �   ��  ��  �   batchServices                               �  �      ��                  Q  T  �              ��?                        O   ����    e�          O   ����    R�          O   ����    ��            ��                    �                   ��                                     ��                                    ����                                    clientSendRows                                       ��                  V  \  8              X�r                        O   ����    e�          O   ����    R�          O   ����    ��            ��       �             P                   ��       �             �                   ��       �             �                   ��                     �                   ��                                     ��                                    ����                                    commitTransaction                                   0        ��                  ^  _  H              (�r                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    copyColumns                                 H  0      ��                  a  d  `              оr                        O   ����    e�          O   ����    R�          O   ����    ��            ��       �             x                   �� 
                     �  
             ��                                    ����                                    dataAvailable                               �	  �	      ��                  f  h  �	              �;b                        O   ����    e�          O   ����    R�          O   ����    ��            ��                      �	               ��                                    ����                                    describeSchema                                �
      ��                  j  m                 �Bb                        O   ����    e�          O   ����    R�          O   ����    ��            ��       x             8                   �� 
              �       h  
             ��                                    ����                                    destroyServerObject                                 �  p      ��                  o  p  �              �M                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    endClientDataRequest                                �  �      ��                  r  s  �              ��M                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    fetchBatch                                  �  �      ��                  u  w  �              @�M                        O   ����    e�          O   ����    R�          O   ����    ��            ��                      �               ��                                    ����                                    fetchFirst                                    �      ��                  y  z                 8�M                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    fetchLast                                            ��                  |  }  8              ؖM                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    fetchNext                                   8         ��                    �  P              �M                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    fetchPrev                                   P  8      ��                  �  �  h              H�M                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    genContextList                              h  P      ��                  �  �  �              ��M                        O   ����    e�          O   ����    R�          O   ����    ��            ��                      �               ��                                    ����                                    home                                �  �      ��                  �  �  �              �-_                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    initializeObject                                    �  �      ��                  �  �  �              �1_                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    initializeServerObject                              �  �      ��                  �  �                 h6_                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    isUpdatePending                                �      ��                  �  �                ;_                        O   ����    e�          O   ����    R�          O   ����    ��            ��                      0               ��                                    ����                                    printToCrystal                              H  0      ��                  �  �  `               B_                        O   ����    e�          O   ����    R�          O   ����    ��            ��       �             x                   ��       �             �                   ��                      �               ��                                    ����                                    refreshRow                                  �  �      ��                  �  �                HN_                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    remoteCommit                                  �      ��                  �  �                 �R_                        O   ����    e�          O   ����    R�          O   ����    ��            ��       x             8                   �� 
      �      �       h  
                 ��       �             �                   ��                      �               ��                                    ����                                    remoteSendRows                              �  �      ��                  �  �  �               a_                        O   ����    e�          O   ����    R�          O   ����    ��            ��       P                                ��       �             @                   ��       �             p                   ��       �             �                   ��                     �                   ��       @                                   �� 
      p       �       0   
                 ��                      `                ��                                    ����                                    restartServerObject                                 �!  h!      ��                  �  �  �!              (�_                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    retrieveFilter                              �"  �"      ��                  �  �  �"              h�_                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    rowObjectState                              �#  �#      ��                  �  �  �#              �=a                        O   ����    e�          O   ����    R�          O   ����    ��            ��                      �#               ��                                    ����                                    saveContextAndDestroy                                %  �$      ��                  �  �  %              �Da                        O   ����    e�          O   ����    R�          O   ����    ��            ��                      0%               ��                                    ����                                    serverCommit                                H&  0&      ��                  �  �  `&              �Ka                        O   ����    e�          O   ����    R�          O   ����    ��            �� 
      �&      �       x&  
                 ��       �&             �&                   ��                      �&               ��                                    ����                                    serverSendRows                              �'  �'      ��                  �  �  (              �Wa                        O   ����    e�          O   ����    R�          O   ����    ��            ��       `(              (                   ��       �(             P(                   ��       �(             �(                   ��       �(             �(                   ��        )             �(                   �� 
              �       )  
             ��                                    ����                                    serverFetchRowObjUpdTable                                   8*   *      ��                  �  �  P*              �ja                        O   ����    e�          O   ����    R�          O   ����    ��            �� 
              �       h*  
             ��                                    ����                                    setPropertyList                             �+  h+      ��                  �  �  �+              �qa                        O   ����    e�          O   ����    R�          O   ����    ��            ��                      �+               ��                                    ����                                    serverSendRows                              �,  �,      ��                  �  �  �,              ya                        O   ����    e�          O   ����    R�          O   ����    ��            ��       8-             �,                   ��       h-             (-                   ��       �-             X-                   ��       �-             �-                   ��       �-             �-                   �� 
              �       �-  
             ��                                    ����                                    startServerObject                                   /  �.      ��                  �  �   /              �a                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    submitCommit                                 0  0      ��                  �  �  80              ��a                        O   ����    e�          O   ����    R�          O   ����    ��            ��       �0             P0                   ��                      �0               ��                                    ����                                    submitForeignKey                                    �1  �1      ��                  �  �  �1              (\m                        O   ����    e�          O   ����    R�          O   ����    ��            ��       2             �1                   ��       @2              2                   ��                      02               ��                                    ����                                    submitValidation                                    P3  83      ��                  �  �  h3              �hm                        O   ����    e�          O   ����    R�          O   ����    ��            ��       �3             �3                   ��                      �3               ��                                    ����                                    synchronizeProperties                               �4  �4      ��                  �  �  �4              �qm                        O   ����    e�          O   ����    R�          O   ����    ��            ��       @5              5                   ��                      05               ��                                    ����                                    transferToExcel                             H6  06      ��                      `6              h{m                        O   ����    e�          O   ����    R�          O   ����    ��            ��       �6             x6                   ��       �6             �6                   ��       7             �6                   ��                      7               ��                                    ����                                    undoTransaction                              8  8      ��                  
    88              Љm                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    updateAddQueryWhere                                 @9  (9      ��                      X9              x�m                        O   ����    e�          O   ����    R�          O   ����    ��            ��       �9             p9                   ��                      �9               ��                                    ����                                    updateQueryPosition                                 �:  �:      ��                      �:              ��m                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    updateState                                 �;  �;      ��                      �;              X�m                        O   ����    e�          O   ����    R�          O   ����    ��            ��                      <               ��                                    ����                                    addRow          �<      �<    ]       CHARACTER,INPUT pcViewColList CHARACTER cancelRow       �<      �<      =   	 d       CHARACTER,      canNavigate     �<      =      H=    n       LOGICAL,        closeQuery      (=      X=      �=   
 z       LOGICAL,        columnProps     h=      �=      �=    �       CHARACTER,INPUT pcColList CHARACTER,INPUT pcPropList CHARACTER  colValues       �=      >      8>   	 �       CHARACTER,INPUT pcViewColList CHARACTER copyRow >      `>      �>  	  �       CHARACTER,INPUT pcViewColList CHARACTER createRow       h>      �>      �>  
 	 �       LOGICAL,INPUT pcValueList CHARACTER     deleteRow       �>      ?      8?   	 �       LOGICAL,INPUT pcRowIdent CHARACTER      fetchRow        ?      `?      �?    �       CHARACTER,INPUT piRow INTEGER,INPUT pcViewColList CHARACTER     fetchRowIdent   p?      �?       @    �       CHARACTER,INPUT pcRowIdent CHARACTER,INPUT pcViewColList CHARACTER      findRow �?      H@      p@    �       LOGICAL,INPUT pcKeyValues CHARACTER     findRowWhere    P@      �@      �@    �       LOGICAL,INPUT pcColumns CHARACTER,INPUT pcValues CHARACTER,INPUT pcOperators CHARACTER  firstRowIds     �@       A      PA    �       CHARACTER,INPUT pcQueryString CHARACTER getLastCommitErrorType  0A      xA      �A    �       CHARACTER,      hasForeignKeyChanged    �A      �A      �A          LOGICAL,        openDataQuery   �A      B      8B          LOGICAL,INPUT pcPosition CHARACTER      openQuery       B      `B      �B   	 )      LOGICAL,        prepareQuery    pB      �B      �B    3      LOGICAL,INPUT pcQuery CHARACTER rowAvailable    �B      �B       C    @      LOGICAL,INPUT pcDirection CHARACTER     rowValues        C      HC      xC   	 M      CHARACTER,INPUT pcColumns CHARACTER,INPUT pcFormat CHARACTER,INPUT pcDelimiter CHARACTER        submitRow       XC      �C      D   	 W      LOGICAL,INPUT pcRowIdent CHARACTER,INPUT pcValueList CHARACTER  updateRow       �C      HD      xD   	 a      LOGICAL,INPUT pcKeyValues CHARACTER,INPUT pcValueList CHARACTER getObjectType   XD      �D      �D    k      CHARACTER,      assignDBRow                                 �E  xE      ��                  �  �  �E               b[                        O   ����    e�          O   ����    R�          O   ����    ��            �� 
                     �E  
             ��                                    ����                                    bufferCopyDBToRO                                    �F  �F      ��                      �F              �h[                        O   ����    e�          O   ����    R�          O   ����    ��            �� 
      PG             G  
                 �� 
      �G             @G  
                 ��       �G             pG                   ��                      �G               ��                                    ����                                    compareDBRow                                �H  �H      ��                    	  �H              ��[                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    confirmContinue                             �I  �I      ��                      �I              (�[                        O   ����    e�          O   ����    R�          O   ����    ��            ��                       J               ��                                    ����                                    dataAvailable                               K   K      ��                      0K              0�[                        O   ����    e�          O   ����    R�          O   ����    ��            ��                      HK               ��                                    ����                                    fetchDBRowForUpdate                                 hL  PL      ��                      �L              `�[                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    fetchFirst                                  �M  hM      ��                      �M              ��[                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    fetchLast                                   �N  �N      ��                      �N              ��[                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    fetchNext                                   �O  �O      ��                      �O              г[                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    fetchPrev                                   �P  �P      ��                       �P              ��[                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    filterContainerHandler                              �Q  �Q      ��                  "  $   R              p�[                        O   ����    e�          O   ����    R�          O   ����    ��            �� 
                     R  
             ��                                    ����                                    initializeObject                                    8S   S      ��                  &  '  PS              ��[                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    refetchDBRow                                PT  8T      ��                  )  +  hT              ��[                        O   ����    e�          O   ����    R�          O   ����    ��            �� 
                     �T  
             ��                                    ����                                    releaseDBRow                                �U  �U      ��                  -  .  �U              ��[                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    startFilter                                 �V  �V      ��                  0  1  �V              h�[                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    transferDBRow                               �W  �W      ��                  3  6  �W              ��[                        O   ����    e�          O   ����    R�          O   ����    ��            ��       8X             �W                   ��                      (X               ��                                    ����                                    addQueryWhere   �D      �X      �X    �      LOGICAL,INPUT pcWhere CHARACTER,INPUT pcBuffer CHARACTER,INPUT pcAndOr CHARACTER        assignQuerySelection    �X      0Y      hY    �      LOGICAL,INPUT pcColumns CHARACTER,INPUT pcValues CHARACTER,INPUT pcOperators CHARACTER  bufferCompareDBToRO     HY      �Y      �Y    �      LOGICAL,INPUT phRowObjUpd HANDLE,INPUT phBuffer HANDLE,INPUT pcExcludes CHARACTER,INPUT pcAssigns CHARACTER     bufferWhereClause       �Y      hZ      �Z    �      CHARACTER,INPUT pcBuffer CHARACTER,INPUT pcWhere CHARACTER      columnDataType  �Z      �Z      [    �      CHARACTER,INPUT pcColumn CHARACTER      columnDbColumn  �Z      8[      h[     �      CHARACTER,INPUT pcColumn CHARACTER      columnQuerySelection    H[      �[      �[  !  �      CHARACTER,INPUT pcColumn CHARACTER      columnTable     �[      �[       \  "        CHARACTER,INPUT pcColumn CHARACTER      columnValMsg     \      H\      x\  #        CHARACTER,INPUT pcColumn CHARACTER      dbColumnDataName        X\      �\      �\  $  !      CHARACTER,INPUT pcDbColumn CHARACTER    dbColumnHandle  �\       ]      0]  %  2      HANDLE,INPUT pcColumn CHARACTER excludeColumns  ]      P]      �]  &  A      CHARACTER,INPUT iTable INTEGER  getDataColumns  `]      �]      �]  '  P      CHARACTER,      getForeignValues        �]      �]      ^  (  _      CHARACTER,      getQueryPosition        �]      (^      `^  )  p      CHARACTER,      getQuerySort    @^      p^      �^  *  �      CHARACTER,      getQueryString  �^      �^      �^  +  �      CHARACTER,      getQueryWhere   �^      �^       _  ,  �      CHARACTER,      getTargetProcedure       _      0_      h_  -  �      HANDLE, indexInformation        H_      p_      �_  .  �      CHARACTER,INPUT pcQuery CHARACTER,INPUT plUseTableSep LOGICAL,INPUT pcIndexInfo CHARACTER       insertExpression        �_      `      @`  /  �      CHARACTER,INPUT pcWhere CHARACTER,INPUT pcExpression CHARACTER,INPUT pcAndOr CHARACTER  newQueryString   `      �`      �`  0  �      CHARACTER,INPUT pcColumns CHARACTER,INPUT pcValues CHARACTER,INPUT pcOperators CHARACTER,INPUT pcQueryString CHARACTER,INPUT pcAndOr CHARACTER  newQueryValidate        �`      Xa      �a  1  �      CHARACTER,INPUT pcQueryString CHARACTER,INPUT pcExpression CHARACTER,INPUT pcBuffer CHARACTER,INPUT pcAndOr CHARACTER   newQueryWhere   pa      b      8b  2         CHARACTER,INPUT pcWhere CHARACTER       newWhereClause  b      `b      �b  3        CHARACTER,INPUT pcBuffer CHARACTER,INPUT pcExpression CHARACTER,INPUT pcWhere CHARACTER,INPUT pcAndOr CHARACTER refreshRowident pb       c      0c  4        CHARACTER,INPUT pcRowident CHARACTER    removeForeignKey        c      Xc      �c  5  -      LOGICAL,        removeQuerySelection    pc      �c      �c  6  >      LOGICAL,INPUT pcColumns CHARACTER,INPUT pcOperators CHARACTER   resolveBuffer   �c      d      Hd  7  S      CHARACTER,INPUT pcBuffer CHARACTER      rowidWhere      (d      pd      �d  8 
 a      CHARACTER,INPUT pcWhere CHARACTER       rowidWhereCols  �d      �d      �d  9  l      CHARACTER,INPUT pcColumns CHARACTER,INPUT pcValues CHARACTER,INPUT pcOperators CHARACTER        setQueryPosition        �d      Xe      �e  :  {      LOGICAL,INPUT pcPosition CHARACTER      setQuerySort    pe      �e      �e  ;  �      LOGICAL,INPUT pcSort CHARACTER  setQueryString  �e      f      8f  <  �      LOGICAL,INPUT pcQueryString CHARACTER   setQueryWhere   f      `f      �f  =  �      LOGICAL,INPUT pcWhere CHARACTER whereClauseBuffer       pf      �f      �f  >  �      CHARACTER,INPUT pcWhere CHARACTER       bindServer                                  �g  �g      ��                  �  �  �g              H�j                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    destroyObject                               �h  �h      ��                  �  �  �h              ��j                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    destroyServerObject                                 �i  �i      ��                  �  �  �i              �k                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    disconnectObject                                     k  �j      ��                  �  �  k              �k                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    initializeServerObject                               l  l      ��                  �  �  8l               
k                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    restartServerObject                                 @m  (m      ��                  �  �  Xm              (k                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    runServerObject                             Xn  @n      ��                  �  �  pn              ("k                        O   ����    e�          O   ����    R�          O   ����    ��            �� 
                     �n  
             ��                                    ����                                    startServerObject                                   �o  �o      ��                  �  �  �o              ()k                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    unbindServer                                �p  �p      ��                  �  �  �p              h.k                        O   ����    e�          O   ����    R�          O   ����    ��            ��                      �p               ��                                    ����                                    getAppService   �f      pq      �q  ?  �      CHARACTER,      getASBound      �q      �q      �q  @ 
 �      LOGICAL,        getAsDivision   �q      �q       r  A  �      CHARACTER,      getASHandle      r      0r      `r  B  �      HANDLE, getASHasStarted @r      hr      �r  C  �      LOGICAL,        getASInfo       xr      �r      �r  D 	       CHARACTER,      getASInitializeOnRun    �r      �r       s  E        LOGICAL,        getASUsePrompt   s      0s      `s  F  *      LOGICAL,        getServerFileName       @s      ps      �s  G  9      CHARACTER,      getServerOperatingMode  �s      �s      �s  H  K      CHARACTER,      runServerProcedure      �s       t      8t  I  b      HANDLE,INPUT pcServerFileName CHARACTER,INPUT phAppService HANDLE       setAppService   t      �t      �t  J  u      LOGICAL,INPUT pcAppService CHARACTER    setASDivision   �t      �t      u  K  �      LOGICAL,INPUT pcDivision CHARACTER      setASHandle     �t      0u      `u  L  �      LOGICAL,INPUT phASHandle HANDLE setASInfo       @u      �u      �u  M 	 �      LOGICAL,INPUT pcInfo CHARACTER  setASInitializeOnRun    �u      �u      v  N  �      LOGICAL,INPUT plInitialize LOGICAL      setASUsePrompt  �u      0v      `v  O  �      LOGICAL,INPUT plFlag LOGICAL    setServerFileName       @v      �v      �v  P  �      LOGICAL,INPUT pcFileName CHARACTER      setServerOperatingMode  �v      �v      w  Q  �      LOGICAL,INPUT pcServerOperatingMode CHARACTER   addLink                             �w  �w      ��                  �  �  �w              �L                        O   ����    e�          O   ����    R�          O   ����    ��            �� 
      Hx             x  
                 ��       xx             8x                   �� 
                     hx  
             ��                                    ����                                    addMessage                                  �y  hy      ��                  �  �  �y              �L                        O   ����    e�          O   ����    R�          O   ����    ��            ��       �y             �y                   ��        z             �y                   ��                      z               ��                                    ����                                    adjustTabOrder                              ({  {      ��                  �  �  @{                L                        O   ����    e�          O   ����    R�          O   ����    ��            �� 
      �{             X{  
                 �� 
      �{             �{  
                 ��                      �{               ��                                    ����                                    applyEntry                                  �|  �|      ��                  �  �  �|              �+L                        O   ����    e�          O   ����    R�          O   ����    ��            ��                       }               ��                                    ����                                    changeCursor                                ~   ~      ��                  �  �  0~              �2L                        O   ����    e�          O   ����    R�          O   ����    ��            ��                      H~               ��                                    ����                                    createControls                              `  H      ��                  �  �  x               JL                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    destroyObject                               x�  `�      ��                  �  �  ��              �NL                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    displayLinks                                ��  x�      ��                  �  �  ��              0TL                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    editInstanceProperties                              ��  ��      ��                  �  �  Ȃ              �XL                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    exitObject                                  ȃ  ��      ��                  �  �  ��              �]L                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    hideObject                                  ��  Ȅ      ��                  �  �  ��              (bL                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    initializeObject                                     �  �      ��                  �  �  �              �fL                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    modifyListProperty                                   �  �      ��                  �  �  8�              lL                        O   ����    e�          O   ����    R�          O   ����    ��            �� 
      ��             P�  
                 ��       ��             ��                   ��       ��             ��                   ��                      ��               ��                                    ����                                    modifyUserLinks                             ��  ��      ��                  �  �  �              PzL                        O   ����    e�          O   ����    R�          O   ����    ��            ��       h�             (�                   ��       ��             X�                   �� 
                     ��  
             ��                                    ����                                    removeAllLinks                              ��  ��      ��                  �  �  ��              �L                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    removeLink                                  ��  ��      ��                  �  �  Ћ              ��L                        O   ����    e�          O   ����    R�          O   ����    ��            �� 
      (�             �  
                 ��       X�             �                   �� 
                     H�  
             ��                                    ����                                    repositionObject                                    h�  P�      ��                  �  �  ��              p�L                        O   ����    e�          O   ����    R�          O   ����    ��            ��       ؍             ��                   ��                      ȍ               ��                                    ����                                    returnFocus                                 ��  Ȏ      ��                  �  �  ��              ��L                        O   ����    e�          O   ����    R�          O   ����    ��            �� 
                     �  
             ��                                    ����                                    showMessageProcedure                                0�  �      ��                  �  �  H�              ��i                        O   ����    e�          O   ����    R�          O   ����    ��            ��       ��             `�                   ��                      ��               ��                                    ����                                    toggleData                                  ��  ��      ��                      ��              ��i                        O   ����    e�          O   ����    R�          O   ����    ��            ��                      ؑ               ��                                    ����                                    viewObject                                  �  ؒ      ��                      �              ��i                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    anyMessage      �v      p�      ��  R 
 B      LOGICAL,        assignLinkProperty      ��      ��      �  S  M      LOGICAL,INPUT pcLink CHARACTER,INPUT pcPropName CHARACTER,INPUT pcPropValue CHARACTER   fetchMessages   ȓ      @�      p�  T  `      CHARACTER,      getChildDataKey P�      ��      ��  U  n      CHARACTER,      getContainerHandle      ��      ��      ��  V  ~      HANDLE, getContainerHidden      ؔ       �      8�  W  �      LOGICAL,        getContainerSource      �      H�      ��  X  �      HANDLE, getContainerSourceEvents        `�      ��      ȕ  Y  �      CHARACTER,      getContainerType        ��      ؕ      �  Z  �      CHARACTER,      getDataLinksEnabled     �       �      X�  [  �      LOGICAL,        getDataSource   8�      h�      ��  \  �      HANDLE, getDataSourceEvents     x�      ��      ؖ  ]        CHARACTER,      getDataSourceNames      ��      �       �  ^        CHARACTER,      getDataTarget    �      0�      `�  _  *      CHARACTER,      getDataTargetEvents     @�      p�      ��  `  8      CHARACTER,      getDBAware      ��      ��      �  a 
 L      LOGICAL,        getDesignDataObject     ȗ      ��      0�  b  W      CHARACTER,      getDynamicObject        �      @�      x�  c  k      LOGICAL,        getInstanceProperties   X�      ��      ��  d  |      CHARACTER,      getLogicalObjectName    ��      И      �  e  �      CHARACTER,      getLogicalVersion       �      �      P�  f  �      CHARACTER,      getObjectHidden 0�      `�      ��  g  �      LOGICAL,        getObjectInitialized    p�      ��      ؙ  h  �      LOGICAL,        getObjectName   ��      �      �  i  �      CHARACTER,      getObjectPage   ��      (�      X�  j  �      INTEGER,        getObjectParent 8�      h�      ��  k  �      HANDLE, getObjectVersion        x�      ��      ؚ  l  
      CHARACTER,      getObjectVersionNumber  ��      �       �  m        CHARACTER,      getParentDataKey         �      0�      h�  n  2      CHARACTER,      getPassThroughLinks     H�      x�      ��  o  C      CHARACTER,      getPhysicalObjectName   ��      ��      ��  p  W      CHARACTER,      getPhysicalVersion      ؛      �      @�  q  m      CHARACTER,      getPropertyDialog        �      P�      ��  r  �      CHARACTER,      getQueryObject  h�      ��      Ȝ  s  �      LOGICAL,        getRunAttribute ��      ؜      �  t  �      CHARACTER,      getSupportedLinks       �      �      P�  u  �      CHARACTER,      getTranslatableProperties       0�      `�      ��  v  �      CHARACTER,      getUIBMode      ��      ��      ��  w 
 �      CHARACTER,      getUserProperty ��      �       �  x  �      CHARACTER,INPUT pcPropName CHARACTER    instancePropertyList     �      H�      ��  y  �      CHARACTER,INPUT pcPropList CHARACTER    linkHandles     `�      ��      ؞  z  	      CHARACTER,INPUT pcLink CHARACTER        linkProperty    ��       �      0�  {  	      CHARACTER,INPUT pcLink CHARACTER,INPUT pcPropName CHARACTER     mappedEntry     �      p�      ��  |  &	      CHARACTER,INPUT pcEntry CHARACTER,INPUT pcList CHARACTER,INPUT plFirst LOGICAL,INPUT pcDelimiter CHARACTER      messageNumber   ��      �      @�  }  2	      CHARACTER,INPUT piMessage INTEGER       propertyType     �      h�      ��  ~  @	      CHARACTER,INPUT pcPropName CHARACTER    reviewMessages  x�      ��      �    M	      CHARACTER,      setChildDataKey Р       �      0�  �  \	      LOGICAL,INPUT cChildDataKey CHARACTER   setContainerHidden      �      X�      ��  �  l	      LOGICAL,INPUT plHidden LOGICAL  setContainerSource      p�      ��      �  �  	      LOGICAL,INPUT phObject HANDLE   setContainerSourceEvents        ȡ      �      H�  �  �	      LOGICAL,INPUT pcEvents CHARACTER        setDataLinksEnabled     (�      p�      ��  �  �	      LOGICAL,INPUT lDataLinksEnabled LOGICAL setDataSource   ��      Т       �  �  �	      LOGICAL,INPUT phObject HANDLE   setDataSourceEvents     �       �      X�  �  �	      LOGICAL,INPUT pcEventsList CHARACTER    setDataSourceNames      8�      ��      ��  �  �	      LOGICAL,INPUT pcSourceNames CHARACTER   setDataTarget   ��      �      �  �  �	      LOGICAL,INPUT pcTarget CHARACTER        setDataTargetEvents     �      8�      p�  �  
      LOGICAL,INPUT pcEvents CHARACTER        setDBAware      P�      ��      Ȥ  � 
 
      LOGICAL,INPUT lAware LOGICAL    setDesignDataObject     ��      �       �  �  !
      LOGICAL,INPUT pcDataObject CHARACTER    setDynamicObject         �      H�      ��  �  5
      LOGICAL,INPUT lTemp LOGICAL     setInstanceProperties   `�      ��      إ  �  F
      LOGICAL,INPUT pcPropList CHARACTER      setLogicalObjectName    ��       �      8�  �  \
      LOGICAL,INPUT c CHARACTER       setLogicalVersion       �      X�      ��  �  q
      LOGICAL,INPUT cVersion CHARACTER        setObjectName   p�      ��      �  �  �
      LOGICAL,INPUT pcName CHARACTER  setObjectParent Ȧ      �      8�  �  �
      LOGICAL,INPUT phParent HANDLE   setObjectVersion        �      X�      ��  �  �
      LOGICAL,INPUT cObjectVersion CHARACTER  setParentDataKey        p�      ��      �  �  �
      LOGICAL,INPUT cParentDataKey CHARACTER  setPassThroughLinks     Ч      �      P�  �  �
      LOGICAL,INPUT pcLinks CHARACTER setPhysicalObjectName   0�      p�      ��  �  �
      LOGICAL,INPUT cTemp CHARACTER   setPhysicalVersion      ��      Ȩ       �  �  �
      LOGICAL,INPUT cVersion CHARACTER        setRunAttribute �      (�      X�  �         LOGICAL,INPUT cRunAttribute CHARACTER   setSupportedLinks       8�      ��      ��  �        LOGICAL,INPUT pcLinkList CHARACTER      setTranslatableProperties       ��      �       �  �  "      LOGICAL,INPUT pcPropList CHARACTER      setUIBMode       �      H�      x�  � 
 <      LOGICAL,INPUT pcMode CHARACTER  setUserProperty X�      ��      Ȫ  �  G      LOGICAL,INPUT pcPropName CHARACTER,INPUT pcPropValue CHARACTER  showmessage     ��      �      8�  �  W      LOGICAL,INPUT pcMessage CHARACTER       Signature       �      `�      ��  � 	 c      CHARACTER,INPUT pcName CHARACTER        ��      ث  X�      �           4   �����                 h�                      ��                    J                  j                             �          ��  �      �           4   �����                 �                      ��                    I                  j                             ��  (�    6  8�  ��                4   ����                ȭ                      ��                  B  D                  j                           B  H�         C                                      �     
                        � ߱        X�  $  F  ��  ���                               $  H  ��  ���                                                        � ߱        ��    N  خ  X�      0          4   ����0                h�                      ��                  O  	                  @j                           O  �  ��  o   R      ,                                      �  $   S  Я  ���                           �  @         �                  � ߱        �  �   T            0�  �   U  �          H�  �   W  8          `�  �   Y  �          x�  �   [  h          ��  �   ]             ��  �   ^  �          ��  �   _  �          ذ  �   b  �          �  �   d             �  �   e  �           �  �   g  `	          8�  �   h   
          P�  �   i  P
          h�  �   j  �
          ��  �   k  �          ��  �   q  �          ��  �   s  p          ȱ  �   y  �          �  �   {  X          ��  �   }  �          �  �   ~  �          (�  �   �  0          @�  �   �  �          X�  �   �  h          p�  �   �             ��  �   �  �          ��  �   �  �          ��  �   �  �          в  �   �  �          �  �   �  h           �  �   �  �          �  �   �            0�  �   �  X          H�  �   �  �          `�  �   �  H          x�  �   �  �          ��  �   �  �          ��  �   �  8          ��  �   �  �          س  �   �  �          �  �   �  (          �  �   �  x           �  �   �  �              �   �                            `�          ��  ��      ��                  :	  h	  ش              �Dj                        O   ����    e�          O   ����    R�          O   ����    ��      �     
                    X                                                      � ߱        ��  $ N	  �  ���                               O   f	  ��  ��  p                �          �  ��    �                                                         ��                                    ����                                        �D      8�      ��     X     �                       �  k                         ��    �	  �  `�      �          4   �����                p�                      ��                  �	  
                  �Lj                           �	  �  ��  �   �	            ��  �   �	  �          ��  �   �	  H          з  �   �	  �          �  �   �	  �           �  �   �	  (          �  �   �	  �          0�  �   �	  `           H�  �   �	   !          `�  �   �	  �!          x�  �   �	  8"          ��  �   �	  �"          ��  �   �	  x#              �   �	  $          �    ?
  �  `�      �$          4   �����$                p�                      ��                  @
  �
                  ��c                           @
  �  ��  �   B
  8%          ��  �   C
  �%          ��  �   D
  x&          й  �   E
  '          �  �   F
  �'           �  �   G
   (          �  �   I
  �(          0�  �   J
  0)          H�  �   K
  �)          `�  �   L
  *          x�  �   M
  h*          ��  �   N
   +          ��  �   O
  P+          ��  �   P
  �+          غ  �   Q
  �,          �  �   R
  0-          �  �   S
  �-           �  �   T
  h.          8�  �   U
  /          P�  �   V
  �/          h�  �   W
  H0          ��  �   X
  �0          ��  �   Y
  �0          ��  �   Z
  �1          Ȼ  �   [
   2          �  �   \
  �2          ��  �   ]
  `3          �  �   ^
   4          (�  �   _
  �4          @�  �   `
  @5          X�  �   a
  �5          p�  �   c
  (6          ��  �   d
  �6          ��  �   e
  7          ��  �   f
  �7          м  �   g
  P8          �  �   h
  �8           �  �   i
  �9          �  �   j
  :          0�  �   k
  �:          H�  �   l
  X;          `�  �   m
  �;          x�  �   n
  �<          ��  �   o
  (=          ��  �   p
  �=          ��  �   q
  h>          ؽ  �   r
  ?              �   s
  �?          @�    �
  �  ��      �?          4   �����?                ��                      ��                  �
  ~                  ��c                           �
   �  ��  �   �
  p@          о  �   �
  A          �  �   �
  �A           �  �   �
  @B          �  �   �
  �B          0�  �   �
  xC          H�  �   �
  D          `�  �   �
  �D          x�  �   �
  PE          ��  �   �
  �E          ��  �   �
  �F          ��  �   �
  0G          ؿ  �   �
  �G          �  �   �
  hH          �  �   �
   I           �  �      �I          8�  �     8J          P�  �     �J          h�  �     pK          ��  �     L          ��  �     �L          ��  �     �L          ��  �     �M          ��  �     0N          ��  �   	  �N          �  �   
  hO          (�  �      P              �     �P          ��    �  `�  ��      0Q          4   ����0Q  	              ��                      ��             	     �  -                  x�c                           �  p�  �  �   �  �Q           �  �   �  `R          8�  �   �   S          P�  �   �  �S          h�  �   �  @T          ��  �   �  �T          ��  �   �  xU          ��  �   �  V          ��  �   �  �V          ��  �   �  PW          ��  �   �  �W          �  �   �  �X          (�  �   �  0Y          @�  �   �  �Y          X�  �   �  hZ          p�  �   �  [          ��  �   �  �[          ��  �   �  H\          ��  �   �  �\          ��  �   �  x]          ��  �   �  ^           �  �   �  �^          �  �   �  _          0�  �   �  �_          H�  �   �  H`          `�  �   �  �`          x�  �   �  �a          ��  �   �   b              �   �  �b          H�    �  ��  ��      Pc          4   ����Pc      /   �  �     �                              3   ����hc            8�                      3   �����c   �    �  h�  ��  ��  �c          4   �����c  
              ��                      ��             
     �  O                  �	d                           �  x�  �  �   �  @d          p�  $  �  @�  ���                           �d     
                        � ߱        ��  �   �  �d          ��  $   �  ��  ���                           �d  @         �d                  � ߱        ��  $  �  �  ���                           pe       
       
               � ߱        �f     
                    8g                         Pi  @        
 �h                  � ߱        X�  V     H�  ���                            `i       
       
           �i                         j       
       
               � ߱        ��  $    ��  ���                           8k     
                    �k                          n  @        
 �m                  � ߱            V   0  ��  ���                                          x�                      ��                  Q  �                  hd                           Q  (�  n     
                    �n                         �p  @        
 xp              hq  @        
 q              �q  @        
 �q              xr  @        
 r                  � ߱            V   f  ��  ���                            start-super-proc        `�  ��  �           �     Y     `                          X  =                         ��      @�  P�      @t          4   ����@t      /     ��     ��                              3   ����Xt            ��                      3   �����t   �  $     ��  ���                           �t                             � ߱         �    /  @�  ��  p�  �t          4   �����t                @�                      ��                  0  4                  �1d                           0  P�  �t                         u                         (u                             � ߱            $  1  ��  ���                                 5  ��  ��      Pu          4   ����Pu  �u                             � ߱            $  6  ��  ���                           �    =   �  0�  ��  �u          4   �����u      $  >  `�  ���                           �u                             � ߱            �   [  �u          8v     
                    �v                          y  @        
 �x                  � ߱        H�  V   o  ��  ���                            `�  �   �  y          p�    !  ��  ��      hy          4   ����hy      /   "  ��     ��                              3   �����y            ��                      3   �����y  �y     
                    �z                         �|  @        
 8|                  � ߱        �  V   .   �  ���                            �|     
                    �}                         �  @        
 P                  � ߱        @�  V   R  ��  ���                            ��    �  `�  ��      �          4   �����                ��                      ��                  �  �                  �Gd                           �  p�  `�  /   �   �     0�                              3   �����            P�                      3   �����      /   �  ��     ��                              3   ����(�            ��                      3   ����P�        �  ��  p�      p�          4   ����p�                ��                      ��                  �  �                  hId                           �   �  ��  /   �  ��     ��                              3   ������            ��                      3   ������  `�  /   �   �     0�                              3   ����Ѐ            P�                      3   ������  ��  /   �  ��     ��                              3   �����            ��                      3   ����@�  ��  /   �   �     �                              3   ����h�            0�                      3   ������  ��     
                    h�                         ��  @        
  �                  � ߱            V   �  @�  ���                            destroyObject   ��  ��                    Z     �                          �  �                         disable_UI      ��  P�                      [      �                               �  
                       initializeObject        `�  ��              `     \     �                          x  �                                         ��          ��  ��      ��                  Q  Y  ��              �d                        O   ����    e�          O   ����    R�          O   ����    ��          O   X  ��  ��  ��    ��                                    ����                                    ��  �      8�              ]      �                            �                                         ��          @�  (�      ��                 `  �  X�              P�d                        O   ����    e�          O   ����    R�          O   ����    ��           
                     p�               �  $  l  ��  ���                           ��                             � ߱        �    n   �  ��      Ȏ          4   ����Ȏ                ��                      ��                  o  �                  h�d                           o  0�  8�  �   p  ؎          �     
                    ��                         p�     
                        � ߱        h�  $  z  ��  ���                           ��    �  ��  �      Б          4   ����Б    �      x�  8�                      ��        0         �  �                  ��d      �                �  ��      $  �  H�  ���                           �                             � ߱        ��  $  �  ��  ���                           (�                             � ߱            4   ����p�  @�     
                    ��                             � ߱            $  �  ��  ���                           8�     
                    �                          �  @        
 ��                  � ߱            V   �  h�  ���                                O   �  ��  ��  �               ��          ��  ��    � X�                
                                         
                           
                  0   @   P   `   p               0   @   P   `   p       �  � �          ��                                    ����                                    X�  �  ��  ��       �     ^     �                        �  N                                         ��          @�  (�      ��                  �  �  X�              p�d                        O   ����    e�          O   ����    R�          O   ����    ��      `                          p�               �  $  �  ��  ���                            �                             � ߱            O   �  ��  ��  0�               p�          `�  h�    P�                                        �               ��                                    ����                                    X�  �  ��  ��      �     _     ��                       x�  s                          �         ����  �         X�  h�      viewObject      ,       H�  ��  ��      toggleData      ,INPUT plEnabled LOGICAL        p�  ��  ��      showMessageProcedure    ,INPUT pcMessage CHARACTER,OUTPUT plAnswer LOGICAL      ��   �  0�      returnFocus     ,INPUT hTarget HANDLE   �  X�  p�      repositionObject        ,INPUT pdRow DECIMAL,INPUT pdCol DECIMAL        H�  ��  ��      removeLink      ,INPUT phSource HANDLE,INPUT pcLink CHARACTER,INPUT phTarget HANDLE     ��  �  (�      removeAllLinks  ,       �  @�  P�      modifyUserLinks ,INPUT pcMod CHARACTER,INPUT pcLinkName CHARACTER,INPUT phObject HANDLE 0�  ��  ��      modifyListProperty      ,INPUT phCaller HANDLE,INPUT pcMode CHARACTER,INPUT pcListName CHARACTER,INPUT pcListValue CHARACTER    ��  8�  H�      hideObject      ,       (�  `�  p�      exitObject      ,       P�  ��  ��      editInstanceProperties  ,       x�  ��  ��      displayLinks    ,       ��  ��  ��      createControls  ,       ��  �  �      changeCursor    ,INPUT pcCursor CHARACTER       ��  H�  X�      applyEntry      ,INPUT pcField CHARACTER        8�  ��  ��      adjustTabOrder  ,INPUT phObject HANDLE,INPUT phAnchor HANDLE,INPUT pcPosition CHARACTER x�  ��   �      addMessage      ,INPUT pcText CHARACTER,INPUT pcField CHARACTER,INPUT pcTable CHARACTER ��  X�  `�      addLink ,INPUT phSource HANDLE,INPUT pcLink CHARACTER,INPUT phTarget HANDLE     H�  ��  ��      unbindServer    ,INPUT pcMode CHARACTER ��  ��   �      runServerObject ,INPUT phAppService HANDLE      ��  0�  H�      disconnectObject        ,        �  `�  p�      bindServer      ,       P�  ��  ��      transferDBRow   ,INPUT pcRowIdent CHARACTER,INPUT piRowNum INTEGER      x�  ��  ��      startFilter     ,       ��  �  �      releaseDBRow    ,       ��  0�  @�      refetchDBRow    ,INPUT phRowObjUpd HANDLE        �  p�  ��      filterContainerHandler  ,INPUT phFilterContainer HANDLE `�  ��  ��      fetchDBRowForUpdate     ,       ��  ��  ��      confirmContinue ,INPUT-OUTPUT pioCancel LOGICAL ��  (�  8�      compareDBRow    ,       �  P�  h�      bufferCopyDBToRO        ,INPUT phRowObj HANDLE,INPUT phBuffer HANDLE,INPUT pcExcludes CHARACTER,INPUT pcAssigns CHARACTER       @�  ��  ��      assignDBRow     ,INPUT phRowObjUpd HANDLE       ��   �  0�      updateState     ,INPUT pcState CHARACTER        �  `�  x�      updateQueryPosition     ,       P�  ��  ��      updateAddQueryWhere     ,INPUT pcWhere CHARACTER,INPUT pcField CHARACTER        ��  ��   �      undoTransaction ,       ��  �  (�      transferToExcel ,INPUT pcFieldList CHARACTER,INPUT plIncludeObj LOGICAL,INPUT plUseExisting LOGICAL,INPUT piMaxRecords INTEGER  �  ��  ��      synchronizeProperties   ,INPUT pcPropertiesForServer CHARACTER,OUTPUT pcPropertiesForClient CHARACTER   ��   �  8�      submitValidation        ,INPUT pcValueList CHARACTER,INPUT pcUpdColumns CHARACTER       �  ��  ��      submitForeignKey        ,INPUT pcRowIdent CHARACTER,INPUT-OUTPUT pcValueList CHARACTER,INPUT-OUTPUT pcUpdColumns CHARACTER      x�  �  (�      submitCommit    ,INPUT pcRowIdent CHARACTER,INPUT plReopen LOGICAL      �  p�  ��      startServerObject       ,       `�  ��  ��      setPropertyList ,INPUT pcProperties CHARACTER   ��  ��   �      serverFetchRowObjUpdTable       ,OUTPUT TABLE-HANDLE phRowObjUpd        ��  8�  H�      serverSendRows  ,INPUT piStartRow INTEGER,INPUT pcRowIdent CHARACTER,INPUT plNext LOGICAL,INPUT piRowsToReturn INTEGER,OUTPUT piRowsReturned INTEGER,OUTPUT TABLE-HANDLE phRowObject    (�   �  �      serverCommit    ,INPUT-OUTPUT TABLE-HANDLE phRowObjUpd,OUTPUT pcMessages CHARACTER,OUTPUT pcUndoIds CHARACTER   ��  ��  ��      saveContextAndDestroy   ,OUTPUT pcContext CHARACTER     p�  ��  ��      rowObjectState  ,INPUT pcState CHARACTER        ��  �  �      retrieveFilter  ,       ��  0�  H�      restartServerObject     ,        �  `�  p�      remoteSendRows  ,INPUT-OUTPUT piocContext CHARACTER,INPUT piStartRow INTEGER,INPUT pcRowIdent CHARACTER,INPUT plNext LOGICAL,INPUT piRowsToReturn INTEGER,OUTPUT pioRowsReturned INTEGER,OUTPUT TABLE-HANDLE phRowObject,OUTPUT pocMessages CHARACTER   P�  h�  x�      remoteCommit    ,INPUT-OUTPUT pcContext CHARACTER,INPUT-OUTPUT TABLE-HANDLE phRowObjUpd,OUTPUT pcMessages CHARACTER,OUTPUT pcUndoIds CHARACTER  X�  �  �      refreshRow      ,       ��  0�  @�      printToCrystal  ,INPUT pcFieldList CHARACTER,INPUT plIncludeObj LOGICAL,INPUT piMaxRecords INTEGER       �  ��  ��      isUpdatePending ,INPUT-OUTPUT plUpdate LOGICAL  ��  ��   �      initializeServerObject  ,       ��  �   �      home    ,       �  8�  H�      genContextList  ,OUTPUT pcContext CHARACTER     (�  x�  ��      fetchPrev       ,       h�  ��  ��      fetchNext       ,       ��  ��  ��      fetchLast       ,       ��  ��   �      fetchFirst      ,       ��  �  (�      fetchBatch      ,INPUT plForwards LOGICAL       �  X�  p�      endClientDataRequest    ,       H�  ��  ��      destroyServerObject     ,       x�  ��  ��      describeSchema  ,INPUT pcSdoName CHARACTER,OUTPUT TABLE-HANDLE hTtSchema        ��  �  (�      dataAvailable   ,INPUT pcRelative CHARACTER     �  X�  h�      copyColumns     ,INPUT pcViewColList CHARACTER,INPUT phDataQuery HANDLE H�  ��  ��      commitTransaction       ,       ��  ��  ��      clientSendRows  ,INPUT piStartRow INTEGER,INPUT pcRowIdent CHARACTER,INPUT plNext LOGICAL,INPUT piRowsToReturn INTEGER,OUTPUT piRowsReturned INTEGER    ��  ��  ��      batchServices   ,INPUT pcServices CHARACTER,OUTPUT pcValues CHARACTER                �     
"         
   %          adecomm/as-utils.w     
"       
   �            }        �    
"         
         �             }        �    �        @   %                   �     
"        
   %                  �     �p  �                 8                  
�                            (     
�                    �     m     
"        
   
�h     T             %                  �             }        �G    G     %                  �     
"       
   x     �p     
�h     T             %                  �             }        �G    G     %                  
"       
   �                �    7    %                   
"       
   �                   �    1    �     }  
   �     �     %                   o%       o           �     �      
"       
   �                   �    1    �     �     �     �     %                   o%       o           �     �     
"       
   �                   (    1    �     �  
   �     �     %                   o%       o           �     �     
"       
   �                   �    1    �     �     �     �     %                   o%       o           �     �      
"       
   �                   X    1    �     �     �     �     %                   o%       o           �     �     
"       
   �                   �    1    �     �     �     �     %                   o%       o           %                   
"       
   �              �    1    �          �          
"       
   �                   �    1    �          �     �     %                   o%       o           �     .    
"       
   �                   x    1    �     0     �     �     %                   o%       o           �     ?  S   
"       
   �                       1    �     �     �     �     %                   o%       o           %                   
"       
   �                   �    1    �     �     �     �     %                   o%       o           %                   
"       
   �                   P	    1    �     �     �     �     %                   o%       o           %                  
"       
   �              �	    1    �     �     �     �     
"       
   �                   @
    1    �     �  
   �     �     %                   o%       o           %                   
"       
   �                   �
    1    �     �     �     �     %                   o%       o           �     �      
"       
   �              x    1    �     �     �          
"       
   �                   �    1    �     �     �     �     %                   o%       o           �     
  t   
"       
   �              `    1    �       
   �          
"       
   �                   �    1    �     �     �     �     %                   o%       o           �     �  �   
"       
   �                   H    1    �     (     �     �     %                   o%       o           �     �      
"       
   �                   �    1    �     ?  
   �     J     %                   o%       o           %                   
"       
   �                   �    1    �     N     �     �     %                   o%       o           %                  
"       
   �                        1    �     V     �     �     %                   o%       o           �     �      
"       
   �                   �    1    �     g     �     �     %                   o%       o           o%       o           
"       
   �                   X    1    �     w  
   �     �     %                   o%       o           �     �     
"       
   �                   �    1    �     �     �     �  	   %                   o%       o           �     �  /  
"       
   �              �    1    �     �     �     �  	   
"       
   �                   �    1    �     �     �     �  	   o%       o           o%       o           �     �     
"       
   �              p    1    �     �     �     �  	   
"       
   �                   �    1    �          �     �  	   o%       o           o%       o           �     �     
"       
   �              X    1    �          �     �     
"       
   �              �    1    �          �     �  	   
"       
   �              �    1    �     ,     �     �  	   
"       
   �              H    1    �     9     �     �  	   
"       
   �                   �    1    �     G     �     �     o%       o           o%       o           %                  
"       
   �              8    1    �     X     �     �  	   
"       
   �              �    1    �     f  
   �     q     
"       
   �              �    1    �     y     �     �  	   
"       
   �              (    1    �     �     �     �  	   
"       
   �              x    1    �     �     �     �  	   
"       
   �              �    1    �     �     �     �  	   
"       
   �                  1    �     �  	   �     �  	   
"       
   �              h    1    �     �     �     �  	   
"       
   �              �    1    �     �     �     �  	   
"       
   �                       1    �     �     �     �     %                   o%       o           o%       o           
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                    �    �     �       �           �                (    �    `            
� `  @     
�               8    �    �          p�                       �L    
�            %                  � `              H    �     @                          �                       
�            �     )     
"       
   � `  @     
�                    �    �     �  
   p�                       �L    "          x     �p     
�h     T             %                  �             }        �G    G     %                  
"       
   �                        1    �     ,  
   �     �     %                   o%       o           �     �      
"       
   �                   �    1    �     7  
   �     �     %                   o%       o           o%       o           
"       
   �                   8    1    �     B     �          %                   o%       o           o%       o           
"       
   �                   �    1    �     K     �     �     %                   o%       o           %                   
"       
   �                   x    1    �     Z     �     �     %                   o%       o           %                   
"       
   �                       1    �     g     �     �     %                   o%       o           �     �      
"       
   �                   �    1    �     n     �     �     %                   o%       o           %                  
"       
   �                   P     1    �     �     �     �     %                   o%       o           o%       o           
"       
   �                   �     1    �     �     �     �     %                   o%       o           o%       o           
"       
   �                   �!    1    �     �  	   �     �     %                   o%       o           �     �     
"       
   �                   ("    1    �     �     �     �     %                   o%       o           o%       o           
"       
   �                   �"    1    �     �     �     �     %                   o%       o           o%       o           
"       
   �                   h#    1    �     �     �     �     %                   o%       o           %                   
"       
   �                   $    1    �     �     �     �     %                   o%       o           o%       o           x     �p     
�h     T             %                  �             }        �G    G     %                  
"       
   �                   (%    1    �     �  
   �     �     %                   o%       o           %                  
"       
   �                   �%    1    �     �     �     �     %                   o%       o           o%       o           
"       
   �                   h&    1    �     �     �     �     %                   o%       o           �     �     
"       
   �                    '    1    �          �     �     %                   o%       o           o%       o           
"       
   �              �'    1    �          �          
"       
   �                   �'    1    �     !     �     �     %                   o%       o           �     4  !  
"       
   �                   �(    1    �     V     �     �     %                   o%       o           �     �     
"       
   �                    )    1    �     c     �     �     %                   o%       o           �     v    
"       
   �              �)    1    �     �     �     �     
"       
   �              *    1    �     �     �          
"       
   �                   X*    1    �     �     �     �     %                   o%       o           �     �     
"       
   �              �*    1    �     �  
   �          
"       
   �                   @+    1    �     �     �     �     %                   o%       o           o%       o           
"       
   �                   �+    1    �     �     �     �     %                   o%       o           %                   
"       
   �                   �,    1    �     �     �     �     %                   o%       o           %                   
"       
   �                    -    1    �     �     �     �     %                   o%       o           �     �      
"       
   �                   �-    1    �     �     �     �     %                   o%       o           o%       o           
"       
   �                   X.    1    �          �     �     %                   o%       o           %                  
"       
   �                   �.    1    �          �     �     %                   o%       o           %                   
"       
   �                   �/    1    �     )     �     �     %                   o%       o           %                   
"       
   �              80    1    �     9     �          
"       
   �              �0    1    �     F     �     �     
"       
   �                   �0    1    �     S     �     J     %                   o%       o           o%       o           
"       
   �                   x1    1    �     _     �     �     %                   o%       o           �     �     
"       
   �                   2    1    �     m     �     �     %                   o%       o           o%       o           
"       
   �                   �2    1    �     {     �     �     o%       o           o%       o           o%       o           
"       
   �                   P3    1    �     �     �     �  	   %                   o%       o           o%       o           
"       
   �                   �3    1    �     �     �     �     %                   o%       o           o%       o           
"       
   �                   �4    1    �     �  
   �     J     %                   o%       o           o%       o           
"       
   �              05    1    �     �     �     �     
"       
   �                   �5    1    �     �     �     �     %                   o%       o           �     �  4  
"       
   �                   6    1    �       
   �     �     %                   o%       o           %                  
"       
   �              �6    1    �     !     �          
"       
   �                   7    1    �     2     �     �     %                   o%       o           �     �      
"       
   �                   �7    1    �     @     �     �     %                   o%       o           %                  
"       
   �                   @8    1    �     O     �     �     %                   o%       o           �     �      
"       
   �                   �8    1    �     \     �     �     %                   o%       o           �     �      
"       
   �                   p9    1    �     j     �     �     %                   o%       o           �     �      
"       
   �                   :    1    �     v     �     �     %                   o%       o           %                   
"       
   �                   �:    1    �     �  	   �          %                   o%       o           o%       o           
"       
   �                   H;    1    �     �     �     �     %                   o%       o           �     �  	  
"       
   �                   �;    1    �     �     �     J     %                   o%       o           %           �       
"       
   �                   �<    1    �     �     �     �     %                   o%       o           �     �      
"       
   �                   =    1    �     �     �     �     o%       o           o%       o           %                  
"       
   �                   �=    1    �     �     �     �     %                   o%       o           %                   
"       
   �                   X>    1    �     �     �     �     %                   o%       o           o%       o           
"       
   �                   �>    1    �     �     �     �  	   %                   o%       o           �     �     
"       
   �              �?    1    �          �     �  	   x     �p     
�h     T             %                  �             }        �G    G     %                  
"       
   �                   `@    1    �       
   �     �     %                   o%       o           �     �      
"       
   �                   �@    1    �          �     �     %                   o%       o           %                   
"       
   �                   �A    1    �     +  	   �     �     %                   o%       o           �     �      
"       
   �                   0B    1    �     5     �     �     %                   o%       o           �     �      
"       
   �                   �B    1    �     C     �     �     %                   o%       o           %                   
"       
   �                   hC    1    �     S     �     �     %                   o%       o           �     �      
"       
   �                    D    1    �     f     �     �     %                   o%       o           o%       o           
"       
   �                   �D    1    �     n     �     �     %                   o%       o           o%       o           
"       
   �                   @E    1    �     {     �     �     %                   o%       o           o%       o           
"       
   �                   �E    1    �     �     �     �     %                   o%       o           o%       o           
"       
   �                   �F    1    �     �     �     �     %                   o%       o           o%       o           
"       
   �                    G    1    �     �     �     �     %                   o%       o           o%       o           
"       
   �                   �G    1    �     �  	   �     �  	   %                   o%       o           �     �     
"       
   �                   XH    1    �     �  
   �     �  	   %                   o%       o           �     �     
"       
   �                   �H    1    �     �     �     �     %                   o%       o           �     �     
"       
   �                   �I    1    �     �     �     �     %                   o%       o           o%       o           
"       
   �                   (J    1    �     �     �     �     %                   o%       o           o%       o           
"       
   �                   �J    1    �     �     �     �     %                   o%       o           �     �     
"       
   �                   `K    1    �          �     �     %                   o%       o           �     �     
"       
   �                   �K    1    �          �     �  	   %                   o%       o           o%       o           
"       
   �              �L    1    �     .     �          
"       
   �                   �L    1    �     :     �     �     %                   o%       o           �     �     
"       
   �                   �M    1    �     H     �     �     %                   o%       o           o%       o           
"       
   �                    N    1    �     [     �     �     %                   o%       o           o%       o           
"       
   �                   �N    1    �     m  
   �     �     %                   o%       o           �     �     
"       
   �                   XO    1    �     x     �     �     %                   o%       o           �     �     
"       
   �                   �O    1    �     �     �     �     %                   o%       o           %                   
"       
   �                   �P    1    �     �     �     �     %                   o%       o           o%       o           x     �p     
�h     T             %                  �             }        �G    G     %                  
"       
   �                   �Q    1    �     �  	   �          %                   o%       o           o%       o           
"       
   �                   PR    1    �     �     �          %                   o%       o           o%       o           
"       
   �                   �R    1    �     �     �          %                   o%       o           o%       o           
"       
   �                   �S    1    �     �     �     �     %                   o%       o           %                  
"       
   �                   0T    1    �     �     �     �     %                   o%       o           �       M   
"       
   �                   �T    1    �     V     �     �     %                   o%       o           %                  
"       
   �                   hU    1    �     g     �     �     %                   o%       o           %                   
"       
   �                   V    1    �     {     �     �     %                   o%       o           %                   
"       
   �                   �V    1    �     �     �     �  	   %                   o%       o           �     �      
"       
   �                   @W    1    �     �     �     �     %                   o%       o           %                   
"       
   �                   �W    1    �     �     �     �  	   %                   o%       o           o%       o           
"       
   �                   �X    1    �     �     �     �     o%       o           o%       o           %                  
"       
   �                    Y    1    �     �     �     �  	   o%       o           o%       o           �     �      
"       
   �                   �Y    1    �     �     �          o%       o           o%       o           o%       o           
"       
   �                   XZ    1    �     �     �          o%       o           o%       o           o%       o           
"       
   �                   �Z    1    �     �     �     �  	   o%       o           o%       o           o%       o           
"       
   �                   �[    1    �          �          o%       o           o%       o           o%       o           
"       
   �                   8\    1    �          �     �  	   o%       o           o%       o           �     ,    
"       
   �                   �\    1    �     .     �     �  	   o%       o           o%       o           �     =    
"       
   �                   h]    1    �     I     �     �     %                   o%       o           %                   
"       
   �                   ^    1    �     ]     �     �     %                   o%       o           %                   
"       
   �              �^    1    �     q     �     �  	   
"       
   �                   �^    1    �     �     �     �     %                   o%       o           %                   
"       
   �                   �_    1    �     �     �     �     %                   o%       o           o%       o           
"       
   �                   8`    1    �     �     �     �     %                   o%       o           o%       o           
"       
   �                   �`    1    �     �     �     �     %                   o%       o           o%       o           
"       
   �                   xa    1    �     �     �     �     %                   o%       o           �     �     
"       
   �                   b    1    �     �     �     �     %                   o%       o           %                   
"       
   �                   �b    1    �     �  	   �     �     %                   o%       o           %                        "          %          start-super-proc Nb    % t-su    adm2/smart.p    x     �p     
�h     T             %                  �             }        �G    G     %                  
"       
   �               0d    6    �     �     
"       
   
�                pd    8    
"       
   �                �d    �    �             }        �G     P                                         
"       
   G     %                  G     %                  %       AppService,ASInfo,ASUsePrompt,CacheDuration,CheckCurrentChanged,DestroyStateless,DisconnectAppServer,ServerOperatingMode,ShareData,UpdateFromSource,ForeignFields,ObjectName,OpenOnInit,PromptColumns,PromptOnDelete,RowsToBatch,RebuildOnRepos,ToggleDataTargets       
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                �f    �    �     �       �           �                g    �    `            
� `  @     
�               g    �    �          p�                       �L    
�            %                  � `              (g    �     @                          �                       
�            �     )     
"       
   p� `  @     
�               �h    �    �          p�                       �L    "      
    �            �     &     �     (     �             }        �A     0            |            "      
    �     &     %                  (` 0 �         @            |             �             }        �A    �     *     "                      "      
    "            `         "      
    "          @            |             �             }        �A    �     *     "          
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                �k    �    �     �       �           �                �k    �    `            
� `  @     
�               �k    �    �          p�                       �L    
�            %                  � `              �k    �     @                          �                       
�            �     )     
"       
   p� `  @     
�               �m    �    �     }  
   p�                       �L    "      
    
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                �n    �    �     �       �           �                �n    �    `            
� `  @     
�               �n    �    �          p�                       �L    
�            %                  � `              �n    �     @                          �                       
�            �     )     
"       
   p� `  @     
�               hp    �    �     �  
   p�                       �L    %        SmartDataObject 
"       
   p� `  @     
�               �p    �    �     �     p�                       �L    %                  
"       
   p� `  @     
�               �q    �    �          p�                       �L    %                  
"       
   p� `  @     
�               r    �    �     �     p�                       �L    (0                        �     �      �     �      �     �      �             }        �A    
�             }        �    
"       
    @           �     
"       
                �                s    �A    "          
"       
   
�                �s    �@         �     
"       
   "          �           }        �    
"       
   %                  %                        "          %          start-super-proc Nb    %  t-su    adm2/appserver.p        �             �     �     
�            �             }        �    %                   %          Server  -      �             }        �                "          �     �      %                               "          �     �      %          NONE    p�8  H                 (     "                  �     �     
�            
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                �v    �    �     �       �           �                �v    �    `            
� `  @     
�               �v    �    �          p�                       �L    
�            %                  � `              �v    �     @                          �                       
�            �     )     
"       
   p� `  @     
�               �x    �    �     �     p�                       �L    "          p�8  H                 (     "                  �     �     
�                 "          %          start-super-proc Ob    %  t-su    adm2/dataquery.p        
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                @z    �    �     �       �           �                Pz    �    `            
� `  @     
�               `z    �    �          p�                       �L    
�            %                  � `              pz    �     @                          �                       
�            �     )     
"       
   p� `  @     
�               (|    �    �     �     p�                       �L    %H    > 8   dataAvailable,confirmContinue,isUpdatePending,buildDataRequest  
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                X}    �    �     �       �           �                h}    �    `            
� `  @     
�               x}    �    �          p�                       �L    
�            %                  � `              �}    �     @                          �                       
�            �     )     
"       
   p� `  @     
�               @    �    �     �     p�                       �L    %                       "          %          start-super-proc Jb    % t-su    adm2/query.p    %          start-super-proc Jb    % t-su    adm2/queryext.p      "          %          start-super-proc Jb    % t-su    adm2/data.p     %          start-super-proc Jb    % t-su    adm2/dataext.p  %          start-super-proc Jb    %  t-su    adm2/dataextcols.p      %          start-super-proc Jb    %  t-su    adm2/dataextapi.p       
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                (�    �    �     �       �           �                8�    �    `            
� `  @     
�               H�    �    �          p�                       �L    
�            %                  � `              X�    �     @                          �                       
�            �     )     
"       
   p� `  @     
�               �    �    �     �     p�                       �L    %                  %          SUPER   �             �     �     
�            
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                P�    �    �     �       �           �                `�    �    `            
� `  @     
�               p�    �    �          p�                       �L    
�            %                  � `              ��    �     @                          �                       
�            �     )     
"       
   � `  @     
�               8�    �    �     V     p�                       �L    �            0 @                       "          �     �                  �             }        �    �     �     "          p�             �     �     
�            �             }        �    
�            
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                �    �    �     �       �           �                (�    �    `            
� `  @     
�               8�    �    �          p�                       �L    
�            %                  � `              H�    �     @                          �                       
�            �     )     
"       
   
� `  @     
�                �    �    �     =     p�                       �L      `                �     
"       
    8           �     
"       
   0     �             �     M     
"       
   
�             �     \     
�            �     
"       
   �             �     h     
"       
   �             �     |  	   
"       
   �             �     �     
"       
   %     	    adm-error b    %         unbindServer    
�            % ndSe    unconditional   p�8  H                 (     "                  �     �  	   
�            p�8  H                 (     "                  �     �     
�            p�8  H                 (     "                  �     �     
�            %          SUPER   %                   "          ���                   (     
"       
           "          p�             �     7     
�            
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                x�    �    �     �       �           �                ��    �    `            
� `  @     
�               ��    �    �          p�                       �L    
�            %                  � `              ��    �     @                          �                       
�            �     )     
"       
   
� `  @     
�               `�    �    �     �  	   p�                       �L    �     
"       
               %                  %                               "          %                  
"       
    H           "                       �                `�    �    %                  
"       
                �                ؒ    �    %                  
"       
   
�               0�    �    "          
"       
    �               h           "          (8                       "          %                  �     �      �     L     �                p�    �    
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                ��    �    �     �       �           �                ��    �    `            
� `  @     
�               Ȕ    �    �          p�                       �L    
�            %                  � `              ؔ    �     @                          �                       
�            �     )     
"       
   p� `  @     
�               ��    �    �     �     p�                       �L    "          "          "          %                                  �           �   p       ��                 �  �  �               �d                        O   ����    e�          O   ����    R�          O   ����    ��      ,                          �              �  $  �    ���                           �r     
                        � ߱                  �  �                      ��                   �  �                  �)d                    8     �  H      4   ����s      $  �    ���                           �s     
                        � ߱        �    �  X  h      �s          4   �����s      /  �  �                                   3   �����s  �  �   �  �s              O   �  ��  ��  (t               P          0  @   0                               
                                         �              ��                                    ����                                                    �           �   p       ��                  �  �  �               �Kd                        O   ����    e�          O   ����    R�          O   ����    ��      �  /   �  �                                     3   ������  ��                         ��     
                    ��                         H�                             � ߱        �  $   �  �   ���                                 �  �  �      ��          4   ������      �   �  H�                       x          X  h   0 8                                                                                       ��                                    ����                                                    �           �   p       ��                  �  �  �               �gd                        O   ����    e�          O   ����    R�          O   ����    ��            �  �   �       x�          4   ����x�      �   �  ��    ��                                    ����                                                    (          �   p       ��                 �  H  �               �ld                        O   ����    e�          O   ����    R�          O   ����    ��      ��     
                    X�                         �     
                        � ߱        X  $  �  �   ���                                 x  �      p�          4   ����p�                                      ��                    D                  Вd                             �  h  $   (  8  ���                            �     
                        � ߱        P    2  �    8  0�          4   ����0�                                      ��                  3  7                  H�d                           3  �  x  $   4  H  ���                           H�                             � ߱        �  $   5  �  ���                           x�                             � ߱            $   6    ���                           ��                             � ߱            O   9  ��  ��  ،  �  /  :  �     �  �                          3   ������            �                      3   ����(�  �  �   <  H�          �  �   ?  ��              �   B  ��          H  /   E  8                                    3   ����P�      O   G  ��  ��  h�              	 h            @  ( � �                
             
             
                                                       
                           
 (   8   H   X   h   x   �   �          
 (   8   H   X   h   x   �   �       ���   �                 ��                                    ����                                    TXS appSrvUtils gcUpdatable /vobs_possenet/src/adm2/dyndata.w should only be RUN PERSISTENT. ADDROW CANCELROW CANNAVIGATE CLOSEQUERY COLUMNPROPS COLVALUES COPYROW CREATEROW DELETEROW FETCHROW FETCHROWIDENT FINDROW FINDROWWHERE FIRSTROWIDS GETLASTCOMMITERRORTYPE HASFOREIGNKEYCHANGED OPENDATAQUERY OPENQUERY PREPAREQUERY ROWAVAILABLE ROWVALUES SUBMITROW UPDATEROW GETOBJECTTYPE xiRocketIndexLimit ADDQUERYWHERE ASSIGNQUERYSELECTION BUFFERCOMPAREDBTORO BUFFERWHERECLAUSE COLUMNDATATYPE COLUMNDBCOLUMN COLUMNQUERYSELECTION COLUMNTABLE COLUMNVALMSG DBCOLUMNDATANAME DBCOLUMNHANDLE EXCLUDECOLUMNS GETDATACOLUMNS GETFOREIGNVALUES GETQUERYPOSITION GETQUERYSORT GETQUERYSTRING GETQUERYWHERE GETTARGETPROCEDURE INDEXINFORMATION INSERTEXPRESSION NEWQUERYSTRING NEWQUERYVALIDATE NEWQUERYWHERE NEWWHERECLAUSE REFRESHROWIDENT REMOVEFOREIGNKEY REMOVEQUERYSELECTION RESOLVEBUFFER ROWIDWHERE ROWIDWHERECOLS SETQUERYPOSITION SETQUERYSORT SETQUERYSTRING SETQUERYWHERE WHERECLAUSEBUFFER GETAPPSERVICE GETASBOUND GETASDIVISION GETASHANDLE GETASHASSTARTED GETASINFO GETASINITIALIZEONRUN GETASUSEPROMPT GETSERVERFILENAME GETSERVEROPERATINGMODE RUNSERVERPROCEDURE SETAPPSERVICE SETASDIVISION SETASHANDLE SETASINFO SETASINITIALIZEONRUN SETASUSEPROMPT SETSERVERFILENAME SETSERVEROPERATINGMODE gshAstraAppserver gshSessionManager gshRIManager gshSecurityManager gshProfileManager gshRepositoryManager gshTranslationManager gshWebManager gscSessionId gsdSessionObj gshFinManager gshGenManager gshAgnManager gsdTempUniqueID gsdUserObj gsdRenderTypeObj gsdSessionScopeObj ghProp ghADMProps ghADMPropsBuf glADMLoadFromRepos glADMOk ANYMESSAGE ASSIGNLINKPROPERTY FETCHMESSAGES GETCHILDDATAKEY GETCONTAINERHANDLE GETCONTAINERHIDDEN GETCONTAINERSOURCE GETCONTAINERSOURCEEVENTS GETCONTAINERTYPE GETDATALINKSENABLED GETDATASOURCE GETDATASOURCEEVENTS GETDATASOURCENAMES GETDATATARGET GETDATATARGETEVENTS GETDBAWARE GETDESIGNDATAOBJECT GETDYNAMICOBJECT GETINSTANCEPROPERTIES GETLOGICALOBJECTNAME GETLOGICALVERSION GETOBJECTHIDDEN GETOBJECTINITIALIZED GETOBJECTNAME GETOBJECTPAGE GETOBJECTPARENT GETOBJECTVERSION GETOBJECTVERSIONNUMBER GETPARENTDATAKEY GETPASSTHROUGHLINKS GETPHYSICALOBJECTNAME GETPHYSICALVERSION GETPROPERTYDIALOG GETQUERYOBJECT GETRUNATTRIBUTE GETSUPPORTEDLINKS GETTRANSLATABLEPROPERTIES GETUIBMODE GETUSERPROPERTY INSTANCEPROPERTYLIST LINKHANDLES LINKPROPERTY MAPPEDENTRY MESSAGENUMBER PROPERTYTYPE REVIEWMESSAGES SETCHILDDATAKEY SETCONTAINERHIDDEN SETCONTAINERSOURCE SETCONTAINERSOURCEEVENTS SETDATALINKSENABLED SETDATASOURCE SETDATASOURCEEVENTS SETDATASOURCENAMES SETDATATARGET SETDATATARGETEVENTS SETDBAWARE SETDESIGNDATAOBJECT SETDYNAMICOBJECT SETINSTANCEPROPERTIES SETLOGICALOBJECTNAME SETLOGICALVERSION SETOBJECTNAME SETOBJECTPARENT SETOBJECTVERSION SETPARENTDATAKEY SETPASSTHROUGHLINKS SETPHYSICALOBJECTNAME SETPHYSICALVERSION SETRUNATTRIBUTE SETSUPPORTEDLINKS SETTRANSLATABLEPROPERTIES SETUIBMODE SETUSERPROPERTY SHOWMESSAGE SIGNATURE prepareInstance ObjectName CHAR  ObjectVersion ADM2.2 ObjectType SmartDataObject ContainerType PropertyDialog adm2/support/datad.w QueryObject LOGICAL ContainerHandle HANDLE InstanceProperties AppService,ASInfo,ASUsePrompt,CacheDuration,CheckCurrentChanged,DestroyStateless,DisconnectAppServer,ServerOperatingMode,ShareData,UpdateFromSource,ForeignFields,ObjectName,OpenOnInit,PromptColumns,PromptOnDelete,RowsToBatch,RebuildOnRepos,ToggleDataTargets SupportedLinks Data-Source,Data-Target,Navigation-Target,Update-Target,Commit-Target,Filter-Target ContainerHidden ObjectInitialized ObjectHidden ObjectsCreated HideOnInit UIBMode ContainerSource ContainerSourceEvents initializeObject,hideObject,viewObject,destroyObject,enableObject,confirmExit,confirmCancel,confirmOk,isUpdateActive DataSource DataSourceEvents dataAvailable,queryPosition,updateState,deleteComplete,fetchDataSet,confirmContinue,confirmCommit,confirmUndo,assignMaxGuess,isUpdatePending TranslatableProperties ObjectPage INT DBAware DesignDataObject DataSourceNames DataTarget DataTargetEvents CHARACTER updateState,rowObjectState,fetchBatch,LinkState LogicalObjectName PhysicalObjectName LogicalVersion PhysicalVersion DynamicObject RunAttribute ChildDataKey ParentDataKey DataLinksEnabled InactiveLinks InstanceId DECIMAL SuperProcedure SuperProcedureMode SuperProcedureHandle LayoutPosition ClassName RenderingProcedure ThinRenderingProcedure Label cType ADMProps Target WHERE Target = WIDGET-H(" ") AppService ASDivision ASHandle ASHasConnected ASHasStarted ASInfo ASInitializeOnRun ASUsePrompt BindSignature BindScope ServerOperatingMode ServerFileName ServerFirstCall NeedContext AutoCommit BLOBColumns BufferHandles CLOBColumns CommitSource CommitSourceEvents commitTransaction,undoTransaction CommitTarget CommitTargetEvents rowObjectState CurrentRowid ROWID CurrentUpdateSource DataColumns DataHandle DataIsFetched DataModified DataQueryBrowsed DataQueryString FetchOnOpen FillBatchOnRepos FilterActive FilterAvailable FilterSource FilterWindow FirstRowNum ForeignFields ForeignValues IgnoreTreeViewFilter IndexInformation LargeColumns LastRowNum NavigationSource NavigationSourceEvents fetchFirst,fetchNext,fetchPrev,fetchLast,startFilter OpenOnInit PrimarySDOSource PromptColumns PromptOnDelete QueryColumns QueryPosition QueryString RebuildOnRepos RowObject RowObjectState NoUpdates RowsToBatch Tables ToggleDataTargets TransferChildrenForAll UpdatableColumns UpdatableWhenNew UpdateSource AssignList AuditEnabled BaseQuery CalcFieldList CheckLastOnOpen DataColumnsByTable DBNames EntityFields FetchHasAudit FetchHasComment FetchAutoComment FirstResultRow KeyFields KeyTableId LastDBRowIdent LastResultRow NewBatchInfo NoLockReadOnlyTables PhysicalTables PositionForClient QueryHandle QueryRowIdent RequiredProperties SkipTransferDBRow TempTables UpdatableColumnsByTable UpdateFromSource WordIndexedFields RowObjUpd RowObjectTable RowObjUpdTable CheckCurrentChanged StatelessSavedProperties CheckCurrentChanged,RowObjectState,LastResultRow,FirstResultRow,QueryRowIdent DestroyStateless DisconnectAppServer ServerSubmitValidation DataFieldDefs QueryContainer QueryContext AsynchronousSDO DataLogicProcedure DataLogicObject DataReadHandler DataReadColumns DataReadBuffer DataDelimiter | DataReadFormat TrimNumeric IsRowObjectExternal IsRowObjUpdExternal ManualAddQueryWhere DynamicData LastCommitErrorType LastCommitErrorKeys RunDataLogicProxy SchemaLocation CacheDuration INTEGER ShareData ghContainer adm2/smart.p cObjectName iStart / \ . pcProcName hProc START-SUPER-PROC cAppService cASDivision cServerOperatingMode adm2/appserver.p getAppService Server NONE setASDivision setAppService adm2/dataquery.p dataAvailable,confirmContinue,isUpdatePending,buildDataRequest adm2/query.p adm2/queryext.p adm2/data.p adm2/dataext.p adm2/dataextcols.p adm2/dataextapi.p cDivision lDestroyStateless getASDivision SERVER WEBSPEED deleteProperties DESTROYOBJECT DISABLE_UI hRowObjectTable hRowObjUpdTable hAppServer cUpdColumns cColumnsByTable cTables hContainer lIsFetchPending Containersource IsFetchPending getASHandle getUpdatableColumns getTables getDataColumnsByTable adm-error unconditional setTables setUpdatableColumns setDataColumnsByTable INITIALIZEOBJECT GETUPDATABLECOLUMNS phHandle lOk i hField cColumns hRowObject createRowObjUpdTable , SETROWOBJECTTABLE pcUpdatableColumns SETUPDATABLECOLUMNS @  �*      P2      * @   ��      0         pcServices          ��      X         pcServices      �   ��      �         piStartRow      �   ��      �         piStartRow      �   ��      �         piStartRow        ��      �         piStartRow          ��               piStartRow      X  ��      H        pcViewColList       ��      p       
 pcViewColList       ��      �        pcRelative      �  ��      �        pcSdoName           ��      �  �     
 pcSdoName           ��              plForwards          ��      8        pcContext           ��      `        plUpdate        �  ��      �        pcFieldList     �  ��      �        pcFieldList         ��      �        pcFieldList       ��               pcContext       8  ��      (  �     
 pcContext       `  ��      P        pcContext           ��      x        pcContext       �  ��      �        piocContext     �  ��      �        piocContext        ��      �        piocContext     (  ��              piocContext     P  ��      @        piocContext     x  ��      h        piocContext     �  ��      �  �     
 piocContext         ��      �        piocContext         ��      �        pcState     ��               pcContext       8  ��      (  �     
 phRowObjUpd     `  ��      P        phRowObjUpd         ��      x        phRowObjUpd     �  ��      �        piStartRow      �  ��      �        piStartRow         ��      �        piStartRow      (  ��              piStartRow      P  ��      @        piStartRow          ��      h  �     
 piStartRow          ��      �  �     
 phRowObjUpd         ��      �        pcProperties    �  ��      �        piStartRow        ��              piStartRow      @  ��      0        piStartRow      h  ��      X        piStartRow      �  ��      �        piStartRow          ��      �  �     
 piStartRow      �  ��      �        pcRowIdent          ��      �        pcRowIdent      0  ��               pcRowIdent      X  ��      H        pcRowIdent          ��      p        pcRowIdent      �  ��      �        pcValueList         ��      �        pcValueList      	  ��      �        pcPropertiesForServer       ��      	        pcPropertiesForServer   X	  ��      H	        pcFieldList     �	  ��      p	        pcFieldList     �	  ��      �	        pcFieldList         ��      �	        pcFieldList     �	  ��      �	        pcWhere     ��      
        pcWhere     ��      (
        pcState     ��      H
       
 phRowObjUpd     �
  ��      p
       
 phRowObj        �
  ��      �
       
 phRowObj        �
  ��      �
        phRowObj            ��      �
        phRowObj            ��              pioCancel           ��      8        pcRelative          ��      `       
 phFilterContainer           ��      �       
 phRowObjUpd     �  ��      �        pcRowIdent          ��      �        pcRowIdent          ��             
 phAppService        ��      0        pcMode  `  ��      P       
 phSource        �  ��      x        phSource            ��      �       
 phSource        �  ��      �        pcText  �  ��      �        pcText      ��              pcText  8  ��      (       
 phObject        `  ��      P       
 phObject            ��      x        phObject            ��      �        pcField     ��      �        pcCursor        �  ��      �       
 phCaller           ��              phCaller        H  ��      8        phCaller            ��      `        phCaller        �  ��      �        pcMod   �  ��      �        pcMod       ��      �       
 pcMod   �  ��      �       
 phSource           ��              phSource            ��      8       
 phSource        h  ��      `        pdRow       ��      �        pdRow       ��      �       
 hTarget �  ��      �        pcMessage           ��      �        pcMessage           ��              plEnabled                 8         cType       �     X              p                  getObjectType   N	  f	  h	                �  
       hProc             �        pcProcName      @     	   Y   �  �                        start-super-proc        �  �  �  �  �  �  �  �  �      p        `         cDivision                 �         lDestroyStateless       �  �     Z   H          �                  destroyObject   �  �  �  �  �      �  8     [               (                  disable_UI      �  �  h        X  
       hRowObjectTable �        �  
       hRowObjUpdTable �        �  
       hAppServer      �        �         cUpdColumns             �         cColumnsByTable (                  cTables P        @  
       hContainer             	   h         lIsFetchPending �  �     \   @          �                  initializeObject        �      (  2  3  4  5  6  7  9  :  <  ?  B  D  E  G  H      x  X     ]               @                  getUpdatableColumns     X  Y  �        x         lOk     �        �         i       �        �  
       hField  �        �         cColumns                     
       hRowObject                (       
 phHandle          �     ^   `        h                  setRowObjectTable       l  n  o  p  z  �  �  �  �  �  �  �  �                �        pcUpdatableColumns      8  0     _       �                        setUpdatableColumns     �  �  �      �  �  �      p                              �          �  
       appSrvUtils     �       �         gcUpdatable     �       �         xiRocketIndexLimit                 
       gshAstraAppserver       P        8  
       gshSessionManager       x        h  
       gshRIManager    �        �  
       gshSecurityManager      �        �  
       gshProfileManager               �  
       gshRepositoryManager    8  	 	        
       gshTranslationManager   `  
 
     P  
       gshWebManager   �        x         gscSessionId    �        �         gsdSessionObj   �        �  
       gshFinManager            �  
       gshGenManager   (          
       gshAgnManager   P        @         gsdTempUniqueID x        h         gsdUserObj      �        �         gsdRenderTypeObj        �        �         gsdSessionScopeObj      �       �  
       ghProp            
       ghADMProps      H       8  
       ghADMPropsBuf   x       `         glADMLoadFromRepos      �       �         glADMOk �    	   �  
       ghContainer     �    
   �         cObjectName                      iStart  0                 cAppService     X       H         cASDivision              p         cServerOperatingMode             A   �   �   �   �           6  B  C  D  F  H  I  J  N  O  R  S  T  U  W  Y  [  ]  ^  _  b  d  e  g  h  i  j  k  q  s  y  {  }  ~  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  
  ?
  @
  B
  C
  D
  E
  F
  G
  I
  J
  K
  L
  M
  N
  O
  P
  Q
  R
  S
  T
  U
  V
  W
  X
  Y
  Z
  [
  \
  ]
  ^
  _
  `
  a
  c
  d
  e
  f
  g
  h
  i
  j
  k
  l
  m
  n
  o
  p
  q
  r
  s
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
                     	  
      ~  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  -  �  �  �  �  �  �  �  �  �      0  O  Q  f  �        /  0  1  4  5  6  =  >  [  o  �  !  "  .  R  �  �  �  �  �  �  �  �  �  �  �  �  �      ��  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/data.i        h  Ds ) /vobs_possenet/src/wrappers/fn       �  �) ( ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/datacustom.i   �  �:  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/query.i            ' ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/querycustom.i  `   �   '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/dataquery.i   �   �Z & ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/dataquerycustom.i      �   �< ! '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/appserver.i   8!  �� % ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/appservercustom.i      x!  I� " '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/smart.i       �!  tw $ ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/smartcustom.i  "  Q. # /vobs_possenet/src/wrappers/set      P"  �>  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/dataprop.i    �"  ��  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/datapropcustom.i       �"  ��  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/dataprtocustom.i       #  YO  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/qryprop.i     `#  -�  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/qrypropcustom.i        �#  ��  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/qryprtocustom.i        �#   	 '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/dataqueryprop.i       @$  �d  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/dataquerypropcustom.i  �$  ��  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/dataqueryprtocustom.i  �$  �l  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/appsprop.i    (%  ɏ  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/appspropcustom.i       h%  V  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/appsprtocustom.i       �%  i$  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/smrtprop.i    &  �j  /vobs_possenet/src/wrappers/get      H&  �  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/smrtpropcustom.i       x&  ��  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/smrtprtocustom.i       �&  ��  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/smrtprto.i    '  Su  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/globals.i     X'  M�  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/globalscustom.i        �'  )a  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/smartdefscustom.i      �'  �  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/appsprto.i    8(  ��  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/appserverdefscustom.i  x(  ��  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/dataqueryprto.i       �(  ª 
 ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/dataquerydefscustom.i  )  ��  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/qryprto.i     `)  �  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/querydefscustom.i      �)  �`  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/dataprto.i    �)  �  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/datadefscustom.i       0*  e�  /vobs_possenet/src/adecomm/appserv.i �*  �   /vobs_possenet/src/adm2/dyndata.w        0  �      �*     �  #   �*  '  �       +     r     +  �   2       +          0+  �         @+       )   P+  �   
      `+     �     p+  �   �      �+  �   �     �+     �  )   �+  �   �     �+     �     �+  �   �     �+     �     �+  �   �     �+     2  (    ,  �   �     ,     �  #    ,  k   �     0,  �   ;     @,     �  '   P,  g   �     `,  a   �      p,     n  &   �,  _   l      �,     J  #   �,  ]   H      �,     &  #   �,  I         �,  �   	  !   �,     �  %   �,  �   �  !    -     �  #   -  �   �  !    -     g  #   0-  �   e  !   @-     C  #   P-  g   )  !   `-     
     p-  O   �  !   �-  �   L  "   �-     �  $   �-  �   �  "   �-     �  #   �-  �   �  "   �-     �  #   �-  �   �  "   �-     �  #    .  �   �  "   .     ^  #    .  �   J  "   0.     (  #   @.  }     "   P.     �  #   `.     ~  "   p.     0  !   �.     �      �.     �     �.     6     �.  �   -     �.  O        �.          �.     �     �.  �   �      /  �   ~     /  O   p      /     _     0/          @/  y   �
     P/  �   �
  	   `/  G   �
     p/     �
     �/     w
     �/  c   
  	   �/  x   
     �/  M   �	     �/     �	     �/     �	     �/  a   �	     �/  �  e	      0     F	     0  �  	      0  O   	     00     �     @0     �     P0  �   �     `0     �     p0     �     �0  x   �     �0     �     �0     a     �0     ]     �0     I     �0     0     �0  Q         �0     �      1     �     1     z      1     `     01  ]   Z  	   @1     P     P1       	   `1     �  
   p1     �  	   �1  Z   �     �1     �     �1     �     �1     �     �1     �     �1  c   d     �1     B     �1     �       2     �      2     �       2     �      02  
   #       @2     
      