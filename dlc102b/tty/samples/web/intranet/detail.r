	��V�&K�<  8��C              #                                _� 3C88010Eundefined MAIN /vobs_possenet/e4gl/samples/web/intranet/detail.w,, PROCEDURE local-e4gl-options,,OUTPUT p_version DECIMAL,OUTPUT p_options CHARACTER,OUTPUT p_content-type CHARACTER PROCEDURE initProps,, PROCEDURE start-super-proc,,INPUT pcProcName CHARACTER PROCEDURE adm-clone-props,, PROCEDURE set-attribute-list,,INPUT p-attr-list CHARACTER PROCEDURE get-attribute,,INPUT p_attr-name CHARACTER PROCEDURE dispatch,,INPUT p-method-name CHARACTER PROCEDURE adm-timing-out,, PROCEDURE adm-destroy,, PROCEDURE viewObject,, PROCEDURE toggleData,,INPUT plEnabled LOGICAL PROCEDURE showMessageProcedure,,INPUT pcMessage CHARACTER,OUTPUT plAnswer LOGICAL PROCEDURE returnFocus,,INPUT hTarget HANDLE PROCEDURE repositionObject,,INPUT pdRow DECIMAL,INPUT pdCol DECIMAL PROCEDURE removeLink,,INPUT phSource HANDLE,INPUT pcLink CHARACTER,INPUT phTarget HANDLE PROCEDURE removeAllLinks,, PROCEDURE modifyUserLinks,,INPUT pcMod CHARACTER,INPUT pcLinkName CHARACTER,INPUT phObject HANDLE PROCEDURE modifyListProperty,,INPUT phCaller HANDLE,INPUT pcMode CHARACTER,INPUT pcListName CHARACTER,INPUT pcListValue CHARACTER PROCEDURE hideObject,, PROCEDURE exitObject,, PROCEDURE editInstanceProperties,, PROCEDURE displayLinks,, PROCEDURE destroyObject,, PROCEDURE createControls,, PROCEDURE changeCursor,,INPUT pcCursor CHARACTER PROCEDURE applyEntry,,INPUT pcField CHARACTER PROCEDURE adjustTabOrder,,INPUT phObject HANDLE,INPUT phAnchor HANDLE,INPUT pcPosition CHARACTER PROCEDURE addMessage,,INPUT pcText CHARACTER,INPUT pcField CHARACTER,INPUT pcTable CHARACTER PROCEDURE addLink,,INPUT phSource HANDLE,INPUT pcLink CHARACTER,INPUT phTarget HANDLE PROCEDURE transferDBRow,,INPUT pcRowIdent CHARACTER,INPUT piRowNum INTEGER PROCEDURE startFilter,, PROCEDURE releaseDBRow,, PROCEDURE refetchDBRow,,INPUT phRowObjUpd HANDLE PROCEDURE initializeObject,, PROCEDURE filterContainerHandler,,INPUT phFilterContainer HANDLE PROCEDURE fetchDBRowForUpdate,, PROCEDURE dataAvailable,,INPUT pcRelative CHARACTER PROCEDURE confirmContinue,,INPUT-OUTPUT pioCancel LOGICAL PROCEDURE compareDBRow,, PROCEDURE bufferCopyDBToRO,,INPUT phRowObj HANDLE,INPUT phBuffer HANDLE,INPUT pcExcludes CHARACTER,INPUT pcAssigns CHARACTER PROCEDURE assignDBRow,,INPUT phRowObjUpd HANDLE PROCEDURE fetchCurrent,, PROCEDURE fetchFirst,, PROCEDURE fetchLast,, PROCEDURE fetchNext,, PROCEDURE fetchPrev,, PROCEDURE assignFields,, PROCEDURE ProcessWebRequest,, FUNCTION deleteRecordStatic,logical,INPUT piTableIndex INTEGER FUNCTION Signature,CHARACTER,INPUT pcName CHARACTER FUNCTION showmessage,LOGICAL,INPUT pcMessage CHARACTER FUNCTION setUserProperty,LOGICAL,INPUT pcPropName CHARACTER,INPUT pcPropValue CHARACTER FUNCTION setUIBMode,LOGICAL,INPUT pcMode CHARACTER FUNCTION setTranslatableProperties,LOGICAL,INPUT pcPropList CHARACTER FUNCTION setSupportedLinks,LOGICAL,INPUT pcLinkList CHARACTER FUNCTION setRunAttribute,LOGICAL,INPUT cRunAttribute CHARACTER FUNCTION setPhysicalVersion,LOGICAL,INPUT cVersion CHARACTER FUNCTION setPhysicalObjectName,LOGICAL,INPUT cTemp CHARACTER FUNCTION setPassThroughLinks,LOGICAL,INPUT pcLinks CHARACTER FUNCTION setParentDataKey,LOGICAL,INPUT cParentDataKey CHARACTER FUNCTION setObjectVersion,LOGICAL,INPUT cObjectVersion CHARACTER FUNCTION setObjectParent,LOGICAL,INPUT phParent HANDLE FUNCTION setObjectName,LOGICAL,INPUT pcName CHARACTER FUNCTION setLogicalVersion,LOGICAL,INPUT cVersion CHARACTER FUNCTION setLogicalObjectName,LOGICAL,INPUT c CHARACTER FUNCTION setInstanceProperties,LOGICAL,INPUT pcPropList CHARACTER FUNCTION setDynamicObject,LOGICAL,INPUT lTemp LOGICAL FUNCTION setDesignDataObject,LOGICAL,INPUT pcDataObject CHARACTER FUNCTION setDBAware,LOGICAL,INPUT lAware LOGICAL FUNCTION setDataTargetEvents,LOGICAL,INPUT pcEvents CHARACTER FUNCTION setDataTarget,LOGICAL,INPUT pcTarget CHARACTER FUNCTION setDataSourceNames,LOGICAL,INPUT pcSourceNames CHARACTER FUNCTION setDataSourceEvents,LOGICAL,INPUT pcEventsList CHARACTER FUNCTION setDataSource,LOGICAL,INPUT phObject HANDLE FUNCTION setDataLinksEnabled,LOGICAL,INPUT lDataLinksEnabled LOGICAL FUNCTION setContainerSourceEvents,LOGICAL,INPUT pcEvents CHARACTER FUNCTION setContainerSource,LOGICAL,INPUT phObject HANDLE FUNCTION setContainerHidden,LOGICAL,INPUT plHidden LOGICAL FUNCTION setChildDataKey,LOGICAL,INPUT cChildDataKey CHARACTER FUNCTION reviewMessages,CHARACTER, FUNCTION propertyType,CHARACTER,INPUT pcPropName CHARACTER FUNCTION messageNumber,CHARACTER,INPUT piMessage INTEGER FUNCTION mappedEntry,CHARACTER,INPUT pcEntry CHARACTER,INPUT pcList CHARACTER,INPUT plFirst LOGICAL,INPUT pcDelimiter CHARACTER FUNCTION linkProperty,CHARACTER,INPUT pcLink CHARACTER,INPUT pcPropName CHARACTER FUNCTION linkHandles,CHARACTER,INPUT pcLink CHARACTER FUNCTION instancePropertyList,CHARACTER,INPUT pcPropList CHARACTER FUNCTION getUserProperty,CHARACTER,INPUT pcPropName CHARACTER FUNCTION getUIBMode,CHARACTER, FUNCTION getTranslatableProperties,CHARACTER, FUNCTION getSupportedLinks,CHARACTER, FUNCTION getRunAttribute,CHARACTER, FUNCTION getQueryObject,LOGICAL, FUNCTION getPropertyDialog,CHARACTER, FUNCTION getPhysicalVersion,CHARACTER, FUNCTION getPhysicalObjectName,CHARACTER, FUNCTION getPassThroughLinks,CHARACTER, FUNCTION getParentDataKey,CHARACTER, FUNCTION getObjectVersionNumber,CHARACTER, FUNCTION getObjectVersion,CHARACTER, FUNCTION getObjectParent,HANDLE, FUNCTION getObjectPage,INTEGER, FUNCTION getObjectName,CHARACTER, FUNCTION getObjectInitialized,LOGICAL, FUNCTION getObjectHidden,LOGICAL, FUNCTION getLogicalVersion,CHARACTER, FUNCTION getLogicalObjectName,CHARACTER, FUNCTION getInstanceProperties,CHARACTER, FUNCTION getDynamicObject,LOGICAL, FUNCTION getDesignDataObject,CHARACTER, FUNCTION getDBAware,LOGICAL, FUNCTION getDataTargetEvents,CHARACTER, FUNCTION getDataTarget,CHARACTER, FUNCTION getDataSourceNames,CHARACTER, FUNCTION getDataSourceEvents,CHARACTER, FUNCTION getDataSource,HANDLE, FUNCTION getDataLinksEnabled,LOGICAL, FUNCTION getContainerType,CHARACTER, FUNCTION getContainerSourceEvents,CHARACTER, FUNCTION getContainerSource,HANDLE, FUNCTION getContainerHidden,LOGICAL, FUNCTION getContainerHandle,HANDLE, FUNCTION getChildDataKey,CHARACTER, FUNCTION fetchMessages,CHARACTER, FUNCTION assignLinkProperty,LOGICAL,INPUT pcLink CHARACTER,INPUT pcPropName CHARACTER,INPUT pcPropValue CHARACTER FUNCTION whereClauseBuffer,CHARACTER,INPUT pcWhere CHARACTER FUNCTION setQueryString,LOGICAL,INPUT pcQueryString CHARACTER FUNCTION setQuerySort,LOGICAL,INPUT pcSort CHARACTER FUNCTION setQueryPosition,LOGICAL,INPUT pcPosition CHARACTER FUNCTION rowidWhereCols,CHARACTER,INPUT pcColumns CHARACTER,INPUT pcValues CHARACTER,INPUT pcOperators CHARACTER FUNCTION rowidWhere,CHARACTER,INPUT pcWhere CHARACTER FUNCTION resolveBuffer,CHARACTER,INPUT pcBuffer CHARACTER FUNCTION removeQuerySelection,LOGICAL,INPUT pcColumns CHARACTER,INPUT pcOperators CHARACTER FUNCTION removeForeignKey,LOGICAL, FUNCTION refreshRowident,CHARACTER,INPUT pcRowident CHARACTER FUNCTION prepareQuery,LOGICAL,INPUT pcQuery CHARACTER FUNCTION newWhereClause,CHARACTER,INPUT pcBuffer CHARACTER,INPUT pcExpression CHARACTER,INPUT pcWhere CHARACTER,INPUT pcAndOr CHARACTER FUNCTION newQueryWhere,CHARACTER,INPUT pcWhere CHARACTER FUNCTION newQueryValidate,CHARACTER,INPUT pcQueryString CHARACTER,INPUT pcExpression CHARACTER,INPUT pcBuffer CHARACTER,INPUT pcAndOr CHARACTER FUNCTION newQueryString,CHARACTER,INPUT pcColumns CHARACTER,INPUT pcValues CHARACTER,INPUT pcOperators CHARACTER,INPUT pcQueryString CHARACTER,INPUT pcAndOr CHARACTER FUNCTION insertExpression,CHARACTER,INPUT pcWhere CHARACTER,INPUT pcExpression CHARACTER,INPUT pcAndOr CHARACTER FUNCTION indexInformation,CHARACTER,INPUT pcQuery CHARACTER,INPUT plUseTableSep LOGICAL,INPUT pcIndexInfo CHARACTER FUNCTION getTargetProcedure,HANDLE, FUNCTION getQueryString,CHARACTER, FUNCTION getQuerySort,CHARACTER, FUNCTION getQueryPosition,CHARACTER, FUNCTION getObjectType,character, FUNCTION getForeignValues,CHARACTER, FUNCTION getDataColumns,CHARACTER, FUNCTION firstRowIds,CHARACTER,INPUT pcQueryString CHARACTER FUNCTION excludeColumns,CHARACTER,INPUT iTable INTEGER FUNCTION dbColumnHandle,HANDLE,INPUT pcColumn CHARACTER FUNCTION dbColumnDataName,CHARACTER,INPUT pcDbColumn CHARACTER FUNCTION colValues,CHARACTER,INPUT pcViewColList CHARACTER FUNCTION columnTable,CHARACTER,INPUT pcColumn CHARACTER FUNCTION columnQuerySelection,CHARACTER,INPUT pcColumn CHARACTER FUNCTION columnDbColumn,CHARACTER,INPUT pcColumn CHARACTER FUNCTION closeQuery,LOGICAL, FUNCTION bufferWhereClause,CHARACTER,INPUT pcBuffer CHARACTER,INPUT pcWhere CHARACTER FUNCTION bufferCompareDBToRO,LOGICAL,INPUT phRowObjUpd HANDLE,INPUT phBuffer HANDLE,INPUT pcExcludes CHARACTER,INPUT pcAssigns CHARACTER FUNCTION assignQuerySelection,LOGICAL,INPUT pcColumns CHARACTER,INPUT pcValues CHARACTER,INPUT pcOperators CHARACTER FUNCTION addQueryWhere,LOGICAL,INPUT pcWhere CHARACTER,INPUT pcBuffer CHARACTER,INPUT pcAndOr CHARACTER FUNCTION validateColumnValue,LOGICAL,INPUT pColumn CHARACTER,INPUT pValue CHARACTER FUNCTION urlLink,CHARACTER,INPUT pcWebObject CHARACTER,INPUT pcJoin CHARACTER FUNCTION urlJoinParams,CHARACTER,INPUT pJoin CHARACTER FUNCTION startDataObject,LOGICAL,INPUT pcDataSource CHARACTER FUNCTION showDataMessages,CHARACTER, FUNCTION setUpdateMode,LOGICAL,INPUT pMode CHARACTER FUNCTION setServerConnection,LOGICAL,INPUT pConnection CHARACTER FUNCTION setSearchColumns,LOGICAL,INPUT pSearchColumns CHARACTER FUNCTION setQueryWhere,LOGICAL,INPUT pWhere CHARACTER FUNCTION setNavigationMode,LOGICAL,INPUT pmode CHARACTER FUNCTION setLinkColumns,LOGICAL,INPUT pLinkColumns CHARACTER FUNCTION setForeignFieldList,LOGICAL,INPUT pcForeignFieldList CHARACTER FUNCTION setExternalWhereList,LOGICAL,INPUT pExternalWhereList CHARACTER FUNCTION setExternalTables,LOGICAL,INPUT pExternalTables CHARACTER FUNCTION setExternalTableList,LOGICAL,INPUT pExternalTableList CHARACTER FUNCTION setExternalJoinList,LOGICAL,INPUT pExternalJoinList CHARACTER FUNCTION setCurrentRowids,LOGICAL,INPUT pcRowids CHARACTER FUNCTION setContextFields,LOGICAL,INPUT pContextFields CHARACTER FUNCTION setColumns,LOGICAL,INPUT pColumns CHARACTER FUNCTION setBuffers,LOGICAL,INPUT pcTables CHARACTER FUNCTION setAppService,LOGICAL,INPUT pAppService CHARACTER FUNCTION reopenQuery,LOGICAL, FUNCTION OpenQuery,LOGICAL, FUNCTION joinForeignFields,LOGICAL,INPUT pTables CHARACTER FUNCTION joinExternalTables,LOGICAL,INPUT pTables CHARACTER,INPUT pRowids CHARACTER FUNCTION HTMLSetFocus,LOGICAL,INPUT pForm CHARACTER,INPUT pfield CHARACTER FUNCTION HTMLAlert,LOGICAL,INPUT pMessage CHARACTER FUNCTION getUpdateMode,CHARACTER, FUNCTION getTables,CHARACTER, FUNCTION getTableRowids,CHARACTER, FUNCTION getServerConnection,CHARACTER, FUNCTION getSearchColumns,CHARACTER, FUNCTION getRowids,CHARACTER, FUNCTION getQueryWhere,CHARACTER, FUNCTION getQueryEmpty,LOGICAL, FUNCTION getNavigationMode,CHARACTER, FUNCTION getForeignFieldList,CHARACTER, FUNCTION getCurrentRowids,CHARACTER, FUNCTION getContextFields,CHARACTER, FUNCTION getAppService,CHARACTER, FUNCTION fieldExpression,CHARACTER,INPUT pColumn CHARACTER,INPUT pOperator CHARACTER,INPUT pValue CHARACTER FUNCTION extentValue,INTEGER,INPUT pcColumn CHARACTER FUNCTION destroyDataObject,LOGICAL, FUNCTION columnStringValue,CHARACTER,INPUT pcColumn CHARACTER FUNCTION columnReadOnly,LOGICAL,INPUT pColumn CHARACTER FUNCTION columnLabel,CHARACTER,INPUT pcColumn CHARACTER FUNCTION columnHTMLName,CHARACTER,INPUT pColumn CHARACTER FUNCTION columnHelp,CHARACTER,INPUT pcColumn CHARACTER FUNCTION ColumnHandle,HANDLE,INPUT pcColumn CHARACTER FUNCTION columnFormat,CHARACTER,INPUT pColumn CHARACTER FUNCTION columnDataType,CHARACTER,INPUT pColumn CHARACTER FUNCTION bufferHandle,HANDLE,INPUT pcTableName CHARACTER FUNCTION assignColumnWidth,LOGICAL,INPUT pColumn CHARACTER,INPUT pWidth DECIMAL FUNCTION assignColumnLabel,LOGICAL,INPUT pcColumn CHARACTER,INPUT pcLabel CHARACTER FUNCTION assignColumnHelp,LOGICAL,INPUT pcColumn CHARACTER,INPUT pcHelp CHARACTER FUNCTION assignColumnFormat,LOGICAL,INPUT pColumn CHARACTER,INPUT pFormat CHARACTER FUNCTION anyMessage,LOGICAL, FUNCTION addSearchCriteria,LOGICAL,INPUT pColumn CHARACTER,INPUT pValue CHARACTER FUNCTION addContextFields,LOGICAL,INPUT pNewContextFields CHARACTER FUNCTION validateColumns,LOGICAL, FUNCTION setFrameHandle,LOGICAL,INPUT pHdl HANDLE FUNCTION setDeleteTables,LOGICAL,INPUT pcDeleteTables CHARACTER FUNCTION setAddMode,LOGICAL,INPUT plAdd LOGICAL FUNCTION LockRow,LOGICAL,INPUT pLock CHARACTER FUNCTION getFrameHandle,HANDLE, FUNCTION getDeleteTables,CHARACTER, FUNCTION deleteRow,LOGICAL, FUNCTION deleteBuffer,LOGICAL,INPUT phBuffer HANDLE FUNCTION columnValMsg,CHARACTER,INPUT pColumn CHARACTER EXTERN logNote,LOGICAL,INPUT pcLogType CHARACTER,INPUT pcLogText CHARACTER EXTERN getGlobal,CHARACTER,INPUT cName CHARACTER EXTERN setGlobal,LOGICAL,INPUT cName CHARACTER,INPUT cValue CHARACTER EXTERN getSession,CHARACTER,INPUT cName CHARACTER EXTERN setSession,LOGICAL,INPUT cName CHARACTER,INPUT cValue CHARACTER EXTERN get-config,CHARACTER,INPUT p_name CHARACTER EXTERN check-agent-mode,LOGICAL,INPUT p_mode CHARACTER EXTERN queue-message,INTEGER,INPUT p_grp CHARACTER,INPUT p_message CHARACTER EXTERN output-messages,INTEGER,INPUT p_option CHARACTER,INPUT p_grp CHARACTER,INPUT p_message CHARACTER EXTERN get-message-groups,CHARACTER, EXTERN get-messages,CHARACTER,INPUT p_grp CHARACTER,INPUT p_delete LOGICAL EXTERN available-messages,LOGICAL,INPUT p_grp CHARACTER EXTERN set-cookie,CHARACTER,INPUT p_name CHARACTER,INPUT p_value CHARACTER,INPUT p_date DATE,INPUT p_time INTEGER,INPUT p_path CHARACTER,INPUT p_domain CHARACTER,INPUT p_options CHARACTER EXTERN get-cookie,CHARACTER,INPUT p_name CHARACTER EXTERN delete-cookie,CHARACTER,INPUT p_name CHARACTER,INPUT p_path CHARACTER,INPUT p_domain CHARACTER EXTERN url-format,CHARACTER,INPUT p_url CHARACTER,INPUT p_name-list CHARACTER,INPUT p_delim CHARACTER EXTERN url-field-list,CHARACTER,INPUT p_name-list CHARACTER,INPUT p_delim CHARACTER EXTERN url-field,CHARACTER,INPUT p_name CHARACTER,INPUT p_value CHARACTER,INPUT p_delim CHARACTER EXTERN url-encode,CHARACTER,INPUT p_value CHARACTER,INPUT p_enctype CHARACTER EXTERN url-decode,CHARACTER,INPUT p_in CHARACTER EXTERN set-wseu-cookie,CHARACTER,INPUT p_cookie CHARACTER EXTERN set-user-field,LOGICAL,INPUT p_name CHARACTER,INPUT p_value CHARACTER EXTERN output-http-header,CHARACTER,INPUT p_header CHARACTER,INPUT p_value CHARACTER EXTERN output-content-type,LOGICAL,INPUT p_type CHARACTER EXTERN html-encode,CHARACTER,INPUT p_in CHARACTER EXTERN hidden-field-list,CHARACTER,INPUT p_name-list CHARACTER EXTERN hidden-field,CHARACTER,INPUT p_name CHARACTER,INPUT p_value CHARACTER EXTERN get-user-field,CHARACTER,INPUT p_name CHARACTER EXTERN get-valueEx,LONGCHAR,INPUT p_name CHARACTER EXTERN get-value,CHARACTER,INPUT p_name CHARACTER EXTERN get-long-value,LONGCHAR,INPUT p_name CHARACTER EXTERN get-from-form-fields,LOGICAL,INPUT p_name CHARACTER EXTERN get-fieldEx,LONGCHAR,INPUT p_name CHARACTER EXTERN get-field,CHARACTER,INPUT p_name CHARACTER EXTERN get-cgi-long,LONGCHAR,INPUT p_name CHARACTER EXTERN get-cgi,CHARACTER,INPUT p_name CHARACTER EXTERN get-binary-data,MEMPTR,INPUT p_name CHARACTER EXTERN format-datetime,CHARACTER,INPUT p_format CHARACTER,INPUT p_date DATE,INPUT p_time INTEGER,INPUT p_options CHARACTER EXTERN convert-datetime,CHARACTER,INPUT p_conversion CHARACTER,INPUT p_idate DATE,INPUT p_itime INTEGER,OUTPUT p_odate DATE,OUTPUT p_otime INTEGER     8d              @Z             GV 8d  �              0�              H  	   +   p� H     �� x     0� X     �      � �     p   6   x �  7   ( �  8   �" �  :       ? h% �0  undefined                                                                        (  �c   � �                  �c                  �                   ��  	                         0`  '     �              ��  �   �c      d                                                         PROGRESS                         �                                             �              �                                                                                                           `          �                                 �  �             H                                                                                                              0       �                                 x  P                                                                                                        0                 �  @       H                                 0               �                                                                                          @                 �  L                                         �  �             p                                                                                          L                 @  X       �                                 �  x             (                                                                                          X                 �  g       p                                 X  0             �                                                                                          g                 �  s       (                                   �             �                                                                                          s                 h  }       �                                 �  �             P                                                                                          }                    �       �                                 �  X  	                                                                                                     �                 �  �       P                                 8  	  
           �                                                                                          �                 �	  �       	                                 �  �	             x	                                                                                          �                 H
  �       �	                                 �	  �
             0
                                                                                          �                    �       x
                                 `
  8             �
                                                                                          �                 �  �       0                                   �             �                                                                                          �                 p  �       �                                 �  �             X                                                                                          �                 (  �       �                                 �  `                                                                                                       �                 �  �       X                                 @               �                                                                                          �                 �  �                                        �  �             �                                                                                          �                 P  	      �                                 �  �             8                                                                                          	                        �                                 h  @             �                                                                                                          �  &      8                                    �             �                                                                                          &                x  ,      �                                 �  �             `                                                                                          ,                0  7      �                                 �  h                                                                                                       7                �  >      `                                 H                �                                                                                          >                �  F                                          �             �                                                                                          F                X  N      �                                 �  �             @                                                                                          N                  Y      �                                 p  H             �                                                                                          Y                �  a      @                                 (                �                                                                                          a                �  k      �                                 �  �             h                                                                                          k                8  x      �            ,                   �  p                                                                                                        x                �  �      h                                 P  (             �                                                                                          �                �  �                   
                    �              �                                                                                          �                `  �      �             ��������            �  �  !           H                                                                                          �                  �      �  
        
                      x  P  "                                                                                                      �          
      �  �      H                                 0    #           �                                                                                          �                �  �                                       �  �  $           p                                                                                          �                `  �      �        + (   AppProgram,AppURL,HostURL,SelDelim,SelfURL,         �  �  %           H                                                                                          �                  �      �                                 x  P  &                                                                                                      �                �         H                                 0    +           �                                                                                                           �                                            �  �  ,           p                                                                                                            @  0       �                                 �  x  -           (                                                                                          0                 �  @       p                                 X  0   .           �                                                                                          @                 �   L       (                                     �   /           �                                                                                           L                 h!  X       �                                  �   �!  0           P!                                                                                          X                  "  g       �!                                 �!  X"  1           "                                                                                          g                 �"  s       P"                                 8"  #  2           �"                                                                                          s                 �#  }       #                                 �"  �#  3           x#                                                                                          }                 H$  �       �#                                 �#  �$  4           0$                                                                                          �                  %  �       x$                                 `$  8%  5           �$                                                                                          �                 �%  �       0%                                 %  �%  6           �%                                                                                          �                 p&  �       �%                                 �%  �&  7           X&                                                                                          �                 ('  �       �&                                 �&  `'  8           '                                                                                          �                 �'  �       X'                                 @'  (  9           �'                                                                                          �                 �(  �       (                                 �'  �(  :           �(                                                                                          �                 P)  �       �(                                 �(  �)  ;           8)                                                                                          �                 *  �       �)                                 h)  @*  <           �)                                                                                          �                 �*  �       8*                                  *  �*  =           �*                                                                                          �                 x+  	      �*                                 �*  �+  >           `+                                                                                          	                0,        �+                                 �+  h,  ?           ,                                                                                                          �,  &      `,                                 H,   -  @           �,                                                                                          &                �-  ,      -                                  -  �-  A           �-                                                                                          ,                X.  7      �-                                 �-  �.  B           @.                                                                                          7                /  >      �.                                 p.  H/  C           �.                                                                                          >                �/  F      @/                                 (/   0  D           �/                                                                                          F                �0  N      �/                                 �/  �0  E           h0                                                                                          N                81  Y      �0                                 �0  p1  F            1                                                                                          Y                �1  a      h1                                 P1  (2  G           �1                                                                                          a                �2  k       2                                 2  �2  H           �2                                                                                          k                `3  x      �2            ,                   �2  �3  I           H3                                                                                          x                4  �      �3                                 x3  P4  J            4                                                                                          �                �4  �      H4            
                  04  5  K           �4                                                                                          �                �5  �       5             ��������            �4  �5  L           p5                                                                                          �                @6  �      �5  
        
                      �5  x6  M           (6                                                                                          �          
      �6  �      p6                                 X6  07  N           �6                                                                                          �                �7  �      (7                                7  8  O           �7                                                                                          �                �8  �       8        + (   AppProgram,AppURL,HostURL,SelDelim,SelfURL,         �7  �8  P           p8                                                                                          �                @9  @      �8  
        
                      �8  x9  Q           (9                                                                                          @          
      �9  R      p9  
        
                      X9  0:  R           �9                                                                                          R          
      �:  d      (:  
        
                      :  �:  S           �:                                                                                          d          
      h;  q      �:  
        
                      �:  �;  T           P;                                                                                          q          
       <  �      �;  
        
                      �;  X<  U           <                                                                                          �          
      �<  �      P<  
        
                      8<  =  V           �<                                                                                          �          
      �=  �      =  
        
                      �<  �=  W           x=                                                                                          �          
      H>  �      �=  
        
                      �=  �>  X           0>                                                                                          �          
       ?  �      x>                                 `>  8?  Y           �>                                                                                          �                �?  �      0?                                ?  �?  Z           �?                                                                                          �                p@  �      �?  
        
                      �?  �@  [           X@                                                                                          �          
      (A  �      �@  
        
                      �@  `A  \           A                                                                                          �          
      �A  �      XA  
        
                      @A  B  ]           �A                                                                                          �          
      �B        B                                �A  �B  ^           �B                                                                                                          PC        �B                                �B  �C  _           8C                                                                                                          D  "      �C                                hC  @D  `           �C                                                                                          "                �D  3      8D                                 D  �D  a           �D                                                                                          3                xE         �D                                 �D  �E  c           `E                                                                                                           0F          �E                                 �E  hF  d           F                                                                                                            �F  0       `F                                 HF   G  e           �F                                                                                          0                 �G  @       G                                  G  �G  f           �G                                                                                          @                 XH  L       �G                                 �G  �H  g           @H                                                                                          L                 I  X       �H                                 pH  HI  h           �H                                                                                          X                 �I  g       @I                                 (I   J  i           �I                                                                                          g                 �J  s       �I                                 �I  �J  j           hJ                                                                                          s                 8K  }       �J                                 �J  pK  k            K                                                                                          }                 �K  �       hK                                 PK  (L  l           �K                                                                                          �                 �L  �        L                                 L  �L  m           �L                                                                                          �                 `M  �       �L                                 �L  �M  n           HM                                                                                          �                 N  �       �M                                 xM  PN  o            N                                                                                          �                 �N  �       HN                                 0N  O  p           �N                                                                                          �                 �O  �        O                                 �N  �O  q           pO                                                                                          �                 @P  �       �O                                 �O  xP  r           (P                                                                                          �                 �P  �       pP                                 XP  0Q  s           �P                                                                                          �                 �Q  �       (Q                                 Q  �Q  t           �Q                                                                                          �                 hR  �       �Q                                 �Q  �R  u           PR                                                                                          �                  S  	      �R                                 �R  XS  v           S                                                                                          	                �S        PS                                 8S  T  w           �S                                                                                                          �T  &      T                                 �S  �T  x           xT                                                                                          &                HU  ,      �T                                 �T  �U  y           0U                                                                                          ,                 V  7      xU                                 `U  8V  z           �U                                                                                          7                �V  >      0V                                 V  �V  {           �V                                                                                          >                pW  F      �V                                 �V  �W  |           XW                                                                                          F                (X  N      �W                                 �W  `X  }           X                                                                                          N                �X  Y      XX                                 @X  Y  ~           �X                                                                                          Y                �Y  a      Y                                 �X  �Y             �Y                                                                                          a                PZ  k      �Y                                 �Y  �Z  �           8Z                                                                                          k                [  x      �Z            ,                   hZ  @[  �           �Z                                                                                          x                �[  �      8[                                  [  �[  �           �[                                                                                          �                x\  �      �[            
                  �[  �\  �           `\                                                                                          �                0]  �      �\             ��������            �\  h]  �           ]                                                                                          �                �]  �      `]  
        
                      H]   ^  �           �]                                                                                          �          
      �^  �      ^                                  ^  �^  �           �^                                                                                          �                X_  �      �^                                �^  �_  �           @_                                                                                          �                    �      �_        + (   AppProgram,AppURL,HostURL,SelDelim,SelfURL,         p_      �           `                                                                                          �                           ' ; �          �b  c  � �h`              
    state-less                                                                                                                                                                                                                                                                                                                                     �         
             
             
                                         
                                         # �   �   �   �   �   �   �           0  @  P  `  p  �  �  �  �  �  �  �  �          0  @  P  `  p  �  �     # �   �   �   �   �   �   �          0  @  P  `  p  �  �  �  �  �  �  �  �          0  @  P  `  p  �  �    ��                                    ����                                                      undefined                                                                       �          �   p       ��                    �����               x�                         O   ����    e�          O   ����    R�          O   ����    ��      convert-datetime               �       �      �      CHARACTER,INPUT p_conversion CHARACTER,INPUT p_idate DATE,INPUT p_itime INTEGER,OUTPUT p_odate DATE,OUTPUT p_otime INTEGER      format-datetime �      p      �          CHARACTER,INPUT p_format CHARACTER,INPUT p_date DATE,INPUT p_time INTEGER,INPUT p_options CHARACTER     get-binary-data �  (         8          MEMPTR,INPUT p_name CHARACTER   get-cgi   8   X      �    !      CHARACTER,INPUT p_name CHARACTER        get-cgi-long    `  H   �      �    )      LONGCHAR,INPUT p_name CHARACTER get-field       �  X   �      (   	 6      CHARACTER,INPUT p_name CHARACTER        get-fieldEx       h   P      �    @      LONGCHAR,INPUT p_name CHARACTER get-from-form-fields    `  x   �      �    L      LOGICAL,INPUT p_name CHARACTER  get-long-value  �  �   �      (    a      LONGCHAR,INPUT p_name CHARACTER get-value         �   H      x  	 	 p      CHARACTER,INPUT p_name CHARACTER        get-valueEx     X  �   �      �  
  z      LONGCHAR,INPUT p_name CHARACTER get-user-field  �  �   �           �      CHARACTER,INPUT p_name CHARACTER        hidden-field       �   H      x    �      CHARACTER,INPUT p_name CHARACTER,INPUT p_value CHARACTER        hidden-field-list       X  �   �      �    �      CHARACTER,INPUT p_name-list CHARACTER   html-encode     �  �         H    �      CHARACTER,INPUT p_in CHARACTER  output-content-type     (  �   h      �    �      LOGICAL,INPUT p_type CHARACTER  output-http-header      �    �      �    �      CHARACTER,INPUT p_header CHARACTER,INPUT p_value CHARACTER      set-user-field  �    8      h    �      LOGICAL,INPUT p_name CHARACTER,INPUT p_value CHARACTER  set-wseu-cookie H  (  �      �    �      CHARACTER,INPUT p_cookie CHARACTER      url-decode      �  8  �      (   
       CHARACTER,INPUT p_in CHARACTER  url-encode        H  H      x   
       CHARACTER,INPUT p_value CHARACTER,INPUT p_enctype CHARACTER     url-field       X  X  �      �   	       CHARACTER,INPUT p_name CHARACTER,INPUT p_value CHARACTER,INPUT p_delim CHARACTER        url-field-list  �  h  @	      p	    &      CHARACTER,INPUT p_name-list CHARACTER,INPUT p_delim CHARACTER   url-format      P	  x  �	      �	   
 5      CHARACTER,INPUT p_url CHARACTER,INPUT p_name-list CHARACTER,INPUT p_delim CHARACTER     delete-cookie   �	  �  8
      h
    @      CHARACTER,INPUT p_name CHARACTER,INPUT p_path CHARACTER,INPUT p_domain CHARACTER        get-cookie      H
  �  �
      �
   
 N      CHARACTER,INPUT p_name CHARACTER        set-cookie      �
  �        H   
 Y      CHARACTER,INPUT p_name CHARACTER,INPUT p_value CHARACTER,INPUT p_date DATE,INPUT p_time INTEGER,INPUT p_path CHARACTER,INPUT p_domain CHARACTER,INPUT p_options CHARACTER       available-messages      (  �  �      0    d      LOGICAL,INPUT p_grp CHARACTER   get-messages      �  P      �    w      CHARACTER,INPUT p_grp CHARACTER,INPUT p_delete LOGICAL  get-message-groups      `  �  �      �    �      CHARACTER,      output-messages �  �         0    �      INTEGER,INPUT p_option CHARACTER,INPUT p_grp CHARACTER,INPUT p_message CHARACTER        queue-message     �  �      �    �      INTEGER,INPUT p_grp CHARACTER,INPUT p_message CHARACTER check-agent-mode        �    �      (     �      LOGICAL,INPUT p_mode CHARACTER  get-config          H      x  ! 
 �      CHARACTER,INPUT p_name CHARACTER        setSession      X  (  �      �  " 
 �      LOGICAL,INPUT cName CHARACTER,INPUT cValue CHARACTER    getSession      �  8        8  # 
 �      CHARACTER,INPUT cName CHARACTER setGlobal         H  X      �  $ 	 �      LOGICAL,INPUT cName CHARACTER,INPUT cValue CHARACTER    getGlobal       h  X  �      �  % 	 �      CHARACTER,INPUT cName CHARACTER logNote �  h        8  &        LOGICAL,INPUT pcLogType CHARACTER,INPUT pcLogText CHARACTER     adm-destroy         x                            �                               T                         adm-timing-out  �  �                            (                              v                         dispatch        �  X  �           �    (                                   �                         get-attribute   h  �  �                )      �                          �  >                         set-attribute-list      �  8  �           �    *      �                          �  �                         �  /  �  �     �                             3   �����  �                             3   ����      $   �  P  ���                                    '                       � ߱                �  �                  3   ����       $   �  �  ���                                    '                       � ߱                  0  @                  3   ����0      $   �  p  ���                                    '                       � ߱            �  �  @  �  @          4   ����@                P                      ��                  �  �                  `                           �  �  �  /	  �  �         �                          3   �����        �  �  �      �          4   �����      O   �  ��  ��  �        �  �  x      �          4   �����                �                      ��                  �  �                  �                           �    �  /	  �  �         h                          3   ����H        �  �  �      x          4   ����x      O   �  ��  ��  �  X    �  0  @      �          4   �����      �   �  �          �  Q   �  p                                       �  Q   �  �            0                             Q   �  �            @                          8  Q   �              P                          p  Q   �  P            `                          �  Q   �  �            p                          �  Q   �  �            �                            Q   �  �            �                          P  Q   �  0            �                          �  Q   �  h            �                          �  Q   �  �            �                          �  Q   �  �            �                          0  Q   �              �                          h  Q   �  H            �                          �  Q   �  �                                       �  Q   �  �                                        Q   �  �                                       H  Q   �  (            0                          �  Q   �  `            @                          �  Q   �  �            P                          �  Q   �  �            `                          (  Q   �              p                          `  Q   �  @            �                          �  Q   �  x            �                          �  Q   �  �            �                            Q   �  �            �                          @  Q   �               �                          x  Q   �  X            �                          �  Q   �  �            �                          �  Q   �  �            �                             Q   �                                          `�  Q   �  8                                      ProcessWebRequest                                   �  �      ��                  �  �                ��                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    assignFields                                   �      ��                  �  �  (               h�                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    start-super-proc                                    0!  !      ��                  �  �  H!              �                        O   ����    e�          O   ����    R�          O   ����    ��            ��                      `!               ��                                    ����                                    columnValMsg          �!      "  '  �      CHARACTER,INPUT pColumn CHARACTER       deleteBuffer    �!      8"      h"  (  �      LOGICAL,INPUT phBuffer HANDLE   deleteRow       H"      �"      �"  ) 	 �      LOGICAL,        getDeleteTables �"      �"      �"  *  �      CHARACTER,      getFrameHandle  �"      #      8#  +  
      HANDLE, LockRow #      @#      h#  ,        LOGICAL,INPUT pLock CHARACTER   setAddMode      H#      �#      �#  - 
 !      LOGICAL,INPUT plAdd LOGICAL     setDeleteTables �#      �#      $  .  ,      LOGICAL,INPUT pcDeleteTables CHARACTER  setFrameHandle  �#      0$      `$  /  <      LOGICAL,INPUT pHdl HANDLE       validateColumns @$      �$      �$  0  K      LOGICAL,        ProcessWebRequest                                   `%  H%      ��                  �  �  x%                                      O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    fetchPrev                                   x&  `&      ��                  �  �  �&              X                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    fetchNext                                   �'  x'      ��                  �  �  �'              �
                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    fetchLast                                   �(  �(      ��                  �  �  �(              �                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    fetchFirst                                  �)  �)      ��                  �  �  �)              8                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    fetchCurrent                                �*  �*      ��                  �  �  �*              �                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    start-super-proc                                    �+  �+      ��                  �  �  ,                                      O   ����    e�          O   ����    R�          O   ����    ��            ��                      (,               ��                                    ����                                    addContextFields        �$      �,      �,  1  [      LOGICAL,INPUT pNewContextFields CHARACTER       addSearchCriteria       �,      -      H-  2  l      LOGICAL,INPUT pColumn CHARACTER,INPUT pValue CHARACTER  anyMessage      (-      �-      �-  3 
 ~      LOGICAL,        assignColumnFormat      �-      �-      �-  4  �      LOGICAL,INPUT pColumn CHARACTER,INPUT pFormat CHARACTER assignColumnHelp        �-      0.      h.  5  �      LOGICAL,INPUT pcColumn CHARACTER,INPUT pcHelp CHARACTER assignColumnLabel       H.      �.      �.  6  �      LOGICAL,INPUT pcColumn CHARACTER,INPUT pcLabel CHARACTER        assignColumnWidth       �.      /      P/  7  �      LOGICAL,INPUT pColumn CHARACTER,INPUT pWidth DECIMAL    bufferHandle    0/      �/      �/  8  �      HANDLE,INPUT pcTableName CHARACTER      columnDataType  �/      �/      0  9  �      CHARACTER,INPUT pColumn CHARACTER       columnFormat    �/      80      h0  :  �      CHARACTER,INPUT pColumn CHARACTER       ColumnHandle    H0      �0      �0  ;  �      HANDLE,INPUT pcColumn CHARACTER columnHelp      �0      �0      1  < 
       CHARACTER,INPUT pcColumn CHARACTER      columnHTMLName  �0      81      h1  =        CHARACTER,INPUT pColumn CHARACTER       columnLabel     H1      �1      �1  >  !      CHARACTER,INPUT pcColumn CHARACTER      columnReadOnly  �1      �1      2  ?  -      LOGICAL,INPUT pColumn CHARACTER columnStringValue       �1      82      p2  @  <      CHARACTER,INPUT pcColumn CHARACTER      destroyDataObject       P2      �2      �2  A  N      LOGICAL,        extentValue     �2      �2      3  B  `      INTEGER,INPUT pcColumn CHARACTER        fieldExpression �2      83      h3  C  l      CHARACTER,INPUT pColumn CHARACTER,INPUT pOperator CHARACTER,INPUT pValue CHARACTER      getAppService   H3      �3      �3  D  |      CHARACTER,      getContextFields        �3       4      84  E  �      CHARACTER,      getCurrentRowids        4      H4      �4  F  �      CHARACTER,      getForeignFieldList     `4      �4      �4  G  �      CHARACTER,      getNavigationMode       �4      �4      5  H  �      CHARACTER,      getQueryEmpty   �4       5      P5  I  �      LOGICAL,        getQueryWhere   05      `5      �5  J  �      CHARACTER,      getRowids       p5      �5      �5  K 	 �      CHARACTER,      getSearchColumns        �5      �5      6  L  �      CHARACTER,      getServerConnection     �5      (6      `6  M  	      CHARACTER,      getTableRowids  @6      p6      �6  N        CHARACTER,      getTables       �6      �6      �6  O 	 ,      CHARACTER,      getUpdateMode   �6      �6       7  P  6      CHARACTER,      HTMLAlert        7      07      `7  Q 	 D      LOGICAL,INPUT pMessage CHARACTER        HTMLSetFocus    @7      �7      �7  R  N      LOGICAL,INPUT pForm CHARACTER,INPUT pfield CHARACTER    joinExternalTables      �7      �7      (8  S  [      LOGICAL,INPUT pTables CHARACTER,INPUT pRowids CHARACTER joinForeignFields       8      `8      �8  T  n      LOGICAL,INPUT pTables CHARACTER OpenQuery       x8      �8      �8  U 	 �      LOGICAL,        reopenQuery     �8      �8      (9  V  �      LOGICAL,        setAppService   9      89      h9  W  �      LOGICAL,INPUT pAppService CHARACTER     setBuffers      H9      �9      �9  X 
 �      LOGICAL,INPUT pcTables CHARACTER        setColumns      �9      �9      :  Y 
 �      LOGICAL,INPUT pColumns CHARACTER        setContextFields        �9      @:      x:  Z  �      LOGICAL,INPUT pContextFields CHARACTER  setCurrentRowids        X:      �:      �:  [  �      LOGICAL,INPUT pcRowids CHARACTER        setExternalJoinList     �:       ;      8;  \  �      LOGICAL,INPUT pExternalJoinList CHARACTER       setExternalTableList    ;      h;      �;  ]  �      LOGICAL,INPUT pExternalTableList CHARACTER      setExternalTables       �;      �;      <  ^        LOGICAL,INPUT pExternalTables CHARACTER setExternalWhereList    �;      0<      h<  _        LOGICAL,INPUT pExternalWhereList CHARACTER      setForeignFieldList     H<      �<      �<  `  ,      LOGICAL,INPUT pcForeignFieldList CHARACTER      setLinkColumns  �<       =      0=  a  @      LOGICAL,INPUT pLinkColumns CHARACTER    setNavigationMode       =      X=      �=  b  O      LOGICAL,INPUT pmode CHARACTER   setQueryWhere   p=      �=      �=  c  a      LOGICAL,INPUT pWhere CHARACTER  setSearchColumns        �=       >      8>  d  o      LOGICAL,INPUT pSearchColumns CHARACTER  setServerConnection     >      `>      �>  e  �      LOGICAL,INPUT pConnection CHARACTER     setUpdateMode   x>      �>      �>  f  �      LOGICAL,INPUT pMode CHARACTER   showDataMessages        �>      ?      H?  g  �      CHARACTER,      startDataObject (?      X?      �?  h  �      LOGICAL,INPUT pcDataSource CHARACTER    urlJoinParams   h?      �?      �?  i  �      CHARACTER,INPUT pJoin CHARACTER urlLink �?       @      (@  j  �      CHARACTER,INPUT pcWebObject CHARACTER,INPUT pcJoin CHARACTER    validateColumnValue     @      h@      �@  k  �      LOGICAL,INPUT pColumn CHARACTER,INPUT pValue CHARACTER  assignDBRow                                 pA  XA      ��                  �  �  �A              ��                        O   ����    e�          O   ����    R�          O   ����    ��            �� 
                     �A  
             ��                                    ����                                    bufferCopyDBToRO                                    �B  �B      ��                  �  �  �B              ��                        O   ����    e�          O   ����    R�          O   ����    ��            �� 
      0C             �B  
                 �� 
      `C              C  
                 ��       �C             PC                   ��                      �C               ��                                    ����                                    compareDBRow                                �D  �D      ��                  �  �  �D              h�                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    confirmContinue                             �E  �E      ��                  �  �  �E              �                        O   ����    e�          O   ����    R�          O   ����    ��            ��                      �E               ��                                    ����                                    dataAvailable                               �F  �F      ��                  �  �  G              �                        O   ����    e�          O   ����    R�          O   ����    ��            ��                      (G               ��                                    ����                                    fetchDBRowForUpdate                                 HH  0H      ��                  �  �  `H              �                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    fetchFirst                                  `I  HI      ��                  �  �  xI              X�                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    fetchLast                                   xJ  `J      ��                  �  �  �J              0�                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    fetchNext                                   �K  xK      ��                  �  �  �K              X�                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    fetchPrev                                   �L  �L      ��                  �  �  �L              ��                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    filterContainerHandler                              �M  �M      ��                  �  �  �M              ��                        O   ����    e�          O   ����    R�          O   ����    ��            �� 
                     �M  
             ��                                    ����                                    initializeObject                                    O   O      ��                  �  �  0O              ��                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    refetchDBRow                                0P  P      ��                  �  �  HP              ��                        O   ����    e�          O   ����    R�          O   ����    ��            �� 
                     `P  
             ��                                    ����                                    releaseDBRow                                xQ  `Q      ��                  �  �  �Q              ��                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    startFilter                                 �R  xR      ��                  �  �  �R              ��                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    transferDBRow                               �S  �S      ��                  �  �  �S              x�                        O   ����    e�          O   ����    R�          O   ����    ��            ��       T             �S                   ��                      T               ��                                    ����                                    addQueryWhere   �@      �T      �T  l         LOGICAL,INPUT pcWhere CHARACTER,INPUT pcBuffer CHARACTER,INPUT pcAndOr CHARACTER        assignQuerySelection    �T      U      HU  m        LOGICAL,INPUT pcColumns CHARACTER,INPUT pcValues CHARACTER,INPUT pcOperators CHARACTER  bufferCompareDBToRO     (U      �U      �U  n  #      LOGICAL,INPUT phRowObjUpd HANDLE,INPUT phBuffer HANDLE,INPUT pcExcludes CHARACTER,INPUT pcAssigns CHARACTER     bufferWhereClause       �U      HV      �V  o  7      CHARACTER,INPUT pcBuffer CHARACTER,INPUT pcWhere CHARACTER      closeQuery      `V      �V      �V  p 
 I      LOGICAL,        columnDbColumn  �V       W      0W  q  T      CHARACTER,INPUT pcColumn CHARACTER      columnQuerySelection    W      XW      �W  r  c      CHARACTER,INPUT pcColumn CHARACTER      columnTable     pW      �W      �W  s  x      CHARACTER,INPUT pcColumn CHARACTER      colValues       �W      X      @X  t 	 �      CHARACTER,INPUT pcViewColList CHARACTER dbColumnDataName         X      hX      �X  u  �      CHARACTER,INPUT pcDbColumn CHARACTER    dbColumnHandle  �X      �X      �X  v  �      HANDLE,INPUT pcColumn CHARACTER excludeColumns  �X      Y      HY  w  �      CHARACTER,INPUT iTable INTEGER  firstRowIds     (Y      hY      �Y  x  �      CHARACTER,INPUT pcQueryString CHARACTER getDataColumns  xY      �Y      �Y  y  �      CHARACTER,      getForeignValues        �Y       Z      8Z  z  �      CHARACTER,      getObjectType   Z      HZ      xZ  {  �      CHARACTER,      getQueryPosition        XZ      �Z      �Z  |  �      CHARACTER,      getQuerySort    �Z      �Z       [  }        CHARACTER,      getQueryString  �Z      [      @[  ~        CHARACTER,      getTargetProcedure       [      P[      �[    $      HANDLE, indexInformation        h[      �[      �[  �  7      CHARACTER,INPUT pcQuery CHARACTER,INPUT plUseTableSep LOGICAL,INPUT pcIndexInfo CHARACTER       insertExpression        �[      (\      `\  �  H      CHARACTER,INPUT pcWhere CHARACTER,INPUT pcExpression CHARACTER,INPUT pcAndOr CHARACTER  newQueryString  @\      �\      �\  �  Y      CHARACTER,INPUT pcColumns CHARACTER,INPUT pcValues CHARACTER,INPUT pcOperators CHARACTER,INPUT pcQueryString CHARACTER,INPUT pcAndOr CHARACTER  newQueryValidate        �\      x]      �]  �  h      CHARACTER,INPUT pcQueryString CHARACTER,INPUT pcExpression CHARACTER,INPUT pcBuffer CHARACTER,INPUT pcAndOr CHARACTER   newQueryWhere   �]      (^      X^  �  y      CHARACTER,INPUT pcWhere CHARACTER       newWhereClause  8^      �^      �^  �  �      CHARACTER,INPUT pcBuffer CHARACTER,INPUT pcExpression CHARACTER,INPUT pcWhere CHARACTER,INPUT pcAndOr CHARACTER prepareQuery    �^       _      P_  �  �      LOGICAL,INPUT pcQuery CHARACTER refreshRowident 0_      p_      �_  �  �      CHARACTER,INPUT pcRowident CHARACTER    removeForeignKey        �_      �_       `  �  �      LOGICAL,        removeQuerySelection    �_      `      H`  �  �      LOGICAL,INPUT pcColumns CHARACTER,INPUT pcOperators CHARACTER   resolveBuffer   (`      �`      �`  �  �      CHARACTER,INPUT pcBuffer CHARACTER      rowidWhere      �`      �`      a  � 
 �      CHARACTER,INPUT pcWhere CHARACTER       rowidWhereCols  �`      8a      ha  �  �      CHARACTER,INPUT pcColumns CHARACTER,INPUT pcValues CHARACTER,INPUT pcOperators CHARACTER        setQueryPosition        Ha      �a       b  �        LOGICAL,INPUT pcPosition CHARACTER      setQuerySort    �a      (b      Xb  �        LOGICAL,INPUT pcSort CHARACTER  setQueryString  8b      xb      �b  �        LOGICAL,INPUT pcQueryString CHARACTER   whereClauseBuffer       �b      �b      c  �  .      CHARACTER,INPUT pcWhere CHARACTER       addLink                             �c  �c      ��                  �
  �
  �c              H�                        O   ����    e�          O   ����    R�          O   ����    ��            �� 
      0d             �c  
                 ��       `d              d                   �� 
                     Pd  
             ��                                    ����                                    addMessage                                  he  Pe      ��                  �
  �
  �e              `�                        O   ����    e�          O   ����    R�          O   ����    ��            ��       �e             �e                   ��       f             �e                   ��                      �e               ��                                    ����                                    adjustTabOrder                              g  �f      ��                  �
  �
  (g              ��                        O   ����    e�          O   ����    R�          O   ����    ��            �� 
      �g             @g  
                 �� 
      �g             pg  
                 ��                      �g               ��                                    ����                                    applyEntry                                  �h  �h      ��                  �
  �
  �h              `�                        O   ����    e�          O   ����    R�          O   ����    ��            ��                      �h               ��                                    ����                                    changeCursor                                 j  �i      ��                  �
  �
  j              H�                        O   ����    e�          O   ����    R�          O   ����    ��            ��                      0j               ��                                    ����                                    createControls                              Hk  0k      ��                  �
  �
  `k              ��                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    destroyObject                               `l  Hl      ��                  �
  �
  xl              8�                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    displayLinks                                xm  `m      ��                  �
  �
  �m              ��                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    editInstanceProperties                              �n  �n      ��                  �
  �
  �n              �	                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    exitObject                                  �o  �o      ��                  �
  �
  �o              8	                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    hideObject                                  �p  �p      ��                  �
  �
  �p              �	                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    initializeObject                                    �q  �q      ��                  �
  �
   r              	                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    modifyListProperty                                  s  �r      ��                  �
  �
   s              ('	                        O   ����    e�          O   ����    R�          O   ����    ��            �� 
      xs             8s  
                 ��       �s             hs                   ��       �s             �s                   ��                      �s               ��                                    ����                                    modifyUserLinks                             �t  �t      ��                  �
  �
  �t              �5	                        O   ����    e�          O   ����    R�          O   ����    ��            ��       Pu             u                   ��       �u             @u                   �� 
                     pu  
             ��                                    ����                                    removeAllLinks                              �v  pv      ��                  �
  �
  �v              A	                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    removeLink                                  �w  �w      ��                  �
  �
  �w              �E	                        O   ����    e�          O   ����    R�          O   ����    ��            �� 
      x             �w  
                 ��       @x              x                   �� 
                     0x  
             ��                                    ����                                    repositionObject                                    Py  8y      ��                  �
  �
  hy              �Q	                        O   ����    e�          O   ����    R�          O   ����    ��            ��       �y             �y                   ��                      �y               ��                                    ����                                    returnFocus                                 �z  �z      ��                  �
  �
  �z              �Z	                        O   ����    e�          O   ����    R�          O   ����    ��            �� 
                     �z  
             ��                                    ����                                    showMessageProcedure                                |   |      ��                  �
  �
  0|              �a	                        O   ����    e�          O   ����    R�          O   ����    ��            ��       �|             H|                   ��                      x|               ��                                    ����                                    toggleData                                  �}  x}      ��                  �
  �
  �}              �j	                        O   ����    e�          O   ����    R�          O   ����    ��            ��                      �}               ��                                    ����                                    viewObject                                  �~  �~      ��                  �
  �
  �~              �r	                        O   ����    e�          O   ����    R�          O   ����    ��        ��                                    ����                                    assignLinkProperty      �b      X      �  �  �      LOGICAL,INPUT pcLink CHARACTER,INPUT pcPropName CHARACTER,INPUT pcPropValue CHARACTER   fetchMessages   p      �      �  �  �      CHARACTER,      getChildDataKey �      (�      X�  �  �      CHARACTER,      getContainerHandle      8�      h�      ��  �  �      HANDLE, getContainerHidden      ��      ��      ��  �  �      LOGICAL,        getContainerSource      ��      ��      (�  �  �      HANDLE, getContainerSourceEvents        �      0�      p�  �  �      CHARACTER,      getContainerType        P�      ��      ��  �        CHARACTER,      getDataLinksEnabled     ��      ȁ       �  �        LOGICAL,        getDataSource   ��      �      @�  �  )      HANDLE, getDataSourceEvents      �      H�      ��  �  7      CHARACTER,      getDataSourceNames      `�      ��      Ȃ  �  K      CHARACTER,      getDataTarget   ��      ؂      �  �  ^      CHARACTER,      getDataTargetEvents     �      �      P�  �  l      CHARACTER,      getDBAware      0�      `�      ��  � 
 �      LOGICAL,        getDesignDataObject     p�      ��      ؃  �  �      CHARACTER,      getDynamicObject        ��      �       �  �  �      LOGICAL,        getInstanceProperties    �      0�      h�  �  �      CHARACTER,      getLogicalObjectName    H�      x�      ��  �  �      CHARACTER,      getLogicalVersion       ��      ��      ��  �  �      CHARACTER,      getObjectHidden ؄      �      8�  �  �      LOGICAL,        getObjectInitialized    �      H�      ��  �  �      LOGICAL,        getObjectName   `�      ��      ��  �        CHARACTER,      getObjectPage   ��      Ѕ       �  �         INTEGER,        getObjectParent ��      �      @�  �  .      HANDLE, getObjectVersion         �      H�      ��  �  >      CHARACTER,      getObjectVersionNumber  `�      ��      Ȇ  �  O      CHARACTER,      getParentDataKey        ��      ؆      �  �  f      CHARACTER,      getPassThroughLinks     ��       �      X�  �  w      CHARACTER,      getPhysicalObjectName   8�      h�      ��  �  �      CHARACTER,      getPhysicalVersion      ��      ��      �  �  �      CHARACTER,      getPropertyDialog       ȇ      ��      0�  �  �      CHARACTER,      getQueryObject  �      @�      p�  �  �      LOGICAL,        getRunAttribute P�      ��      ��  �  �      CHARACTER,      getSupportedLinks       ��      ��      ��  �  �      CHARACTER,      getTranslatableProperties       ؈      �      H�  �  �      CHARACTER,      getUIBMode      (�      X�      ��  � 
       CHARACTER,      getUserProperty h�      ��      ȉ  �        CHARACTER,INPUT pcPropName CHARACTER    instancePropertyList    ��      ��      (�  �  ,      CHARACTER,INPUT pcPropList CHARACTER    linkHandles     �      P�      ��  �  A      CHARACTER,INPUT pcLink CHARACTER        linkProperty    `�      ��      ؊  �  M      CHARACTER,INPUT pcLink CHARACTER,INPUT pcPropName CHARACTER     mappedEntry     ��      �      H�  �  Z      CHARACTER,INPUT pcEntry CHARACTER,INPUT pcList CHARACTER,INPUT plFirst LOGICAL,INPUT pcDelimiter CHARACTER      messageNumber   (�      ��      �  �  f      CHARACTER,INPUT piMessage INTEGER       propertyType    ȋ      �      @�  �  t      CHARACTER,INPUT pcPropName CHARACTER    reviewMessages   �      h�      ��  �  �      CHARACTER,      setChildDataKey x�      ��      ،  �  �      LOGICAL,INPUT cChildDataKey CHARACTER   setContainerHidden      ��       �      8�  �  �      LOGICAL,INPUT plHidden LOGICAL  setContainerSource      �      X�      ��  �  �      LOGICAL,INPUT phObject HANDLE   setContainerSourceEvents        p�      ��      ��  �  �      LOGICAL,INPUT pcEvents CHARACTER        setDataLinksEnabled     Ѝ      �      P�  �  �      LOGICAL,INPUT lDataLinksEnabled LOGICAL setDataSource   0�      x�      ��  �  �      LOGICAL,INPUT phObject HANDLE   setDataSourceEvents     ��      Ȏ       �  �        LOGICAL,INPUT pcEventsList CHARACTER    setDataSourceNames      ��      (�      `�  �        LOGICAL,INPUT pcSourceNames CHARACTER   setDataTarget   @�      ��      ��  �  (      LOGICAL,INPUT pcTarget CHARACTER        setDataTargetEvents     ��      ��      �  �  6      LOGICAL,INPUT pcEvents CHARACTER        setDBAware      ��      @�      p�  � 
 J      LOGICAL,INPUT lAware LOGICAL    setDesignDataObject     P�      ��      Ȑ  �  U      LOGICAL,INPUT pcDataObject CHARACTER    setDynamicObject        ��      �      (�  �  i      LOGICAL,INPUT lTemp LOGICAL     setInstanceProperties   �      H�      ��  �  z      LOGICAL,INPUT pcPropList CHARACTER      setLogicalObjectName    `�      ��      ��  �  �      LOGICAL,INPUT c CHARACTER       setLogicalVersion       ��       �      8�  �  �      LOGICAL,INPUT cVersion CHARACTER        setObjectName   �      `�      ��  �  �      LOGICAL,INPUT pcName CHARACTER  setObjectParent p�      ��      ��  �  �      LOGICAL,INPUT phParent HANDLE   setObjectVersion        ��       �      8�  �  �      LOGICAL,INPUT cObjectVersion CHARACTER  setParentDataKey        �      `�      ��  �  �      LOGICAL,INPUT cParentDataKey CHARACTER  setPassThroughLinks     x�      ��      ��  �  �      LOGICAL,INPUT pcLinks CHARACTER setPhysicalObjectName   ؓ      �      P�  �        LOGICAL,INPUT cTemp CHARACTER   setPhysicalVersion      0�      p�      ��  �  !      LOGICAL,INPUT cVersion CHARACTER        setRunAttribute ��      Д       �  �  4      LOGICAL,INPUT cRunAttribute CHARACTER   setSupportedLinks       ��      (�      `�  �  D      LOGICAL,INPUT pcLinkList CHARACTER      setTranslatableProperties       @�      ��      ȕ  �  V      LOGICAL,INPUT pcPropList CHARACTER      setUIBMode      ��      �       �  � 
 p      LOGICAL,INPUT pcMode CHARACTER  setUserProperty  �      @�      p�  �  {      LOGICAL,INPUT pcPropName CHARACTER,INPUT pcPropValue CHARACTER  showmessage     P�      ��      ��  �  �      LOGICAL,INPUT pcMessage CHARACTER       Signature       ��      �      8�  � 	 �      CHARACTER,INPUT pcName CHARACTER        `�    �  ��   �                 4   ����                 �                      ��                  �  #                  ��	                           �  ��        �  0�  ��      8          4   ����8                ��                      ��                  �  "                  ��	                           �  @�  Й      ��  `�      P          4   ����P                p�                      ��                                      ��	                             �                                               �     
 '                       � ߱         �  $    ��  ���                               $  !  0�  ���                           X      '                       � ߱        h�    '  ��   �      p          4   ����p                �                      ��                  (  �                  ��	                           (  ��  H�  o   +  '    ,                                     ��  $   ,  x�  ���                              @                            � ߱        ��  �   -  H          ؛  �   .  �          �  �   0  x          �  �   2             �  �   4  �          8�  �   6  @          P�  �   7  �          h�  �   8  0          ��  �   ;  �          ��  �   =  `          ��  �   >             Ȝ  �   @  �          ��  �   A  @          ��  �   B  �          �  �   C  0          (�  �   D  �          @�  �   J            X�  �   L  �          p�  �   R             ��  �   T  �          ��  �   V  0          ��  �   W  �          Н  �   ]  p           �  �   ^  !           �  �   _  �!          �  �   `  @"          0�  �   c  �"          H�  �   d  (#          `�  �   f  �#          x�  �   g  $          ��  �   i  �$          ��  �   j  �$          ��  �   k  H%          ؞  �   l  �%          �  �   m  �%          �  �   n  �&           �  �   o  �&          8�  �   q  ('          P�  �   r  x'          h�  �   s  �'          ��  �   u  (          ��  �   v  h(          ��  �   w  �(          ȟ  �   x  )              �   y  X)                          �          h�  P�      ��                    A  ��              �
                        O   ����    e�          O   ����    R�          O   ����    ��      �)     
 '                   �*      '                   P,      b                       � ߱        8�  $ '  ��  ���                               O   ?  ��  ��  �,             b  ��          ��  ��    ��                                                b         ��                                    ����                                    P  HZ      ��      P�    b 5     ��                      { ��  �                         ��    �  ��  �      �,          4   �����,                �                      ��                  �  $                  `
                           �  ��  0�  �   �  P-          H�  �   �  �-          `�  �   �  �.          x�  �   �  (/          ��  �   �  �/          ��  �   �  0          ��  �   �  �0          أ  �   �  H1          �  �   �  �1          �  �   �  02           �  �   �  �2          8�  �   �  3          P�  �   �  h3          h�  �   �  4          ��  �   �  �4          ��  �   �  H5          ��  �   �  �5          Ȥ  �   �  �6          �  �   �   7          ��  �   �  �7          �  �   �  `8          (�  �   �  �8          @�  �   �   9          X�  �   �  �9          p�  �   �  8:          ��  �   �  �:          ��  �   �  x;          ��  �   �  <          Х  �   �  �<          �  �   �  X=           �  �   �  �=          �  �   �  @>          0�  �   �  �>          H�  �   �  0?          `�  �   �  �?          x�  �   �  h@          ��  �   �   A          ��  �   �  �A          ��  �   �  0B          ئ  �   �  �B          �  �   �  pC          �  �   �  D           �  �   �  �D          8�  �   �  @E          P�  �   �  �E          h�  �   �  �F          ��  �   �   G              �   �  �G          �    2  ��  8�      �G          4   �����G                H�                      ��                  3  �                  �$
                           3  ȧ  `�  �   7  �H          x�  �   8   I          ��  �   9  �I          ��  �   :  XJ          ��  �   ;  �J          ب  �   <  �K          �  �   =  (L          �  �   >  �L           �  �   ?  hM          8�  �   @  N          P�  �   A  �N          h�  �   B  HO          ��  �   C  �O          ��  �   D  �P          ��  �   E  Q          ȩ  �   F  �Q          �  �   G  PR          ��  �   H  �R          �  �   I  �S          (�  �   J   T          @�  �   K  �T          X�  �   L  U          p�  �   M  �U          ��  �   N  HV          ��  �   O  �V          ��  �   P  �W          Ъ  �   Q  X              �   R  �X           �  �   �  XY          �  �   �  �Y          0�  �   �  �Y          H�  �   �  HZ          `�  �   �  �Z          x�  �   �  �Z          ��  �   �  8[          ��  �   �  �[          ��  �   �  �[          ث  �   �  (\          �  �   �  x\          �  �   �  ]           �  �   �  �]          8�  �   �  ^          P�  �   �  X^          h�  �   W  �^          ��  �   X  �^          ��  �   Y  H_          deleteRecordStatic      P�    �  Ь  �      �_          4   �����_      /   �  �      �                              3   �����_            @�                      3   �����_  ��    �  p�  �  ��  �_          4   �����_  	               �                      ��             	     �                    �                           �  ��  �  �   �  x`          x�  $  �  H�  ���                           �`     
 '                       � ߱        ��  �   �  �`          �  $   �  ��  ���                           (a  @         a                  � ߱        ��  $  �   �  ���                           �a      ' !       !               � ߱        (b     
 '                   �b      '                   �d  @        
 �d                  � ߱        `�  V   �  P�  ���                             e      ' !       !           Pe      ' "       "           �e      ' !       !               � ߱         �  $  �  �  ���                           �f     
 '                   �g      '                   �i  @        
 @i                  � ߱            V   �  ��  ���                            
              ��                      ��             
       �                  �                             0�  �i     
 '                   `j      '                   xl  @        
 l               m  @        
 �l              �m  @        
 (m              n  @        
 �m                  � ߱            V   1  ��  ���                            adm-clone-props �  ��                   � 6     �                          �  {$                         start-super-proc        ��   �  �           �    � 7     `                          X  �$                         ��    �  ��  ȳ      ps          4   ����ps      /   �  ��     �                              3   �����s            (�                      3   �����s  �s     
 '                   �t      '                   �v  @        
 @v                  � ߱        H�  V   �  8�  ���                            �v     
 '                   �w      '                   �y  @        
 Xy                  � ߱        x�  V     ش  ���                            �    �  ��  �      �y          4   �����y                (�                      ��                  �  �                  `�                           �  ��  ��  /   �  X�     h�                              3   �����y            ��                      3   ����z      /   �  ȶ     ض                              3   ����0z            ��                      3   ����Xz  0�  /  �  8�         �z                          3   ����xz  initProps       8�  H�              `    � 8     h                          `  �%  	                                       ��          @�  (�      ��                 N  g  X�              p                        O   ����    e�          O   ����    R�          O   ����    ��      �%   �                       p�              ��  p   Y  `~  ��      d      P�  @�     p~                                        ��                  Z  v                  �'                           Z  и  �  й     �~                                        ��                  w  �                  )                           w  `�  p�  `�     �~                                        ��                  �  �                  x*                           �  �   �  �     �~                                        ��                  �  �                  �+                           �  ��  ��  ��     �~                                        ��                  �  �                  8-                           �  �   �  �     �~                                        ��                  �                    �.                           �  ��  ��  ��                                              ��                    $                  �/                             0�  @�  0�                                             ��                  %  A                  X1                           %  ��  н  ��     0  	                                      ��             	     B  ^                  �2                           B  P�  `�  P�     H  
                                      ��             
     _  {                  �D                           _  �  �  �     `                                        ��                  |  �                  �E                           |  p�  ��  p�     x                                        ��                  �  �                  HG                           �   �  �   �     �                                        ��                  �  �                  �H                           �  ��  ��  ��     �                                        ��                  �  �                  J                           �   �  0�   �     �                                        ��                  �                    hK                           �  ��  ��  ��     �                                        ��                    )                  �L                             @�  P�  @�     �                                        ��                  *  F                  (N                           *  ��      ��     �                                        ��                  G  c                  �O                           G  `�      O   f  ��  ��   �             �  p�          P�  `�   0 0�                                                                     �    �         ��                                    ����                                    X�  ��  ��  ��      ��    � 9     ��                      � x�  &                         ��  /   {  `�     p�                              3   ����0�            ��                      3   ����X�  ��     }  x�                                         H�  /   �  �     �                              3   ������            8�                      3   ������  ��     �  ؀                                         X�    J  ��   �  ��  ��          4   ������                0�                      ��                  K  N                   S                           K  ��  H�  �   L   �              �   M  X�                        ��                      ��                  O  W                  �d                           O  `�  ��  �   R  ��          �  �   S  ȁ          (�  �   T   �          @�  �   U  8�              �   V  p�           �  �   Z  ��          ��      ' 
       
           �      '                   P�      '                   �      '                       � ߱        0�  $  a  p�  ���                           ��    i  P�  ��      x�          4   ����x�                ��                      ��                  j  �                  f                           j  `�  ��  �   q  ��          P�  Q   u  �            ��             Є             ��                          ��  Q   v  h�            ��                          ��  Q   w  ��             �                          �  Q   x  ��            �              �             X�                          p�  Q   y  0�            h�             x�             ��                          ��  Q   z  ��            ��             Ѕ                          �  Q   {  ��            �             �             x�                          H�  Q   |  (�            ��                          ��  Q   }  `�            ��                          ��  Q   ~  ��            ��                              Q     ��            ��                          ��  /   �   �                                     3   ����Ȇ  ��      '                   ��      '                   (�      '                   `�      '                       � ߱        ��  $  �  0�  ���                           h�    �  �  ��      ��          4   ������                ��                      ��                  �  �                   h                           �   �  ��  Q   �  ��            ��                          0�  Q   �  ��            ��             ȉ             ؉                              Q   �  H�            �                          ��  Q   �  ��            ��             �             �                          �  Q   �  ��            (�             8�             ��                          P�  Q   �  0�            ��                          ��  Q   �  h�            ��                          ��  Q   �  ��            ��             Њ             0�                          �  Q   �  ��            @�                          p�  Q   �  0�            P�             `�             ��                          ��  Q   �  ��            ��             ��             �                           �  Q   �  ��            (�                          X�  Q   �  �            ��             ��              �                          ��  Q   �  p�            �                          ��  Q   �  ��             �                           �  Q   �  ��            0�                          8�  Q   �  �            @�                          p�  Q   �  P�            P�                          ��  Q   �  ��            `�                          ��  Q   �  ��            p�                          8�  Q   �  ��            ��             ��             ��                          p�  Q   �  P�             �                          ��  Q   �  ��            �              �             X�                           �  Q   �  ��            h�             x�             ؎                          X�  Q   �  8�            �                          ��  Q   �  p�            P�             `�             ��                          ��  Q   �  ��            Џ                           �  Q   �   �            ��                          X�  Q   �  8�            ��                          ��  Q   �  p�             �                          ��  Q   �  ��            �              �             ��                           �  Q   �   �            ��                          x�  Q   �  8�            ��             ��             �                          ��  Q   �  ��            ��             �             h�                          �  Q   �  ��            x�                          `�  Q   �   �            ��             �             P�                          ��  Q   �  x�            `�                          ��  Q   �  ��            p�                          �  Q   �  ��            ��                          @�  Q   �   �            ��                          ��  Q   �  X�            ��             ��             �                          ��  Q   �  ��             �                          (�  Q   �  ��            0�             @�             x�                          ��  Q   �  @�            ��             ��             ��                          ��  Q   �  ��            �                          �  Q   �  ��            p�             ��             ��                          H�  Q   �  (�            �                          ��  Q   �  `�             �                          ��  Q   �  ��            �                          ��  Q   �  ��             �                          H�  Q   �  �            0�             @�             ��                          ��  Q   �  `�            ��                          ��  Q   �  ��            ��             Е             �                          0�  Q   �  ��            �             (�             ��                          h�  Q   �  H�            ��                          ��  Q   �  ��             �             �             p�                          ��  Q   �  ��            ��                          0�  Q   �  �            ��                          h�  Q   �  H�            ��                          ��  Q   �  ��            ��                          ��  Q   �  ��            ��                          @�    �  ��  �      З          4   ����З      Q   �   �             �                          ��    �  `�  p�      0�          4   ����0�      Q   �  ��            @�                          �    �  ��  ��      P�          4   ����P�      Q   �  ��            ��                          x�    �  0�  @�      ��          4   ������      Q   �  X�            ��                          ��    �  ��  �      И          4   ����И                (�                      ��                  �  �                  ��                           �  ��  `�  Q   �  @�             �                          ��  Q   �  x�            0�             @�             ��                              Q   �  ��            ��                          (�  Q   �  �            ��                          `�  Q   �  @�            ��                          ��  Q   �  x�            ��                          ��       ��  8�      Й          4   ����Й                H�                      ��                    #                  ��                             ��  ��  Q     `�             �                          ��  Q     ��            0�                          ��  Q     ��            @�                          (�  Q     �            P�                          ��  Q     @�            `�             p�             �                          ��  Q   	  ��            (�                          ��  Q   
  ��            8�                          H�  Q     �            H�             X�             h�                          ��  Q     `�            x�                          ��  Q     ��            ��                          �  Q     ��            ��             ��             P�                          H�  Q     (�            `�                          ��  Q     `�            p�                          ��  Q     ��            ��             ��             ��                          �  Q     ��            ��                          H�  Q     (�            ��                          ��  Q     `�            М             ��             ��                          ��  Q     ��            ��                          �  Q     ��            ��                          h�  Q     (�            ��             ȝ             ؝                          ��  Q     ��            �                          ��  Q     ��            ��                          0�  Q     ��            �             �             ��                          h�  Q     H�            О                          ��  Q     ��            ��                          ��  Q     ��            �              �             �                          0�  Q     �             �                          h�  Q     H�            0�                          ��  Q      ��            @�                              Q   !  ��            P�                          0�    &  ��  x�      `�          4   ����`�                ��                      ��                  '  ,                  ��                           '  �  ��  $  (  ��  ���                           p�      '                       � ߱              *  �  �      ��          4   ������      �   +  ��          h�  Q   0  H�            �                              Q   1  ��             �                          local-e4gl-options      ��  ��  �           H    � :     8                          0  �0                         �   1 
state-less                  ����  �           h�  x�      viewObject      ,       X�  ��  ��      toggleData      ,INPUT plEnabled LOGICAL        ��  ��  ��      showMessageProcedure    ,INPUT pcMessage CHARACTER,OUTPUT plAnswer LOGICAL      ��  0�  @�      returnFocus     ,INPUT hTarget HANDLE    �  h�  ��      repositionObject        ,INPUT pdRow DECIMAL,INPUT pdCol DECIMAL        X�  ��  ��      removeLink      ,INPUT phSource HANDLE,INPUT pcLink CHARACTER,INPUT phTarget HANDLE     ��  (�  8�      removeAllLinks  ,       �  P�  `�      modifyUserLinks ,INPUT pcMod CHARACTER,INPUT pcLinkName CHARACTER,INPUT phObject HANDLE @�  ��  ��      modifyListProperty      ,INPUT phCaller HANDLE,INPUT pcMode CHARACTER,INPUT pcListName CHARACTER,INPUT pcListValue CHARACTER    ��  H�  X�      hideObject      ,       8�  p�  ��      exitObject      ,       `�  ��  ��      editInstanceProperties  ,       ��  ��  ��      displayLinks    ,       ��  ��   �      destroyObject   ,       ��  �  (�      createControls  ,       �  @�  P�      changeCursor    ,INPUT pcCursor CHARACTER       0�  ��  ��      applyEntry      ,INPUT pcField CHARACTER        p�  ��  ��      adjustTabOrder  ,INPUT phObject HANDLE,INPUT phAnchor HANDLE,INPUT pcPosition CHARACTER ��  (�  8�      addMessage      ,INPUT pcText CHARACTER,INPUT pcField CHARACTER,INPUT pcTable CHARACTER �  ��  ��      addLink ,INPUT phSource HANDLE,INPUT pcLink CHARACTER,INPUT phTarget HANDLE     ��  ��   �      transferDBRow   ,INPUT pcRowIdent CHARACTER,INPUT piRowNum INTEGER      ��  H�  X�      startFilter     ,       8�  p�  ��      releaseDBRow    ,       `�  ��  ��      refetchDBRow    ,INPUT phRowObjUpd HANDLE       ��  ��  ��      initializeObject        ,       ��  �   �      filterContainerHandler  ,INPUT phFilterContainer HANDLE ��  P�  h�      fetchDBRowForUpdate     ,       @�  ��  ��      dataAvailable   ,INPUT pcRelative CHARACTER     p�  ��  ��      confirmContinue ,INPUT-OUTPUT pioCancel LOGICAL ��   �  �      compareDBRow    ,       ��  (�  @�      bufferCopyDBToRO        ,INPUT phRowObj HANDLE,INPUT phBuffer HANDLE,INPUT pcExcludes CHARACTER,INPUT pcAssigns CHARACTER       �  ��  ��      assignDBRow     ,INPUT phRowObjUpd HANDLE       ��  ��  �      fetchCurrent    ,       ��   �  0�      fetchFirst      ,       �  H�  X�      fetchLast       ,       8�  p�  ��      fetchNext       ,       `�  ��  ��      fetchPrev       ,       ��  ��  ��      assignFields    ,       ��  ��   �      ProcessWebRequest       ,               
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   
"     "   
   �             }        �    
�            %          set-attribute-list     
�            %  attr    Web-State = Timed-Out   8            "     (     �     �                "     (     %                  %           ��������T            %                  �     %                  �     �     P �            0           "     (                  �     �     "     (     `            S0                          �     �     "     (     �             }        �    %                                �     �     "     (     P �            0           "     (                  �     �     "     (     `            S0                          �     �     "     (     �             }        �    %                                �     �     "     (     "     (     
�                        �      �     �  	   %     	    ADM-ERROR     �             }        �    ` `           8            �            }        �    %                  %           Q      8            �            }        �    %                  %           8      %         dispatch ��     
"     "   
   % atch    show-errors     % -err	    ADM-ERROR     %                   "     )     �     �     %                   �     �     %          WEB1.0  �       	   "     '     �                       "     '     �          "     '     �     +     %          get-time-remaining     
"     "   
   
�            "     )                  "     )     %          special-get-attribute   
�            "     )           �             }        �    �      %                  "     )                 %                  %                               "     *     %                               "     *     �             "     *     �             "     *     T            "     *     "     *     0                        "     *     �     r     %                   �     t  &   %          
       "     *     %          
       �     �     �             }        �A    z�               X         "     *     %                  0                        "     *     �     r     %                  z�              X          "     *      0                        "     *     �     r     %                  %           ��������"     *     �          !     "     *     �       	   "     *     �          "     *     %          special-set-attribute   
�            "     *     "     *     %          local-e4gl-options     
�            "     '     "     '     "     '     80            �            }        �    �     �     �     �  	   %         output-header   
�            �             }        �    %                   80            �            }        �    �     �     �     �  	   %         output-headers  
�            �             }        �    %                   0     A            "     '     �          �                    (     "     '             �       /   �     D  G   �     �  G   �     �  G   �       G   �     d  G   �     �  G   �     �  G   �     d  G   �     <  G   �     �  G   �     �  G   �     	  G   �     \	  G   �     d  G   �     �	  G   �     �	  G   �     4
  G   �     |
  G   �     d  G   �     �
  G   �     d  G   �       G   �     T     �     \     �     d  ,   �     �     �     �     �     �     �     �  	   �     �     �     �  0   �     
"     V   
   %                  �     �p  �                 8                  
�                            (     
�                    �     �     
"     V   
   
�h     T             %                  �             }        �G    G     %                  �     
"     '  
   x     �p     
�h     T             %                  �             }        �G    G     %                  
"     '  
   �                �    7    %                   
"     '  
   �                   8    1    �     �  
   �     �     %                   o%       o           �     �      
"     '  
   �                   �    1    �     �     �     �     %                   o%       o           �     �     
"     '  
   �                   h    1    �     �  
   �     �     %                   o%       o           �     �      
"     '  
   �                        1    �     �     �     �     %                   o%       o           �     �      
"     '  
   �                   �    1    �     �     �     �     %                   o%       o           �     �      
"     '  
   �                   0    1    �     �     �     
     %                   o%       o           %                   
"     '  
   �              �    1    �          �     "     
"     '  
   �                        1    �     )     �     �     %                   o%       o           �     <  m   
"     '  
   �                   �    1    �     �     �     �     %                   o%       o           �     �      
"     '  
   �                   P    1    �     �     �     
     %                   o%       o           %                   
"     '  
   �                   �    1    �     �     �     
     %                   o%       o           %                   
"     '  
   �                   �    1    �     �     �     
     %                   o%       o           %                  
"     '  
   �              0    1    �     �     �     
     
"     '  
   �                   �    1    �     �  
   �     
     %                   o%       o           %                   
"     '  
   �                        1    �          �     �     %                   o%       o           �     �      
"     '  
   �              �    1    �     
     �     "     
"     '  
   �                       1    �          �     �     %                   o%       o           �     0  t   
"     '  
   �              �    1    �     �  
   �     "     
"     '  
   �                   �    1    �     �     �     �     %                   o%       o           �     �  �   
"     '  
   �                   �    1    �     N     �     �     %                   o%       o           �     �      
"     '  
   �                        1    �     e  
   �     p     %                   o%       o           %                   
"     '  
   �                   �    1    �     t     �     
     %                   o%       o           %                   
"     '  
   �                   `     1    �     |     �     �     %                   o%       o           �     �      
"     '  
   �                   �     1    �     �     �     �     %                   o%       o           o%       o           
"     '  
   �                   �!    1    �     �  
   �     �     %                   o%       o           �     �     
"     '  
   �                   0"    1    �     �     �     �  	   %                   o%       o           �     �  /  
"     '  
   �              �"    1    �     �     �     �  	   
"     '  
   �                   #    1    �          �     �  	   o%       o           o%       o           �     �     
"     '  
   �              �#    1    �          �     �  	   
"     '  
   �                    $    1    �     '     �     �  	   o%       o           o%       o           �     �     
"     '  
   �              �$    1    �     7     �     
     
"     '  
   �              �$    1    �     E     �     �  	   
"     '  
   �              8%    1    �     R     �     �  	   
"     '  
   �              �%    1    �     _     �     �  	   
"     '  
   �                   �%    1    �     m     �     
     o%       o           o%       o           %                  
"     '  
   �              x&    1    �     ~     �     �  	   
"     '  
   �              �&    1    �     �  
   �     �     
"     '  
   �              '    1    �     �     �     �  	   
"     '  
   �              h'    1    �     �     �     �  	   
"     '  
   �              �'    1    �     �     �     �  	   
"     '  
   �              (    1    �     �     �     �  	   
"     '  
   �              X(    1    �     �  	   �     �  	   
"     '  
   �              �(    1    �     �     �     �  	   
"     '  
   �              �(    1    �          �     �  	   
"     '  
   �                   H)    1    �          �     �     %                   o%       o           o%       o           
�h     T             %                  �             }        �G    G     %                  
"     '  
   
"     '  
   
"     '  
   
"     '  
   (  �         @ �                        �                X*    �    �     %       �           �                h*    �    `            
� `  @     
�               x*    �    �     .     p�                       �L    
�            %                  � `              �*    �     @                          �     5                  
�            �     O     
"     '  
   � `  @     
�               @,    �    �     �  
   p�                       �L    "     b     x     �p     
�h     T             %                  �             }        �G    G     %                  
"     '  
   �                   @-    1    �     R  
   �     
     %                   o%       o           %                  
"     '  
   �                   �-    1    �     ]     �     �     %                   o%       o           o%       o           
"     '  
   �                   �.    1    �     i     �     �     %                   o%       o           �     �     
"     '  
   �                   /    1    �     w     �     �     %                   o%       o           o%       o           
"     '  
   �              �/    1    �     �     �     "     
"     '  
   �                   0    1    �     �     �     �     %                   o%       o           �     �  !  
"     '  
   �                   �0    1    �     �     �     �     %                   o%       o           �     �     
"     '  
   �                   81    1    �     �     �     �     %                   o%       o           �     �    
"     '  
   �              �1    1    �     �     �          
"     '  
   �               2    1    �          �     "     
"     '  
   �                   p2    1    �          �     �     %                   o%       o           �     �     
"     '  
   �              3    1    �     '  
   �     "     
"     '  
   �                   X3    1    �     2     �     
     %                   o%       o           o%       o           
"     '  
   �                   �3    1    �     @     �     
     %                   o%       o           %                   
"     '  
   �                   �4    1    �     M     �     
     %                   o%       o           %                   
"     '  
   �                   85    1    �     ^     �     �     %                   o%       o           �     �      
"     '  
   �                   �5    1    �     n     �     �     %                   o%       o           o%       o           
"     '  
   �                   p6    1    �     z     �     
     %                   o%       o           %                  
"     '  
   �                   7    1    �     �     �     
     %                   o%       o           %                   
"     '  
   �                   �7    1    �     �     �     
     %                   o%       o           %                   
"     '  
   �              P8    1    �     �     �     "     
"     '  
   �              �8    1    �     �     �     �     
"     '  
   �                   �8    1    �     �     �     p     %                   o%       o           o%       o           
"     '  
   �                   �9    1    �     �     �     �     %                   o%       o           �     �     
"     '  
   �                   (:    1    �     �     �     �     %                   o%       o           o%       o           
"     '  
   �                   �:    1    �     �     �     
     o%       o           o%       o           o%       o           
"     '  
   �                   h;    1    �     �     �     �  	   %                   o%       o           o%       o           
"     '  
   �                   <    1    �           �     �     %                   o%       o           o%       o           
"     '  
   �                   �<    1    �        
   �     p     %                   o%       o           o%       o           
"     '  
   �              H=    1    �     (      �     �     
"     '  
   �                   �=    1    �     9      �     �     %                   o%       o           �     P   4  
"     '  
   �                   0>    1    �     �   
   �     
     %                   o%       o           %                  
"     '  
   �              �>    1    �     �      �     "     
"     '  
   �                    ?    1    �     �      �     �     %                   o%       o           �     �      
"     '  
   �                   �?    1    �     �      �     
     %                   o%       o           %                  
"     '  
   �                   X@    1    �     �      �     �     %                   o%       o           �     �      
"     '  
   �                   �@    1    �     �      �     �     %                   o%       o           �     �      
"     '  
   �                   �A    1    �     �      �     �     %                   o%       o           �     �      
"     '  
   �                    B    1    �     �      �     
     %                   o%       o           %                   
"     '  
   �                   �B    1    �     �   	   �     "     %                   o%       o           o%       o           
"     '  
   �                   `C    1    �     �      �     �     %                   o%       o           �     !  	  
"     '  
   �                   �C    1    �     !     �     p     %                   o%       o           %           �       
"     '  
   �                   �D    1    �     #!     �     �     %                   o%       o           �     �      
"     '  
   �                   0E    1    �     *!     �     
     o%       o           o%       o           %                  
"     '  
   �                   �E    1    �     <!     �     
     %                   o%       o           %                   
"     '  
   �                   pF    1    �     S!     �     �     %                   o%       o           o%       o           
"     '  
   �                   G    1    �     d!     �     �  	   %                   o%       o           �     �     
"     '  
   �              �G    1    �     u!     �     �  	   x     �p     
�h     T             %                  �             }        �G    G     %                  
"     '  
   �                   xH    1    �     �!  
   �     �     %                   o%       o           �     �      
"     '  
   �                   I    1    �     �!     �     
     %                   o%       o           %                   
"     '  
   �                   �I    1    �     �!  	   �     �     %                   o%       o           �     �      
"     '  
   �                   HJ    1    �     �!     �     �     %                   o%       o           �     �      
"     '  
   �                   �J    1    �     �!     �     
     %                   o%       o           %                   
"     '  
   �                   �K    1    �     �!     �     �     %                   o%       o           �     �      
"     '  
   �                   L    1    �     �!     �     �     %                   o%       o           o%       o           
"     '  
   �                   �L    1    �     �!     �     �     %                   o%       o           o%       o           
"     '  
   �                   XM    1    �     �!     �     
     %                   o%       o           o%       o           
"     '  
   �                   �M    1    �     �!     �     
     %                   o%       o           o%       o           
"     '  
   �                   �N    1    �     "     �     
     %                   o%       o           o%       o           
"     '  
   �                   8O    1    �     "     �     �     %                   o%       o           o%       o           
"     '  
   �                   �O    1    �     ("  	   �     �  	   %                   o%       o           �     �     
"     '  
   �                   pP    1    �     2"  
   �     �  	   %                   o%       o           �     �     
"     '  
   �                   Q    1    �     ="     �     �     %                   o%       o           �     �     
"     '  
   �                   �Q    1    �     L"     �     �     %                   o%       o           o%       o           
"     '  
   �                   @R    1    �     Z"     �     �     %                   o%       o           o%       o           
"     '  
   �                   �R    1    �     g"     �     �     %                   o%       o           �     �     
"     '  
   �                   xS    1    �     |"     �     �     %                   o%       o           �     �     
"     '  
   �                   T    1    �     �"     �     �  	   %                   o%       o           o%       o           
"     '  
   �              �T    1    �     �"     �     "     
"     '  
   �                    U    1    �     �"     �     �     %                   o%       o           �     �     
"     '  
   �                   �U    1    �     �"     �     �     %                   o%       o           o%       o           
"     '  
   �                   8V    1    �     �"     �     
     %                   o%       o           o%       o           
"     '  
   �                   �V    1    �     �"  
   �     �     %                   o%       o           �     �     
"     '  
   �                   pW    1    �     �"     �     �     %                   o%       o           �     �     
"     '  
   �                   X    1    �     �"     �     
     %                   o%       o           %                   
"     '  
   �                   �X    1    �     #     �     �     %                   o%       o           o%       o           
"     '  
   �              HY    1    �     "#  
   �     �     
"     '  
   �              �Y    1    �     -#     �     �     
"     '  
   �              �Y    1    �           �     �     
"     '  
   �              8Z    1    �     <#     �     �     
"     '  
   �              �Z    1    �     J#  
   �     �     
"     '  
   �              �Z    1    �     U#     �     �     
"     '  
   �              ([    1    �     g#     �     �     
"     '  
   �              x[    1    �     x#     �     �     
"     '  
   �              �[    1    �     �#     �     �     
"     '  
   �              \    1    �     �#     �     �     
"     '  
   �                   h\    1    �     �#     �     �#     %                   o%       o           %                  
"     '  
   �                   ]    1    �     �#     �     �#     %                   o%       o           %                  
"     '  
   �              �]    1    �     �#     �     �     
"     '  
   �              �]    1    �          �     �     
"     '  
   �              H^    1    �     �#     �     �     
"     '  
   �              �^    1    �     �#     �     "     
"     '  
   �              �^    1    �     �#     �     �#     
"     '  
   �              8_    1    �     $     �     �          "     '     %          start-super-proc �    % t-su    adm2/smart.p    x     �p     
�h     T             %                  �             }        �G    G     %                  
"     '  
   �               h`    6    �     %     
"     '  
   
�                �`    8    
"     '  
   �                �`    �    �             }        �G     P                                         
"     '  
   G     %                  G     %                  %x     m h   ForeignFields,ObjectName,OpenOnInit,PromptColumns,PromptOnDelete,RowsToBatch,RebuildOnRepos,ToggleDataTargets   
�h     T             %                  �             }        �G    G     %                  
"     '  
   
"     '  
   
"     '  
   
"     '  
   (  �         @ �                        �                �b    �    �     %       �           �                �b    �    `            
� `  @     
�               �b    �    �     .     p�                       �L    
�            %                  � `              �b    �     @                          �     5                  
�            �     O     
"     '  
   p� `  @     
�               �d    �    �     )     p�                       �L    "     ' !    �            �     =$     �     ?$     �             }        �A     0            |            "     ' !    �     =$     %                  (` 0 �         @            |             �             }        �A    �     A$     "     ' "                "     ' !    "     ' "      `         "     ' !    "     ' "    @            |             �             }        �A    �     A$     "     ' "    
�h     T             %                  �             }        �G    G     %                  
"     '  
   
"     '  
   
"     '  
   
"     '  
   (  �         @ �                        �                Hg    �    �     %       �           �                Xg    �    `            
� `  @     
�               hg    �    �     .     p�                       �L    
�            %                  � `              xg    �     @                          �     5                  
�            �     O     
"     '  
   p� `  @     
�               0i    �    �     �  
   p�                       �L    "     ' !    
�h     T             %                  �             }        �G    G     %                  
"     '  
   
"     '  
   
"     '  
   
"     '  
   (  �         @ �                        �                 j    �    �     %       �           �                0j    �    `            
� `  @     
�               @j    �    �     .     p�                       �L    
�            %                  � `              Pj    �     @                          �     5                  
�            �     O     
"     '  
   p� `  @     
�               l    �    �     �  
   p�                       �L    %                  
"     '  
   p� `  @     
�               �l    �    �     �     p�                       �L    %                  
"     '  
   p� `  @     
�               m    �    �     '     p�                       �L    %                  
"     '  
   p� `  @     
�               �m    �    �          p�                       �L    (0                        �     �      �     �      �     �      �             }        �A    
�h     T             %                  �             }        �G    G     %                  
"     �  
    @           �     
"     �  
                �                �n    �    �     %     
"     �  
   � `              ho    �     @                          �     5                  
�            �     O     
"     �  
   �                �o    �    
"     �  
   �               (p    /    
"     �  
   
"     �  
   �               hp    6    �     %     
"     �  
   
�                �p    8    
"     �  
   �                �p    �    
"     �  
   �               q    �    
"     �  
   p�             �     j$     
�            �             }        �G     P                                         
"     �  
   G     %                  G     %                  
�             }        �    
"     �  
    @           �     
"     �  
                �                8r    �A    "     �     
"     �  
   
�                �r    �@         �     
"     �  
   "     �     �           }        �    
"     �  
   %                  %                        "     '     %          start-super-proc �    %  t-su    adm2/dataquery.p        
�h     T             %                  �             }        �G    G     %                  
"     '  
   
"     '  
   
"     '  
   
"     '  
   (  �         @ �                        �                Ht    �    �     %       �           �                Xt    �    `            
� `  @     
�               ht    �    �     .     p�                       �L    
�            %                  � `              xt    �     @                          �     5                  
�            �     O     
"     '  
   p� `  @     
�               0v    �    �     �     p�                       �L    %H    > 8   dataAvailable,confirmContinue,isUpdatePending,buildDataRequest  
�h     T             %                  �             }        �G    G     %                  
"     '  
   
"     '  
   
"     '  
   
"     '  
   (  �         @ �                        �                `w    �    �     %       �           �                pw    �    `            
� `  @     
�               �w    �    �     .     p�                       �L    
�            %                  � `              �w    �     @                          �     5                  
�            �     O     
"     '  
   p� `  @     
�               Hy    �    �     �     p�                       �L    %                       "     '     %          start-super-proc �    % t-su    adm2/query.p    %          start-super-proc �    % t-su    adm2/queryext.p %     	    initProps �     
�            %                   �           �     �%     �     �     �     �      p�8  H                 (     "     �             �     �%  	   
�                        "     �     �     �      
�h     T             %                  �             }        �G    G     %                  
"     '  
   
"     '  
   
"     '  
   
"     '  
   (  �         @ �                        �                �{    �    �     %       �           �                |    �    `            
� `  @     
�               |    �    �     .     p�                       �L    
�            %                  � `              (|    �     @                          �     5                  
�            �     O     
"     '  
   p� `  @     
�               �}    �    �     �!  	   p�                       �L    "     �     "     �     %                  %                  %                  %                  %                  %                  %                  %                  %           	       %           
       %                  %                  %                  %                  %                  %                  %                  %                  "     �     %          start-super-proc �    % t-su    web2/webrep.p   %                   %          start-super-proc �    % t-su    web2/wbdata.p   %                               "     '     �     �      �W                    (     �     �              �h                    (     "     '             �X                    (     �     7&             �c                    (     �     @&             �]                    (     �     �              �\                    (     �     �              �_                    (     �     �              �Y                    (     �     Z&  P           �                    (     �     �&             �                    (     �     �&             �                    0     o%       o                           (     �     �&  4                   0     o%       o                   (X           0                        "     '     �     �&     %                   %                  �     �&     "     '     �d                    (     �     �              �     �&     "           �     '  #   �     0'  /   �     `'  9   �     �'  6   �                    (     �     �'             �     �'     �     �'  6   �                    (     �     (             �     �'     �     *(     �>                    (     �     �              �     :(  ;   �                    P     �                    (     �     v(                     �     �'     �     �(  :   �     �(     �     �(  	   �     �(  	   %          ProcessWebRequest       �           "     '     �                    (     �                           (     �F                             (     "     '             (X           0                        "     '     �     �&     %                   %                  �     �&     �                    (     �     �(  
           ( p �         "     '      P             0                         �     �(     �O             �      )     �N               �           �     )     (0  8                     "     '     �     �      "     '     �                    (     �     !)             "     '     �     0)     �     P)  0   �F             �     �)     �     �)  
   �     �)     "     '     �     �)  %   �     �)  +   8            �                    (     �     �)             �     �)     �     �'     �     *     �     *     �      *     �                    P     �>                    (     �     /*                     �     =*     �     O*     �     l*     �=                    (     �     /*             �     �*     �     �*     �                    P     �@                    (     �     /*                     �     �*     (8           �?                    (     �     /*             �     �*  
   �     �      �     �*  )   �                    P     �<                    (     �     /*                     �     �*     �     �*  8   �     +  
   �     "+     �     ;+  :   �     v+  5   �     �+     �     *     �      *     �                    P     �>                    (     �     �+                     �     =*     �     O*     �     l*     �=                    (     �     �+             �     �*     �     �*     �                    P     �@                    (     �     �+                     �     �*     (8           �?                    (     �     �+             �     �*  
   �     �      �     �*  )   �                    P     �<                    (     �     �+                     �     �*     �     �*  8   �     +  
   �     �+     �     *     �      *     �                    P     �>                    (     �     �+                     �     =*     �     O*     �     l*     �=                    (     �     �+             �     �*     �     �*     �                    P     �@                    (     �     �+                     �     �*     (8           �?                    (     �     �+             �     �*  
   �     �      �     �*  )   �                    P     �<                    (     �     �+                     �     �*     �     �*  8   �     +  
   �     �+     �     *     �      *     �                    P     �>                    (     �     �+                     �     =*     �     O*     �     l*     �=                    (     �     �+             �     �*     �     �*     �                    P     �@                    (     �     �+                     �     �*     (8           �?                    (     �     �+             �     �*  
   �     �      �     �*  )   �                    P     �<                    (     �     �+                     �     �*     �     �*  8   �     +  
   �     �+     �     *     �      *     �                    P     �>                    (     �     �+                     �     =*     �     O*     �     l*     �=                    (     �     �+             �     �*     �     �*     �                    P     �@                    (     �     �+                     �     �*     (8           �?                    (     �     �+             �     �*  
   �     �      �     �*  )   �                    P     �<                    (     �     �+                     �     �*     �     �*  8   �     +  
   �     �+     �     �+  	   �     ,     0                        �P             �     �)     "     '     �     ,  E   "     '     �     Q,  H   0                        �P             �     �)     "     '     �     �,  H   "     '     �     �,  F   0                        �P             �     �)     "     '     �     *-  B   �     m-  -   �           �     �-     �     �     �O             �     �-     �     �-  )   �     �+  	   �     �-     �     �-  
    0           "     '                 "     '     �     �)     �     �-     �     .     �     .     �      .     �     0.       �           "     '     �                    (     �     ?.                     (     �     H.                     (     "     '             �     N.     �     Q.  8   �     �.  7   �     �.     "           �     �.  ,   �     �.     �      .     �     0.       �           "     '     �                    (     �     ?.                     (     �     /                     (     "     '             �     N.     �     !/  ;   �     �.  7   �     �.     "           �     ]/  +   �     �.     �      .     �     0.       �           "     '     �                    (     �     ?.                     (     �     �/                     (     "     '             �     N.     �     �/  7   �     �.  7   �     �.     "           �     �/  +   �     �.     �      .     �     0.       �           "     '     �                    (     �     ?.                     (     �     �/                     (     "     '             �     N.     �     �/  7   �     �.  7   �     �.     "           �     /0  +   �     �.     �     [0  
   �     f0  
   �     q0     �3             �g                         "     '     �     �      �R                    (     �     �0                     (     "     '             �     �0     �     �0                     �           �   p       ��                  �  �  �               �y                        O   ����    e�          O   ����    R�          O   ����    ��            �  �   �       x          4   ����x      �   �  �    ��                                    ����                                                    �           �   p       ��                  �  �  �               �~                        O   ����    e�          O   ����    R�          O   ����    ��          /  �  �      �   �                          3   �����                                  3   �����    ��                                    ����                                                    �           �   p       ��                 �  "  �               H�                        O   ����    e�          O   ����    R�          O   ����    ��      �   (                       �              �    �                    4   ����      $  �  H  ���                           8      (                       � ߱        �      (                       � ߱        �  $  �  x  ���                           �    �  �    h  �          4   �����      $  �  8  ���                           �      (                       � ߱                �  �      �          4   �����      $    �  ���                           �      (                       � ߱        8  /	    (                                    3   ����  �      X  h      0          4   ����0      O     ��  ��  X  h      �         x          4   ����x                0                      ��                                      X�                             �          P  �      �          4   �����                �                      ��                                      P�                             `  P  /            �                          3   ����h            @                      3   �����      O     ��  ��  �      O   !  ��  ��  �             (  �          �  �   0 �                                                                              (         ��                                    ����                                                    �           �   p       ��                 )  I  �               ��                        O   ����    e�          O   ����    R�          O   ����    ��      �   )                       �                p   6  �    �  E      x              $  7  H  ���                                 )                       � ߱        �  �     (      $  8  �  ���                           8      )                       � ߱        X  �     P      $  9  (  ���                           `      )                       � ߱        �  h     p      $  :  �  ���                           �      )                       � ߱        8  �     �      $  ;    ���                           �      )                       � ߱            �     �                �                      ��                  <  ?                  �                           <  H  �  /  =  �       �                          3   �����  8     
   (                      3   ����	            X  h                  3   ����	      $   =  �  ���                                    )                       � ߱            $  >  �  ���                           (	      )                       � ߱                      �                      ��                  @  D                  �                           @  (    /	  A  �     �  p	                          3   ����H	                                  3   �����	        B  8  H  �  �	          4   �����	      $  B  x  ���                           �	      )                       � ߱            $  C  �  ���                           �	      )                       � ߱            O   H  ��  ��  �	             )  �          �  �   @ X                                                                 0              0          )         ��                                    ����                                                    X          �   p       ��                 Q  {  �               0�                        O   ����    e�          O   ����    R�          O   ����    ��      L   *                       �                h      �  8                      ��        0         c  y                  ��    *  �
                c  �       $  c  �  ���                           �	      *                       � ߱        (  $  c  �  ���                           (
      *                       � ߱            4   ����`
  �  $  d  h  ���                           �
      *                       � ߱        �    e  �  8      �
          4   �����
                H                      ��                  e  k                  @                           e  �  �  	  f  �                                        �  3   ����H  �  3   ����X  �  3   ����p  �  3   �����  �  3   �����      3   �����      O   j  �� ��      X  $  l  (  ���                           �      *                       � ߱        �  $  n  �  ���                           h      *                       � ߱            p   q    �  (  x      H  �           $ r    ���                           (      '                       � ߱        �  X     @      $  s  �  ���                           P      '                       � ߱            �     `      $  t  �  ���                           p      '                       � ߱            /	  v  X     h  �                          3   �����  �        �                      3   �����            �                      3   �����             *  �          P  h   h                                                                                            (   8   H   X          (   8   H   X          *         ��                                    ����                                                    �           �   p       ��                 )  M  �               (#                        O   ����    e�          O   ����    R�          O   ����    ��        $  8  �   ���                           �n     
 �                       � ߱              9  8  �       o          4   ���� o                �                      ��                  :  L                   B                           :  H  �  �  ;  xo                =     �      p          4   ����p                �                      ��                  >  K                  �B                           >    �  o   ?  �    ,                                     �  �   @  8p          �  �   A  xp          X  $  B  (  ���                           �p     
 �                       � ߱        p  �   C  �p          �  �   D  q          �  �   G  Hq              $   J  �  ���                           �q  @         xq                  � ߱                   �  �          x  �   X 8                
             
             
             
                 (   8   H              (   8   H       ����   �         ��                                    ����                                                    �           �   p       ��                 q  �  �               E                        O   ����    e�          O   ����    R�          O   ����    ��      �$   �                       �              �  $  �    ���                           r     
 �                       � ߱                  �  �                      ��                   �  �                  `�                    8     �  H      4   ����Hr      $  �    ���                           �r     
 �                       � ߱        �    �  X  h      �r          4   �����r      /  �  �         �                          3   ���� s  �  �   �  s              O   �  ��  ��  Xs             �  P          0  @   0                               
                                         �     �         ��                                    ����                                                    �           �   p       ��                  �  A  �               8�                        O   ����    e�          O   ����    R�          O   ����    ��        $    �   ���                           �z      �                       � ߱        x  $    H  ���                           �z      �                       � ߱        �  �   �   {                �  �  0      X{          4   ����X{  �{     
 '                   8|      '                   P~  @        
 �}                  � ߱            V   �  �  ���                                       � 7 (            �  � �                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 �   �   �   �   �   �   �   �       (  8  H  X  h  x  �  \  �  �  �  �  <L\l|��������,<L\          �   �   �   �   �   �   �   �      (  8  H  X  h  x  �   \ �  �  �  �  <L\l|��������,<L\      �                    � �                     �     �         ��                                    ����                                                                �   p       ��                  H  O  �               p�                        O   ����    e�          O   ����    R�          O   ����    ��      �0   �        �              �              �0   �        (             �              �0   �                                               � 3 �          �  �   h �                         $     no-output,wsoptions-found,web-object    	    text/html                 P              P   �/$no-output,wsoptions-found,web-object	text/html     �         ��                                    ����                                    TXS WebStream GATEWAY_INTERFACE SERVER_SOFTWARE SERVER_PROTOCOL SERVER_NAME SERVER_PORT REQUEST_METHOD SCRIPT_NAME PATH_INFO PATH_TRANSLATED QUERY_STRING REMOTE_ADDR REMOTE_HOST REMOTE_IDENT REMOTE_USER AUTH_TYPE CONTENT_TYPE CONTENT_LENGTH HTTP_ACCEPT HTTP_COOKIE HTTP_REFERER HTTP_USER_AGENT HTTPS AppProgram AppURL SelfURL HostURL CookiePath RootURL useConnID CookieDomain SelDelim , output-content-type http-newline 
 utc-offset web-utilities-hdl debug-options debugging-enabled MiscVarList CONVERT-DATETIME FORMAT-DATETIME GET-BINARY-DATA GET-CGI GET-CGI-LONG GET-FIELD GET-FIELDEX GET-FROM-FORM-FIELDS GET-LONG-VALUE GET-VALUE GET-VALUEEX GET-USER-FIELD HIDDEN-FIELD HIDDEN-FIELD-LIST HTML-ENCODE OUTPUT-CONTENT-TYPE OUTPUT-HTTP-HEADER SET-USER-FIELD SET-WSEU-COOKIE URL-DECODE URL-ENCODE URL-FIELD URL-FIELD-LIST URL-FORMAT DELETE-COOKIE GET-COOKIE SET-COOKIE AVAILABLE-MESSAGES GET-MESSAGES GET-MESSAGE-GROUPS OUTPUT-MESSAGES QUEUE-MESSAGE CHECK-AGENT-MODE GET-CONFIG gscSessionId SETSESSION GETSESSION SETGLOBAL GETGLOBAL LOGNOTE adm-web-state adm-web-timeout adm-web-tohdlr adm-web-time-remaining ADM-DESTROY Web-State = Timed-Out ADM-TIMING-OUT p-method-name caller-name adm-   local- ADM-ERROR show-errors DISPATCH p_attr-name attr-value p_period Type  Version WEB1.0 Web-State Web-Timeout Web-Timeout-Handler Web-Time-Remaining GET-ATTRIBUTE p-attr-list cntr attr-name attr-entry = Invalid element in set-attribute call: in SET-ATTRIBUTE-LIST e4gl-version e4gl-options e4gl-content-type output-header PROCEDURE output-headers no-content-type <!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
 <!--------------------------------------------------------------------
 * Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
 * 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
 * below.  All Rights Reserved.                                       *
 *                                                                    *
 * The Initial Developer of the Original Code is PSC.  The Original   *
 * Code is Progress IDE code released to open source December 1, 2000.*
 * The contents of this file are subject to the Possenet Public       *
 * License Version 1.0 (the "License"); you may not use this file     *
 * except in compliance with the License.  A copy of the License is   *
 * available as of the date of this notice at                         *
 * http://www.possenet.org/license.html                               *
 * Software distributed under the License is distributed on an "AS IS"*
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
 * should refer to the License for the specific language governing    *
 * rights and limitations under the License.                          *
 * Contributors:                                                      *
 --------------------------------------------------------------------->
 <html>
 <head>
 <meta name="wsoptions" content="no-output">
 <title>Customer Update</title>
 </head>
 <body>
 <center>
 <!-- Report Title -->
 <p><strong>Customer Update</strong><br><br></p>
 SearchValue CurrentRowids BackRowids TmpUrl MaintOption DelimiterField LinkParams FieldName UseRowidsInLink UseNavigation UseSubmit UseReset UseAdd UseCancel UseDelete UseSearchForm DataObject  COLUMNVALMSG DELETEBUFFER DELETEROW GETDELETETABLES GETFRAMEHANDLE LOCKROW SETADDMODE SETDELETETABLES SETFRAMEHANDLE VALIDATECOLUMNS ADDCONTEXTFIELDS ADDSEARCHCRITERIA ANYMESSAGE ASSIGNCOLUMNFORMAT ASSIGNCOLUMNHELP ASSIGNCOLUMNLABEL ASSIGNCOLUMNWIDTH BUFFERHANDLE COLUMNDATATYPE COLUMNFORMAT COLUMNHANDLE COLUMNHELP COLUMNHTMLNAME COLUMNLABEL COLUMNREADONLY COLUMNSTRINGVALUE DESTROYDATAOBJECT EXTENTVALUE FIELDEXPRESSION GETAPPSERVICE GETCONTEXTFIELDS GETCURRENTROWIDS GETFOREIGNFIELDLIST GETNAVIGATIONMODE GETQUERYEMPTY GETQUERYWHERE GETROWIDS GETSEARCHCOLUMNS GETSERVERCONNECTION GETTABLEROWIDS GETTABLES GETUPDATEMODE HTMLALERT HTMLSETFOCUS JOINEXTERNALTABLES JOINFOREIGNFIELDS OPENQUERY REOPENQUERY SETAPPSERVICE SETBUFFERS SETCOLUMNS SETCONTEXTFIELDS SETCURRENTROWIDS SETEXTERNALJOINLIST SETEXTERNALTABLELIST SETEXTERNALTABLES SETEXTERNALWHERELIST SETFOREIGNFIELDLIST SETLINKCOLUMNS SETNAVIGATIONMODE SETQUERYWHERE SETSEARCHCOLUMNS SETSERVERCONNECTION SETUPDATEMODE SHOWDATAMESSAGES STARTDATAOBJECT URLJOINPARAMS URLLINK VALIDATECOLUMNVALUE xiRocketIndexLimit ADDQUERYWHERE ASSIGNQUERYSELECTION BUFFERCOMPAREDBTORO BUFFERWHERECLAUSE CLOSEQUERY COLUMNDBCOLUMN COLUMNQUERYSELECTION COLUMNTABLE COLVALUES DBCOLUMNDATANAME DBCOLUMNHANDLE EXCLUDECOLUMNS FIRSTROWIDS GETDATACOLUMNS GETFOREIGNVALUES GETOBJECTTYPE GETQUERYPOSITION GETQUERYSORT GETQUERYSTRING GETTARGETPROCEDURE INDEXINFORMATION INSERTEXPRESSION NEWQUERYSTRING NEWQUERYVALIDATE NEWQUERYWHERE NEWWHERECLAUSE PREPAREQUERY REFRESHROWIDENT REMOVEFOREIGNKEY REMOVEQUERYSELECTION RESOLVEBUFFER ROWIDWHERE ROWIDWHERECOLS SETQUERYPOSITION SETQUERYSORT SETQUERYSTRING WHERECLAUSEBUFFER gshAstraAppserver gshSessionManager gshRIManager gshSecurityManager gshProfileManager gshRepositoryManager gshTranslationManager gshWebManager gsdSessionObj gshFinManager gshGenManager gshAgnManager gsdTempUniqueID gsdUserObj gsdRenderTypeObj gsdSessionScopeObj ghProp ghADMProps ghADMPropsBuf glADMLoadFromRepos glADMOk ASSIGNLINKPROPERTY FETCHMESSAGES GETCHILDDATAKEY GETCONTAINERHANDLE GETCONTAINERHIDDEN GETCONTAINERSOURCE GETCONTAINERSOURCEEVENTS GETCONTAINERTYPE GETDATALINKSENABLED GETDATASOURCE GETDATASOURCEEVENTS GETDATASOURCENAMES GETDATATARGET GETDATATARGETEVENTS GETDBAWARE GETDESIGNDATAOBJECT GETDYNAMICOBJECT GETINSTANCEPROPERTIES GETLOGICALOBJECTNAME GETLOGICALVERSION GETOBJECTHIDDEN GETOBJECTINITIALIZED GETOBJECTNAME GETOBJECTPAGE GETOBJECTPARENT GETOBJECTVERSION GETOBJECTVERSIONNUMBER GETPARENTDATAKEY GETPASSTHROUGHLINKS GETPHYSICALOBJECTNAME GETPHYSICALVERSION GETPROPERTYDIALOG GETQUERYOBJECT GETRUNATTRIBUTE GETSUPPORTEDLINKS GETTRANSLATABLEPROPERTIES GETUIBMODE GETUSERPROPERTY INSTANCEPROPERTYLIST LINKHANDLES LINKPROPERTY MAPPEDENTRY MESSAGENUMBER PROPERTYTYPE REVIEWMESSAGES SETCHILDDATAKEY SETCONTAINERHIDDEN SETCONTAINERSOURCE SETCONTAINERSOURCEEVENTS SETDATALINKSENABLED SETDATASOURCE SETDATASOURCEEVENTS SETDATASOURCENAMES SETDATATARGET SETDATATARGETEVENTS SETDBAWARE SETDESIGNDATAOBJECT SETDYNAMICOBJECT SETINSTANCEPROPERTIES SETLOGICALOBJECTNAME SETLOGICALVERSION SETOBJECTNAME SETOBJECTPARENT SETOBJECTVERSION SETPARENTDATAKEY SETPASSTHROUGHLINKS SETPHYSICALOBJECTNAME SETPHYSICALVERSION SETRUNATTRIBUTE SETSUPPORTEDLINKS SETTRANSLATABLEPROPERTIES SETUIBMODE SETUSERPROPERTY SHOWMESSAGE SIGNATURE prepareInstance ObjectName CHAR ObjectVersion ADM2.2 ObjectType ContainerType PropertyDialog QueryObject LOGICAL ContainerHandle HANDLE InstanceProperties ForeignFields,ObjectName,OpenOnInit,PromptColumns,PromptOnDelete,RowsToBatch,RebuildOnRepos,ToggleDataTargets SupportedLinks ContainerHidden ObjectInitialized ObjectHidden ObjectsCreated HideOnInit UIBMode ContainerSource ContainerSourceEvents initializeObject,hideObject,viewObject,destroyObject,enableObject,confirmExit,confirmCancel,confirmOk,isUpdateActive DataSource DataSourceEvents dataAvailable,queryPosition,updateState,deleteComplete,fetchDataSet,confirmContinue,confirmCommit,confirmUndo,assignMaxGuess,isUpdatePending TranslatableProperties ObjectPage INT DBAware DesignDataObject DataSourceNames DataTarget DataTargetEvents CHARACTER updateState,rowObjectState,fetchBatch,LinkState LogicalObjectName PhysicalObjectName LogicalVersion PhysicalVersion DynamicObject RunAttribute ChildDataKey ParentDataKey DataLinksEnabled InactiveLinks InstanceId DECIMAL SuperProcedure SuperProcedureMode SuperProcedureHandle LayoutPosition ClassName RenderingProcedure ThinRenderingProcedure Label cType ADMProps Target WHERE Target = WIDGET-H(" ") AutoCommit BLOBColumns BufferHandles CLOBColumns CommitSource CommitSourceEvents commitTransaction,undoTransaction CommitTarget CommitTargetEvents rowObjectState CurrentRowid ROWID CurrentUpdateSource DataColumns DataHandle DataIsFetched DataModified DataQueryBrowsed DataQueryString FetchOnOpen FillBatchOnRepos FilterActive FilterAvailable FilterSource FilterWindow FirstRowNum ForeignFields ForeignValues IgnoreTreeViewFilter IndexInformation LargeColumns LastRowNum NavigationSource NavigationSourceEvents fetchFirst,fetchNext,fetchPrev,fetchLast,startFilter OpenOnInit PrimarySDOSource PromptColumns PromptOnDelete QueryColumns QueryPosition QueryString RebuildOnRepos RowObject RowObjectState NoUpdates RowsToBatch Tables ToggleDataTargets TransferChildrenForAll UpdatableColumns UpdatableWhenNew UpdateSource AssignList AuditEnabled BaseQuery CalcFieldList CheckLastOnOpen DataColumnsByTable DBNames EntityFields FetchHasAudit FetchHasComment FetchAutoComment FirstResultRow KeyFields KeyTableId LastDBRowIdent LastResultRow NewBatchInfo NoLockReadOnlyTables PhysicalTables PositionForClient QueryHandle QueryRowIdent RequiredProperties SkipTransferDBRow TempTables UpdatableColumnsByTable UpdateFromSource WordIndexedFields UpdateMode NavigationMode SearchColumns AppService ExternalTableList ExternalJoinList ExternalWhereList ForeignFieldList ExternalTables HTMLFocusOnError LOG HTMLSelectOnError ContextFields ServerConnection FrameHandle AddMode DeleteTables ghContainer adm2/smart.p cObjectName iStart / \ . hReposBuffer hPropTable hBuffer hTable deleteProperties ADM-CLONE-PROPS pcProcName hProc START-SUPER-PROC adm2/dataquery.p dataAvailable,confirmContinue,isUpdatePending,buildDataRequest adm2/query.p adm2/queryext.p cTable iTable cColumns cDataCols cUpdCols cCalcData cCalcUpd iNumData iNumUpd cBuffers cKeyFields cAssignList iAssigns iPos iEntry iCount cTables cTableAssign cDbEntry cField cKeyTable cQueryString , setTables INITPROPS piTableIndex lRet DELETERECORDSTATIC web2/webrep.p web2/wbdata.p Customer FOR EACH Customer NO-LOCK Customer.Name,Customer.Contact,Customer.Balance,Customer.Discount,Customer.Terms CurrentRowids MaintOption SearchValue,ExternalTables,ExternalRowids,BackRowids ?  <form action=" " method="POST" name="SearchForm">
     <input type="hidden" name="CurrentRowids">
     <input type="hidden" name="Navigate" value="Search">
     <input type="hidden" name="Externaltables" value=" ExternalTables ">
     <input type="hidden" name="ExternalRowids" value=" ExternalRowids     <p><strong>     <input type="text" size="20" name="SearchValue" value=" searchValue     <input type="submit" name="SubmitBtn" value="Search">
     </strong></p>
     <hr>
  </form>
 BackRowids ?ExternalTables= &ExternalRowids= ?CurrentRowids= Externalrowids <script language="JavaScript">
    { document.SearchForm.CurrentRowids.value = " "; }
 </script>
 <form action=" " method="POST" name="DetailForm">  
 <input type="hidden" name="Addmode" value=" Maintoption Add <table border="2" >
   <tr>
   <td><strong> Customer.Name </strong></td>  
   <td><input text="submit" 
              name=" " 
              value="  disabled               onmouseover="window.status=' ';return true"
              onmouseout="window.status='';return true">
   </td>  
   <td>&nbsp;&nbsp;</td>
   <td><input type="button" name="LinkButton" value="Back"
        onClick="window.open('cusrpt','_self')"></td>
   </tr>
 Customer.Contact Customer.Balance Customer.Discount Customer.Terms </table>
 <table>
        <td><input type="submit" name="MaintOption" value="Add"></td>
        <td><input type="submit" name="MaintOption" value="Submit"></td>
        <td><input type="submit" name="MaintOption" value="Cancel"></td>
        <td><input type="reset" name="MaintOption" value="Reset"></td>
        <td><input type="submit" name="MaintOption" value="Delete"
          onClick="if (! confirm('Delete this   and '))
                     return false;"></td>
 </form>
 </center>
  <div align="center"><center>
  <table border="2">
    <tr>
         <td><a
         href=" Navigate First "
         onmouseover="window.status='First';return true"
         onmouseout="window.status='';return true"><img
         src=" /images/first-au.gif" border="0" width="16"
         height="16"></a></td>
 Prev         onmouseover="window.status='Previous';return true"
 /images/prev-au.gif" border="0" width="16"
 Next         onmouseover="window.status='Next';return true"
 /images/next-au.gif" border="0" width="16"
 Last         onmouseover="window.status='Last';return true"
 /images/last-au.gif" border="0" width="16"
     </tr>
  </table>
  </center></div>
 document.DetailForm </body>
 </html>
 p_version p_options p_content-type LOCAL-E4GL-OPTIONS �  X>      H      /     X                     H                   adm-destroy     �  �     �                     �                   adm-timing-out  �  �      (      �          caller-name         (      �         p-method-name   `   8        �   �       (                  dispatch        �  �  �  �  �                        !  "  �  )      �         attr-value          )      �         p_period            )      �        p_attr-name     �   8        �  �      (                  get-attribute   6  7  8  9  :  ;  <  =  >  ?  @  A  B  C  D  E  H  I  �  *      �         cntr    �  *      �         attr-name       �  *      �         attr-value          *               attr-entry          *      0        p-attr-list     �  �        �        p                  set-attribute-list      c  d  e  f  j  k  l  n  q  r  s  t  v  x  y  {      ��      �        pcProcName          ��              pcProcName          ��      0       
 phRowObjUpd     h  ��      X       
 phRowObj        �  ��      �       
 phRowObj        �  ��      �        phRowObj            ��      �        phRowObj            ��      �        pioCancel           ��               pcRelative          ��      H       
 phFilterContainer           ��      x       
 phRowObjUpd     �  ��      �        pcRowIdent          ��      �        pcRowIdent         ��      �       
 phSource        (  ��              phSource            ��      @       
 phSource        p  ��      h        pcText  �  ��      �        pcText      ��      �        pcText  �  ��      �       
 phObject           ��      �       
 phObject            ��              phObject            ��      @        pcField     ��      `        pcCursor        �  ��      �       
 phCaller        �  ��      �        phCaller        �  ��      �        phCaller            ��               phCaller        0  ��      (        pcMod   P  ��      H        pcMod       ��      h       
 pcMod   �  ��      �       
 phSource        �  ��      �        phSource            ��      �       
 phSource        	  ��       	        pdRow       ��       	        pdRow       ��      @	       
 hTarget p	  ��      `	        pcMessage           ��      �	        pcMessage           ��      �	        plEnabled           b      �	         cType   @   
     5   �	          
                  getObjectType   '  ?  A      X
  �      H
  
       hReposBuffer    �
  �      p
  
       hPropTable      �
  �      �
  
       hBuffer     �      �
  
       hTable  �	        6   0
          �
                  adm-clone-props 8  9  :  ;  =  >  ?  @  A  B  C  D  G  J  K  L  M          �      `  
       hProc       �      �        pcProcName      �
  �  	   7   H  h      �                  start-super-proc        �  �  �  �  �  �  �  �  �         �               cTable  @  �      8         iTable  h  �      X         cColumns        �  �      �         cDataCols       �  �      �         cUpdCols        �  �      �         cCalcData         �      �         cCalcUpd        0  �   	             iNumData        P  �   
   H         iNumUpd x  �      h         cBuffers        �  �      �         cKeyFields      �  �      �         cAssignList     �  �      �         iAssigns          �               iPos    0  �      (         iEntry  P  �      H         iCount  p  �      h         cTables �  �     �         cTableAssign    �  �      �         cDbEntry        �  �      �         cField    �      �         cKeyTable           �                cQueryString    �  p     8              `                  initProps           �  �  �  A      �      �         lRet        �      �        piTableIndex    0    (   9   �  �                         deleteRecordStatic      Y  Z  v  w  �  �  �  �  �  �  �  �      $  %  A  B  ^  _  {  |  �  �  �  �  �  �  �  �      )  *  F  G  c  d  f  g  �  �      �        p_version         �      �        p_options           �               p_content-type  �  x     :       �      `                  local-e4gl-options      O      0  �+  �     �                              �          �         GATEWAY_INTERFACE               �         SERVER_SOFTWARE 0                  SERVER_PROTOCOL X        H         SERVER_NAME     �        p         SERVER_PORT     �        �         REQUEST_METHOD  �        �         SCRIPT_NAME     �        �         PATH_INFO                         PATH_TRANSLATED H  	 	     8         QUERY_STRING    p  
 
     `         REMOTE_ADDR     �        �         REMOTE_HOST     �        �         REMOTE_IDENT    �        �         REMOTE_USER                       AUTH_TYPE       8        (         CONTENT_TYPE    `        P         CONTENT_LENGTH  �        x         HTTP_ACCEPT     �        �         HTTP_COOKIE     �        �         HTTP_REFERER             �         HTTP_USER_AGENT                   HTTPS   H        8         AppProgram      h        `         AppURL  �        �         SelfURL �        �         HostURL �        �         CookiePath      �        �         RootURL                  useConnID       @        0         CookieDomain    h        X         SelDelim        �        �         output-content-type     �          �         http-newline    �  ! !     �         utc-offset        " "        
       web-utilities-hdl       @  # #     0         debug-options   p  $ $     X         debugging-enabled       �  % %     �         MiscVarList     �  & &     �         gscSessionId    �  ' '    �         adm-web-state     ' '              adm-web-timeout 8  ' '    (         adm-web-tohdlr  h  ' '    P         adm-web-time-remaining  �  ' '    �         e4gl-version    �  ' '    �         e4gl-options    �  ' '    �         e4gl-content-type         ' ' 	             SearchValue     8  ' ' 
   (         CurrentRowids   `  ' '    P         BackRowids      �  ' '    x         TmpUrl  �  ' '    �         MaintOption     �  ' '    �         DelimiterField  �  ' '    �         LinkParams         ' '             FieldName       H  ' '    8         UseRowidsInLink p  ' '    `         UseNavigation   �  ' '    �         UseSubmit       �  ' '    �         UseReset        �  ' '    �         UseAdd    ' '    �         UseCancel       0  ' '              UseDelete       X  ' '    H         UseSearchForm   �  ' '    p         DataObject      �  + (     �         GATEWAY_INTERFACE       �  , )     �         SERVER_SOFTWARE    - *     �         SERVER_PROTOCOL (  . +              SERVER_NAME     P  / ,     @         SERVER_PORT     x  0 -     h         REQUEST_METHOD  �  1 .     �         SCRIPT_NAME     �  2 /     �         PATH_INFO       �  3 0     �         PATH_TRANSLATED   4 1              QUERY_STRING    @  5 2     0         REMOTE_ADDR     h  6 3     X         REMOTE_HOST     �  7 4     �         REMOTE_IDENT    �  8 5     �         REMOTE_USER     �  9 6     �         AUTH_TYPE         : 7     �         CONTENT_TYPE    0  ; 8               CONTENT_LENGTH  X  < 9     H         HTTP_ACCEPT     �  = :     p         HTTP_COOKIE     �  > ;     �         HTTP_REFERER    �  ? <     �         HTTP_USER_AGENT �  @ =     �         HTTPS     A >              AppProgram      8  B ?     0         AppURL  X  C @     P         SelfURL x  D A     p         HostURL �  E B     �         CookiePath      �  F C     �         RootURL �  G D     �         useConnID          H E                CookieDomain    8   I F     (          SelDelim        h   J G     P          output-content-type     �   K H     �          http-newline    �   L I     �          utc-offset      �   M J     �   
       web-utilities-hdl       !  N K      !         debug-options   @!  O L     (!         debugging-enabled       h!  P M     X!         MiscVarList     �!  ' '    �!         xiRocketIndexLimit      �!  Q N     �!  
       gshAstraAppserver       �!  R O     �!  
       gshSessionManager        "  S P     "  
       gshRIManager    P"  T Q     8"  
       gshSecurityManager      �"  U R     h"  
       gshProfileManager       �"  V S     �"  
       gshRepositoryManager    �"  W T     �"  
       gshTranslationManager   #  X U     �"  
       gshWebManager   0#  Y V      #         gscSessionId    X#  Z W     H#         gsdSessionObj   �#  [ X     p#  
       gshFinManager   �#  \ Y     �#  
       gshGenManager   �#  ] Z     �#  
       gshAgnManager   �#  ^ [     �#         gsdTempUniqueID  $  _ \     $         gsdUserObj      P$  ` ]     8$         gsdRenderTypeObj        �$  a ^     h$         gsdSessionScopeObj      �$  ' '    �$  
       ghProp  �$  ' '    �$  
       ghADMProps      �$  ' '    �$  
       ghADMPropsBuf    %  ' '    %         glADMLoadFromRepos      @%  ' '    8%         glADMOk p%  c _     X%         GATEWAY_INTERFACE       �%  d `     �%         SERVER_SOFTWARE �%  e a     �%         SERVER_PROTOCOL �%  f b     �%         SERVER_NAME     &  g c      &         SERVER_PORT     8&  h d     (&         REQUEST_METHOD  `&  i e     P&         SCRIPT_NAME     �&  j f     x&         PATH_INFO       �&  k g     �&         PATH_TRANSLATED �&  l h     �&         QUERY_STRING     '  m i     �&         REMOTE_ADDR     ('  n j     '         REMOTE_HOST     P'  o k     @'         REMOTE_IDENT    x'  p l     h'         REMOTE_USER     �'  q m     �'         AUTH_TYPE       �'  r n     �'         CONTENT_TYPE    �'  s o     �'         CONTENT_LENGTH  (  t p     (         HTTP_ACCEPT     @(  u q     0(         HTTP_COOKIE     h(  v r     X(         HTTP_REFERER    �(  w s     �(         HTTP_USER_AGENT �(  x t     �(         HTTPS   �(  y u     �(         AppProgram      �(  z v     �(         AppURL  )  { w     )         SelfURL 8)  | x     0)         HostURL `)  } y     P)         CookiePath      �)  ~ z     x)         RootURL �)   {     �)         useConnID       �)  � |     �)         CookieDomain    �)  � }     �)         SelDelim        (*  � ~     *         output-content-type     P*  �      @*         http-newline    x*  � �     h*         utc-offset      �*  � �     �*  
       web-utilities-hdl       �*  � �     �*         debug-options    +  � �     �*         debugging-enabled       (+  � �     +         MiscVarList     P+  ' '     @+  
       ghContainer     x+  ' ' !   h+         cObjectName         ' ' "   �+         iStart  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �            !  "  #  '  (  +  ,  -  .  0  2  4  6  7  8  ;  =  >  @  A  B  C  D  J  L  R  T  V  W  ]  ^  _  `  c  d  f  g  i  j  k  l  m  n  o  q  r  s  u  v  w  x  y  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  $  2  3  7  8  9  :  ;  <  =  >  ?  @  A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  W  X  Y  �  �  �  �  �  �  �  �  �  �  �  �      1  �  �  �  �    �  �  �  �  �  �  {  }  �  �  J  K  L  M  N  O  R  S  T  U  V  W  Z  a  i  j  q  u  v  w  x  y  z  {  |  }  ~    �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �                 	  
                                               !  #  &  '  (  *  +  ,  0  1          r`  '/vobs_prgs/linuxx86_64/dlcbld/src/web2/wbdata.i      �1  � . ./vobs_prgs/linuxx86_64/dlcbld/src/web2/custom/wbdatacustom.i �1  �y # '/vobs_prgs/linuxx86_64/dlcbld/src/web2/webrep.i      82  T� - ./vobs_prgs/linuxx86_64/dlcbld/src/web2/custom/webrepcustom.i x2  �: $ '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/query.i       �2  z , '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/delrecst.i     3   + ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/querycustom.i  @3  � % '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/dataquery.i   �3  �Z * ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/dataquerycustom.i      �3  I� & '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/smart.i       4  Ds ) /vobs_possenet/src/wrappers/fn       X4  tw ( ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/smartcustom.i  �4  Q. ' /vobs_possenet/src/wrappers/set      �4     '/vobs_prgs/linuxx86_64/dlcbld/src/web2/wbdaprop.i     5  ɋ ! ./vobs_prgs/linuxx86_64/dlcbld/src/web2/custom/wbdapropcustom.i       @5  �� " ./vobs_prgs/linuxx86_64/dlcbld/src/web2/custom/wbdaprtocustom.i       �5  � 
 '/vobs_prgs/linuxx86_64/dlcbld/src/web2/webrprop.i    �5  ��  ./vobs_prgs/linuxx86_64/dlcbld/src/web2/custom/webrpropcustom.i        6  ��   ./vobs_prgs/linuxx86_64/dlcbld/src/web2/custom/webrprtocustom.i       p6  YO  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/qryprop.i     �6  -�  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/qrypropcustom.i         7  ��  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/qryprtocustom.i        P7    '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/dataqueryprop.i       �7  �d  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/dataquerypropcustom.i  �7  ��  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/dataqueryprtocustom.i  88  i$  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/smrtprop.i    �8  �j  /vobs_possenet/src/wrappers/get      �8  �  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/smrtpropcustom.i       �8  ��  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/smrtprtocustom.i       H9  ��  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/smrtprto.i    �9  Su  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/globals.i     �9  M�  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/globalscustom.i        :  )a  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/smartdefscustom.i      h:  ��  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/dataqueryprto.i       �:  ª  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/dataquerydefscustom.i   ;  ��  '/vobs_prgs/linuxx86_64/dlcbld/src/adm2/qryprto.i     P;  �  ./vobs_prgs/linuxx86_64/dlcbld/src/adm2/custom/querydefscustom.i      �;  ��  '/vobs_prgs/linuxx86_64/dlcbld/src/web2/webrprto.i    �;  �~  ./vobs_prgs/linuxx86_64/dlcbld/src/web2/custom/webrepdefscustom.i      <  ] 	 '/vobs_prgs/linuxx86_64/dlcbld/src/web2/wbdaprto.i    p<  �-  ./vobs_prgs/linuxx86_64/dlcbld/src/web2/custom/wbdatadefscustom.i     �<  ϗ  -/vobs_prgs/linuxx86_64/dlcbld/src/web/method/e4gl.i   =  �F  -/vobs_prgs/linuxx86_64/dlcbld/src/web/method/admweb.i        @=  w�  -/vobs_prgs/linuxx86_64/dlcbld/src/web/method/cgidefs.i       �=  1e  -/vobs_prgs/linuxx86_64/dlcbld/src/web/method/proto.i �=  �  -/vobs_prgs/linuxx86_64/dlcbld/src/web/method/session.i       >  �   )/vobs_possenet/e4gl/samples/web/intranet/detail.w        ;   I      �>  a   B     �>     �  .   �>  O   �     �>  f   �  #   �>     �  -   �>  T   o  #   �>  �  c  $   ?     I  ,   ?  �  F  $   (?     ,  ,   8?  �  )  $   H?       ,   X?  �    $   h?     �  ,   x?  �  �  $   �?     �  ,   �?  �  �  $   �?     �  ,   �?  �  �  $   �?     �  ,   �?  �  �  $   �?     ~  ,   �?  �  {  $   @     a  ,   @  �  ^  $   (@     D  ,   8@  �  A  $   H@     '  ,   X@  �  $  $   h@     
  ,   x@  �    $   �@     �  ,   �@  �  �  $   �@     �  ,   �@  �  �  $   �@     �  ,   �@  �  �  $   �@     �  ,   �@  �  �  $   A     y  ,   A  �  v  $   (A     \  ,   8A    �  $   HA     �  '   XA    �  $   hA     s  '   xA  �   �  $   �A     �  +   �A  g   u  $   �A  a   m  %   �A       *   �A  _     %   �A     �  '   �A  ]   �  %   �A     �  '   B  G   �  %   B  �   I  &   (B     G  )   8B  �     &   HB     �  (   XB  �   �  &   hB     �  '   xB  �   �  &   �B     o  '   �B  �   n  &   �B     L  '   �B  �   K  &   �B     )  '   �B  �     &   �B     �  '   �B  }   �  &   C     �  '   C     I  &   (C       %   8C     �  $   HC  %   n  #   XC  �   k     hC     �     xC     !     �C     �  #   �C  #   �     �C  _   �     �C  O   �  !   �C     �  "   �C     ]  !   �C  W   U     �C  {   O  
   D  O   A     D     0      (D     �     8D  f   �  
   HD  �   �     XD  O   �     hD     �     xD     W     �D  y   -     �D  �   #     �D  G        �D          �D     �     �D  e   _     �D  �  >     �D          E  �  �     E  O   �     (E     �     8E          HE  �   �     XE     {
     hE     �	     xE  x   �	     �E     �	     �E     :	     �E     6	     �E     "	     �E     		     �E  ]   	     �E     �     �E     �     F     �     F     �     (F  Z   n     8F     �     HF     ]     XF     I     hF     -     xF  P     
   �F     �     �F     �  
   �F     �     �F     r  
   �F  N   i     �F     �  	   �F     �     �F     y     G     b     G      _     (G  �   \     8G     �     HG          XG     �     hG     �      xG     �     �G     �     �G     �     �G  �   �     �G  �   �     �G     \     �G     �      �G           �G           