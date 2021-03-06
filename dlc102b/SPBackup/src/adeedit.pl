?undefined               ?  3    /*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure :  _dlggetf.p
    
    Purpose : GUI and Character-mode version of SYSTEM-DIALOG GET-FILE for both
              Open and Save As dialogs.

    Syntax  :
    
        RUN adeedit/_dlggetf.p 
            ( INPUT p_Title ,
              INPUT p_Save_As ,
              INPUT p_Initial_Filter ,
              INPUT-OUTPUT p_File_Spec ,
              OUTPUT p_Return_Status ) .

    Parmameters :

        p_Title           : String to use for dialog box title.
        p_Save_As         : YES means use Save As dlg; NO means Open.
        p_Initial_Filter  : A number indicating which filter should be
                            the initial filter.  Currently unused.
        p_File_Spec       : File spec passed in and out.
        p_Return_Status   : YES - User successfully selected a file name
                            which could be found executing a PROGRESS RUN.
                            NO  - User press Cancel or STOP.
**************************************************************************/

DEFINE INPUT  PARAMETER p_Title            AS CHAR    NO-UNDO.
DEFINE INPUT  PARAMETER p_Save_As          AS LOGICAL NO-UNDO.
DEFINE INPUT  PARAMETER p_Initial_Filter   AS INTEGER INIT 1 NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p_File_Spec  AS CHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER p_Return_Status    AS LOGICAL INIT FALSE NO-UNDO.

DEFINE VAR vAction  AS CHAR NO-UNDO.
DEFINE VAR vMode    AS CHAR NO-UNDO.

/* ADE Standards Include */
{ adecomm/adestds.i }
IF NOT initialized_adestds
THEN RUN adecomm/_adeload.p.

/* Help Context */
{ adecomm/commeng.i }

/* Define temporary widget handle for run-time attributes.            */
DEFINE VAR tmp_handle     AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VAR File_Name AS CHAR LABEL "File Name" FORMAT "x({&PATH_WIDG})"
    VIEW-AS FILL-IN SIZE 60 BY 1.

DEFINE BUTTON btn_OK LABEL "OK"
    {&STDPH_OKBTN} AUTO-GO.

DEFINE BUTTON btn_Cancel LABEL "Cancel"
    {&STDPH_OKBTN} AUTO-ENDKEY.

DEFINE BUTTON btn_Browse LABEL "&Files..."
    {&STDPH_OKBTN}.

DEFINE BUTTON btn_Help LABEL "&Help"
    {&STDPH_OKBTN}.

/* Dialog Button Box */
&IF {&OKBOX} &THEN
DEFINE RECTANGLE GF_Btn_Box    {&STDPH_OKBOX}.
&ENDIF

/* Dialog Box */    
FORM  
  SKIP( {&TFM_WID} )
     "File Name:" {&AT_OKBOX} VIEW-AS TEXT
  SKIP( {&VM_WID} )
     File_Name {&AT_OKBOX}
    { adecomm/okform.i
        &BOX    ="GF_Btn_Box"
        &OK     ="btn_OK"
        &CANCEL ="btn_Cancel"
        &OTHER  ="SPACE( {&HM_BTNG} ) btn_Browse"
        &HELP   ="btn_Help" 
    }
    WITH FRAME DLG-GET-FILE NO-LABELS TITLE p_Title
         VIEW-AS DIALOG-BOX
                 DEFAULT-BUTTON btn_OK
                 CANCEL-BUTTON btn_Cancel.
    { adecomm/okrun.i
        &FRAME  = "FRAME DLG-GET-FILE"
        &BOX    = "GF_Btn_Box"
        &OK     = "btn_OK"
        &OTHER  = "btn_Browse"
        &HELP   = "btn_Help"
    }

/*-------------------- UI Triggers  ------------------------------*/
ON HELP OF FRAME DLG-GET-FILE ANYWHERE
  RUN adecomm/_adehelp.p
      ( INPUT "comm" ,
        INPUT "CONTEXT" , INPUT {&Chr_Open_Dlg_Box} , INPUT ? ).

ON CHOOSE OF btn_Help IN FRAME DLG-GET-FILE
  RUN adecomm/_adehelp.p
      ( INPUT "comm" ,
        INPUT "CONTEXT" , INPUT {&Chr_Open_Dlg_Box} , INPUT ? ).

ON RETURN,ENTER OF File_Name IN FRAME DLG-GET-FILE
DO:
  APPLY "GO" TO FRAME DLG-GET-FILE.
  RETURN NO-APPLY.
END.

ON GO OF FRAME DLG-GET-FILE
DO:
   DEFINE VAR File_Spec    AS CHAR NO-UNDO.
   DEFINE VAR File_Exists  AS LOGI NO-UNDO.
   DEFINE VAR File_Valid   AS LOGI NO-UNDO.
   
   File_Spec = TRIM( File_Name:SCREEN-VALUE IN FRAME DLG-GET-FILE ) .

   /*--------------------------------------------------------------------
       Don't accept blank or unknown as file names.
   --------------------------------------------------------------------*/
   RUN FileValidName ( INPUT p_Title , File_Spec , OUTPUT File_Valid ).
   IF ( File_Valid = NO ) 
   THEN DO:
      APPLY "ENTRY" TO File_Name IN FRAME DLG-GET-FILE.  
      RETURN NO-APPLY.
   END.

   /*--------------------------------------------------------------------
       If Open dialog, file must exist. Using FILE-INFO handle allows
       us to test for a file relative to the PROGRESS PROPATH.
   --------------------------------------------------------------------*/
   IF ( p_Save_As = FALSE )
   THEN DO:
      RUN FileExists ( INPUT p_Title , File_Spec , OUTPUT File_Exists ).
      IF ( File_Exists = NO ) THEN RETURN NO-APPLY.
   END.
 
   HIDE FRAME DLG-GET-FILE NO-PAUSE .
   /* Return filename specification. */
   p_Return_Status = TRUE.
   p_File_Spec = File_Spec.
END.

ON CHOOSE OF btn_Browse IN FRAME DLG-GET-FILE
DO:
   DEFINE VAR File_Spec  AS CHAR NO-UNDO.

   /* Take initial value user typed. Maybe get-file can use it
      as the inital-dir. */
   ASSIGN File_Spec = File_Name:SCREEN-VALUE IN FRAME DLG-GET-FILE.

   RUN SysGetFile 
        ( INPUT "Files" /* p_Title */ ,
          INPUT p_Save_As ,
          INPUT p_Initial_Filter ,
          INPUT-OUTPUT File_Spec ,
          OUTPUT p_Return_Status ) .
    
   IF    ( p_Return_Status = NO )  
      OR ( File_Spec = ? ) 
   THEN RETURN NO-APPLY.
   ELSE DO:
       HIDE FRAME DLG-GET-FILE NO-PAUSE .
       File_Name:SCREEN-VALUE IN FRAME DLG-GET-FILE = File_Spec.
       APPLY "CHOOSE" TO btn_OK IN FRAME DLG-GET-FILE .
   END.
END.


ON WINDOW-CLOSE OF FRAME DLG-GET-FILE
   OR CHOOSE OF btn_Cancel IN FRAME DLG-GET-FILE
DO:
   p_Return_Status = FALSE.
END.


DO: /* Main */

  Dlg_Open :
  DO ON STOP   UNDO Dlg_Open , LEAVE Dlg_Open
     ON ERROR  UNDO Dlg_Open , LEAVE Dlg_Open
     ON ENDKEY UNDO Dlg_Open , LEAVE Dlg_Open :
  
    /*------------------------------------------------------------ 
       If nothing passed for Title, use one of the defaults. 
    ------------------------------------------------------------*/
    IF ( TRIM( p_Title ) = "" ) THEN
      ASSIGN p_Title = IF ( p_Save_As = TRUE ) THEN "Save As" ELSE "Open".
      
    IF ( SESSION:WINDOW-SYSTEM <> "TTY":U ) THEN
    DO:
        ASSIGN vAction  = IF p_Save_As THEN "Save As" ELSE "Open".
        ASSIGN vMode    = IF p_Save_As THEN "Save" ELSE "Open".
        RUN adecomm/_getfile.p
            (INPUT ACTIVE-WINDOW , INPUT ?,
             INPUT vAction      /* Action : "Save As" or "Open" */,
             INPUT p_Title      /* Title */,
             INPUT vMode        /* Mode   : "SAVE" or "OPEN" */,
             INPUT-OUTPUT p_File_Spec,
             OUTPUT p_Return_Status).
        LEAVE Dlg_Open.
    END.
    
    /* If Doing Save As, go straight to TTY get-file dialog. */
    IF ( p_Save_As = YES ) THEN
    DO:
       RUN SysGetFile
           ( INPUT p_Title ,
             INPUT p_Save_As ,
             INPUT p_Initial_Filter ,
             INPUT-OUTPUT p_File_Spec ,
             OUTPUT p_Return_Status ) .
        LEAVE Dlg_Open.
    END.
    ELSE DO:
    /* When TTY/Open, use initial Filename Open dialog with option to browse. */
       VIEW FRAME DLG-GET-FILE .
       UPDATE 
           File_Name
           btn_OK btn_Cancel btn_Browse btn_Help {&WHEN_HELP}
           GO-ON( GO,WINDOW-CLOSE )
           WITH FRAME DLG-GET-FILE .
    END. /* TTY/Open */
  
  END. /* DO ON Dlg_Open */
  
END.  /* Main */


PROCEDURE FileValidName .
   /*--------------------------------------------------------------------
       Don't accept blank or unknown as file names.
   --------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER p_Title      AS CHAR NO-UNDO.
  DEFINE INPUT  PARAMETER p_File_Spec  AS CHAR NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Valid      AS LOGI INIT TRUE NO-UNDO.

  ASSIGN p_Valid = TRUE.

  /* Validate that the name is a legal PROGRESS external procedure name. */
  RUN adecomm/_valpnam.p
      (INPUT  p_File_Spec, INPUT TRUE, INPUT "_EXTERNAL":U,
       OUTPUT p_Valid).

END PROCEDURE.


PROCEDURE FileExists .
   /*--------------------------------------------------------------------
       Test if file exists. Using FILE-INFO handle allows
       us to test for a file relative to the PROGRESS PROPATH.
   --------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER p_Title      AS CHAR NO-UNDO.
  DEFINE INPUT  PARAMETER p_File_Spec  AS CHAR NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Exists     AS LOGI INIT FALSE NO-UNDO.

   ASSIGN FILE-INFO:FILE-NAME = p_File_Spec. 
   IF ( FILE-INFO:FULL-PATHNAME = ? )
   THEN DO:
       MESSAGE p_File_Spec                SKIP
               "Cannot find this file." SKIP(1)
               "Please verify that the correct path and filename are given."
               VIEW-AS ALERT-BOX WARNING BUTTONS OK.
       p_Exists = FALSE.
   END.
   ELSE p_Exists = TRUE.

END PROCEDURE.


PROCEDURE SysGetFile .
  /*---------------------------------------------------------------------
    Purpose : Runs the appropriate Get-File (Open or Save As) dialog box,
              and returns the file spec and dialog status (ie, did user
              press OK or Cancel?)

    Syntax  :
    
        RUN SysGetFile 
            ( INPUT p_Title ,
              INPUT p_Save_As ,
              INPUT p_Initial_Filter ,
              INPUT-OUTPUT p_File_Spec ,
              OUTPUT p_Return_Status ) .
  ---------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER p_Title            AS CHAR    NO-UNDO.
  DEFINE INPUT  PARAMETER p_Save_As          AS LOGICAL NO-UNDO.
  DEFINE INPUT  PARAMETER p_Initial_Filter   AS INTEGER INIT 1 NO-UNDO .
  DEFINE INPUT-OUTPUT PARAMETER p_File_Spec  AS CHAR    NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Return_Status    AS LOGICAL INIT FALSE NO-UNDO.

  DEFINE VARIABLE vOptions     AS CHAR NO-UNDO.
  DEFINE VARIABLE vInitial_Dir AS CHAR NO-UNDO.

  DO: /* Main */
    /*------------------------------------------------------------ 
       If nothing passed for Title, use one of the defaults. 
    ------------------------------------------------------------*/
    IF ( TRIM( p_Title ) = "" ) THEN
        ASSIGN p_Title = IF ( p_Save_As = TRUE ) THEN "Save As" ELSE "Open".
    
    IF ( SESSION:WINDOW-SYSTEM = "TTY" ) THEN
    DO:
      ASSIGN vOptions = "ASK-OVERWRITE,MUST-EXIST" .
      
      /* Its possible that p_File_Spec is a dir name, so try and
         use it as the p_Dir name (pass in) and blank out the
         p_File_Spec. */
      ASSIGN vInitial_Dir = p_File_Spec
             p_File_Spec  = "".
  
      REPEAT ON STOP UNDO, LEAVE:
        RUN adecomm/_filecom.p
          ( INPUT "" /* p_Filter */, 
            INPUT vInitial_Dir /* p_Dir */ , 
            INPUT "" /* p_Drive */ ,
            INPUT p_Save_As ,  
            INPUT p_Title ,
            INPUT vOptions , 
            INPUT-OUTPUT p_File_Spec ,
            OUTPUT p_Return_Status ).
          IF p_Return_Status <> TRUE THEN LEAVE.
          RUN adecomm/_valpnam.p
              (INPUT  p_File_Spec, INPUT YES /* Show Msg */, INPUT "_EXTERNAL":U,
               OUTPUT p_Return_Status).
          IF p_Return_Status = TRUE THEN LEAVE.
      END.
    END.

  END. /* Main */
END PROCEDURE.

/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/****************************************************************************
    Procedure :  _dlgsbuf.p
    
    Syntax    :  
    
                 RUN adeedit/_dlgsbuf.p 
    		    ( p_Window , p_Title , p_Mod_List , 
    		      OUTPUT p_Save_List ) .
    		        	
    Purpose   :  Dialog box which displays a list of modified editor buffers
    		 from which the user selects buffers to save .
    		 
    INPUT PARAMETERS

    	p_Window	(WIDGET-HANDLE)
    		Handle to window in which dialog box should display.

    	p_Title		(CHAR)
    		Title of dialog box. Defaults to "Save Modified Buffers".
    		
    	p_Mod_List	(CHAR)
    		List of modified editor buffers which user can select to
    		save.  Comma-delimited.
    		
    OUTPUT PARAMETERS
    
    	p_Save_List	(CHAR)
    		List of buffers users selected to be saved.
    		
    		Return Value    Description
    		------------	-------------------------------
    		Comma-List	List of buffers to save.
    		Null ("")	User choose to Save None.
    		Unknown (?)	User presed Cancel button.
    		
    Author:	J. Palazzo
    Created:	11.03.92
    		
****************************************************************************/


DEFINE INPUT  PARAMETER p_Window       AS WIDGET-HANDLE NO-UNDO .
DEFINE INPUT  PARAMETER p_Title        AS CHAR NO-UNDO .
DEFINE INPUT  PARAMETER p_Mod_List     AS CHAR NO-UNDO .
DEFINE OUTPUT PARAMETER p_Save_List    AS CHAR INIT ? NO-UNDO .

&GLOBAL-DEFINE WIN95-BTN YES

/* ADE Standards Include */
{ adecomm/adestds.i }
IF NOT initialized_adestds
THEN RUN adecomm/_adeload.p.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE Buf_List AS CHAR 
    VIEW-AS SELECTION-LIST MULTIPLE NO-DRAG 
            LIST-ITEMS ""  SIZE 68 BY 6 SCROLLBAR-V SCROLLBAR-H NO-UNDO.

DEFINE VAR hBuf_List AS WIDGET-HANDLE NO-UNDO .

DEFINE VAR Selected_Count AS CHAR FORMAT "x(20)" NO-UNDO.
DEFINE VAR List_Items AS CHAR NO-UNDO .
DEFINE VAR Num_Selected AS CHAR NO-UNDO .
DEFINE VAR Temp_Bool AS LOGICAL NO-UNDO .

DEFINE BUTTON btn_Save_Sel  LABEL "Save &Selected"
    SIZE 16 BY {&H_OKBTN} DEFAULT AUTO-GO.

DEFINE BUTTON btn_Cancel    LABEL "Cancel"
    {&STDPH_OKBTN} AUTO-ENDKEY.
    
DEFINE BUTTON btn_Save_None LABEL "Save &None"
    {&STDPH_OKBTN}.
    
DEFINE BUTTON btn_Help      LABEL "&Help"
    {&STDPH_OKBTN}.

/* Dialog Button Box */
&IF {&OKBOX} &THEN
DEFINE RECTANGLE SB_Btn_Box    {&STDPH_OKBOX}.
&ENDIF

/* Dialog Box */    
DEFINE FRAME FRAME-A
  SKIP( {&TFM_WID} )
       "Select Changed Buffers to Save:" VIEW-AS TEXT {&AT_OKBOX}
  SKIP( {&VM_WID} )
       Buf_List {&AT_OKBOX}
     Selected_Count VIEW-AS TEXT {&AT_OKBOX}
    { adecomm/okform.i
        &BOX    ="SB_Btn_Box"
        &OK     ="btn_Save_Sel"
        &CANCEL ="btn_Cancel"
        &OTHER  ="SPACE( {&HM_BTNG} ) btn_Save_None"
        &HELP   ="btn_Help" 
    }
    WITH OVERLAY NO-LABELS
         VIEW-AS DIALOG-BOX
                 DEFAULT-BUTTON btn_Save_Sel
                 CANCEL-BUTTON  btn_Cancel.
    { adecomm/okrun.i
        &FRAME  = "FRAME FRAME-A"
        &BOX    = "SB_Btn_Box"
        &OK     = "btn_Save_Sel"
        &CANCEL = "btn_Cancel"
        &OTHER  = "btn_Save_None"
        &HELP   = "btn_Help"
    }

ON HELP OF FRAME FRAME-A ANYWHERE
  RUN adeedit/_edithlp.p ( INPUT "Save_Buffers_Dialog_Box" ).
  
ON CHOOSE OF btn_Help IN FRAME FRAME-A
  RUN adeedit/_edithlp.p ( INPUT "Save_Buffers_Dialog_Box" ).

ON VALUE-CHANGED OF Buf_List IN FRAME FRAME-A
DO:
    RUN SelectedCount.
    DISPLAY Selected_Count WITH FRAME FRAME-A.
    
    IF ( hBuf_List:SCREEN-VALUE = "" ) OR ( hBuf_List:SCREEN-VALUE = ? )
    THEN btn_Save_Sel:SENSITIVE IN FRAME FRAME-A = FALSE .
    ELSE btn_Save_Sel:SENSITIVE IN FRAME FRAME-A = TRUE .
END.
  
ON GO OF FRAME FRAME-A
DO:
  p_Save_List = IF    ( hBuf_List:SCREEN-VALUE = ? ) 
                   OR ( hBuf_List:SCREEN-VALUE = "" )
                THEN ""
                ELSE hBuf_List:SCREEN-VALUE .
END.

ON CHOOSE OF btn_Save_None IN FRAME FRAME-A
  p_Save_List = "" .

ON WINDOW-CLOSE OF FRAME FRAME-A
   OR CHOOSE OF btn_Cancel IN FRAME FRAME-A
  p_Save_List = ? .

PROCEDURE SelectedCount .
        Num_Selected =  IF   ( hBuf_List:SCREEN-VALUE = "" ) 
                          OR ( hBuf_List:SCREEN-VALUE = ? )
        THEN "0"
        ELSE STRING( NUM-ENTRIES( hBuf_List:SCREEN-VALUE ) ) .
        Selected_Count = Num_Selected +  List_Items.
END PROCEDURE.  /* SelectedCount */


DO:    /* Main */

  /* ASSIGN RUN TIME ATTRIBUTES */
  ASSIGN
    hBuf_List            = Buf_List:HANDLE IN FRAME FRAME-A
    p_Save_List          = ?
    hBuf_List:LIST-ITEMS = p_Mod_List
    FRAME FRAME-A:TITLE = IF ( p_Title <> "" )
    			     THEN p_Title 
    			     ELSE "Save Changed Buffers"
    .
  
  ENABLE ALL EXCEPT btn_Help WITH FRAME FRAME-A.
  ENABLE btn_Help {&WHEN_HELP} WITH FRAME FRAME-A.

  ASSIGN
    hBuf_List:SCREEN-VALUE = hBuf_List:LIST-ITEMS
    Temp_Bool              = 
            hBuf_List:SCROLL-TO-ITEM( hBuf_List:ENTRY( 1 ) )
    List_Items             = " of " + 
                             STRING( NUM-ENTRIES( p_Mod_List ) ) + 
                             " selected.".
  
  RUN SelectedCount.
  DISPLAY Selected_Count WITH FRAME FRAME-A.
  
  _DLG_SBUF :
  DO ON STOP   UNDO _DLG_SBUF , LEAVE _DLG_SBUF
     ON ENDKEY UNDO _DLG_SBUF , LEAVE _DLG_SBUF
     ON ERROR  UNDO _DLG_SBUF , LEAVE _DLG_SBUF:
     SET Buf_List
	GO-ON( GO , WINDOW-CLOSE, 
               CHOOSE OF btn_Save_None )
        WITH FRAME FRAME-A .
  END.

END.  /* Main */

/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/***************************************************************************
    Procedure:      _edithlp.p
    Purpose:        Help API for Procedure Editor Help.

    Run Syntax:     RUN adeedit/_edithlp.p ( INPUT p_Help_On ) .

    Parameters:

          INPUT p_Help_On
                The SYSTEM-HELP <context-string> for which you want help.

                For example, the context string of the Buffer List dialog
                box is Buffer_List_Dialog_Box.  This is converted to the
                appropriate SYSTEM-HELP <context-number>.

    Description:
    Notes:
***************************************************************************/

DEFINE INPUT PARAMETER p_Help_On      AS CHARACTER NO-UNDO .

{ adeedit/edithelp.i }

DEFINE VAR             vHelp_Context  AS INTEGER   NO-UNDO .

/* proc-main */
REPEAT ON STOP UNDO, LEAVE:

CASE p_Help_On :

    /*--------------- Search Help ---------------*/
    /* See adecomm/_srchhlp.p */

    /*--------------- Buffer Help ---------------*/
    WHEN "Buffer_List_Dialog_Box"
    	THEN vHelp_Context = {&Buffer_List_Dialog_Box} .
    
    WHEN "Buffer_Settings_Dialog_Box"
    	THEN vHelp_Context = {&Buffer_Settings_Dialog_Box} .

    /*--------------- Compile Help --------------*/
    WHEN "Compiler_Message_Dialog_Box"
        THEN vHelp_Context = {&Compiler_Message_Dialog_Box} .

    /*--------------- Options Help --------------*/
    WHEN "System_Options_Dialog_Box"
    	THEN vHelp_Context = {&System_Options_Dialog_Box} .

    /*-------------- Other Help    --------------*/
    WHEN "Save_Buffers_Dialog_Box"
        THEN vHelp_Context = {&Save_Buffers_Dialog_Box} .
   
END CASE .

RUN adecomm/_adehelp.p
    ( INPUT "edit" , INPUT "CONTEXT" , INPUT vHelp_Context , INPUT ? ) .

LEAVE.

END. /* proc-main */
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/******************************************************************************

Procedure: _proedit.p

Syntax:
        RUN adeedit/_proedit.p
            ( INPUT p_File_List , INPUT p_Edit_Command ).

Purpose:          
    PROGRESS Procedure Editor.

Description:
       This PROGRESS procedure is the "engine" of the PROGRESS Procedure Editor. 
       Other modules call it with a list of files for the editor to open
       for editing purposes.
       
       The PROGRESS Editor executes in its own base window.  From the PROGRESS
       Editor, you may write and change PROGRESS programs, such as procedures
       and includes.

       The PROGRESS Editor is a window-based application that provides both
       mouse pointer operations and keyboard accelerators for editing text.

       The editor operates via a pull-down menu and through keyboard commands.
       
Parameters:

    INPUT p_FileList   (CHAR)
        - Comma-delimited list of os files for the Editor to open for
          editing.  
        
        - If NULL (""), sets current buffer to (Untitled).
        
        - If a file cannot be found, a warning message is given in an alert box.

    INPUT p_Edit_Command
        - Edit Command. See adeedit/dsystem.i for details.

Notes:
        - If the user stops editor execution before reaching the WAIT-FOR,
          the calling module must handle the STOP.

Author: John Palazzo

Date Created: 01.15.92 

*****************************************************************************/

/*-----------------------------  DEFINE VARS  -------------------------------*/

/* ADE Standards Include. */
&GLOBAL-DEFINE WIN95-BTN YES
{ adecomm/adestds.i }
IF NOT initialized_adestds
THEN RUN adecomm/_adeload.p.

/*--------------------------------------------------------------------------
                       System-Wide Defines for Editor 
--------------------------------------------------------------------------*/
{adeedit/dsystem.i}

/*--------------------------------------------------------------------------
             Buffer List-Related Defines for Editor 
--------------------------------------------------------------------------*/
{adeedit/dbuffers.i}

/*--------------------------------------------------------------------------
             File Commands-Related Defines for Editor 
--------------------------------------------------------------------------*/
{adeedit/dfile.i}

/*--------------------------------------------------------------------------
             Edit Commands-Related Defines for Editor 
--------------------------------------------------------------------------*/
/* ED_POPUP tells dedit.i to define a popup menu for editor. */
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
&SCOPED-DEFINE ED_POPUP     "PE_POPUP"
&ENDIF
{adecomm/dedit.i}


/*--------------------------------------------------------------------------
             Search Commands-Related Defines for Editor 
--------------------------------------------------------------------------*/
{adecomm/dsearch.i}

/*--------------------------------------------------------------------------
             Compile Commands-Related Defines for Editor 
--------------------------------------------------------------------------*/
{adeedit/dcompile.i}

/*--------------------------------------------------------------------------
                        Tools Menu Defines
--------------------------------------------------------------------------*/
{adeedit/dtools.i}

/*--------------------------------------------------------------------------
             Help Commands-Related Defines for Editor 
--------------------------------------------------------------------------*/
{adeedit/dhelp.i}

/*-------------------------  DEFINE MENUS AND MENU TRIGGERS  -------------*/
{adeedit/dmenus.i}

/*--------------------------------------------------------------------------
             .cls File Compile Commands-Related defines for Editor 
--------------------------------------------------------------------------*/
{adecomm/dcmpcls.i}

/*-------------------------  INTERNAL PROCEDURES ----------------------------*/

/*--------------------------------------------------------------------------
             System-wide  Procedures for Editor 
--------------------------------------------------------------------------*/
{adeedit/psystem.i}

/*--------------------------------------------------------------------------
             Buffer List-Related Procedures for Editor 
--------------------------------------------------------------------------*/
{adeedit/pbuffers.i}

/*--------------------------------------------------------------------------
             File Commands-Related Procedures for Editor 
--------------------------------------------------------------------------*/
{adeedit/pfile.i}

/*--------------------------------------------------------------------------
             Edit Commands-Related Procedures for Editor 
--------------------------------------------------------------------------*/
{adecomm/pedit.i}

/*--------------------------------------------------------------------------
             Search Commands-Related Procedures for Editor 
--------------------------------------------------------------------------*/
{adecomm/psearch.i}

/*--------------------------------------------------------------------------
             Compile Commands-Related Procedures for Editor 
--------------------------------------------------------------------------*/
{adeedit/pcompile.i}

/*--------------------------------------------------------------------------
             .cls File Compile Commands-Related Procedures for Editor 
--------------------------------------------------------------------------*/
{adecomm/pcmpcls.i}

/*--------------------------------------------------------------------------
             Tools Commands-Related Procedures for Editor 
--------------------------------------------------------------------------*/
{adeedit/ptools.i}

/*--------------------------------------------------------------------------
             Help Commands-Related Procedures for Editor 
--------------------------------------------------------------------------*/
{adeedit/phelp.i}

/*--------------------------------------------------------------------------
             Procedures to support Menus
--------------------------------------------------------------------------*/
{adeedit/pmenus.i}

/*--------------------------------------------------------------------------
             Procedures for Editor Initialization.
--------------------------------------------------------------------------*/
{adeedit/pinit.i}

/*--------------------------------------------------------------------------
             Procedures for Misc Editor operations.
--------------------------------------------------------------------------*/
{adeedit/peditor.i}

/* proc-main */
DO ON STOP UNDO, LEAVE:
    /* If this ADE Tool is already running, don't run again. Return. */
    /* The adecomm tool routine sets tool_bomb. */
    IF ( tool_bomb = TRUE ) THEN RETURN.

    /*----------------------------------------------------------------
        Create unnamed widget-pool so any dynamic widgets created by 
        editor (eg, edit buffers, view windows, etc ) are certain  to
        be deleted when the editor ends.
    ----------------------------------------------------------------*/
    CREATE WIDGET-POOL.
    /*----------------------------------------------------------------
        Run editor's initilization routines.
    ----------------------------------------------------------------*/
    RUN InitEditor.

    /* Trap all CTRL-C's, STOP's, END-ERRORS.  Prevents Editor from exiting. */
    REPEAT ON STOP UNDO, RETRY ON ERROR UNDO, RETRY ON ENDKEY UNDO, RETRY:
       
        WAIT-FOR "U9":U OF win_ProEdit
            FOCUS ProEditor .
        
        IF ( Saved_File = ? )
        THEN DO:
            Quit_Pending = FALSE.  /* Always reset to false. */
            NEXT.
        END.
        
        /* Close PROGRESS Help Window if open. */
        DO ON STOP UNDO, LEAVE: /* ON STOP prevents infinite RETRY loop. */
            RUN adecomm/_adehelp.p ( INPUT "edit" , INPUT "QUIT" , 
                                     INPUT ? , INPUT ? ).
        END.
        
        LEAVE. /* REPEAT ON STOP */
        
    END. /* REPEAT */
    
    /*----------------------------------------------------------------
        Not really needed - when this .p ends, the created unnamed
        widget-pool gets deleted by Progress.  Just for symmetry.
    ----------------------------------------------------------------*/
    DELETE WIDGET-POOL.
 
END. /* proc-main */
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _winrsz.p
    
    Purpose:    Resize the Frame and Editor widgets of the Procedure Editor.

    Syntax :    RUN adeedit/_winrsz.p.

    Parameters: NONE.  Keys off of the p_Window parameter or SELF handle.
    
    Description:
        Resize Algorithm:
            1. If Window W or H grew, grow the Frame's W and H accordingly.
            2. Size the field-level editor widgets to the window LESS the
               Frame Border Widths.
            3. If Window W or H shrank, shrink the Frame's W and H accordingly.
    
    Notes  : Adapted from adecomm/_pwresz.p.
    
    Authors: John Palazzo
    Date   : July, 1993
    Updated: June, 1994 John Palazzo
**************************************************************************/

DEFINE INPUT PARAMETER p_Window AS WIDGET-HANDLE.

DEFINE VARIABLE h         AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h_frame   AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h_Focus   AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE Ret_Value AS LOGICAL       NO-UNDO.

IF p_Window:TYPE <> "WINDOW" 
THEN MESSAGE "Resize can only work on a window!" VIEW-AS ALERT-BOX ERROR.
ELSE DO:

  /* Assign handle of Editor Frame. */
  ASSIGN h_frame = p_Window:FIRST-CHILD.
  DO WHILE VALID-HANDLE( h_frame ) AND h_frame:TYPE <> "FRAME":U :
     ASSIGN h_frame = h_frame:NEXT-SIBLING.
  END.

  /* If no change in window size, return now. */
  IF h_frame:WIDTH-P = p_Window:WIDTH-P AND
     h_frame:HEIGHT-P = p_Window:HEIGHT-P THEN
      RETURN.
  
  /* Motif Only: Hide frame to avoid scrollbar painting. Save focus to restor
    later.
  */
  IF SESSION:WINDOW-SYSTEM = "OSF/Motif" THEN
  DO:
    ASSIGN h_Focus       = FOCUS
         h_frame:VISIBLE = FALSE.
  END.

  /* 1. If Window W or H grew, grow the Frame's W and H accordingly. */
  IF h_frame:WIDTH-P < p_Window:WIDTH-P THEN
      ASSIGN h_frame:WIDTH-P  = p_Window:WIDTH-P.
  IF h_frame:HEIGHT-P < p_Window:HEIGHT-P THEN
      ASSIGN h_frame:HEIGHT-P = p_Window:HEIGHT-P.
  
  /* 2. Size the field-level editor widgets to the window LESS the Frame
     Border Widths.
  */
  ASSIGN h = h_frame:FIRST-CHILD /* field-group   */
         h = h:FIRST-CHILD       /* editor widget */
         . /* END ASSIGN */

    DO WHILE ( h <> ? ) :
        ASSIGN h:WIDTH  = p_Window:WIDTH
                                        - ( h_frame:BORDER-LEFT + 
                                            h_frame:BORDER-RIGHT )
               h:HEIGHT = p_Window:HEIGHT
                                        - ( h_frame:BORDER-TOP + 
                                            h_frame:BORDER-BOTTOM )
               h = h:NEXT-SIBLING
        . /* END ASSIGN */
    END.

  /* 3. If Window W or H shrank, shrink the Frame's W and H accordingly. */
  IF h_frame:WIDTH-P > p_Window:WIDTH-P THEN 
      ASSIGN h_frame:WIDTH-P  = p_Window:WIDTH-P.
  IF h_frame:HEIGHT-P > p_Window:HEIGHT-P THEN
      ASSIGN h_frame:HEIGHT-P = p_Window:HEIGHT-P.

  /* Motif Only: Display frame to avoid scrollbar painting. Restore focus.
     We also need the MOVE-TO-TOP to keep the focus editor in the front
     of the frame.  This must be done AFTER the frame is made visible.
  */
  IF SESSION:WINDOW-SYSTEM = "OSF/Motif" THEN
  DO:
    ASSIGN h_frame:VISIBLE = TRUE 
           Ret_Value = h_Focus:MOVE-TO-TOP()
           NO-ERROR.
    /* Ensure the current Editor widget still has focus. */
    IF VALID-HANDLE( h_Focus) THEN
        APPLY "ENTRY" TO h_Focus.
  END.

END.
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------------
  dbftrigs.i
  Define Triggers For Individual Editor Buffers.
  These triggers are defined as PERSISTENT.
----------------------------------------------------------------------------*/


/*-------------------------  EDITOR KEY TRIGGERS  --------------------------*/

/* CTRL-TAB on Windows moves the focus to the next active field when inside
   an editor widget. In Motif, TAB moves the focus. So we trap both and
   force them to act as Editor TAB. In DOS, CTRL-TAB is NEXT-FRAME and the
   Editor uses it to perform the Next Buffer option, so we trap TAB only
   in DOS.

   A similar situation is true for BACK-TAB and SHIFT-TAB, except we
   can treat them as Editor BACK-TAB for all platforms.
*/
&IF LOOKUP(OPSYS, "MSDOS,WIN32":u ) = 0 &THEN
ON TAB,CTRL-TAB PERSISTENT
  RUN ApplyTab ( INPUT p_Buffer , YES ).
&ELSE
ON TAB PERSISTENT
  RUN ApplyTab ( INPUT p_Buffer , YES ).
&ENDIF

ON BACK-TAB,SHIFT-TAB PERSISTENT
   RUN ApplyBackTab ( INPUT p_Buffer , YES ).

&IF ( "{&WINDOW-SYSTEM}" = "TTY" ) &THEN


/*-----------	File Triggers  --------------*/
ON NEW	      /* File->New */ PERSISTENT
   RUN NewFile.

ON GET	      /* File->Open */ PERSISTENT
   RUN OpenFile.

ON PUT /* File->Save */ PERSISTENT
   RUN SaveFile (INPUT p_Buffer) .

ON SAVE-AS /* File->Save As */ PERSISTENT
   RUN SaveAsFile (INPUT p_Buffer ) .

ON CLOSE,CLEAR /* File->Close */ PERSISTENT
   RUN CloseFile (INPUT p_Buffer ).

ON EXIT /* File->Exit */ PERSISTENT
   RUN WinExitEditor.

/*-----------	Edit Triggers  --------------*/
ON BLOCK PERSISTENT
   RUN SelectSetStart( INPUT p_Buffer ).

ON CUT PERSISTENT
   RUN EditCut ( INPUT p_Buffer ).

ON COPY PERSISTENT
   RUN EditCopy ( INPUT p_Buffer ).

ON PASTE PERSISTENT
   RUN EditPaste ( INPUT p_Buffer ).

/*-----------	Search Menu Triggers  --------------*/
ON FIND /* Search->Find */ PERSISTENT
  RUN FindText ( INPUT p_Buffer ) .

ON FIND-NEXT   /* Search->Find */ PERSISTENT
  RUN FindNext ( INPUT p_Buffer , INPUT Find_Criteria ).

ON FIND-PREVIOUS   /* Search->Find */ PERSISTENT
  RUN FindPrev ( INPUT p_Buffer , INPUT Find_Criteria ).

ON REPLACE /* Search->Replace  */ PERSISTENT
  RUN ReplaceText ( INPUT p_Buffer ).

ON GOTO /* Search->Goto-Line  */ PERSISTENT
  RUN GotoLine ( INPUT p_Buffer ).

/*-----------	Buffer Menu Triggers  --------------*/
ON BREAK-LINE /* Buffer->List */ PERSISTENT
  RUN BufferList ( INPUT p_Window , INPUT p_Buffer ).

