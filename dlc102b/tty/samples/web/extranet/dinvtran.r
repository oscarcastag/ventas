	��V�&K�7   �C                                              	� 378800EFundefined MAIN /vobs_prgs/src//pscade/samples/web/extranet/dinvtran.w,, PROCEDURE disable_UI,, PROCEDURE serverCommit,,INPUT-OUTPUT RowObjUpd TABLE,OUTPUT pcMessages CHARACTER,OUTPUT pcUndoIds CHARACTER PROCEDURE remoteCommit,,INPUT-OUTPUT pcContext CHARACTER,INPUT-OUTPUT RowObjUpd TABLE,OUTPUT pcMessages CHARACTER,OUTPUT pcUndoIds CHARACTER PROCEDURE pushTableAndValidate,,INPUT pcValType CHARACTER,INPUT-OUTPUT RowObjUpd TABLE PROCEDURE pushRowObjUpdTable,,INPUT RowObjUpd TABLE PROCEDURE initProps,, PROCEDURE start-super-proc,,INPUT pcProcName CHARACTER PROCEDURE adm-clone-props,, PROCEDURE viewObject,, PROCEDURE toggleData,,INPUT plEnabled LOGICAL PROCEDURE showMessageProcedure,,INPUT pcMessage CHARACTER,OUTPUT plAnswer LOGICAL PROCEDURE returnFocus,,INPUT hTarget HANDLE PROCEDURE repositionObject,,INPUT pdRow DECIMAL,INPUT pdCol DECIMAL PROCEDURE removeLink,,INPUT phSource HANDLE,INPUT pcLink CHARACTER,INPUT phTarget HANDLE PROCEDURE removeAllLinks,, PROCEDURE modifyUserLinks,,INPUT pcMod CHARACTER,INPUT pcLinkName CHARACTER,INPUT phObject HANDLE PROCEDURE modifyListProperty,,INPUT phCaller HANDLE,INPUT pcMode CHARACTER,INPUT pcListName CHARACTER,INPUT pcListValue CHARACTER PROCEDURE hideObject,, PROCEDURE exitObject,, PROCEDURE editInstanceProperties,, PROCEDURE displayLinks,, PROCEDURE createControls,, PROCEDURE changeCursor,,INPUT pcCursor CHARACTER PROCEDURE applyEntry,,INPUT pcField CHARACTER PROCEDURE adjustTabOrder,,INPUT phObject HANDLE,INPUT phAnchor HANDLE,INPUT pcPosition CHARACTER PROCEDURE addMessage,,INPUT pcText CHARACTER,INPUT pcField CHARACTER,INPUT pcTable CHARACTER PROCEDURE addLink,,INPUT phSource HANDLE,INPUT pcLink CHARACTER,INPUT phTarget HANDLE PROCEDURE unbindServer,,INPUT pcMode CHARACTER PROCEDURE runServerObject,,INPUT phAppService HANDLE PROCEDURE disconnectObject,, PROCEDURE destroyObject,, PROCEDURE bindServer,, PROCEDURE transferDBRow,,INPUT pcRowIdent CHARACTER,INPUT piRowNum INTEGER PROCEDURE startFilter,, PROCEDURE releaseDBRow,, PROCEDURE refetchDBRow,,INPUT phRowObjUpd HANDLE PROCEDURE filterContainerHandler,,INPUT phFilterContainer HANDLE PROCEDURE fetchDBRowForUpdate,, PROCEDURE confirmContinue,,INPUT-OUTPUT pioCancel LOGICAL PROCEDURE compareDBRow,, PROCEDURE bufferCopyDBToRO,,INPUT phRowObj HANDLE,INPUT phBuffer HANDLE,INPUT pcExcludes CHARACTER,INPUT pcAssigns CHARACTER PROCEDURE assignDBRow,,INPUT phRowObjUpd HANDLE PROCEDURE updateState,,INPUT pcState CHARACTER PROCEDURE updateQueryPosition,, PROCEDURE updateAddQueryWhere,,INPUT pcWhere CHARACTER,INPUT pcField CHARACTER PROCEDURE undoTransaction,, PROCEDURE transferToExcel,,INPUT pcFieldList CHARACTER,INPUT plIncludeObj LOGICAL,INPUT plUseExisting LOGICAL,INPUT piMaxRecords INTEGER PROCEDURE synchronizeProperties,,INPUT pcPropertiesForServer CHARACTER,OUTPUT pcPropertiesForClient CHARACTER PROCEDURE submitValidation,,INPUT pcValueList CHARACTER,INPUT pcUpdColumns CHARACTER PROCEDURE submitForeignKey,,INPUT pcRowIdent CHARACTER,INPUT-OUTPUT pcValueList CHARACTER,INPUT-OUTPUT pcUpdColumns CHARACTER PROCEDURE submitCommit,,INPUT pcRowIdent CHARACTER,INPUT plReopen LOGICAL PROCEDURE startServerObject,, PROCEDURE setPropertyList,,INPUT pcProperties CHARACTER PROCEDURE serverFetchRowObjUpdTable,,OUTPUT phRowObjUpd TABLE-HANDLE PROCEDURE serverSendRows,,INPUT piStartRow INTEGER,INPUT pcRowIdent CHARACTER,INPUT plNext LOGICAL,INPUT piRowsToReturn INTEGER,OUTPUT piRowsReturned INTEGER,OUTPUT phRowObject TABLE-HANDLE PROCEDURE saveContextAndDestroy,,OUTPUT pcContext CHARACTER PROCEDURE rowObjectState,,INPUT pcState CHARACTER PROCEDURE retrieveFilter,, PROCEDURE restartServerObject,, PROCEDURE remoteSendRows,,INPUT-OUTPUT piocContext CHARACTER,INPUT piStartRow INTEGER,INPUT pcRowIdent CHARACTER,INPUT plNext LOGICAL,INPUT piRowsToReturn INTEGER,OUTPUT pioRowsReturned INTEGER,OUTPUT phRowObject TABLE-HANDLE,OUTPUT pocMessages CHARACTER PROCEDURE refreshRow,, PROCEDURE printToCrystal,,INPUT pcFieldList CHARACTER,INPUT plIncludeObj LOGICAL,INPUT piMaxRecords INTEGER PROCEDURE isUpdatePending,,INPUT-OUTPUT plUpdate LOGICAL PROCEDURE initializeServerObject,, PROCEDURE initializeObject,, PROCEDURE home,, PROCEDURE genContextList,,OUTPUT pcContext CHARACTER PROCEDURE fetchPrev,, PROCEDURE fetchNext,, PROCEDURE fetchLast,, PROCEDURE fetchFirst,, PROCEDURE fetchBatch,,INPUT plForwards LOGICAL PROCEDURE endClientDataRequest,, PROCEDURE destroyServerObject,, PROCEDURE describeSchema,,INPUT pcSdoName CHARACTER,OUTPUT hTtSchema TABLE-HANDLE PROCEDURE dataAvailable,,INPUT pcRelative CHARACTER PROCEDURE copyColumns,,INPUT pcViewColList CHARACTER,INPUT phDataQuery HANDLE PROCEDURE commitTransaction,, PROCEDURE clientSendRows,,INPUT piStartRow INTEGER,INPUT pcRowIdent CHARACTER,INPUT plNext LOGICAL,INPUT piRowsToReturn INTEGER,OUTPUT piRowsReturned INTEGER PROCEDURE batchServices,,INPUT pcServices CHARACTER,OUTPUT pcValues CHARACTER FUNCTION deleteRecordStatic,logical,INPUT piTableIndex INTEGER FUNCTION getRowObjUpdStatic,widget-handle, FUNCTION Signature,CHARACTER,INPUT pcName CHARACTER FUNCTION showmessage,LOGICAL,INPUT pcMessage CHARACTER FUNCTION setUserProperty,LOGICAL,INPUT pcPropName CHARACTER,INPUT pcPropValue CHARACTER FUNCTION setUIBMode,LOGICAL,INPUT pcMode CHARACTER FUNCTION setTranslatableProperties,LOGICAL,INPUT pcPropList CHARACTER FUNCTION setSupportedLinks,LOGICAL,INPUT pcLinkList CHARACTER FUNCTION setRunAttribute,LOGICAL,INPUT cRunAttribute CHARACTER FUNCTION setPhysicalVersion,LOGICAL,INPUT cVersion CHARACTER FUNCTION setPhysicalObjectName,LOGICAL,INPUT cTemp CHARACTER FUNCTION setPassThroughLinks,LOGICAL,INPUT pcLinks CHARACTER FUNCTION setParentDataKey,LOGICAL,INPUT cParentDataKey CHARACTER FUNCTION setObjectVersion,LOGICAL,INPUT cObjectVersion CHARACTER FUNCTION setObjectParent,LOGICAL,INPUT phParent HANDLE FUNCTION setObjectName,LOGICAL,INPUT pcName CHARACTER FUNCTION setLogicalVersion,LOGICAL,INPUT cVersion CHARACTER FUNCTION setLogicalObjectName,LOGICAL,INPUT c CHARACTER FUNCTION setInstanceProperties,LOGICAL,INPUT pcPropList CHARACTER FUNCTION setDynamicObject,LOGICAL,INPUT lTemp LOGICAL FUNCTION setDesignDataObject,LOGICAL,INPUT pcDataObject CHARACTER FUNCTION setDBAware,LOGICAL,INPUT lAware LOGICAL FUNCTION setDataTargetEvents,LOGICAL,INPUT pcEvents CHARACTER FUNCTION setDataTarget,LOGICAL,INPUT pcTarget CHARACTER FUNCTION setDataSourceNames,LOGICAL,INPUT pcSourceNames CHARACTER FUNCTION setDataSourceEvents,LOGICAL,INPUT pcEventsList CHARACTER FUNCTION setDataSource,LOGICAL,INPUT phObject HANDLE FUNCTION setDataLinksEnabled,LOGICAL,INPUT lDataLinksEnabled LOGICAL FUNCTION setContainerSourceEvents,LOGICAL,INPUT pcEvents CHARACTER FUNCTION setContainerSource,LOGICAL,INPUT phObject HANDLE FUNCTION setContainerHidden,LOGICAL,INPUT plHidden LOGICAL FUNCTION setChildDataKey,LOGICAL,INPUT cChildDataKey CHARACTER FUNCTION reviewMessages,CHARACTER, FUNCTION propertyType,CHARACTER,INPUT pcPropName CHARACTER FUNCTION messageNumber,CHARACTER,INPUT piMessage INTEGER FUNCTION mappedEntry,CHARACTER,INPUT pcEntry CHARACTER,INPUT pcList CHARACTER,INPUT plFirst LOGICAL,INPUT pcDelimiter CHARACTER FUNCTION linkProperty,CHARACTER,INPUT pcLink CHARACTER,INPUT pcPropName CHARACTER FUNCTION linkHandles,CHARACTER,INPUT pcLink CHARACTER FUNCTION instancePropertyList,CHARACTER,INPUT pcPropList CHARACTER FUNCTION getUserProperty,CHARACTER,INPUT pcPropName CHARACTER FUNCTION getUIBMode,CHARACTER, FUNCTION getTranslatableProperties,CHARACTER, FUNCTION getSupportedLinks,CHARACTER, FUNCTION getRunAttribute,CHARACTER, FUNCTION getQueryObject,LOGICAL, FUNCTION getPropertyDialog,CHARACTER, FUNCTION getPhysicalVersion,CHARACTER, FUNCTION getPhysicalObjectName,CHARACTER, FUNCTION getPassThroughLinks,CHARACTER, FUNCTION getParentDataKey,CHARACTER, FUNCTION getObjectVersionNumber,CHARACTER, FUNCTION getObjectVersion,CHARACTER, FUNCTION getObjectParent,HANDLE, FUNCTION getObjectPage,INTEGER, FUNCTION getObjectName,CHARACTER, FUNCTION getObjectInitialized,LOGICAL, FUNCTION getObjectHidden,LOGICAL, FUNCTION getLogicalVersion,CHARACTER, FUNCTION getLogicalObjectName,CHARACTER, FUNCTION getInstanceProperties,CHARACTER, FUNCTION getDynamicObject,LOGICAL, FUNCTION getDesignDataObject,CHARACTER, FUNCTION getDBAware,LOGICAL, FUNCTION getDataTargetEvents,CHARACTER, FUNCTION getDataTarget,CHARACTER, FUNCTION getDataSourceNames,CHARACTER, FUNCTION getDataSourceEvents,CHARACTER, FUNCTION getDataSource,HANDLE, FUNCTION getDataLinksEnabled,LOGICAL, FUNCTION getContainerType,CHARACTER, FUNCTION getContainerSourceEvents,CHARACTER, FUNCTION getContainerSource,HANDLE, FUNCTION getContainerHidden,LOGICAL, FUNCTION getContainerHandle,HANDLE, FUNCTION getChildDataKey,CHARACTER, FUNCTION fetchMessages,CHARACTER, FUNCTION assignLinkProperty,LOGICAL,INPUT pcLink CHARACTER,INPUT pcPropName CHARACTER,INPUT pcPropValue CHARACTER FUNCTION anyMessage,LOGICAL, FUNCTION setServerOperatingMode,LOGICAL,INPUT pcServerOperatingMode CHARACTER FUNCTION setServerFileName,LOGICAL,INPUT pcFileName CHARACTER FUNCTION setASUsePrompt,LOGICAL,INPUT plFlag LOGICAL FUNCTION setASInitializeOnRun,LOGICAL,INPUT plInitialize LOGICAL FUNCTION setASInfo,LOGICAL,INPUT pcInfo CHARACTER FUNCTION setASHandle,LOGICAL,INPUT phASHandle HANDLE FUNCTION setASDivision,LOGICAL,INPUT pcDivision CHARACTER FUNCTION setAppService,LOGICAL,INPUT pcAppService CHARACTER FUNCTION runServerProcedure,HANDLE,INPUT pcServerFileName CHARACTER,INPUT phAppService HANDLE FUNCTION getServerOperatingMode,CHARACTER, FUNCTION getServerFileName,CHARACTER, FUNCTION getASUsePrompt,LOGICAL, FUNCTION getASInitializeOnRun,LOGICAL, FUNCTION getASInfo,CHARACTER, FUNCTION getASHasStarted,LOGICAL, FUNCTION getASHandle,HANDLE, FUNCTION getAsDivision,CHARACTER, FUNCTION getASBound,LOGICAL, FUNCTION getAppService,CHARACTER, FUNCTION whereClauseBuffer,CHARACTER,INPUT pcWhere CHARACTER FUNCTION setQueryWhere,LOGICAL,INPUT pcWhere CHARACTER FUNCTION setQueryString,LOGICAL,INPUT pcQueryString CHARACTER FUNCTION setQuerySort,LOGICAL,INPUT pcSort CHARACTER FUNCTION setQueryPosition,LOGICAL,INPUT pcPosition CHARACTER FUNCTION rowidWhereCols,CHARACTER,INPUT pcColumns CHARACTER,INPUT pcValues CHARACTER,INPUT pcOperators CHARACTER FUNCTION rowidWhere,CHARACTER,INPUT pcWhere CHARACTER FUNCTION resolveBuffer,CHARACTER,INPUT pcBuffer CHARACTER FUNCTION removeQuerySelection,LOGICAL,INPUT pcColumns CHARACTER,INPUT pcOperators CHARACTER FUNCTION removeForeignKey,LOGICAL, FUNCTION refreshRowident,CHARACTER,INPUT pcRowident CHARACTER FUNCTION newWhereClause,CHARACTER,INPUT pcBuffer CHARACTER,INPUT pcExpression CHARACTER,INPUT pcWhere CHARACTER,INPUT pcAndOr CHARACTER FUNCTION newQueryWhere,CHARACTER,INPUT pcWhere CHARACTER FUNCTION newQueryValidate,CHARACTER,INPUT pcQueryString CHARACTER,INPUT pcExpression CHARACTER,INPUT pcBuffer CHARACTER,INPUT pcAndOr CHARACTER FUNCTION newQueryString,CHARACTER,INPUT pcColumns CHARACTER,INPUT pcValues CHARACTER,INPUT pcOperators CHARACTER,INPUT pcQueryString CHARACTER,INPUT pcAndOr CHARACTER FUNCTION insertExpression,CHARACTER,INPUT pcWhere CHARACTER,INPUT pcExpression CHARACTER,INPUT pcAndOr CHARACTER FUNCTION indexInformation,CHARACTER,INPUT pcQuery CHARACTER,INPUT plUseTableSep LOGICAL,INPUT pcIndexInfo CHARACTER FUNCTION getTargetProcedure,HANDLE, FUNCTION getQueryWhere,CHARACTER, FUNCTION getQueryString,CHARACTER, FUNCTION getQuerySort,CHARACTER, FUNCTION getQueryPosition,CHARACTER, FUNCTION getForeignValues,CHARACTER, FUNCTION getDataColumns,CHARACTER, FUNCTION excludeColumns,CHARACTER,INPUT iTable INTEGER FUNCTION dbColumnHandle,HANDLE,INPUT pcColumn CHARACTER FUNCTION dbColumnDataName,CHARACTER,INPUT pcDbColumn CHARACTER FUNCTION columnValMsg,CHARACTER,INPUT pcColumn CHARACTER FUNCTION columnTable,CHARACTER,INPUT pcColumn CHARACTER FUNCTION columnQuerySelection,CHARACTER,INPUT pcColumn CHARACTER FUNCTION columnDbColumn,CHARACTER,INPUT pcColumn CHARACTER FUNCTION columnDataType,CHARACTER,INPUT pcColumn CHARACTER FUNCTION bufferWhereClause,CHARACTER,INPUT pcBuffer CHARACTER,INPUT pcWhere CHARACTER FUNCTION bufferCompareDBToRO,LOGICAL,INPUT phRowObjUpd HANDLE,INPUT phBuffer HANDLE,INPUT pcExcludes CHARACTER,INPUT pcAssigns CHARACTER FUNCTION assignQuerySelection,LOGICAL,INPUT pcColumns CHARACTER,INPUT pcValues CHARACTER,INPUT pcOperators CHARACTER FUNCTION addQueryWhere,LOGICAL,INPUT pcWhere CHARACTER,INPUT pcBuffer CHARACTER,INPUT pcAndOr CHARACTER FUNCTION getObjectType,character, FUNCTION updateRow,LOGICAL,INPUT pcKeyValues CHARACTER,INPUT pcValueList CHARACTER FUNCTION submitRow,LOGICAL,INPUT pcRowIdent CHARACTER,INPUT pcValueList CHARACTER FUNCTION rowValues,CHARACTER,INPUT pcColumns CHARACTER,INPUT pcFormat CHARACTER,INPUT pcDelimiter CHARACTER FUNCTION rowAvailable,LOGICAL,INPUT pcDirection CHARACTER FUNCTION prepareQuery,LOGICAL,INPUT pcQuery CHARACTER FUNCTION openQuery,LOGICAL, FUNCTION openDataQuery,LOGICAL,INPUT pcPosition CHARACTER FUNCTION hasForeignKeyChanged,LOGICAL, FUNCTION getLastCommitErrorType,CHARACTER, FUNCTION firstRowIds,CHARACTER,INPUT pcQueryString CHARACTER FUNCTION findRowWhere,LOGICAL,INPUT pcColumns CHARACTER,INPUT pcValues CHARACTER,INPUT pcOperators CHARACTER FUNCTION findRow,LOGICAL,INPUT pcKeyValues CHARACTER FUNCTION fetchRowIdent,CHARACTER,INPUT pcRowIdent CHARACTER,INPUT pcViewColList CHARACTER FUNCTION fetchRow,CHARACTER,INPUT piRow INTEGER,INPUT pcViewColList CHARACTER FUNCTION deleteRow,LOGICAL,INPUT pcRowIdent CHARACTER FUNCTION createRow,LOGICAL,INPUT pcValueList CHARACTER FUNCTION copyRow,CHARACTER,INPUT pcViewColList CHARACTER FUNCTION colValues,CHARACTER,INPUT pcViewColList CHARACTER FUNCTION columnProps,CHARACTER,INPUT pcColList CHARACTER,INPUT pcPropList CHARACTER FUNCTION closeQuery,LOGICAL, FUNCTION canNavigate,LOGICAL, FUNCTION cancelRow,CHARACTER, FUNCTION addRow,CHARACTER,INPUT pcViewColList CHARACTER TEMP-TABLE RowObjUpd 0,RowNum:RowNum 0 NO,BinNum integer 0 0,InvType character 1 0,Itemnum integer 2 0,Ordernum integer 3 0,InvTransNum integer 4 0,PONum integer 5 0,Qty integer 6 0,TransDate date 7 0,Transtime character 8 0,WarehouseNum integer 9 0,RowNum integer 10 0,RowIdent character 11 0,RowMod character 12 0,RowIdentIdx character 13 0,RowUserProp character 14 0,ChangedFields character 15 0         �%              �&             �> �%               0�              PE     +   ��   W   �� �  X   x�   Y   � (  [   � H  \   � �  ]   � p  ^     H  `   ? H q  undefined                                                                        (  �$    �                                      �                   P�                %  X    �   ��   ��              �  �   H%      X%          �                                             PROGRESS                         P            
        
                        �              �                                                                                                     
                   sports2000                       PROGRESS                         �        �                                ��&K               ��                              �  x                      �  �  M 
     INVTRANSNUMWAREHOUSENUMBINNUMQTYITEMNUMTRANSDATEINVTYPEPONUMORDERNUMTRANSTIME                                                                         	          
                            �  
        
                      h  @             �                                                                                                    
      �        8  
        
                         �             �                                                                                                    
      x  0      �  
        
                      �  �             `                                                                                          0          
      0  =      �  
        
                      �  h                                                                                                       =          
      �  P      `  
        
                      H                �                                                                                          P          
      �  b        
        
                         �  	           �                                                                                          b          
      X  w      �  
        
                      �  �  
           @                                                                                          w          
      	  �      �  
        
                      p  H	             �                                                                                          �          
      �	  �      @	                                 (	   
             �	                                                                                          �                �
  �      �	                                �	  �
             h
                                                                                          �                8  �      �
  
        
                      �
  p                                                                                                        �          
      �  �      h  
        
                      P  (             �                                                                                          �          
      �  �         
        
                        �             �                                                                                          �          
      `  �      �                                �  �             H                                                                                          �                  �      �                                x  P                                                                                                        �                �  �      H                                0               �                                                                                          �                                                           �  �             p                                                                                                          �         �       �  H  �  %   �  �  �                �             �          �      �              �       �  X  �#  &   $  �  j_      p$         �         �    `          �      �                 ��                                                   ��          �  8  P p�                    �         
             
             
                                         
                                                                                                               
             
                                          P   `   p   �   �   �   �   �   �   �   �           0  @  P  `          P   `   p   �   �   �   �   �   �   �   �          0  @  P  `                                                                                                                                         	                  
                                                                                                                                             �  �  �  �              �             �  �  �  �              �                    0      P  8  p             �  �  �  �              �             �  �                   (             P  X  h  p              x             �  �  �  �              �             �  �  �                             0  @  H  X                             `  p  �  �              �             �  �  �  �                             �  �                                        (  0                             8  H  P  `                             h  x  �  �                                                                          BinNum  zzzzzzzzz9      Bin Num 0       Please enter a bin number.      InvType X(12)   Type            Please enter the type.  Itemnum zzzzzzzzz9      Item Num        0       Item must be on file.   CAN-FIND ( item OF RowObject )  Please enter an item number     Ordernum        zzzzzzzzz9      Order Num       0       Please Enter an Order Number    InvTransNum     zzzzzzzzz9      Inventory Trans Num     0       Please enter an inventory trans number  PONum   zzzzzzzzz9      PO Num  0       Please enter a PO Number.       Qty     ->>>>9  Qty     0       Please enter the quantity.      TransDate       99/99/9999      Trans Date      ?       Please enter the trans date.    Transtime       X(5)    Trans Time              WarehouseNum    zzzzzzzzz9      Warehouse Num   0       Please enter the Warehouse Number.      RowNum  ->,>>>,>>9      RowNum  0       RowIdent        x(8)    RowIdent                RowMod  x(8)    RowMod          RowIdentIdx     x(8)    RowIdentIdx             RowUserProp     x(8)    RowUserProp             �  �  ���������       �              �                                �     i     i     i     	 	 	        �  �  �  �  �  �  �  �  �  �  �        !                                                                                                                                         	                  
                                                                                                                                                                   �  �  �  �              �             �  �                                   (   0   @   P       p   X   �              �   �   �   �               �              !  !  (!  @!              H!             p!  x!  �!  �!              �!             �!  �!  �!  �!              �!             �!  "  "  ("              0"             P"  `"  h"  x"                             �"  �"  �"  �"              �"             �"  �"  �"   #                             #  #   #  0#                              8#  @#  H#  P#                             X#  h#  p#  �#                             �#  �#  �#  �#                              �#  �#  �#  �#                                                                              BinNum  zzzzzzzzz9      Bin Num 0       Please enter a bin number.      InvType X(12)   Type            Please enter the type.  Itemnum zzzzzzzzz9      Item Num        0       Item must be on file.   CAN-FIND ( item OF RowObject )  Please enter an item number     Ordernum        zzzzzzzzz9      Order Num       0       Please Enter an Order Number    InvTransNum     zzzzzzzzz9      Inventory Trans Num     0       Please enter an inventory trans number  PONum   zzzzzzzzz9      PO Num  0       Please enter a PO Number.       Qty     ->>>>9  Qty     0       Please enter the quantity.      TransDate       99/99/9999      Trans Date      ?       Please enter the trans date.    Transtime       X(5)    Trans Time              WarehouseNum    zzzzzzzzz9      Warehouse Num   0       Please enter the Warehouse Number.      RowNum  ->,>>>,>>9      RowNum  0       RowIdent        x(8)    RowIdent                RowMod  x(8)    RowMod          RowIdentIdx     x(8)    RowIdentIdx             RowUserProp     x(8)    RowUserProp             ChangedFields   x(8)    ChangedFields           �  �  ���������       �              �                                �     i     i     i     	 	 	        �  �  �  �  �  �  �  �  �  �  �        !  -    ��                                    ����                                    -    ��                    H�    f   ��                    �Q    undefined                                                                       �       ��  �   p   ��  ��                    �����               hH�                         O   ����    e�          O   ����    R�          O   ����    ��      �       �   �                  4   ����   (  /                                        3   ����(       $     X  ���                           P      
                           � ߱        �  �      `           �     N              �    �   �  X      �           4   �����                 h                      ��                  �   �                   �b�                            �   �  �  	  �   �                                            3   �����       O   �   ��  ��  �   batchServices                               `  H      ��                  d  g  x              ���                         O   ����    e�          O   ����    R�          O   ����    ��            ��       �             �                   ��                      �               ��                                    ����                                    clientSendRows                              �  �      ��                  i  o  �              ���                         O   ����    e�          O   ����    R�          O   ����    ��            ��       H                                ��       x             8                   ��       �             h                   ��       �             �                   ��                      �               ��                                    ����                                    commitTransaction                                   �  �      ��                  q  r                 p�                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    copyColumns                                    �      ��                  t  w                ��                         O   ����    e�          O   ����    R�          O   ����    ��            ��       p             0                   �� 
                     `  
             ��                                    ����                                    dataAvailable                               x	  `	      ��                  y  {  �	              ��                         O   ����    e�          O   ����    R�          O   ����    ��            ��                      �	               ��                                    ����                                    describeSchema                              �
  �
      ��                  }  �  �
              ��                         O   ����    e�          O   ����    R�          O   ����    ��            ��       0             �
                   �� 
              �          
             ��                                    ����                                    destroyServerObject                                 @  (      ��                  �  �  X               $�                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    endClientDataRequest                                `  H      ��                  �  �  x              �(�                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    fetchBatch                                  x  `      ��                  �  �  �              X-�                         O   ����    e�          O   ����    R�          O   ����    ��            ��                      �               ��                                    ����                                    fetchFirst                                  �  �      ��                  �  �  �              P4�                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    fetchLast                                   �  �      ��                  �  �  �              �I�                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    fetchNext                                   �  �      ��                  �  �                N�                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    fetchPrev                                     �      ��                  �  �                 �R�                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    genContextList                                       ��                  �  �  8              @W�                         O   ����    e�          O   ����    R�          O   ����    ��            ��                      P               ��                                    ����                                    home                                `  H      ��                  �  �  x              �^�                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    initializeObject                                    �  h      ��                  �  �  �              (c�                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    initializeServerObject                              �  �      ��                  �  �  �              �g�                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    isUpdatePending                             �  �      ��                  �  �  �              �l�                         O   ����    e�          O   ����    R�          O   ����    ��            ��                      �               ��                                    ����                                    printToCrystal                                 �      ��                  �  �                �s�                         O   ����    e�          O   ����    R�          O   ����    ��            ��       p             0                   ��       �             `                   ��                      �               ��                                    ����                                    refreshRow                                  �  �      ��                  �  �  �              ��                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    remoteSendRows                              �  �      ��                  �  �  �              0��                         O   ����    e�          O   ����    R�          O   ����    ��            ��       0             �                   ��       `                                 ��       �             P                   ��       �             �                   ��       �             �                   ��                     �                   �� 
      P      �         
                 ��                      @               ��                                    ����                                    restartServerObject                                 `  H      ��                  �  �  x              8��                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    retrieveFilter                              x   `       ��                  �  �  �                ��                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    rowObjectState                              �!  x!      ��                  �  �  �!              ���                         O   ����    e�          O   ����    R�          O   ����    ��            ��                      �!               ��                                    ����                                    saveContextAndDestroy                               �"  �"      ��                  �  �  �"              ��                         O   ����    e�          O   ����    R�          O   ����    ��            ��                      #               ��                                    ����                                    serverSendRows                              ($  $      ��                  �  �  @$              ���                         O   ����    e�          O   ����    R�          O   ����    ��            ��       �$             X$                   ��       �$             �$                   ��       �$             �$                   ��       (%             �$                   ��       X%             %                   �� 
              �       H%  
             ��                                    ����                                    serverFetchRowObjUpdTable                                   p&  X&      ��                  �  �  �&              ���                         O   ����    e�          O   ����    R�          O   ����    ��            �� 
              �       �&  
             ��                                    ����                                    setPropertyList                             �'  �'      ��                  �  �  �'              ���                         O   ����    e�          O   ����    R�          O   ����    ��            ��                      �'               ��                                    ����                                    serverSendRows                               )  �(      ��                  �  �  )              ��                         O   ����    e�          O   ����    R�          O   ����    ��            ��       p)             0)                   ��       �)             `)                   ��       �)             �)                   ��        *             �)                   ��       0*             �)                   �� 
              �        *  
             ��                                    ����                                    startServerObject                                   @+  (+      ��                  �  �  X+              �]�                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    submitCommit                                X,  @,      ��                  �  �  p,              @b�                         O   ����    e�          O   ����    R�          O   ����    ��            ��       �,             �,                   ��                      �,               ��                                    ����                                    submitForeignKey                                    �-  �-      ��                  �    �-              �k�                         O   ����    e�          O   ����    R�          O   ����    ��            ��       H.             .                   ��       x.             8.                   ��                      h.               ��                                    ����                                    submitValidation                                    �/  p/      ��                      �/              xw�                         O   ����    e�          O   ����    R�          O   ����    ��            ��       �/             �/                   ��                      �/               ��                                    ����                                    synchronizeProperties                               1  �0      ��                  	     1              P��                         O   ����    e�          O   ����    R�          O   ����    ��            ��       x1             81                   ��                      h1               ��                                    ����                                    transferToExcel                             �2  h2      ��                      �2              H��                         O   ����    e�          O   ����    R�          O   ����    ��            ��       �2             �2                   ��        3             �2                   ��       P3             3                   ��                      @3               ��                                    ����                                    undoTransaction                             X4  @4      ��                      p4              h��                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    updateAddQueryWhere                                 x5  `5      ��                     #  �5              ��                         O   ����    e�          O   ����    R�          O   ����    ��            ��       �5             �5                   ��                      �5               ��                                    ����                                    updateQueryPosition                                 �6  �6      ��                  %  &  7              H��                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    updateState                                 8  �7      ��                  (  *  (8              ���                         O   ����    e�          O   ����    R�          O   ����    ��            ��                      @8               ��                                    ����                                    addRow          �8      �8     u       CHARACTER,INPUT pcViewColList CHARACTER cancelRow       �8      9      @9   	 |       CHARACTER,      canNavigate      9      P9      �9    �       LOGICAL,        closeQuery      `9      �9      �9   
 �       LOGICAL,        columnProps     �9      �9       :    �       CHARACTER,INPUT pcColList CHARACTER,INPUT pcPropList CHARACTER  colValues       �9      @:      p:   	 �       CHARACTER,INPUT pcViewColList CHARACTER copyRow P:      �:      �:    �       CHARACTER,INPUT pcViewColList CHARACTER createRow       �:      �:      ;   	 �       LOGICAL,INPUT pcValueList CHARACTER     deleteRow       �:      @;      p;   	 �       LOGICAL,INPUT pcRowIdent CHARACTER      fetchRow        P;      �;      �;  	  �       CHARACTER,INPUT piRow INTEGER,INPUT pcViewColList CHARACTER     fetchRowIdent   �;      <      8<  
  �       CHARACTER,INPUT pcRowIdent CHARACTER,INPUT pcViewColList CHARACTER      findRow <      �<      �<    �       LOGICAL,INPUT pcKeyValues CHARACTER     findRowWhere    �<      �<       =    �       LOGICAL,INPUT pcColumns CHARACTER,INPUT pcValues CHARACTER,INPUT pcOperators CHARACTER  firstRowIds     �<      X=      �=    �       CHARACTER,INPUT pcQueryString CHARACTER getLastCommitErrorType  h=      �=      �=          CHARACTER,      hasForeignKeyChanged    �=      �=      0>          LOGICAL,        openDataQuery   >      @>      p>    3      LOGICAL,INPUT pcPosition CHARACTER      openQuery       P>      �>      �>   	 A      LOGICAL,        prepareQuery    �>      �>      ?    K      LOGICAL,INPUT pcQuery CHARACTER rowAvailable    �>      (?      X?    X      LOGICAL,INPUT pcDirection CHARACTER     rowValues       8?      �?      �?   	 e      CHARACTER,INPUT pcColumns CHARACTER,INPUT pcFormat CHARACTER,INPUT pcDelimiter CHARACTER        submitRow       �?      @      @@   	 o      LOGICAL,INPUT pcRowIdent CHARACTER,INPUT pcValueList CHARACTER  updateRow        @      �@      �@   	 y      LOGICAL,INPUT pcKeyValues CHARACTER,INPUT pcValueList CHARACTER getObjectType   �@      �@       A    �      CHARACTER,      assignDBRow                                 �A  �A      ��                      �A              ���                         O   ����    e�          O   ����    R�          O   ����    ��            �� 
                     �A  
             ��                                    ����                                    bufferCopyDBToRO                                    C   C      ��                      0C              ���                         O   ����    e�          O   ����    R�          O   ����    ��            �� 
      �C             HC  
                 �� 
      �C             xC  
                 ��       �C             �C                   ��                      �C               ��                                    ����                                    compareDBRow                                �D  �D      ��                      E              �
�                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    confirmContinue                             F  �E      ��                        F              ��                         O   ����    e�          O   ����    R�          O   ����    ��            ��                      8F               ��                                    ����                                    dataAvailable                               PG  8G      ��                  "  $  hG              ��                         O   ����    e�          O   ����    R�          O   ����    ��            ��                      �G               ��                                    ����                                    fetchDBRowForUpdate                                 �H  �H      ��                  &  '  �H              �                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    fetchFirst                                  �I  �I      ��                  )  *  �I              �#�                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    fetchLast                                   �J  �J      ��                  ,  -  �J              �(�                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    fetchNext                                   �K  �K      ��                  /  0   L              .�                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    fetchPrev                                    M  �L      ��                  2  3  M              03�                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    filterContainerHandler                               N  N      ��                  5  7  8N              X8�                         O   ����    e�          O   ����    R�          O   ����    ��            �� 
                     PN  
             ��                                    ����                                    initializeObject                                    pO  XO      ��                  9  :  �O              �?�                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    refetchDBRow                                �P  pP      ��                  <  >  �P              0U�                         O   ����    e�          O   ����    R�          O   ����    ��            �� 
                     �P  
             ��                                    ����                                    releaseDBRow                                �Q  �Q      ��                  @  A  �Q              p\�                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    startFilter                                 �R  �R      ��                  C  D   S              a�                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    transferDBRow                                T  �S      ��                  F  I  T              �e�                         O   ����    e�          O   ����    R�          O   ����    ��            ��       pT             0T                   ��                      `T               ��                                    ����                                    addQueryWhere    A      �T      U    �      LOGICAL,INPUT pcWhere CHARACTER,INPUT pcBuffer CHARACTER,INPUT pcAndOr CHARACTER        assignQuerySelection    �T      hU      �U    �      LOGICAL,INPUT pcColumns CHARACTER,INPUT pcValues CHARACTER,INPUT pcOperators CHARACTER  bufferCompareDBToRO     �U      �U      0V    �      LOGICAL,INPUT phRowObjUpd HANDLE,INPUT phBuffer HANDLE,INPUT pcExcludes CHARACTER,INPUT pcAssigns CHARACTER     bufferWhereClause       V      �V      �V    �      CHARACTER,INPUT pcBuffer CHARACTER,INPUT pcWhere CHARACTER      columnDataType  �V      W      HW    �      CHARACTER,INPUT pcColumn CHARACTER      columnDbColumn  (W      pW      �W    �      CHARACTER,INPUT pcColumn CHARACTER      columnQuerySelection    �W      �W       X          CHARACTER,INPUT pcColumn CHARACTER      columnTable     �W      (X      XX           CHARACTER,INPUT pcColumn CHARACTER      columnValMsg    8X      �X      �X     ,      CHARACTER,INPUT pcColumn CHARACTER      dbColumnDataName        �X      �X      Y  !  9      CHARACTER,INPUT pcDbColumn CHARACTER    dbColumnHandle  �X      8Y      hY  "  J      HANDLE,INPUT pcColumn CHARACTER excludeColumns  HY      �Y      �Y  #  Y      CHARACTER,INPUT iTable INTEGER  getDataColumns  �Y      �Y      Z  $  h      CHARACTER,      getForeignValues        �Y      Z      PZ  %  w      CHARACTER,      getQueryPosition        0Z      `Z      �Z  &  �      CHARACTER,      getQuerySort    xZ      �Z      �Z  '  �      CHARACTER,      getQueryString  �Z      �Z      [  (  �      CHARACTER,      getQueryWhere   �Z      ([      X[  )  �      CHARACTER,      getTargetProcedure      8[      h[      �[  *  �      HANDLE, indexInformation        �[      �[      �[  +  �      CHARACTER,INPUT pcQuery CHARACTER,INPUT plUseTableSep LOGICAL,INPUT pcIndexInfo CHARACTER       insertExpression        �[      @\      x\  ,  �      CHARACTER,INPUT pcWhere CHARACTER,INPUT pcExpression CHARACTER,INPUT pcAndOr CHARACTER  newQueryString  X\      �\       ]  -  �      CHARACTER,INPUT pcColumns CHARACTER,INPUT pcValues CHARACTER,INPUT pcOperators CHARACTER,INPUT pcQueryString CHARACTER,INPUT pcAndOr CHARACTER  newQueryValidate        �\      �]      �]  .        CHARACTER,INPUT pcQueryString CHARACTER,INPUT pcExpression CHARACTER,INPUT pcBuffer CHARACTER,INPUT pcAndOr CHARACTER   newQueryWhere   �]      @^      p^  /        CHARACTER,INPUT pcWhere CHARACTER       newWhereClause  P^      �^      �^  0  &      CHARACTER,INPUT pcBuffer CHARACTER,INPUT pcExpression CHARACTER,INPUT pcWhere CHARACTER,INPUT pcAndOr CHARACTER refreshRowident �^      8_      h_  1  5      CHARACTER,INPUT pcRowident CHARACTER    removeForeignKey        H_      �_      �_  2  E      LOGICAL,        removeQuerySelection    �_      �_      `  3  V      LOGICAL,INPUT pcColumns CHARACTER,INPUT pcOperators CHARACTER   resolveBuffer   �_      P`      �`  4  k      CHARACTER,INPUT pcBuffer CHARACTER      rowidWhere      ``      �`      �`  5 
 y      CHARACTER,INPUT pcWhere CHARACTER       rowidWhereCols  �`       a      0a  6  �      CHARACTER,INPUT pcColumns CHARACTER,INPUT pcValues CHARACTER,INPUT pcOperators CHARACTER        setQueryPosition        a      �a      �a  7  �      LOGICAL,INPUT pcPosition CHARACTER      setQuerySort    �a      �a       b  8  �      LOGICAL,INPUT pcSort CHARACTER  setQueryString   b      @b      pb  9  �      LOGICAL,INPUT pcQueryString CHARACTER   setQueryWhere   Pb      �b      �b  :  �      LOGICAL,INPUT pcWhere CHARACTER whereClauseBuffer       �b      �b       c  ;  �      CHARACTER,INPUT pcWhere CHARACTER       bindServer                                  �c  �c      ��                  �  �  �c              0��                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    destroyObject                               �d  �d      ��                  �  �  e              б�                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    destroyServerObject                                 f   f      ��                  �  �  0f              ��                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    disconnectObject                                    8g   g      ��                  �  �  Pg              ���                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    initializeServerObject                              Xh  @h      ��                  �  �  ph              ��                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    restartServerObject                                 xi  `i      ��                  �  �  �i              `��                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    runServerObject                             �j  xj      ��                  �  �  �j              ���                         O   ����    e�          O   ����    R�          O   ����    ��            �� 
                     �j  
             ��                                    ����                                    startServerObject                                   �k  �k      ��                  �  �  �k              ���                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    unbindServer                                �l  �l      ��                  �  �  m              x��                         O   ����    e�          O   ����    R�          O   ����    ��            ��                      (m               ��                                    ����                                    getAppService    c      �m      �m  <  �      CHARACTER,      getASBound      �m      �m      n  = 
 �      LOGICAL,        getAsDivision   �m      (n      Xn  >  �      CHARACTER,      getASHandle     8n      hn      �n  ?        HANDLE, getASHasStarted xn      �n      �n  @        LOGICAL,        getASInfo       �n      �n      o  A 	 #      CHARACTER,      getASInitializeOnRun    �n       o      Xo  B  -      LOGICAL,        getASUsePrompt  8o      ho      �o  C  B      LOGICAL,        getServerFileName       xo      �o      �o  D  Q      CHARACTER,      getServerOperatingMode  �o      �o      (p  E  c      CHARACTER,      runServerProcedure      p      8p      pp  F  z      HANDLE,INPUT pcServerFileName CHARACTER,INPUT phAppService HANDLE       setAppService   Pp      �p      �p  G  �      LOGICAL,INPUT pcAppService CHARACTER    setASDivision   �p      q      @q  H  �      LOGICAL,INPUT pcDivision CHARACTER      setASHandle      q      hq      �q  I  �      LOGICAL,INPUT phASHandle HANDLE setASInfo       xq      �q      �q  J 	 �      LOGICAL,INPUT pcInfo CHARACTER  setASInitializeOnRun    �q      r      @r  K  �      LOGICAL,INPUT plInitialize LOGICAL      setASUsePrompt   r      hr      �r  L  �      LOGICAL,INPUT plFlag LOGICAL    setServerFileName       xr      �r      �r  M  �      LOGICAL,INPUT pcFileName CHARACTER      setServerOperatingMode  �r      s      Ps  N  �      LOGICAL,INPUT pcServerOperatingMode CHARACTER   addLink                             t  �s      ��                  �  �  (t              2�                         O   ����    e�          O   ����    R�          O   ����    ��            �� 
      �t             @t  
                 ��       �t             pt                   �� 
                     �t  
             ��                                    ����                                    addMessage                                  �u  �u      ��                  �  �  �u              D�                         O   ����    e�          O   ����    R�          O   ����    ��            ��       (v             �u                   ��       Xv             v                   ��                      Hv               ��                                    ����                                    adjustTabOrder                              `w  Hw      ��                  �  �  xw              xO�                         O   ����    e�          O   ����    R�          O   ����    ��            �� 
      �w             �w  
                 �� 
       x             �w  
                 ��                      �w               ��                                    ����                                    applyEntry                                  y  �x      ��                  �  �   y              �[�                         O   ����    e�          O   ����    R�          O   ����    ��            ��                      8y               ��                                    ����                                    changeCursor                                Pz  8z      ��                  �  �  hz              Pb�                         O   ����    e�          O   ����    R�          O   ����    ��            ��                      �z               ��                                    ����                                    createControls                              �{  �{      ��                  �  �  �{              Pi�                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    destroyObject                               �|  �|      ��                  �  �  �|              �m�                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    displayLinks                                �}  �}      ��                  �  �  �}              8s�                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    editInstanceProperties                              �~  �~      ��                  �  �                 �w�                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    exitObject                                   �  �      ��                  �  �  �              (��                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    hideObject                                  �   �      ��                  �  �  0�              ���                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    initializeObject                                    8�   �      ��                  �  �  P�              @��                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    modifyListProperty                                  X�  @�      ��                  �  �  p�              ��                         O   ����    e�          O   ����    R�          O   ����    ��            �� 
      ȃ             ��  
                 ��       ��             ��                   ��       (�             �                   ��                      �               ��                                    ����                                    modifyUserLinks                             0�  �      ��                  �  �  H�              ȩ�                         O   ����    e�          O   ����    R�          O   ����    ��            ��       ��             `�                   ��       Ѕ             ��                   �� 
                     ��  
             ��                                    ����                                    removeAllLinks                              ؆  ��      ��                  �  �  ��              `��                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    removeLink                                  ��  ؇      ��                       �              ���                         O   ����    e�          O   ����    R�          O   ����    ��            �� 
      `�              �  
                 ��       ��             P�                   �� 
                     ��  
             ��                                    ����                                    repositionObject                                    ��  ��      ��                    	  ��              ���                         O   ����    e�          O   ����    R�          O   ����    ��            ��       �             Љ                   ��                       �               ��                                    ����                                    returnFocus                                 �   �      ��                      0�              ��                         O   ����    e�          O   ����    R�          O   ����    ��            �� 
                     H�  
             ��                                    ����                                    showMessageProcedure                                h�  P�      ��                      ��              ���                         O   ����    e�          O   ����    R�          O   ����    ��            ��       ،             ��                   ��                      Ȍ               ��                                    ����                                    toggleData                                  ��  ȍ      ��                      ��              ���                         O   ����    e�          O   ����    R�          O   ����    ��            ��                      �               ��                                    ����                                    viewObject                                  (�  �      ��                      @�              ���                         O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    anyMessage      0s      ��      ؏  O 
 Z      LOGICAL,        assignLinkProperty      ��      �       �  P  e      LOGICAL,INPUT pcLink CHARACTER,INPUT pcPropName CHARACTER,INPUT pcPropValue CHARACTER   fetchMessages    �      x�      ��  Q  x      CHARACTER,      getChildDataKey ��      ��      �  R  �      CHARACTER,      getContainerHandle      Ȑ      ��      0�  S  �      HANDLE, getContainerHidden      �      8�      p�  T  �      LOGICAL,        getContainerSource      P�      ��      ��  U  �      HANDLE, getContainerSourceEvents        ��      ��       �  V  �      CHARACTER,      getContainerType        ��      �      H�  W  �      CHARACTER,      getDataLinksEnabled     (�      X�      ��  X  �      LOGICAL,        getDataSource   p�      ��      В  Y        HANDLE, getDataSourceEvents     ��      ؒ      �  Z        CHARACTER,      getDataSourceNames      �       �      X�  [  /      CHARACTER,      getDataTarget   8�      h�      ��  \  B      CHARACTER,      getDataTargetEvents     x�      ��      ��  ]  P      CHARACTER,      getDBAware      ��      �       �  ^ 
 d      LOGICAL,        getDesignDataObject      �      0�      h�  _  o      CHARACTER,      getDynamicObject        H�      x�      ��  `  �      LOGICAL,        getInstanceProperties   ��      ��      ��  a  �      CHARACTER,      getLogicalObjectName    ؔ      �      @�  b  �      CHARACTER,      getLogicalVersion        �      P�      ��  c  �      CHARACTER,      getObjectHidden h�      ��      ȕ  d  �      LOGICAL,        getObjectInitialized    ��      ؕ      �  e  �      LOGICAL,        getObjectName   �       �      P�  f  �      CHARACTER,      getObjectPage   0�      `�      ��  g        INTEGER,        getObjectParent p�      ��      Ж  h        HANDLE, getObjectVersion        ��      ؖ      �  i  "      CHARACTER,      getObjectVersionNumber  �       �      X�  j  3      CHARACTER,      getParentDataKey        8�      h�      ��  k  J      CHARACTER,      getPassThroughLinks     ��      ��      �  l  [      CHARACTER,      getPhysicalObjectName   ȗ      ��      0�  m  o      CHARACTER,      getPhysicalVersion      �      @�      x�  n  �      CHARACTER,      getPropertyDialog       X�      ��      ��  o  �      CHARACTER,      getQueryObject  ��      И       �  p  �      LOGICAL,        getRunAttribute ��      �      @�  q  �      CHARACTER,      getSupportedLinks        �      P�      ��  r  �      CHARACTER,      getTranslatableProperties       h�      ��      ؙ  s  �      CHARACTER,      getUIBMode      ��      �      �  t 
 �      CHARACTER,      getUserProperty ��      (�      X�  u   	      CHARACTER,INPUT pcPropName CHARACTER    instancePropertyList    8�      ��      ��  v  	      CHARACTER,INPUT pcPropList CHARACTER    linkHandles     ��      ��      �  w  %	      CHARACTER,INPUT pcLink CHARACTER        linkProperty    �      8�      h�  x  1	      CHARACTER,INPUT pcLink CHARACTER,INPUT pcPropName CHARACTER     mappedEntry     H�      ��      ؛  y  >	      CHARACTER,INPUT pcEntry CHARACTER,INPUT pcList CHARACTER,INPUT plFirst LOGICAL,INPUT pcDelimiter CHARACTER      messageNumber   ��      H�      x�  z  J	      CHARACTER,INPUT piMessage INTEGER       propertyType    X�      ��      М  {  X	      CHARACTER,INPUT pcPropName CHARACTER    reviewMessages  ��      ��      (�  |  e	      CHARACTER,      setChildDataKey �      8�      h�  }  t	      LOGICAL,INPUT cChildDataKey CHARACTER   setContainerHidden      H�      ��      ȝ  ~  �	      LOGICAL,INPUT plHidden LOGICAL  setContainerSource      ��      �       �    �	      LOGICAL,INPUT phObject HANDLE   setContainerSourceEvents         �      @�      ��  �  �	      LOGICAL,INPUT pcEvents CHARACTER        setDataLinksEnabled     `�      ��      ��  �  �	      LOGICAL,INPUT lDataLinksEnabled LOGICAL setDataSource   ��      �      8�  �  �	      LOGICAL,INPUT phObject HANDLE   setDataSourceEvents     �      X�      ��  �  �	      LOGICAL,INPUT pcEventsList CHARACTER    setDataSourceNames      p�      ��      �  �  �	      LOGICAL,INPUT pcSourceNames CHARACTER   setDataTarget   П      �      H�  �  
      LOGICAL,INPUT pcTarget CHARACTER        setDataTargetEvents     (�      p�      ��  �  
      LOGICAL,INPUT pcEvents CHARACTER        setDBAware      ��      Р       �  � 
 .
      LOGICAL,INPUT lAware LOGICAL    setDesignDataObject     �       �      X�  �  9
      LOGICAL,INPUT pcDataObject CHARACTER    setDynamicObject        8�      ��      ��  �  M
      LOGICAL,INPUT lTemp LOGICAL     setInstanceProperties   ��      ء      �  �  ^
      LOGICAL,INPUT pcPropList CHARACTER      setLogicalObjectName    �      8�      p�  �  t
      LOGICAL,INPUT c CHARACTER       setLogicalVersion       P�      ��      Ȣ  �  �
      LOGICAL,INPUT cVersion CHARACTER        setObjectName   ��      �       �  �  �
      LOGICAL,INPUT pcName CHARACTER  setObjectParent  �      @�      p�  �  �
      LOGICAL,INPUT phParent HANDLE   setObjectVersion        P�      ��      ȣ  �  �
      LOGICAL,INPUT cObjectVersion CHARACTER  setParentDataKey        ��      �      (�  �  �
      LOGICAL,INPUT cParentDataKey CHARACTER  setPassThroughLinks     �      P�      ��  �  �
      LOGICAL,INPUT pcLinks CHARACTER setPhysicalObjectName   h�      ��      �  �  �
      LOGICAL,INPUT cTemp CHARACTER   setPhysicalVersion      ��       �      8�  �        LOGICAL,INPUT cVersion CHARACTER        setRunAttribute �      `�      ��  �        LOGICAL,INPUT cRunAttribute CHARACTER   setSupportedLinks       p�      ��      �  �  (      LOGICAL,INPUT pcLinkList CHARACTER      setTranslatableProperties       Х      �      X�  �  :      LOGICAL,INPUT pcPropList CHARACTER      setUIBMode      8�      ��      ��  � 
 T      LOGICAL,INPUT pcMode CHARACTER  setUserProperty ��      Ц       �  �  _      LOGICAL,INPUT pcPropName CHARACTER,INPUT pcPropValue CHARACTER  showmessage     �      @�      p�  �  o      LOGICAL,INPUT pcMessage CHARACTER       Signature       P�      ��      ȧ  � 	 {      CHARACTER,INPUT pcName CHARACTER        �    /  �  ��      �           4   �����                 ��                      ��                  0  ]                  hY�                            0   �        1  ��  @�      �           4   �����                 P�                      ��                  2  \                  hZ�                            2  Ш  `�    I  p�  �                4   ����                 �                      ��                  U  W                  h[�                            U  ��         V                                      �     
                        � ߱        ��  $  Y  0�  ���                               $  [  ��  ���                                                        � ߱        ��    a  �  ��      0          4   ����0                ��                      ��                  b  &	                  �\�                            b   �  ث  o   e      ,                                     8�  $   f  �  ���                           �  @         �                  � ߱        P�  �   g            h�  �   h  �          ��  �   j  8          ��  �   l  �          ��  �   n  h          Ȭ  �   p             �  �   q  �          ��  �   r  �          �  �   u  �          (�  �   w             @�  �   x  �          X�  �   z  `	          p�  �   {   
          ��  �   |  P
          ��  �   }  �
          ��  �   ~  �          Э  �   �  �          �  �   �  p           �  �   �  �          �  �   �  X          0�  �   �  �          H�  �   �  �          `�  �   �  0          x�  �   �  �          ��  �   �  h          ��  �   �             ��  �   �  �          خ  �   �  �          �  �   �  �          �  �   �  �           �  �   �  h          8�  �   �  �          P�  �   �            h�  �   �  X          ��  �   �  �          ��  �   �  H          ��  �   �  �          ȯ  �   �  �          �  �   �  8          ��  �   �  �          �  �   �  �          (�  �   �  (          @�  �   �  x          X�  �   �  �              �   �                            ��          ��  �      ��                  M	  {	  �              �q�                         O   ����    e�          O   ����    R�          O   ����    ��      �     
                    X                                                      � ߱        ȱ  $ a	  (�  ���                               O   y	  ��  ��  p               8�          (�  0�    �                                                         ��                                    ����                                        �@      p�      �     V     H�                       @�  �                         ��    �	  �  ��      �          4   �����                ��                      ��                  �	  "
                  ��                            �	  (�  ��  �   �	            س  �   �	  �          �  �   �	  H          �  �   �	  �           �  �   �	  �          8�  �   �	  (          P�  �   �	  �          h�  �   �	  `           ��  �   �	   !          ��  �   �	  �!          ��  �   �	  8"          ȴ  �   �	  �"          �  �   �	  x#              �   �	  $          (�    R
  �  ��      �$          4   �����$                ��                      ��                  S
  �
                  `��                            S
  (�  ��  �   U
  8%          ص  �   V
  �%          �  �   W
  x&          �  �   X
  '           �  �   Y
  �'          8�  �   Z
   (          P�  �   \
  �(          h�  �   ]
  0)          ��  �   ^
  �)          ��  �   _
  *          ��  �   `
  h*          ȶ  �   a
   +          �  �   b
  P+          ��  �   c
  �+          �  �   d
  �,          (�  �   e
  0-          @�  �   f
  �-          X�  �   g
  h.          p�  �   h
  /          ��  �   i
  �/          ��  �   j
  H0          ��  �   k
  �0          з  �   l
  �0          �  �   m
  �1           �  �   n
   2          �  �   o
  �2          0�  �   p
  `3          H�  �   q
   4          `�  �   r
  �4          x�  �   s
  @5          ��  �   t
  �5          ��  �   v
  (6          ��  �   w
  �6          ظ  �   x
  7          �  �   y
  �7          �  �   z
  P8           �  �   {
  �8          8�  �   |
  �9          P�  �   }
  :          h�  �   ~
  �:          ��  �   
  X;          ��  �   �
  �;          ��  �   �
  �<          ȹ  �   �
  (=          �  �   �
  �=          ��  �   �
  h>          �  �   �
  ?              �   �
  �?          x�    �
  H�  Ⱥ      �?          4   �����?                غ                      ��                     �                  ���                               X�  �  �     p@          �  �     A           �  �     �A          8�  �     @B          P�  �     �B          h�  �   	  xC          ��  �   
  D          ��  �     �D          ��  �     PE          Ȼ  �     �E          �  �     �F          ��  �     0G          �  �     �G          (�  �     hH          @�  �      I          X�  �     �I          p�  �     8J          ��  �     �J          ��  �     pK          ��  �     L          м  �     �L          �  �     �L           �  �     �M          �  �     0N          0�  �     �N          H�  �     hO          `�  �      P              �     �P          �    �  ��  �      0Q          4   ����0Q  	              (�                      ��             	     �  @                  ���                            �  ��  @�  �   �  �Q          X�  �   �  `R          p�  �   �   S          ��  �   �  �S          ��  �   �  @T          ��  �   �  �T          о  �   �  xU          �  �   �  V           �  �   �  �V          �  �   �  PW          0�  �   �  �W          H�  �   �  �X          `�  �   �  0Y          x�  �   �  �Y          ��  �   �  hZ          ��  �   �  [          ��  �   �  �[          ؿ  �   �  H\          �  �   �  �\          �  �   �  x]           �  �   �  ^          8�  �   �  �^          P�  �   �  _          h�  �   �  �_          ��  �   �  H`          ��  �   �  �`          ��  �   �  �a          ��  �   �   b              �   �  �b          getRowObjUpdStatic      deleteRecordStatic      ��    �  0�  @�      Pc          4   ����Pc      /   �  p�     ��                              3   ����hc            ��                      3   �����c  ��    �  ��  P�   �  �c          4   �����c  
              `�                      ��             
        b                  (�                               ��  x�  �     @d          ��  $    ��  ���                           �d     
                        � ߱        ��  �     �d          P�  $      �  ���                           �d  @         �d                  � ߱         �  $    ��  ���                           pe       	       	               � ߱        �f     
                    8g                         Pi  @        
 �h                  � ߱        ��  V     ��  ���                            `i       	       	           �i       
       
           j       	       	               � ߱        `�  $  1  P�  ���                           8k     
                    �k                          n  @        
 �m                  � ߱            V   C  ��  ���                                          ��                      ��                  d                    X�                            d  ��  n     
                    �n                         �p  @        
 xp              hq  @        
 q              �q  @        
 �q              xr  @        
 r                  � ߱            V   y  �  ���                            adm-clone-props ��  �                    W     �                          �  �                         start-super-proc         �  ��  �           �     X     `                          X  �                         ��      �  (�      �w          4   �����w      /     X�     h�                              3   �����w            ��                      3   ����x  ��  $   4  ��  ���                           @x                             � ߱        ��    D  �  ��  H�  px          4   ����px                �                      ��                  E  I                  �l�                            E  (�  �x                         �x                         �x                             � ߱            $  F  ��  ���                                 J  h�  ��      �x          4   �����x  y                             � ߱            $  K  x�  ���                           ��    R  ��  �  h�  0y          4   ����0y      $  S  8�  ���                           `y                             � ߱            �   p  xy          �y     
                    �z                         �|  @        
 8|                  � ߱         �  V   �  ��  ���                            8�  �   �  �|          H�    6  X�  h�       }          4   ���� }      /   7  ��     ��                              3   ����}            ��                      3   ����@}  h}     
                    ~                         0�  @        
 �                  � ߱        ��  V   C  ��  ���                            ��     
                    0�                         H�  @        
 �                  � ߱        �  V   g  x�  ���                            ��    �  8�  ��      `�          4   ����`�                ��                      ��                  �  �                  Xr�                            �  H�  8�  /   �  ��     �                              3   ����x�            (�                      3   ������      /   �  h�     x�                              3   ������            ��                      3   �����  H�  /  T  ��         (�                          3   �����  initProps       ��  ��              �     Y     �             �          �  8  	                                       @�          ��  ��      ��                �  �  ��              ���                         O   ����    e�          O   ����    R�          O   ����    ��      B                          �              ��  p   �  �  `�      �      h�  ��     �                ��                      ��                  �  �                  P��                            �  p�  �  :  �                 $  �  8�  ���                           0�                             � ߱        ��  ��     X�                                        ��                  �  �                  ���                            �  x�  ��  x�     p�                                        ��                  �                    ��                            �  �  �  �     ��                                        ��                    5                  @��                              ��  ��  ��     ��                                        ��                  6  R                  ���                            6  (�  8�  (�     ��                                        ��                  S  o                   ��                            S  ��  ��  ��     Ь                                        ��                  p  �                  `��                            p  H�  X�  H�     �                                        ��                  �  �                  0��                            �  ��  ��  ��      �  	                                      ��             	     �  �                  ���                            �  h�  x�  h�     �  
                                      ��             
     �  �                  ���                            �  ��  �  ��     0�                                        ��                  �                     P��                            �  ��  ��  ��     H�                                        ��                                      ���                              �  (�  �     `�                                        ��                    :                  ��                              ��  ��  ��     x�                                        ��                  ;  W                  p��                            ;  8�  H�  8�     ��                                        ��                  X  t                  ���                            X  ��  ��  ��     ��                                        ��                  u  �                  0��                            u  X�  h�  X�     ��                                        ��                  �  �                  ���                            �  ��      ��     ح                                        ��                  �  �                  ���                            �  x�      O   �  ��  ��  �               ��          h�  x�   0 H�                                                                     �             ��                                    ����                                    ��  ��   �  X�      �     Z     ��                      � ��  T                         (�    �  h�  ��       �          4   ���� �                ��                      ��                  �  �                  ���                            �  x�  h�  /   �  (�     8�                              3   �����            X�                      3   ����@�  ��  /   �  ��     ��                              3   ����`�            ��                      3   ������  H�  /   �  �     �                              3   ������            8�                      3   ����Ю      /   �  x�     ��                              3   ������            ��                      3   ���� �  H�     
                    ��                         �  @        
 ��                  � ߱        X�  V   M  ��  ���                            (�  $  g  ��  ���                           (�                             � ߱        `�     
                    �                         (�  @        
 ȴ                  � ߱        X�  V   q  ��  ���                            (�  $  �  ��  ���                           8�     
                        � ߱        X�     
                    �                          �  @        
 ��                  � ߱        X�  V   �  ��  ���                            (�  $  �  ��  ���                           0�     
                        � ߱        P�     
                     �                         �  @        
 ��                  � ߱        X�  V   �  ��  ���                            (�  $  �  ��  ���                           8�                             � ߱        x�     
                    (�                         @�  @        
 �                  � ߱        X�  V   �  ��  ���                            p�  �   �  `�          @�  $  �  ��  ���                           ��     
                        � ߱        ��     
                    `�                         x�  @        
 �                  � ߱        p�  V     ��  ���                            ��  $    ��  ���                           ��     
                        � ߱        ��  �   7  ��          H�  $  A  �  ���                            �     
                        � ߱        `�  �   [   �          ��  $   }  ��  ���                           x�                             � ߱              �  ��  ��      ��          4   ������      /   �   �     0�                              3   ������  `�     
   P�                      3   ���� �  ��        ��                      3   �����  ��        ��                      3   ����(�            ��                      3   ����H�  pushRowObjUpdTable      ��  ��  �                   [      �                               �                         pushTableAndValidate    �  h�  �           �     \     �                          �  �                         remoteCommit    ��  ��  �           �     ]     H                          @  .                         serverCommit    ��  P�  �           �     ^                                  ;                                         x�          H�  0�      ��                  �  �  `�              i                        O   ����    e�          O   ����    R�          O   ����    ��          O   �  ��  ��  ��    ��                                    ����                                    `�  ��      ��              _      ��                      
�     H                         disable_UI      ��  @�                      `      �                               [  
                        �      �    ����  �       ��                      �  8   ����   �  8   ����   (�  8   ����   8�  8   ����       8   ����       8   ����       X�  h�      viewObject      ,       H�  ��  ��      toggleData      ,INPUT plEnabled LOGICAL        p�  ��  ��      showMessageProcedure    ,INPUT pcMessage CHARACTER,OUTPUT plAnswer LOGICAL      ��   �  0�      returnFocus     ,INPUT hTarget HANDLE   �  X�  p�      repositionObject        ,INPUT pdRow DECIMAL,INPUT pdCol DECIMAL        H�  ��  ��      removeLink      ,INPUT phSource HANDLE,INPUT pcLink CHARACTER,INPUT phTarget HANDLE     ��  �  (�      removeAllLinks  ,       �  @�  P�      modifyUserLinks ,INPUT pcMod CHARACTER,INPUT pcLinkName CHARACTER,INPUT phObject HANDLE 0�  ��  ��      modifyListProperty      ,INPUT phCaller HANDLE,INPUT pcMode CHARACTER,INPUT pcListName CHARACTER,INPUT pcListValue CHARACTER    ��  8�  H�      hideObject      ,       (�  `�  p�      exitObject      ,       P�  ��  ��      editInstanceProperties  ,       x�  ��  ��      displayLinks    ,       ��  ��  ��      createControls  ,       ��  �  �      changeCursor    ,INPUT pcCursor CHARACTER       ��  H�  X�      applyEntry      ,INPUT pcField CHARACTER        8�  ��  ��      adjustTabOrder  ,INPUT phObject HANDLE,INPUT phAnchor HANDLE,INPUT pcPosition CHARACTER x�  ��   �      addMessage      ,INPUT pcText CHARACTER,INPUT pcField CHARACTER,INPUT pcTable CHARACTER ��  X�  `�      addLink ,INPUT phSource HANDLE,INPUT pcLink CHARACTER,INPUT phTarget HANDLE     H�  ��  ��      unbindServer    ,INPUT pcMode CHARACTER ��  ��   �      runServerObject ,INPUT phAppService HANDLE      ��  0�  H�      disconnectObject        ,        �  `�  p�      destroyObject   ,       P�  ��  ��      bindServer      ,       x�  ��  ��      transferDBRow   ,INPUT pcRowIdent CHARACTER,INPUT piRowNum INTEGER      ��  �  �      startFilter     ,       ��  0�  @�      releaseDBRow    ,        �  X�  h�      refetchDBRow    ,INPUT phRowObjUpd HANDLE       H�  ��  ��      filterContainerHandler  ,INPUT phFilterContainer HANDLE ��  ��  ��      fetchDBRowForUpdate     ,       ��  �   �      confirmContinue ,INPUT-OUTPUT pioCancel LOGICAL  �  P�  `�      compareDBRow    ,       @�  x�  ��      bufferCopyDBToRO        ,INPUT phRowObj HANDLE,INPUT phBuffer HANDLE,INPUT pcExcludes CHARACTER,INPUT pcAssigns CHARACTER       h�  �  �      assignDBRow     ,INPUT phRowObjUpd HANDLE       ��  H�  X�      updateState     ,INPUT pcState CHARACTER        8�  ��  ��      updateQueryPosition     ,       x�  ��  ��      updateAddQueryWhere     ,INPUT pcWhere CHARACTER,INPUT pcField CHARACTER        ��  �  (�      undoTransaction ,       �  @�  P�      transferToExcel ,INPUT pcFieldList CHARACTER,INPUT plIncludeObj LOGICAL,INPUT plUseExisting LOGICAL,INPUT piMaxRecords INTEGER  0�  ��  ��      synchronizeProperties   ,INPUT pcPropertiesForServer CHARACTER,OUTPUT pcPropertiesForClient CHARACTER   ��  H�  `�      submitValidation        ,INPUT pcValueList CHARACTER,INPUT pcUpdColumns CHARACTER       8�  ��  ��      submitForeignKey        ,INPUT pcRowIdent CHARACTER,INPUT-OUTPUT pcValueList CHARACTER,INPUT-OUTPUT pcUpdColumns CHARACTER      ��  @�  P�      submitCommit    ,INPUT pcRowIdent CHARACTER,INPUT plReopen LOGICAL      0�  ��  ��      startServerObject       ,       ��  ��  ��      setPropertyList ,INPUT pcProperties CHARACTER   ��  �  (�      serverFetchRowObjUpdTable       ,OUTPUT TABLE-HANDLE phRowObjUpd        ��  `�  p�      serverSendRows  ,INPUT piStartRow INTEGER,INPUT pcRowIdent CHARACTER,INPUT plNext LOGICAL,INPUT piRowsToReturn INTEGER,OUTPUT piRowsReturned INTEGER,OUTPUT TABLE-HANDLE phRowObject    P�  (�  @�      saveContextAndDestroy   ,OUTPUT pcContext CHARACTER     �  p�  ��      rowObjectState  ,INPUT pcState CHARACTER        `�  ��  ��      retrieveFilter  ,       ��  ��  ��      restartServerObject     ,       ��  �  �      remoteSendRows  ,INPUT-OUTPUT piocContext CHARACTER,INPUT piStartRow INTEGER,INPUT pcRowIdent CHARACTER,INPUT plNext LOGICAL,INPUT piRowsToReturn INTEGER,OUTPUT pioRowsReturned INTEGER,OUTPUT TABLE-HANDLE phRowObject,OUTPUT pocMessages CHARACTER   ��  �   �      refreshRow      ,        �  8�  H�      printToCrystal  ,INPUT pcFieldList CHARACTER,INPUT plIncludeObj LOGICAL,INPUT piMaxRecords INTEGER      (�  ��  ��      isUpdatePending ,INPUT-OUTPUT plUpdate LOGICAL  ��  ��  �      initializeServerObject  ,       ��   �  8�      initializeObject        ,       �  P�  X�      home    ,       @�  p�  ��      genContextList  ,OUTPUT pcContext CHARACTER     `�  ��  ��      fetchPrev       ,       ��  ��  ��      fetchNext       ,       ��   �  �      fetchLast       ,       ��  (�  8�      fetchFirst      ,       �  P�  `�      fetchBatch      ,INPUT plForwards LOGICAL       @�  ��  ��      endClientDataRequest    ,       ��  ��  ��      destroyServerObject     ,       ��  ��   �      describeSchema  ,INPUT pcSdoName CHARACTER,OUTPUT TABLE-HANDLE hTtSchema        ��  P�  `�      dataAvailable   ,INPUT pcRelative CHARACTER     @�  ��  ��      copyColumns     ,INPUT pcViewColList CHARACTER,INPUT phDataQuery HANDLE ��  ��         commitTransaction       ,       ��    (      clientSendRows  ,INPUT piStartRow INTEGER,INPUT pcRowIdent CHARACTER,INPUT plNext LOGICAL,INPUT piRowsToReturn INTEGER,OUTPUT piRowsReturned INTEGER      �  �      batchServices   ,INPUT pcServices CHARACTER,OUTPUT pcValues CHARACTER                �     
"         
   %          adecomm/as-utils.w      
"       
   �            }        �    
"         
         �             }        �    �        U   %                   �     
"     	   
   %                  �     �p  �                 8                  
�                            (     
�                    �     �     
"     	   
   
�h     T             %                  �             }        �G    G     %                  �     
"       
   x     �p     
�h     T             %                  �             }        �G    G     %                  
"       
   �                �    7    %                   
"       
   �                   �    1    �     �  
   �     �     %                   o%       o           �     �      
"       
   �                   �    1    �     �     �     �     %                   o%       o           �     �     
"       
   �                   (    1    �     �  
   �     �     %                   o%       o           �     �     
"       
   �                   �    1    �     �     �     �     %                   o%       o           �     �      
"       
   �                   X    1    �     �     �     �     %                   o%       o           �     �     
"       
   �                   �    1    �          �          %                   o%       o           %                   
"       
   �              �    1    �          �     ,     
"       
   �                   �    1    �     3     �     �     %                   o%       o           �     F    
"       
   �                   x    1    �     H     �     �     %                   o%       o           �     W  S   
"       
   �                       1    �     �     �          %                   o%       o           %                   
"       
   �                   �    1    �     �     �          %                   o%       o           %                   
"       
   �                   P	    1    �     �     �          %                   o%       o           %                  
"       
   �              �	    1    �     �     �          
"       
   �                   @
    1    �     �  
   �          %                   o%       o           %                   
"       
   �                   �
    1    �     �     �     �     %                   o%       o           �     �      
"       
   �              x    1    �     �     �     ,     
"       
   �                   �    1    �          �     �     %                   o%       o           �     "  t   
"       
   �              `    1    �     �  
   �     ,     
"       
   �                   �    1    �     �     �     �     %                   o%       o           �     �  �   
"       
   �                   H    1    �     @     �     �     %                   o%       o           �     �      
"       
   �                   �    1    �     W  
   �     b     %                   o%       o           %                   
"       
   �                   �    1    �     f     �          %                   o%       o           %                  
"       
   �                        1    �     n     �     �     %                   o%       o           �     �      
"       
   �                   �    1    �          �     �     %                   o%       o           o%       o           
"       
   �                   X    1    �     �  
   �     �     %                   o%       o           �     �     
"       
   �                   �    1    �     �     �     �  	   %                   o%       o           �     �  /  
"       
   �              �    1    �     �     �     �  	   
"       
   �                   �    1    �     �     �     �  	   o%       o           o%       o           �     �     
"       
   �              p    1    �     
     �     �  	   
"       
   �                   �    1    �          �     �  	   o%       o           o%       o           �     �     
"       
   �              X    1    �     )     �          
"       
   �              �    1    �     7     �     �  	   
"       
   �              �    1    �     D     �     �  	   
"       
   �              H    1    �     Q     �     �  	   
"       
   �                   �    1    �     _     �          o%       o           o%       o           %                  
"       
   �              8    1    �     p     �     �  	   
"       
   �              �    1    �     ~  
   �     �     
"       
   �              �    1    �     �     �     �  	   
"       
   �              (    1    �     �     �     �  	   
"       
   �              x    1    �     �     �     �  	   
"       
   �              �    1    �     �     �     �  	   
"       
   �                  1    �     �  	   �     �  	   
"       
   �              h    1    �     �     �     �  	   
"       
   �              �    1    �     �     �     �  	   
"       
   �                       1    �          �     �     %                   o%       o           o%       o           
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                    �    �            �           �                (    �    `            
� `  @     
�               8    �    �           p�                       �L    
�            %                  � `              H    �     @                          �     '                  
�            �     A     
"       
   � `  @     
�                    �    �     �  
   p�                       �L    "          x     �p     
�h     T             %                  �             }        �G    G     %                  
"       
   �                        1    �     D  
   �     �     %                   o%       o           �     �      
"       
   �                   �    1    �     O  
   �     �     %                   o%       o           o%       o           
"       
   �                   8    1    �     Z     �     ,     %                   o%       o           o%       o           
"       
   �                   �    1    �     c     �          %                   o%       o           %                   
"       
   �                   x    1    �     r     �          %                   o%       o           %                   
"       
   �                       1    �          �     �     %                   o%       o           �     �      
"       
   �                   �    1    �     �     �          %                   o%       o           %                  
"       
   �                   P     1    �     �     �          %                   o%       o           o%       o           
"       
   �                   �     1    �     �     �     �     %                   o%       o           o%       o           
"       
   �                   �!    1    �     �  	   �     �     %                   o%       o           �     �     
"       
   �                   ("    1    �     �     �     �     %                   o%       o           o%       o           
"       
   �                   �"    1    �     �     �     �     %                   o%       o           o%       o           
"       
   �                   h#    1    �     �     �          %                   o%       o           %                   
"       
   �                   $    1    �     �     �          %                   o%       o           o%       o           x     �p     
�h     T             %                  �             }        �G    G     %                  
"       
   �                   (%    1    �     �  
   �          %                   o%       o           %                  
"       
   �                   �%    1    �          �     �     %                   o%       o           o%       o           
"       
   �                   h&    1    �          �     �     %                   o%       o           �     �     
"       
   �                    '    1    �           �     �     %                   o%       o           o%       o           
"       
   �              �'    1    �     ,     �     ,     
"       
   �                   �'    1    �     9     �     �     %                   o%       o           �     L  !  
"       
   �                   �(    1    �     n     �     �     %                   o%       o           �     �     
"       
   �                    )    1    �     {     �     �     %                   o%       o           �     �    
"       
   �              �)    1    �     �     �     �     
"       
   �              *    1    �     �     �     ,     
"       
   �                   X*    1    �     �     �     �     %                   o%       o           �     �     
"       
   �              �*    1    �     �  
   �     ,     
"       
   �                   @+    1    �     �     �          %                   o%       o           o%       o           
"       
   �                   �+    1    �     �     �          %                   o%       o           %                   
"       
   �                   �,    1    �     �     �          %                   o%       o           %                   
"       
   �                    -    1    �          �     �     %                   o%       o           �     �      
"       
   �                   �-    1    �          �     �     %                   o%       o           o%       o           
"       
   �                   X.    1    �     #     �          %                   o%       o           %                  
"       
   �                   �.    1    �     4     �          %                   o%       o           %                   
"       
   �                   �/    1    �     A     �          %                   o%       o           %                   
"       
   �              80    1    �     Q     �     ,     
"       
   �              �0    1    �     ^     �     �     
"       
   �                   �0    1    �     k     �     b     %                   o%       o           o%       o           
"       
   �                   x1    1    �     w     �     �     %                   o%       o           �     �     
"       
   �                   2    1    �     �     �     �     %                   o%       o           o%       o           
"       
   �                   �2    1    �     �     �          o%       o           o%       o           o%       o           
"       
   �                   P3    1    �     �     �     �  	   %                   o%       o           o%       o           
"       
   �                   �3    1    �     �     �     �     %                   o%       o           o%       o           
"       
   �                   �4    1    �     �  
   �     b     %                   o%       o           o%       o           
"       
   �              05    1    �     �     �     �     
"       
   �                   �5    1    �     �     �     �     %                   o%       o           �     �  4  
"       
   �                   6    1    �     .  
   �          %                   o%       o           %                  
"       
   �              �6    1    �     9     �     ,     
"       
   �                   7    1    �     J     �     �     %                   o%       o           �     �      
"       
   �                   �7    1    �     X     �          %                   o%       o           %                  
"       
   �                   @8    1    �     g     �     �     %                   o%       o           �     �      
"       
   �                   �8    1    �     t     �     �     %                   o%       o           �     �      
"       
   �                   p9    1    �     �     �     �     %                   o%       o           �     �      
"       
   �                   :    1    �     �     �          %                   o%       o           %                   
"       
   �                   �:    1    �     �  	   �     ,     %                   o%       o           o%       o           
"       
   �                   H;    1    �     �     �     �     %                   o%       o           �     �  	  
"       
   �                   �;    1    �     �     �     b     %                   o%       o           %           �       
"       
   �                   �<    1    �     �     �     �     %                   o%       o           �     �      
"       
   �                   =    1    �     �     �          o%       o           o%       o           %                  
"       
   �                   �=    1    �     �     �          %                   o%       o           %                   
"       
   �                   X>    1    �     �     �     �     %                   o%       o           o%       o           
"       
   �                   �>    1    �          �     �  	   %                   o%       o           �     �     
"       
   �              �?    1    �          �     �  	   x     �p     
�h     T             %                  �             }        �G    G     %                  
"       
   �                   `@    1    �     +  
   �     �     %                   o%       o           �     �      
"       
   �                   �@    1    �     6     �          %                   o%       o           %                   
"       
   �                   �A    1    �     C  	   �     �     %                   o%       o           �     �      
"       
   �                   0B    1    �     M     �     �     %                   o%       o           �     �      
"       
   �                   �B    1    �     [     �          %                   o%       o           %                   
"       
   �                   hC    1    �     k     �     �     %                   o%       o           �     �      
"       
   �                    D    1    �     ~     �     �     %                   o%       o           o%       o           
"       
   �                   �D    1    �     �     �     �     %                   o%       o           o%       o           
"       
   �                   @E    1    �     �     �          %                   o%       o           o%       o           
"       
   �                   �E    1    �     �     �          %                   o%       o           o%       o           
"       
   �                   �F    1    �     �     �          %                   o%       o           o%       o           
"       
   �                    G    1    �     �     �     �     %                   o%       o           o%       o           
"       
   �                   �G    1    �     �  	   �     �  	   %                   o%       o           �     �     
"       
   �                   XH    1    �     �  
   �     �  	   %                   o%       o           �     �     
"       
   �                   �H    1    �     �     �     �     %                   o%       o           �     �     
"       
   �                   �I    1    �     �     �     �     %                   o%       o           o%       o           
"       
   �                   (J    1    �          �     �     %                   o%       o           o%       o           
"       
   �                   �J    1    �          �     �     %                   o%       o           �     �     
"       
   �                   `K    1    �     %     �     �     %                   o%       o           �     �     
"       
   �                   �K    1    �     4     �     �  	   %                   o%       o           o%       o           
"       
   �              �L    1    �     F     �     ,     
"       
   �                   �L    1    �     R     �     �     %                   o%       o           �     �     
"       
   �                   �M    1    �     `     �     �     %                   o%       o           o%       o           
"       
   �                    N    1    �     s     �          %                   o%       o           o%       o           
"       
   �                   �N    1    �     �  
   �     �     %                   o%       o           �     �     
"       
   �                   XO    1    �     �     �     �     %                   o%       o           �     �     
"       
   �                   �O    1    �     �     �          %                   o%       o           %                   
"       
   �                   �P    1    �     �     �     �     %                   o%       o           o%       o           x     �p     
�h     T             %                  �             }        �G    G     %                  
"       
   �                   �Q    1    �     �  	   �     ,     %                   o%       o           o%       o           
"       
   �                   PR    1    �     �     �     ,     %                   o%       o           o%       o           
"       
   �                   �R    1    �     �     �     ,     %                   o%       o           o%       o           
"       
   �                   �S    1    �     �     �          %                   o%       o           %                  
"       
   �                   0T    1    �          �     �     %                   o%       o           �        M   
"       
   �                   �T    1    �     n     �          %                   o%       o           %                  
"       
   �                   hU    1    �          �          %                   o%       o           %                   
"       
   �                   V    1    �     �     �          %                   o%       o           %                   
"       
   �                   �V    1    �     �     �     �  	   %                   o%       o           �     �  !   
"       
   �                   @W    1    �     �     �          %                   o%       o           %                   
"       
   �                   �W    1    �     �     �     �  	   %                   o%       o           o%       o           
"       
   �                   �X    1    �     �     �          o%       o           o%       o           %                  
"       
   �                    Y    1    �          �     �  	   o%       o           o%       o           �     �      
"       
   �                   �Y    1    �          �     ,     o%       o           o%       o           o%       o           
"       
   �                   XZ    1    �     )     �     ,     o%       o           o%       o           o%       o           
"       
   �                   �Z    1    �     9     �     �  	   o%       o           o%       o           o%       o           
"       
   �                   �[    1    �     I     �     ,     o%       o           o%       o           o%       o           
"       
   �                   8\    1    �     X     �     �  	   o%       o           o%       o           �     f    
"       
   �                   �\    1    �     h     �     �  	   o%       o           o%       o           �     w    
"       
   �                   h]    1    �     �     �          %                   o%       o           %                   
"       
   �                   ^    1    �     �     �          %                   o%       o           %                   
"       
   �              �^    1    �     �     �     �  	   
"       
   �                   �^    1    �     �     �          %                   o%       o           %                   
"       
   �                   �_    1    �     �     �     �     %                   o%       o           o%       o           
"       
   �                   8`    1    �     �     �     �     %                   o%       o           o%       o           
"       
   �                   �`    1    �     �     �          %                   o%       o           o%       o           
"       
   �                   xa    1    �          �     �     %                   o%       o           �     �     
"       
   �                   b    1    �          �     "     %                   o%       o           %                   
"       
   �                   �b    1    �     *  	   �          %                   o%       o           %                        "          %          start-super-proc /�     % t-su    adm2/smart.p    x     �p     
�h     T             %                  �             }        �G    G     %                  
"       
   �               0d    6    �          
"       
   
�                pd    8    
"       
   �                �d    �    �             }        �G     P                                         
"       
   G     %                  G     %                  %       AppService,ASInfo,ASUsePrompt,CacheDuration,CheckCurrentChanged,DestroyStateless,DisconnectAppServer,ServerOperatingMode,ShareData,UpdateFromSource,ForeignFields,ObjectName,OpenOnInit,PromptColumns,PromptOnDelete,RowsToBatch,RebuildOnRepos,ToggleDataTargets       
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                �f    �    �            �           �                g    �    `            
� `  @     
�               g    �    �           p�                       �L    
�            %                  � `              (g    �     @                          �     '                  
�            �     A     
"       
   p� `  @     
�               �h    �    �     3     p�                       �L    "      	    �            �     `     �     b     �             }        �A     0            |            "      	    �     `     %                  (` 0 �         @            |             �             }        �A    �     d     "      
                "      	    "      
      `         "      	    "      
    @            |             �             }        �A    �     d     "      
    
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                �k    �    �            �           �                �k    �    `            
� `  @     
�               �k    �    �           p�                       �L    
�            %                  � `              �k    �     @                          �     '                  
�            �     A     
"       
   p� `  @     
�               �m    �    �     �  
   p�                       �L    "      	    
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                �n    �    �            �           �                �n    �    `            
� `  @     
�               �n    �    �           p�                       �L    
�            %                  � `              �n    �     @                          �     '                  
�            �     A     
"       
   p� `  @     
�               hp    �    �     �  
   p�                       �L    %        SmartDataObject 
"       
   p� `  @     
�               �p    �    �     �     p�                       �L    %                  
"       
   p� `  @     
�               �q    �    �          p�                       �L    %                  
"       
   p� `  @     
�               r    �    �     �     p�                       �L    (0                        �     �      �     �      �     �      �             }        �A    
�h     T             %                  �             }        �G    G     %                  
"       
    @           �     
"       
                �                Xs    �    �          
"       
   � `              �s    �     @                          �     '                  
�            �     A     
"       
   �                `t    �    
"       
   �               �t    /    
"       
   
"       
   �               �t    6    �          
"       
   
�                u    8    
"       
   �                @u    �    
"       
   �               pu    �    
"       
   p�             �     �     
�            �             }        �G     P                                         
"       
   G     %                  G     %                  
�             }        �    
"       
    @           �     
"       
                �                �v    �A    "          
"       
   
�                w    �@         �     
"       
   "          �           }        �    
"       
   %                  %                        "          %          start-super-proc /�     %  t-su    adm2/appserver.p        �             �          
�            �             }        �    %                   %          Server  -      �             }        �                "          �     �      %                               "          �     �      %          NONE    p�8  H                 (     "                  �     (     
�            
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                @z    �    �            �           �                Pz    �    `            
� `  @     
�               `z    �    �           p�                       �L    
�            %                  � `              pz    �     @                          �     '                  
�            �     A     
"       
   p� `  @     
�               (|    �    �     �     p�                       �L    "          p�8  H                 (     "                  �     6     
�                 "          %          start-super-proc /�     %  t-su    adm2/dataquery.p        
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                �}    �    �            �           �                �}    �    `            
� `  @     
�               �}    �    �           p�                       �L    
�            %                  � `              ~    �     @                          �     '                  
�            �     A     
"       
   p� `  @     
�               �    �    �     �     p�                       �L    %H    > 8   dataAvailable,confirmContinue,isUpdatePending,buildDataRequest  
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                ��    �    �            �           �                 �    �    `            
� `  @     
�               �    �    �           p�                       �L    
�            %                  � `               �    �     @                          �     '                  
�            �     A     
"       
   p� `  @     
�               ؂    �    �          p�                       �L    %                       "          %          start-super-proc +�     % t-su    adm2/query.p    %          start-super-proc +�     % t-su    adm2/queryext.p %     	    initProps �     
�            %                   �           �     w     �     y     �           
�             	         �G    
"       
   �                ��    �G    
"       
   
"       
    �            (H P                       �                ��    �G    %                                 �                ��    �G    G     %                  �     ]      �     ^                 %                  %                               "          %                  
"       
                "          �                P�    �    
"       
   �                ��    �    
"       
   
�               І    �    "           �               h           "          (8                       "          %                  �     �      �     w                  
"       
   
"       
    �               h           "          (8                       "          %                  �     �      �     w     �                ȇ    �    %                               %                  %                               "      (    %                              "      (                
"       
   
"       
   P �                         m     �     "      (    �                P�    �    A h           "           8                          �     "      (    �     d     �                `�    �    �     "      (    
"       
    � p             h           "          (8                       "          %                  �     �      �     w     (0                        "      !    �     �      �                p�    �    "      !    
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                ��    �    �            �           �                �    �    `            
� `  @     
�               �    �    �           p�                       �L    
�            %                  � `              (�    �     @                          �     '                  
�            �     A     
"       
   p� `  @     
�               ��    �    �     �     p�                       �L    %                   
"       
   p� `  @     
�               h�    �    �          p�                       �L    "          �8  H                 (     "                  �     e  
   
�            
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                ��    �    �            �           �                ��    �    `            
� `  @     
�               Џ    �    �           p�                       �L    
�            %                  � `              ��    �     @                          �     '                  
�            �     A     
"       
   p� `  @     
�               ��    �    �     F     p�                       �L    
"       
   
"       
   p� `  @     
�               �    �    �     %     p�                       �L    "          
"       
   p� `  @     
�               ��    �    �     �     p�                       �L    "                      "          �     �      %@     6 0   OPEN QUERY Query-Main FOR EACH InventoryTrans NO-LOCK.              "          �     �   NO(8 0                      "          %                               "          �     �     "           8           "                       "          %                  X     �8  H                 (     "                  �     �     
�            p�8  H                 (     �     �             �     �     
�            %                   �            "          �     y                 %                  %                               "          %                              "          "          "          T8                        "          %                  "          �     y     "          � 0         "          �            "          �     d     �     �      �     d     �            "          �     d     S            "          "                      "          %                    X`            8            � x            ( x           4                 "          (H           (            4                 "          �     �      �     �      �     w     T @          %                  T           "          "          �     y     �     d     �     w     T0           �            "          �     d     "          �     d     "          %                               %                  %                               "          %                               "          �             "          �             "           � (             h           "          (8                       "          %                  �     �      �     �     4                 "          
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                Л    �    �            �           �                ��    �    `            
� `  @     
�               �    �    �           p�                       �L    
�            %                  � `               �    �     @                          �     '                  
�            �     A     
"       
   p� `  @     
�               ��    �    �     +  
   p�                       �L    "            0           "      
    �            �     �  V   �     y       0           "      	    �            �     �  V   �     y     �           �     w     �     y     �     �  V   �           �     w     �     y     �     �  V   �           �     w     �     y     �     �  V   
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                �    �    �            �           �                �    �    `            
� `  @     
�               (�    �    �           p�                       �L    
�            %                  � `              8�    �     @                          �     '                  
�            �     A     
"       
   p� `  @     
�               �    �    �     �     p�                       �L    "          
"       
   p� `  @     
�               p�    �    �     �     p�                       �L    "          
"       
   p� `  @     
�               �    �    �     k     p�                       �L    "                      %                  %                               "          %                               "          �             "          �             "          P @            0           "      
    �            �     �  V   �     y                  "      	    �             "          T            "          "          `     A@            �           �     w     �     �     "          "           �              `           "          (0                       "          �     �      �     �      �     w     "                       "      	    %                  h h           `     A@            �           �     w     �     �     "          "          @            S           "          �     �  V   �     y     %                    �              `           "          (0                       "          �     �      �     �      �     w     "                       "      
    %                   0                         "          �     �     "           0                         "          �     �     "          
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                 �    �    �            �           �                0�    �    `            
� `  @     
�               @�    �    �           p�                       �L    
�            %                  � `              P�    �     @                          �     '                  
�            �     A     
"       
   p� `  @     
�               �    �    �     �     p�                       �L    "          
"       
   p� `  @     
�               ��    �    �     k     p�                       �L    "          "          %                        �             }        �    %                  %                  %                  %                  %                  %                  %                  %           	       %           
       %                  %                  %                  %                  %                  %                  %                  %                  "               "          %          start-super-proc ��     % t-su    adm2/data.p     %          start-super-proc ��     % t-su    adm2/dataext.p  %          start-super-proc ��     %  t-su    adm2/dataextcols.p      %          start-super-proc ��     %  t-su    adm2/dataextapi.p       
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                ��    �    �            �           �                ȯ    �    `            
� `  @     
�               د    �    �           p�                       �L    
�            %                  � `              �    �     @                          �     '                  
�            �     A     
"       
   p� `  @     
�               ��    �    �     �     p�                       �L    %                   %0     !     "samples/web/extranet/dinvtran.i" �     
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                в    �    �            �           �                �    �    `            
� `  @     
�               �    �    �           p�                       �L    
�            %                  � `               �    �     @                          �     '                  
�            �     A     
"       
   p� `  @     
�               ��    �    �     �     p�                       �L    "          
�             	        �G    
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                ȵ    �    �            �           �                ص    �    `            
� `  @     
�               �    �    �           p�                       �L    
�            %                  � `              ��    �     @                          �     '                  
�            �     A     
"       
   p� `  @     
�               ��    �    �     �  
   p�                       �L    
"       
   
�             
        �G    
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                ��    �    �            �           �                и    �    `            
� `  @     
�               �    �    �           p�                       �L    
�            %                  � `              �    �     @                          �     '                  
�            �     A     
"       
   p� `  @     
�               ��    �    �     �  	   p�                       �L    
"       
   
"       
                 �     o  	   �                (�    �    
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                �    �    �            �           �                ��    �    `            
� `  @     
�               �    �    �           p�                       �L    
�            %                  � `              �    �     @                          �     '                  
�            �     A     
"       
   p� `  @     
�               н    �    �          p�                       �L    "          
"       
   �               P�    �    "          
�             
        �G    
�h     T             %                  �             }        �G    G     %                  
"       
   
"       
   
"       
   
"       
   (  �         @ �                        �                 �    �    �            �           �                0�    �    `            
� `  @     
�               @�    �    �           p�                       �L    
�            %                  � `              P�    �     @                          �     '                  
�            �     A     
"       
   p� `  @     
�               �    �    �     �  	   p�                       �L    
"       
   
�                     �G    p�8  H                 (     
"       
           �     y     
�            
�                     �G    p�8  H                 (     
"       
           �     �     
�            �             �     �     
�                        "          �     �      %          modifyListProperty      
�            % fyLi     REMOVE  % VE      SupportedLinks  % orte    Update-Target   %         bufferValidate  
�            "          �      %          setContextAndInitialize 
�            "          %         bufferCommit    
�            "          "          �             �          
�            %                   %         bufferCommit    
�            "          "          
�             
        �G    �             }        �    
�                            �           �   p       ��                 q  �  �               @*�                         O   ����    e�          O   ����    R�          O   ����    ��        $  �  �   ���                           �r     
                        � ߱              �  8  �      hs          4   ����hs                �                      ��                  �  �                  H7�                            �  H  �  �  �  �s                �     �      pt          4   ����pt                �                      ��                  �  �                  �H�                            �    �  o   �      ,                                     �  �   �  �t          �  �   �  �t          X  $  �  (  ���                            u     
                        � ߱        p  �   �  Pu          �  �   �  �u          �  �   �  �u              $   �  �  ���                            v  @         �u                  � ߱                     �          x  �   X 8                
             
             
             
                 (   8   H              (   8   H       ����            ��                                    ����                                                    �           �   p       ��                 �  �  �               K�                         O   ����    e�          O   ����    R�          O   ����    ��      �                          �              �  $  �    ���                           �v     
                        � ߱                  �  �                      ��                   �  �                  T�                     8     �  H      4   �����v      $  �    ���                           (w     
                        � ߱        �    �  X  h      Hw          4   ����Hw      /  �  �                                   3   ����hw  �  �   �  xw              O   �  ��  ��  �w               P          0  @   0                               
                                         �              ��                                    ����                                                    �           �   p       ��            	     `  �  �               0t�                         O   ����    e�          O   ����    R�          O   ����    ��        $  �  �   ���                           8�                             � ߱        �  $  �  H  ���                           P�                             � ߱        ��     
                     �  @         ��                  � ߱        h  $   �  x  ���                             x      �  �                      ��        0         �  �                  Ph�       ��         �     �  �      $  �  �  ���                           ؅                             � ߱        8  $  �    ���                           �                             � ߱            4   ����`�  ��     
                    �                         ؇                             � ߱        X  $  �  H  ���                                         h                      ��                  �  �                  i�                     @     �  �  8  $  �  �  ���                           ��       !       !               � ߱          H      �                        ��        0         �  �                  �i�      ( H�                �  �      $  �  x  ���                           ��       (       (               � ߱          $  �  �  ���                           �       (       (               � ߱            4   ���� �        �  8  �      p�          4   ����p�                �                      ��                  �  �                  �j�                            �  H  (  $  �  �  ���                           X�       !       !               � ߱            O   �  �� ��          $  �  p  ���                           ��                             � ߱        ��     
                    8�                         P�  @        
 ��              ؎  @        
 x�              �                         @�     
                    ��                         �  @        
 ��              ��  @        
 (�              �  @        
 ��                  � ߱         	  V   �  �  ���                            
    �  @	  �	      �          4   �����  H�                         ��                         ��                         H�                             � ߱            $  �  P	  ���                           X
    �  0
  @
      ��          4   ������      �   �   �          �
  $  �  �
  ���                           X�                             � ߱        �  $  �  �
  ���                           p�                             � ߱          �      �                        ��        0         �  �                  �o�       H�         �     �        $  �  �  ���                           ��                             � ߱        X  $  �  (  ���                           ��                             � ߱            4   �����  X�                         ��                         Ж                         @�                         p�                             � ߱        H  $  �  h  ���                                 �  h  x      ��          4   ������      $  �  �  ���                           ؗ          ��                 � ߱        �  $  �    ���                           ��                             � ߱          �        �                      ��        0         �  �                  pq�       ��         X     �  8      $  �  �  ���                           ș                             � ߱        x  $  �  H  ���                           �                             � ߱            4   ����@�      $  �  �  ���                           ��                             � ߱        `�     
                    �                         (�  @        
 ȝ                  � ߱          V   �  �  ���                            8�       
       
           ��       	       	           ؞                         �                             � ߱        H  $  *  �  ���                           X  $  �  x  ���                           X�                             � ߱        ��     
                    H�                         `�  @        
  �              �  @        
 ��              `�  @        
  �                  � ߱        �  V   �  �  ���                                    h  �                      ��        0    	     >  S                  ���       (�         �     >  �      $  >  8  ���                           p�                             � ߱        �  $  >  �  ���                           ��                             � ߱        �  4   �����      4   ����H�  H  $  C    ���                           �                             � ߱        x    E  h  �      �          4   �����                H                      ��                  F  J                  ���                            F  x  ��                          �       	       	               � ߱            $  G  �  ���                                 L  �        X�          4   ����X�  	              x                      ��             	     N  R                  ȑ�                            N  �  8�                         ا       
       
               � ߱            $  O  (  ���                           �                         `�                             � ߱        �  $  Y  �  ���                           ��     
                    `�                         x�  @        
 �              ��  @        
 ��                  � ߱            V   g  (  ���                                        J @          �  x  � X                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
             
                                                                                                                                                                                                                               ) �   �   �   �       (  8  H  X  h  x  �  �  �  �  �  �      (  8  H  X  h  x  �  �  �  �  �  �  �  �      (  8  H  8HXhx��������(8HX     ) �   �   �   �      (  8  H  X  h  x  �  �  �  �  �   �     (  8  H  X  h  x  �  �  �  �  �  �  �  �      (  8  H  8HXhx��������(8HX  �   :                  � �                     �    ��                              ��                                    ����                                    -                          H�                                    �   p       ��                    &  �               X�                         O   ����    e�          O   ����    R�          O   ����    ��              !                        ��                                    ����                                                              �   p       ��                  0  ?  �               �
                        O   ����    e�          O   ����    R�          O   ����    ��      �           �              �                      $                      x  /  <  8     H  ��                          3   ����h�            h                      3   ������      O   =  ��  ��  ��               �          �  �    �                                                         ��                                    ����                                                    h          �   p       ��                  I  t  �               h                        O   ����    e�          O   ����    R�          O   ����    ��      �           �              �                    $                                 H                                                    8             �  /  h  �     �  ��                          3   ������            �                      3   ������  8  /  j         �                          3   ������  �        8  H                  3   ����(�      $   j  x  ���                                                           � ߱                  �  �                  3   ����8�      $   j    ���                                                           � ߱        �  $   n  h  ���                           H�                             � ߱            O   r  ��  ��  x�               8            (   @ �                                                                  0              0                   ��                                    ����                                                    8          �   p       ��                  ~  �  �               0O                        O   ����    e�          O   ����    R�          O   ����    ��      �       $                                              �                                                         /  �  h     x  ��                          3   ������          �  �                  3   ������      $   �  �  ���                                                           � ߱                  (  8                  3   ������      $   �  h  ���                                                           � ߱                               �      0 �                                                                                       ��                                    ����                                                    �           �   p       ��                      �               (o                        O   ����    e�          O   ����    R�          O   ����    ��              �   �        �          4   ���� �      �      �    ��                                    ����                                    TXS appSrvUtils InventoryTrans /vobs_prgs/src//pscade/samples/web/extranet/dinvtran.w should only be RUN PERSISTENT. ADDROW CANCELROW CANNAVIGATE CLOSEQUERY COLUMNPROPS COLVALUES COPYROW CREATEROW DELETEROW FETCHROW FETCHROWIDENT FINDROW FINDROWWHERE FIRSTROWIDS GETLASTCOMMITERRORTYPE HASFOREIGNKEYCHANGED OPENDATAQUERY OPENQUERY PREPAREQUERY ROWAVAILABLE ROWVALUES SUBMITROW UPDATEROW GETOBJECTTYPE xiRocketIndexLimit ADDQUERYWHERE ASSIGNQUERYSELECTION BUFFERCOMPAREDBTORO BUFFERWHERECLAUSE COLUMNDATATYPE COLUMNDBCOLUMN COLUMNQUERYSELECTION COLUMNTABLE COLUMNVALMSG DBCOLUMNDATANAME DBCOLUMNHANDLE EXCLUDECOLUMNS GETDATACOLUMNS GETFOREIGNVALUES GETQUERYPOSITION GETQUERYSORT GETQUERYSTRING GETQUERYWHERE GETTARGETPROCEDURE INDEXINFORMATION INSERTEXPRESSION NEWQUERYSTRING NEWQUERYVALIDATE NEWQUERYWHERE NEWWHERECLAUSE REFRESHROWIDENT REMOVEFOREIGNKEY REMOVEQUERYSELECTION RESOLVEBUFFER ROWIDWHERE ROWIDWHERECOLS SETQUERYPOSITION SETQUERYSORT SETQUERYSTRING SETQUERYWHERE WHERECLAUSEBUFFER GETAPPSERVICE GETASBOUND GETASDIVISION GETASHANDLE GETASHASSTARTED GETASINFO GETASINITIALIZEONRUN GETASUSEPROMPT GETSERVERFILENAME GETSERVEROPERATINGMODE RUNSERVERPROCEDURE SETAPPSERVICE SETASDIVISION SETASHANDLE SETASINFO SETASINITIALIZEONRUN SETASUSEPROMPT SETSERVERFILENAME SETSERVEROPERATINGMODE gshAstraAppserver gshSessionManager gshRIManager gshSecurityManager gshProfileManager gshRepositoryManager gshTranslationManager gshWebManager gscSessionId gsdSessionObj gshFinManager gshGenManager gshAgnManager gsdTempUniqueID gsdUserObj gsdRenderTypeObj gsdSessionScopeObj ghProp ghADMProps ghADMPropsBuf glADMLoadFromRepos glADMOk ANYMESSAGE ASSIGNLINKPROPERTY FETCHMESSAGES GETCHILDDATAKEY GETCONTAINERHANDLE GETCONTAINERHIDDEN GETCONTAINERSOURCE GETCONTAINERSOURCEEVENTS GETCONTAINERTYPE GETDATALINKSENABLED GETDATASOURCE GETDATASOURCEEVENTS GETDATASOURCENAMES GETDATATARGET GETDATATARGETEVENTS GETDBAWARE GETDESIGNDATAOBJECT GETDYNAMICOBJECT GETINSTANCEPROPERTIES GETLOGICALOBJECTNAME GETLOGICALVERSION GETOBJECTHIDDEN GETOBJECTINITIALIZED GETOBJECTNAME GETOBJECTPAGE GETOBJECTPARENT GETOBJECTVERSION GETOBJECTVERSIONNUMBER GETPARENTDATAKEY GETPASSTHROUGHLINKS GETPHYSICALOBJECTNAME GETPHYSICALVERSION GETPROPERTYDIALOG GETQUERYOBJECT GETRUNATTRIBUTE GETSUPPORTEDLINKS GETTRANSLATABLEPROPERTIES GETUIBMODE GETUSERPROPERTY INSTANCEPROPERTYLIST LINKHANDLES LINKPROPERTY MAPPEDENTRY MESSAGENUMBER PROPERTYTYPE REVIEWMESSAGES SETCHILDDATAKEY SETCONTAINERHIDDEN SETCONTAINERSOURCE SETCONTAINERSOURCEEVENTS SETDATALINKSENABLED SETDATASOURCE SETDATASOURCEEVENTS SETDATASOURCENAMES SETDATATARGET SETDATATARGETEVENTS SETDBAWARE SETDESIGNDATAOBJECT SETDYNAMICOBJECT SETINSTANCEPROPERTIES SETLOGICALOBJECTNAME SETLOGICALVERSION SETOBJECTNAME SETOBJECTPARENT SETOBJECTVERSION SETPARENTDATAKEY SETPASSTHROUGHLINKS SETPHYSICALOBJECTNAME SETPHYSICALVERSION SETRUNATTRIBUTE SETSUPPORTEDLINKS SETTRANSLATABLEPROPERTIES SETUIBMODE SETUSERPROPERTY SHOWMESSAGE SIGNATURE prepareInstance ObjectName CHAR  ObjectVersion ADM2.2 ObjectType SmartDataObject ContainerType PropertyDialog adm2/support/datad.w QueryObject LOGICAL ContainerHandle HANDLE InstanceProperties AppService,ASInfo,ASUsePrompt,CacheDuration,CheckCurrentChanged,DestroyStateless,DisconnectAppServer,ServerOperatingMode,ShareData,UpdateFromSource,ForeignFields,ObjectName,OpenOnInit,PromptColumns,PromptOnDelete,RowsToBatch,RebuildOnRepos,ToggleDataTargets SupportedLinks Data-Source,Data-Target,Navigation-Target,Update-Target,Commit-Target,Commit-Source ContainerHidden ObjectInitialized ObjectHidden ObjectsCreated HideOnInit UIBMode ContainerSource ContainerSourceEvents initializeObject,hideObject,viewObject,destroyObject,enableObject,confirmExit,confirmCancel,confirmOk,isUpdateActive DataSource DataSourceEvents dataAvailable,queryPosition,updateState,deleteComplete,fetchDataSet,confirmContinue,confirmCommit,confirmUndo,assignMaxGuess,isUpdatePending TranslatableProperties ObjectPage INT DBAware DesignDataObject DataSourceNames DataTarget DataTargetEvents CHARACTER updateState,rowObjectState,fetchBatch,LinkState LogicalObjectName PhysicalObjectName LogicalVersion PhysicalVersion DynamicObject RunAttribute ChildDataKey ParentDataKey DataLinksEnabled InactiveLinks InstanceId DECIMAL SuperProcedure SuperProcedureMode SuperProcedureHandle LayoutPosition ClassName RenderingProcedure ThinRenderingProcedure Label cType ADMProps Target WHERE Target = WIDGET-H(" ") AppService ASDivision ASHandle ASHasConnected ASHasStarted ASInfo ASInitializeOnRun ASUsePrompt BindSignature BindScope ServerOperatingMode ServerFileName ServerFirstCall NeedContext AutoCommit BLOBColumns BufferHandles CLOBColumns CommitSource CommitSourceEvents commitTransaction,undoTransaction CommitTarget CommitTargetEvents rowObjectState CurrentRowid ROWID CurrentUpdateSource DataColumns DataHandle DataIsFetched DataModified DataQueryBrowsed DataQueryString FetchOnOpen FillBatchOnRepos FilterActive FilterAvailable FilterSource FilterWindow FirstRowNum ForeignFields ForeignValues IgnoreTreeViewFilter IndexInformation LargeColumns LastRowNum NavigationSource NavigationSourceEvents fetchFirst,fetchNext,fetchPrev,fetchLast,startFilter OpenOnInit PrimarySDOSource PromptColumns PromptOnDelete QueryColumns QueryPosition QueryString RebuildOnRepos RowObject RowObjectState NoUpdates RowsToBatch Tables ToggleDataTargets TransferChildrenForAll UpdatableColumns UpdatableWhenNew UpdateSource AssignList AuditEnabled BaseQuery CalcFieldList CheckLastOnOpen DataColumnsByTable DBNames EntityFields FetchHasAudit FetchHasComment FetchAutoComment FirstResultRow KeyFields KeyTableId LastDBRowIdent LastResultRow NewBatchInfo NoLockReadOnlyTables PhysicalTables PositionForClient QueryHandle QueryRowIdent RequiredProperties SkipTransferDBRow TempTables UpdatableColumnsByTable UpdateFromSource WordIndexedFields RowObjUpd RowObjectTable RowObjUpdTable CheckCurrentChanged StatelessSavedProperties CheckCurrentChanged,RowObjectState,LastResultRow,FirstResultRow,QueryRowIdent DestroyStateless DisconnectAppServer ServerSubmitValidation DataFieldDefs "samples/web/extranet/dinvtran.i" QueryContainer QueryContext AsynchronousSDO DataLogicProcedure DataLogicObject DataReadHandler DataReadColumns DataReadBuffer DataDelimiter | DataReadFormat TrimNumeric IsRowObjectExternal IsRowObjUpdExternal ManualAddQueryWhere DynamicData LastCommitErrorType LastCommitErrorKeys RunDataLogicProxy SchemaLocation CacheDuration INTEGER ShareData ghContainer adm2/smart.p cObjectName iStart / \ . hReposBuffer hPropTable hBuffer hTable deleteProperties ADM-CLONE-PROPS pcProcName hProc START-SUPER-PROC cAppService cASDivision cServerOperatingMode adm2/appserver.p getAppService Server NONE setASDivision setAppService adm2/dataquery.p dataAvailable,confirmContinue,isUpdatePending,buildDataRequest adm2/query.p adm2/queryext.p cTable iTable cColumns cDataCols cUpdCols cCalcData cCalcUpd iNumData iNumUpd cBuffers cKeyFields cAssignList iAssigns iPos iEntry iCount cTables cTableAssign cDbEntry cField cKeyTable cQueryString ,   hQuery cOpenQuery cDBNames cPhysicalTables cKeyTableEntityFields cKeyTableEntityValues cKeyTableEntityMnemonic cKeyTableEntityObjField cDBName cEntityFields lHasObjectField lHasAudit lHasComment lHasAutoComment iLookup iAlias  STATIC setDBNames OPEN QUERY Query-Main FOR EACH InventoryTrans NO-LOCK.  FOR   PRESELECT  setOpenQuery 5 showMessage ; BinNum InvType Itemnum Ordernum InvTransNum PONum Qty TransDate Transtime WarehouseNum Query-Main INITPROPS piTableIndex lRet DELETERECORDSTATIC adm2/data.p adm2/dataext.p adm2/dataextcols.p adm2/dataextapi.p BinNum InvType Itemnum Ordernum InvTransNum PONum Qty TransDate Transtime WarehouseNum RowNum RowIdent RowMod RowIdentIdx RowUserProp ChangedFields cContainerType hRowObject hDataQuery cDataFieldDefs FOR EACH  setRowObjectTable setRowObjUpdTable getUpdatableColumns REMOVE Update-Target PUSHROWOBJUPDTABLE pcValType PUSHTABLEANDVALIDATE pcContext pcMessages pcUndoIds obtainContextForClient REMOTECOMMIT SERVERCOMMIT GETROWOBJUPDSTATIC DISABLE_UI qDataQuery �  �6  �  @E      / @   ��      0         pcServices          ��      X         pcServices      �   ��      �         piStartRow      �   ��      �         piStartRow      �   ��      �         piStartRow        ��      �         piStartRow          ��               piStartRow      X  ��      H        pcViewColList       ��      p       
 pcViewColList       ��      �        pcRelative      �  ��      �        pcSdoName           ��      �  �     
 pcSdoName           ��              plForwards          ��      8        pcContext           ��      `        plUpdate        �  ��      �        pcFieldList     �  ��      �        pcFieldList         ��      �        pcFieldList       ��               piocContext     8  ��      (        piocContext     `  ��      P        piocContext     �  ��      x        piocContext     �  ��      �        piocContext     �  ��      �        piocContext        ��      �  �     
 piocContext         ��              piocContext         ��      @        pcState     ��      `        pcContext       �  ��      �        piStartRow      �  ��      �        piStartRow      �  ��      �        piStartRow        ��               piStartRow      8  ��      (        piStartRow          ��      P  �     
 piStartRow          ��      x  �     
 phRowObjUpd         ��      �        pcProperties    �  ��      �        piStartRow         ��      �        piStartRow      (  ��              piStartRow      P  ��      @        piStartRow      x  ��      h        piStartRow          ��      �  �     
 piStartRow      �  ��      �        pcRowIdent          ��      �        pcRowIdent        ��              pcRowIdent      @  ��      0        pcRowIdent          ��      X        pcRowIdent      �  ��      �        pcValueList         ��      �        pcValueList     �  ��      �        pcPropertiesForServer       ��               pcPropertiesForServer   @  ��      0        pcFieldList     h  ��      X        pcFieldList     �  ��      �        pcFieldList         ��      �        pcFieldList     �  ��      �        pcWhere     ��      �        pcWhere     ��      	        pcState     ��      0	       
 phRowObjUpd     h	  ��      X	       
 phRowObj        �	  ��      �	       
 phRowObj        �	  ��      �	        phRowObj            ��      �	        phRowObj            ��      �	        pioCancel           ��       
        pcRelative          ��      H
       
 phFilterContainer           ��      x
       
 phRowObjUpd     �
  ��      �
        pcRowIdent          ��      �
        pcRowIdent          ��      �
       
 phAppService        ��              pcMode  H  ��      8       
 phSource        p  ��      `        phSource            ��      �       
 phSource        �  ��      �        pcText  �  ��      �        pcText      ��      �        pcText     ��             
 phObject        H  ��      8       
 phObject            ��      `        phObject            ��      �        pcField     ��      �        pcCursor        �  ��      �       
 phCaller          ��      �        phCaller        0  ��               phCaller            ��      H        phCaller        x  ��      p        pcMod   �  ��      �        pcMod       ��      �       
 pcMod   �  ��      �       
 phSource          ��      �        phSource            ��              
 phSource        P  ��      H        pdRow       ��      h        pdRow       ��      �       
 hTarget �  ��      �        pcMessage           ��      �        pcMessage           ��      �        plEnabled                           cType       h     V             X                  getObjectType   a	  y	  {	      �        �  
       hReposBuffer    �        �  
       hPropTable      �        �  
       hBuffer              
       hTable  (  H     W   x          8                  adm-clone-props �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �                �  
       hProc             �        pcProcName           	   X   �  �                        start-super-proc        �  �  �  �  �  �  �  �  �      h        `         cTable  �        �         iTable  �        �         cColumns        �        �         cDataCols                �         cUpdCols        (                 cCalcData       P        @         cCalcUpd        x     	   h         iNumData        �     
   �         iNumUpd �        �         cBuffers        �        �         cKeyFields                        cAssignList     8        (         iAssigns        X        P         iPos    x        p         iEntry  �        �         iCount  �        �         cTables �       �         cTableAssign            �         cDbEntry        (                  cField  P        @         cKeyTable       x        h         cQueryString    �        �  
       hQuery  �        �  
       hBuffer �        �         cOpenQuery              �         cDBNames        0                  cPhysicalTables `        H         cKeyTableEntityFields   �        x         cKeyTableEntityValues   �        �         cKeyTableEntityMnemonic �         �         cKeyTableEntityObjField      !            cDBName 8     "   (         cEntityFields   `     #   P         lHasObjectField �     $   x         lHasAudit       �     %   �         lHasComment     �     &   �         lHasAutoComment �     '   �         iLookup        (            iAlias  �  X  3   Y   H          H                  initProps       �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  *  �  �  >  C  E  F  G  J  L  N  O  R  S  Y  g  �                @         lRet              `        piTableIndex      �  *   Z   (  H      �                  deleteRecordStatic      �  �  �  �  �  �  �  �      5  6  R  S  o  p  �  �  �  �  �  �  �  �           :  ;  W  X  t  u  �  �  �  �  �  �  �  �                 !       p  �     [       `      �                  pushRowObjUpdTable      &      �        �        pcValType                      $       x  P     \       �      8                  pushTableAndValidate    <  =  ?      �        x        pcContext       �             $       �        �        pcMessages                �        pcUndoIds         0     ]       `                         remoteCommit    h  j  n  r  t      `             $       �        x        pcMessages                �        pcUndoIds       �  �     ^       H      �                  serverCommit    �  �  �  @     _               (                  getRowObjUpdStatic      �  �  �  �     `               x                  disable_UI          H  8&       �      �%                      P  �  �     RowObject       �         �         �         �         �         �         �         �         �                                     (         0         @             BinNum  InvType Itemnum Ordernum        InvTransNum     PONum   Qty     TransDate       Transtime       WarehouseNum    RowNum  RowIdent        RowMod  RowIdentIdx     RowUserProp         `  p     RowObjUpd       0         8         @         H         X         h         p         x         �         �         �         �         �         �         �         �         BinNum  InvType Itemnum Ordernum        InvTransNum     PONum   Qty     TransDate       Transtime       WarehouseNum    RowNum  RowIdent        RowMod  RowIdentIdx     RowUserProp     ChangedFields                  
       appSrvUtils     P        8          xiRocketIndexLimit      �         h   
       gshAstraAppserver       �         �   
       gshSessionManager       �         �   
       gshRIManager    !        �   
       gshSecurityManager      8!         !  
       gshProfileManager       h!  	 	     P!  
       gshRepositoryManager    �!  
 
     �!  
       gshTranslationManager   �!        �!  
       gshWebManager   �!        �!         gscSessionId    "         "         gsdSessionObj   8"        ("  
       gshFinManager   `"        P"  
       gshGenManager   �"        x"  
       gshAgnManager   �"        �"         gsdTempUniqueID �"        �"         gsdUserObj      #        �"         gsdRenderTypeObj        8#         #         gsdSessionScopeObj      X#       P#  
       ghProp  �#       p#  
       ghADMProps      �#       �#  
       ghADMPropsBuf   �#       �#         glADMLoadFromRepos      �#       �#         glADMOk  $       $  
       ghContainer     H$    	   8$         cObjectName     h$    
   `$         iStart  �$       �$         cAppService     �$       �$         cASDivision     �$       �$         cServerOperatingMode    %        %         cContainerType  8%       (%         cQueryString    `%       P%  
       hRowObject      �%       x%  
       hDataQuery      �%       �%         cColumns                 �%         cDataFieldDefs  �%       �%  InventoryTrans  &    H  &  RowObject             X  (&  RowObjUpd                N   �   �   �   �   /  0  1  2  I  U  V  W  Y  [  \  ]  a  b  e  f  g  h  j  l  n  p  q  r  u  w  x  z  {  |  }  ~  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  &	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  "
  R
  S
  U
  V
  W
  X
  Y
  Z
  \
  ]
  ^
  _
  `
  a
  b
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
  t
  v
  w
  x
  y
  z
  {
  |
  }
  ~
  
  �
  �
  �
  �
  �
  �
  �
  �
  �
               	  
                                            �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  @  �  �  �                 1  C  b  d  y        4  D  E  F  I  J  K  R  S  p  �  �  6  7  C  g  �  �  �  �  �  T  �  �  �  �  �  �  �  M  g  q  �  �  �  �  �  �  �  �      7  A  [  }  �  �          ��  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/data.i        h*  �) . ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/datacustom.i   �*  �� - '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/robjflds.i    �*  hL , ,/vobs_prgs/src//pscade/samples/web/extranet/dinvtran.i       0+  �:  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/query.i       x+  z + '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/delrecst.i    �+  `W * '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/tblprep.i     �+  F� ) /vobs_possenet/src/wrappers/fnarg    8,   ( ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/querycustom.i  h,  �   '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/dataquery.i   �,  �Z ' ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/dataquerycustom.i      �,  �< ! '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/appserver.i   @-  �� & ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/appservercustom.i      �-  I� " '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/smart.i       �-  Ds % /vobs_possenet/src/wrappers/fn       .  tw $ ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/smartcustom.i  @.  Q. # /vobs_possenet/src/wrappers/set      �.  �>  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/dataprop.i    �.  ��  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/datapropcustom.i       �.  ��  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/dataprtocustom.i       H/  YO  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/qryprop.i     �/  -�  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/qrypropcustom.i        �/  ��  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/qryprtocustom.i        (0   	 '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/dataqueryprop.i       x0  �d  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/dataquerypropcustom.i  �0  ��  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/dataqueryprtocustom.i  1  �l  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/appsprop.i    `1  ɏ  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/appspropcustom.i       �1  V  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/appsprtocustom.i       �1  i$  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/smrtprop.i    @2  �j  /vobs_possenet/src/wrappers/get      �2  �  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/smrtpropcustom.i       �2  ��  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/smrtprtocustom.i        3  ��  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/smrtprto.i    P3  Su  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/globals.i     �3  M�  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/globalscustom.i        �3  )a  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/smartdefscustom.i       4  �  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/appsprto.i    p4  ��  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/appserverdefscustom.i  �4  ��  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/dataqueryprto.i        5  ª 
 ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/dataquerydefscustom.i  H5  ��  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/qryprto.i     �5  �  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/querydefscustom.i      �5  �`  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/dataprto.i    (6  �  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/datadefscustom.i       h6  e�  /vobs_possenet/src/adecomm/appserv.i �6  ��   ,/vobs_prgs/src//pscade/samples/web/extranet/dinvtran.w           �   �      07  [  q     @7     o  %   P7  �   �     `7     �  .   p7  �   �     �7     h     �7  �   e     �7     C  #   �7  �   A     �7       #   �7  �        �7     �  #   �7  �   �      8     �  #   8  �   �      8     �  #   08  �   �     @8     �  #   P8  �   �     `8     i  #   p8  �   g     �8     E  #   �8  �   8     �8        -   �8  �        �8       ,   �8  k   �     �8  �  �     �8     �  +    9  �  �     9     �  +    9  �  �     09     w  +   @9  �  t     P9     Z  +   `9  �  W     p9     =  +   �9  �  :     �9        +   �9  �       �9       +   �9  �        �9     �  +   �9  �  �     �9     �  +    :  �  �     :     �  +    :  �  �     0:     �  +   @:  �  �     P:     r  +   `:  �  o     p:     U  +   �:  �  R     �:     8  +   �:  �  5     �:       +   �:  �       �:     �  +   �:  �  �     �:     �  +    ;  �  �     ;     �  +    ;  �  �     0;     �  #   @;  �  �     P;     _  #   `;  k  :     p;       #   �;  j       �;     �  #   �;  i  �     �;     �  #   �;  _  �     �;     �  *   �;  ^  �     �;     {  *    <  ]  z     <     T  *    <  \  S     0<     -  *   @<  [  ,     P<       *   `<  Z       p<     �  *   �<  Y  �     �<     �  *   �<  X  �     �<     �  *   �<  W  �     �<     j  *   �<  V  i     �<     C  *    =  U  B     =       *    =  T       0=     �  *   @=  S  �     P=     �  *   `=  R  �     p=     �  *   �=  Q  �     �=     �  *   �=  P       �=     Y  *   �=  O  X     �=     2  *   �=  N  1     �=       *    >  @  �     >     �  #    >  	  �     0>     �  )   @>  �   �     P>     o  #   `>  �   n     p>     L  #   �>  �   K     �>     )  #   �>  �   (     �>       #   �>  �        �>     �  #   �>  �   �     �>     �  #    ?  �   P     ?     �  (    ?  g   �     0?  a   �      @?     �  '   P?  _   �      `?     _  #   p?  ]   ]      �?     ;  #   �?  I   '      �?  �     !   �?     �  &   �?  �   �  !   �?     �  #   �?  �   �  !   �?     |  #    @  �   z  !   @     X  #    @  g   >  !   0@          @@  O     !   P@  �   �  "   `@     �  %   p@  �   _  "   �@       $   �@  �   �  "   �@     �  #   �@  �   �  "   �@     �  #   �@  �   �  "   �@     �  #   �@  �   �  "    A     q  #   A  �   ]  "    A     ;  #   0A  }   /  "   @A       #   PA     �  "   `A     C  !   pA     �      �A     �     �A     I     �A  �   @     �A  O   2     �A     !     �A     �     �A  �   �     �A  �   �      B  O   �     B     r      B     $     0B  y   �
     @B  �   �
  	   PB  G   �
     `B     �
     pB     �
     �B  c   *
  	   �B  x   "
     �B  M   
     �B     �	     �B     �	     �B  a   �	     �B  �  x	     �B     Y	      C  �  &	     C  O   	      C     	     0C     �     @C  �   �     PC     �     `C     
     pC  x        �C     �     �C     t     �C     p     �C     \     �C     C     �C  Q   3     �C     �     �C     �      D     �     D     s      D  ]   m  	   0D     c     @D       	   PD       
   `D     �  	   pD  Z   �     �D          �D     �     �D     �     �D     �     �D  c   w     �D     U     �D          �D     �       E     �      E     �       E     !       0E           