ON NEXT-FRAME /* Buffer->Next */ PERSISTENT
  RUN NextBuffer.

ON PREV-FRAME,PAGE-LEFT /* Buffer->Previous */ PERSISTENT
  RUN PrevBuffer.

/*-----------	Compile Menu Triggers  --------------*/
ON GO /* Compile->Run */ PERSISTENT
  RUN RunFile ( INPUT "RUN" ).

ON COMPILE /* Compile->Check-Syntax */ PERSISTENT
  RUN RunFile ( INPUT "CHECK-SYNTAX" ).

&ENDIF
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------------
  dbuffers.i
  Buffer Defines for Editor 
--------------------------------------------------------------------------*/

DEFINE WORKFILE Edit_Window NO-UNDO
  FIELD hWindow AS WIDGET-HANDLE
  FIELD Current_Buffer AS WIDGET-HANDLE
. /* END-WORKFILE */
  
DEFINE WORKFILE Edit_Buffer NO-UNDO
  FIELD hWindow   AS WIDGET-HANDLE
  FIELD hBuffer   AS WIDGET-HANDLE
  /* Stores full file name (OS-SEARCH(FILENAME)) of original file name buffer was read from. */
  FIELD File_Name AS CHARACTER FORMAT "x(40)"  LABEL "File Name"
  /* Stores hBuffer:PRIVATE-DATA - ie, Buffer File Name. */
  FIELD Buffer_Name AS CHARACTER FORMAT "x(40)" LABEL "Buffer Name"
  FIELD Read_Only     AS LOGICAL LABEL "Read-only" VIEW-AS TOGGLE-BOX
  FIELD Auto_Indent  AS LOGICAL LABEL "Auto-indent" VIEW-AS TOGGLE-BOX
  FIELD Cursor_Line  AS INTEGER FORMAT ">>>>9" LABEL "Line"
  FIELD Cursor_Char  AS INTEGER FORMAT ">>>>9" LABEL "Column"
  FIELD Font_Num     AS INTEGER LABEL "Font"
  FIELD Length AS INTEGER FORMAT ">>>>>>9" LABEL "Bytes"
  FIELD Modified  AS LOGICAL LABEL "Modified" FORMAT "Yes/No"
  FIELD Obj-ID    AS INTEGER                /* ADE Object ID */
  FIELD Compile_Name AS CHARACTER FORMAT "x(40)"  LABEL "Compile Name"
  FIELD Class_Type  AS CHARACTER FORMAT "x(40)" LABEL "Class Type" INIT ?
  FIELD Class_TmpDir AS CHARACTER FORMAT "x(40)" LABEL "Class Dir" INIT ?
. /* END-WORKFILE */

DEFINE VARIABLE Buffers_Open AS INTEGER NO-UNDO.



/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------------
  dcompile.i
  Compile Commands-Related Defines for Editor 
--------------------------------------------------------------------------*/

DEFINE STREAM Comp_Msgs.
DEFINE STREAM ttyStream.

DEFINE VARIABLE Run_Window AS WIDGET-HANDLE NO-UNDO.
  /* PROEDIT uses this window when executing procs. */

DEFINE VARIABLE  Compile_FileName AS CHARACTER NO-UNDO.
  /*  Name of temporary OS file name to compile.  */

DEFINE VARIABLE Compiler_Message_Log AS CHARACTER NO-UNDO. /* Log File */

DEFINE VARIABLE Compiler_Messages AS CHARACTER  /* Hold compiler messages. */
    VIEW-AS EDITOR SIZE 75 BY  8 SCROLLBAR-V PFCOLOR 0 FONT 5.

DEFINE VARIABLE System_Error AS LOGICAL NO-UNDO.

/* CW = Compiler_Window */
DEFINE BUTTON CW_Close_Button   LABEL "OK" {&STDPH_OKBTN} AUTO-GO .

/* CW = Compiler_Window */
DEFINE BUTTON CW_Help_Button    LABEL "&Help" {&STDPH_OKBTN}.

/* Dialog Button Box */
&IF {&OKBOX} &THEN
DEFINE RECTANGLE CM_Btn_Box    {&STDPH_OKBOX}.
&ENDIF

/* Dialog Box */    
FORM
    SKIP( {&TFM_WID} )
    Compiler_Messages NO-LABEL {&AT_OKBOX}
&IF FALSE &THEN
    &IF "{&WINDOW-SYSTEM}" <> "TTY":U &THEN
    SKIP({&VM_WIDG})
    "Highlight a keyword and press Help to display PROGRESS 4GL Help."
    VIEW-AS TEXT {&AT_OKBOX}
    &ENDIF
&ENDIF
    { adecomm/okform.i
        &BOX    ="CM_Btn_Box"
        &OK     ="CW_Close_Button"
        &HELP   ="CW_Help_Button" 
    }
    WITH FRAME Compiler-Frame NO-LABELS
         VIEW-AS DIALOG-BOX TITLE "Compiler Messages"
                 DEFAULT-BUTTON CW_Close_Button . 
{ adecomm/okrun.i
    &FRAME  = "FRAME Compiler-Frame"
    &BOX    = "CM_Btn_Box"
    &OK     = "CW_Close_Button"
    &HELP   = "CW_Help_Button"
}
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------------
  dfile.i
  File Commands-Related Defines for Editor 
--------------------------------------------------------------------------*/

DEFINE VARIABLE  File_Name AS CHARACTER LABEL "Filename" FORMAT "x(50)" NO-UNDO.
  /*  OS file name currently being edited.  */

DEFINE VARIABLE Search_File AS CHAR NO-UNDO.
  /* Stores PROPATH search pathname for a file to be opened. */
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------------
  dhelp.i
  Help Related Defines for Editor 
--------------------------------------------------------------------------*/

{ adeedit/edithelp.i }
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*---------------------------------------------------------------------------
  dmenus.i
  DEFINE MENUS for Editor
----------------------------------------------------------------------------*/

/* The conditional menu accelerator definitions below are used to support
   menu accelerators in both GUI and TTY environments.  The TTY accelerators
   follow the keyfunction mappings defined in adeedit/dbftrigs.i.
*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
DEFINE VARIABLE mi_mrulist  AS HANDLE    EXTENT 9 NO-UNDO.
DEFINE VARIABLE mi_rule     AS HANDLE             NO-UNDO.

DEFINE TEMP-TABLE mruWork LIKE MRU_Files.
&ENDIF

DEFINE VARIABLE mi_AddRepos AS HANDLE             NO-UNDO.
DEFINE VARIABLE mi_rule_pr1 AS HANDLE             NO-UNDO.
DEFINE VARIABLE mi_Print    AS HANDLE             NO-UNDO.
DEFINE VARIABLE mi_rule_pr2 AS HANDLE             NO-UNDO.
DEFINE VARIABLE mi_Exit     AS HANDLE             NO-UNDO.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN

/* File */
&SCOPED-DEFINE NEW-ACCEL        "SHIFT-F3"
&SCOPED-DEFINE OPEN-ACCEL       "F3"
&SCOPED-DEFINE CLOSE-ACCEL      "F8"
&SCOPED-DEFINE PWIN-ACCEL       "CTRL-F3"
&SCOPED-DEFINE SAVE-ACCEL       "F6"
&SCOPED-DEFINE SAVEAS-ACCEL     "SHIFT-F6"
/* Edit */
&SCOPED-DEFINE UNDO-ACCEL       "CTRL-Z"
&SCOPED-DEFINE CUT-ACCEL        "CTRL-X"
&SCOPED-DEFINE COPY-ACCEL       "CTRL-C"
&SCOPED-DEFINE PASTE-ACCEL      "CTRL-V"
/* Search */
&SCOPED-DEFINE FIND-ACCEL       "CTRL-F"
&SCOPED-DEFINE FIND-NEXT-ACCEL  "F9"
&SCOPED-DEFINE FIND-PREV-ACCEL  "SHIFT-F9"
&SCOPED-DEFINE REPLACE-ACCEL    "CTRL-R"
&SCOPED-DEFINE GOTOLINE-ACCEL   "CTRL-G"
/* Buffers */
&SCOPED-DEFINE LIST-ACCEL       "CTRL-L"
&SCOPED-DEFINE NEXT-ACCEL       "F7"
&SCOPED-DEFINE PREV-ACCEL       "SHIFT-F7"
/* Compile */
&SCOPED-DEFINE RUN-ACCEL        KBLABEL("GO")
&SCOPED-DEFINE CHECK-ACCEL      "SHIFT-F2"
&SCOPED-DEFINE DEBUG-ACCEL      "SHIFT-F4"
&SCOPED-DEFINE CMSG-ACCEL       "CTRL-E"

&ELSE

/* File */
&SCOPED-DEFINE NEW-ACCEL        KBLABEL("NEW")
&SCOPED-DEFINE OPEN-ACCEL       KBLABEL("GET")
&SCOPED-DEFINE CLOSE-ACCEL      KBLABEL("CLEAR")
&SCOPED-DEFINE SAVE-ACCEL       KBLABEL("PUT")
&SCOPED-DEFINE SAVEAS-ACCEL     KBLABEL("SAVE-AS")
/* Edit */
&SCOPED-DEFINE CUT-ACCEL        KBLABEL("CUT")
&SCOPED-DEFINE COPY-ACCEL       KBLABEL("COPY")
&SCOPED-DEFINE PASTE-ACCEL      KBLABEL("PASTE")
/* Search */
&SCOPED-DEFINE FIND-ACCEL       KBLABEL("FIND")
&SCOPED-DEFINE FIND-NEXT-ACCEL  KBLABEL("FIND-NEXT")
&SCOPED-DEFINE FIND-PREV-ACCEL  KBLABEL("FIND-PREVIOUS")
&SCOPED-DEFINE REPLACE-ACCEL    KBLABEL("REPLACE")
&SCOPED-DEFINE GOTOLINE-ACCEL   KBLABEL("GOTO")
/* Buffers */
&SCOPED-DEFINE LIST-ACCEL       KBLABEL("BREAK-LINE")
&SCOPED-DEFINE NEXT-ACCEL       KBLABEL("NEXT-FRAME")
&SCOPED-DEFINE PREV-ACCEL       KBLABEL("PREV-FRAME")
/* Compile */
&SCOPED-DEFINE RUN-ACCEL        KBLABEL("GO")
&SCOPED-DEFINE CHECK-ACCEL      KBLABEL("COMPILE")
&SCOPED-DEFINE DEBUG-ACCEL      ?
&SCOPED-DEFINE CMSG-ACCEL       ?

&ENDIF

/* Menu definitions here must be kept in sync with Procedure
   MenuAccelInit in adeedit/pmenus.i. Any added items, removed
   items, or items whose internal menu-item names are changed
   must be reflected in MenuAccelInit. -jep 06/29/99 */
   
/* Note: Triggers are defined here with the menu item definitions so that
   when they are referenced on more than one main menubar, their trigger
   actions will always fire correctly. See notes in on-line programming help
   for menu-items regarding using the ON statement vs TRIGGER define block
   when referencing the same sub-menu on more than one main menu.
   -jep 06/29/99 */
   
DEFINE SUB-MENU mnu_File
  MENU-ITEM _New       LABEL "&New      " ACCELERATOR {&NEW-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN NewFile.
  END.
  MENU-ITEM _Open      LABEL "&Open...  " ACCELERATOR {&OPEN-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN OpenFile.
  END.
  MENU-ITEM _Close     LABEL "&Close    " ACCELERATOR {&CLOSE-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN CloseFile ( INPUT ProEditor ) .
  END.
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  RULE
  MENU-ITEM _New_PW    LABEL "New Procedure &Window" ACCELERATOR {&PWIN-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN NewPW.
  END.
&ENDIF
  RULE
  MENU-ITEM _Save      LABEL "&Save      "       ACCELERATOR {&SAVE-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN SaveFile (INPUT ProEditor ) .
  END.
  MENU-ITEM _Save_as   LABEL "Save &As..." ACCELERATOR {&SAVEAS-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN SaveAsFile ( INPUT ProEditor ) .
  END.

/* IZ 2513 Add to Repository and Print menu items are created dynamically in adeedit/pinit.i. */

DEFINE SUB-MENU mnu_Edit
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  MENU-ITEM _Undo           LABEL "&Undo"             ACCELERATOR {&UNDO-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN EditUndo ( ProEditor ) .
  END.
  RULE
&ENDIF
  MENU-ITEM _Cut            LABEL "Cu&t             " ACCELERATOR {&CUT-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN EditCut ( ProEditor ) .
  END.
  MENU-ITEM _Copy           LABEL "&Copy            " ACCELERATOR {&COPY-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN EditCopy ( ProEditor ) .
  END.
  MENU-ITEM _Paste          LABEL "&Paste           " ACCELERATOR {&PASTE-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN EditPaste ( ProEditor ) .
  END.
  RULE
  MENU-ITEM _Insert_File    LABEL "&Insert File...  "
  TRIGGERS:
    ON CHOOSE RUN InsertFile ( ProEditor ) .
  END.
  MENU-ITEM _Field_Selector LABEL "Insert Fie&lds..."
  TRIGGERS:
    ON CHOOSE RUN FieldSelector( ProEditor ).
  END.
  .

  DEFINE SUB-MENU mnu_Search
  MENU-ITEM _Find      LABEL "&Find...      " ACCELERATOR {&FIND-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN FindText( INPUT ProEditor ) .
  END.
  MENU-ITEM _Find_Next LABEL "Find &Next    " ACCELERATOR {&FIND-NEXT-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN FindNext ( INPUT ProEditor , INPUT Find_Criteria ).
  END.
  MENU-ITEM _Find_Prev LABEL "Find &Previous" ACCELERATOR {&FIND-PREV-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN FindPrev ( INPUT ProEditor , INPUT Find_Criteria ).
  END.
  MENU-ITEM _Replace   LABEL "&Replace...   " ACCELERATOR {&REPLACE-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN ReplaceText ( INPUT ProEditor ) .
  END.
  RULE
  MENU-ITEM _Goto_Line LABEL "&Goto Line... " ACCELERATOR {&GOTOLINE-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN GotoLine ( INPUT ProEditor ) .
  END.
  .

DEFINE SUB-MENU mnu_Buffer
  MENU-ITEM _BuffList    LABEL "&List...        " ACCELERATOR {&LIST-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN BufferList ( INPUT win_ProEdit, INPUT ProEditor ).
  END.
  MENU-ITEM _Next        LABEL "&Next Buffer    " ACCELERATOR {&NEXT-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN NextBuffer.
  END.
  MENU-ITEM _Prev        LABEL "&Previous Buffer" ACCELERATOR {&PREV-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN PrevBuffer.
  END.
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  MENU-ITEM _BufFont     LABEL "&Font..."
  TRIGGERS:
    ON CHOOSE RUN BufChangeFont ( INPUT ProEditor ) .
  END.
  &ENDIF
  MENU-ITEM _BufSettings LABEL "&Information..."
  TRIGGERS:
    ON CHOOSE RUN DlgBufSettings ( INPUT ProEditor ) .
  END.
  .

DEFINE SUB-MENU mnu_Compile
  MENU-ITEM _Run          LABEL "&Run               " ACCELERATOR {&RUN-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN RunFile( INPUT "RUN" ).
  END.
  MENU-ITEM _Check_Syntax LABEL "&Check Syntax      " ACCELERATOR {&CHECK-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN RunFile( INPUT "CHECK-SYNTAX" ).
  END.
&IF OPSYS <> "VMS" &THEN
  MENU-ITEM _Debug 	  LABEL "&Debug             " ACCELERATOR {&DEBUG-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN RunFile( INPUT "DEBUG" ).
  END.
&ENDIF
  RULE
  MENU-ITEM _Comp_Msgs    LABEL "Compiler &Messages..." ACCELERATOR {&CMSG-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN CompilerMessages.
  END.
  .

/* ADE Standard Tools Menu Include. */
{ adecomm/toolmenu.i &EXCLUDE_EDIT=yes
                     &DEF_TRIGGERS=yes
                     &PERSISTENT=PERSISTENT}

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
DEFINE SUB-MENU mnu_Options
  MENU-ITEM _Editor_Prefs  LABEL "&Preferences..."
  TRIGGERS:
    ON CHOOSE RUN DlgSysOptions .
  END.
  MENU-ITEM _Menu_Accels  LABEL "&Menu Accelerators..."
  TRIGGERS:
    ON CHOOSE RUN DlgMenuAccels.
  END.
  MENU-ITEM _DefFont      LABEL "Default &Font..."
  TRIGGERS:
    ON CHOOSE RUN ChangeDefFont.
  END.
  .
&ENDIF

DEFINE SUB-MENU mnu_OptionsAdv
  MENU-ITEM _Editor_Prefs  LABEL "&Preferences..."
  TRIGGERS:
    ON CHOOSE RUN DlgSysOptions .
  END.
  MENU-ITEM _Editing_Options LABEL "&Editing Options..."
  TRIGGERS:
    ON CHOOSE RUN EditingOptions ( ProEditor ).
  END.
  MENU-ITEM _Menu_Accels  LABEL "&Menu Accelerators..."
  TRIGGERS:
    ON CHOOSE RUN DlgMenuAccels.
  END.
  MENU-ITEM _DefFont      LABEL "Default &Font..."
  TRIGGERS:
    ON CHOOSE RUN ChangeDefFont.
  END.
  .

/* FRAME f_Buffers is defined in adeedit/dsystem.i. See comments there. */
ON HELP OF FRAME f_Buffers ANYWHERE 
    RUN EditHelp( INPUT ProEditor , 
                  INPUT "edit" , 
                  INPUT 0 /* Zero means Help Topics */ ).

DEFINE SUB-MENU mnu_Help SUB-MENU-HELP
&IF ( "{&WINDOW-SYSTEM}" <> "TTY" ) &THEN
    MENU-ITEM _Help_Master   LABEL "OpenEdge &Master Help"
    TRIGGERS:
      ON CHOOSE RUN adecomm/_adehelp.p 
                  ( INPUT "mast", INPUT "TOPICS", INPUT ?, INPUT ? ).
    END.
    MENU-ITEM _Help_Topics   LABEL "Procedure Editor &Help Topics"
    TRIGGERS:
      ON CHOOSE RUN adecomm/_adehelp.p 
                  ( INPUT "edit" , INPUT "TOPICS" , INPUT ? , INPUT ? ).
    END.
    RULE
&ENDIF
    MENU-ITEM _Menu_Messages LABEL "M&essages..."
    TRIGGERS:
      ON CHOOSE RUN prohelp/_msgs.p.
    END.
    MENU-ITEM _Menu_Recent   LABEL "&Recent Messages..."
    TRIGGERS:
      ON CHOOSE RUN prohelp/_rcntmsg.p.
    END.
&IF ( "{&WINDOW-SYSTEM}" = "TTY" ) &THEN
    MENU-ITEM _Keyboard      LABEL "&Keyboard..."
    TRIGGERS:
      ON CHOOSE RUN prohelp/_keybrd.p.
    END.
&ENDIF
    RULE
    MENU-ITEM _About         LABEL "&About Procedure Editor"
    TRIGGERS:
      ON CHOOSE RUN adecomm/_about.p ( "Procedure Editor" , "adeicon/edit%" ).
    END.
    .

DEFINE MENU mnb_ProEdit
  MENUBAR
  SUB-MENU mnu_File    LABEL "&File"
  SUB-MENU mnu_Edit    LABEL "&Edit"
  SUB-MENU mnu_Search  LABEL "&Search"
  SUB-MENU mnu_Buffer  LABEL "&Buffer"
  SUB-MENU mnu_Compile LABEL "&Compile"
  SUB-MENU mnu_Tools   LABEL "&Tools"
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  SUB-MENU mnu_Options LABEL "&Options"
&ENDIF
  SUB-MENU mnu_Help    LABEL "&Help"
  .

DEFINE MENU mnb_ProEditAdv
  MENUBAR
  SUB-MENU mnu_File    LABEL "&File"
  SUB-MENU mnu_Edit    LABEL "&Edit"
  SUB-MENU mnu_Search  LABEL "&Search"
  SUB-MENU mnu_Buffer  LABEL "&Buffer"
  SUB-MENU mnu_Compile LABEL "&Compile"
  SUB-MENU mnu_Tools   LABEL "&Tools"
  SUB-MENU mnu_OptionsAdv LABEL "&Options"
  SUB-MENU mnu_Help    LABEL "&Help"
  .

ON MENU-DROP OF MENU mnu_Edit IN MENU mnb_ProEdit
  RUN EditMenuDrop ( ProEditor ).

ON MENU-DROP OF MENU mnu_Edit IN MENU mnb_ProEditAdv
  RUN EditMenuDrop ( ProEditor ).

ON MENU-DROP OF MENU mnu_Buffer IN MENU mnb_ProEdit
  RUN BufferMenuDrop .

ON MENU-DROP OF MENU mnu_Buffer IN MENU mnb_ProEditAdv
  RUN BufferMenuDrop .


/*-----------   Tools Menu Triggers  --------------*/
DEFINE VARIABLE h_sm          AS HANDLE      NO-UNDO.
{ adecomm/toolrun.i 
      &MENUBAR="mnb_Proedit"
      &EXCLUDE_EDIT=yes
}

h_sm = MENU mnb_ProEditADv:HANDLE.
{ adecomm/toolrun.i 
      &MENUBAR="mnb_ProeditAdv"
      &EXCLUDE_EDIT=yes
      &TOOL_RUN=yes
}

&IF DEFINED(ED_POPUP) <> 0 &THEN
/*-----------   Edit Popup Menu Triggers  --------------*/
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
ON MENU-DROP OF MENU mnu_EdPopup
  RUN EdPopupDrop ( ProEditor ).
&ENDIF

ON CHOOSE OF MENU-ITEM m_Indent /* Indent */
  RUN ApplyTab ( ProEditor, YES ) .

ON CHOOSE OF MENU-ITEM m_UnIndent /* UnIndent */
  RUN ApplyBackTab ( ProEditor, YES ) .

ON CHOOSE OF MENU-ITEM m_Comment /* Comment */
  RUN CommentSelection ( ProEditor, YES ) .

ON CHOOSE OF MENU-ITEM m_UnComment /* Uncomment */
  RUN CommentSelection ( ProEditor, NO ) .

ON CHOOSE OF MENU-ITEM m_File_Contents
  RUN InsertFile ( ProEditor ) .

ON CHOOSE OF MENU-ITEM m_DB_Fields
  RUN FieldSelector( ProEditor ).

ON CHOOSE OF MENU-ITEM m_Cut
  RUN EditCut ( ProEditor ) .

ON CHOOSE OF MENU-ITEM m_Copy
  RUN EditCopy ( ProEditor ) .

ON CHOOSE OF MENU-ITEM m_Paste
  RUN EditPaste ( ProEditor ) .

ON CHOOSE OF MENU-ITEM m_Run
  RUN RunFile( INPUT "RUN" ).

ON CHOOSE OF MENU-ITEM m_Check_Syntax
  RUN RunFile( INPUT "CHECK-SYNTAX" ).

ON CHOOSE OF MENU-ITEM m_Keyword_Help
    RUN EditHelp( INPUT ProEditor , 
                  INPUT "edit" , 
                  INPUT ? ).

&ENDIF
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*****************************************************************************

    Procedure  :  dsysgetf.i

    Syntax     :
                  { adeedit/dsysgetf.i }

    Description:

    GET-FILE defiinitions.  Use to maintain the File Filter descriptions
    and patterns.  These are used for the List Files of Type box in the
    File Open, File Save As, etc. dialog boxes.

    Notes     : Prodedure file is psysgetf.i .

    Author    : John Palazzo
    Date      : 02.09.93

*****************************************************************************/

  &SCOPED-DEFINE Max_Filters 6

  DEFINE VAR Filter_Desc    AS CHAR NO-UNDO.
  DEFINE VAR Filter_Pattern AS CHAR NO-UNDO.
  DEFINE VAR Filter_NameString AS CHAR EXTENT {&Max_Filters} NO-UNDO.
  DEFINE VAR Filter_FileSpec   AS CHAR EXTENT {&Max_Filters} NO-UNDO.
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------------
  dsystem.i
  Editor-Wide DEFINES.
--------------------------------------------------------------------------*/


DEFINE INPUT PARAMETER p_File_List AS CHARACTER NO-UNDO.
  /* Files editor should open automatically on start-up. */
DEFINE INPUT PARAMETER p_Edit_Command AS CHARACTER NO-UNDO.
  /*---------------------------------------------------------------
    Edit Command.  Behavoir is as follows:
        1. "NEW"         - Ignore p_File_List and Saved Buffer List.  Gives
                           user Empty Untitled buffer.
        2. Anything Else - If p_File_List has value, use it.
                           Otherwise, use Saved Buffer List.
    See Also: adeedit/pinit.i PROCEDURE InitFileList .
  ---------------------------------------------------------------*/
        
/* Not implemented.
DEFINE INPUT PARAMETER p_Obj_IDList AS CHARACTER NO-UNDO.
  /*--------------------------------------------------------------- 
     ADE Object Names for Files editor should open automatically. 
     Null value means this list can be ignored. 
  ---------------------------------------------------------------*/
*/

DEFINE NEW GLOBAL SHARED VAR g_Editor_Cached_Accels AS CHAR NO-UNDO.
    /*------------------------------------------------------------
       To keep Procedure Editor from reading the Menu Accelerators
       for the Editor menu every time the editor is invoked,
       this var is assigned menu accelerator values when:
            1) Editor is invoked for first time during a session.
            2) When the user changes the Accelerators using
               the Menus Accelerator dialog.
       Note: If user changes Env. File during a Progress session,
       Editor will not see changes after first invocation.
       
       Form:
       Comma-delimited list of Menu Items and their accelerators 
       in the form:
                                
          "MenuLabel:Accelerator,..."
                                
       The menu labels have all &, spaces, and ellipses removed.
    ------------------------------------------------------------*/
DEFINE VARIABLE Exclude_Menus AS CHARACTER INIT "&Tools" NO-UNDO.
  /* Comma-delimited list of Editor Menus to not assign/read menu 
     accelerators.  The Tools menu is built dynamically at run-time.
  */
  
/*--------------------------------------------------------------------------
             Editor System-Related Defines for Editor 
--------------------------------------------------------------------------*/
DEFINE VARIABLE Editor_Name AS CHARACTER INIT "Procedure Editor" NO-UNDO.
  /* Name of PROGRESS Editor.  Used in Window:Title, etc. */

DEFINE VARIABLE ProEditor AS WIDGET-HANDLE NO-UNDO.
  /* Editor's Edit Buffer. */

DEFINE VARIABLE win_ProEdit AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE win_ProEdit_Menubar AS WIDGET-HANDLE NO-UNDO. /* SOURCE-EDITOR */

/* Editor System Options Definitions.  Used as default editor-wide settings. */
DEFINE VAR KeyValue_Section AS CHAR INITIAL "Proedit" .

DEFINE WORK-TABLE Sys_Options NO-UNDO
  FIELD KeyGroup AS CHAR INITIAL "SysOptions":u
  
  /* Exit Options */
  FIELD Save_Settings AS LOGICAL LABEL "Save Settings on Exit" 
  		        INITIAL NO VIEW-AS TOGGLE-BOX 
  FIELD Exit_Warning  AS LOGICAL LABEL "Exit Warning to Save Changes" 
  		      INITIAL YES VIEW-AS TOGGLE-BOX 
  FIELD Save_BufList  AS LOGICAL LABEL "Save Buffer List to Open on Startup" 
  		      INITIAL NO VIEW-AS TOGGLE-BOX 
  FIELD BufList       AS CHAR INITIAL ""
  
  /* Run Options */
  FIELD Minimize_BeforeRun  AS LOGICAL LABEL "Minimize Editor Before Running"
  		            INITIAL NO VIEW-AS TOGGLE-BOX
  FIELD Restore_AfterRun    AS LOGICAL LABEL "Restore Editor After Running"
  		            INITIAL YES VIEW-AS TOGGLE-BOX
  FIELD Pause_AfterRun      AS LOGICAL LABEL "Pause After Running"
  		            INITIAL YES VIEW-AS TOGGLE-BOX
  FIELD Auto_Cleanup        AS LOGICAL LABEL "Auto-Cleanup Dynamic Widgets"
  		            INITIAL YES VIEW-AS TOGGLE-BOX
  FIELD MRU_FileList        AS LOGICAL LABEL "Recently Used Filelist:"
                          INITIAL NO VIEW-AS TOGGLE-BOX
  FIELD MRU_Entries         AS INTEGER VIEW-AS FILL-IN INITIAL 0
  		            
  FIELD EditorFont	    AS INTEGER INITIAL ?
  FIELD BG_Color            AS INTEGER INITIAL ?
  FIELD FG_Color            AS INTEGER INITIAL ?
  FIELD SaveClass_BeforeRun AS LOGICAL LABEL "Auto-Save Class Before Running"
                    INITIAL NO VIEW-AS TOGGLE-BOX
  /* END DEFINE */ .

    
DEFINE VARIABLE Untitled AS CHARACTER INIT "Untitled:" NO-UNDO .
  /* 
     Beginning Name of an untitled ProEditor file.  A number is added after (:)
  */
DEFINE VARIABLE Num_Untitled_Buffers AS INTEGER NO-UNDO .
  /* Incrementing counter for untitled buffers. */


DEFINE VARIABLE  User_Selection AS CHARACTER NO-UNDO.
  /*  User's selected action (e.g., "OK" or "CANCEL").  */

DEFINE VARIABLE Saved_File AS LOGICAL NO-UNDO.
  /* Used system-wide to determine if file is saved successfully. */
  
DEFINE VARIABLE Quit_Pending AS LOGICAL INIT FALSE NO-UNDO .
  /* Indicates if QUIT statement executed when running user's code. */
    
DEFINE VAR Edit_Win_State AS INTEGER NO-UNDO.
  /* Editor Window state before Run or Debug. */

DEFINE VAR hCur_Buf_Name AS WIDGET-HANDLE NO-UNDO.
  /* Handle to widget which displays name of current buffer in Char mode. */

/*    Temp-table used to store the internally maintained list of 
      most recently used files */
DEFINE TEMP-TABLE MRU_Files NO-UNDO
    FIELD mru_file         AS CHARACTER
    FIELD mru_position     AS INTEGER
    INDEX mru_idx_position IS UNIQUE PRIMARY mru_position ASCENDING
    INDEX mru_idx_pos_desc IS UNIQUE mru_position         DESCENDING
    INDEX mru_idx_file     IS UNIQUE mru_file             ASCENDING.

/*-----------------------------  DEFINE FORMS -------------------------------*/

/*---------------------------------------------------------------------
   Editor Frame.  All editor widgets get created in this frame.
   In TTY, only current buffer has :VISIBLE = TRUE.  In GUI (which can
   clip overlayed widgets), all buffers have :VISIBLE = TRUE (but only
   current buffer can be seen).
---------------------------------------------------------------------*/

FORM WITH FRAME f_Buffers NO-LABELS NO-BOX.
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------------
  dtools.i 
  Defines for Tools Menu operations.
--------------------------------------------------------------------------*/

/* Defined in dedit.i */
/*
/* Support for Insert Fields */
DEFINE VARIABLE Schema_Prefix   AS INTEGER   NO-UNDO.
DEFINE VARIABLE Schema_Database AS CHARACTER NO-UNDO.
DEFINE VARIABLE Schema_Table    AS CHARACTER NO-UNDO.
*/
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------------
  dtrigs.i
  Define Triggers For Editor.
----------------------------------------------------------------------------*/

/*-------------------------  MENU TRIGGERS    ------------------------------*/


/*-----------   File Menu Triggers  --------------*/
ON CHOOSE OF MENU-ITEM _New      IN MENU mnu_File
  RUN NewFile.

ON CHOOSE OF MENU-ITEM _Open     IN MENU mnu_File
  RUN OpenFile.

ON CHOOSE OF MENU-ITEM _Close    IN MENU mnu_File
  RUN CloseFile ( INPUT ProEditor ) .

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
ON CHOOSE OF MENU-ITEM _New_PW IN MENU mnu_File
  RUN NewPW.
&ENDIF

ON CHOOSE OF MENU-ITEM _Save     IN MENU mnu_File
  RUN SaveFile (INPUT ProEditor ) .

ON CHOOSE OF MENU-ITEM _Save_as  IN MENU mnu_File
  RUN SaveAsFile ( INPUT ProEditor ) .

/* IZ 2513 : Triggers for Add to Repos and Print are defined in pmenus.i. */

/*-----------   Edit Menu Triggers  --------------*/
ON MENU-DROP OF MENU mnu_Edit
  RUN EditMenuDrop ( ProEditor ).

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
ON CHOOSE OF MENU-ITEM _Undo IN MENU mnu_Edit
  RUN EditUndo ( ProEditor ) .
&ENDIF

ON CHOOSE OF MENU-ITEM _Cut IN MENU mnu_Edit
  RUN EditCut ( ProEditor ) .

ON CHOOSE OF MENU-ITEM _Copy IN MENU mnu_Edit
  RUN EditCopy ( ProEditor ) .

ON CHOOSE OF MENU-ITEM _Paste IN MENU mnu_Edit
  RUN EditPaste ( ProEditor ) .

ON CHOOSE OF MENU-ITEM _Insert_File   IN MENU mnu_Edit
  RUN InsertFile ( ProEditor ) .

ON CHOOSE OF MENU-ITEM _Field_Selector    IN MENU mnu_Edit
  RUN FieldSelector( ProEditor ).

/*-----------   Search Menu Triggers  --------------*/
ON CHOOSE OF MENU-ITEM _Find     IN MENU mnu_Search
  RUN FindText( INPUT ProEditor ) .

ON CHOOSE OF MENU-ITEM _Find_Next  IN MENU mnu_Search
  RUN FindNext ( INPUT ProEditor , INPUT Find_Criteria ).
  
ON CHOOSE OF MENU-ITEM _Find_Prev  IN MENU mnu_Search
  RUN FindPrev ( INPUT ProEditor , INPUT Find_Criteria ).

ON CHOOSE OF MENU-ITEM _Replace  IN MENU mnu_Search
  RUN ReplaceText ( INPUT ProEditor ) .

ON CHOOSE OF MENU-ITEM _Goto_Line IN MENU mnu_Search
  RUN GotoLine ( INPUT ProEditor ) .

/*-----------   Buffer Menu Triggers  --------------*/
ON MENU-DROP OF MENU mnu_Buffer
  RUN BufferMenuDrop .

ON CHOOSE OF MENU-ITEM _BuffList  IN MENU mnu_Buffer
  RUN BufferList ( INPUT win_ProEdit, INPUT ProEditor ).

ON CHOOSE OF MENU-ITEM _Next      IN MENU mnu_Buffer
  RUN NextBuffer.

ON CHOOSE OF MENU-ITEM _Prev   IN MENU mnu_Buffer
  RUN PrevBuffer.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
ON CHOOSE OF MENU-ITEM _BufFont IN MENU mnu_Buffer
  RUN BufChangeFont ( INPUT ProEditor ) .
&ENDIF

ON CHOOSE OF MENU-ITEM _BufSettings   IN MENU mnu_Buffer
  RUN DlgBufSettings ( INPUT ProEditor ) .

/*-----------   Compile Menu Triggers  --------------*/
ON CHOOSE OF MENU-ITEM _Run      IN MENU mnu_Compile
  RUN RunFile( INPUT "RUN" ).

ON CHOOSE OF MENU-ITEM _Check_Syntax IN MENU mnu_Compile
  RUN RunFile( INPUT "CHECK-SYNTAX" ).

&IF OPSYS <> "VMS" &THEN
ON CHOOSE OF MENU-ITEM _Debug IN MENU mnu_Compile
  RUN RunFile( INPUT "DEBUG" ).
&ENDIF

ON CHOOSE OF MENU-ITEM _Comp_Msgs IN MENU mnu_Compile
  RUN CompilerMessages.

/*-----------   Tools Menu Triggers  --------------*/
{ adecomm/toolrun.i 
      &MENUBAR="mnb_Proedit"
      &EXCLUDE_EDIT=yes
}

  
/*-----------   Options Menu Triggers  --------------*/
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
ON CHOOSE OF MENU-ITEM _Editor_Opts IN MENU mnu_Options
  RUN DlgSysOptions .

ON CHOOSE OF MENU-ITEM _Menu_Accels IN MENU mnu_Options
  RUN DlgMenuAccels.

ON CHOOSE OF MENU-ITEM _DefFont IN MENU mnu_Options
  RUN ChangeDefFont.
&ENDIF

/*-----------   Help Menu Triggers   ---------------*/

/* FRAME f_Buffers is defined in adeedit/dsystem.i. See comments there. */
ON HELP OF FRAME f_Buffers ANYWHERE 
    RUN EditHelp( INPUT ProEditor , 
                  INPUT "edit" , 
                  INPUT 0 /* Zero means Help Topics */ ).

&IF ( "{&WINDOW-SYSTEM}" <> "TTY" ) &THEN
ON CHOOSE OF MENU-ITEM _Help_Topics IN MENU mnu_Help
    RUN adecomm/_adehelp.p 
        ( INPUT "edit" , INPUT "TOPICS" , INPUT ? , INPUT ? ).
&ENDIF

&IF ( "{&WINDOW-SYSTEM}" = "TTY" ) &THEN
ON CHOOSE OF MENU-ITEM _Keyboard IN MENU mnu_Help
    RUN prohelp/_keybrd.p.
&ENDIF

ON CHOOSE OF MENU-ITEM _Menu_Messages IN MENU mnu_Help
    RUN prohelp/_msgs.p.

ON CHOOSE OF MENU-ITEM _Menu_Recent IN MENU mnu_Help
    RUN prohelp/_rcntmsg.p.

ON CHOOSE OF MENU-ITEM _About IN MENU mnu_Help
    RUN adecomm/_about.p ( "Procedure Editor" , "adeicon/edit%" ).


&IF DEFINED(ED_POPUP) <> 0 &THEN
/*-----------   Edit Popup Menu Triggers  --------------*/
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
ON MENU-DROP OF MENU mnu_EdPopup
  RUN EdPopupDrop ( ProEditor ).
&ENDIF

ON CHOOSE OF MENU-ITEM m_Indent /* Indent */
  RUN ApplyTab ( ProEditor, YES ) .

ON CHOOSE OF MENU-ITEM m_UnIndent /* UnIndent */
  RUN ApplyBackTab ( ProEditor, YES ) .

ON CHOOSE OF MENU-ITEM m_Comment /* Comment */
  RUN CommentSelection ( ProEditor, YES ) .

ON CHOOSE OF MENU-ITEM m_UnComment /* Uncomment */
  RUN CommentSelection ( ProEditor, NO ) .

ON CHOOSE OF MENU-ITEM m_File_Contents
  RUN InsertFile ( ProEditor ) .

ON CHOOSE OF MENU-ITEM m_DB_Fields
  RUN FieldSelector( ProEditor ).

ON CHOOSE OF MENU-ITEM m_Cut
  RUN EditCut ( ProEditor ) .

ON CHOOSE OF MENU-ITEM m_Copy
  RUN EditCopy ( ProEditor ) .

ON CHOOSE OF MENU-ITEM m_Paste
  RUN EditPaste ( ProEditor ) .

ON CHOOSE OF MENU-ITEM m_Run
  RUN RunFile( INPUT "RUN" ).

ON CHOOSE OF MENU-ITEM m_Check_Syntax
  RUN RunFile( INPUT "CHECK-SYNTAX" ).

ON CHOOSE OF MENU-ITEM m_Keyword_Help
    RUN EditHelp( INPUT ProEditor , 
                  INPUT "edit" , 
                  INPUT ? ).

&ENDIF
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* edithelp.i */

/* 
   This file contains
   Help Context Identifiers for PROGRESS PROCEDURE EDITOR HELP
   embedded in PROGRESS pre-processor statements.
   
   The form used in this file is:

   	<Name of the Help Topic>
	&GLOBAL <context-string> <context-number>

*/

/* Help File for the Procedure Editor. */
&GLOBAL-DEFINE Help_File prohelp/editeng.hlp

/* Editor Help Contents screen. */
&GLOBAL Main_Index 49153

/* Editor Help Contents screen. */
&GLOBAL Menu_Commands 49154

/* Help for Main Editor window. */
&GLOBAL Procedure_Editor_Window 49155

/* Help for Editor Buffer List dialog box. */
&GLOBAL Buffer_List_Dialog_Box 49156

/* Help for Compiler Message dialog box. */
&GLOBAL Compiler_Message_Dialog_Box 49157

/* Help for Buffer Information dialog box. */
&GLOBAL Buffer_Settings_Dialog_Box 49158

/* Help for Editor Preferences dialog box. */
&GLOBAL System_Options_Dialog_Box 49159

/* Help for Save Buffers with Changes dialog box. */
&GLOBAL Save_Buffers_Dialog_Box 49160

/* How To Help topic (called from Help menu). */
&GLOBAL How_To 49161
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*---------------------------------------------------------------------------
  Include   : minitdbg.i
  Purpose   : Editor Menu Initialize for Compile->Debug.
  Syntax    : { adeedit/minitdbg.i }

  Description : Used in an include because its encrypted in $DLC/src/adeedit
                to protect reference to GET-LICENSE.
----------------------------------------------------------------------------*/

  ASSIGN MENU-ITEM _Debug:SENSITIVE IN MENU mnu_Compile
                   = ( GET-LICENSE("DEBUGGER") = 0 )
  . /* END ASSIGN. */
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*---------------------------------------------------------------------------
  pbuffers.i
  Buffer and Buffer List Mgt Procedures for Editor.
---------------------------------------------------------------------------*/


PROCEDURE OpenWindow.
  /*---------------------------------------------------------------------
      Opens a top-level editor window.
  ----------------------------------------------------------------------*/
 
  /* Don`t create a window under TTY. Just assign as default window. */
  IF SESSION:WINDOW-SYSTEM <> "TTY" 
    THEN RUN CreateWindow ( OUTPUT win_ProEdit ).
    ELSE win_ProEdit = DEFAULT-WINDOW.
  
  RUN MakeEditWin ( INPUT win_ProEdit ).
  
  CURRENT-WINDOW = win_ProEdit.
  VIEW win_ProEdit.
  IF ( SESSION:WINDOW-SYSTEM <> "TTY" ) THEN
  /* Assign W x H needed for Window RESIZE and MAXIMIZE. */
  ASSIGN
    win_ProEdit:MAX-WIDTH  = ?
    win_ProEdit:MAX-HEIGHT = ? .

  RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "WAIT" ) .


  /* --- Begin SCM changes --- */
  /* Do custom setup -- this file is generally a no-op, but it can
     be used to initialize custom modifications. */
  DEFINE VARIABLE scm_ok AS LOGICAL NO-UNDO.
  RUN adecomm/_adeevnt.p 
      ( INPUT "Editor",
        INPUT "STARTUP", INPUT STRING(THIS-PROCEDURE), INPUT STRING(win_ProEdit),
        OUTPUT scm_ok ).
  /* --- End SCM changes ----- */


  ASSIGN
    /* w and h of frame for proedit's editing window area. */
    FRAME f_Buffers:SCROLLABLE  = NO
    FRAME f_Buffers:WIDTH       = win_ProEdit:WIDTH
    FRAME f_Buffers:HEIGHT      = win_ProEdit:HEIGHT
    FRAME f_Buffers:SENSITIVE   = TRUE
  . /* END ASSIGN */

  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  /* Attach Char Mode top and bottom editor bars and current buffer name. */
  RUN CreateEditorBars( INPUT FRAME f_Buffers:HANDLE , OUTPUT hCur_Buf_Name ).
  &ENDIF

  VIEW FRAME f_Buffers IN WINDOW win_ProEdit.
  RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .
  
END PROCEDURE.  /* OpenWindow */
  

PROCEDURE CreateWindow .
  /*---------------------------------------------------------------------
      Creates a window and returns its window handle.
  ---------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER p_Window AS WIDGET-HANDLE NO-UNDO.

  CREATE WINDOW p_Window
    ASSIGN
      MAX-WIDTH      = ?
      MAX-HEIGHT     = ?
      MIN-WIDTH      = 1 /* Zero is not acceptable to UIM */
      MIN-HEIGHT     = 1
      SCROLL-BARS    = NO
      RESIZE         = YES
      DROP-TARGET    = TRUE
      SENSITIVE      = TRUE
      &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
          TITLE        = Editor_Name  /* System Var in dsystem.i */ 
          MESSAGE-AREA = NO
      &ENDIF
      
      TRIGGERS:
        ON WINDOW-CLOSE PERSISTENT
          RUN _winevnt.p ( INPUT "ED_WINDOW_CLOSE" ) .
        ON WINDOW-RESIZED PERSISTENT
          RUN adeedit/_winrsz.p ( INPUT p_Window ).
        ON DROP-FILE-NOTIFY PERSISTENT
          RUN OpenFile IN THIS-PROCEDURE.
      END
      
    . /* END ASSIGN */
  
  ASSIGN
    p_Window:WIDTH          = FONT-TABLE:GET-TEXT-WIDTH(FILL("0", 85), editor_font)
    p_Window:HEIGHT         = (SESSION:HEIGHT * 0.66)
    p_Window:VIRTUAL-WIDTH  = SESSION:WIDTH
    p_Window:VIRTUAL-HEIGHT = SESSION:HEIGHT
    NO-ERROR.

END PROCEDURE.  /* CreateWindow */


PROCEDURE MakeEditWin .
  /*---------------------------------------------------------------------
      Makes a window an editor window.
      
      - Assigns standard editor menubar and adds to window list.
  ---------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_Window AS WIDGET-HANDLE NO-UNDO.

  DEFINE VAR Return_Status AS LOGICAL NO-UNDO.

  RUN MenuBarSet(p_Window).
  
  /* :ACCELERATOR not supported under TTY, so skip it. */
  IF ( SESSION:WINDOW-SYSTEM <> "TTY" )
  THEN DO:
      /* Load the Editor's minimized icon. */
      Return_Status = p_Window:LOAD-ICON("adeicon/edit%").
      /* Read accelerator key settings from Env File, if necessary. */
      IF ( g_Editor_Cached_Accels = "" )
      THEN DO:
        RUN adecomm/_mnkvals.p ( INPUT p_Window:MENUBAR , INPUT "GET" , 
                                INPUT KeyValue_Section ,
                                INPUT Exclude_Menus /* see dsystem.i */ , 
                                OUTPUT g_Editor_Cached_Accels ).
      END.
  END.
  /* Initialize accelerators and enable states. */
  RUN MenuInit.

  FIND FIRST Edit_Window WHERE Edit_Window.hWindow = p_Window NO-ERROR.
  IF NOT AVAILABLE Edit_Window THEN
  DO:
    CREATE /* WORKFILE */ Edit_Window.
    ASSIGN
      Edit_Window.hWindow = p_Window.
  END.
    
END PROCEDURE.  /* MakeEditWin */



PROCEDURE CreateBuffer .
  /*---------------------------------------------------------------------
      Creates an editor buffer for a window and returns its buffer handle.
      
      - Adds buffer to p_Window's buffer list.
      - Does NOT make buffer visible by default.  This is deliberate 
        and making it visible here may screw up other procedures.

      Note: We substract 2 from the editor height for tty to make room
            for the display of the editor bars and current buffer name.
            See PROCEDURE WinSetTitle for actual disp of buffer name
            and PROCEDURE CreateEditorBars as well.
  ---------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER p_Window AS WIDGET-HANDLE NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO.

  CREATE EDITOR p_Buffer
    ASSIGN
      FRAME          = FRAME f_Buffers:HANDLE
      &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
      ROW            = 2
      &ENDIF
      WIDTH          = FRAME f_Buffers:WIDTH -
                       ( FRAME f_Buffers:BORDER-LEFT + 
                         FRAME f_Buffers:BORDER-RIGHT )
      HEIGHT         = FRAME f_Buffers:HEIGHT -
                       ( FRAME f_Buffers:BORDER-TOP +
                         FRAME f_Buffers:BORDER-BOTTOM )
                       - IF ( SESSION:WINDOW-SYSTEM = "TTY" )
                         THEN 2
                         ELSE 0
      PROGRESS-SOURCE = YES        /* TTY - For Proper wrapping. */
      WORD-WRAP      = FALSE
      SCROLLBAR-H    = ( SESSION:WINDOW-SYSTEM <> "TTY" )
      SCROLLBAR-V    = ( SESSION:WINDOW-SYSTEM <> "TTY" )
      AUTO-INDENT    = TRUE
      FONT           = Sys_Options.EditorFont
      BGCOLOR        = Sys_Options.BG_Color
      FGCOLOR        = Sys_Options.FG_Color
      /* Since widget is not realized, safe to assign pfcolor under GUI. */
      PFCOLOR        = 0
      PRIVATE-DATA   = Untitled
      LARGE          = TRUE
      
    TRIGGERS:
    
      {adeedit/dbftrigs.i}
     
    END.

  RUN SetEditor (INPUT p_Buffer).   /* adecomm/peditor.i */
  ASSIGN p_Buffer:SENSITIVE = TRUE.
  
  /* Add buffer to Buffer List which attaches buffer to a window. */
  FIND LAST Edit_Buffer NO-ERROR. /* List is in Chronological order. */
  CREATE /* WORKFILE */ Edit_Buffer.
  ASSIGN
     Edit_Buffer.hWindow = p_Window
     Edit_Buffer.hBuffer = p_Buffer
     Edit_Buffer.File_Name = Untitled.
     
END PROCEDURE.  /* CreateBuffer */


PROCEDURE AssignBuffer .
  /*---------------------------------------------------------------------
     Assigns the buffer to a file.
  ---------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p_File_Name AS CHAR NO-UNDO.

  DEFINE VARIABLE File_Ext AS CHARACTER   NO-UNDO.

  /* We don't need p_Window because buffer handles are unique system-wide. */
  FIND FIRST Edit_Buffer WHERE Edit_Buffer.hBuffer = p_Buffer.
 
   /*------------------------------------------------------------------------ 
      Buffer:PRIVATE-DATA is actually Edit_Buffer.Buffer_Name.  This represents
      the name the user used to open the file.  This can be different than
      Buffer.File_Name.  e.g., "PROC1.p" is buffer name, "C:\APPL\AR\PROC1.p" is
      original fullpath file name.
   ------------------------------------------------------------------------*/
  ASSIGN p_Buffer:PRIVATE-DATA   = p_File_Name
         Edit_Buffer.Buffer_Name = p_File_Name .
  /*---------------------------------------------------------------------- 
     Note:  E_B:File_Name is the fullpath name of the os file from which buffer
     was originally read. 
  --------------------------------------------------------------------- */
  ASSIGN FILE-INFO:FILENAME    = p_File_Name
         Edit_Buffer.File_name = FILE-INFO:FULL-PATHNAME.

  /* adecomm/peditor.i */
  RUN SetEdBufType (INPUT p_Buffer, INPUT p_File_Name).

  RUN adecomm/_uniqfil.p (p_File_Name, ".ped", OUTPUT Edit_Buffer.Compile_Name).

  /* If this is a .cls file, set the CLASS_TYPE to "" to indicate this.
   * As long as it is not ?, we know it is a .cls, and can set it 
   * with the correct class namespace later. */
  RUN adecomm/_osfext.p(INPUT  p_File_Name, OUTPUT File_Ext).
  IF (File_Ext = ".cls") THEN
    Edit_Buffer.Class_Type = "".

END PROCEDURE.  /* AssignBuffer */


PROCEDURE BufReName .
  /*---------------------------------------------------------------------
     Renames a buffer's Buffer Name.
  ---------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p_File_Name AS CHAR NO-UNDO.

  DEFINE VARIABLE File_Ext AS CHARACTER   NO-UNDO.

  /* We don't need p_Window because buffer handles are unique system-wide. */
  FIND FIRST Edit_Buffer WHERE Edit_Buffer.hBuffer = p_Buffer.
 
   /*-------------------------------------------------------------------- 
      Buffer:PRIVATE-DATA is actually Edit_Buffer.Buffer_Name.  This represents
      the name the user used to open the file.  This can be different than
      Buffer.File_Name.  e.g., "PROC1.p" is buffer name, "C:\APPL\AR\PROC1.p" is
      original fullpath file name.
   --------------------------------------------------------------------*/
  p_Buffer:PRIVATE-DATA   = p_File_Name.
  Edit_Buffer.Buffer_Name = p_File_Name .

  /* adecomm/peditor.i */
  RUN SetEdBufType (INPUT p_Buffer, INPUT p_File_Name).

  RUN adecomm/_uniqfil.p (p_File_Name, ".ped", OUTPUT Edit_Buffer.Compile_Name).
      
  /* check for .cls extension */
  DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE :
      RUN adecomm/_osfext.p (INPUT  p_File_Name,OUTPUT File_Ext).
  END. /* DO ON STOP */
  /* If this is a class file, reset the Class_Type.
   * We will only be able to get the namespace name from the COMPILER handle. 
   * But set this to something that is not ?, so we know it is a class. 
   * The later compilation (RunFile()) will set it correctly.
   * For non-.cls files, this should be ?.
   */
  Edit_Buffer.Class_Type = (IF FILE_Ext = ".cls" THEN "" ELSE ?).

END PROCEDURE.  /* BufRename */


PROCEDURE MakeCurrent .
  /*---------------------------------------------------------------------
     Makes a buffer the current buffer for p_Window and
     Assigns a title to the window. 
  ---------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_Window AS WIDGET-HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO.
  
  DEFINE VAR Temp_Var AS LOGICAL NO-UNDO.
  DEFINE VAR hTemp    AS HANDLE  NO-UNDO.

  FIND FIRST Edit_Buffer WHERE Edit_Buffer.hBuffer = p_Buffer.
  RUN WinSetTitle( INPUT p_Window , INPUT Edit_Buffer.hBuffer:PRIVATE-DATA ) .

  &IF DEFINED(ED_POPUP) &THEN
  /* Assign popup menu to current buffer. */
  ASSIGN hTemp               = MENU mnu_EdPopup:OWNER
         hTemp:POPUP-MENU    = ? NO-ERROR.
  ASSIGN p_Buffer:POPUP-MENU = MENU mnu_EdPopup:HANDLE.
  &ENDIF
  
  p_Buffer:VISIBLE = TRUE.

  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  Temp_Var = p_Buffer:MOVE-TO-TOP().
  &ENDIF

  APPLY "ENTRY" TO p_Buffer.

  /* Updating ProEditor provides calls to _adeevnt.p with
     the correct current buffer handle. */
  ASSIGN ProEditor = p_Buffer.

END PROCEDURE.  /* MakeCurrent */



PROCEDURE CreateUntitledBufName .
  /*---------------------------------------------------------------------
  ---------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER p_Untitled_BufName AS CHAR NO-UNDO.
  
  Num_Untitled_Buffers = Num_Untitled_Buffers + 1.
  p_Untitled_BufName = Untitled +
  			TRIM( STRING( Num_Untitled_Buffers , ">>9" ) ).
  			  	
END PROCEDURE.  /* CreateUntitledBufName */



PROCEDURE CloseWindow.
  /*---------------------------------------------------------------------
      Closes an editor window and deletes it from window list.
      Under GUI, ensures that any open Procedure Windows are also
      closed.
  ---------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER p_Window AS WIDGET-HANDLE NO-UNDO.
   
  DEFINE VARIABLE OK_Close AS LOGICAL NO-UNDO.

  /* Perform a close all for any open Procedure Windows belonging to
     the Procedure Editor. Not checked if TTY.
  */
  IF SESSION:WINDOW-SYSTEM <> "TTY" THEN
  DO ON STOP UNDO, LEAVE:
    RUN adecomm/_pwexit.p ( INPUT  "_edit.p":U /* PW Parent ID */ ,
                            OUTPUT OK_Close ).
  END.
  
  /*
  ** Changed by R. Ryan to fix bug 94-08-30-017. This fix allows the procedure
  ** windows cancel on exit to act like the close buffer's cancel.
  */
  IF OK_Close = ? THEN
  DO:
    Saved_File = ?.
    RETURN.
  END.
  
  ELSE
    ASSIGN OK_Close = TRUE.

  /* Cancel the close event? */
  IF OK_Close <> TRUE THEN RETURN.

  /* Saved_File tells us if user cancelled the close window because
     buffers were opened with unsaved changes. */
  RUN CloseAllBuffers( INPUT-OUTPUT p_Window ).
  IF Saved_File = ? THEN RETURN.

  /* --- Begin SCM changes --- */
  /* Do custom shutdown -- this is generally a no-op, but it can
     be used to cleanup custom modifications */
  DEFINE VARIABLE scm_ok  AS LOGICAL NO-UNDO.
  RUN adecomm/_adeevnt.p 
      ( INPUT "Editor",
        INPUT "SHUTDOWN", INPUT STRING(THIS-PROCEDURE), STRING(p_Window),
        OUTPUT scm_ok ).
  /* --- End SCM changes ----- */

  /*---------------------------------------------------------------------
     The following cleanup is only necessary for GUI platforms.
     Under TTY, editor window is DEFAULT-WINDOW.
  ---------------------------------------------------------------------*/
  IF SESSION:WINDOW-SYSTEM <> "TTY"
  THEN DO: 
    /* HIDE p_Window  - done in closeallbuffers too.                    */  
    p_Window:VISIBLE = NO . 
    p_Window:SENSITIVE = NO .

  
    /* Later, put in code here to go to next open window, if any.       */
    /*---------------------------------------------------------------------
       All buffers have been deleted at this point, so delete window.
    ---------------------------------------------------------------------*/
    RUN DeleteWindow( INPUT-OUTPUT p_Window ).
  END. /* TTY */
  
END PROCEDURE.  /* CloseWindow */


PROCEDURE CloseAllBuffers .
  /*---------------------------------------------------------------------
      Closes all buffers for specified window and deletes each buffer
      from the buffer list.
  ---------------------------------------------------------------------*/
  
  DEFINE INPUT-OUTPUT PARAMETER p_Window AS WIDGET-HANDLE NO-UNDO.
  
  DEFINE VARIABLE Mod_List  AS CHAR NO-UNDO .
  DEFINE VARIABLE Save_List AS CHAR NO-UNDO .
  DEFINE VARIABLE vBuffer   AS WIDGET-HANDLE NO-UNDO.
  DEFINE VARIABLE SA_OK     AS LOGICAL NO-UNDO .
  DEFINE VARIABLE SA_Filename AS CHAR NO-UNDO .
  DEFINE VARIABLE Old_Filename AS CHAR NO-UNDO .
  DEFINE VARIABLE Buf_Modified AS LOGICAL NO-UNDO.

  /* --- Begin SCM changes --- */
  DEFINE VAR scm_ok       AS LOGICAL NO-UNDO.
  DEFINE VAR scm_context  AS CHAR    NO-UNDO.
  DEFINE VAR scm_filename AS CHAR    NO-UNDO.
  /* --- End SCM changes ----- */

  /* Editor System Flag for Exiting. */
  Saved_File = Sys_Options.Exit_Warning .  
 
  IF ( Sys_Options.Exit_Warning = YES )
  THEN DO:
  /* Build comma-delimited list of modified buffers. */
  FOR EACH Edit_Buffer WHERE Edit_Buffer.hWindow = p_Window:
    RUN BufQMod ( Edit_Buffer.hBuffer , OUTPUT Buf_Modified ) . 
    IF ( Buf_Modified = FALSE ) THEN NEXT.
    Mod_List = Mod_List + Edit_Buffer.hBuffer:PRIVATE-DATA + ",".
  END.
  /* Trim-off trailing comma left over from building list. */ 
  Mod_List = IF Mod_List <> ""
  		THEN SUBSTRING( Mod_List , 1 , LENGTH( Mod_List ) - 1 )
  		ELSE "".

  IF NUM-ENTRIES( Mod_List ) <> 0
  THEN DO:
    Save_List = Mod_List.
    MESSAGE "You have buffers with changes that have not been saved." SKIP(1)
	    "Save changes before exiting?"
	    VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO-CANCEL
                    UPDATE Saved_File .
    IF ( Saved_File = ? ) THEN RETURN .
    IF ( Saved_File = YES )
    THEN DO:
      /* Display Save Buffers with Changes dialog. */
      RUN adeedit/_dlgsbuf.p
          ( p_Window , "Save Buffers with Changes" , Mod_List , 
            OUTPUT Save_List ) .

      IF ( Save_List = ? )   
      THEN DO: 		   /* User pressed Cancel.                */
        Saved_File = ?.    /* Tells WAIT-FOR user pressed Cancel. */
        RETURN .
      END.

      IF Saved_File = YES
      THEN DO:
        FOR EACH Edit_Buffer WHERE Edit_Buffer.hWindow = p_Window:

          IF LOOKUP( Edit_Buffer.hBuffer:PRIVATE-DATA , Save_List ) = 0
          THEN NEXT.
          
          RUN SaveFile (Edit_Buffer.hBuffer).
          IF (RETURN-VALUE = "_CANCEL":U)
          THEN DO:
              ASSIGN SA_OK = YES.
              MESSAGE "Save cancelled. Continue Exit?"
                      VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO
                              UPDATE SA_OK .
              IF ( SA_OK = YES ) THEN NEXT.
              ASSIGN Saved_File = ?. /* System var - ? means cancel Exit. */
              RETURN.
          END.
        END.  /* FOR EACH */
      END.  /* IF Saved_File = YES */
    END.  /* IF Saved_File = YES */
  END. /* Mod Buffers */
  END. /* Exit_Warning = Yes */
  
  /* Now delete the buffers.  We'll hide the window first. */
  ASSIGN p_Window:VISIBLE = FALSE.
  ASSIGN Sys_Options.BufList = "".  /* Always clear out buf list. */
  FOR EACH Edit_Buffer WHERE Edit_Buffer.hWindow = p_Window:
      vBuffer = Edit_Buffer.hBuffer.

      /* --- Begin SCM changes --- */
      /* Check with source code control programs and see if we really should
       * close the file.  [Save the context and file name so that we can
       * report the event after the file has closed.]
       */
      ASSIGN scm_context  = STRING(vBuffer)
             scm_filename = vBuffer:PRIVATE-DATA.
      RUN adecomm/_adeevnt.p 
             (INPUT "Editor",
              INPUT "Before-Close", INPUT scm_context, INPUT scm_filename,
              OUTPUT scm_ok).
              
      IF NOT scm_ok THEN
      DO:
          /* If close is cancelled by SCM, make that buffer current. */
          ASSIGN ProEditor = vBuffer
                 File_Name = ProEditor:PRIVATE-DATA .
          RUN MakeCurrent( INPUT win_ProEdit, INPUT ProEditor ) .

          /* Under Character Progress, if we don't assign ? and then reassign
             mnb_Proedit, Progress won't redisplay the menubar.
          */
          IF SESSION:DISPLAY-TYPE = "TTY" THEN
              ASSIGN p_Window:MENUBAR = ?
                     p_Window:MENUBAR = MENU mnb_ProEdit:HANDLE .

          ASSIGN p_Window:VISIBLE = TRUE
                 Saved_File       = ?.   /* System var - ? means cancel Exit. */
          RETURN.
      END.
      /* --- End SCM changes ----- */

      IF ( Sys_Options.Save_BufList = YES ) AND 
	 ( NOT Edit_Buffer.hBuffer:PRIVATE-DATA BEGINS Untitled ) THEN
      DO:
        Sys_Options.BufList = IF ( Sys_Options.BufList <> "" )
        			THEN ( Sys_Options.BufList + "," +
        			       Edit_Buffer.hBuffer:PRIVATE-DATA )
        			ELSE Edit_Buffer.hBuffer:PRIVATE-DATA .
      END.
      
      RUN DeleteBuffer( INPUT-OUTPUT vBuffer ).

      /* --- Begin SCM changes --- */
      RUN adecomm/_adeevnt.p 
          (INPUT "Editor",
           INPUT "Close", INPUT scm_context, INPUT scm_filename, 
           OUTPUT scm_ok).
      /* --- Begin SCM changes --- */

  END.
  
  DO ON ERROR UNDO, LEAVE:
    /* Be certain to reset to default Progress Environment File. */
    USE "" NO-ERROR.
    /* Always save buf list. */
    RUN adecomm/_kvlist.p ( INPUT "PUT" ,
                          INPUT KeyValue_Section ,
                          INPUT "BufList",
                          INPUT-OUTPUT Sys_Options.BufList ).
  END.                          
 
END PROCEDURE.  /* CloseAllBuffers */  


    

PROCEDURE SaveBuffer .
  /*---------------------------------------------------------
     Save contents of current Buffer in buffer list for 
     this window. 
  ---------------------------------------------------------*/
 
  DEFINE INPUT  PARAMETER p_Buffer     AS WIDGET-HANDLE NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Saved_File AS LOGICAL       NO-UNDO.

  DEFINE BUFFER tEdit_Buffer FOR Edit_Buffer.
  DEFINE VAR Valid_BufName AS LOGICAL NO-UNDO.
  /* --- Begin SCM changes --- */
  DEFINE VAR scm_ok        AS LOGICAL NO-UNDO.
  /* --- End SCM changes ----- */


/* Uncommenting this code will warn user before saving an empty buffer.
  DEFINE VAR Save_Empty  AS LOGICAL NO-UNDO.
  
  IF p_Buffer:EMPTY
  THEN DO:
      Save_Empty = YES.
      MESSAGE p_Buffer:PRIVATE-DATA SKIP
        "This buffer is empty.  Save it anyways?" 
        VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO
                UPDATE Save_Empty.
      ASSIGN p_Saved_File = Save_Empty .
      IF ( Save_Empty = NO ) THEN RETURN.
  END.
*/

  RUN BufValidName ( INPUT p_Buffer , INPUT p_Buffer:PRIVATE-DATA ,
                     OUTPUT Valid_BufName ) .
  IF NOT Valid_BufName THEN RETURN.


  /* --- Begin SCM changes --- */
  RUN adecomm/_adeevnt.p 
      ( INPUT "Editor",
        INPUT "Before-Save", INPUT STRING(p_Buffer), INPUT p_Buffer:PRIVATE-DATA,
        OUTPUT p_Saved_File).
  IF NOT p_Saved_File THEN RETURN.
  /* --- End SCM changes ----- */


  ASSIGN p_Saved_File = p_Buffer:SAVE-FILE( p_Buffer:PRIVATE-DATA ) NO-ERROR .

  IF ( p_Saved_File = FALSE )
  THEN DO:
      MESSAGE p_Buffer:PRIVATE-DATA SKIP
        "Cannot save to this file."  SKIP(1)
        "File is read-only or the path specified" SKIP
        "is invalid. Use a different filename."
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.

  END.
  ELSE DO:
      FIND FIRST tEdit_Buffer WHERE tEdit_Buffer.hBuffer = p_Buffer.
      ASSIGN
          FILE-INFO:FILENAME     = p_Buffer:PRIVATE-DATA
          tEdit_Buffer.File_Name = FILE-INFO:FULL-PATHNAME
          .

      /* adecomm/peditor.i */
      RUN SetEdBufType (INPUT p_Buffer, INPUT p_Buffer:PRIVATE-DATA).

      /* Reset the EDIT-CAN-UNDO attribute-GUI only. */
      ASSIGN p_Buffer:EDIT-CAN-UNDO = FALSE WHEN SESSION:WINDOW-SYSTEM <> "TTY".

      /* --- Begin SCM changes --- */
      RUN adecomm/_adeevnt.p 
          ( INPUT "Editor",
            INPUT "Save", INPUT STRING(p_Buffer), INPUT p_Buffer:PRIVATE-DATA,
            OUTPUT scm_ok ).
      /* --- End SCM changes ----- */
  END.
        
END PROCEDURE.  /* SaveBuffer */



PROCEDURE DeleteWindow .

  DEFINE INPUT-OUTPUT PARAMETER p_Window AS WIDGET-HANDLE NO-UNDO.
  
  FIND FIRST Edit_Window WHERE Edit_Window.hWindow = p_Window.
  DELETE Edit_Window.
  DELETE WIDGET p_Window.
  
END PROCEDURE.  /* DeleteWindow */



PROCEDURE DeleteBuffer .

  DEFINE INPUT-OUTPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO.

  FIND FIRST Edit_Buffer WHERE Edit_Buffer.hBuffer = p_Buffer.
  p_Buffer:VISIBLE = FALSE.
  /* if this file has a Class_TmpDir, remove this directory */
  /* TO DO: CHECK IF THIS COULD ACCIDENTALLY DELETE A VALID DIR */
  IF (Edit_Buffer.Class_TmpDir <> ?) THEN
      OS-DELETE VALUE(Edit_Buffer.Class_TmpDir) RECURSIVE.
  DELETE Edit_Buffer.
  DELETE WIDGET p_Buffer.
  
END PROCEDURE.  /* DeleteBuffer */


PROCEDURE NumBuffers .
  /*------------------------------------------------------------- 
     Returns the number of open buffers for a window.
  ------------------------------------------------------------- */

  DEFINE INPUT  PARAMETER p_Window       AS WIDGET-HANDLE NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Buffers_Open AS INTEGER NO-UNDO.

  p_Buffers_Open = 0.
  FOR EACH Edit_Buffer WHERE Edit_Buffer.hWindow = p_Window:
    p_Buffers_Open =  p_Buffers_Open + 1.
  END.
   
END PROCEDURE.  /* NumBuffers */


PROCEDURE NextBuffer .

  /* More than the current buffer open? */
  FIND FIRST Edit_Buffer WHERE Edit_Buffer.hWindow = win_ProEdit AND
                               Edit_Buffer.hBuffer <> ProEditor
                         NO-ERROR.
  IF NOT AVAILABLE Edit_Buffer THEN
  DO:
    MESSAGE "No other buffers open."
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    RETURN.
  END.
  FIND FIRST Edit_Buffer WHERE Edit_Buffer.hWindow = win_ProEdit AND
                               Edit_Buffer.hBuffer = ProEditor.
  FIND NEXT Edit_Buffer WHERE Edit_Buffer.hWindow = win_ProEdit AND
                              Edit_Buffer.hBuffer <> ProEditor NO-ERROR.
  IF NOT AVAILABLE Edit_Buffer THEN
    FIND FIRST Edit_Buffer WHERE Edit_Buffer.hWindow = win_ProEdit AND
                                 Edit_Buffer.hBuffer <> ProEditor.

  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  /* To avoid flashing in tty, hide current buffer. */
  ASSIGN ProEditor:VISIBLE = FALSE.
  &ENDIF

  ProEditor = Edit_Buffer.hBuffer.
  RUN MakeCurrent( INPUT win_ProEdit, INPUT ProEditor).
    
END PROCEDURE.  /* NextBuffer */



PROCEDURE PrevBuffer .
  
  /* More than the current buffer open? */
  FIND FIRST Edit_Buffer WHERE Edit_Buffer.hWindow = win_ProEdit AND
                               Edit_Buffer.hBuffer <> ProEditor
                         NO-ERROR.
  IF NOT AVAILABLE Edit_Buffer THEN
  DO:
    MESSAGE "No other buffers open."
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    RETURN.
  END.
  
  FIND FIRST Edit_Buffer WHERE Edit_Buffer.hWindow = win_ProEdit AND
                               Edit_Buffer.hBuffer = ProEditor.
  FIND PREV Edit_Buffer WHERE Edit_Buffer.hWindow = win_ProEdit AND
                              Edit_Buffer.hBuffer <> ProEditor NO-ERROR.
  IF NOT AVAILABLE Edit_Buffer THEN
    FIND LAST Edit_Buffer WHERE Edit_Buffer.hWindow = win_ProEdit AND
                                Edit_Buffer.hBuffer <> ProEditor.
    
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  /* To avoid flashing in tty, hide current buffer. */
  ASSIGN ProEditor:VISIBLE = FALSE.
  &ENDIF

  ProEditor = Edit_Buffer.hBuffer.
  RUN MakeCurrent( INPUT win_ProEdit, INPUT ProEditor).
  
END PROCEDURE.  /* PrevBuffer */


PROCEDURE BufQMod .
  /* Returns TRUE if buffer is a modified buffer; FALSE if not. */
    DEFINE INPUT  PARAMETER p_Buffer   AS WIDGET-HANDLE      NO-UNDO.
    DEFINE OUTPUT PARAMETER p_Modified AS LOGICAL INIT FALSE NO-UNDO.
    
    DEFINE VARIABLE Buffer_Code AS CHAR NO-UNDO.

    /* If the buffer being checked is the current buffer and its a QUIT
       buffer, then we don't consider it a modified buffer. */
    IF ( p_Buffer = ProEditor )
       AND Quit_Pending
    THEN p_Modified = FALSE.
    ELSE IF ( p_Buffer:MODIFIED = NO ) OR 
       ( p_Buffer:PRIVATE-DATA BEGINS Untitled AND
         p_Buffer:EMPTY ) 
    THEN p_Modified = FALSE.
    ELSE p_Modified = TRUE.

END PROCEDURE. /* BufQMod */


PROCEDURE BufferList .
  
  DEFINE INPUT PARAMETER p_Window AS WIDGET-HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO.
  
  DEFINE VARIABLE Buffer_Handle_List AS CHARACTER INIT "".
  DEFINE VARIABLE Buffer_File_Name_List AS CHARACTER INIT "".
  DEFINE VARIABLE Buffer_List AS CHARACTER 
    LABEL "Select &Buffer:" 
    VIEW-AS SELECTION-LIST SINGLE SIZE 60 BY 6 
            SCROLLBAR-V SCROLLBAR-H {&STDPH_FIX}.
  DEFINE VARIABLE Buffer_Handle AS WIDGET-HANDLE NO-UNDO.
  DEFINE VARIABLE Num_Open AS INTEGER NO-UNDO.  
  DEFINE VARIABLE Buf_Modified AS LOGICAL NO-UNDO .
  DEFINE VARIABLE Buffer_Selected AS CHAR NO-UNDO .
  DEFINE VARIABLE Buf_Mod_Marker  AS CHAR INIT "*  " NO-UNDO .
  DEFINE VARIABLE Buf_UMod_Marker AS CHAR INIT "   " NO-UNDO.
  DEFINE VARIABLE List_Handle     AS WIDGET-HANDLE NO-UNDO.
  DEFINE VARIABLE Temp_Logical AS LOGICAL NO-UNDO .

  DEFINE BUTTON b_OK       LABEL "OK"     {&STDPH_OKBTN} AUTO-GO .
  DEFINE BUTTON b_Cancel   LABEL "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
  DEFINE BUTTON b_Save     LABEL "&Save"  {&STDPH_OKBTN} .
  DEFINE BUTTON b_Help     LABEL "&Help"  {&STDPH_OKBTN}  .
  
  /* Dialog Button Box */
  &IF {&OKBOX} &THEN
  DEFINE RECTANGLE BL_Btn_Box    {&STDPH_OKBOX}.
  &ENDIF

  /* Dialog Box */    
  FORM
    SKIP( {&TFM_WID} )
    "Select Buffer:" {&AT_OKBOX} VIEW-AS TEXT
    SKIP( {&VM_WID} )
    Buffer_List  {&AT_OKBOX}
    SKIP( {&VM_WID} )
    "*=Modified" {&AT_OKBOX} VIEW-AS TEXT
    { adecomm/okform.i
        &BOX    ="BL_Btn_Box"
        &OK     ="b_OK"
        &CANCEL ="b_Cancel"
        &OTHER  ="SPACE( {&HM_BTNG} ) b_Save"
        &HELP   ="b_Help" 
    }
    WITH FRAME Buffer_List
         VIEW-AS DIALOG-BOX TITLE "Buffer List" NO-LABELS
	 DEFAULT-BUTTON b_OK
         CANCEL-BUTTON  b_Cancel .
    { adecomm/okrun.i
        &FRAME  = "FRAME Buffer_List"
        &BOX    = "BL_Btn_Box"
        &OK     = "b_OK"
        &OTHER  = "b_Save"
        &HELP   = "b_Help"
    }
 
  ON HELP OF FRAME Buffer_List ANYWHERE
    RUN adeedit/_edithlp.p ( INPUT "Buffer_List_Dialog_Box" ).
  ON CHOOSE OF b_Help IN FRAME Buffer_List 
    RUN adeedit/_edithlp.p ( INPUT "Buffer_List_Dialog_Box" ).
 
  ON GO OF FRAME Buffer_List OR
     DEFAULT-ACTION OF Buffer_List 
                       IN FRAME Buffer_List
  DO:
    User_Selection = "EDIT".
  END.
 
  ON CHOOSE OF b_Save IN FRAME Buffer_List
  DO:
    DEFINE VAR Buffer_Name AS CHAR NO-UNDO.

    Buffer_Name = SUBSTRING(Buffer_List:SCREEN-VALUE IN FRAME Buffer_List , 
			  LENGTH( Buf_Mod_Marker ) + 1 ) .

    FIND FIRST Edit_Buffer WHERE Edit_Buffer.hWindow = p_Window AND
			   Edit_Buffer.Buffer_Name = Buffer_Name.
    User_Selection = "SAVE".
    RUN SaveFile ( INPUT Edit_Buffer.hBuffer ).
    IF ( Edit_Buffer.hBuffer:MODIFIED = FALSE )
    THEN DO:

      Buffer_Name = Buf_UMod_Marker + Edit_Buffer.Buffer_Name.
      Temp_Logical = Buffer_List:REPLACE( Buffer_Name, 
                         Buffer_List:SCREEN-VALUE IN FRAME Buffer_List )
                         IN FRAME Buffer_List.
      Buffer_List:SCREEN-VALUE IN FRAME Buffer_List = Buffer_Name.
    END.
    APPLY "ENTRY" TO SELF.
  END.

  ON WINDOW-CLOSE OF FRAME Buffer_List OR
     CHOOSE OF b_Cancel IN FRAME Buffer_List
  DO:
    User_Selection = "CANCEL".
  END.
  
  RUN WinStatusMsg (win_ProEdit , "MT_INPUT" , "" , "WAIT").
    
  /* Build Buffer List for window's buffers with files open in them. */
  Buffer_File_Name_List = "".
  FOR EACH Edit_Buffer WHERE Edit_Buffer.hWindow = p_Window :
    RUN BufQMod ( Edit_Buffer.hBuffer , OUTPUT Buf_Modified ).
    
    IF ( Buffer_File_Name_List <> "" ) 
    THEN
      Buffer_File_Name_List = Buffer_File_Name_List + "," +
				IF Buf_Modified 
				THEN Buf_Mod_Marker  /* Add MOD Marker. */
				ELSE Buf_UMod_Marker.
    ELSE
      Buffer_File_Name_List = IF Buf_Modified 
				THEN Buf_Mod_Marker  /* Add MOD Marker. */
				ELSE Buf_UMod_Marker.
    Buffer_File_Name_List = Buffer_File_Name_list + 
				Edit_Buffer.hBuffer:PRIVATE-DATA.
  END.
  
  Buffer_List:LIST-ITEMS IN FRAME Buffer_List = Buffer_File_Name_List .
  RUN BufQMod( p_Buffer , OUTPUT Buf_Modified ).
  Buffer_List:SCREEN-VALUE IN FRAME Buffer_List = IF Buf_Modified
						THEN Buf_Mod_Marker + 
						     p_Buffer:PRIVATE-DATA
						ELSE Buf_UMod_Marker +
						     p_Buffer:PRIVATE-DATA.
  ASSIGN List_Handle = Buffer_List:HANDLE IN FRAME Buffer_List.

  RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .
  ENABLE ALL EXCEPT b_Help WITH FRAME Buffer_List.
  ENABLE b_Help {&WHEN_HELP} WITH FRAME Buffer_List.
  
  User_Selection = "CANCEL".
  REPEAT ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE:  
    SET Buffer_List
      GO-ON ( GO,WINDOW-CLOSE
              DEFAULT-ACTION OF Buffer_List )
      WITH FRAME Buffer_List.
    LEAVE.
  END.
 
 /* debug leave these lines here for now.  */
  HIDE FRAME Buffer_List NO-PAUSE.
  DISABLE ALL WITH FRAME Buffer_List.

  IF User_Selection <> "CANCEL" THEN
  DO:
    IF User_Selection = "Edit" THEN
    DO:
      /* Strip off leading MODIFIED MARKER. */
      Buffer_Selected = SUBSTRING(Buffer_List:SCREEN-VALUE 
						IN FRAME Buffer_List , 
				  LENGTH( Buf_Mod_Marker ) + 1 ) .

      FIND FIRST Edit_Buffer WHERE Edit_Buffer.hWindow = p_Window AND
				   Edit_Buffer.Buffer_Name = Buffer_Selected.


      &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
      /* To avoid flashing in tty, hide current buffer. */
      ASSIGN p_Buffer:VISIBLE = FALSE.
      &ENDIF

      p_Buffer = Edit_Buffer.hBuffer.
      RUN MakeCurrent ( INPUT p_Window, INPUT p_Buffer ).
      ProEditor = p_Buffer. 
    END.
    ELSE APPLY "ENTRY" TO p_Buffer.
  END.

END PROCEDURE.  /* BufferList */


PROCEDURE BufChangeFont .
  /*-------------------------------------------------------------------------
     Presents the Buffer Font dialog, which allows the user to choose a font
     for an editor buffer.
  -------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO.
    
    DEFINE VAR Pressed_OK AS LOGICAL NO-UNDO.

    DO ON STOP UNDO, LEAVE:
        FIND FIRST Edit_Buffer WHERE Edit_Buffer.hBuffer = p_Buffer.
        ASSIGN Edit_Buffer.Font_Num = p_Buffer:FONT .
        RUN adecomm/_chsfont.p ( INPUT "Buffer Font" , 
                                 INPUT ?,  /* Use System Default Font */
    			         INPUT-OUTPUT Edit_Buffer.Font_Num ,
                                 OUTPUT Pressed_OK ) .
        IF ( Pressed_OK = TRUE ) AND 
           ( p_Buffer:FONT <> Edit_Buffer.Font_Num )
        THEN p_Buffer:FONT = Edit_Buffer.Font_Num .
    END.
END PROCEDURE.

PROCEDURE DlgBufSettings  .
  /*--------------------------------------------------------------------------
     The Buffer Information Dialog permits a user to view various attributes 
     specific to a buffer.
  --------------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO.
  
  DEFINE VAR EFile_Name   LIKE Edit_Buffer.File_Name   NO-UNDO .
  DEFINE VAR Valid_BufName AS LOGICAL NO-UNDO .
  
  DEFINE VAR File_Access  AS CHAR    LABEL "File Access" FORMAT "x(1)".
  DEFINE VAR Read_Access  AS LOGICAL LABEL "Read"  VIEW-AS TOGGLE-BOX.
  DEFINE VAR Write_Access AS LOGICAL LABEL "Write" VIEW-AS TOGGLE-BOX.
  DEFINE VAR l_Length     AS INTEGER NO-UNDO.
  DEFINE VAR short_name    AS CHAR    NO-UNDO.
  
  DEFINE BUTTON btn_OK   LABEL "OK"    {&STDPH_OKBTN} AUTO-GO .
  DEFINE BUTTON btn_HELP LABEL "&Help" {&STDPH_OKBTN} .

  /* Dialog Button Box */
  &IF {&OKBOX} &THEN
  DEFINE RECTANGLE BI_Btn_Box    {&STDPH_OKBOX}.
  &ENDIF

  /* Dialog Box */    
    
  FORM
    SKIP( {&TFM_WID} )
    EFile_Name    COLON 13 
    SKIP( {&VM_WID} )
    File_Access   COLON 13 Read_Access Write_Access
    SKIP( {&VM_WID} )
    Edit_Buffer.Cursor_Line COLON 13
    Edit_Buffer.Length      COLON 42
    SKIP( {&VM_WID} )
    Edit_Buffer.Cursor_Char COLON 13
    Edit_Buffer.Modified  FORMAT "Yes /No "  COLON 42
    { adecomm/okform.i
        &BOX    ="BI_Btn_Box"
        &OK     ="btn_OK"
        &CANCEL =" "
        &OTHER  =" "
        &HELP   ="btn_Help" 
    }
    WITH FRAME Dlg_BufSettings 
         VIEW-AS DIALOG-BOX TITLE "Buffer Information" USE-TEXT
         SIDE-LABELS OVERLAY  
         DEFAULT-BUTTON btn_OK.
    { adecomm/okrun.i
        &FRAME  = "FRAME Dlg_BufSettings"
        &BOX    = "BI_Btn_Box"
        &OK     = "btn_OK"
        &HELP   = "btn_Help"
    }

  /* The Read and Write toggles are display fields only. However, when
     displayed as disabled fields, the toggle labels are grayed
     out and do not display well. So we enable them. Since the dialog is
     for display-only, we prevent the user from changing the toggle values
     using this trigger.
  */
  ON VALUE-CHANGED OF Read_Access IN FRAME  Dlg_BufSettings
  OR VALUE-CHANGED OF Write_Access IN FRAME  Dlg_BufSettings
  DO:
    ASSIGN SELF:SCREEN-VALUE = IF SELF:SCREEN-VALUE = "yes":U
                               THEN "no" ELSE "yes".
    RETURN NO-APPLY.
  END.

  ON HELP OF FRAME Dlg_BufSettings ANYWHERE
    RUN adeedit/_edithlp.p ( INPUT "Buffer_Settings_Dialog_Box" ).
  ON CHOOSE OF btn_Help IN FRAME Dlg_BufSettings 
    RUN adeedit/_edithlp.p ( INPUT "Buffer_Settings_Dialog_Box" ).

  DLG_BUFSET :
  DO ON STOP   UNDO DLG_BUFSET , LEAVE DLG_BUFSET 
     ON ERROR  UNDO DLG_BUFSET , LEAVE DLG_BUFSET 
     ON ENDKEY UNDO DLG_BUFSET , LEAVE DLG_BUFSET
     WITH FRAME Dlg_BufSettings:
  
    RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "WAIT" ) .  
    
    /* Calculate the buffer size based on what the OS thinks it is. Avoids
       differences and speed issues with the <editor>:LENGTH attribute on
       different platforms.
    */
    IF NOT p_Buffer:EMPTY THEN
    RUN adecomm/_getflen.p
                (INPUT  p_Buffer     /* Editor handle.   */ ,
                 INPUT  ""           /* OS file.         */ ,
                 OUTPUT l_Length     /* Length in bytes  */ ).

    /* We don't need p_Window because buffer handles are unique system-wide. */
    FIND FIRST Edit_Buffer WHERE Edit_Buffer.hBuffer = p_Buffer.
    ASSIGN  Edit_Buffer.Cursor_Line = p_Buffer:CURSOR-LINE
            Edit_Buffer.Cursor_Char = p_Buffer:CURSOR-CHAR
            Edit_Buffer.Font_Num    = p_Buffer:FONT
            Edit_Buffer.Length      = l_Length
            Edit_Buffer.Modified    = p_Buffer:MODIFIED
            EFile_Name              = (IF Edit_Buffer.File_Name <> ?
                                       THEN Edit_Buffer.File_Name
                                       ELSE "<No File>")
    . /* END ASSIGN */

    /* adecomm/peditor.i */
    RUN SetEdBufType (INPUT p_Buffer, INPUT Edit_Buffer.Buffer_Name).
    
    /* Shorten display name. If we do, set tooltip to long name. */
    RUN adecomm/_ossfnam.p
        (INPUT EFile_Name,
         INPUT EFile_Name:WIDTH IN FRAME Dlg_BufSettings,
         INPUT EFile_Name:FONT IN FRAME Dlg_BufSettings,
         OUTPUT short_name).
    IF EFile_Name <> short_name THEN
        ASSIGN EFile_Name:TOOLTIP = Efile_Name
               EFile_Name         = short_name.

    IF ( Edit_Buffer.File_Name <> ? ) /* Not Untitled */
    THEN DO:
        ASSIGN FILE-INFO:FILENAME = Edit_Buffer.File_Name
               Read_Access  = ( INDEX( FILE-INFO:FILE-TYPE , "R" ) > 0 )
               Write_Access = ( INDEX( FILE-INFO:FILE-TYPE , "W" ) > 0 )
        .
    END.
    
    RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .
    DISPLAY EFile_Name Read_Access Write_Access
            Edit_Buffer.Cursor_Line Edit_Buffer.Cursor_Char
            Edit_Buffer.Length Edit_Buffer.Modified
            WITH FRAME Dlg_BufSettings .

    IF (EFile_Name <> "<No File>") AND (SESSION:WINDOW-SYSTEM <> "TTY":U) THEN
      ENABLE Read_Access Write_Access WITH FRAME Dlg_BufSettings.

    UPDATE btn_OK btn_Help {&WHEN_HELP}
           GO-ON ( GO,WINDOW-CLOSE )
	   WITH FRAME Dlg_BufSettings .

  END.  /* DLG_BUFSET DO: */
  RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .
         
END PROCEDURE.  /* DlgBufSettings */
 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
  pcompile.i
  Compile Commands-Related Procedures for Editor 
--------------------------------------------------------------------------*/


PROCEDURE RunFile.
/*--------------------------------------------------------------------------
    Purpose:    Executes the RUN command, compiling and executing the code
                in the edit buffer.

    Run Syntax: RUN RunFile ( INPUT p_Mode ) .

    Parameters:
        Input Parameters
            p_Mode (CHAR)
                RUN          :  Compile and run current buffer. (DEFAULT)
                CHECK-SYNTAX :  Compile only (check syntax) the current buffer.
                DEBUG        :  Compile debug the current buffer.
    Description:

    Notes:
---------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_Mode  AS CHAR    INIT "RUN" NO-UNDO .

  DEFINE VARIABLE Buffer_Modified  AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE rf_Action        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Temp_Logical     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE Return_Status    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE Error_File_Name  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Compiler_Error   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE Compiler_Stopped AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE Compiler_ClassType AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE Read_OK          AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE wfrun            AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE Save_OK          AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE isClass          AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE setClass         AS LOGICAL   INIT FALSE NO-UNDO.
  DEFINE VARIABLE isClassError     AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE isWrongClass     AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE ClassType        AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE ipos             AS INTEGER     NO-UNDO.
  DEFINE VARIABLE Run_Filename     AS CHARACTER   INIT ? NO-UNDO.
  DEFINE VARIABLE lOK              AS LOGICAL     NO-UNDO.

  /* --- Begin SCM changes --- */
  DEFINE VARIABLE scm_ok             AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE scm_action         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE scm_context        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE scm_filename       AS CHARACTER NO-UNDO.
  /* --- End SCM changes ----- */

  /* We don't need p_Window because buffer handles are unique system-wide. */
  FIND FIRST Edit_Buffer WHERE Edit_Buffer.hBuffer = ProEditor.
  ASSIGN 
      isClass = (IF Edit_Buffer.Class_Type <> ? THEN YES ELSE NO)
      Compile_FileName = Edit_Buffer.Compile_Name
      ClassType = Edit_Buffer.Class_Type.
  
  RunFile_STOP:
  DO ON STOP UNDO RunFile_STOP , RETRY RunFile_STOP:
 
    IF NOT RETRY
    THEN DO:

      Quit_Pending = FALSE .  /* System Var assignment. */
      rf_Action = ( IF p_Mode = "CHECK-SYNTAX" THEN "check"
                    ELSE LC(p_Mode) /* run or debug */ ).

      IF ProEditor:EMPTY
      THEN DO:
        MESSAGE "Nothing in this buffer to " + rf_Action + "."
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        RETURN.
      END.

      IF CAN-DO( "RUN,DEBUG" , p_Mode )
      THEN DO:
          /* Test if just a QUIT statement. If so, execute File->Exit. */
          RUN QuitBuffer ( INPUT ProEditor , OUTPUT Quit_Pending ) .
          IF Quit_Pending THEN
          DO:
              RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) . 
              RUN ExitEditor.
              RETURN.
          END.
      END.


      IF CAN-DO( "RUN,DEBUG" , p_Mode )
      THEN RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , 
                              "Compiling procedure..." , "WAIT" ).
      ELSE RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , 
                              "Checking syntax..." , "WAIT" ).
  
      ASSIGN
        Buffer_Modified = ProEditor:MODIFIED
      . /* END-ASSIGN */
  
    /* SAVE_AND_COMPILE_BLOCK explanation
     * This block was implemented to support OO4GL and .cls files.
     * Background:
     * A piece of OO4GL code MUST meet the following criteria in order 
     * to compile correctly:
     * - its filename MUST have a ".cls" extension
     * - the end of its path MUST match the package declared in the CLASS 
     * e.g. CLASS foo.bar MUST have a pathname foo/bar.cls
     * If the compiler compiles OO4GL syntax in a file without a .cls extension, 
     * it will generate error (12622) for a CLASS and (12623) for an INTERFACE.
     * Also, if the compiler compiles a .cls file, and the pathname does NOT
     * match the package declared in the CLASS, it will generate error (12629),
     * and set the COMPILER:CLASS-TYPE attribute to the name of the declared CLASS
     * (note that the COMPILER:CLASS-TYPE attribute is NOT set unless you 
     * compile a file with a .cls extension).
     * Two other things to consider:
     * - when a user enters text into an untitled edit buffer, there is no way to
     *   tell (without compiling) whether the code contains OO4GL syntax or not.
     * - when a user loads a .cls file, there is no way to know what the 
     *   declared package of the class is (without compiling it).
     * This means that to successfully compile OO4GL code we need to determine
     * that it is OO4GL code first (by compiling), and then determine the
     * correct package (by compiling). This means we might need to save the code
     * up to 3 times with different names and compile up to 3 times in order to
     * CHECK SYNTAX or RUN. Rather than re-write the save and compile code 3 times, 
     * we make up to 3 iterations of the SAVE_AND_COMPILE_BLOCK.
     * 
     * To explain how the SAVE_AND_COMPILE_BLOCK (SACB) works, consider the following
     * situations:
     *
     * - untitled buffer, containing non-OO4GL code
     *   On the first pass through SACB, the buffer is saved to a temp file 
     *   with a non-.cls extension. If it compiles without a (12622) or (12623)
     *   error, then we assume it is NOT a .cls file, and leave SACB.
     *   
     * - untitled buffer, containing OO4GL code
     *   On the first pass through SACB, the buffer is saved to a temp file
     *   with a non-.cls extension. The compiler will return a (12622) or 
     *   (12623) error, which indicates this is OO4GL. We then set isClass to 
     *   indicate it is OO4GL, and force another pass of SACB.
     *   On the second pass of SACB, we know the buffer contains OO4GL, 
     *   but we don't know the correct class name. We change the extension of
     *   the temp file to .cls, and save the buffer to this file. The compile
     *   will then generate a (12629) error, indicating the file has the wrong 
     *   pathname for the declared class. We set the ClassType based on 
     *   COMPILER:CLASS-TYPE, and force another pass of SACB.
     *   On the third pass of SACB, we know the buffer contains OO4GL, 
     *   and we know what the classtype (and hence the pathname) should be.
     *   We then create a temporary directory under the SESSION:TEMP-DIR,
     *   and build a directory path to match the classtype of the class.
     *   We then save the buffer to the file in the temporary directory path.
     *   The compiler will then compile the temp file. At this point, 
     *   we leave SACB, to report the outcome of the compile. However, we save
     *   away the classtype and temp dir name for future use.
     *
     * - buffer loaded from a non-.cls file
     *   When loading the non-.cls file, we know the extension is not .cls,
     *   so this is treated the same as an untitled edit buffer. However, if 
     *   the code contains any OO4GL statements, we will not trap the (12622)
     *   or (12623) errors, since the file is already determined as non-OO4GL 
     *   by its extension. Regardless, we leave the SACB to report the outcome
     *   of the compile.
     *
     * - buffer loaded from a .cls file, never previously compiled
     *   When first loading the file, we know it is a class file by its
     *   .cls extension, so we flag this with a classtype of "", and 
     *   set isClass to true. 
     *   On the first pass of SACB, we have a temp file name with a non-.cls 
     *   extension, so we change the extension to .cls, and save the buffer
     *   to this file. We then compile it, which should give us the (12629)
     *   error, and the classtype in COMPILER:CLASS-TYPE. We then force
     *   another pass of SACB.
     *   On the second pass, we know the classtype, and that the file is a class,
     *   so we create a temp dir, and build the appropriate path beneath it to 
     *   match the classtype. We save the buffer to the .cls file in this 
     *   temp dir, and compile it. We then leave SACB, to report the 
     *   outcome of the compile. However, we save away the classtype and 
     *   temp-dir name for future use.
     *
     * - buffer loaded from a .cls file, previously compiled
     *   From previous compiles, we know that this buffer contains OO4GL,
     *   and we know its clastype and the name of the temp dir we have
     *   determined for it. We can go straight to building the appropriate
     *   dir structure underneath the temp dir, saving the buffer to this file,
     *   and compiling. We then leave SACB to report the outcome of the compile.
     */

      SAVE_AND_COMPILE_BLOCK:
      REPEAT:

          /**** SAVE FILE ****/          
          /* First, get the correct Compile_Filename */

          /* If this is an untitled edit buffer, or not a .cls file*/
          IF (NOT isClass) THEN
              /* save to the default unique filename */
              Compile_Filename = Edit_Buffer.Compile_Name.
          ELSE 
          DO:
              /* this is a .cls file */
              
              /* if this is an untitled edit buffer, or a .cls file we just loaded */
              IF (ClassType = "") THEN
              DO:
                  /* replace .ped with .cls */
                  ipos = R-INDEX(Compile_Filename,".ped").
                  IF ipos > 0 THEN
                      SUBSTRING(Compile_Filename,ipos) = ".cls".
              END.
              ELSE
              DO:
                  /* this is a .cls file we have compiled before. */

                  /* If we don't have a Class_TmpDir, create one */
                  IF (Edit_Buffer.Class_TmpDir = ?) THEN
                      RUN GetUniqueDir(SESSION:TEMP-DIR,"p",?,OUTPUT Edit_Buffer.Class_TmpDir).

                  /* create the directories to store the ClassType
                   * beneath Class_TmpDir */
                  RUN GetClassCompileName(
                      Edit_Buffer.Class_TmpDir,
                      /* TO DO: Check if this is the correct way to get the filename, and "Untitled:" */
                      (IF ProEditor:PRIVATE-DATA BEGINS Untitled THEN ? ELSE ProEditor:PRIVATE-DATA),
                      ClassType,
                      OUTPUT Compile_Filename).
              END.
          END.  /* if isClass */

          /* save the file to the nominated filename */
          Save_OK = ProEditor:SAVE-FILE(Compile_FileName).

          /* adecomm/peditor.i */
          RUN SetEdBufType (INPUT ProEditor, INPUT ProEditor:PRIVATE-DATA).

          IF ( NOT Save_OK )
          THEN DO:
            RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .
            MESSAGE "Unable to create compile file. Compilation cancelled."
              VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            /* if this is a .cls file, we want to remove the 
             * temp dir structure we created */
            IF (isClass AND Edit_Buffer.Class_TmpDir <> ?) THEN
                OS-DELETE RECURSIVE VALUE(Edit_Buffer.Class_TmpDir) .
            RETURN.
          END.
          ProEditor:MODIFIED = Buffer_Modified. /* Reset due to Save-File. */

          IF ( SEARCH( Compile_FileName ) = ? )
          THEN DO:
            RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .

            MESSAGE "Cannot " + rf_Action + ". Unable to find temporary file."
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            /* if this is a .cls file, we want to remove the 
             * temp dir structure we created */
            IF (isClass AND Edit_Buffer.Class_TmpDir <> ?) THEN
                OS-DELETE RECURSIVE VALUE(Edit_Buffer.Class_TmpDir) .
            RETURN.
          END.


          /* NOTE: Now that we have SAVE_AND_COMPILE_BLOCK, this SCM event could 
           * fire up 3 times or one program. However, we cannot really take 
           * it out of the loop, as it sits between the save and compile, 
           * both integral parts of SACB */ 
          /* --- Begin SCM changes --- */
          ASSIGN
              scm_action   = "Before-" + p_Mode  /* RUN, CHECK-SYNTAX, DEBUG */
              scm_context  = STRING( ProEditor )
              scm_filename = ProEditor:PRIVATE-DATA.
          RUN adecomm/_adeevnt.p 
              (INPUT "Editor",
               INPUT scm_action, INPUT scm_context, scm_filename,
               OUTPUT scm_ok ).
          IF NOT scm_ok THEN
          DO:
            RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ).
            RETURN.
          END.
          /* --- End SCM changes ----- */

          /**** COMPILE FILE ****/
          COMPILE_BLOCK:
          REPEAT ON STOP UNDO COMPILE_BLOCK, RETRY COMPILE_BLOCK:
              IF NOT RETRY
              THEN DO:
                  /* Clear out previous compiler messages. */
                  Compiler_Messages:SCREEN-VALUE IN FRAME Compiler-Frame = "" .
                  OUTPUT TO VALUE(Compiler_Message_Log) UNBUFFERED KEEP-MESSAGES.
                  COMPILE VALUE( Compile_FileName ).
              END.
              /* Assign here to avoid problems with session compiles changing the
              COMPILER widget attributes. */
              Compiler_Error   = COMPILER:ERROR .
              Compiler_Stopped = COMPILER:STOPPED.
              Compiler_ClassType = COMPILER:CLASS-TYPE. 
              OUTPUT CLOSE.

              /* .cls support - only if not stopped and there was an error */
              IF (Compiler_Stopped = FALSE AND Compiler_Error = TRUE) THEN
              DO:
                  ASSIGN Read_OK = Compiler_Messages:READ-FILE(Compiler_Message_Log)
                         NO-ERROR.
                  IF (Read_OK) THEN
                  DO:
                      /* look for IS_CLASS_ERROR and IS_INTERFACE_ERROR */
                      isClassError = 
                          INDEX(Compiler_Messages:SCREEN-VALUE,{&IS_CLASS_ERROR}) > 0 OR
                          INDEX(Compiler_Messages:SCREEN-VALUE,{&IS_INTERFACE_ERROR}) > 0.
                      /* look for WRONG_CLASS_TYPE_ERROR or WRONG_INTERFACE_TYPE_ERROR */
                      isWrongClass = 
                          INDEX(Compiler_Messages:SCREEN-VALUE,{&WRONG_CLASS_TYPE_ERROR}) > 0 OR
                          INDEX(Compiler_Messages:SCREEN-VALUE,{&WRONG_INTERFACE_TYPE_ERROR}) > 0.
                      /* if this is an untitled edit buffer */
                      IF (NOT isClass AND Edit_Buffer.hBuffer:PRIVATE-DATA BEGINS untitled) THEN
                      DO:
                          /* if a class or interface error */
                          IF isClassError THEN
                          DO:
                              /* mark this as a class with an empty ClassType */
                              ASSIGN 
                                  ClassType = ""
                                  isClass = TRUE.
                              /* remove the previous Compile_Filename */
                              OS-DELETE VALUE(Compile_Filename).
                              NEXT SAVE_AND_COMPILE_BLOCK.
                          END.
                      END.
                      /* If this is a class, but the compile showed the classtype was wrong 
                       * 20050809-041 Only do this if the Wrong Class Type error was raised 
                       * on the same file that was being compiled, in case an interface or
                       * ancestor class gives the same error. */                      
                      IF (isClass AND isWrongClass AND 
                          COMPILER:FILE-NAME = Compile_Filename) THEN
                      DO:
                          /* if the previous classtype is "" (just-loaded .cls)
                           * OR the file is an untitled edit buffer containing OO4GL
                           * OR classtype is a subset of COMPILER:CLASS-TYPE (user qualified the classtype)
                           * then we want to save the classname, and redo the save */
                          IF (ClassType = "" OR 
                              Edit_Buffer.hBuffer:PRIVATE-DATA BEGINS untitled OR
                              IsValidClassChange(
                                  IF (Edit_Buffer.hBuffer:PRIVATE-DATA BEGINS untitled) THEN ? ELSE Edit_Buffer.hBuffer:PRIVATE-DATA,
                                  ClassType,COMPILER:CLASS-TYPE))
                              THEN
                          DO:
                              ClassType = COMPILER:CLASS-TYPE.
                              /* remove the previous Compile_Filename */
                              OS-DELETE VALUE(Compile_Filename).
                              NEXT SAVE_AND_COMPILE_BLOCK.
                          END.
                          /* otherwise, fall through and display the wrong class error message */
                      END.
                  END.  /* if Read_OK */
              END.  /* if compiler_stopped */
              LEAVE SAVE_AND_COMPILE_BLOCK.
          END.  /* COMPILE_BLOCK */

      END.  /* SAVE_AND_COMPILE_BLOCK */
  
      RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .

      IF ( Compiler_Stopped = FALSE ) /* User did not abort compile. */
      THEN DO:

          /*-------------------------------------------------------------
             Read the compiler messages file always.  Some messages can be
             generated (like warning and preprocessor messages) without
             raising the COMPILER:ERROR flag.
          -------------------------------------------------------------*/
          ASSIGN Read_OK = Compiler_Messages:READ-FILE(Compiler_Message_Log)
                 NO-ERROR.
          IF (Read_OK = FALSE) OR (ERROR-STATUS:ERROR = TRUE) OR
             (ERROR-STATUS:GET-MESSAGE(1) <> "")
          THEN MESSAGE "Unable to read Compiler Messages file."
                       VIEW-AS ALERT-BOX WARNING BUTTONS OK.

          IF ( Compiler_Error = TRUE ) 
          THEN DO:
              Return_Status = YES.
              IF ( COMPILER:FILENAME <> Compile_FileName )
                 AND ( SEARCH(COMPILER:FILENAME) <> SEARCH(Compile_FileName) )
              THEN DO:
                   RUN GetFile ( INPUT COMPILER:FILENAME ,
                                 INPUT-OUTPUT ProEditor ,
                                 OUTPUT Return_Status ).
              END.

              IF ( Return_Status = YES ) THEN
              &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
                 /* LARGE MSW editor does not support :CURSOR-OFFSET. */
                 ASSIGN ProEditor:CURSOR-LINE = COMPILER:ERROR-ROW 
                        ProEditor:CURSOR-CHAR = COMPILER:ERROR-COLUMN
                        NO-ERROR.
              &ELSE
                 ASSIGN ProEditor:CURSOR-OFFSET = COMPILER:FILE-OFFSET NO-ERROR.
              &ENDIF
          END.

          /* if this is a .cls file, we want to set the Class_Type.
           * We want to do this if:
           * - this is an untitled edit buffer
           * - we opened the .cls file, and this is the first time compiling
           * However, we DON'T want to do this if:
           * - this is a .cls file, and the basename of the file is 
           *   is different from the basename of the class-type.
           *   If these are different, it means the user saved the file
           *   as foo.cls, when the file was defined as CLASS bar.
           *   We should be saving the file as foo.cls, as the user 
           *   wanted, not as we know it should be.
           */
          IF (isClass AND Edit_Buffer.Class_Type = "" AND 
              ClassType <> ?) THEN
              Edit_Buffer.Class_Type = ClassType.

          /* Show any compiler messages (warnings, etc) if any. */
          IF NOT Compiler_Messages:EMPTY 
              THEN RUN CompilerMessages.

          IF ( Compiler_Error <> TRUE ) AND CAN-DO( "RUN,DEBUG" , p_Mode )
          THEN DO:
            /* check if a tool is already running a program */
            RUN adecomm/_wfrun.p (INPUT "Procedure Editor", OUTPUT wfrun).
            IF wfrun THEN RETURN. /* another tool is running a procedure */
            Execute_Block :
            DO ON STOP UNDO Execute_Block , LEAVE Execute_Block :
               /* set up the file to run. 
                * For a .cls, this is not the same Compile_Filename */
               Run_Filename = Edit_Buffer.Compile_Name.
               /* .cls RUN processing */
               IF (isClass) THEN
               DO:
                   /* If .cls file is not saved */
                   IF Buffer_Modified THEN
                   DO:
                       /* if untitled or not autosave, offer to save */
                       IF (ProEditor:PRIVATE-DATA BEGINS Untitled OR
                           NOT Sys_Options.SaveClass_BeforeRun) THEN
                       DO:
                           lOK = TRUE.
                           /* offer to save(-as) */
                           RUN AskToSaveClass(
                               INPUT (IF ProEditor:PRIVATE-DATA BEGINS Untitled THEN YES ELSE NO) /* untitled */,
                               INPUT ClassType,  /* package name */
                               INPUT-OUTPUT Sys_Options.SaveClass_BeforeRun   /* AutoSaveCls setting  */,
                               OUTPUT lOK).
                           /* if not save, abort run */
                           IF (NOT lOK) THEN
                           DO:
                               /* abort run */
                               LEAVE Execute_Block.
                           END.
                           ELSE
                           DO:
                               /* Only the AutoSaveCls if using GUI */
                               &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
                               /* save the Sys_Options.SaveClass_BeforeRun value */
                               PUT-KEY-VALUE SECTION KeyValue_Section 
                                   KEY "AutoSaveCls" 
                                   VALUE (IF Sys_Options.SaveClass_BeforeRun THEN "Yes" ELSE "") NO-ERROR.
                               &ENDIF
                           END.
                       END.  /* if untitled or not autosave */
                       /* record whether this was an untitled edit buffer */
                       lOK = (IF ProEditor:PRIVATE-DATA BEGINS Untitled THEN TRUE ELSE FALSE).
                       /* save the file. SaveFile will automagically run SaveAs if necessary */
                       RUN SaveFile(ProEditor).
                       IF RETURN-VALUE = "_CANCEL" THEN
                       DO:
                           /* TO DO: error, save failed, abort run? */
                           LEAVE Execute_Block.
                       END.
                       /* if this was an untitled edit buffer, 
                        * we need to reset some values after the save-as */
                       IF lOK THEN
                           Edit_buffer.Class_Type = ClassType.
                   END.  /* if Buffer_Modified */
                   /* search for this class in the PROPATH */
                   RUN FindClassInPropath(
                       INPUT ClassType,  /* expected classtype */
                       INPUT ProEditor:PRIVATE-DATA, /* name of file */
                       OUTPUT lOK).
                   /* file was not in PROPATH, user aborted */
                   IF (NOT lOK) THEN
                   DO:
                       /* abort run */
                       LEAVE Execute_Block.
                   END.
                   /* build the run stub here */
                   RUN CreateClassStub(Run_Filename,INPUT ClassType).
                   IF (RETURN-VALUE <> ?) THEN
                   DO:
                       /* TO DO: tidy this up */
                       MESSAGE RETURN-VALUE
                           VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                       LEAVE Execute_Block.
                   END.
               END.  /* if isClass */
               IF ( p_Mode = "DEBUG" )
               THEN DO:
                    RUN DebugInit .
                    /* Use -1 to set break at first executable line in
                       main PROCEDURE. */
                    /* TO DO: for a .cls file, debug the original filename, 
                     * NOT the compile_filename */
                    RUN DebugSetBreakpoint (INPUT Compile_FileName ,
                                            INPUT -1 , TRUE /* Set Break */ ).
               END.
               /* No compiler errors, so run the program. */
               RUN ExecuteRun 
                 ( INPUT win_Proedit, 
                   INPUT Run_Window, 
                   INPUT Editor_Name + " - Run",
                   INPUT Run_FileName ,
                   INPUT FALSE /* Does not force a no-pause after run */ ).
            END. /* ON STOP Execute_Block */  
    
            /* Clear Debugger if Compile->Debug executed. */
            IF ( p_Mode = "DEBUG" ) THEN RUN DebugClear.
            
            ASSIGN wfRunning = "". /* reset flag */
          END.
          ELSE IF ( Compiler_Error <> TRUE ) AND ( p_Mode = "CHECK-SYNTAX" )
          THEN DO:
               MESSAGE "Syntax is correct." 
                   VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
          END.
        END. /* COMPILER:STOPPED */
      END. /* IF NOT RETRY */
  
      OUTPUT CLOSE.
      OS-DELETE VALUE( Compile_FileName ) NO-ERROR.
      OS-DELETE VALUE( Compiler_Message_Log ) NO-ERROR.
      /* .cls support - remove temp dir. 
       * TO DO: Make sure this does not delete stuff it shouldn't */      
      IF (Edit_Buffer.Class_TmpDir <> ?) THEN
          OS-DELETE VALUE( Edit_Buffer.Class_TmpDir) RECURSIVE.
      /* if a .cls, remove the Run_FileName as well */
      IF (isClass AND Run_Filename <> ?) THEN
          OS-DELETE VALUE( Run_Filename ) NO-ERROR.

      /* --- Begin SCM changes --- */
      ASSIGN scm_action = p_Mode. /* RUN, CHECK-SYNTAX, DEBUG */
      RUN adecomm/_adeevnt.p 
          (INPUT "Editor",
           INPUT scm_action, INPUT scm_context, INPUT scm_filename,
           OUTPUT scm_ok ).
      /* --- End SCM changes ----- */

      RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .
      RETURN.  /* Use to reset RETURN-VALUE function to Null (""). */

  END. /* RunFile_STOP DO ON STOP */
    
      
END PROCEDURE.        /* RunFile */



PROCEDURE CompilerMessages.
 
/*--------------------------------------------------------------------------
    Purpose:            Displays most recently generated compiler messages.

    Run Syntax:     RUN CompilerMessages.

    Parameters:

    Description:
    Notes:
 
---------------------------------------------------------------------------*/

  /* Help triggers */
  ON CHOOSE OF CW_Help_Button IN FRAME Compiler-Frame
     OR HELP OF FRAME Compiler-Frame
    RUN adecomm/_kwhelp.p ( INPUT Compiler_Messages:HANDLE, 
                            INPUT "edit"    , 
                            INPUT {&Compiler_Message_Dialog_Box} ).

  IF Compiler_Messages:EMPTY
  THEN DO:
    MESSAGE "No Compiler Messages to display."
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    RETURN.
  END.
 
  /* Change temp file name in messages to null and make read-only. */
  ASSIGN System_Error = Compiler_Messages:REPLACE( Compile_FileName , 
                        "" , FIND-GLOBAL ) IN FRAME Compiler-Frame

         Compiler_Messages:READ-ONLY IN FRAME Compiler-Frame     = TRUE.

  ENABLE ALL EXCEPT CW_Help_Button WITH FRAME Compiler-Frame.
  ENABLE CW_Help_Button {&WHEN_HELP} WITH FRAME Compiler-Frame.
  
  UPDATE_BLK:
  DO ON STOP UNDO UPDATE_BLK, LEAVE UPDATE_BLK
     ON ERROR UNDO UPDATE_BLK, LEAVE UPDATE_BLK
     ON ENDKEY UNDO UPDATE_BLK, LEAVE UPDATE_BLK:
    UPDATE CW_Close_Button
           GO-ON ( GO,WINDOW-CLOSE )
           WITH FRAME Compiler-Frame.
  END.
    
  HIDE FRAME Compiler-Frame NO-PAUSE.
  DISABLE ALL WITH FRAME Compiler-Frame.
  APPLY "ENTRY" TO ProEditor.

END PROCEDURE. /* CompilerMessages */


PROCEDURE DebugInit.
/*--------------------------------------------------------------------------
    Purpose:        Initializes Progress Debugger.

    Run Syntax: RUN DebugInit.
    
    Parameters:
    Description:
    Notes:
---------------------------------------------------------------------------*/

  DEFINE VAR Return_Value AS LOGICAL NO-UNDO.
  
  DO:
    /* INITIATE() is a NO-OP if Debugger is already initiated. */
    ASSIGN Return_Value             = DEBUGGER:INITIATE()
    . /* END ASSIGN */
  END.
  
END PROCEDURE.


PROCEDURE DebugSetBreakpoint.
/*--------------------------------------------------------------------------
    Purpose:        Sets or cancels a Debugger breakpoint at specified line in
                specified procedure.

    Run Syntax: RUN DebugSetBreakpoint ( INPUT p_Proc_Name ,
                                         INPUT p_Line_Num  , 
                                         INPUT p_Break_State ).

    Parameters:
        INPUT
            p_Proc_Name (CHAR) - 
                Name of procedure in which to set or cancel breakpoint.
            p_Line_Num  (INTE) - 
                Line within p_Proc_Name at which to set or cancel a 
                breakpoint.
            p_Break_State(LOG) - 
                FALSE : Cancel breakpoint, if one is there.
                TRUE  : Set breakpoint at line in proc.

    Description:

    Notes:
---------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Proc_Name   AS CHARACTER NO-UNDO .
  DEFINE INPUT PARAMETER p_Line_Num    AS INTEGER   NO-UNDO .  
  DEFINE INPUT PARAMETER p_Break_State AS LOGICAL   NO-UNDO .

  DEFINE VAR Return_Value AS LOGICAL NO-UNDO.
  
  IF ( p_Break_State = TRUE ) /* Setting Break */
  THEN DO:
    ASSIGN Return_Value = DEBUGGER:SET-BREAK( p_Proc_Name , p_Line_Num )
    . /* END ASSIGN */
  END.
  ELSE DO:
    ASSIGN
      Return_Value = DEBUGGER:CANCEL-BREAK( p_Proc_Name , p_Line_Num )
    . /* END ASSIGN */
  END.
  
END PROCEDURE.


PROCEDURE DebugClear.
/*--------------------------------------------------------------------------
    Purpose:        Resets Debugger state by clearing breaks, etc.

    Run Syntax: RUN DebugClear.
    Parameters:
    Description:
    Notes:
---------------------------------------------------------------------------*/
    
    DEFINE VAR Return_Status       AS LOGICAL NO-UNDO .
        
    ASSIGN
        DEBUGGER:VISIBLE = FALSE
        Return_Status    = DEBUGGER:CLEAR()
    . /* END ASSIGN. */
END PROCEDURE.


/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------------
  pfile.i 
  File Commands-Related Procedures for Editor
--------------------------------------------------------------------------*/


PROCEDURE WinExitEditor:
  /*--------------------------------------------------------------------------
    Purpose:        Executes the EXIT command, exiting the PROGRESS Editor.

    Run Syntax:     RUN WinExitEditor.

    Parameters:

    Description:
        1. Allow user chance to save any changes to open buffers.

    Notes: See ExitEditor  procedure in this file.
    Modified: 12/96 Added SKIP(2) to printile for TTY bug#96-09-19-036
  ---------------------------------------------------------------------------*/

  APPLY "CHOOSE" TO mi_Exit.
  RETURN ERROR.
END PROCEDURE.  /* WinExitEditor. */


PROCEDURE FileChanged:

  /*--------------------------------------------------------------------------
    Purpose:        Executes File Changed Dialog, which asks user to save
                    changes made to a modified file before continuing some
                    operation.

    Run Syntax:     RUN FileChanged( INPUT p_Buffer , OUTPUT p_Message_Response)

    Parameters:
        p_Message_Repsonse   YES - User wants changes.
                             NO  - User does not want changes saved.
                              ?  - User wants to Cancel the current
                                   operation.
    Description:
    
    Notes:
  --------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO. 
  DEFINE OUTPUT PARAMETER p_Message_Response AS LOGICAL NO-UNDO.

  DEFINE VARIABLE Buf_Modified AS LOGICAL NO-UNDO.

  /* PROC BufQMod can be found in adeedit/pbuffers.i. */
  RUN BufQMod ( INPUT p_Buffer , OUTPUT Buf_Modified ).
  IF ( Buf_Modified = TRUE ) THEN DO:
    p_Message_Response = YES.
    MESSAGE p_Buffer:PRIVATE-DATA SKIP
            "This buffer has changes which have not been saved." SKIP(1)
              "Save changes before closing?"
             VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO-CANCEL 
                      UPDATE p_Message_Response. 
  END.
  ELSE
    p_Message_Response = NO.  /* No changes, so skip the save. */
    
  RETURN.
  
END PROCEDURE.  /* AlertClose */


PROCEDURE NewFile:

  /*--------------------------------------------------------------------------
    Purpose:        Executes NEW File Command, which creates a new 
                    current untitled buffer.

    Run Syntax:     RUN NewFile

    Parameters:

    Description:
    Notes:
  --------------------------------------------------------------------------*/
  
  DEFINE VAR Buf_Name AS CHAR NO-UNDO.
  /* --- Begin SCM changes --- */
  DEFINE VAR scm_ok   AS LOGICAL NO-UNDO.
  /* --- End SCM changes ----- */
  
  RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "Creating new buffer..." ,
                        "WAIT" ) .

  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
    /* To avoid flashing in tty, hide current buffer. */
    ASSIGN ProEditor:VISIBLE = FALSE NO-ERROR.
  &ENDIF

  /* OpenNewBuffer */
  RUN CreateBuffer (INPUT win_ProEdit, OUTPUT ProEditor ) .
  RUN CreateUntitledBufName (OUTPUT Buf_Name ) .
  ASSIGN ProEditor:PRIVATE-DATA = Buf_Name.
  RUN AssignBuffer ( INPUT ProEditor , INPUT ProEditor:PRIVATE-DATA ).
  RUN MakeCurrent( INPUT win_ProEdit, INPUT ProEditor ) .
  ASSIGN File_Name = ProEditor:PRIVATE-DATA.

  /* --- Begin SCM changes --- */
  RUN adecomm/_adeevnt.p 
      (INPUT  "Editor", INPUT "New", INPUT STRING(ProEditor), ?, 
       OUTPUT scm_ok).
  /* --- End SCM changes ----- */

  /* Clear Undo state. */
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  ASSIGN ProEditor:EDIT-CAN-UNDO = FALSE.
  &ENDIF

  RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .
  /* Although MakeCurrent executes an APPLY "ENTRY", the wait state was set
     which causes PROGRESS to block the event. So we do it again after the
     wait state has been turned off.
  */
  APPLY "ENTRY" TO ProEditor.

END PROCEDURE.  /* NewFile */


PROCEDURE OpenFile:

  /*--------------------------------------------------------------------------
    Purpose:        Executes the OPEN command, which allows user to select
                    and edit an existing file.  Opens file into new buffer.
                    
                    For GUI, handles dropped files processing as well.

    Run Syntax:     RUN OpenFile.

    Parameters:

    Description:

        1. If there are no dropped files, prompt user for a filename.
        2. For files selected or dropped:
            - Check for a reopen
            - Otherwise open the file
        3. Opened files are added to Editor's Buffer List, if not already on it.

    Notes:
  ---------------------------------------------------------------------------*/

  DEFINE VARIABLE hCur_Buffer AS WIDGET-HANDLE NO-UNDO.
  /* In case we cannot read the "Open File" into a buffer, we'll go back
     to hCur_Buffer.                                 
  */
  DEFINE VARIABLE OF_OK         AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE File_Selected AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE Valid_BufName AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE File_Count    AS INTEGER      NO-UNDO.
  
  IF (win_ProEdit:NUM-DROPPED-FILES = ?) OR
     (win_ProEdit:NUM-DROPPED-FILES = 0) THEN
  DO:
      RUN adeedit/_dlggetf.p 
          ( INPUT "Open" ,
            INPUT NO ,
            INPUT 1 /* Initial_Filter */ ,
            INPUT-OUTPUT File_Selected ,
            OUTPUT OF_OK ) .
  END.
  ELSE
  DO File_Count = 1 TO win_ProEdit:NUM-DROPPED-FILES:
      ASSIGN File_Selected = File_Selected + ",":U + win_Proedit:GET-DROPPED-FILE(File_Count)
             OF_OK         = TRUE.
  END.
  IF NOT OF_OK THEN RETURN. /* User pressed Cancel. */

  /* Remove leading comma that may have been added in dropped-files processing. */
  ASSIGN File_Selected = TRIM(File_Selected, ",":U).

  OPEN_BLOCK:
  DO File_Count = 1 TO NUM-ENTRIES(File_Selected):
      /* Test for reopening file. Here's what the return values mean:
            OF_OK = YES : File was open with changes and got reopened.
                    NO  : File was open with changes and user did not want it reopened.
                    ?   : File was not already open.
      */
      RUN ReOpenFile ( INPUT ENTRY(File_Count, File_Selected) , INPUT-OUTPUT ProEditor ,
                       OUTPUT OF_OK ).
      IF ( OF_OK = ? ) THEN
      DO: /* Go open file. */
          RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "Opening file..." ,
                             "WAIT" ) .
          RUN FileOpen
                ( INPUT        win_ProEdit ,
                  INPUT        ENTRY(File_Count, File_Selected) ,
                  INPUT        FALSE ,
                  INPUT-OUTPUT ProEditor ).
          File_Name = ProEditor:PRIVATE-DATA.
          &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
          /* If File_Name begins untitled then there was an error opening the 
             file and we don't want to add the file to the MRU filelist */
          IF File_Name BEGINS Untitled THEN.
          ELSE RUN MRUList ( INPUT File_Name ).
          &ENDIF
      END.
      ELSE
      DO: /* File either got reopened or did not get reopened. */
          File_Name = ProEditor:PRIVATE-DATA.
          NEXT OPEN_BLOCK.
      END.
  END. /* DO OPEN_BLOCK */
  
  /* Be certain the system-wide File_Name var is set to correct current file name. */
  File_Name = ProEditor:PRIVATE-DATA.

  /* Always release dropped-files memory before returning. */
  win_ProEdit:END-FILE-DROP().


  RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .


  /* Although FileOpen which calls MakeCurrent executes an APPLY "ENTRY", 
     the wait state was set which causes PROGRESS to block the event.
     So we do it again after the wait state has been turned off.
  */
  APPLY "ENTRY" TO ProEditor.
  
END PROCEDURE.  /* OpenFile */

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
PROCEDURE OpenMRUFile:

  /*--------------------------------------------------------------------------
    Purpose:        Open a File from the MRU FileList
                    
    Run Syntax:     RUN OpenMRUFile ( INPUT p_File_Num ).

    Parameters:     p_File_Num     INTEGER
                    File position of the file in the MRU FileList to be opened

    Description:

    Notes:
  ---------------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_File_Num AS INTEGER NO-UNDO.
  
  DEFINE VARIABLE hCur_Buffer AS WIDGET-HANDLE NO-UNDO.
  /* In case we cannot read the "Open File" into a buffer, we'll go back
     to hCur_Buffer.                                 
  */
  DEFINE VARIABLE OF_OK         AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE Valid_BufName AS LOGICAL      NO-UNDO.
  
  FIND MRU_Files WHERE MRU_Files.mru_position = p_File_Num NO-ERROR.
  IF AVAILABLE MRU_Files THEN DO:
    /* Test for reopening file. Here's what the return values mean:
          OF_OK = YES : File was open with changes and got reopened.
                  NO  : File was open with changes and user did not want it reopened.
                  ?   : File was not already open.
    */
    RUN ReOpenFile ( INPUT MRU_Files.mru_file , INPUT-OUTPUT ProEditor , OUTPUT OF_OK ).
    IF ( OF_OK = ? ) THEN
    DO: /* Go open file. */
        RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "Opening file..." ,
                           "WAIT" ) .
        RUN FileOpen
              ( INPUT        win_ProEdit ,
                INPUT        MRU_Files.mru_file ,
                INPUT        FALSE ,
                INPUT-OUTPUT ProEditor ).
        File_Name = ProEditor:PRIVATE-DATA.
        /* If File_Name begins untitled then there was an error opening the
           file so we remove the file from the filelist */
        IF File_Name BEGINS Untitled THEN DO:
          DELETE MRU_Files.
          RUN MRUList ( INPUT "":U ).
        END.  /* if file_name begins untitled */
        /* File was opened successfully so we must adjust its position on the
           filelist */
        ELSE RUN MRUList ( INPUT File_Name ).
    END.
    ELSE
    DO: /* File either got reopened or did not get reopened. */
        File_Name = ProEditor:PRIVATE-DATA.
    END.
  
    /* Be certain the system-wide File_Name var is set to correct current file name. */
    File_Name = ProEditor:PRIVATE-DATA.

    RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .

    /* Although FileOpen which calls MakeCurrent executes an APPLY "ENTRY", 
       the wait state was set which causes PROGRESS to block the event.
       So we do it again after the wait state has been turned off.
    */
    APPLY "ENTRY" TO ProEditor.
  END.  /* if avail MRU_Files */
  
END PROCEDURE.  /* OpenMRUFile */
&ENDIF

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
PROCEDURE NewPW:
  /*--------------------------------------------------------------------------
    Purpose:        Executes File->New Procedure Window editor command.

    Run Syntax:     RUN NewPW.

    Parameters:

    Description:
    Notes:
  --------------------------------------------------------------------------*/
  
  DEFINE VARIABLE pw_Window  AS WIDGET-HANDLE NO-UNDO.
  DEFINE VARIABLE pw_Editor  AS WIDGET-HANDLE NO-UNDO.
  
  RUN WinStatusMsg ( win_ProEdit , 
                     "MT_INPUT"  ,
                     "Creating new procedure window..." ,
                     "WAIT" ) .
  /* Open new Procedure Window. */
  RUN adecomm/_pwmain.p ( INPUT "_edit.p":U /* PW Parent ID */ ,
                          INPUT ""          /* PW File List */ ,
                          INPUT ""          /* PW Command   */ ).
  
  /* Get handle of new PW. */
  ASSIGN pw_Window = SESSION:LAST-CHILD.
  
  /* Get widget handle of Procedure Window editor widget. */
  RUN adecomm/_pwgeteh.p ( INPUT pw_Window , OUTPUT pw_Editor ).
  
  /* Make new PW inherit font of Procedure Editor default font. */
  IF pw_Editor:FONT <> Sys_Options.EditorFont
  THEN ASSIGN pw_Editor:FONT = Sys_Options.EditorFont.

  RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .
   
END PROCEDURE.
&ENDIF

PROCEDURE ReOpenFile:
  /*--------------------------------------------------------------------------
    Purpose:        Re-Open a file from disk, or if the file is already open
                    in a buffer, make it the current buffer.

    Run Syntax:     RUN ReOpenFile
                      ( INPUT p_File_Name ,
                        INPUT-OUTPUT p_Current_Buffer ,
                        OUTPUT p_Return_Status ) .

    Parameters:

    Description:
    Notes:
  --------------------------------------------------------------------------*/

  DEFINE INPUT        PARAMETER p_File_Name      AS CHAR NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER p_Current_Buffer AS WIDGET-HANDLE NO-UNDO.
  DEFINE OUTPUT       PARAMETER p_Return_Status  AS LOGICAL NO-UNDO.

  DEFINE VAR Fullpath_Buffer_Name AS CHAR NO-UNDO.
  DEFINE VAR Delete_Buffer AS WIDGET-HANDLE.

  /* --- Begin SCM changes --- */
  DEFINE VAR scm_ok    AS LOGICAL           NO-UNDO.
  DEFINE VAR scm_context   AS CHAR              NO-UNDO.
  DEFINE VAR scm_filename AS CHAR              NO-UNDO.
  /* --- End SCM changes ----- */

  /* References to system editor vars here. */
  DO: /* proc-main */
      ASSIGN
          p_Return_Status      = ?
          FILE-INFO:FILENAME   = p_File_Name .
          Fullpath_Buffer_Name = FILE-INFO:FULL-PATHNAME
      . /* END ASSIGN. */
      /*----------------------------------------------------------------
         Be sure we can find file. User may have renamed or deleted it.
         Don't search for Edit_Buffer with File_Name = ? because
         that finds the first Untitled buffer.
      ----------------------------------------------------------------*/
      IF ( Fullpath_Buffer_Name <> ? ) 
      THEN FIND FIRST Edit_Buffer WHERE ( Edit_Buffer.File_Name =
                                          Fullpath_Buffer_Name )
                                  NO-ERROR.

      IF AVAILABLE( Edit_Buffer ) AND ( Fullpath_Buffer_Name <> ? )
      THEN DO:  /* File already open in editor buffer. */
      
        p_Return_Status = YES.
        IF ( Edit_Buffer.hBuffer:MODIFIED = YES )
        THEN DO:  /* Modified */
            MESSAGE p_File_Name SKIP
                    "File is already open with changes." SKIP(1)
                    "Discard changes and re-open file?"
                    VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO
                            UPDATE p_Return_Status .
            
            IF ( p_Return_Status = NO ) 
            THEN DO: /* Switch to open buffer. */
                /* If its not already the current buffer, make it current. */
                IF ( p_Current_Buffer <> Edit_Buffer.hBuffer )
                THEN DO:

                  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
                  /* To avoid flashing in tty, hide current buffer. */
                  ASSIGN p_Current_Buffer:VISIBLE = FALSE NO-ERROR.
                  &ENDIF

                  p_Current_Buffer = Edit_Buffer.hBuffer .
                  File_Name = p_Current_Buffer:PRIVATE-DATA.
                  RUN MakeCurrent ( INPUT Edit_Buffer.hWindow ,
                                    INPUT Edit_Buffer.hBuffer ).
                END.
                ELSE APPLY "ENTRY" TO p_Current_Buffer.
                RETURN.
            END.     /* Switch to open buffer. */
            &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
            /* If file is being re-opened then we must adjust its placement
               in the MRU filelist */
            ELSE RUN MRUList ( INPUT p_File_Name ).
            &ENDIF
        END.     /* Modified */


        /* --- Begin SCM changes --- */
        IF ( p_Return_Status = TRUE ) THEN
        DO:
          /* Check with source code control programs and see if we really
           * should reopen/close the file. [Save the scm_context and file name
           * so that we can report the event after the file has closed.]
           */
          ASSIGN scm_context  = STRING(Edit_Buffer.hbuffer)
                 scm_filename = Edit_Buffer.hbuffer:PRIVATE-DATA.
          RUN adecomm/_adeevnt.p 
                 (INPUT "Editor", INPUT "Before-Open", INPUT ?, INPUT scm_filename,
                  OUTPUT p_Return_Status).

          IF ( p_Return_Status = TRUE ) THEN
             RUN adecomm/_adeevnt.p 
                 (INPUT "Editor", "Before-Close", scm_context, scm_filename,
                  OUTPUT p_Return_Status ).
        END.
        /* --- End SCM changes ----- */
            

        IF ( p_Return_Status = TRUE ) THEN
        DO: /* Re-open. */
              RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , 
                                 "Re-opening file..." , "WAIT") . 
              ASSIGN
                  File_Name       = p_File_Name
                  Delete_Buffer   = Edit_Buffer.hBuffer
              . /* END ASSIGN. */
              IF SESSION:WINDOW-SYSTEM = "TTY" THEN 
                  RUN DeleteBuffer ( INPUT-OUTPUT Delete_Buffer ).
              RUN FileOpen ( INPUT win_ProEdit , INPUT File_Name ,
                             INPUT TRUE ,
                             INPUT-OUTPUT p_Current_Buffer ).
              IF SESSION:WINDOW-SYSTEM <> "TTY" THEN 
                  RUN DeleteBuffer ( INPUT-OUTPUT Delete_Buffer ).

              /* --- Begin SCM changes --- */
              RUN adecomm/_adeevnt.p 
                  (INPUT "Editor", "Close", scm_context, scm_filename, 
                   OUTPUT scm_ok ).
              /* --- End SCM changes ----- */

              RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) . 
              APPLY "ENTRY" TO p_Current_Buffer.
        END.     /* Re-open. */   
      END.  /* File already open in editor buffer. */
      /* ELSE - File is not already open, so caller should open it. */
      RETURN .
  END. /* proc-main */

END PROCEDURE .


PROCEDURE FileOpen:
/*----------------------------------------------------------------------------

Syntax:
        RUN FileOpen
            ( INPUT        p_Assign_Window ,
              INPUT        p_OpenList ,
              INPUT        p_ReOpen ,
              INPUT-OUTPUT p_Current_Buffer ).

Description:

  Opens a buffer for one or more existing files and assigned the buffer
  to the specified window.

INPUT Parameters

  p_Assign_Window  WIDGET-HANDLE        
          Editor window files are assigned to.

  p_OpenList       CHARACTER            
          Comma-delimited list of files to open.  Files are opened in the 
          same order as the list (creating a buffer list in the same
          order as well). The first file in the list is always made
          the current buffer (see p_Current_Buffer).

  p_ReOpen         LOGICAL
          If TRUE, Editor will not attempt to check if file is already
          open in the editor.  If FALSE, it will check and not allow
          the file to be reopened.

INPUT-OUTPUT Parameters
  p_Current_Buffer WIDGET-HANDLE
        IN :  Handle to current editor buffer.
        OUT:  Handle to current editor buffer.  This probably is a different
              buffer, since one or more files have been opened.  


Author: John Palazzo

Date Created: 08.05.92 

----------------------------------------------------------------------------*/

  DEFINE INPUT        PARAMETER p_Assign_Window  AS WIDGET-HANDLE NO-UNDO.
  DEFINE INPUT        PARAMETER p_OpenList       AS CHARACTER NO-UNDO.
  DEFINE INPUT        PARAMETER p_ReOpen         AS LOGICAL   NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER p_Current_Buffer AS WIDGET-HANDLE NO-UNDO.
  
  /* PROGRESS Preprocessor Message Number - 104:
     Invalid Characters were replaced with blanks. (104)
  */
  &SCOPED-DEFINE MSG-104       104

  DEFINE VARIABLE List_Item    AS INTEGER       NO-UNDO.
  DEFINE VARIABLE File_to_Open AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE Search_File  AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE hCur_Buffer  AS WIDGET-HANDLE NO-UNDO.
  DEFINE VARIABLE In_Library   AS CHAR          NO-UNDO.
  DEFINE VARIABLE Read_OK      AS LOGICAL       NO-UNDO.
  DEFINE VARIABLE Open_Msg     AS CHARACTER     NO-UNDO.
  
  /* --- Begin SCM changes --- */
  DEFINE VAR scm_ok       AS LOGICAL           NO-UNDO.
  DEFINE VAR scm_context  AS CHAR              NO-UNDO.
  DEFINE VAR scm_filename AS CHAR              NO-UNDO.
  /* --- End SCM changes ----- */
  
  DEFINE VARIABLE Valid_BufName AS LOGICAL NO-UNDO .

  IF LENGTH( p_OpenList ) = 0 THEN RETURN.
  
  OPEN_BLOCK:
  DO List_Item = 1 TO NUM-ENTRIES( p_OpenList ) :

    /* Save whandle to current buffer in case of read-file failure. */
    hCur_Buffer  = p_Current_Buffer.
    
    /* Get file to open and the search name. */
    File_to_Open = ENTRY( List_Item , p_OpenList ).

    ASSIGN scm_ok = TRUE.
    IF ( p_ReOpen = FALSE ) THEN
    DO:
        RUN BufValidName ( INPUT ? , INPUT File_to_Open ,
                            OUTPUT Valid_BufName ).
        IF NOT Valid_BufName THEN NEXT OPEN_BLOCK.

        /* --- Begin SCM changes --- */
        RUN adecomm/_adeevnt.p 
               (INPUT "Editor", INPUT "Before-Open", INPUT ?, INPUT File_to_Open, OUTPUT scm_ok).
        IF NOT scm_ok AND VALID-HANDLE(hCur_Buffer) THEN
          NEXT OPEN_BLOCK. /* SCM Cancelled Open. */
        /* --- End SCM changes ----- */
    END.

    
    /* OpenNewBuffer */
    RUN CreateBuffer ( INPUT p_Assign_Window, OUTPUT p_Current_Buffer ).
    RUN AssignBuffer
        ( INPUT p_Current_Buffer , INPUT File_to_Open ).
    
    ASSIGN FILE-INFO:FILE-NAME = File_to_Open
           Search_File         = FILE-INFO:FULL-PATHNAME.

    /* Try to read file to newly created, but not visible buffer. */
    ASSIGN Read_OK = scm_ok NO-ERROR. /* Clear ERROR-STATUS. */
    IF scm_ok THEN ASSIGN Read_OK = p_Current_Buffer:READ-FILE( Search_File ) NO-ERROR.

    /* If its Invalid Characters message, show it and open the file. */
    IF ERROR-STATUS:GET-NUMBER(1) = {&MSG-104} THEN
    DO ON STOP UNDO, LEAVE:
        MESSAGE File_to_Open SKIP
                ERROR-STATUS:GET-MESSAGE(1) VIEW-AS ALERT-BOX INFORMATION.
    END.

    IF (Read_OK = FALSE) THEN
    DO:
      IF scm_ok THEN
      DO:
        ASSIGN In_Library = LIBRARY( File_to_Open ).
        IF ( In_Library <> ? ) THEN
          /* 1. File in R-code Library. */
          ASSIGN Open_Msg = "File is in R-code Library " +
                             In_Library + ".":U .
        ELSE DO:
          /* 2. Path or Filename incorrect. */
          ASSIGN FILE-INFO:FILE-NAME = File_to_Open.
          IF FILE-INFO:FULL-PATHNAME = ? THEN
              ASSIGN Open_Msg = "The path or filename may be incorrect or " +
                                "the file may not exist.".
          /* 3. No read permissions. */
          ELSE IF INDEX(FILE-INFO:FILE-TYPE , "R":U) = 0 THEN
              ASSIGN Open_Msg = "You do not have read permission.".
          /* 4. File may be too large. */
          ELSE
              ASSIGN Open_Msg = "The file may be too large to open.".
        END.
      END. /* scm */

      DO ON STOP UNDO, LEAVE:
        MESSAGE File_to_Open        SKIP
                "Cannot open file." SKIP(1)
                Open_Msg            SKIP
                "Creating Untitled buffer in its place."
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      END.
        
      /* Get rid of newly created buffer */
      RUN DeleteBuffer ( INPUT-OUTPUT p_Current_Buffer ).
      /* Create an Untitled buffer in its place. */
      RUN NewFile.
      ASSIGN p_Current_Buffer = ProEditor
             File_Name        = p_Current_Buffer:PRIVATE-DATA
      . /* END ASSIGN */
    END.

    ELSE 
    DO:
      /* Set the editor source type to get 4GL syntax highlighting.
       * Refer to comment in adecomm/_pwmain.p */
      /* adecomm/peditor.i */
      RUN SetEdBufType (INPUT p_Current_Buffer, INPUT Edit_Buffer.Buffer_Name).

      /* --- Begin SCM changes --- */
      RUN adecomm/_adeevnt.p 
        (INPUT  "Editor", "Open", STRING(p_Current_Buffer), File_to_Open, 
         OUTPUT scm_ok).
      /* --- End SCM changes ----- */
    END.

  END. /* DO List_Item */


/* --- Begin SCM changes --- */
/* Because "File Open" from another source (such as an SCM) could
 * potentially return a list of files to open, we want to try to position
 * on the first file in the new list, rather than on the first edit buffer.
 */
  IF ( NUM-ENTRIES( p_OpenList ) > 1 )
  THEN DO:
      FIND FIRST Edit_Buffer
           WHERE Edit_Buffer.Buffer_Name = ENTRY( 1 , p_OpenList )
           NO-ERROR.
      IF NOT AVAILABLE Edit_Buffer THEN FIND FIRST Edit_Buffer.
      ASSIGN p_Current_Buffer = Edit_Buffer.hBuffer
             File_Name        = p_Current_Buffer:PRIVATE-DATA
      . /* END ASSIGN */
  END.
/* --- End SCM changes ----- */


  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  /* To avoid flashing in tty, hide current buffer. */
  ASSIGN hCur_Buffer:VISIBLE = FALSE NO-ERROR.
  &ENDIF

  /* Display the new current buffer. */
  RUN MakeCurrent ( INPUT p_Assign_Window , INPUT p_Current_Buffer ).
    
END PROCEDURE.  /* FileOpen. */


PROCEDURE SaveFile:
  /*--------------------------------------------------------------------------
    Purpose:        Executes the SAVE command, saving contents of edit
                    buffer to current file name. Allows user to continue
                    editing uninterrupted.

    Run Syntax:     RUN SaveFile ( INPUT p_Buffer ) .

    Parameters:
        
    Description:
        1.  Test if the file is "untitled".
        2.  If untitled, execute the Save As Dialog, allowing
            user to enter a file name to save.
        3.  Write contents of edit buffer to File_Name.

    Notes:
  ---------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO .
  
  DEFINE VARIABLE File_Selected AS CHARACTER NO-UNDO.
  DEFINE VARIABLE SF_OK         AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE Old_Filename  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lOK           AS LOGICAL   NO-UNDO. 
  DEFINE VARIABLE cValue        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hTempDBLib    AS HANDLE    NO-UNDO.  
  DEFINE VARIABLE cRelName      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTables       AS CHARACTER NO-UNDO.
  
  ASSIGN Saved_File = FALSE.               /* system var */
  IF p_Buffer:PRIVATE-DATA  BEGINS Untitled THEN
  DO:
    RUN SaveAsFile ( INPUT p_Buffer ).
    RETURN RETURN-VALUE.
  END.
  ELSE
  DO:
      ASSIGN File_Selected = p_Buffer:PRIVATE-DATA.
      RUN FileSave ( INPUT p_Buffer , INPUT File_Selected , OUTPUT SF_OK ).
      IF SF_OK = TRUE THEN
      DO:
        IF CONNECTED ("TEMP-DB") THEN
        DO:
          RUN adeuib/_tempdbvalid.p (OUTPUT lOK). /* Check that control file is present in TEMP-DB */
          IF lOK THEN
          DO:          
            GET-KEY-VALUE SECTION  "ProAB":U KEY "TempDBIntegration":U VALUE cValue.
            IF CAN-DO ("true,yes,on",cValue) THEN
            DO:
              GET-KEY-VALUE SECTION  "ProAB":U KEY "TempDBExtension":U VALUE cValue.
              IF cValue > "" AND File_Selected MATCHES cValue THEN 
              DO:
                RUN adecomm/_relname.p (INPUT File_Selected, INPUT "", OUTPUT cRelName).
                RUN adeuib/_tempdbfind.p (INPUT "SOURCE":U,
                                          INPUT cRelName ,
                                          OUTPUT cTables).
                /* Only update if source file already exists */                          
                IF cTables > "" THEN
                DO:
                  hTempDBLib = SESSION:FIRST-PROCEDURE.
                  DO WHILE VALID-HANDLE(hTempDBLib) AND hTempDBLib:FILE-NAME NE "adeuib/_tempdblib.p":U:
                     hTempDBLib = hTempDBLib:NEXT-SIBLING.
                  END.
      
                  IF NOT VALID-HANDLE(hTempDBLib) THEN
                  DO:
                    RUN VALUE("adeuib/_tempdblib.p":U) PERSISTENT SET hTempDBLib.
                    RUN RebuildImport in hTempDBLib (cRelName).
                    IF VALID-HANDLE(hTempDBLib) THEN
                      DELETE PROCEDURE hTempDBLib.
                  END.
                  ELSE   
                    RUN RebuildImport in hTempDBLib (cRelName).
      
                END.
              END.  /* End if file extension matches */
            END.  /* End if flag is set to yes to do perfrom TEmp-DB rebuild */
          END.  /* End if temp-db is valid */
        END.  /* End If connected Temp-DB */
        
        RETURN.
      END.  
      ELSE
        RETURN "_CANCEL":U.
  END.

END.    /* SaveFile */


PROCEDURE SaveAsFile:

  /*--------------------------------------------------------------------------
    Purpose:        Executes the SAVE AS command, saving contents of edit
                    buffer to a user selected file name.

    Run Syntax:     RUN SaveAsFile ( INPUT p_Buffer ) .

    Parameters:

    Description:

        1. Prompts user for name of file to save current edit buffer
           contents to.
        2. Calls SaveFile procedure to execute actual save.

        Users execute the SAVE AS command to:
            1.  Save an Untitled file.
            2.  Save an existing file to a different file name.

    Notes:
  ---------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO .

  DEFINE VARIABLE File_Selected AS CHAR     NO-UNDO.
  DEFINE VARIABLE Was_Saved     AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE SA_OK         AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE Old_Filename  AS CHAR     NO-UNDO.
  DEFINE VARIABLE Valid_BufName AS LOGICAL  NO-UNDO.
  
  RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "WAIT" ) .
  IF (p_Buffer:PRIVATE-DATA BEGINS Untitled) THEN
  DO:
    /* When Exiting, help user out with default name, otherwise they don't
       know which of several buffers they are closing. */
    IF (PROGRAM-NAME(3) BEGINS "CloseAllBuffers":U) THEN
        ASSIGN File_Selected = REPLACE(p_Buffer:PRIVATE-DATA , ":" , "" ) + ".p":U.
  END.
  ELSE ASSIGN File_Selected = p_Buffer:PRIVATE-DATA.
  RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .

  SAVE_AS_BLOCK:
  DO WHILE TRUE:

    RUN adeedit/_dlggetf.p
        ( INPUT "Save As" ,
          INPUT YES ,
          INPUT 1 /* Initial_Filter */ ,
          INPUT-OUTPUT File_Selected ,
          OUTPUT SA_OK ) .

    IF NOT SA_OK THEN RETURN "_CANCEL":U. /* User pressed Cancel. */
    RUN BufValidName ( INPUT p_Buffer , INPUT File_Selected ,
                       OUTPUT Valid_BufName ).
    IF NOT Valid_BufName THEN NEXT SAVE_AS_BLOCK.
    
    RUN FileSave ( INPUT p_Buffer , INPUT File_Selected  ,
                   OUTPUT Was_Saved ).
    IF ( Was_Saved = TRUE ) THEN DO:
      &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
      /* If a new file is saved or an existing file is saved as, the file
         name must be added to the MRU filelist */
      RUN MRUList ( INPUT File_Selected ).
      &ENDIF
      LEAVE SAVE_AS_BLOCK.
    END.  /* if was_saved true */

  END. /* DO */
  RETURN.
END PROCEDURE.  /* SaveAsFile */


PROCEDURE FileSave:
  /*--------------------------------------------------------------------------
    Purpose:        Low-level routine to save buffer contents to os file.
                    Updates Window Title if file name has changed.

    Run Syntax:     RUN FileSave ( INPUT p_Buffer , 
                                   INPUT p_File_Selected ,
                                   OUTPUT p_Saved_File ) .

    Parameters:
        
    Description:

    Notes:
  ---------------------------------------------------------------------------*/
 
  DEFINE INPUT PARAMETER p_Buffer        AS WIDGET-HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p_File_Selected AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Saved_File   AS LOGICAL NO-UNDO.
  
  DEFINE VAR Old_BufName AS CHAR NO-UNDO .
  DEFINE VAR Save_OK     AS LOGICAL NO-UNDO.
   
    RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "Saving file..." , "WAIT" ) .
    ASSIGN
        Old_BufName       = p_Buffer:PRIVATE-DATA  /* Store old name. */
        p_Buffer:PRIVATE-DATA = p_File_Selected.  /* Assign new name. */
    RUN SaveBuffer ( INPUT p_Buffer , OUTPUT Save_OK ).
    RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .
    IF ( Save_OK = FALSE )
    THEN DO:
        ASSIGN
            p_Buffer:PRIVATE-DATA = Old_BufName
            p_Saved_File      = FALSE
            Saved_File        = FALSE
        .
        RETURN.
    END.
    
    Saved_File   = TRUE.  /* Global status var. */
    p_Saved_File = TRUE.

    IF ( p_Buffer:PRIVATE-DATA <> Old_BufName )
    THEN DO:    /* Filename changed (new name, from untitled, etc.. */
      RUN BufRename ( INPUT p_Buffer , INPUT p_File_Selected ).
      IF ( p_Buffer = ProEditor ) /* Was the Current Buffer Renamed? */
      THEN DO:
        RUN WinSetTitle ( win_ProEdit , p_Buffer:PRIVATE-DATA ) .
        File_Name = p_File_Selected. /* Global File Name var */
      END.
    END.
    
END PROCEDURE.  /* FileSave */



PROCEDURE CloseFile:

  /*--------------------------------------------------------------------------
    Purpose:        Executes CLOSE File Command, which closes the current
                    buffer.
    
    Run Syntax:     RUN CloseFile ( INPUT p_Buffer ).

    Parameters:

    Description:
            -   If file in current buffer has been modified, allows user
                to save changes before closing buffer.
            -   If file in current buffer is untitled, prompts user for
                a name to save the file as.
            -   When current buffer is deleted the prev buffer in the
                window's buffer list becomes current.
            -   If the current buffer is the only open buffer in the
                window's buffer list, then it is made an Untitled 
                buffer.
    Notes:
  --------------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO.
  
  DEFINE VARIABLE Message_Response AS LOGICAL NO-UNDO.
  DEFINE VARIABLE Delete_Buffer AS WIDGET-HANDLE NO-UNDO.

  /* --- Begin SCM changes --- */
  DEFINE VAR scm_ok     AS LOGICAL           NO-UNDO.
  DEFINE VAR scm_context  AS CHAR              NO-UNDO.
  DEFINE VAR scm_filename AS CHAR              NO-UNDO.
  /* --- End SCM changes ----- */
  
  RUN FileChanged(INPUT p_Buffer , OUTPUT Message_Response).
  IF Message_Response = ? THEN RETURN.  /* Cancel */
  IF Message_Response = YES THEN
  DO:
    RUN SaveFile ( INPUT p_Buffer ).
    IF NOT Saved_File THEN RETURN.  /* Global SysVar */
  END.


  /* --- Begin SCM changes --- */
  /* Check with source code control programs and see if we really should close 
     the file.  [Save the scm_context and file name so that we can report the
     event after the file has closed.] */
  ASSIGN scm_context  = STRING(p_Buffer)
         scm_filename = p_Buffer:PRIVATE-DATA.
  RUN adecomm/_adeevnt.p 
         (INPUT "Editor", "Before-Close", scm_context, scm_filename,
          OUTPUT scm_ok).
  /* --- End SCM changes ----- */

  /* --- Begin SCM changes --- */
  IF scm_ok THEN DO:
  /* --- End SCM changes ----- */
 
    RUN WinStatusMsg
      ( win_ProEdit , "MT_INPUT" , "Closing buffer..." , "WAIT") . 
    ASSIGN Delete_Buffer = p_Buffer .

    /* --- Begin SCM changes --- */
      RUN adecomm/_adeevnt.p
         (INPUT "Editor", "Close", scm_context, scm_filename,
          OUTPUT scm_ok).
    /* --- End SCM changes ----- */

    IF ( p_Buffer = ProEditor )
    THEN DO: 
      /* p_Buffer is Current Buffer, so update editor current buffer. */ 
      /* Determine if window has another buffer to make current. */
      RUN NumBuffers ( INPUT win_ProEdit, OUTPUT Buffers_Open ).
      IF Buffers_Open > 1 
        THEN RUN PrevBuffer.       /* Make prev buffer current. */
        ELSE RUN NewFile.          /* Make a new untitled buffer. */
      File_Name = ProEditor:PRIVATE-DATA.
    END.
    
    RUN DeleteBuffer ( INPUT-OUTPUT Delete_Buffer ).
    RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) . 

    /*  IF ( SESSION:WINDOW-SYSTEM = "TTY" )
    THEN   /* Prevents clipping problems in VV. */ */
    APPLY "ENTRY" TO ProEditor.

  /* --- Begin SCM changes --- */
  END.   /* IF scm_ok */
  /* --- End SCM changes ----- */


END PROCEDURE.  /* CloseFile */


PROCEDURE FilePrintCall:
/* Internal Call to FilePrint. Added to keep backwards compatibility
   for FilePrint. */

  RUN FilePrint (INPUT ProEditor).

END PROCEDURE.


PROCEDURE FilePrint:

  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO.

  DEFINE VAR Return_Status AS LOGICAL NO-UNDO.
  DEFINE VAR Printed       AS LOGICAL NO-UNDO.
  DEFINE VAR vModified     AS LOGICAL NO-UNDO.

  /* We don't need p_Window because buffer handles are unique system-wide. */
  FIND FIRST Edit_Buffer WHERE Edit_Buffer.hBuffer = p_Buffer.
  Compile_FileName = Edit_Buffer.Compile_Name.

  _PRINT_BLOCK:
  DO ON STOP UNDO _PRINT_BLOCK , RETRY _PRINT_BLOCK:

  IF NOT RETRY THEN
  DO:
    IF p_Buffer:EMPTY THEN
    DO:
      MESSAGE "Nothing in this buffer to print."
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      RETURN.
    END.

    RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "Printing procedure..." , 
                       "" ) .
    /* In Windows, we put up a dialog box. So we don't need the wait. */
    IF NOT SESSION:WINDOW-SYSTEM BEGINS "MS-WIN":U THEN
        RUN adecomm/_setcurs.p ( INPUT "WAIT" ).
        
    ASSIGN vModified         = p_Buffer:MODIFIED
           Return_Status     = p_Buffer:SAVE-FILE( Compile_FileName )
           p_Buffer:MODIFIED = vModified
    . /* END ASSIGN */

    /* adecomm/peditor.i */
    RUN SetEdBufType (INPUT p_Buffer, INPUT p_Buffer:PRIVATE-DATA).
    
    IF SESSION:WINDOW-SYSTEM = "TTY":U THEN
    DO:
       OUTPUT STREAM ttyStream TO VALUE(Compile_FileName) APPEND NO-ECHO.
       PUT STREAM ttyStream UNFORMATTED SKIP(2).
       OUTPUT STREAM ttyStream CLOSE. 
    END.
    RUN adecomm/_osprint.p ( INPUT win_ProEdit,
                             INPUT Compile_FileName,
                             INPUT p_Buffer:FONT,
                             INPUT 1 + /* use print dialog */
                               (IF SESSION:CPSTREAM = "utf-8":U THEN 512 ELSE 0),
                             INPUT 0, /* page size */
                             INPUT 0, /* page count */
                             OUTPUT Printed ) .
  END. /* NOT RETRY */

  OS-DELETE VALUE( Compile_FileName ) .
  IF NOT SESSION:WINDOW-SYSTEM BEGINS "MS-WIN":U THEN
      RUN adecomm/_setcurs.p ( INPUT "" ).
  RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .
  /* This is just to be sure the user winds up in the editor. */
  APPLY "ENTRY" TO p_Buffer.
  
  END. /* DO ON STOP */

END PROCEDURE. /* FilePrint */


PROCEDURE ExitEditor:

  /*--------------------------------------------------------------------------
    Purpose:        Executes the EXIT command, exiting the PROGRESS Editor.

    Run Syntax:     RUN ExitEditor.

    Parameters:

    Description:
        1. Allow user chance to save any changes to open buffers.

    Notes:
  ---------------------------------------------------------------------------*/
  DEFINE VARIABLE filekey    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE mru_actual AS INTEGER   NO-UNDO.
  DEFINE VARIABLE mru_count  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE ok_save    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE v          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_v        AS CHARACTER NO-UNDO.
  
  /* Save settings is done in the various dialogs and not on exit anymore.
     Except for MRU. */
  
  APPLY "U9":U TO win_ProEdit.
  
  RUN CloseWindow( INPUT-OUTPUT win_ProEdit ).
  /* At this point, Saved_File will = ? if user cancelled Exit. 
     This is detected by main wait-for and we re-enter it.
  */

  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  /* Save the MRU File list to the registry for non-tty. */
  PUTMRU-BLOCK:
  DO ON STOP  UNDO PUTMRU-BLOCK, LEAVE PUTMRU-BLOCK
     ON ERROR UNDO PUTMRU-BLOCK, LEAVE PUTMRU-BLOCK:

    mru_count = 1.
    mru_actual = Sys_Options.MRU_Entries.
    DO WHILE mru_count < 10:
      ASSIGN filekey = "MRUFile" + STRING(mru_count).
      GET-KEY-VALUE SECTION KeyValue_Section KEY filekey VALUE v.
      FIND MRU_Files where MRU_Files.mru_position = mru_count NO-ERROR.
      IF AVAILABLE MRU_Files THEN DO:
        IF mru_count <= mru_actual THEN DO:
          c_v = MRU_Files.mru_file.
          IF v NE c_v THEN
          DO:
            PUT-KEY-VALUE SECTION KeyValue_Section KEY filekey VALUE c_v NO-ERROR.
            IF ERROR-STATUS:ERROR THEN STOP.
          END.
        END.  /* if mru_count <= mru entries */
        ELSE DO:
          PUT-KEY-VALUE SECTION KeyValue_Section KEY filekey VALUE ? NO-ERROR.
          IF ERROR-STATUS:ERROR THEN STOP.
        END.  /* else do - mru_count > mru entries */    
      END.  /* if avail MRU_Files */
      ELSE DO:
        PUT-KEY-VALUE SECTION KeyValue_Section KEY filekey VALUE ? NO-ERROR.
        IF ERROR-STATUS:ERROR THEN STOP.
      END.  /* else do MRU_Files not avail */
      mru_count = mru_count + 1 NO-ERROR.
    END.  /* do while */    
    
    /* If we got here, then all desired save were successful. */
    ok_save = yes.

  END.  /* putprefs-block */
  
  /* Don't report save errors. They are annoying. jep. */
  /* IF ok_save = NO THEN
    RUN adeshar/_puterr.p ( INPUT "Most Recently Used File" , INPUT ProEditor ). */
  
  /* Remove internally maintained MRU Filelist */
  FOR EACH MRU_Files:
    DELETE MRU_Files.
  END.  /* for each mru */
  &ENDIF
  
END PROCEDURE.  /* ExitEditor */


PROCEDURE AddtoRepos:
  /*--------------------------------------------------------------------------
    Purpose:        Executes the Add to Repository command (Dynamics Only) on
                    the current buffer. User can then add file to repository.

    Run Syntax:     RUN AddtoRepos.
    Parameters:
    Description:
    Notes:          Added to support IZ 2513 Error when trying to save
                    structured include in Dynamics framework.
  ---------------------------------------------------------------------------*/

  DEFINE VARIABLE hWindow     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE Add_OK      AS LOGICAL   NO-UNDO. 
  DEFINE VARIABLE FileExt     AS CHARACTER NO-UNDO.
  
  DO ON STOP UNDO, LEAVE:
      /* Need window handle of this editor widget. */
      hWindow = ProEditor:WINDOW.
             
      /* Cannot add untitled / unsaved files to repository. */
      IF ProEditor:PRIVATE-DATA BEGINS Untitled THEN
      DO:
          MESSAGE "Cannot add to repository:" ProEditor:PRIVATE-DATA SKIP(1)
                  "The file must be saved before it can be added to a repository."
                  VIEW-AS ALERT-BOX INFORMATION IN WINDOW hWindow.
          RETURN.
      END.

      /* IZ 2513 Cannot add include files to repository. We can only filter on .i extensions. */
      RUN adecomm/_osfext.p
          (INPUT  ProEditor:PRIVATE-DATA  /* OS File Name.   */ ,
           OUTPUT FileExt                 /* File Extension. */ ).
      IF (FileExt = ".i":U) THEN
      DO:
        MESSAGE "Cannot add to repository:" ProEditor:PRIVATE-DATA SKIP(1)
                "Include file types cannot be added to a repository."
                VIEW-AS ALERT-BOX INFORMATION IN WINDOW hWindow.
        RETURN.
      END.
  
      /* Call to run Add to Repository dialog and add file to repository. */
      RUN adeuib/_reposaddfile.p
          (INPUT hWindow,                /* Parent Window    */
           INPUT ?,                      /* _P recid         */
           INPUT "",                     /* Product Module   */
           INPUT ProEditor:PRIVATE-DATA, /* File to add      */
           INPUT "",                     /* File type        */
           OUTPUT Add_OK).
  END.
  
END.    /* AddtoRepos */


/* pfile.i -  end of file */


/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------------
  phelp.i
  Help Procedures for Editor 
--------------------------------------------------------------------------*/



/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/********************************************************************/
/* Encrypted code which is part of this file is subject to the      */
/* Possenet End User Software License Agreement Version 1.0         */
/* (the "License"); you may not use this file except in             */
/* compliance with the License. You may obtain a copy of the        */
/* License at http://www.possenet.org/license.html                  */
/********************************************************************/

/******************************************************************************
    Procedure :	pinit.i
    Purpose   : Editor Initialization Procedures.
******************************************************************************/
    

PROCEDURE InitEditor.
/*----------------------------------------------------------------------------
Syntax:
        RUN InitEditor.

Description:

  Runs all PROGRESS Editor Initializatin routines.
  

Author: John Palazzo
----------------------------------------------------------------------------*/

  /*---------------- Initialize Stuff ----------------*/
 
  /* Set global active ade tool procedure handle to Procedure Editor. */
  ASSIGN h_ade_tool = THIS-PROCEDURE.

  RUN InitSysOpts .
  RUN InitColors .
  RUN InitTemps .
  RUN InitFileList .
  RUN InitFindReplace .
  RUN CreateFileMenuItems.  /* IZ 2513 */
  RUN InitMRUList .
  
  /*----------------------------------------------------------------------
     In GUI or CUI, always have editor set CURRENT-WINDOW to DEFAULT-WINDOW
     when about to run user's code.  This will allow user to write code
     which will behaive the same when run from the editor or as the
     PROGRESS -p startup procedure (which always uses DEFAULT-WINDOW by
     default) .
  ----------------------------------------------------------------------*/
  ASSIGN Run_Window             = DEFAULT-WINDOW
         DEFAULT-WINDOW:VISIBLE = ( SESSION:WINDOW-SYSTEM = "TTY" ) 
  .

  /* Set the advanced/color editor dialog box help file name. */
  RUN SetEdHelpFile.   /* adecomm/peditor.i */

  /*----------------------------------------------------------------------
     Open initial editor window and assign values to system defines:
     win_ProEdit, and ProEditor.
  ----------------------------------------------------------------------*/
  RUN OpenWindow.
 
  /* If no files to open on start-up, then open with untitled. */
  IF LENGTH( p_File_List ) = 0 THEN
    RUN NewFile.
  ELSE DO:
    RUN FileOpen
        ( INPUT        win_ProEdit ,
          INPUT        p_File_List ,
          INPUT        FALSE , /* Don't allow duplicates. */
          INPUT-OUTPUT ProEditor ).
    /* Be sure editor was able to find and open specified file(s). */
    FIND FIRST Edit_Buffer NO-ERROR.
    IF NOT AVAILABLE Edit_Buffer THEN RUN NewFile.
    File_Name = ProEditor:PRIVATE-DATA.
    APPLY "ENTRY" TO ProEditor.
  END.

  
END PROCEDURE . /* InitEditor. */


PROCEDURE InitSysOpts .
/*----------------------------------------------------------------------------
Syntax:
        RUN InitSysOpts .

Description:

  Initializes editor's System Options defaults.
  

Author: John Palazzo

Date Created: 11.17.92 
----------------------------------------------------------------------------*/

  CREATE Sys_Options .

  RUN SysOptsGetPut ( INPUT "GET" ) .
  IF ( SESSION:WINDOW-SYSTEM = "TTY":u ) THEN RETURN.

  /* Starting in 9.1A, Save Settings on Exit menu item was removed. Settings
     are now saved when pressing OK in each Options dialog. So we force
     the Save_Settings item to YES to ensure dependent code works and save the
     settings on startup to write the updated value to Yes. Only done one time,
     because after the one time, the value is always Yes. -jep */
  IF Sys_Options.Save_Settings <> YES THEN
  DO ON STOP UNDO, LEAVE:
    RUN OptionsSetSave(YES).
    RUN SysOptsGetPut (INPUT "PUT":U).
  END.
   
END PROCEDURE . /* InitSysOpts */


PROCEDURE InitColors .
/*----------------------------------------------------------------------------
Syntax:
        RUN InitColors .

Description:

  Initializes editor's fg/bg colors.

Author: John Palazzo
----------------------------------------------------------------------------*/

  IF ( SESSION:WINDOW-SYSTEM = "TTY" )
      THEN RETURN.
  
  /* ADE Standard Vars from adecomm/adestds.i. */
  IF ( Sys_Options.BG_Color = ? )
      THEN ASSIGN Sys_Options.BG_Color = std_ed4gl_bgcolor NO-ERROR.
  IF ( Sys_Options.FG_Color = ? )
      THEN ASSIGN Sys_Options.FG_Color = std_ed4gl_fgcolor NO-ERROR.
END PROCEDURE.



PROCEDURE InitTemps.
/*----------------------------------------------------------------------------

Syntax:
        RUN InitTemps.

Description:

  Initializes the editor's temporary file names and locations.

Author: John Palazzo

Date Created: 08.14.92 

----------------------------------------------------------------------------*/

  DO ON STOP UNDO, LEAVE:
    RUN adecomm/_tmpfile.p ( "m" , ".ped" , OUTPUT Compiler_Message_Log ).
  END.
    
END PROCEDURE . /* InitTemps. */


PROCEDURE InitFileList .
/*----------------------------------------------------------------------------
  Syntax:
        RUN InitFileList .

  Description:

    Initializes editor's startup Buffer List.
    Uses p_Edit_Command (defined in adeedit/dsystem.i).  Behavoir is as
    follows:
        1. "NEW"         - Ignore p_File_List and Saved Buffer List.  Gives
                           user Empty Untitled buffer.
        2. Anything Else - If p_File_List has value, use it.
                           Otherwise, use Saved Buffer List.
  
  Author: John Palazzo
----------------------------------------------------------------------------*/

    CASE p_Edit_Command :
        WHEN "NEW"
            THEN DO:
                /* Ignore Saved Buf List and return Null open list. */
                ASSIGN p_File_List = "".
            END.
            
        OTHERWISE
            DO:
            /*--------------------------------------------------------------
                If an ADE Tool is passing files in to the editor or the user
                passed files to the editor using -param, don't overwrite.
                Otherwise, we do use Saved Buffer List.
            --------------------------------------------------------------*/
                IF ( p_File_List = "" ) OR ( p_File_List = ? )
                THEN DO ON ERROR UNDO, LEAVE:
                    /* Reset to default Progress Environment File. */
                    USE "" NO-ERROR.
                    RUN adecomm/_kvlist.p ( INPUT "GET" ,
                                            INPUT KeyValue_Section ,
                                            INPUT "BufList",
                                            INPUT-OUTPUT Sys_Options.BufList ).
                    ASSIGN p_File_List = Sys_Options.BufList.
                END.
            END.
    END CASE.

END PROCEDURE . /* InitFileList */


PROCEDURE InitFindReplace .
/*----------------------------------------------------------------------------
  Syntax:
        RUN InitFindReplace .

  Description:

    Initializes editor's Find and Replace Alert-Box Titles.
    May some day restore Find/Replace option settings from Environment file.
    Someday.
  
  Author: John Palazzo

  Date Created: 12.10.92 

----------------------------------------------------------------------------*/

  /* These are defined in adeedit/dsearch.i and adeedit/dedit.i. 
     Used for Application Style.
  */
  ASSIGN Search_Info_Title  = Editor_Name 
         Search_Quest_Title = Editor_Name 
         Edit_Error_Title   = Editor_Name .
         
END PROCEDURE . /* InitFindReplace */

PROCEDURE InitMRUList .
/*----------------------------------------------------------------------------
  Syntax:
        RUN InitMRUList .

  Description:

    Creates MRU_Files temp table records from registry entries
      
  Author: Tammy Marshall

  Date Created: 05.11.99 

----------------------------------------------------------------------------*/
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN

  DEFINE VARIABLE mru_count AS INTEGER   NO-UNDO.
  DEFINE VARIABLE keyname   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE v         AS CHARACTER NO-UNDO.
  
  mru_count = 1.
  IF Sys_Options.MRU_Filelist THEN DO WHILE mru_count <= Sys_Options.MRU_Entries:
    keyname = "MRUFile" + STRING(mru_count).
  
    GET-KEY-VALUE SECTION "Proedit" KEY keyname VALUE v.
    IF v NE ? THEN DO:
      CREATE MRU_Files.
      ASSIGN 
        MRU_Files.mru_file = v
        MRU_Files.mru_position = mru_count.
    END.  /* if v NE ? */
    
    mru_count = mru_count + 1.
  END.  /* if mru_filelist then do while */
  &ENDIF
  
  /* We still need to run MRUMenu in TTY so that the exit menu item is
     created */
  RUN MRUMenu.
END PROCEDURE . /* InitMRUList */





/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*---------------------------------------------------------------------------
  pmenus.i
  Procedures for Editor Menus
----------------------------------------------------------------------------*/


PROCEDURE EditMenuDrop.
/*---------------------------------------------------------------------------
    Syntax     RUN EditMenuDrop ( INPUT p_Editor ) .
   
    Purpose    On the MENU-DROP event for the Edit Menu, set the enable/disable
               state of the Edit Menu selections. 
    
    Remarks    The p_Editor widget is presumed to be of :TYPE = "EDITOR".
               Must be run from a trigger, since SELF handle is used.
    
    Return Values  NONE.
---------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_Editor AS WIDGET-HANDLE NO-UNDO.
  
  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN  
    /* Works well under MS-WINDOWS only. */
    DEFINE VAR Read_Only        AS LOGICAL NO-UNDO.
    DEFINE VAR Text_Is_Selected AS LOGICAL NO-UNDO.
    DEFINE VAR hItem            AS HANDLE  NO-UNDO.

    ASSIGN
        Read_Only        = p_Editor:READ-ONLY
        Text_Is_Selected = p_Editor:TEXT-SELECTED.
   
    hItem = SELF:FIRST-CHILD NO-ERROR.
    DO WHILE VALID-HANDLE(hItem):
      CASE hItem:NAME:
        WHEN '_Undo':U        THEN hItem:SENSITIVE = ( p_Editor:EDIT-CAN-UNDO ) AND ( p_Editor:MODIFIED ).
        WHEN '_Redo':U        THEN hItem:SENSITIVE = ( p_Editor:EDIT-CAN-REDO ) AND ( p_Editor:MODIFIED ).
        WHEN '_Cut':U         THEN hItem:SENSITIVE = ( NOT Read_Only ) AND ( Text_Is_Selected ).
        WHEN '_Copy':U        THEN hItem:SENSITIVE = ( Text_Is_Selected  ).
        WHEN '_Paste':U       THEN hItem:SENSITIVE = ( p_Editor:EDIT-CAN-PASTE ) AND ( NOT Read_Only ).
        WHEN '_Insert_File':U THEN hItem:SENSITIVE = ( NOT Read_Only ).
        WHEN '_Field_Selector':U THEN hItem:SENSITIVE = ( NOT Read_Only ).
      END CASE.
      hItem = hItem:NEXT-SIBLING.
    END.

  &ENDIF
END PROCEDURE.


PROCEDURE BufferMenuDrop.
/*---------------------------------------------------------------------------
    Syntax     RUN BufferMenuDrop.
   
    Purpose    On the MENU-DROP event for the Buffer Menu, set the 
               enable/disable state of the Buffer Menu selections. 
    
    Remarks    Must be run from a trigger, since SELF handle is used.
    
    Return Values  NONE.
---------------------------------------------------------------------------*/
  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN  
  /* Works well under MS-WINDOWS only. */

  DEFINE VAR hItem            AS HANDLE  NO-UNDO.
  
  /* If more than one buffer open, enable Buffer Next and Prev. */
  RUN NumBuffers ( INPUT win_ProEdit, OUTPUT Buffers_Open ).

  hItem = SELF:FIRST-CHILD NO-ERROR.
  DO WHILE VALID-HANDLE(hItem):
    CASE hItem:NAME:
      WHEN '_Next':U  THEN hItem:SENSITIVE = ( Buffers_Open > 1 ).
      WHEN '_Prev':U  THEN hItem:SENSITIVE = ( Buffers_Open > 1 ).
    END CASE.
    hItem = hItem:NEXT-SIBLING.
  END.

  &ENDIF
      
END PROCEDURE.


PROCEDURE MenuInit .
/*---------------------------------------------------------------------------
    Syntax     RUN MenuInit . 

    Purpose    Initialize menu item accelerators and enable states.

    Remarks    

    Return Values  NONE.
---------------------------------------------------------------------------*/
  
  &IF OPSYS <> "VMS" &THEN
  RUN MenuDebugInit.
  &ENDIF

  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  /* TTY, so just return - no :accelerator or Options support. */
  RETURN.
  &ENDIF

  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  DO:
      /* Starting in 9.1A, Save Settings on Exit menu item was removed. Settings
         are now saved when pressing OK in each Preferences dialog. */
      RUN MenuAccelInit ( INPUT g_Editor_Cached_Accels ).
      
  END.  /* "MS-WINDOWS or OSF/Motif" */
  &ENDIF

END PROCEDURE.


PROCEDURE MenuAccelInit.
/*---------------------------------------------------------------------------
    Syntax     RUN MenuAccelInit( INPUT p_Accels ). 

    Purpose    Initialize/assign menu item accelerators.

    Parameters
        INPUT  p_Accels   Comma-delimited list of Menu Items and their
                          accelerators in the form:
                                
                                    "MenuLabel:Accelerator,..."
                                
                          The menu labels have all &, spaces, and ellipses
                          removed.
                          
    Remarks    Must be kept in perfect sync with adeedit/dmenus.i.
               Except for Tools Menu Accelerators, defined by the ADE
               Standards Tools Menu Include toolmenu.i.  Editor does not
               support Menu Accelerators on the Tools menu.
    Return Values  NONE.
---------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p_Accels AS CHAR NO-UNDO.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN

DEFINE VARIABLE hMenu AS HANDLE NO-UNDO.
DEFINE VARIABLE hItem AS HANDLE NO-UNDO.

hMenu = win_ProEdit:MENUBAR.
hMenu = hMenu:FIRST-CHILD.
DO WHILE VALID-HANDLE(hMenu):
  hItem = hMenu:FIRST-CHILD.
  DO WHILE VALID-HANDLE(hItem):
    /*-----------   File Menu Accelerators --------------*/
    IF CAN-DO('_New,_Open,_Close,_New_PW,_Save,_Save_as,_AddRepos,_Print,_Exit':u , hItem:NAME) THEN
      RUN MenuAccelSet (INPUT hItem, INPUT-OUTPUT p_Accels).
    /*-----------   Edit Menu Accelerators --------------*/
    ELSE IF CAN-DO('_Undo,_Cut,_Copy,_Paste,_Insert_File,_Field_Selector':u , hItem:NAME) THEN
      RUN MenuAccelSet (INPUT hItem, INPUT-OUTPUT p_Accels).
    /*-----------   Search Menu Accelerators --------------*/
    ELSE IF CAN-DO('_Find,_Find_Next,_Find_Prev,_Replace,_Goto_Line':u , hItem:NAME) THEN
      RUN MenuAccelSet (INPUT hItem, INPUT-OUTPUT p_Accels).
    /*-----------   Buffer Menu Accelerators --------------*/
    ELSE IF CAN-DO('_BuffList,_Next,_Prev,_BufFont,_BufSettings':u , hItem:NAME) THEN
      RUN MenuAccelSet (INPUT hItem, INPUT-OUTPUT p_Accels).
    /*-----------   Compile Menu Accelerators --------------*/
    ELSE IF CAN-DO('_Run,_Check_Syntax,_Debug,_Comp_Msgs':u , hItem:NAME) THEN
      RUN MenuAccelSet (INPUT hItem, INPUT-OUTPUT p_Accels).
    /*-----------   Options Menu Accelerators --------------*/
    ELSE IF CAN-DO('_Editor_Prefs,_Editing_Options,_Menu_Accels,_DefFont':u , hItem:NAME) THEN
      RUN MenuAccelSet (INPUT hItem, INPUT-OUTPUT p_Accels).
    /*-----------   Help Menu Accelerators ---------------*/
    /* Keyboard option not in the GUI Help menu. */
    ELSE IF CAN-DO('_Help_Topics,_Menu_Messages,_Menu_Recent,_About':u , hItem:NAME) THEN
      RUN MenuAccelSet (INPUT hItem, INPUT-OUTPUT p_Accels).

    /*-----------   Tools Menu Accelerators --------------*/
    /* None - See Notes in header. */

    hItem = hItem:NEXT-SIBLING.

  END.
  hMenu = hMenu:NEXT-SIBLING.
END.

RETURN.

&ENDIF

END PROCEDURE.

PROCEDURE MenuAccelSet.
/*---------------------------------------------------------------------------
    Syntax     RUN MenuAccelSet ( INPUT p_Item, INPUT-OUTPUT p_Accels ).

    Purpose    Sets a menu item's accelerator.

    Parameters
        p_Item     Handle to menu item whose accelerator to be set.
        p_Accels   Comma-delimited list of Menu Items and their
                   accelerators in the form:
                                
                      "MenuLabel:Accelerator,..."
                                
                   The menu labels have all &, spaces, and ellipses removed.
                          
    Remarks    Must be kept in perfect sync with adeedit/dmenus.i.
               Except for Tools Menu Accelerators, defined by the ADE
               Standards Tools Menu Include toolmenu.i.  Editor does not
               support Menu Accelerators on the Tools menu.
               
               Once an item's accelerator is found among the p_Accels list,
               its entry in the p_Accels list is removed. This is for local
               optimization. It does not affect the global accelerator
               list maintained by the editor.
               
    Return Values  p_Accels via OUTPUT param.
---------------------------------------------------------------------------*/

  DEFINE INPUT        PARAMETER p_Item   AS HANDLE NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER p_Accels AS CHAR  NO-UNDO.
  
  DEFINE VARIABLE iItem     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cLabel    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cListItem AS CHARACTER NO-UNDO.

  DO iItem = 1 TO NUM-ENTRIES(p_Accels):
    /* Remove the menu item label &, spaces, and ellipses. Must do this to
       correctly search the p_Accels list, which also has those chars removed.
       -jep 06/29/99 */
    ASSIGN cLabel = REPLACE(p_Item:LABEL, '&', '')
           cLabel = REPLACE(cLabel, ' ', '')
           cLabel = REPLACE(cLabel, '.', '').
    cListItem = ENTRY(iItem, p_Accels).
    IF cLabel = ENTRY(1, cListItem, ':') THEN
    DO:
      p_Item:ACCELERATOR = ENTRY(2, cListItem, ':').
      p_Accels = TRIM(REPLACE(p_Accels, cListItem, ''), ',').
      LEAVE.
    END.
  END.        

END PROCEDURE.


&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN

PROCEDURE MRUList .
/*---------------------------------------------------------------------------
    Syntax     RUN MRUList . 

    Purpose    Updates Most Recently Used File List.  This is called when a file 
               is opened or saved.  It is also called to adjust the list
               after the preference for the number of entries has changed

    Parameters
               INPUT  pcFileName - File name for the file just opened or saved

               If this is being called to adjust the number of entries, these parameter
               is blank
        
    Remarks    This logic must be keep in sync with adeshar/_mrulist.p 
               (_mrulist.p contains the same logic for the Appbuilder
               MRU Filelist)

    Return Values  NONE.
---------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcFileName  AS CHARACTER NO-UNDO.

  DEFINE VARIABLE iCount AS INTEGER INIT 0 NO-UNDO.

  FOR EACH MRU_Files USE-INDEX mru_idx_pos_desc:
    CREATE mruWork.
    BUFFER-COPY MRU_Files EXCEPT mru_position TO mruWork.
    ASSIGN mruWork.mru_position = MRU_Files.mru_position + 10.
    DELETE MRU_Files.
  END.  /* for each MRU_Files */

  IF pcFileName NE "":U THEN DO:
    FIND mruWork WHERE mruWork.mru_file = pcFileName NO-ERROR.
    IF AVAILABLE mruWork THEN ASSIGN mruWork.mru_position = 1. 
    ELSE DO:
      CREATE mruWork.
      ASSIGN mruWork.mru_file     = pcFileName
             mruWork.mru_position = 1.
    END.  /* else do - not avail mruWork */
  END.  /* if filename NE "" */

  FOR EACH mruWork:
    iCount = iCount + 1.
    IF iCount <= Sys_Options.MRU_Entries THEN DO:
      CREATE MRU_Files.
      ASSIGN MRU_Files.mru_position = iCount
             MRU_Files.mru_file     = mruWork.mru_file.
    END.  /* if iCound less than or equal to file list */
    DELETE mruWork.
  END.  /* for each mruWork */

  RUN MRUMenu.  

END PROCEDURE.

&ENDIF

PROCEDURE MRUMenu .
/*---------------------------------------------------------------------------
    Syntax     RUN MRUMenu . 

    Purpose    Creates menu items for MRU FileList.

    Remarks    

    Return Values  NONE.
---------------------------------------------------------------------------*/

DEFINE VARIABLE cAbbrevName AS CHARACTER          NO-UNDO.
DEFINE VARIABLE cExitAccel  AS CHARACTER          NO-UNDO.
DEFINE VARIABLE i           AS INTEGER            NO-UNDO.
DEFINE VARIABLE hFileMenu   AS HANDLE             NO-UNDO.
  
  /* editor.i */
  RUN GetFileMenu (OUTPUT hFileMenu).

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN

  i = 1.
  DO WHILE i < 10:
    IF VALID-HANDLE(mi_mrulist[i]) THEN DELETE WIDGET mi_mrulist[i].
    i = i + 1. 
  END.  /* do while */
  IF VALID-HANDLE(mi_rule) THEN DELETE WIDGET mi_rule.
  IF VALID-HANDLE(mi_Exit) THEN DO:
    ASSIGN cExitAccel = mi_Exit:ACCELERATOR.
    DELETE WIDGET mi_Exit.
  END.  /* if mi_Exit valid */
  
  FOR EACH MRU_Files:
    /* Get abbreviated filename to display in menu */
    RUN adecomm/_ossfnam.p 
      (INPUT MRU_Files.mru_file, 
       INPUT 30,
       INPUT ?,
       OUTPUT cAbbrevName).
    CREATE MENU-ITEM mi_mrulist[MRU_Files.mru_position]
      ASSIGN PARENT = hFileMenu
             LABEL = STRING(MRU_Files.mru_position) + " ":U + cAbbrevName
             TRIGGERS: ON CHOOSE PERSISTENT RUN OpenMRUFile (MRU_Files.mru_position). END TRIGGERS.
  END.  /* for each MRU_Files */
  FIND FIRST MRU_Files NO-ERROR.
  IF AVAIL MRU_Files THEN 
    CREATE MENU-ITEM mi_rule
      ASSIGN SUBTYPE = "RULE"
             PARENT  = hFileMenu.
          
&ENDIF
  
  CREATE MENU-ITEM mi_Exit
    ASSIGN NAME        = "_Exit"
           PARENT      = hFileMenu
           LABEL       = "E&xit"
           ACCELERATOR = cExitAccel
    TRIGGERS: ON CHOOSE PERSISTENT RUN ExitEditor. END TRIGGERS.

END PROCEDURE.  /* mru_menu */


PROCEDURE CreateFileMenuItems .
/*---------------------------------------------------------------------------
    Syntax     RUN CreateFileMenuItems . 

    Purpose    Creates these File menu items after Save As menu item:
    
               Add to Repos (Dynamics only)
               Rule
               Print
               Rule

    Remarks    Needed these menu items to be dynamic so 'Add to Repository'
               could be optionally added to the File menu if Dynamics is
               running.
               
               Added to support IZ 2513 Error when trying to save structured
               include in Dynamics framework.

    Return Values  NONE.
---------------------------------------------------------------------------*/

  DEFINE VARIABLE hFileMenu     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lIsICFRunning AS LOGICAL    NO-UNDO.

  /* Establish if Dynamics is running. */
   ASSIGN lIsICFRunning = DYNAMIC-FUNCTION("IsICFRunning":U) NO-ERROR.
   ASSIGN lIsICFRunning = (lIsICFRunning = YES) NO-ERROR.

  /* editor.i */
  RUN GetFileMenu (OUTPUT hFileMenu).

  IF lIsICFRunning THEN
  DO:
    CREATE MENU-ITEM mi_AddRepos
      ASSIGN NAME        = "_AddRepos"
             PARENT      = hFileMenu
             LABEL       = "Add to &Repository..."
      TRIGGERS: ON CHOOSE PERSISTENT RUN AddtoRepos. END TRIGGERS.
  END.

  CREATE MENU-ITEM mi_rule_pr1
      ASSIGN SUBTYPE = "RULE"
             PARENT  = hFileMenu.

  CREATE MENU-ITEM mi_Print
    ASSIGN NAME        = "_Print"
           PARENT      = hFileMenu
           LABEL       = IF OPSYS = "UNIX":U THEN "&Print" ELSE "&Print..."
    TRIGGERS: ON CHOOSE PERSISTENT RUN FilePrintCall. END TRIGGERS.

  CREATE MENU-ITEM mi_rule_pr2
      ASSIGN SUBTYPE = "RULE"
             PARENT  = hFileMenu.

END PROCEDURE.  /* CreateFileMenuItems */
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*****************************************************************************

    Procedure  :  psysgetf.i

    Syntax     :
                  { adeedit/psysgetf.i }

    Description:

        Generic GET-FILE Procedures. Eg, File Open, File Save As, etc...
        dialog boxes.

    Notes     : Definition file is dsysgetf.i .

    Author    : John Palazzo
    Date      : 02.09.93

*****************************************************************************/

PROCEDURE SysGetFile .
  /*---------------------------------------------------------------------
    Purpose : Runs the appropriate Get-File (Open or Save As) dialog box,
              and returns the file spec and dialog status (ie, did user
              press OK or Cancel?)

    Syntax  :
    
        RUN SysGetFile 
            ( INPUT p_Title ,
              INPUT p_Save_As ,
              INPUT p_Initial_Filter ,
              INPUT-OUTPUT p_File_Spec ,
              OUTPUT p_Return_Status ) .
  ---------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER p_Title            AS CHAR    NO-UNDO.
  DEFINE INPUT  PARAMETER p_Save_As          AS LOGICAL NO-UNDO.
  DEFINE INPUT  PARAMETER p_Initial_Filter   AS INTEGER INIT 1 NO-UNDO .
  DEFINE INPUT-OUTPUT PARAMETER p_File_Spec  AS CHAR    NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Return_Status    AS LOGICAL INIT FALSE NO-UNDO.

  DEFINE VARIABLE vOptions     AS CHAR NO-UNDO.
  DEFINE VARIABLE vInitial_Dir AS CHAR NO-UNDO.

  DO: /* Main */
  /*------------------------------------------------------------ 
     If nothing passed for Title, use one of the defaults. 
  ------------------------------------------------------------*/
  IF ( TRIM( p_Title ) = "" ) THEN
      ASSIGN p_Title = IF ( p_Save_As = TRUE )
                       THEN "Save As"
                       ELSE "Open".
  
  RUN InitFilters.
  
  IF ( SESSION:WINDOW-SYSTEM <> "TTY" ) THEN
  DO:
    REPEAT ON STOP UNDO, LEAVE:
      IF ( p_Save_As = YES ) THEN
      DO:
        SYSTEM-DIALOG GET-FILE p_File_Spec
        FILTERS  Filter_NameString[ 1 ]   Filter_FileSpec[ 1 ],
                 Filter_NameString[ 2 ]   Filter_FileSpec[ 2 ],
                 Filter_NameString[ 3 ]   Filter_FileSpec[ 3 ],
                 Filter_NameString[ 4 ]   Filter_FileSpec[ 4 ],
                 Filter_NameString[ 5 ]   Filter_FileSpec[ 5 ],
                 Filter_NameString[ 6 ]   Filter_FileSpec[ 6 ]
        INITIAL-FILTER p_Initial_Filter
        SAVE-AS USE-FILENAME ASK-OVERWRITE CREATE-TEST-FILE
        TITLE p_Title UPDATE p_Return_Status IN WINDOW ACTIVE-WINDOW.
        IF p_Return_Status <> TRUE THEN LEAVE.
        RUN adecomm/_valpnam.p
            (INPUT  p_File_Spec, INPUT YES /* Show Msg */, INPUT "_EXTERNAL":U,
             OUTPUT p_Return_Status).
        IF p_Return_Status = TRUE THEN LEAVE.
      END.
      ELSE  /* Open Dialog */
      DO:
        SYSTEM-DIALOG GET-FILE p_File_Spec
        FILTERS  Filter_NameString[ 1 ]   Filter_FileSpec[ 1 ],
                 Filter_NameString[ 2 ]   Filter_FileSpec[ 2 ],
                 Filter_NameString[ 3 ]   Filter_FileSpec[ 3 ],
                 Filter_NameString[ 4 ]   Filter_FileSpec[ 4 ],
                 Filter_NameString[ 5 ]   Filter_FileSpec[ 5 ],
                 Filter_NameString[ 6 ]   Filter_FileSpec[ 6 ]
        INITIAL-FILTER p_Initial_Filter
        MUST-EXIST 
        TITLE p_Title UPDATE p_Return_Status IN WINDOW ACTIVE-WINDOW.
        IF p_Return_Status <> TRUE THEN LEAVE.
        RUN adecomm/_valpnam.p
            (INPUT  p_File_Spec, INPUT YES /* Show Msg */, INPUT "_EXTERNAL":U,
             OUTPUT p_Return_Status).
        IF p_Return_Status = TRUE THEN LEAVE.
      END.
    END. /* ON STOP */
  END.
  ELSE DO:
     ASSIGN vOptions = "ASK-OVERWRITE,MUST-EXIST" .
     
     /* Its possible that p_File_Spec is a dir name, so try and
        use it as the p_Dir name (pass in) and blank out the
        p_File_Spec. */
     ASSIGN vInitial_Dir = p_File_Spec
            p_File_Spec  = "".

    REPEAT ON STOP UNDO, LEAVE:
      RUN adecomm/_filecom.p
        ( INPUT "" /* p_Filter */, 
          INPUT vInitial_Dir /* p_Dir */ , 
          INPUT "" /* p_Drive */ ,
          INPUT p_Save_As ,  
          INPUT p_Title ,
          INPUT vOptions , 
          INPUT-OUTPUT p_File_Spec ,
          OUTPUT p_Return_Status ).
        IF p_Return_Status <> TRUE THEN LEAVE.
        RUN adecomm/_valpnam.p
            (INPUT  p_File_Spec, INPUT YES /* Show Msg */, INPUT "_EXTERNAL":U,
             OUTPUT p_Return_Status).
        IF p_Return_Status = TRUE THEN LEAVE.
    END.
  END.

  END. /* Main */
END PROCEDURE.


PROCEDURE InitFilters.
/*----------------------------------------------------------------------------
Syntax:
        RUN InitFilters.

Description:

  Initializes the File Filters for SYSTEM-DIALOG GET-FILE.

Author: John Palazzo

Date Created: 08.14.92
----------------------------------------------------------------------------*/

  DEFINE VARIABLE List_Pos AS INTEGER NO-UNDO.

    ASSIGN Filter_NameString[ 1 ] = IF OPSYS = "UNIX"
                                      THEN "All Source(*.[piw])"
                                      ELSE "All Source(*.p~;*.i~;*.w)"
           Filter_FileSpec[ 1 ]   = IF OPSYS = "UNIX"
                                      THEN "*.[piw]"
                                      ELSE "*.p~;*.i~;*.w"

           Filter_NameString[ 2 ] = "Procedures(*.p)"
           Filter_FileSpec[ 2 ]   = "*.p"

           Filter_NameString[ 3 ] = "Includes(*.i)"
           Filter_FileSpec[ 3 ]   = "*.i"

           Filter_NameString[ 4 ] = "Windows(*.w)"
           Filter_FileSpec[ 4 ]   = "*.w"

           Filter_NameString[ 5 ] = IF OPSYS = "UNIX"
                                      THEN "All Files(*)"
                                      ELSE "All Files(*.*)"
           Filter_FileSpec[ 5 ]   = IF OPSYS = "UNIX"
                                      THEN "*"
                                      ELSE "*.*"
    . /* END-ASSIGN */

    DO List_Pos = 1 TO 6:
      Filter_Desc    = Filter_Desc + Filter_NameString[ List_Pos ] +
                       IF List_Pos = 6
                         THEN ","
                         ELSE "".  /* Omit last comma in list */
      Filter_Pattern = Filter_Pattern + Filter_FileSpec[ List_Pos ] +
                       IF List_Pos = 6
                         THEN ","
                         ELSE "".  /* Omit last comma in list */
    END. /* DO */

END PROCEDURE . /* InitFilters. */
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------------
  psystem.i 
  System-wide Procedures for Editor
--------------------------------------------------------------------------*/


PROCEDURE ExecuteRun.
  /*--------------------------------------------------------------------------
    Purpose:	    Handles Editor's integration when it "RUNs" a procedure.
    Run Syntax:     RUN ExecuteRun 
		      ( INPUT p_Edit_Window, 
			INPUT p_Execute_Window, 
			INPUT p_Execute_Title ,
			INPUT p_Run_File ,
			INPUT p_Never_Pause ).
    Parameters:
            p_Never_Pause    (LOGICAL)
                Tool calls and the editor running an os file directly
                should never pause after running.  This allows for control
                of that behavoir.

    Description:
    Notes:
		    References the system-wide FRAME f_Buffers and
		    ProEditor widgets.
  --------------------------------------------------------------------------*/
  
    DEFINE INPUT PARAMETER p_Edit_Window     AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p_Execute_Window  AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p_Execute_Title   AS CHARACTER     NO-UNDO.
    DEFINE INPUT PARAMETER p_Run_File	     AS CHARACTER     NO-UNDO.
    DEFINE INPUT PARAMETER p_Never_Pause     AS LOGICAL       NO-UNDO.

    DEFINE VARIABLE Run_Flags AS CHARACTER NO-UNDO.

    DEFINE VARIABLE app_handle AS HANDLE NO-UNDO.

    
    REPEAT ON QUIT       , RETRY
           ON STOP   UNDO, RETRY
           ON ERROR  UNDO, RETRY
           ON ENDKEY UNDO, RETRY:
           
        IF NOT RETRY
        THEN DO:
            RUN DisableEditor
                ( INPUT p_Edit_Window, 
                  INPUT p_Execute_Window, 
                  INPUT p_Execute_Title ,
                  INPUT p_Run_File ).
                  
            IF ( SESSION:WINDOW-SYSTEM <> "TTY" )
            THEN DO:
                RUN WinStatusMsg 
                    ( INPUT p_Edit_Window , INPUT "MT_INPUT" , 
                      INPUT "Running " + Proeditor:PRIVATE-DATA + " ...",
                      INPUT "" ) .
             END.
            
	    /* Auto-cleanup orphaned dynamic widgets? */
	    IF ( Sys_Options.Auto_Cleanup = NO ) THEN
                ASSIGN Run_Flags = "_KEEP-WIDGETS":U.
            
            /* Only pause when told to do so. */
            IF ( Sys_Options.Pause_AfterRun = YES ) AND
               ( p_Never_Pause = FALSE ) THEN
                ASSIGN Run_Flags = Run_Flags + "," + "_PAUSE":U.

            DO ON QUIT     , LEAVE
               ON STOP UNDO, LEAVE:
              RUN adecomm/_runcode.p
                  ( INPUT p_Run_File   ,
                    INPUT Run_Flags ,
                    INPUT ?     /* p_Stop_Widget */,
                    OUTPUT app_handle ) .
            END.
      
        END.
        RUN EnableEditor
            ( INPUT p_Edit_Window, 
              INPUT p_Execute_Window, 
              INPUT p_Execute_Title ,
              INPUT p_Run_File ,
              INPUT p_Never_Pause ).
        LEAVE.
    END.
    
END PROCEDURE.    


PROCEDURE DisableEditor .
  /*--------------------------------------------------------------------------
    Purpose:	    Handles Disabling Editor before running user code
                    or another ADE Tool.
    
    Run Syntax:     RUN DisableEditor 
		      ( INPUT p_Edit_Window, 
			INPUT p_Execute_Window, 
			INPUT p_Execute_Title ,
			INPUT p_Run_File ).
    Parameters:

    Description:
    Notes       : References the system-wide Edit_Win_State var.
  --------------------------------------------------------------------------*/
  
    DEFINE INPUT PARAMETER p_Edit_Window     AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p_Execute_Window  AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p_Execute_Title   AS CHARACTER     NO-UNDO.
    DEFINE INPUT PARAMETER p_Run_File	     AS CHARACTER     NO-UNDO.
    
    DEFINE VAR Temp_Logical   AS LOGICAL NO-UNDO.
    
    /*---------------------------------------------------------------- 
       Need to trap in case CTRL-C while editor is disabled and while
       running program.
    ----------------------------------------------------------------*/
 /*   
    DISABLE_BLOCK:
    DO ON STOP UNDO DISABLE_BLOCK , LEAVE DISABLE_BLOCK :
  */    

        /* Unset global active ade tool variable. */
        ASSIGN h_ade_tool = ?.

	/* Reset Progress Session defaults for execute window. */
	RUN SessionDefaults ( INPUT p_Execute_Window ) .

	IF ( SESSION:WINDOW-SYSTEM <> "TTY" )
	THEN DO:  /* GUI */
	  ASSIGN Edit_Win_State = p_Edit_Window:WINDOW-STATE.
          IF ( Sys_Options.Minimize_BeforeRun = YES )
          THEN DO:
                ASSIGN p_Edit_Window:WINDOW-STATE = WINDOW-DELAYED-MINIMIZE.
                RUN adecomm/_pwwinst.p (INPUT Editor_Name /* Parent ID */ ,
                                        INPUT WINDOW-MINIMIZED ).
          END.
	    
	  /* Disable the Editor Window menubar items. */
	  RUN EnableEditWin ( INPUT p_Edit_Window, 
                              INPUT FALSE /* disable */ ).

	  ASSIGN p_Execute_Window:SENSITIVE = TRUE
		 p_Execute_Window:TITLE   = p_Execute_Title
		 p_Execute_Window:MENUBAR = ?
		 CURRENT-WINDOW 	  = p_Execute_Window
		 .
	END.
	ELSE DO: /* TTY */
            ASSIGN p_Execute_Window:MENUBAR = ?.
        END.
        
        /* Ensure the Procedure Editor does not have focus when running
           user's code by "killing" FOCUS - that is, making it null.
        */
        RUN KillFocus ( INPUT p_Execute_Window ,
                        INPUT FRAME f_Buffers:HANDLE ).
        
    /*
    END. /* DISABLE_BLOCK */
    */
    
END PROCEDURE.


PROCEDURE EnableEditor .
  /*--------------------------------------------------------------------------
    Purpose:	    Handles Enabling Editor after running user code
                    or another ADE Tool.
    
    Run Syntax:     RUN EnableEditor 
		      ( INPUT p_Edit_Window, 
			INPUT p_Execute_Window, 
			INPUT p_Execute_Title ,
			INPUT p_Run_File ,
			INPUT p_Never_Pause ).
    Parameters:
            p_Never_Pause    (LOGICAL)
                Tool calls and the editor running an os file directly
                should never pause after running.  This allows for control
                of that behavoir.

    Description :
    Notes       : References the system-wide FRAME f_Buffers and
                  ProEditor widgets and Edit_Win_State var.
  --------------------------------------------------------------------------*/
  
    DEFINE INPUT PARAMETER p_Edit_Window     AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p_Execute_Window  AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p_Execute_Title   AS CHARACTER     NO-UNDO.
    DEFINE INPUT PARAMETER p_Run_File	     AS CHARACTER     NO-UNDO.
    DEFINE INPUT PARAMETER p_Never_Pause     AS LOGICAL       NO-UNDO.
    
    DEFINE VAR Temp_Logical   AS LOGICAL NO-UNDO.
    
    PAUSE_BLOCK : 
    REPEAT ON STOP UNDO PAUSE_BLOCK , RETRY PAUSE_BLOCK :

      /* Set global active ade tool procedure handle to Procedure Editor. */
      ASSIGN h_ade_tool = THIS-PROCEDURE.

      /******************************************************************
         I want this block executed whether there's a retry or not
         a retry condition. Its the code to re-enable the editor.
         Progress' default behavior is to override an UNDO RETRY with
         UNDO LEAVE if the RETRY block has no user interaction and has
         not evaluated the RETRY function.  This next statement forces 
         a RETRY evaluation and allows the execution to continue with
         the rest of the code. Got it?  - jep  11/18/94
      ******************************************************************/

      IF RETRY = (NOT RETRY) THEN RETURN.
      
      /* Reset Progress Session defaults for execute window. */
      RUN SessionDefaults ( INPUT p_Execute_Window ) .

      /* Post-run reset. */    
      IF ( SESSION:WINDOW-SYSTEM <> "TTY" )
      THEN DO:
        /* Reset major attributes for execute window (font, title etc. */
        RUN DefWinReset ( INPUT p_Execute_Window ).
	/* Re-enable Editor Window. */
	RUN EnableEditWin ( INPUT p_Edit_Window, INPUT TRUE /* enable */ ).
 	ASSIGN CURRENT-WINDOW = p_Edit_Window.
      END.
      ELSE DO:
          ASSIGN p_Edit_Window:MENUBAR = MENU mnb_ProEdit:HANDLE .
      END.
     
      ASSIGN Temp_Logical = p_Edit_Window:LOAD-MOUSE-POINTER("").
      
      IF ( SESSION:WINDOW-SYSTEM <> "TTY" ) AND
         ( Sys_Options.Restore_AfterRun = YES )
      THEN DO:
        /*-----------------------------------------------------------
            Restore Editor window state:
                - MSW  : Return to previous state.
                - MOTIF: Return to Normal state. Does not support
                         return to Maximized.
                       
            Restore Procedure Window states:
                - Restore all Procedure Windows.
                - Restore to Normal state always.
        -----------------------------------------------------------*/
        RUN adecomm/_pwwinst.p (INPUT Editor_Name /* Parent ID */ ,
                                INPUT WINDOW-NORMAL ).
        IF ( p_Edit_Window:WINDOW-STATE = WINDOW-MINIMIZED )
            THEN ASSIGN p_Edit_Window:WINDOW-STATE = WINDOW-NORMAL .
      END.

      IF ( SESSION:WINDOW-SYSTEM <> "TTY":U ) THEN
          /* In GUI, ensure Editor was not hidden by user code. */
          ASSIGN p_Edit_Window:HIDDEN = FALSE.
      ELSE DO:
          /* f_Buffers is a system-wide reference. */ 
          /* No need to re-VIEW under GUI, just TTY.  Re-viewing under GUI
             here can cause buffer ordering problems. */
          VIEW FRAME f_Buffers IN WINDOW p_Edit_Window.
          RUN WinSetTitle( INPUT p_Edit_Window , 
                           INPUT ProEditor:PRIVATE-DATA ).
      END.

      RUN WinStatusMsg ( p_Edit_Window , "MT_INPUT" , "" , "" ) .
      APPLY "ENTRY" TO ProEditor.
      LEAVE PAUSE_BLOCK.
    END.  /* PAUSE_BLOCK */
      
    /* Ensure the delayed minimize window state is cleared. Fixes 97-08-13-040. */
    IF ( SESSION:WINDOW-SYSTEM <> "TTY" ) THEN
        ASSIGN p_Edit_Window:WINDOW-STATE = p_Edit_Window:WINDOW-STATE.
    RETURN.  /* Use to reset RETURN-VALUE function to Null (""). */

END PROCEDURE.


PROCEDURE KillFocus .
  /*--------------------------------------------------------------------------
    Purpose:        Kills FOCUS so its no longer in Procedure Editor.
    Run Syntax:
        RUN KillFocus ( INPUT p_Execute_Window ,
                        INPUT p_hFrame ).
                        
    Parameters:
    
    Description:
        1. Ensures the Procedure Editor does not have focus
           when it becomes disabled before running user's code.
        2. User can no longer access the Procedure Editor handle via
           FOCUS or FRAME-VALUE when their code runs.
    
    Notes:
        1. To move focus out of Editor, we move focus into a temp editor
           widget and then delete the widget.  Also...
        2. We Apply entry to the execute window.
        
        One and Two together move FOCUS out to nowhere (null focus) and
        deacticates FRAME-VALUE until user actives it. 
        
        This only works for GUI, not TTY.
  --------------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_Execute_Window  AS WIDGET-HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p_hFrame          AS WIDGET-HANDLE NO-UNDO.

  DEFINE VARIABLE hTempEd                  AS WIDGET-HANDLE NO-UNDO.
  
  
  DO ON STOP UNDO, LEAVE:
  
      /* Create a temp editor widget. We'll put focus in it, then destroy
         it before running user's code. This ensures the Procedure Editor
         will not have focus when the user's code runs. User can no longer
         access the Procedure Editor handle via FOCUS or FRAME-VALUE when 
         their code runs.
      */
      CREATE EDITOR hTempEd
        ASSIGN HIDDEN    = TRUE
               FRAME     = p_hFrame
               SENSITIVE = TRUE
        . /* ASSIGN */
      APPLY "ENTRY" TO hTempED.
      ASSIGN hTempEd:SENSITIVE = FALSE.
  
  END. /* DO ON STOP */
  
  /* Destory the temp focus editor.  Progress puts focus nowhere, so the
     Editor will not have it. Note the VALID-HANDLE check prevents the
     DELETE WIDGET from executing if some stop condition occurred
     before hTempEd got created.
     
     The APPLY ensures we move focus out of the Editor window under
     Motif.
  */
  IF VALID-HANDLE( hTempEd )
    THEN DELETE WIDGET hTempED.
  IF VALID-HANDLE( p_Execute_Window )
    THEN APPLY "ENTRY" TO p_Execute_Window.
  
  RETURN.
  
END PROCEDURE.	/* KillFocus. */


PROCEDURE DefWinReset.
  /*--------------------------------------------------------------------------
    Purpose:        Resets a window's attributes to the Progress 
                    Initial window defaults.

    Run Syntax:     RUN DefWinReset( INPUT p_Window ).

    Parameters:     INPUT p_Window  - Window to reset.

    Description:
    Notes:
  --------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p_Window AS WIDGET-HANDLE NO-UNDO.
    
    DEFINE VAR Default_Win AS WIDGET-HANDLE NO-UNDO.
    
    /* proc-main */
    REPEAT ON STOP UNDO, RETRY:
        IF ( SESSION:WINDOW-SYSTEM = "TTY" ) THEN RETURN.
        IF NOT RETRY
        THEN DO:
            CREATE WINDOW Default_Win.
            ASSIGN
                p_Window:FONT    = Default_Win:FONT
                p_Window:BGCOLOR = Default_Win:BGCOLOR
                p_Window:FGCOLOR = Default_Win:FGCOLOR
                p_Window:TITLE   = Default_Win:TITLE
                p_Window:MENUBAR = ?
                p_Window:VIRTUAL-WIDTH   = Default_Win:VIRTUAL-WIDTH
                p_Window:VIRTUAL-HEIGHT  = Default_Win:VIRTUAL-HEIGHT
                p_Window:MAX-WIDTH   = Default_Win:MAX-WIDTH
                p_Window:MAX-HEIGHT  = Default_Win:MAX-HEIGHT
                p_Window:MIN-WIDTH   = Default_Win:MIN-WIDTH
                p_Window:MIN-HEIGHT  = Default_Win:MIN-HEIGHT
                p_Window:WIDTH   = Default_Win:WIDTH
                p_Window:HEIGHT  = Default_Win:HEIGHT
            . /* END-ASSIGN */
        END.
        DELETE WIDGET Default_Win.
        LEAVE.
    END.
    
END PROCEDURE.


PROCEDURE GetFile.  
  /*--------------------------------------------------------------------------
    Purpose:        Open a file from disk, or if the file is already open
                    in a buffer, make it the current buffer.

    Run Syntax:     RUN GetFile
                      ( INPUT p_File_Name ,
                        INPUT-OUTPUT p_Current_Buffer ,
                        OUTPUT p_Return_Status ) .

    Parameters:

    Description:
    Notes:
  --------------------------------------------------------------------------*/

  DEFINE INPUT        PARAMETER p_File_Name      AS CHAR NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER p_Current_Buffer AS WIDGET-HANDLE NO-UNDO.
  DEFINE OUTPUT       PARAMETER p_Return_Status  AS LOGICAL NO-UNDO.

  DEFINE VAR Fullpath_Buffer_Name AS CHAR NO-UNDO.

  /* References to system editor vars here. */
  DO:
      FILE-INFO:FILENAME   = p_File_Name .
      Fullpath_Buffer_Name = FILE-INFO:FULL-PATHNAME.
      /*----------------------------------------------------------------
         Be sure we can find file. User may have renamed or deleted it.
         Don't search for Edit_Buffer with File_Name = ? because
         that finds the first Untitled buffer.
      ----------------------------------------------------------------*/
      IF ( Fullpath_Buffer_Name <> ? ) 
      THEN FIND FIRST Edit_Buffer WHERE ( Edit_Buffer.File_Name =
                                          Fullpath_Buffer_Name )
                                  NO-ERROR.

      IF AVAILABLE( Edit_Buffer ) AND ( Fullpath_Buffer_Name <> ? )
      THEN DO:  /* File already open in editor buffer. */
        /* If its not already the current buffer, make it current. */
        IF ( p_Current_Buffer <> Edit_Buffer.hBuffer )
        THEN DO:
         &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
         /* To avoid flashing in tty, hide current buffer. */
         ASSIGN p_Current_Buffer:VISIBLE = FALSE NO-ERROR.
         &ENDIF

          p_Current_Buffer = Edit_Buffer.hBuffer .
          File_Name = p_Current_Buffer:PRIVATE-DATA.
          RUN MakeCurrent ( INPUT Edit_Buffer.hWindow ,
                            INPUT Edit_Buffer.hBuffer ).
        END.
        p_Return_Status = TRUE.
      END.
      ELSE IF ( Fullpath_Buffer_Name <> ? )
      THEN DO: /* File on disk but not open in buffer. */
        /* Go open the file from the operating system. */
        RUN FileOpen ( INPUT win_ProEdit , INPUT p_File_Name ,
                       INPUT TRUE ,
                       INPUT-OUTPUT p_Current_Buffer ).
        p_Return_Status = TRUE.
      END.
      ELSE DO: /* Can't find file with error. */
        p_Return_Status = FALSE.
      END.
      RETURN .
  END.

END PROCEDURE .



PROCEDURE SessionDefaults.
  /*--------------------------------------------------------------------------
    Purpose:	    Reset Progress Session defaults for specfied window.
    Run Syntax:     RUN SessionDefaults ( INPUT p_Window ).
    Parameters:     p_Window : Handle to window to set session defaults.
    Description:
    Notes:
  --------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Window AS WIDGET-HANDLE NO-UNDO.

  DEFINE VAR Temp_Var   AS LOGICAL NO-UNDO.
  DEFINE VAR Immed_Disp AS LOGICAL NO-UNDO.

  /* Most important after run.  Must be sure user wait state is cleared. */
  ASSIGN 
      Temp_Var = SESSION:SET-WAIT-STATE("")
      Temp_Var = p_Window:LOAD-MOUSE-POINTER("")
  NO-ERROR . /* END ASSIGN */

  /* Hide the execute window. */
  HIDE p_Window.
	  
  /* Clear the execute window.		    */
  HIDE ALL NO-PAUSE IN WINDOW p_Window .
	
  /* Clear previous messages.*/
  HIDE MESSAGE NO-PAUSE IN WINDOW p_Window .

  /* Reset Status Input and Default to PROGRESS defaults. */
  /* Needed to force display of status using IMMEDIATE-DISPLAY. */
  ASSIGN Immed_Disp = SESSION:IMMEDIATE-DISPLAY
         SESSION:IMMEDIATE-DISPLAY = TRUE.
  STATUS DEFAULT IN WINDOW p_Window .
  STATUS INPUT	 IN WINDOW p_Window .
  ASSIGN SESSION:IMMEDIATE-DISPLAY = Immed_Disp.
	
  /* Default PAUSE processsing. 	    */	
  PAUSE IN WINDOW p_Window BEFORE-HIDE.
  
  /* Be certain to reset to default Progress Environment File. */
  USE "" NO-ERROR.
       
  /* In TTY, Use Message area for R-T errors. GUI: Use Alert-Boxes. */
  ASSIGN SESSION:SYSTEM-ALERT-BOXES = ( SESSION:WINDOW-SYSTEM <> "TTY" ) .
  
  /* Set DATA-ENTRY-RETURN to appropriate default for window system. */
  ASSIGN SESSION:DATA-ENTRY-RETURN  = ( SESSION:WINDOW-SYSTEM = "TTY" ) . 
  
  &IF ( "{&WINDOW-SYSTEM}" <> "TTY" ) &THEN
  /* Bring the default execution window (DEFAULT-WINDOW) topmost.  This
     does not mean its made visible.  It just means that if the user displays
     or gets input from it, by default the window will be brought to the
     top.  See bug 92-12-23-023. jep */
  Temp_Var = p_Window:MOVE-TO-TOP().
  &ENDIF

END PROCEDURE.


PROCEDURE EnableEditWin .

  /*--------------------------------------------------------------------------
    Purpose:        Enables/Disables an Editor Window and all its buffers.
    Run Syntax:     RUN EnableEditWin ( INPUT p_Window, INPUT p_Enabled ).
    Parameters:
    Description:
		    1. Enables/Disables window menubar and all window edit 
		       buffers.
    Notes:
  --------------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_Window  AS WIDGET-HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p_Enabled AS LOGICAL       NO-UNDO.

  DEFINE VARIABLE hMenubar         AS WIDGET-HANDLE NO-UNDO.
  DEFINE VARIABLE hBuffer          AS WIDGET-HANDLE NO-UNDO.
  
  ASSIGN
      hMenubar                  = p_Window:MENUBAR
      hMenubar:SENSITIVE        = p_Enabled
      FRAME f_Buffers:SENSITIVE = p_Enabled
  . /* END ASSIGN */
  
  /* Set SENSITIVE state of all Editor buffers. */
  ASSIGN hBuffer = FRAME f_Buffers:FIRST-CHILD   /* Field Group         */
         hBuffer = hBuffer:FIRST-CHILD           /* First Editor Buffer */
  . /* ASSIGN */
  DO WHILE VALID-HANDLE( hBuffer ) :
    ASSIGN hBuffer:SENSITIVE = p_Enabled
           hBuffer           = hBuffer:NEXT-SIBLING
    . /* ASSIGN */
  END.
  
END PROCEDURE.	/* EnableEditWin. */


PROCEDURE RunProc.
  /*--------------------------------------------------------------------------
    Purpose:        Runs a specified procedure file.

    Run Syntax:     RUN RunProc ( INPUT p_Run_Procedure ,
                                  INPUT p_Never_Pause ) .

    Parameters:
        Input Parameters
            p_Run_Procedure  (CHAR)
                Operating system name of Progress Procedure to be run.

	    p_Never_Pause    (LOGICAL)
		Tool calls and the editor running an os file directly
		should never pause after running.  This allows for control
		of that behavoir.

    Description:

    Notes:
  ---------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Run_Procedure AS CHAR    NO-UNDO.
  DEFINE INPUT PARAMETER p_Never_Pause   AS LOGICAL NO-UNDO.

  RunProc_Block:
  DO ON STOP UNDO RunProc_Block , RETRY RunProc_Block :

    IF NOT RETRY
    THEN RUN ExecuteRun
             ( INPUT win_Proedit,
               INPUT Run_Window,
               INPUT Editor_Name + " - Run",
               INPUT p_Run_Procedure ,
	       INPUT p_Never_Pause ).
             
  END. /* RunProc_Block */

  RETURN.
  
END PROCEDURE.  


PROCEDURE SysOptsGetPut .
 
/*----------------------------------------------------------------------------

  Syntax:
	RUN SysOptsGetPut .

  Description:

    Reads/Saves Editor System Options settings from current PROGRESS 
    Environment file (e.g., PROGRESS.INI or .Xdefaults) and assigns them 
    to the System Var worktable which holds the settings during an editor 
    session.

  Parameters
 INPUT p_Mode CHAR
    "GET"  :  Reads System Options from current Env. file.

    "PUT"  : Saves System Options to current Env. file.
    If Save_Settings = NO, saves only this setting.
    Otherwise, saves all settings.

    "PUT_SAVE" : Saves all System Options regardless of the
    Save_Settings setting.  This allows editor to
    save current settings during a session.
     
  
  Author: John Palazzo

  Date Created: 11.17.92 

 
----------------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_Mode AS CHAR NO-UNDO .
  
  DEFINE VAR Key_Value         AS CHAR NO-UNDO .
  DEFINE VAR Settings_NotSaved AS LOGICAL INIT TRUE.

  DO ON STOP  UNDO, LEAVE
     ON ERROR UNDO, LEAVE:
  
  FIND FIRST Sys_Options .  /* One record in table contains all settings. */
  IF SESSION:WINDOW-SYSTEM = 'TTY':U THEN
  DO:
    Sys_Options.Save_Settings = NO.
    RETURN.
  END.
  
  USE "" NO-ERROR.
  
    Key_Value = STRING( Sys_Options.Save_Settings ) .
    RUN KeyVals (INPUT p_Mode ,
                 INPUT KeyValue_Section ,
                 INPUT "SaveSettings" ,
                 INPUT-OUTPUT Key_Value ) .
        
    IF CAN-DO( "YES,NO" , Key_Value ) 
      THEN Sys_Options.Save_Settings = CAN-DO( "YES" , Key_Value ).
    /*-----------------------------------------------------------------
       If I'm in PUT mode but user does not want to save prefs on
       exit, save only this setting and don't save the others.
    -----------------------------------------------------------------*/
    IF ( p_Mode = "PUT" ) AND ( Sys_Options.Save_Settings = NO ) 
    THEN DO:
        ASSIGN Settings_NotSaved = FALSE.
        RETURN.
    END.

    Key_Value = STRING( Sys_Options.Exit_Warning ) .
    RUN KeyVals (INPUT p_Mode ,
                 INPUT KeyValue_Section ,
                 INPUT "ExitWarning" ,
                 INPUT-OUTPUT Key_Value ) .
    IF CAN-DO( "YES,NO" , Key_Value ) 
      THEN Sys_Options.Exit_Warning = CAN-DO( "YES" , Key_Value ).

    Key_Value = STRING( Sys_Options.Save_BufList ) .
    RUN KeyVals (INPUT p_Mode ,
                 INPUT KeyValue_Section ,
                 INPUT "SaveBufList" ,
                 INPUT-OUTPUT Key_Value ) .
    IF CAN-DO( "YES,NO" , Key_Value ) 
      THEN Sys_Options.Save_BufList = CAN-DO( "YES" , Key_Value ).

    Key_Value = STRING( Sys_Options.Minimize_BeforeRun ) .
    RUN KeyVals (INPUT p_Mode ,
                 INPUT KeyValue_Section ,
                 INPUT "MinimizeBeforeRun" ,
                 INPUT-OUTPUT Key_Value ) .
    IF CAN-DO( "YES,NO" , Key_Value ) 
      THEN Sys_Options.Minimize_BeforeRun = CAN-DO( "YES" , Key_Value ).

    Key_Value = STRING( Sys_Options.Restore_AfterRun ) .
    RUN KeyVals (INPUT p_Mode ,
                 INPUT KeyValue_Section ,
                 INPUT "RestoreAfterRun" ,
                 INPUT-OUTPUT Key_Value ) .
    IF CAN-DO( "YES,NO" , Key_Value ) 
      THEN Sys_Options.Restore_AfterRun = CAN-DO( "YES" , Key_Value ).
    
    Key_Value = STRING( Sys_Options.Pause_AfterRun ) .
    RUN KeyVals (INPUT p_Mode ,
                 INPUT KeyValue_Section ,
                 INPUT "PauseAfterRun" ,
                 INPUT-OUTPUT Key_Value ) .
    IF CAN-DO( "YES,NO" , Key_Value )
      THEN Sys_Options.Pause_AfterRun = CAN-DO( "YES" , Key_Value ).

    Key_Value = STRING( Sys_Options.Auto_Cleanup ) .
    RUN KeyVals (INPUT p_Mode ,
                 INPUT KeyValue_Section ,
                 INPUT "AutoCleanup" ,
                 INPUT-OUTPUT Key_Value ) .
    IF CAN-DO( "YES,NO" , Key_Value ) 
      THEN Sys_Options.Auto_Cleanup = CAN-DO( "YES" , Key_Value ).
      
    Key_Value = STRING( Sys_Options.MRU_Filelist ) .
    RUN KeyVals (INPUT p_Mode ,
                 INPUT KeyValue_Section ,
                 INPUT "MostRecentlyUsedFileList" ,
                 INPUT-OUTPUT Key_Value ) .
    IF Key_Value EQ ? THEN Sys_Options.MRU_Filelist = TRUE.
    ELSE IF CAN-DO( "YES,NO" , Key_Value )
      THEN Sys_Options.MRU_Filelist = CAN-DO( "YES", Key_Value ).
      
    Key_Value = STRING( Sys_Options.MRU_Entries ) .
    RUN KeyVals (INPUT p_Mode ,
                 INPUT KeyValue_Section ,
                 INPUT "MRUEntries" ,
                 INPUT-OUTPUT Key_Value ) .
    CASE Key_Value:
      WHEN ? THEN Sys_Options.MRU_Entries = IF Sys_Options.MRU_Filelist THEN 4 ELSE 0.
      OTHERWISE DO:
        ASSIGN Sys_Options.MRU_Entries = INTEGER( Key_Value ) NO-ERROR.
        IF ERROR-STATUS:ERROR 
          THEN ASSIGN Sys_Options.MRU_Entries = 0.
      END.  /* otherwise do */
    END CASE.
    
    Key_Value = STRING( Sys_Options.EditorFont ).
    IF ( Key_Value = ? ) THEN ASSIGN Key_Value = "Default".
    RUN KeyVals (INPUT p_Mode ,
                 INPUT KeyValue_Section ,
                 INPUT "EditorFont" ,
                 INPUT-OUTPUT Key_Value ) .
                 
    /* See also adeedit/pinit.i for bg/fgcolor initialization. 
       Editor_Font comes from adecomm/_adeload.p. */
    CASE Key_Value:
        WHEN ? OR WHEN ""       
            THEN ASSIGN Sys_Options.EditorFont = Editor_Font NO-ERROR.
        WHEN "Default" 
            THEN ASSIGN Sys_Options.EditorFont = ? NO-ERROR.
        OTHERWISE DO:
          ASSIGN Sys_Options.EditorFont = INTEGER( Key_Value ) NO-ERROR.
          IF ERROR-STATUS:ERROR 
             THEN ASSIGN Sys_Options.EditorFont = Editor_Font NO-ERROR.
        END.
    END CASE.  

    Key_Value = STRING( Sys_Options.SaveClass_BeforeRun ) .
    RUN KeyVals (INPUT p_Mode ,
                 INPUT KeyValue_Section ,
                 INPUT "AutoSaveCls" ,
                 INPUT-OUTPUT Key_Value ) .
    IF CAN-DO( "YES,NO" , Key_Value ) 
      THEN Sys_Options.SaveClass_BeforeRun = CAN-DO( "YES" , Key_Value ).

    ASSIGN Settings_NotSaved = FALSE.
    
  END. /* DO ON ERROR */

/* Don't report save errors. They are annoying. If you want them, uncomment below. */
/*  IF Settings_NotSaved THEN
    RUN adeshar/_puterr.p ( INPUT Editor_Name , INPUT ProEditor ). */
  
END PROCEDURE . /* SysOptsGetPut */


PROCEDURE KeyVals .
 
/*----------------------------------------------------------------------------
  Purpose:  Reads/saves Key Values to and from Progress Environment File.  
  Syntax:
	    RUN KeyVals (INPUT p_Mode ,
                         INPUT p_Section ,
                         INPUT p_Key ,
                         INPUT-OUTPUT p_Value ) .

  Description:
  
  Author: John Palazzo

  Date Created: 11.17.92 
----------------------------------------------------------------------------*/
 
    DEFINE INPUT        PARAMETER p_Mode    AS CHAR FORMAT "x(15)" NO-UNDO .
    DEFINE INPUT        PARAMETER p_Section AS CHAR FORMAT "x(15)" NO-UNDO .
    DEFINE INPUT        PARAMETER p_Key     AS CHAR FORMAT "x(15)" NO-UNDO .
    DEFINE INPUT-OUTPUT PARAMETER p_Value   AS CHAR FORMAT "x(15)" NO-UNDO .

    DEFINE VARIABLE Key_Value AS CHAR NO-UNDO.
    
    /* proc-main */
    DO ON STOP  UNDO, RETURN ERROR
       ON ERROR UNDO, RETURN ERROR :

        /*-----------------------------------------------------------------
            Get the key value. Do this regadless of PUT or GET mode.
            Then, if PUT mode and the key's value is different than
            what's currently in environment file, go ahead and save
            the new value.
        -----------------------------------------------------------------*/
        
        ASSIGN Key_Value = p_Value .

        GET-KEY-VALUE SECTION p_Section KEY p_Key VALUE p_Value.
        IF ( p_Mode = "PUT" ) AND ( Key_Value <> p_Value )
        THEN DO:
            ASSIGN p_Value = Key_Value .
            PUT-KEY-VALUE SECTION p_Section KEY p_Key VALUE p_Value NO-ERROR.
            IF ERROR-STATUS:ERROR THEN STOP.
        END.
    END.
    
END PROCEDURE.	/* KeyVals */



PROCEDURE DlgSysOptions .
/*----------------------------------------------------------------------------
  Syntax:
	RUN DlgSysOptions .

  Description:
    Editor Preferences Dialog Box for viewing and setting editor 
    system options.
  
  Author: John Palazzo
----------------------------------------------------------------------------*/

  DEFINE BUTTON btn_OK	    LABEL "OK"
    {&STDPH_OKBTN} AUTO-GO.
  DEFINE BUTTON btn_Cancel  LABEL "Cancel"
    {&STDPH_OKBTN} AUTO-ENDKEY.
  DEFINE BUTTON btn_Help    LABEL "&Help"
    {&STDPH_OKBTN}.
    
  DEFINE VARIABLE OK_Pressed AS LOGICAL NO-UNDO.

  /* Dialog Button Box */
  &IF {&OKBOX} &THEN
  DEFINE RECTANGLE SO_Btn_Box    {&STDPH_OKBOX}.
  &ENDIF

  /*---------------- Editor Settings Dialog Box ----------------*/    
  DEFINE FRAME DLG_SysOptions
    SKIP( {&TFM_WID} )
     "Exit Preferences:"  {&AT_OKBOX} VIEW-AS TEXT
    SKIP( {&VM_WID} )
        Sys_Options.Exit_Warning AT 5
    SKIP( {&VM_WID} )
        Save_BufList       AT 5
    SKIP( {&VM_WID} )
        MRU_FileList       AT 5
        MRU_Entries        AT 31 FORMAT "9" NO-LABEL
        "entries" VIEW-AS TEXT
    SKIP( {&VM_WIDG} )
     "Run Preferences:"   {&AT_OKBOX} VIEW-AS TEXT
    SKIP( {&VM_WID} )
        Minimize_BeforeRun AT 5
    SKIP( {&VM_WID} )
        Restore_AfterRun   AT 5
    SKIP( {&VM_WID} )
        Pause_AfterRun     AT 5
    SKIP( {&VM_WID} )
        Auto_Cleanup       AT 5
    { adecomm/okform.i
        &BOX    ="SO_Btn_Box"
        &OK     ="btn_OK"
        &CANCEL ="btn_Cancel"
        &OTHER  =" "
        &HELP   ="btn_Help" 
    }
  WITH TITLE "Preferences" SIDE-LABELS
       VIEW-AS DIALOG-BOX
               DEFAULT-BUTTON btn_OK
               CANCEL-BUTTON  btn_Cancel.
    { adecomm/okrun.i
        &FRAME  = "FRAME DLG_SysOptions"
        &BOX    = "SO_Btn_Box"
        &OK     = "btn_OK"
        &HELP   = "btn_Help"
    }
  
  ON HELP OF FRAME DLG_SysOptions ANYWHERE
    RUN adeedit/_edithlp.p ( INPUT "System_Options_Dialog_Box" ).
  ON CHOOSE OF btn_Help IN FRAME DLG_SysOptions
    RUN adeedit/_edithlp.p ( INPUT "System_Options_Dialog_Box" ).
  
  ON GO OF FRAME DLG_SysOptions
  DO:
    OK_Pressed = YES.
  END.
  
  ON WINDOW-CLOSE OF FRAME DLG_SysOptions
     OR CHOOSE OF btn_Cancel IN FRAME DLG_SysOptions
  DO:
    /* Nothing. */
  END.
  
  ON ENTRY OF FRAME DLG_SysOptions DO:
    IF NOT Sys_Options.MRU_FileList THEN 
      MRU_Entries:SENSITIVE IN FRAME DLG_SysOptions = FALSE.
  END.  /* of entry of frame */
  
  ON VALUE-CHANGED OF MRU_FileList IN FRAME DLG_SysOptions DO:
    IF MRU_FileList:SCREEN-VALUE = "yes" THEN ASSIGN
      MRU_Entries:SCREEN-VALUE = "4"
      MRU_Entries:SENSITIVE = TRUE.
    ELSE ASSIGN
      MRU_Entries:SCREEN-VALUE = "0"
      MRU_Entries:SENSITIVE = FALSE.
  END.  /* value-changed of filelist */
  
  ON VALUE-CHANGED OF MRU_Entries IN FRAME DLG_SysOptions DO:
    IF MRU_Entries:SCREEN-VALUE = "0" THEN ASSIGN
      MRU_FileList:SCREEN-VALUE = "no"
      MRU_Entries:SENSITIVE = FALSE.
  END.  /* value-changed of entries */

DO: /* MAIN */
  RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "WAIT" ) .
  FIND FIRST Sys_Options.
  RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .

  _DLG_BOX :
  DO  ON ERROR  UNDO _DLG_BOX , LEAVE _DLG_BOX 
      ON ENDKEY UNDO _DLG_BOX , LEAVE _DLG_BOX
      ON STOP   UNDO _DLG_BOX , LEAVE _DLG_BOX :
    UPDATE 
        Exit_Warning
        Save_BufList
        MRU_FileList
        MRU_Entries 
        Minimize_BeforeRun 
        Restore_AfterRun 
        Pause_AfterRun 
        Auto_Cleanup 
        btn_OK btn_Cancel btn_Help
    GO-ON ( GO,WINDOW-CLOSE )
    WITH FRAME DLG_SysOptions .
    IF LAST-EVENT:FUNCTION = "WINDOW-CLOSE" THEN UNDO, LEAVE.
  END.
  ASSIGN 
    MRU_FileList 
    MRU_Entries.
  RUN MRUList ( INPUT "":U ).
  HIDE FRAME DLG_SysOptions NO-PAUSE.
  
  IF OK_Pressed THEN
  DO ON STOP UNDO, LEAVE: /* Save settings and menu accelerators now. */
    RUN SysOptsGetPut ( INPUT "PUT":u ) .
    RUN adecomm/_mnkvals.p (INPUT win_ProEdit:MENUBAR ,
                            INPUT "PUT" , INPUT KeyValue_Section ,
                            INPUT Exclude_Menus /* see dsystem.i */ ,
                            OUTPUT g_Editor_Cached_Accels ).
  END. /* OK_Pressed */
  
  APPLY "ENTRY" TO ProEditor.

END.  /* MAIN */

END PROCEDURE.	/* DlgSysOptions */


PROCEDURE DlgMenuAccels.
/*----------------------------------------------------------------------------
  Syntax: RUN DlgMenuAccels.

  Description:
    Display Menu Accelerators dialog box and save accelerator settings if
    OK is pressed.
  
  Author: John Palazzo
----------------------------------------------------------------------------*/

  DO ON STOP  UNDO, LEAVE
     ON ERROR UNDO, LEAVE:
    RUN adecomm/_dlgmnua.p (INPUT win_ProEdit:MENUBAR , INPUT Exclude_Menus).
    IF RETURN-VALUE = "OK":U THEN /* Save accelerator settings now. */
      RUN adecomm/_mnkvals.p (INPUT win_ProEdit:MENUBAR ,
                              INPUT "PUT" , INPUT KeyValue_Section ,
                              INPUT Exclude_Menus /* see dsystem.i */ ,
                              OUTPUT g_Editor_Cached_Accels ).
  END. /* ON STOP */
  RETURN. /* Reset RETURN-VALUE to Null. */
  
END PROCEDURE.


PROCEDURE ChangeDefFont .
  /*---------------------------------------------------------------------------
     Presents the Default Editor Font dialog, which allows the user to choose a 
     default font for the Procedure Editor.  The chosen font is used as the
     font for new Buffers and Procedure Windows, when created.  Its also the 
     value stored in the Progress Environment File as the Procedure 
     Editor's default font.
   ---------------------------------------------------------------------------*/

    DEFINE BUFFER BEdit_Buffer FOR Edit_Buffer.
    
    DEFINE VAR Old_Font   AS INTEGER NO-UNDO.
    DEFINE VAR Pressed_OK AS LOGICAL NO-UNDO.

    DO ON STOP UNDO, LEAVE:
    
        FIND FIRST Sys_Options.
        ASSIGN Old_Font = Sys_Options.EditorFont .
        
        RUN adecomm/_chsfont.p ( INPUT Editor_Name + " Default Font" , 
                                 INPUT ?,  /* Use System Default Font */
  			         INPUT-OUTPUT Sys_Options.EditorFont ,
                                 OUTPUT Pressed_OK ) .
        IF ( Pressed_OK = TRUE ) AND ( Sys_Options.EditorFont <> Old_Font )
        THEN DO:
            /* Change as needed, the Editor Buffer Fonts. */
            FOR EACH BEdit_Buffer :
                IF ( BEdit_Buffer.hBuffer:FONT = Old_Font )
                    THEN BEdit_Buffer.hBuffer:FONT = Sys_Options.EditorFont .
            END.
            /* Change as needed, the Procedure Window Fonts. */
            RUN adecomm/_pwchfnt.p (INPUT Editor_Name  /* Parent_ID */ ,
                                    INPUT ?            /* PW Handle */ ,
                                    INPUT Old_Font , 
                                    INPUT Sys_Options.EditorFont ).
            /* Save the Font settings change. */
            RUN SysOptsGetPut ( INPUT "PUT":u ) .
        END.

    END.
    
END PROCEDURE.


PROCEDURE OptionsSetSave.
  /*--------------------------------------------------------------------------
    Purpose: Sets/Toggles the Save Settings on Exit system option.

    Run Syntax: RUN OptionsSetSave( INPUT p_Save_State ) .

    Parameters:
  INPUT
	p_Save_State (LOGICAL) - When TRUE, Procedure Editor 
    saves all system option values to Environment file.
    FALSE - settings are not saved when editor ends.
    Description:

    Notes: 
 
---------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Save_State AS LOGICAL NO-UNDO .
  
  /* proc-main */
  DO:
      FIND FIRST Sys_Options.
      ASSIGN Sys_Options.Save_Settings = p_Save_State .
  END.

END PROCEDURE.


&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
/* TTY Only Procedure. */
PROCEDURE CreateEditorBars.
/*--------------------------------------------------------------------------
    Purpose:        Creates the Character Procedure Editor top and
                    bottom editor bars and name of current buffer handle.

    Run Syntax:     RUN CreateEditorBars (INPUT p_Frame ) .

    Parameters:

          INPUT     p_Frame (WIDGET-HANDLE)
                    Handle to frame to place editor bars.

    Description:

    Notes:
---------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p_Frame        AS WIDGET-HANDLE NO-UNDO.
    DEFINE OUTPUT PARAMETER p_Cur_Buf_Name AS WIDGET-HANDLE NO-UNDO.
    
    DEFINE VAR Top_Bar    AS WIDGET-HANDLE NO-UNDO.
    DEFINE VAR Bottom_Bar AS WIDGET-HANDLE NO-UNDO.

    DO:
        CREATE RECTANGLE Top_Bar
        ASSIGN 
            FRAME   = p_Frame
            ROW     = 1
            COL     = 1
            WIDTH   = p_Frame:WIDTH
            HEIGHT  = 1
            GRAPHIC-EDGE = YES
        . /* END ASSIGN. */
        
        CREATE RECTANGLE Bottom_Bar
        ASSIGN 
            FRAME   = p_Frame
            ROW     = p_Frame:HEIGHT
            COL     = 1
            WIDTH   = p_Frame:WIDTH
            HEIGHT  = 1
            GRAPHIC-EDGE = YES
            DCOLOR      = 2  /* DISPLAY COLOR MESSAGES in protermcap. */
            PFCOLOR     = 2  /* PROMPT-FOR COLOR MESSAGES in protermcap. */
        . /* END ASSIGN. */
        
        CREATE TEXT p_Cur_Buf_Name
        ASSIGN
            FRAME       = p_Frame
            AUTO-RESIZE = TRUE
            ROW         = Bottom_Bar:ROW
            COL         = 2
            DCOLOR      = 2  /* DISPLAY COLOR MESSAGES in protermcap. */
        . /* END ASSIGN. */
    END.

END PROCEDURE.
&ENDIF


PROCEDURE WinSetTitle .
/*
    RUN WinSetTitle ( p_Window , p_Text ) .
*/

  DEFINE INPUT PARAMETER p_Window AS WIDGET-HANDLE NO-UNDO .
  DEFINE INPUT PARAMETER p_Text   AS CHARACTER	   NO-UNDO .

  DEFINE VAR Title_Text AS CHARACTER NO-UNDO.
  DEFINE VAR MaxWidth   AS INTEGER   NO-UNDO.

  &IF ( "{&WINDOW-SYSTEM}" <> "TTY" ) &THEN
      ASSIGN p_Window:TITLE = Editor_Name + IF ( p_Text <> ""  )
                                            THEN " - " + p_Text
                                            ELSE "".
  &ELSE

      p_Text = " File: " + p_Text + " ".

      /* Max file display width is two less than the window width
         to account for the file name display starting at column 1
         and the trailing space added to make the display look nice. */
      MaxWidth = p_Window:WIDTH - 2.

      /* If file path is too long, get a short name for it. */
      IF LENGTH( p_Text ) > MaxWidth THEN
      DO:
          RUN adecomm/_ossfnam.p
              (INPUT  p_Text,
               INPUT  MaxWidth,
               INPUT  ? /* Font */,
               OUTPUT p_Text).
      END.
      hCur_Buf_Name:FORMAT = "x(" + 
                             STRING( MIN( LENGTH( p_Text ) , MaxWidth ) )
                                + ")" NO-ERROR.
      hCur_Buf_Name:SCREEN-VALUE = p_Text NO-ERROR.
  &ENDIF
END PROCEDURE. /* WinSetTitle */


PROCEDURE WinStatusMsg.
  /*

     RUN WinStatusMsg ( p_Window , p_Msg_Type , p_Message , 
   p_Mouse_Cursor ) .

  */

  DEFINE INPUT PARAMETER p_Window	AS WIDGET-HANDLE	 NO-UNDO .
  DEFINE INPUT PARAMETER p_Msg_Type	AS CHARACTER	 INIT "MT_INPUT" 
		NO-UNDO .
  DEFINE INPUT PARAMETER p_Message	AS CHARACTER	 INIT "" NO-UNDO .
  DEFINE INPUT PARAMETER p_Mouse_Cursor AS CHARACTER	 INIT "" NO-UNDO .

  DEFINE VAR Temp_Logical AS LOGICAL NO-UNDO.
  DEFINE VAR Immed_Disp AS LOGICAL NO-UNDO.

  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
    IF p_Message = ""
    THEN DO:
        ASSIGN p_Message = " " + KBLABEL("GO") + "=RUN  "
/* jep 2/12/96             + KBLABEL("HELP") + "=HELP  "                 */
                           + KBLABEL("ENTER-MENUBAR") + "=MENUS  "
                           + KBLABEL("GET") + "=OPEN  "
                           + KBLABEL("PUT") + "=SAVE  "
                           + KBLABEL("CLEAR") + "=CLOSE" .
       /* On vt100 based terminals, standard key labels cause CLOSE to be
          truncated.  So, remove double spacing between Function items. */
       /* 63 is max string length for PROGRESS STATUS LINE. */
       IF ( LENGTH( p_Message ) > 63 )
       THEN ASSIGN p_Message = REPLACE( p_Message , "  " , " " ).
    END.

  &ENDIF

  /* Needed to force display of status. */
  ASSIGN Immed_Disp = SESSION:IMMEDIATE-DISPLAY
         SESSION:IMMEDIATE-DISPLAY = TRUE.
  IF p_Msg_Type <> "MT_INPUT" 
      THEN STATUS DEFAULT p_Message IN WINDOW p_Window.
      ELSE STATUS INPUT   p_Message IN WINDOW p_Window.
  /* Reset Immediate Display. */
  ASSIGN SESSION:IMMEDIATE-DISPLAY = Immed_Disp.
  RUN adecomm/_setcurs.p ( INPUT p_Mouse_Cursor ).

END PROCEDURE.


PROCEDURE _winevnt.p .
/*----------------------------------------------------------------------------
  Purpose:  Executes appropriate Window Event Procedure for Procedure Editor.

  Syntax:
            RUN _winevnt.p ( INPUT p_Win_Event ).

  Description:

           The Window Event procedures for PERSISTENT RUN triggers are not
           found by Progress when running user application code.  Therefore,
           a call is made to this procedure first.  An external .p file called
           _winevnt.p is in $DLC/gui.  Its a no-op procedure and will be
           found by Progress instead of the internal _winevnt procedure.
           This avoids the unpleasant "could not find file" error.

           See external _winevnt.p for more details.

  Author: John Palazzo
----------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p_Win_Event AS CHARACTER NO-UNDO.

    /* proc-main */
    DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:

      CASE p_Win_Event :
        WHEN "ED_WINDOW_CLOSE"
          THEN RUN WinExitEditor.
      END CASE.

    END.
    /* Prevent Beep from Window System. */
    RETURN ERROR.

END PROCEDURE.


PROCEDURE BufValidName .
  /*-------------------------------------------------------------
     Returns TRUE
       -  Buffer Name is blank, null, or unknown.
       -  If no buffer with same name as p_Buffer_Name
          already exists (other than itself, of course) or
       -  If user is attempting to assign a second editor buffer to the same
          OS file.

     Returns FALSE otherwise.
  -------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER p_Buffer        AS WIDGET-HANDLE NO-UNDO .
  DEFINE INPUT  PARAMETER p_Buffer_Name   AS CHAR          NO-UNDO .
  DEFINE OUTPUT PARAMETER p_Valid_BufName AS LOGICAL INIT TRUE NO-UNDO .

  DEFINE BUFFER bEdit_Buffer FOR Edit_Buffer.
  DEFINE VARIABLE Fullpath_Buffer_Name AS CHAR NO-UNDO .

    IF ( TRIM( p_Buffer_Name ) = "" ) OR ( p_Buffer_Name = ? )
    THEN DO:
      MESSAGE p_Buffer_Name SKIP
              "Cannot assign buffer name." SKIP(1)
              "A blank buffer name is invalid."
              VIEW-AS ALERT-BOX WARNING BUTTONS OK.
      p_Valid_BufName = FALSE .
      RETURN.
    END.

    /* Check 1) Buffer with same name already open? */
    FIND FIRST bEdit_Buffer WHERE ( bEdit_Buffer.Buffer_Name = p_Buffer_Name )
			    AND ( bEdit_Buffer.hBuffer <> p_Buffer )
			    NO-ERROR.
    IF AVAILABLE( bEdit_Buffer )
    THEN DO:
      MESSAGE p_Buffer_Name SKIP
	      "Cannot assign buffer name." SKIP(1)
	      "A buffer already exists with this name."
	      VIEW-AS ALERT-BOX WARNING BUTTONS OK.
      p_Valid_BufName = FALSE .
    END.
    ELSE DO:
      /* Check 2) Buffer already open for specified OS file? */
      FILE-INFO:FILENAME = p_Buffer_Name.
      Fullpath_Buffer_Name = FILE-INFO:FULL-PATHNAME.
      IF Fullpath_Buffer_Name = ? THEN RETURN.	
	 /* File not in PROPATH, so can't make any determination.  Guess that
its valid. */
	 
      FIND FIRST bEdit_Buffer WHERE ( bEdit_Buffer.File_Name = 
		Fullpath_Buffer_Name )
				AND ( bEdit_Buffer.hBuffer <> p_Buffer	     
 )	
			      NO-ERROR.
      IF AVAILABLE( bEdit_Buffer )
      THEN DO:
	MESSAGE p_Buffer_Name SKIP
		"Cannot assign buffer name." SKIP(1)
		"A buffer is already open for this file."
		VIEW-AS ALERT-BOX WARNING BUTTONS OK.
	p_Valid_BufName = FALSE .
      END.
    END.

END PROCEDURE.	/* BufValidName */


PROCEDURE QuitBuffer .
  /* Returns TRUE if buffer is a QUIT buffer; FALSE if not. */
    DEFINE INPUT  PARAMETER p_Buffer AS WIDGET-HANDLE      NO-UNDO.
    DEFINE OUTPUT PARAMETER p_Quit   AS LOGICAL INIT FALSE NO-UNDO.

    DEFINE VARIABLE Buffer_Code AS CHAR NO-UNDO.

    &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
    IF ( p_Buffer:NUM-LINES < 6 ) /* Avoids ditem errors. */
    THEN DO:
    &ELSE
    IF ( p_Buffer:LENGTH < 256 ) /* Avoids ditem errors. */
    THEN DO:
    &ENDIF
      /*----------------------------------------------------------------
         Following code tests if buffer code is just a QUIT statement.

         1. Trim off any leading or trailing white space.
         2. Test if QUIT token is the first non-whitespace word
            in buffer.  If not, its not a QUIT-only buffer.
         3. The IF Buffer tests for a buffer of only "QUIT or "QUIT.".
         4. The "ELSE IF (..." tests the case where the token QUIT
            is not followed immediately by its terminating period
            and or its terminating period has something following it.
            The only characters we allow between QUIT and its period
            is whitespace.  The ELSE IF checks this.
      ----------------------------------------------------------------*/
      Buffer_Code = TRIM( p_Buffer:SCREEN-VALUE ) .
      IF ( Buffer_Code BEGINS "QUIT" )
      THEN DO:
        IF ( Buffer_Code = "QUIT" ) OR ( Buffer_Code = "QUIT." )
        THEN p_Quit = TRUE .
        ELSE IF ( INDEX( Buffer_Code , "." ) > 0 AND
                  TRIM( SUBSTRING(Buffer_Code , 5 ) ) = "." )
        THEN p_Quit = TRUE .
      END.
    END. /* IF Quit_Pending */
END PROCEDURE.
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------------
  ptools.i
  Tools Menu Related Procedures for Editor 
--------------------------------------------------------------------------*/


PROCEDURE RunTool .
/*----------------------------------------------------------------------------
  Purpose     : Runs an ADE Tool.  Tool to run cannot have Run-Time Parameters
                or arguments.
  Syntax      : 
                  RUN RunTool( INPUT  p_Program_Name ) .
                  
  Description : 

  Author      : John Palazzo
  Date Created: 04/02/93
----------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p_Program_Name  AS CHAR .

    DEFINE VAR Can_Run AS LOGICAL .

    DO ON STOP UNDO, LEAVE : /* proc-main */
        RUN CheckTool( INPUT p_Program_Name , INPUT YES /* disp alert-box */ ,
                       OUTPUT Can_Run ) .
        IF ( Can_Run = NO ) THEN RETURN .
        RUN RunProc ( INPUT p_Program_Name , 
                      INPUT TRUE /* Never Pause After Run */ ).
    END . /* proc-main */
    
END PROCEDURE .


PROCEDURE disable_widgets .
  /*--------------------------------------------------------------------------
    Purpose:     Routine called from Tools Menu to disable editor
                 before running ADE Tool.
    
    Run Syntax:  RUN disable_widgets .
    Parameters:  None.

    Description:
    Notes:
  --------------------------------------------------------------------------*/

  RUN DisableEditor
	( INPUT win_Proedit, 
	  INPUT Run_Window, 
	  INPUT Editor_Name + " - Run",
	  INPUT Compile_FileName ) .
    
END.


PROCEDURE enable_widgets.
  /*--------------------------------------------------------------------------
    Purpose:     Routine called from Tools Menu to enable editor
                 after running ADE Tool.
    
    Run Syntax:  RUN disable_widgets .
    Parameters:  None.

    Description:
    Notes:
  --------------------------------------------------------------------------*/

  RUN EnableEditor
	( INPUT win_Proedit, 
	  INPUT Run_Window, 
	  INPUT Editor_Name + " - Run",
	  INPUT Compile_FileName ,
	  INPUT FALSE /* Does not force a no-pause after run */ ).
    
END.
Y//+S!+??3Ļ?k޳??k???A?q???AWW?W9>q?yԡW?WyA5?g?????&Q??????/~??????????F,EW?맛eV??]?nJ\???` ?SnV?8KQ???W?V?1Y)??_I???o?r?e?e.\??"ze???]??3໒t??]g?0?#??7Y#o??%??8_?????+?S??L[V????ib<?b ?????Ұ?b?+?һr????%82?C??0?T?0ݿQB)LQlL????(??UU?1????PܭZ?΃1??CN?:???u??Cc|?I?I??m??l???mm??텔??mg????k???
hg?dd?6??N<6Bes
nyN??s?n??W????M??ՒI???X?J:??\?`?????[????j??3%????????u????????U?2Y|?\?$??y\??hq???"??˂???
???ʀ??Ù?!3Xq????
rr!X??j<?????t?-=V????q%???h?p??{??<???=??(?o;????6???W???H???????j1???h`=B/?=JR2	0pg04u?r=!??".ŧv!xEPGQQ+??q?, 3?????때????????4???҃b+?b?omnHӍ?L?*??@m???E?E?%@m???fll?v???(?GG??"???????j2j?/??w???S|#??	??? VM?av$t??oh@?X?r6?????Va<?7T!?A5N ????i?m?	h?y??\`??悻\?y????EJ|]S?nϮ'?덦??񀲉?H?????1?*XE/\?s]???Y??Z?U?7;Nd?|?(?+?{?(?`֓F?T???[Z????k?X*???а? ??a?????m?? w???;;?Ӛ?????PS*?/?P~7?xS?PwS]?0a$S?????Y?
B@????g&??

??
ڣ?g?:???:K??Aɓ?Mɓ??G#G8%???%???"?q???????@&?Η4?::?ث?'????2;??)???Ի)?s}[u?Q~?C????BY???j??kz??	k????D:???????OT?OT??
_??e8?8 ???<?e??,?$l<??O???m??m:???Q??Qd?d????Qd?????????!?֨??"???!S"??9"S9U^??9ܫ3t^???~f??OFsL?^s?'?x1???^????1?m!j!mP?mY??蕑e?Y?l???p?e?????pˮ???@G۱{5??'{????R??F_?R??=???oo ???-???????ĥ???`?*?C?U	?	^E????^	???)e?e?23???ם?,?t??Ĝ閳??M??g44Q)??{@?)%X?bV???D@?????x????_>?{w??ѓ?J_??Br_c	*?n???6?	???M??i((G???7#!כfs45?b?1L6ɕ?h?_&z_??Dԭ??VL?-???a=?` ????w??·v͡??f?"v?7?a?7?L?+?»{e????W*:'?bD&22?ISe?#2Sy%?#m??)?-T?9@	?c?????S??z?ّ????/?<ʍ???????RP?>8?[[[???#??pH#H%R; ?#iO ?M~?!GEEB1?e$9.l?1?e#?4
?{??w?0?<;&iw*?hy?j?3??3?||7I?*o?K???,7?;ÿ'È6{{x?;{{ux{???x??o?<???4!(???.xz?7.?????P2?????Q?????._N?????* ???*????/?? -T1??^? 0?-? ???{#??|M?JM?|???(?x?2???p?2?p?2???I?K?????Ӧ?>ה?<???v?1L?ɥֺݫZ??????6ρ????Z?G	?˹??Um???V?m?|?w,i[?̮??z<a9֋,?~?4b?ݎ?jM??nMm?????I??T??Y????????dQ|6?O,?7uG?H}?8^Hk=???{H={F??mm????;?????&?lĽPP?h ?? c?? ??Z8???8ZB8B?$8i~ݺ?:&:7#????ķ??????B??5?h?j??lG5S9?|?36??????OF??$???????B?ߌ??p?I??:!f?*?u??Hs?6s|Q"b?ZK??wl?$%Xz??z4-?HC??@?,?(z????/????|6??98x'`?Z????gT??r????C??????J??,әM?@?0]O?(z}??????ߋf?z2??_??ja?#?u3.??Za?Aχ
 ?|?????HUA???ѫ???ޥ 5???GJ??y???Cʾm?T??V?i?ѼȔv???\?uW??Y???-?dfG??/?-f??t0?$7:'?Ab?N?O?1|??^?s??ՠ??l?V?Ginpx&;|??>??ň,@?Th$C??o????%???"~?~?J%?fJN?wwNg?''wg^?g^?8????*1????8???*Y???b`???|>??榦`???|?0?a?	/?[:?~,6i>]??Kj6????p???ˉ9Ͻ6?"Y:w?????X?SkH3\l?????&?%V҉?MӚ.M?>$:Jd%I"?,!1?3?}???ϬR\?=w?DUw?`??k??Н
9?߭?0??~?~?Ts@צT?]??(nТ  ??}R?3 >3n?a)?}???T??Nv`f?\WR?RLY?p\67E޴y??쓀???b????????C?ÓտN[??D?fz\???|????d?IR?4????C\?=\Ǻ?\-=???l/l???(zƛ"????r.<?p,(`?&?
==P0??????B?J?=????jF*]????>?v+@ڦ?	6?4??Z>???!?D?AT?wxd_???x?|??!+??R?U?!?gq?!??????Tgg????``?`?E?߾??8??ܴ?ܾ?h??4h4Jd?dzJ?4&?zm?6F?f????6W?Yi???wB{h???M?b?f{,p?E ?P?v??ԃ?.????R񙳁???ĩ?ǚ?@?rJ??ɛ?????[?&-Bj?Hcл?*??W3|???@?????????'ЈW?'
?T?Z?m????A?poW???pҽ;?W?m??o??Խ/s?s /k,?1?1?JT,?t??  7?? ????V???8c?]I-???	?́)??@gC?D0&??
`???;q?VW=_m4@?ل???????F???b<?F???v?֜??qI??}?[????b$??L?U?U????9??Jp???~4? Osr/ڌ'a5}??3Ϻ?m????Q???G?C?3????Sҡ?4fqO?z???nl???X?aqA??ݍ?B??}??ېŝ?<?r???????:?"i	?X???M??F@$?EHde????]?H?<???]?????m????????????3u?y5????z?%????`?д??L☟?,??:&???E?????jf?Yw<=??adeedit/_dlggetf.pf?   &?  -pK&??K&?n        ?adeedit/_dlgsbuf.pL  -??  RK&??K&?n        ?adeedit/_edithlp.p  D??  ?K&??K&?n        ?adeedit/_proedit.p?h  M??  #?K&??K&?n        ?adeedit/_winrsz.p^)  qF?  lK&??K&?n        ?adeedit/dbftrigs.iz[  ???  ?K&??K&?n        ?adeedit/dbuffers.i  ?o?  ?K&??K&?n        ?adeedit/dcompile.i*  ???  K&??K&?n        ?adeedit/dfile.iگ  ?~?  jK&??K&?n        ?adeedit/dhelp.i?  ???  ?K&??K&?n        ?adeedit/dmenus.iH?  ?r?  2?K&??K&?n        ?   ?adeedit/dsysgetf.i[  ??  ?K&??K&?n        ?adeedit/dsystem.i?*  ???  ?K&??K&?o        ?adeedit/dtools.i??  ???  XK&??K&?o        ?adeedit/dtrigs.i?  ???  ?K&??K&?o        ?adeedit/edithelp.i
& ??  ?K&??K&?o        ?adeedit/minitdbg.i ??  ?K&??K&?o        ?adeedit/pbuffers.i t?  ?K&??K&?o        ?adeedit/pcompile.i?% ???  |K&??K&?o        ?adeedit/pfile.i?P 2??  ??K&??K&?o        ?adeedit/phelp.i) ?J?  pK&??K&?o        ?adeedit/pinit.i-? ???  $K&??K&?o        ?        ?adeedit/pmenus.i?? ??  ;?K&??K&?o        ?adeedit/psysgetf.i? B??  K&??K&?o        ?adeedit/psystem.i?N ]??  ??K&??K&?o        ?adeedit/ptools.ii? ??  
gK&??K&?o        ?adeedit/peditor.i_? %	?  ?K&??K&?o        ? ?    d                   ?                                                                                                                                                                                                                                                             