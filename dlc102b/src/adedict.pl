?undefined               ?k c 
Zd    /*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/


/*----------------------------------------------------------------------------

File: _connect.p

Description:
Display and handle the connect dialog box.  Most of this code has been
put into a common dialog service so that it is useable from outside the
dictionary.

Input Parameter:
p_name - The default physical name of the database to connect to, or ?.

Author: Laura Stern

Date Created: 03/03/92

history
95-04-17    j.palazzo   added network, host, and service params to
                          _getconp.p call.
94-07-29    hutegger    changed arg_ld from ? to ldbname(p_name)
94-05-02    hutegger    changed the code to use _getconp.p

----------------------------------------------------------------------------*/

{adedict/dictvar.i SHARED}
{adedict/brwvar.i SHARED}

DEFINE INPUT  PARAMETER p_name  AS CHARACTER    NO-UNDO.

DEFINE VARIABLE cnt 	    AS INTEGER 	 NO-UNDO.
DEFINE VARIABLE dblst       AS HANDLE    NO-UNDO.

DEFINE VARIABLE arg_1       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE arg_db      AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_dt      AS CHARACTER NO-UNDO INITIAL "PROGRESS".
DEFINE VARIABLE arg_ld      AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_p       AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_pf      AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_u       AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_tl      AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_network AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_host    AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_service AS CHARACTER NO-UNDO.
DEFINE VARIABLE ix          AS INTEGER   NO-UNDO.
DEFINE VARIABLE stri        AS CHARACTER NO-UNDO.
DEFINE VARIABLE args        AS CHARACTER NO-UNDO EXTENT 4.

/*----------------------------Mainline code----------------------------------*/

ASSIGN
  arg_db         = p_Name
  arg_ld         = LDBNAME(p_name)
  arg_dt         = DBTYPE(p_Name)
  CURRENT-WINDOW = (IF s_win_Logo = ? THEN s_win_Browse ELSE s_win_Logo).

IF arg_db <> ? AND NUM-DBS > 0 THEN
  RUN prodict/misc/_getconp.p (INPUT        arg_db,
                               INPUT-OUTPUT arg_db,
                               INPUT-OUTPUT arg_ld,
                               INPUT-OUTPUT arg_dt,
                               OUTPUT       arg_tl,
                               OUTPUT       arg_pf,
                               OUTPUT       arg_1,
                               OUTPUT       arg_network,
                               OUTPUT       arg_host,
                               OUTPUT       arg_service,
                               OUTPUT       arg_u,
                               OUTPUT       arg_p,
                               OUTPUT       args[2],
                               OUTPUT       args[3],
                               OUTPUT       args[4]).

ASSIGN args[2] = args[2] + " " + args[3] + " " + args[4].

RUN adecomm/_dbconnx.p (INPUT        YES,
                        INPUT-OUTPUT arg_db,
                        INPUT-OUTPUT arg_ld,
                        INPUT-OUTPUT arg_dt,
                        INPUT-OUTPUT arg_1,
                        INPUT-OUTPUT arg_network,
                        INPUT-OUTPUT arg_host,
                        INPUT-OUTPUT arg_service,
                        INPUT-OUTPUT arg_u,
                        INPUT-OUTPUT arg_p,
                        INPUT-OUTPUT arg_tl,
                        INPUT-OUTPUT arg_pf,
                        INPUT-OUTPUT args[2],
                        OUTPUT       stri).

IF arg_ld <> ? THEN DO: /* connect succeeded */
  /* If the user connected to other databases via the unix parms, this
     will add them to the list as well. */
  cnt = s_DbCache_Cnt.  /* remember how many we have now */

  RUN adedict/DB/_getdbs.p.

  /* Make sure we actually add something to the list.  If all dbs were
     V5 e.g., we wouldn't have. */
  dblst = s_lst_Dbs:HANDLE IN FRAME BROWSE.  /* for convenience */
  IF s_DbCache_Cnt > cnt THEN DO:
    ASSIGN
      arg_ld             = dblst:ENTRY(cnt + 1)
      dblst:SCREEN-VALUE = arg_ld.

    RUN adecomm/_scroll.p (dblst,arg_ld).

    /* This will cause wait-for to break and switch to the new database
       as soon as we leave here (i.e., leave the trigger that invoked
       _connect.p.).  */
    APPLY "VALUE-CHANGED":u TO dblst.
  END.
END.

/* _connect.p - end of file */

/*********************************************************************
* Copyright (C) 2006 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _dbprop.p

Description:
   Display database properties for the current db in the prop window.

Author: Laura Stern

Date Created: 12/04/92

History:
    tomn    01/10/96    Added codepage to DB Properties form (s_Db _Cp)
    
    fernando 05/24/2005 Added db-description and custom-details to the DB Properties form.
                        Accessing the _Db record with a dynamic buffer now
    fernando 06/06/06  Added large sequence and large key support to the DB Properties form.
    
----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES

{adedict/dictvar.i shared}
{adedict/uivar.i shared}
{adedict/DB/dbvar.i shared}

DEFINE VARIABLE has_db_detail      AS LOGICAL NO-UNDO INITIAL NO.
DEFINE VARIABLE hBuffer_DB          AS HANDLE NO-UNDO.
DEFINE VARIABLE hBuffer_DB-detail AS HANDLE NO-UNDO.

/* create a buffer for _Db because the _db-guid field is not present on a non-upgraded db (pre-10.1A) */
CREATE BUFFER hBuffer_DB FOR TABLE "DICTDB._Db" NO-ERROR.

hBuffer_DB:FIND-FIRST ("where  recid(dictdb._db) = " + STRING(s_DbRecId), NO-LOCK) NO-ERROR.

/* check if we can find the _db-detail table */
FIND FIRST dictdb._file WHERE dictdb._file._file-name = "_db-detail":U NO-LOCK NO-ERROR.

IF hBuffer_DB:AVAILABLE THEN DO:
                                                                   
    /* create a dynamic buffer to try to find the record. If this is a pre-101a db or the schema was not
       upgraded, then this table won't exist, so can't add static reference to it 
    */
    CREATE BUFFER hBuffer_DB-detail FOR TABLE "DICTDB._Db-detail" NO-ERROR.
    
    IF VALID-HANDLE(hBuffer_DB-detail) THEN DO:
    
        /* try to find the db-detail record */
        hBuffer_DB-detail:FIND-FIRST("where _db-guid = " + QUOTER(hBuffer_DB::_db-guid),NO-LOCK) NO-ERROR.

        IF hBuffer_DB-detail:AVAILABLE THEN
            ASSIGN has_db_detail = YES.

    END.

END.

assign
   s_Db_PName  = s_DbCache_Pname[s_DbCache_ix]
   s_Db_Holder = s_DbCache_Holder[s_DbCache_ix]
   s_Db_Type   = s_DbCache_Type[s_DbCache_ix]
   s_Db_Cp     = if hBuffer_DB:AVAILABLE then hBuffer_DB::_db-xl-name else "".

/* check large sequence and large key support, but only for Progress databases */
IF hBuffer_DB:AVAILABLE AND hBuffer_DB::_Db-type = "PROGRESS" THEN DO:
    /* For large key support, we look at the _Database-feature table.
       For large sequence - if 'Large Keys' is not a valid feature, than this
       is a pre-10.1B db in which case large sequences is not
       applicable. Otherwise we look at db-res1[1].
    */
    FIND DICTDB._Database-feature WHERE _DBFeature_Name = "Large Keys" NO-LOCK NO-ERROR.
    IF AVAILABLE DICTDB._Database-feature THEN DO:

        IF DICTDB._Database-feature._DBFeature_Enabled = "1" THEN
           s_Db_Large_Keys = "enabled".
        ELSE
           s_Db_Large_Keys = "not enabled".

         IF hBuffer_DB::_db-res1(1) = 1 THEN 
             s_Db_Large_Sequence = "enabled".
         ELSE
             s_Db_Large_Sequence = "not enabled".
    END.
    ELSE 
        ASSIGN s_Db_Large_Keys = "n/a"
               s_Db_Large_Sequence = "n/a".
END.
ELSE
    ASSIGN s_Db_Large_Sequence = "n/a"
           s_Db_Large_Keys = "n/a".


/* if we have data in the db-detail record to display, assign it now */
IF has_db_detail AND VALID-HANDLE( hBuffer_DB-detail) THEN DO:
    
    ASSIGN
        s_db_description = hBuffer_DB-detail::_Db-description
        s_Db_Add_Details = hBuffer_DB-detail::_Db-custom-detail.

    /* don't need the dynamic buffer anymore */
    DELETE OBJECT hBuffer_DB-detail.
    ASSIGN hBuffer_DB-detail= ?.
END.
ELSE
    ASSIGN s_db_description = "":U
                 s_Db_Add_Details = "".

DELETE OBJECT hBuffer_DB.

/* Run time layout for button area.  Only do this the first time. */
if frame dbprops:private-data <> "alive" then
do:
   /* okrun.i widens frame by 1 for margin */
   assign
      frame dbprops:private-data = "alive"
      s_win_Db:width = s_win_Db:width + 1.  

   {adecomm/okrun.i  
      &FRAME = "frame dbprops" 
      &BOX   = "s_rect_Btns"
      &OK    = "s_btn_OK" 
      &HELP  = "s_btn_Help"
   }
end.

display s_CurrDb
	s_Db_Pname
	s_Db_Holder
        s_Db_Type
        s_Db_Cp
    s_Db_Large_Sequence
    s_Db_Large_Keys
    s_db_description
    s_Db_Add_Details
	with frame dbprops.

enable s_btn_OK s_btn_Cancel s_btn_Help with frame dbprops.  

/* if we found the db detail record for this db, make it enabled, so user can update it, otherwise disable it
   in case the user switched db's while this frame is up. Also, if db is read-only, don't allow updates.
*/

IF has_db_detail AND NOT s_DB_ReadOnly THEN 
    ENABLE s_db_description s_Db_Add_Details with frame dbprops.
ELSE
    DISABLE s_db_description s_Db_Add_Details with frame dbprops.

apply "entry" to s_btn_OK in frame dbprops.







/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _dconn.p

Description:
   Disconnect the current database.  This has to be done in a separate
   .p file since the disconnect really only takes effect when the .p
   goes out of scope.

Author: Laura Stern

Date Created: 04/13/92 

----------------------------------------------------------------------------*/

{adedict/dictvar.i shared}
{adedict/brwvar.i shared}

Define var cnt       as integer NO-UNDO.   /* # of items in db list */
Define var ix  	     as integer NO-UNDO.   /* list index */
Define var lname     as char    NO-UNDO.   /* logical db name */


disconnect VALUE(s_CurrDb).

/* If this was a schema holder for foreign databases, these foreign dbs
   will be removed from the list as well - unless there connected themselves.
   We also have to reset the cache.  The easiest thing to do is is to clear 
   the list and the cache and re-get all dbs.  Remember the position of the 
   current db so we can reset the value of the select list at this position
   (or the next one above it that's left after the purge).
*/
ix = s_DbCache_ix.
assign
   s_lst_Dbs:LIST-ITEMS = ""
   s_DbCache_Cnt = 0
   s_DbCache_Pname = ""
   s_DbCache_Holder = ""
   s_DbCache_Type = "".

run adedict/DB/_getdbs.p.

/* Set the select list value to the database at the correct select list 
   position */
cnt = s_lst_Dbs:NUM-ITEMS in frame browse.
if ix > cnt then
   ix = cnt.

if ix > 0 then
do:
   lname = s_lst_Dbs:ENTRY(ix) in frame browse.
   s_lst_Dbs:screen-value in frame browse = lname.
   display lname @ s_DbFill with frame browse.
end.
else
   display "" @ s_DbFill with frame browse.

/* Switch to the new database.  This will reset s_CurrDb */
s_ask_gateconn = no.
run adedict/DB/_switch.p.



/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*-----------------------------------------------------------------------

File: _getdbs.p

Description:   
   This procedure gets the list of databases as follows:

   This includes:
      all connected databases and foreign databases whose schema holders
      are connected.

Shared Output:
   s_CurrDb    	  - will have been set.

Author: Laura Stern

Date Created: 01/28/92 

History:    
     laurief       12/18/97    Made V8 to "generic version" changes
     mcmann        10/29/98    Change message to read V9 Dictionary
     mcmann        11/23/02    Changed adecomm/_dictdb.p to prodict/_dictdb.p
     mcmann        07/24/03    Changed for V10
     mcmann        09/23/03    Changed message to remove version of dictionary
-----------------------------------------------------------------------*/

{ adedict/dictvar.i shared }
{ adedict/brwvar.i  shared }

{ adecomm/getdbs.i
  &new = "NEW"
  }

Define var l_i     as int     NO-UNDO.
Define var l_strng as char    NO-UNDO.

/*------------------------  INT.-PROCEDURES  -----------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/

/* initialize cache */
assign
  s_DbCache_Cnt        = 0
  s_lst_dbs:list-items = "".

/* get list of dbs */
if NUM-DBS <> 0 
 then do:
  RUN prodict/_dictdb.p.
  RUN adecomm/_getdbs.p.
  end.
  
/* create cache and selection-list */
for each s_ttb_db:
  
  /* get rid of older versions, because we can't handle them and
   * Keep track of these old connected databases so we don't keep
   * repeating this message to the user every time they connect
   * to a new database.
   */
  if INTEGER(s_ttb_db.vrsn) < 10
   then do:
    if NOT CAN-DO (s_OldDbs, s_ttb_db.ldbnm)
     then do:
      assign
        s_OldDbs = s_OldDbs
                 + (if s_OldDbs = "" then "" else ",")
                 + s_ttb_db.ldbnm.
        l_strng  = "V" + s_ttb_db.vrsn.
      message 
        "Database" s_ttb_db.ldbnm "is a" l_strng "database." SKIP
        "This dictionary cannot be used with a" SKIP
        "PROGRESS" l_strng "database.  Use the dictionary" SKIP
        "under PROGRESS" l_strng "to access this database." SKIP(1)
        "(Note: Database" s_ttb_db.ldbnm "is still connected.)"
         view-as ALERT-BOX INFORMATION buttons OK.
      end.
    next.
    end.

  /* Skip auto-connect records
   */
  if   s_ttb_db.local = FALSE
   and s_ttb_db.dbtyp = "PROGRESS"
   then next.
   
  /* check for number of dbs to be maller than extent */
  if EXTENT(s_DbCache_Pname) <= s_DbCache_Cnt
   then next.

  assign
    /* Add the name to the select list in the browse window. */
    s_Res = ( if s_ttb_db.local = TRUE
                then s_lst_Dbs:add-last(s_ttb_db.ldbnm) in frame browse
                else s_lst_Dbs:add-last( " " + s_ttb_db.ldbnm
                                       + "(" + s_ttb_db.sdbnm + ")"
                                       ) in frame browse
            )
    /* generate internal db-type */
    l_strng = { adecomm/ds_type.i
                 &direction = "etoi"
                 &from-type = "s_ttb_db.dbtyp"
              }

    /* Add database to the cache. */
    { adedict/DB/cachedb.i
       &Lname  = s_ttb_db.ldbnm
       &Pname  = s_ttb_db.pdbnm
       &Holder = s_ttb_db.sdbnm
       &Type   = l_strng
       }

  end.  /* for each s_ttb_db */


/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _getrdbs.p

Description:   
   Get the list of foreign databases for which the current database is a
   schema holder looking through the _Db file.

   Add each one to the cache of databases making sure that it is not
   already there.

Author: Laura Stern

Date Created: 01/28/92 
     History: 10/17/03 DLM Add NO-LOCK statement to _Db find in support of on-line schema add

----------------------------------------------------------------------------*/


{adedict/dictvar.i shared}
{adedict/brwvar.i shared}


Define var lname as char    NO-UNDO.

lname = LDBNAME("DICTDB"). /* logical name for current database */

db_record:
for each _Db NO-LOCK:
   if s_lst_Dbs:LOOKUP(_Db._Db-name) in frame browse = 0 then 
   do:
      /* If foreign (a slave) the schema holder is the current database. 
         We know we can look at schema info so put it in the list even if
         gateway type is not supported by the current executable.  If it's
         not we won't allow user to try to connect to it. (los 12/27/94)
      */
      if _Db._Db-slave then
      do:
      	 s_Res = s_lst_Dbs:add-last(_Db._Db-name) in frame browse.

      	 /* Physical name will only be set if this database is connected.
      	    Otherwise, it will be ? */
      	 {adedict/DB/cachedb.i &Lname  = _Db._Db-name
      	       	     	       &Pname  = PDBNAME(_Db._Db-name)
      	       	     	       &Holder = lname
      	       	     	       &Type   = CAPS(_Db._Db-type)}
      end.
   end.
end.

return.

/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _newdb.p

Description:   
   Put up a dialog box to get parameters for creating a new database.
   and create the database by calling prodb.  Most of this code has been
   put into a common dialog service so it can be called from outside
   the dictionary.

Author: Laura Stern

Date Created: 01/27/92

----------------------------------------------------------------------------*/

{adedict/dictvar.i shared}
{adedict/brwvar.i shared}


/*------------------------------ Mainline code ------------------------------*/

Define var newdb  as char     NO-UNDO.
Define var olddb  as char     NO-UNDO.
Define var stat   as logical  NO-UNDO.

assign
   newdb = ""
   olddb = ""
   current-window = (if s_win_Logo = ? then s_win_Browse else s_win_Logo).

run adecomm/_dbcreat.p (INPUT olddb, INPUT-OUTPUT newdb).

if newdb <> ? then
   run adedict/DB/_connect.p (INPUT newdb).
/**********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

/*----------------------------------------------------------------------------

File: _switch.p

Description:
   Do what has to be done when the user selects a different database.
   This is also called on startup to set up for the default database selection
   or after connecting a new database since this becomes the selected one
   by default.

Author: Laura Stern

Date Created: 01/31/92 
     History: D. McMann 02/21/03 Replaced GATEWAYS with DATASERVERS
              fernando  06/12/06 Support for int64

----------------------------------------------------------------------------*/
  
{adedict/dictvar.i shared}
{adedict/menu.i shared}
{adedict/brwvar.i shared}

Define var is_progress	as logical init true NO-UNDO.
Define var useable_db   as integer           NO-UNDO.
Define var answer       as logical           NO-UNDO.
Define var l_CurrDB     as character         NO-UNDO.

/* Parameters for getting datatype info for gateway. */
Define var io1        as integer NO-UNDO.
Define var io_length  as integer NO-UNDO.
Define var pro_type   as char    NO-UNDO.
Define var gate_type  as char    NO-UNDO.
Define var out1       as char    NO-UNDO.

DEFINE VAR cTemp      AS CHAR    NO-UNDO.

/*-------------------------Mainline Code-------------------------------*/

CURRENT-WINDOW = s_win_Browse.

/* Reset CurrDb and the index into the cache. */
assign
  l_CurrDB     = s_lst_Dbs:screen-value in frame browse
  l_CurrDB     = ( if l_CurrDB = ?
                    then ""
                    else l_CurrDB
                 )
  s_DbCache_ix = ( if l_CurrDB = ""
                    then 0
                    else s_lst_Dbs:LOOKUP(l_CurrDB) in frame browse
                 )
  io_length    = index(l_CurrDB,"(") - 2
  s_CurrDB     = (if io_length < 0
                    then l_CurrDB
                    else substring(l_CurrDB,2,io_length,"character")
                 ).

/* Set the alias DICTDB.  Inside the dictionary, DICTDB is always a
   Progress database - which means it is the schema holder database when
   we are working with a foreign database. 

   Outside of the dictionary, DICTDB may be either a progress database or
   a gateway database.
*/
if s_CurrDB <> "" then
do:
   is_progress = (if {adedict/ispro.i} then true else false).
   s_DictState = {&STATE_NO_OBJ_SELECTED}. /* i.e. no obj selected */
                                           /*        in working db */

   if is_progress then
      create alias "DICTDB" for database VALUE(s_CurrDB) NO-ERROR.
   else 
      create alias "DICTDB" for database 
      	 VALUE(s_DbCache_Holder[s_DbCache_ix]) NO-ERROR.

   /* Determine if the we will be in read-only mode for this database. If
      it is a foreign db that's not connected, we can't the info - so
      assume, it's not read only.
   */
   s_DB_ReadOnly = can-do (DBRESTRICTIONS(s_CurrDB), "Read-Only").
   if s_DB_ReadOnly = ? then s_DB_ReadOnly = no.

   /* Set the record Id for:
      	 1) the _Db record for this database      	 

      Note: This must be done in a separate .p so that it uses the alias
      	    we just set up against the current database.
   */
   run adedict/_setid.p (INPUT {&OBJ_DB}, OUTPUT s_DbRecId).   
   
   /* check if this is a 10.1B db at least, so that we complain about int64 and
      int64 values. If the LARGE_KEYS feature is not known by this db, then this
      is a pre-101.B db 
   */
   ASSIGN is-pre-101b-db = YES
          s_Large_Seq = ?.

   RUN prodict/user/_usrinf3.p 
      (INPUT  LDBNAME("DICTDB"),
       INPUT  "PROGRESS",
       OUTPUT ctemp, 
       OUTPUT ctemp,
       OUTPUT s_Large_Seq,
       OUTPUT answer).
      
  /* if large_keys is not known by db, answer will be ? */
  IF answer NE ? THEN
     ASSIGN is-pre-101b-db = NO.

end.
else do:
   s_DictState = {&STATE_NO_DB_SELECTED}.
   delete alias "DICTDB".
end.

/* If this is a foreign db, fill the user_env variable which holds 
   data type and default info for this gateway.  We'll need it everytime
   we add or modify a field - might as well just get it once.
*/
if s_CurrDB <> "" AND NOT is_progress then
do:
   {adedict/gateproc.i &Suffix = "_typ" &Name = "s_Gate_Typ_Proc"} 

   /* This will not fill the in/out parms - instead user_env[11] -
      user_env[15] are filled with stuff.  We tell xxx_typ to do this by
      setting both pro_typ and gate_type to ?.  Also set io_length to
      anything but ? to indicate for rms that we want expanded data 
      type list.
   */
   assign 
      pro_type = ?
      gate_type = ?
      io_length = ?. 
   run VALUE(s_Gate_Typ_Proc) 
     ( INPUT-OUTPUT io1,
       INPUT-OUTPUT io_length,
       INPUT-OUTPUT pro_type,
       INPUT-OUTPUT gate_type,
       OUTPUT       out1
     ). 
end.

/* Now hide/view stuff.  When we select a new database, we clear all
   the info from the old database. This also adjusts menu/browse graying.  
*/
useable_db = if s_CurrDB = "" then 0 else 1.
run adedict/_brwadj.p (INPUT {&OBJ_DB}, INPUT useable_db).

/* You can get at the schema for Foreign databases even if they're not
   connected - but give user the option to connect.
*/
if s_ask_gateconn AND NOT is_progress AND NOT CONNECTED(s_CurrDB) then
do:
   /* los - added 12/27/94 - also see _getrdbs.p */
   if NOT CAN-DO(DATASERVERS, s_DbCache_Type[s_DbCache_ix]) then do:
      s_Browse_Stat = 
      "This module does not support connections to this Data Server type.".
      display s_Browse_Stat with frame browse.
      /* this will get erased as soon as we come back down through
         dcttran and artificially "click" on table icon.  So just pause
         a bit so user can read this.  
      */
      pause(2) no-message.
   end.
   else do:
     message "In order to access user's data in database" s_CurrDB
                                                                {&SKIP}
             "it must be connected.  Do you want to connect now?"
              view-as ALERT-BOX QUESTION buttons YES-NO update answer.
       
     if answer then
        run adedict/DB/_connect.p (INPUT s_CurrDB).
   end.
end.
s_ask_gateconn = yes.  /* reset to default */

/* Menugray doesn't take care of disconnect option - so do that */
assign
   MENU-ITEM mi_Disconnect:sensitive = 
      (if s_CurrDB = "" then false
       else if CONNECTED(s_CurrDB) then true 
       else false).

/* If database is read only make sure user is told so he knows why things
   are grayed out.  If the dictionary is read only for another reason
   we will have already gotten a message so don't bother.
*/
if s_DB_ReadOnly and NOT s_ReadOnly then
   message "Note: This is a read-only database.  You will not be" SKIP
   	   "allowed to modify any schema objects."
      view-as ALERT-BOX INFORMATION buttons OK.

return.







/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: cachedb.i

Description:
   Include file for code to store a new database into the database cache.

Arguments:
   &Lname   - Logical name to store
   &Pname   - Physical name to store
   &Holder  - Name of the schema holder
   &Type    - Database type.

Author: Laura Stern

Date Created: 03/03/92 

----------------------------------------------------------------------------*/


s_DbCache_Cnt = s_DbCache_Cnt + 1.

s_DbCache_Pname[s_DbCache_Cnt]  = {&Pname}.
s_DbCache_Holder[s_DbCache_Cnt] = {&Holder}.
s_DbCache_Type[s_DbCache_Cnt]  = {&Type}.


/*********************************************************************
* Copyright (C) 2006 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: dbprop.f

Description:   
   This file contains the form for displaying some database properties.
   This information will be read-only.

Author: Laura Stern

Date Created: 03/05/92 

History:
    tomn    01/10/96    Added codepage to DB Properties form (s_Db_Cp)
    fernando 06/06/06    Added large sequence and keys to DB Properties form
        
----------------------------------------------------------------------------*/

form
   SKIP({&TFM_WID})

   s_CurrDb    	 LABEL "Logical Name" 	 colon 17
                 FORMAT "x(32)" view-as TEXT       SKIP
   s_Db_Pname 	 LABEL "Physical Name"	 colon 17  
                 FORMAT "x(50)" view-as TEXT       SKIP
   s_Db_Holder	 LABEL "Schema Holder"	 colon 17  
                 FORMAT "x(32)" view-as TEXT       SKIP
   s_Db_Type 	 LABEL "Type"	      	 colon 17
                 FORMAT "x(12)" view-as TEXT        SKIP
   s_Db_Cp       LABEL "Codepage"        colon 17
                 FORMAT "x(32)" view-as TEXT    SKIP      
   s_Db_Large_Sequence LABEL "64-bit Sequences" colon 17
                 FORMAT "x(12)" view-as TEXT SKIP
   s_Db_Large_Keys LABEL "Large Key Entries"     colon 17 
                 FORMAT "x(12)" view-as TEXT    SKIP    
   s_Db_Description  LABEL "Description" colon 17
                FORMAT "X(70)" view-as FILL-IN size 30 BY 1
   s_Db_Add_Details LABEL "Additional Details" colon 17
                FORMAT "X(3000)" view-as EDITOR INNER-CHARS 50 INNER-LINES 3 
                SCROLLBAR-VERTICAL
               

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}

   with frame dbprops SIDE-LABELS NO-BOX DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel.


/*********************************************************************
* Copyright (C) 2006 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: dbvar.i

Description:   
   Include file which defines the user interface components for database
   properties.
 
Arguments:
   {1} - this is either "new shared" or "shared".

Author: Laura Stern

Date Created: 03/03/92

History:
    tomn     01/10/96    Added codepage to DB Properties form (s_Db_Cp)
    fernando 06/06/06    Added large sequence and keys to DB Properties form
    
----------------------------------------------------------------------------*/

Define {1} frame dbprops.  /* database properties */

Define {1} var s_Db_Pname  as char NO-UNDO.
Define {1} var s_Db_Holder as char NO-UNDO.
Define {1} var s_Db_Type   as char NO-UNDO.
Define {1} var s_Db_Cp     as char NO-UNDO.
Define {1} var s_Db_Description  as char NO-UNDO.
Define {1} var s_Db_Add_Details as char NO-UNDO.
DEFINE {1} VAR s_Db_Large_Sequence AS CHAR NO-UNDO.
DEFINE {1} VAR s_Db_Large_Keys AS CHAR NO-UNDO.

/* This is the form for the database properties window. */
{adedict/DB/dbprop.f} 



/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

/*----------------------------------------------------------------------------

File: _savdbprop.p

Description:
   Save any changes the user made in the db property window. 

Returns: "error" if the save is not complete for any reason, otherwise "".

Author: Fernando de Souza

Date Created: 05/24/2005
    Modified: 

----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adedict/DB/dbvar.i shared}

DEFINE VARIABLE changed          AS LOGICAL       NO-UNDO INITIAL NO.
DEFINE VARIABLE new-description AS CHARACTER NO-UNDO.
DEFINE VARIABLE new-add-details AS CHARACTER NO-UNDO.

/* check if the field is enabled for input. If not, just return. */
IF NOT s_Db_Description:sensitive in frame dbprops THEN
    return "".

DEFINE VAR hBuffer AS HANDLE NO-UNDO.

do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:

   run adecomm/_setcurs.p ("WAIT").

   /* find the _db record */
   find dictdb._db where recid(dictdb._db) = s_DbRecId NO-LOCK NO-ERROR.
   
   /* find the _db-detail record for this _db record */
   CREATE BUFFER hBuffer FOR TABLE "DICTDB._Db-detail" NO-ERROR.

   IF VALID-HANDLE(hBuffer) THEN
       hBuffer:FIND-FIRST ("where _db-guid = " + QUOTER(dictdb._db._db-guid) ) NO-ERROR.

   /* get the values from the screen buffer */
   ASSIGN new-description = INPUT FRAME dbprops s_db_description
                new-add-details = INPUT FRAME dbprops s_Db_Add_Details.

   /* check if the value has changed and update them */
   IF hBuffer::_Db-description <>  new-description  THEN DO:
       ASSIGN changed = YES
                    hBuffer::_Db-description =  new-description.
   END.

   IF hBuffer::_Db-custom-detail <>  new-add-details  THEN DO:
       ASSIGN changed = YES
                    hBuffer::_Db-custom-detail = new-add-details.
   END.

   DELETE OBJECT hBuffer.

   /* if the user changed anything, set the dirty flag */
   IF changed THEN
       {adedict/setdirty.i &Dirty = "true"}.

   run adecomm/_setcurs.p ("").
   return "".
end.

run adecomm/_setcurs.p ("").
return "error".



/*********************************************************************
* Copyright (C) 2006-2008 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _dfltfmt.p

Description:
   Set the format to it's default value based on the data type, conditional
   upon the value of p_Default.  In any case, fix the initial value if
   the data type is logical, to be consistent with the current or new default
   format.

Shared Input (The following shared variables must have been set):
   if database is Progress:
      s_Fld_Typecode  - data type code corresponding to currently selected data
      	       	        type.
   else
      s_Fld_Gatetype  - The gateway data type string (short form)
      s_Fld_Protype   - Progress data type that this gateway type maps to.
      s_Gate_Typ_Proc - The procedure to call to get the format/type info for
      	       	        the current gateway type.
   
Input Parameters:
   p_Format  - The format widget handle.
   p_Initial - The initial value widget handle.
   p_Default - True, if caller wants format set to the default unconditionally,
      	       False if we should only set default if the current format value
      	       is the null string. 

Author: Laura Stern

Date Created: 08/05/92 
Modified: 01/31/03 D. McMann Added support for lobs
          07/01/03 D. McMann Added support for Date-time and Date-time-tz
          05/24/06 fernando  Added support for int64 datatype
          02/14/08 fernando support for datetime/tz - DataServers

----------------------------------------------------------------------------*/

&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adecomm/cbvar.i shared}
{adedict/uivar.i shared}
{adedict/FLD/fldvar.i shared}

Define INPUT PARAMETER p_Format  as widget-handle NO-UNDO.
Define INPUT PARAMETER p_Initial as widget-handle NO-UNDO.
Define INPUT PARAMETER p_Length  as integer       NO-UNDO.
Define INPUT PARAMETER p_Default as logical       NO-UNDO.

Define var io1 as integer  NO-UNDO.  
Define var fmt as char     NO-UNDO.

fmt = p_Format:screen-value.
if p_Default OR (fmt = "" OR fmt = "?") then
do:
   /*Reset format to its default for this data type */
   assign fmt = ?.

   if NOT {adedict/ispro.i} then
      run VALUE(s_Gate_Typ_Proc) 
      	 (INPUT-OUTPUT io1, 
	  INPUT-OUTPUT p_Length,
	  INPUT-OUTPUT s_Fld_Protype, 
	  INPUT-OUTPUT s_Fld_Gatetype,
	  OUTPUT fmt).

   if io1 <> b_Field._fld-stdtype
    then assign b_Field._fld-stdtype = io1.

   if fmt = ? OR fmt = "?" then
   case s_Fld_Typecode:
	 when {&DTYPE_CHARACTER} OR WHEN {&DTYPE_RAW} OR
     WHEN {&DTYPE_BLOB}      OR WHEN {&DTYPE_CLOB} OR
     WHEN {&DTYPE_XLOB} THEN
	    fmt = "x(8)".
	 when {&DTYPE_DATE} then
	    fmt = "99/99/99".
     when {&DTYPE_DATETM} then
	    fmt = "99/99/9999 HH:MM:SS.SSS".
     when {&DTYPE_DATETMTZ} then
	    fmt = "99/99/9999 HH:MM:SS.SSS+HH:MM".
	 when {&DTYPE_LOGICAL} then
	    fmt = "yes/no".
	 when {&DTYPE_INTEGER} OR WHEN {&DTYPE_INT64} then
	    fmt = "->,>>>,>>9".
	 when {&DTYPE_DECIMAL} then
	    fmt = "->>,>>9.99".
	 when {&DTYPE_RECID} then
	    fmt = ">>>>>>9".
   end.
   else case fmt:
	 when "c"  then
	    fmt = "X(8)".
	 when "d"  then
	    fmt = "99/99/99".
	 when "l"  then
	    fmt = "yes/no".
	 when "i"  then
	    fmt = "->,>>>,>>9".
	 when "#"  then
	    fmt = "->>,>>9.99".
	 when "dt" then
	    fmt = "99/99/9999 HH:MM:SS.SSS".
	 when "dtz" then
	    fmt = "99/99/9999 HH:MM:SS.SSS+HH:MM".
      end.

   p_Format:screen-value = fmt.
end.

if s_Fld_Typecode = {&DTYPE_LOGICAL} then
   /* Reset the initial value to the first string in the format, e.g.,
      set to "male" if format is male/female.  However, special case
      yes/no and true/false to initialize to no and false respectively
      since that is what Progress does.
   */
if S_Adding then do:
   if fmt = "yes/no" then
      p_Initial:screen-value = "no".
   else if fmt = "true/false" then
      p_Initial:screen-value = "false".
   else
      p_Initial:screen-value = SUBSTR(fmt, 1, INDEX(fmt, "/") - 1).
 end.

 if (s_Fld_Typecode = {&DTYPE_BLOB} OR 
     s_Fld_Typecode = {&DTYPE_CLOB} OR
     s_Fld_Typecode = {&DTYPE_XLOB} OR
     s_Fld_Typecode = {&DTYPE_DATETM} OR
     s_Fld_Typecode = {&DTYPE_DATETMTZ}) 
     AND S_Adding  then
       p_Initial:SCREEN-VALUE = ?.
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _dfltgat.p

Description:
   Default some unknown values to a reasonable default.  If the user
   never brings up the gateway dialog, this will be called to set defaults
   so the user won't get errors on adding new fields.  If the user does
   come into the gateway dialog, this will be called to set the defaults
   at that time.

Input Parameter:
   p_copy - this is being called for a copied field.  Don't do spacing
      	    processing.

Author: Laura Stern

Date Created: 08/16/93

----------------------------------------------------------------------------*/

&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/uivar.i shared}
{adedict/FLD/fldvar.i shared}

DEFINE INPUT PARAMETER p_copy AS LOGICAL NO-UNDO.

Define var db_type as char NO-UNDO.
Define var odbtyp  as char NO-UNDO.

/*==========================Internal Procedures==============================*/

/*-----------------------------------------------------------------------
   The field offset for a new field is based on the offset and length
   of the last field.  Otherwise, it is the stored offset value.

   Spacing is used when elements in array are not contiguous. It tells 
   how far away the next array element is.  Clearly it must not be less
   than the field length so default it wisely.

-----------------------------------------------------------------------*/
Procedure Set_FlatFile_Defaults:

   Define var ext as integer NO-UNDO.

   if b_Field._Fld-stoff = ? then
   do:
      find LAST _Field USE-INDEX _Field-Position 
      	 where _Field._File-recid = s_TblRecId AND
      	       _Field._Field-name <> b_Field._Field-name.

      b_Field._Fld-stoff = 
      	 (if AVAILABLE _Field 
      	     then _Field._Fld-stoff 
                  + (if _Field._Fld-stlen < _Field._For-spacing
                     then _Field._For-spacing else _Field._Fld-stlen)
                  * (if _Field._Extent > 1 then _Field._Extent else 1)
             else ?).
   end.
   
   if NOT p_copy then 
   do:
      ext = (if s_Adding then input frame newfld b_Field._Extent
			 else input frame fldprops b_Field._Extent).
      if ext > 0 AND b_Field._For-spacing = ? AND b_Field._Fld-stlen > 0 then
	 b_Field._For-spacing = b_Field._Fld-stlen.
   end.
end.


/*-----------------------------------------------------------------------
   The field offset for a new field is a sequential column #.  This
   must be set for the field to be added properly.

-----------------------------------------------------------------------*/
Procedure Set_ODBC_Defaults:
   if b_Field._Fld-stoff = ? then
   do:
      define query qry for _Field.
      open query qry 
        for each _Field 
      	  where _Field._File-recid = s_TblRecId AND
      	        _Field._Field-name <> b_Field._Field-name
          by _Field._Fld-stoff.
      get last qry.

      b_Field._Fld-stoff = 
      	 (if AVAILABLE _Field 
      	     then _Field._Fld-stoff + 1
             else 1
         ).
      close query qry.
   end.
   if b_Field._For-Name = ? then
      b_Field._For-Name = "NONAME".
end.


/*==============================Mainline Code================================*/

assign
  db_type = s_DbCache_Type[s_DbCache_ix]
  odbtyp  = {adecomm/ds_type.i
               &direction = "ODBC"
               &from-type = "db_type"
            }.

/* Run the appropriate routine, based on the gateway. */
case (db_type):
   when "CISAM" OR
   when "NETISAM" OR
   when "CTOSISAM" OR
   when "RMS" then
      run Set_FlatFile_Defaults.

   otherwise if can-do(odbtyp,db_type) then
      run Set_ODBC_Defaults.
end.




/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _domprop.p

Description:
   Set up the domain properties window so the user can view or modify the 
   information on a domain.  Since this window is non-modal, we just do the
   set up here.  All triggers must be global.

   All of this code is in an include file so that we can use it for fields
   and domains.

Author: Laura Stern

Date Created: 02/05/92 

----------------------------------------------------------------------------*/

/*------------------------------------------------------------------
   Comment out the whole thing until (if ever) we support domains)

&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/FLD/fldvar.i shared}



find _File "_Field".  /* FIX? or do we look for _Domain table? */
if NOT can-do(_File._Can-read, USERID("DICTDB")) then
do:
   message s_NoPrivMsg "see domain definitions."
      view-as ALERT-BOX ERROR buttons Ok in window s_win_Browse.
   return.
end.

/* Don't want Cancel if moving to next domain - only when window opens */
if s_win_Dom = ? then
   s_btn_Close:label in frame domprops = "Cancel".

/* Open the window if necessary */
run adedict/_openwin.p
   (INPUT   	  "Domain Properties",
    INPUT   	  frame domprops:HANDLE,
    INPUT         {&OBJ_DOM},
    INPUT-OUTPUT  s_win_Dom).

display "" @ s_Status with frame domprops. /* clears from last time */

s_Dom_ReadOnly = (s_ReadOnly OR s_DB_ReadOnly).
if NOT s_Dom_ReadOnly then
   if NOT can-do(_File._Can-write, USERID("DICTDB")) then
   do:
      display s_NoPrivMsg +" modify domain definitions." @ s_Status
      	 with frame domprops.
      s_Dom_ReadOnly = true.
   end.

{adedict/FLD/fdprop.i &Frame 	 = "frame domprops"
      	       	       &ReadOnly = "s_Dom_ReadOnly"}


------------------------------------------------------------------*/
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _dtcust.p

Description:
   Do data type customization.  This means changing visibility or labels
   of fields based on their relevance to the currently selected data type.
   For the fields affected, also take gateway capabilities and other 
   factors into account.

Shared Input:
   s_Fld_Typecode - The underlying code for data type
   s_Fld_Gatetype - The gateway data type.

Input Parameters:
   p_Case - Widget handle for the case sensitive widget.
   p_Dec  - Widget handle for the decimals widget.

Author: Laura Stern

Date Created: 10/02/92

History:
    tomn    07/96   Changed code to set the screen-value of the _decimals
                    field to "?" when field was disabled (before, it would set
                    the screen-value to "0").  Some foreign
                    character fields use this field to store length info, and
                    it was being overwritten if/when the "save" button was
                    pressed.  Also, this change makes it consistent with the
                    TTY dictionary.
    D. McMann 06/09/03 Added data type CLOB to check for case sensitivity

----------------------------------------------------------------------------*/

&GLOBAL-DEFINE WIN95-BTN YES
{adecomm/adestds.i} 

{adedict/dictvar.i shared}
{adecomm/cbvar.i shared}
{adedict/uivar.i shared}
{adedict/FLD/fldvar.i shared}
{adedict/capab.i}

Define INPUT PARAMETER p_Case as widget-handle NO-UNDO.
Define INPUT PARAMETER p_Dec  as widget-handle NO-UNDO.

assign
   p_Case:sensitive = (if (s_Fld_Typecode = {&DTYPE_CHARACTER} OR s_Fld_Typecode = {&DTYPE_CLOB} )
                       AND INDEX(s_Fld_Capab, {&CAPAB_CHANGE_CASE_SENS}) > 0 AND
      	       	       (s_Adding OR NOT s_Fld_InIndex)
      	       	      then yes else no)
   p_Dec:sensitive = (if s_Fld_Typecode = {&DTYPE_DECIMAL} OR
      	       	      s_Fld_Gatetype = "Bits" then yes else no)
   p_Dec:label = (if s_Fld_Gatetype = "Bits" then "Bit Off&set" 
      	       	     	      	       	     else "Decimal&s").

if p_Case:sensitive = no then
   p_Case:screen-value = "no".
if p_Dec:sensitive = no then
   p_Dec:screen-value = /*"0"*/ ?.







/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _fldcopy.p

Description:
   Display and handle the field copy dialog box.

Input-Output Parameters:
   p_Order -  This is set to the last order# assigned to a copied field
      	      If no field is successfully copied, or the user chooses
      	      copy-modify first, the input value is left as is.

Output Parameters:
   p_Tbl   - The name of the table chosen if user hit Copy with Modify,
      	     otherwise it is set to "".
   p_Fld   - The name of the field chosen if user hit Copy with Modify.
      	     otherwise it is set to "".
   p_Copied- Set to yes if any field was copied successfully.

Author: Laura Stern

Date Created: 06/15/92 

History:
     tomn    12/05/95    Remove "choose of s_btn_Help" from the WAIT-FOR so 
                        you don't exit the program when you press HELP
     D. McMann 06/29/98  Added WHERE (_owner = "PUB" or _owner = "_FOREIGN")
                         to _File Find.
     D. McMann 02/24/03  Added BLOB support
     D. McMann 10/08/03  Added CLOB support 20031007-038

----------------------------------------------------------------------------*/


&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adedict/FLD/fldvar.i shared}

Define INPUT-OUTPUT PARAMETER p_Order  as integer  NO-UNDO.
Define OUTPUT  	    PARAMETER p_Tbl    as char     NO-UNDO.
Define OUTPUT  	    PARAMETER p_Fld    as char     NO-UNDO.
Define OUTPUT       PARAMETER p_Copied as logical  NO-UNDO init no.


Define var cpy_lst_Tbls as char NO-UNDO
   view-as SELECTION-LIST SINGLE INNER-CHARS 28 INNER-LINES 8 
   SCROLLBAR-V SCROLLBAR-H.
Define var cpy_lst_Flds as char NO-UNDO
   view-as SELECTION-LIST MULTIPLE INNER-CHARS 28 INNER-LINES 8 
   SCROLLBAR-V SCROLLBAR-H.

Define button btn_Copy_AsIs label "&Copy As Is" 	      	
   SIZE 15 by {&H_OKBTN} MARGIN-EXTRA DEFAULT AUTO-GO.
Define button btn_Copy_Mod  label "&Modify First" 
   SIZE 15 by {&H_OKBTN} MARGIN-EXTRA DEFAULT AUTO-GO.
Define button btn_Cancel1    label "Cancel"	
   SIZE 15 by {&H_OKBTN} MARGIN-EXTRA DEFAULT AUTO-ENDKEY.
Define button btn_Skip 	    label "&Skip" {&STDPH_OKBTN} AUTO-GO.

/* Id of the table selected in this dialog box.  Note s_TblRecId is the
   recid of the table we're adding fields to. */
Define var cpy_Recid as RECID NO-UNDO.

Define var cpy_Name     as char    NO-UNDO.
Define var cpy_Order    as integer NO-UNDO.
Define var cpy_Skipped  as logical NO-UNDO init false.
Define var stat         as char    NO-UNDO.


/*===============================Forms===================================*/

FORM 
   skip({&TFM_WID})
      "Select the fields to copy from the field list.             " at 2 view-as TEXT 
   skip({&VM_WIDG})

      "Tables:"      at 2  view-as text
      "Fields:"      at 37 view-as text
   skip({&VM_WID})
      cpy_lst_Tbls   at 2  NO-LABEL 
      cpy_lst_Flds   at 37 NO-LABEL 

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = btn_Copy_AsIs
      &CANCEL = btn_Copy_Mod  /* in place of where cancel btn usually is */
      &OTHER  = btn_Cancel1
      &HELP   = s_btn_Help}

   with frame fldcopy 
      DEFAULT-BUTTON btn_Copy_AsIs CANCEL-BUTTON btn_Cancel1
      TITLE "Copy Field(s)" view-as DIALOG-BOX.


/* Form which allows user to rename if there is a name conflict. */
FORM
   skip({&TFM_WID})
   "A field with this name already exists in the      "      at 2
       view-as TEXT 
   "destination table.  If you still want to copy it,      " at 2 
       view-as TEXT 
   "enter a unique name and press OK.  Otherwise      "      at 2
       view-as TEXT
   "press the Skip button.      "                            at 2
       view-as TEXT
   skip({&VM_WIDG})

   cpy_Name label "&Field name"  format "x(32)"        at 2 {&STDPH_FILL}

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &OTHER  = "SPACE({&HM_DBTNG}) btn_Skip"
      &HELP   = s_btn_Help}

   with frame rename 
        DEFAULT-BUTTON s_btn_OK  CANCEL-BUTTON btn_Skip
        title "Rename Field" view-as DIALOG-BOX 
        SIDE-LABELS.


/* Status frame */
FORM
   SKIP(1)
   SPACE(3) stat format "x(32)" LABEL "Copying" SPACE
   SKIP(1)
   with frame copying SIDE-LABELS view-as dialog-box.


/*=========================Internal Procedures===============================*/

/*------------------------------------------------------------------
   Fill the field list with fields for the currently selected
   table.
------------------------------------------------------------------*/
PROCEDURE Fill_Field_List:
   Define var access  as logical NO-UNDO.

   /* Refresh the field list to show fields for the selected table. */
   find _File where 
      	 _File._File-Name = cpy_lst_Tbls:screen-value in frame fldcopy AND
        _File._DB-recid = s_DbRecId AND
        (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN").
   cpy_Recid = RECID(_File).

   if NOT cpy_lst_Flds:visible in frame fldcopy then
      cpy_lst_Flds:visible in frame fldcopy = yes.

   /* Fill the field list for the selected table. */
   cpy_lst_Flds:list-items in frame fldcopy = "".  /* clear the list first */
   run adecomm/_fldlist.p
      (INPUT   cpy_lst_Flds:HANDLE in frame fldcopy,
       INPUT   cpy_Recid,
       INPUT   (if s_Order_By = {&ORDER_ALPHA} then true else false),
       INPUT   "",
       INPUT   ?,
       INPUT   no,
       INPUT   "",
       OUTPUT  access).
   if NOT access then return.  /* no read permission on fields */

   /* Set selection to the first item. */
   cpy_lst_Flds:screen-value in frame fldcopy = 
      cpy_lst_Flds:entry(1) in frame fldcopy.
end.


/*========================Frame rename Triggers==============================*/

/*-----WINDOW-CLOSE (frame rename)-----*/
on window-close of frame rename
   apply "END-ERROR" to frame rename.


/*----- HIT of OK BUTTON or GO (frame rename) ----- */
on GO of frame rename	/* or OK due to AUTO-GO */
do:
   Define var name as char NO-UNDO.

   name = input frame rename cpy_Name.
   if name = "" OR name = ? then
   do:
      message "Please enter a new name for this field" SKIP
              "or press the Skip button to not copy this field."
               view-as ALERT-BOX ERROR  buttons OK.
      return NO-APPLY.
   end.
end.


/*----- LEAVE of NAME (frame rename) -----*/
on leave of cpy_Name in frame rename
do:
   Define var okay as logical NO-UNDO.

   /* Make sure the name is a valid identifier for Progress. */
   run adecomm/_valname.p (INPUT SELF:screen-value, INPUT true, OUTPUT okay).
   if NOT okay then
      return NO-APPLY.
end.


/*----- HIT of SKIP button (frame rename) -----*/
on choose of btn_Skip in frame rename
   cpy_Skipped = true.


/*----- HELP -----*/
on HELP of frame rename OR choose of s_btn_Help in frame rename
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Rename_Field_Dlg_Box}, ?).

      	 
/*========================Frame fldcopy Triggers==============================*/

/*----- HIT of COPY AS IS BUTTON -----*/

/*-----WINDOW-CLOSE (frame fldcopy)-----*/
on window-close of frame fldcopy
   apply "END-ERROR" to frame fldcopy.

/*----- CHOOSE of COPY AS IS -----*/
on choose of btn_Copy_AsIs in frame fldcopy
do:
   Define var num       as integer  NO-UNDO.
   Define var flds      as char     NO-UNDO.
   Define var fld#      as integer  NO-UNDO.
   Define var newname   as char     NO-UNDO.
   Define var ins_name  as char     NO-UNDO.
   Define var success   as logical  NO-UNDO init false.
   Define var canned    as logical  NO-UNDO.
   
   Define buffer cpy_Field for _Field.

   run adecomm/_setcurs.p ("WAIT").
   assign
      session:immediate-display = yes
      flds = cpy_lst_Flds:screen-value in frame fldcopy
      num = NUM-ENTRIES(flds).

   /* If the table we're copying to is empty, copy the order #s from the
      source fields.  Otherwise, generate new unique order #s and start
      by finding the highest one used in the existing table that we're
      copying to.  cpy_Order = ? flags that we'll copy orders from
      the source fields.
   */
   find LAST _Field USE-INDEX _Field-Position 
      where _Field._File-recid = s_TblRecId NO-ERROR.
   cpy_Order = (if AVAILABLE _Field then _Field._Order + 10 else ?).

   all_flds:
   do ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE ON STOP UNDO, LEAVE:
      cpy_loop:
      do fld# = 1 to num:
      	 cpy_Name = ENTRY(fld#, flds).
         find cpy_Field where cpy_Field._Field-Name = cpy_Name AND 
              cpy_Field._File-recid = cpy_Recid.
   
         /* Make sure there's no other field with this name in the 
            destination table.  If there is, give the user the chance
            to rename the field he is about to copy.
         */
         do while CAN-FIND (_Field where _Field._File-recid = s_TblRecId AND
                            _Field._Field-Name = cpy_Name):
      	    /* Turn off WAIT while in dlg */
      	    run adecomm/_setcurs.p ("").
      	    canned = true.
      	    do ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
	       update cpy_Name 
		      s_btn_Ok 
      	       	      s_btn_Cancel
		      btn_Skip 
		      s_btn_Help
		      with frame rename.
      	       canned = false.
      	    end.
      	    /* fields already copied are NOT undone */
      	    if canned then leave cpy_loop.

      	    run adecomm/_setcurs.p ("WAIT"). 
            if cpy_Skipped then 
            do:
               hide frame rename.
               cpy_Skipped = false.  /* reset flag */
               next cpy_loop.
            end.
         end.
         hide frame rename.

      	 display cpy_Field._Field-Name @ stat with frame copying.

         create b_Field.
      	 assign
            b_Field._File-recid = s_TblRecId
      	    b_Field._Field-name = cpy_Name
      	    b_Field._Data-type  = cpy_Field._Data-type
      	    b_Field._Format     = cpy_Field._Format
      	    b_Field._Initial    = cpy_Field._Initial
      	    b_Field._Order      = (if cpy_Order = ? then cpy_Field._Order
      	       	     	      	       	     	    else cpy_Order).
      	 {prodict/dump/copy_fld.i &from=cpy_Field &to=b_Field &all=false}

         IF b_field._Data-type = "BLOB" AND cpy_Field._Field-rpos <> ? THEN DO:
           FIND _storageobject WHERE _Storageobject._Db-recid = s_DbRecId
                                 AND _Storageobject._Object-type = 3
                                 AND _Storageobject._Object-number = b_Field._Fld-stlen
                                 NO-LOCK.
           ASSIGN b_field._Fld-stlen = _StorageObject._Area-number.
         END.
         ELSE IF b_field._Data-type = "CLOB" THEN DO:
           IF cpy_Field._Field-rpos <> ? THEN DO:
             FIND _storageobject WHERE _Storageobject._Db-recid = s_DbRecId
                                   AND _Storageobject._Object-type = 3
                                   AND _Storageobject._Object-number = b_Field._Fld-stlen
                                   NO-LOCK.
             ASSIGN b_field._Fld-stlen = _StorageObject._Area-number.
           END.
           ASSIGN b_field._Charset   = cpy_Field._Charset
                  b_Field._Collation = cpy_Field._Collation.
         END.
      	 /* Reset offset as if it was a new field to put at the end. */
      	 b_Field._Fld-stoff = ?.
      	 RUN adedict/FLD/_dfltgat.p (TRUE).
      	 find _File where RECID(_File) = s_TblRecId.
      	 if b_Field._Fld-stoff + b_Field._Fld-stlen > _File._For-Size then 
         do:
	    message "If this field is added, the record" SKIP
		    "size will be exceeded." SKIP
      	       	    "No more fields will be copied."
		    view-as ALERT-BOX ERROR buttons OK.
      	    undo all_flds, leave all_flds.
      	 end.

         /* Update the browse window to show this field in the
            field list. */
      	 run adedict/FLD/_ptinlst.p (INPUT b_Field._Field-Name,
      	       	     	      	     INPUT b_Field._Order).
         p_Copied = yes.

         if cpy_Order <> ? then
            cpy_Order = cpy_Order + 10.
      end.  /* cpy_loop */

      if p_Copied then 
      do:
         {adedict/setdirty.i &Dirty = "true"}
      	 p_Order = b_Field._Order.  /* Set to last order# used */
      end.
      success = true.
   end.  /* do on error block */

   hide frame copying no-pause.
   run adecomm/_setcurs.p ("").
   session:immediate-display = no.

   if success then
      return.
   else
      return NO-APPLY.  /* dialog will remain up if error. */
end.


/*----- HIT of COPY w/ MODIFICATION BUTTON -----*/
on choose of btn_Copy_Mod in frame fldcopy
do:
   /* Set the output parameters so newfld can fill
      field dialog with info from this field. */

   assign
      p_Fld = cpy_lst_Flds:screen-value in frame fldcopy
      p_Tbl = cpy_lst_Tbls:screen-value in frame fldcopy.
end.


/*----- VALUE-CHANGED of TBL LIST ----- */
on value-changed of cpy_lst_Tbls in frame fldcopy
   run Fill_Field_List.


/*----- VALUE-CHANGED of FLD LIST ----- */
on value-changed of cpy_lst_Flds in frame fldcopy
do:
   Define var num as integer NO-UNDO.

   assign
      num = NUM-ENTRIES(cpy_lst_Flds:screen-value in frame fldcopy)
      btn_Copy_Mod:sensitive in frame fldcopy = (if num = 1 then yes else no)
      btn_Copy_AsIs:sensitive in frame fldcopy = (if num = ? then no else yes).
end.


/*----- HELP -----*/
on HELP of frame fldcopy OR choose of s_btn_Help in frame fldcopy
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Copy_Fields_Dlg_Box}, ?).


/*============================Mainline code==================================*/

Define var access as logical NO-UNDO.


/* Make the field list invisible until the user makes a table choice. */
cpy_lst_Flds:visible in frame fldcopy = no.
cpy_lst_Flds:sensitive in frame fldcopy = yes.

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame fldcopy" 
   &BOX   = "s_rect_Btns"
   &OK    = "btn_Copy_AsIs" 
   &HELP  = "s_btn_Help"
}

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame rename" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}

enable cpy_lst_Tbls
       btn_Copy_AsIs
       btn_Copy_Mod
       btn_Cancel1
       s_btn_Help
   with frame fldcopy.

/* Fill the table list */
run adecomm/_tbllist.p
   (INPUT  cpy_lst_Tbls:HANDLE in frame fldcopy,
    INPUT  s_Show_Hidden_Tbls,
    INPUT  s_DbRecId,
    INPUT  "",
    INPUT "BUFFER,FUNCTION,PACKAGE,PROCEDURE,SEQUENCE,VIEW",
    OUTPUT access).
if NOT access then return.  /* no read permission on tables */

/* Set selection to first item */
cpy_lst_Tbls:screen-value in frame fldcopy = 
   cpy_lst_Tbls:entry(1) in frame fldcopy.

/* Forced display of field list here */
run Fill_Field_List.

/* Default output parameters */
assign
   p_Tbl = ""
   p_Fld = "".

do ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE:
   wait-for choose of btn_Cancel1   in frame fldcopy,
      	       	      btn_Copy_AsIs in frame fldcopy,
      	       	      btn_Copy_Mod  in frame fldcopy.
end.

hide frame fldcopy.
return.

/*********************************************************************
* Copyright (C) 2006 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _fldfmts.p

Description:
   Show example formats for the given data type and allow the user to
   choose one.

Input Parameters:
   p_Type - The current field data type (the numeric data type code).

Input/Output Parameters:
   p_Format - The format chosen or "" if user hit Cancel.

Author: Laura Stern

Date Created: 10/20/92 

Modified:
    hutegger    03/97   changed a view phrases to shorten and correct
    fernando    06/06/06 added format example for int64

----------------------------------------------------------------------------*/

&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/FLD/fldvar.i shared}


Define INPUT   	    PARAMETER p_Type   as integer  NO-UNDO.
Define INPUT-OUTPUT PARAMETER p_Format as char     NO-UNDO.

Define var ix        as integer       NO-UNDO.
Define var num       as integer       NO-UNDO.
Define var hlist     as widget-handle NO-UNDO. /* for convenience */
Define var fmt_list  as char  	      NO-UNDO.

Define var rule      as char  NO-UNDO.
Define var pre_rule  as char  NO-UNDO init "Valid format components are:".
Define var post_rule as char  NO-UNDO init "(Use Help for the full syntax.)".

&global-define NUM_CHAR_FMTS  7
Define var char_fmts as char extent {&NUM_CHAR_FMTS} NO-UNDO init
   [ "X(8)",
     "(999) 999-9999",
     "999-NNN-NNNN",
     "999-99-9999",
     "99999-9999",
     "!!",
     "A(10)"
   ].

Define var char_desc as char extent {&NUM_CHAR_FMTS} NO-UNDO init
   [ "Any 8 characters",
     "Phone #, all digits",
     "Phone #, 3 digits, 7 digits or letters",
     "Social Security Number",
     "Zip Code",
     "2 characters converted to upper case (e.g., State)",
     "Any 10 letters, no blanks"
   ].

&global-define NUM_INT_FMTS  5
Define var int_fmts as char extent {&NUM_INT_FMTS} NO-UNDO init
   [ "->,>>>,>>9",
     "99999",
     "99,999,999",
     "ZZZZZ9",
     "+>99"
   ].

Define var int_desc as char extent {&NUM_INT_FMTS} NO-UNDO init
   [ "Signed (if neg.), 7 digit #, leading 0's suppressed",
     "5 digit # (e.g., zip code)",
     "8 digit # with thousand separators",
     "6 digit #, leading zeroes replaced with blanks",
     "Signed 3 digit #, with at least 2 digits displayed"
   ].

&global-define NUM_INT64_FMTS  1
Define var int64_fmts as char extent {&NUM_INT64_FMTS} NO-UNDO init
   [ "->,>>>,>>>,>>9"].

Define var int64_desc as char extent {&NUM_INT4_FMTS} NO-UNDO init
   [ "Signed (if neg.), 10 digit #, leading 0's suppressed"
   ].

&global-define NUM_DEC_FMTS  6
Define var dec_fmts as char extent {&NUM_DEC_FMTS} NO-UNDO init
   [ "->,>>>,>>9.99",
     "99,999",
     "$*,**9.99+",
     ">>,>>9.99<<",
     "Total=+99,999.9",
     "+ZZZ,ZZ9.99"
   ].

Define var dec_desc as char extent {&NUM_DEC_FMTS} NO-UNDO init
   [ "Signed #, 2 dec. places, leading 0's suppressed",
     "5 digit # with thousand separators",
     "Signed Dollar amount, leading 0's replaced with *",
     "Floating decimal format, with max. 6 digits displayed",
     "5 digit total amount for report with 1 decimal place",
     "Signed # with leading 0's replaced with blanks"
   ].

&global-define NUM_LOG_FMTS  4
Define var log_fmts as char extent {&NUM_LOG_FMTS} NO-UNDO init
   [ "yes/no",
     "true/false",
     "male/female",
     "shipped/waiting"
   ].

/* No desc for logical - it's redundant */

&global-define NUM_DATE_FMTS  5
Define var date_fmts as char extent {&NUM_DATE_FMTS} NO-UNDO init
   [ "99/99/99",
     "99-99-99",
     "99/99/9999",
     "99-99-9999",
     "999999"
   ].

Define var date_desc as char extent {&NUM_DATE_FMTS} NO-UNDO init
   [ "2 digit year, slash separators",
     "2 digit year, dash separators",
     "4 digit year, slash separators",
     "4 digit year, dash separators",
     "2 digit year, no separators"
   ].

&global-define NUM_DATETM_FMTS  8
Define var datetm_fmts as char extent {&NUM_DATETM_FMTS} NO-UNDO init
   [ "99/99/99 HH:MM:SS.SSS",
     "99-99-99 HH:MM:SS.SSS",
     "99/99/9999 HH:MM:SS.SSS",
     "99-99-9999 HH:MM:SS.SSS",
     "99/99/99 HH:MM:SS.SSS AM",
     "99-99-99 HH:MM:SS.SSS AM",
     "99/99/9999 HH:MM:SS.SSS AM",
     "99-99-9999 HH:MM:SS.SSS AM"
   ].

Define var datetm_desc as char extent {&NUM_DATETM_FMTS} NO-UNDO init
   [ "2 digit year, / separators 24 hour",
     "2 digit year, - separators 24 hour",
     "4 digit year, / separators 24 hour",
     "4 digit year, - separators 24 hour",
     "2 digit year, / separators 12 hour",
     "2 digit year, - separators 12 hour",
     "4 digit year, / separators 12 hour",
     "4 digit year, - separators 12 hour"
   ].

&global-define NUM_DATETMTZ_FMTS  8
Define var datetmtz_fmts as char extent {&NUM_DATETMTZ_FMTS} NO-UNDO init
   [ "99/99/99 HH:MM:SS.SSS+HH:MM",
     "99-99-99 HH:MM:SS.SSS+HH:MM",
     "99/99/9999 HH:MM:SS.SSS+HH:MM",
     "99-99-9999 HH:MM:SS.SSS+HH:MM",
     "99/99/99 HH:MM:SS.SSS AM +HH:MM",
     "99-99-99 HH:MM:SS.SSS AM +HH:MM",
     "99/99/9999 HH:MM:SS.SSS AM +HH:MM",
     "99-99-9999 HH:MM:SS.SSS AM +HH:MM"
   ].

Define var datetmtz_desc as char extent {&NUM_DATETMTZ_FMTS} NO-UNDO init
   [ "2 digit yr, / separators 24 hr & time zone",
     "2 digit yr, - separators 24 hr & time zone",
     "4 digit yr, / separators 24 hr & time zone",
     "4 digit yr, - separators 24 hr & time zone",
     "2 digit yr, / separators 12 hr & time zone",
     "2 digit yr, - separators 12 hr & time zone",
     "4 digit yr, / separators 12 hr & time zone",
     "4 digit yr, - separators 12 hr & time zone"
   ].
&global-define NUM_REC_FMTS  3
Define var rec_fmts as char extent {&NUM_REC_FMTS} NO-UNDO init
   [ ">>>>>>9",
     "ZZZZZ9",
     "******9"
   ].

Define var rec_desc as char extent {&NUM_REC_FMTS} NO-UNDO init
   [ "7 digit ID with leading 0's suppressed",
     "6 digit ID with leading 0's replaced with blanks",
     "7 digit ID with leading 0's replaced with asterisks"
   ].


/*--------------------------------Form-------------------------------------*/

form
   SKIP({&TFM_WID})
   "Valid format components are:"
      	 view-as TEXT         	       	     	at  2 SKIP
   rule  FORMAT "x(70)"  
      	 view-as TEXT         	       	     	at  5 SKIP({&VM_WIDG})

   "Some example formats:"
    	 view-as TEXT         	       	     	at  2 SKIP({&VM_WID})
   fmt_list  
      	 view-as SELECTION-LIST SINGLE 
      	 INNER-CHARS 78 INNER-LINES 9 FONT 0  	at  2 

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}

   with frame fmt_examples 
      NO-LABELS
      DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel
      view-as DIALOG-BOX scrollable.


/*-----------------------------Triggers------------------------------------*/

/*----- HELP -----*/
on HELP of frame fmt_examples OR choose of s_btn_Help in frame fmt_examples
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Format_Examples_Dlg_Box}, ?).


/*-----WINDOW-CLOSE-----*/
on window-close of frame fmt_examples
   apply "END-ERROR" to frame fmt_examples.


/*----- DBL-CLICK of FORMAT LIST -----*/
on default-action of fmt_list in frame fmt_examples
   apply "GO" to frame fmt_examples.


/*---------------------------Mainline code---------------------------------*/

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame fmt_examples" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}

assign
   hlist = fmt_list:HANDLE in frame fmt_examples
   hlist:delimiter = "|".  /* have to pick something not in desc strings */

case p_Type:
   when {&DTYPE_CHARACTER} OR WHEN {&DTYPE_RAW} then
   do:
      do ix = 1 to {&NUM_CHAR_FMTS}:
   	 s_Res = hlist:add-last(STRING(char_fmts[ix],"x(17)") + char_desc[ix]).
      end.
      assign
   	 rule = "X N A ! 9 (n) <any fill characters you want>."
   	 frame fmt_examples:title = "Format Examples for Character Data Type".
   end.
   when {&DTYPE_INTEGER} OR WHEN {&DTYPE_INT64} THEN 
   do:
      do ix = 1 to {&NUM_INT_FMTS}:
   	     s_Res = hlist:add-last(STRING(int_fmts[ix],"x(17)") + int_desc[ix]).
      end.

      /* add the specific int64 formats */
      IF p_Type = {&DTYPE_INT64} THEN DO:
          do ix = 1 to {&NUM_INT64_FMTS}:
              s_Res = hlist:add-last(STRING(int64_fmts[ix],"x(17)") + int64_desc[ix]).
          END.
      END.

      assign
      	 rule = "<leading string> ( ) + - , > < 9 Z * . DB CR DR " +
      	        "<trailing string>"
      	 frame fmt_examples:title = "Format Examples for Integer Data Type".
   end.
   when {&DTYPE_DECIMAL} then
   do:
      do ix = 1 to {&NUM_DEC_FMTS}:
      	 s_Res = hlist:add-last(STRING(dec_fmts[ix],"x(17)") + dec_desc[ix]).
      end.
      assign
      	 rule = "<leading string> ( ) + - , > < 9 Z * . DB CR DR " +
      	        "<trailing string>"
      	 frame fmt_examples:title = "Format Examples for Decimal Data Type".
   end.
   when {&DTYPE_LOGICAL} then
   do:
      do ix = 1 to {&NUM_LOG_FMTS}:
      	 s_Res = hlist:add-last(STRING(log_fmts[ix],"x(17)")).
      end.
      assign
      	 rule = "<any two strings>"
      	 frame fmt_examples:title = "Format Examples for Logical Data Type".
   end.
   when {&DTYPE_DATE} then
   do:
      do ix = 1 to {&NUM_DATE_FMTS}:
      	 s_Res = hlist:add-last(STRING(date_fmts[ix],"x(17)") + date_desc[ix]).
      end.
      assign
      	 rule = "9 / -"
      	 frame fmt_examples:title = "Format Examples for Date Data Type".
   end.
   when {&DTYPE_DATETM} then
   do:
      do ix = 1 to {&NUM_DATETM_FMTS}:
      	 s_Res = hlist:add-last(STRING(datetm_fmts[ix],"x(33)") + datetm_desc[ix]).
      end.
      assign
      	 rule = "9 / - H M S A"
      	 frame fmt_examples:title = "Format Examples for Date-Time Data Type".
   end.
   when {&DTYPE_DATETMTZ} then
   do:
      do ix = 1 to {&NUM_DATETMTZ_FMTS}:
      	 s_Res = hlist:add-last(STRING(datetmtz_fmts[ix],"x(33)") + datetmtz_desc[ix]).
      end.
      assign
      	 rule = "9 / - H M S A"
      	 frame fmt_examples:title = "Format Examples for Date-Time-TZ Data Type".
   end.
   when {&DTYPE_RECID} then
   do:
      do ix = 1 to {&NUM_REC_FMTS}:
   	 s_Res = hlist:add-last(STRING(rec_fmts[ix],"x(17)") + rec_desc[ix]).
      end.
      assign
   	 rule = "<leading string> ( ) > 9 Z * <trailing string>"
      	 frame fmt_examples:title = "Format Examples for RECID Data Type".
   end.
end.

/* If input format is non null and is in the list, make it select the list
   value - otherwise, select the first entry as default. 
*/
num = hlist:num-items.
if p_Format <> "" then
do:
   find_loop:
   do ix = 1 to num:
      IF p_type = {&DTYPE_DATETMTZ} OR p_type = {&DTYPE_DATETM} THEN
        if p_Format = TRIM(SUBSTR(hlist:entry(ix), 1, 33)) then 
      	   leave find_loop.
      ELSE
        if p_Format = TRIM(SUBSTR(hlist:entry(ix), 1, 17)) then 
      	   leave find_loop.
   end.
   if ix > num then ix = 1.  /* format not found */
end.
else 
   ix = 1.
fmt_list = hlist:entry(ix).  

display rule with frame fmt_examples.
do ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE:
   update fmt_list 
      	  s_btn_Ok 
      	  s_btn_Cancel
      	  s_btn_Help
       	  with frame fmt_examples.
   IF p_type = {&DTYPE_DATETMTZ} OR p_type = {&DTYPE_DATETM} THEN
     p_Format = TRIM(SUBSTR(fmt_list, 1, 33)). 
   ELSE
     p_Format = TRIM(SUBSTR(fmt_list, 1, 17)).
end.
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _fldgate.p

Description:   
   Display and handle the field gateway information dialog box.

Input Parameter:
   p_ReadOnly - The read only flag to check (could be for flds or domains).

Returns: "mod" if user OK'ed changes (though we really don't
      	 check to see if the values actually are different),
      	 "" if user Cancels.

Author: Laura Stern

Date Created: 02/28/92
     History: 07/19/00 D. McMann Added MSS Help
              03/26/01 D. McMann Added format for display of _Fld-misc1[1]
              05/15/01 D. McMann Changed which field was displayed for ODBC

----------------------------------------------------------------------------*/


&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/FLD/fldvar.i shared}

Define INPUT PARAMETER p_ReadOnly as logical NO-UNDO.

Define var db_type as char NO-UNDO.
Define var edbtyp  as char NO-UNDO.
Define var odbtyp  as char NO-UNDO.
Define var proc    as char NO-UNDO.
Define var retval  as char NO-UNDO init "". /* return value */


/*=================================Forms==================================*/

form
   SKIP({&TFM_WID})
   b_Field._Fld-stoff	LABEL "&Position" FORMAT ">>>>9" colon 15 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._Fld-stlen	LABEL "&Length"   FORMAT ">>>>9" colon 15 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._For-spacing	LABEL "&Array spacing"           colon 15 {&STDPH_FILL}
   
   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}

   with frame isamfld
        DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel
        SIDE-LABELS
        TITLE db_type + " Specific Fields"
        view-as DIALOG-BOX.

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame isamfld" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}
/*--------------------------------------------------------------------*/

form
   SKIP({&TFM_WID})
   b_Field._Fld-stoff	LABEL "&Position" FORMAT ">>>>9" colon 15 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._Fld-stlen	LABEL "&Length"   FORMAT ">>>>9" colon 15 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._For-spacing	LABEL "&Array spacing"           colon 15 {&STDPH_FILL}

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}

   with frame ctosfld
        DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel
        SIDE-LABELS
        TITLE db_type + " Specific Fields"
        view-as DIALOG-BOX.

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame ctosfld" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}
/*--------------------------------------------------------------------*/

form
   SKIP({&TFM_WID})
   b_Field._Fld-stoff	LABEL "&Position" FORMAT ">>>>9" colon 16 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._Fld-stlen	LABEL "&Length"   FORMAT ">>>>9" colon 16 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._For-spacing	LABEL "&Array spacing"           colon 16 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._For-scale	LABEL "&Scaling factor"          colon 16 {&STDPH_FILL}

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}

   with frame rmsfld
        DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel
        SIDE-LABELS
        TITLE db_type + " Specific Fields"
        view-as DIALOG-BOX.

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame rmsfld" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}
/*--------------------------------------------------------------------*/

form
   SKIP({&TFM_WID})
   b_Field._For-name       LABEL "Native Field &Name"  colon 19 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._Fld-stoff	   LABEL "&Position"  	       colon 19 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._For-scale	   LABEL "&Scaling factor"     colon 19 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._For-id         LABEL "Field &Id"           colon 19 {&STDPH_FILL}

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}

   with frame rdbfld
        DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel
        SIDE-LABELS
        TITLE db_type + " Specific Fields"
        view-as DIALOG-BOX.

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame rdbfld" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}
/*--------------------------------------------------------------------*/

form
   SKIP({&TFM_WID})
   b_Field._For-name       LABEL "Native Field &Name"  colon 19 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._Fld-stoff	   LABEL "&Column Number"      colon 19 {&STDPH_FILL}

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}

   with frame oraclefld
        DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel
        SIDE-LABELS
        TITLE db_type + " Specific Fields"
        view-as DIALOG-BOX.

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame oraclefld" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}
/*--------------------------------------------------------------------*/

form
   SKIP({&TFM_WID})
   b_Field._For-name       LABEL "Native Field &Name" colon 19 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._Fld-stoff	   LABEL "&Column Number"     colon 19 {&STDPH_FILL}

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}

   with frame sybasefld
        DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel
        SIDE-LABELS
        TITLE db_type + " Specific Fields"
        view-as DIALOG-BOX.

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame sybasefld" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}
/*--------------------------------------------------------------------*/

form
   SKIP({&TFM_WID})
   b_Field._Fld-stoff	   LABEL "&Position"  	colon 15 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._Fld-stlen	   LABEL "&Length"    	colon 15 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._fld-misc2[6]   LABEL "DDS Type"  	colon 15 {&STDPH_FILL}

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}

   with frame as400fld
        DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel
        SIDE-LABELS
        TITLE db_type + " Specific Fields"
        view-as DIALOG-BOX.

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame as400fld" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}
/*--------------------------------------------------------------------*/

form
   SKIP({&TFM_WID})
   b_Field._For-name       LABEL "Native Field &Name"  colon 20 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._Fld-stoff	   LABEL "&Column Number"      colon 20 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._Fld-Misc1[2]	   LABEL "&Scale"  	       colon 20 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._Fld-misc1[1]   LABEL "&Precision"  FORMAT ">>>>>>>>>9"
    	       colon 20 {&STDPH_FILL}
   SKIP({&VM_WID})
  
   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}

   with frame odbfld
        DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel
        SIDE-LABELS
        TITLE edbtyp + " Specific Fields"
        view-as DIALOG-BOX.

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame odbfld" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}


/*=================================Triggers==================================*/

/*-----WINDOW-CLOSE-----*/
on window-close of frame isamfld
   apply "END-ERROR" to frame isamfld.

on window-close of frame ctosfld
   apply "END-ERROR" to frame ctosfld.

on window-close of frame rmsfld
   apply "END-ERROR" to frame rmsfld.

on window-close of frame rdbfld
   apply "END-ERROR" to frame rdbfld.

on window-close of frame oraclefld
   apply "END-ERROR" to frame oraclefld.

on window-close of frame sybasefld
   apply "END-ERROR" to frame sybasefld.

on window-close of frame as400fld
   apply "END-ERROR" to frame as400fld.

on window-close of frame odbfld
   apply "END-ERROR" to frame odbfld.


/*----- HIT of OK BUTTON or GO -----*/
On GO of frame isamfld 	/* or OK because of AUTO-GO */
do:
   run Validate_Spacing 
      (INPUT input frame isamfld b_Field._For-spacing,
       INPUT input frame isamfld b_Field._Fld-stlen).
   if RETURN-VALUE = "error" then return NO-APPLY.

   run Validate_Offset 
      (INPUT input frame isamfld b_Field._Fld-stoff,
       INPUT input frame isamfld b_Field._Fld-stlen).
   if RETURN-VALUE = "error" then return NO-APPLY.
end.

On GO of frame rmsfld /* or OK because of AUTO-GO */
do:
   run Validate_Spacing 
      (INPUT input frame rmsfld b_Field._For-spacing,
       INPUT input frame rmsfld b_Field._Fld-stlen).
   if RETURN-VALUE = "error" then return NO-APPLY.

   run Validate_Offset 
      (INPUT input frame rmsfld b_Field._Fld-stoff,
       INPUT input frame rmsfld b_Field._Fld-stlen).
   if RETURN-VALUE = "error" then return NO-APPLY.
end.

On GO of frame rdbfld /* or OK because of AUTO-GO */
do:
   run Validate_Offset 
      (INPUT input frame rdbfld b_Field._Fld-stoff,
       INPUT 0).
   if RETURN-VALUE = "error" then return NO-APPLY.
end.

On GO of frame ctosfld	/* or OK because of AUTO-GO */
do:
   run Validate_Spacing 
      (INPUT input frame ctosfld b_Field._For-spacing,
       INPUT input frame ctosfld b_Field._Fld-stlen).
   if RETURN-VALUE = "error" then return NO-APPLY.

   run Validate_Offset 
      (INPUT input frame ctosfld b_Field._Fld-stoff,
       INPUT input frame ctosfld b_Field._Fld-stlen).
   if RETURN-VALUE = "error" then return NO-APPLY.
end.


/*----- LEAVE of SCALE -----*/
On leave of b_Field._For-scale in frame rmsfld
do:
   run Validate_Scale (INPUT input frame rmsfld b_Field._For-scale).
   if RETURN-VALUE = "error" then 
      return NO-APPLY.
end.

On leave of b_Field._For-scale in frame rdbfld
do:
   run Validate_Scale (INPUT input frame rdbfld b_Field._For-scale).
   if RETURN-VALUE = "error" then 
      return NO-APPLY.
end.


/*----- HELP -----*/
on HELP of frame isamfld OR choose of s_btn_Help in frame isamfld
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&CISAM_Specific_Flds__Dlg_Box}, ?).

on HELP of frame ctosfld OR choose of s_btn_Help in frame ctosfld
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Gateways_Dlg_Box}, ?).

on HELP of frame rmsfld OR choose of s_btn_Help in frame rmsfld
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Gateways_Dlg_Box}, ?).

on HELP of frame rdbfld OR choose of s_btn_Help in frame rdbfld
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Gateways_Dlg_Box}, ?).

on HELP of frame oraclefld OR choose of s_btn_Help in frame oraclefld
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&ORACLE_Specific_Flds__Dlg_Box}, ?).

on HELP of frame sybasefld OR choose of s_btn_Help in frame sybasefld
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&SYBASE_Specific_Flds_Dlg_Box}, ?).

on HELP of frame as400fld OR choose of s_btn_Help in frame as400fld
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&AS400_Specific_Flds__Dlg_Box}, ?).

on HELP of frame odbfld OR choose of s_btn_Help in frame odbfld DO:
  IF db_type = "MSS" THEN
    RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&MSS_Specific_Flds_Dlg_Box}, ?).
  ELSE
    RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&ODBC_Specific_Flds_Dlg_Box}, ?).
END.


/*==========================Internal Procedures==============================*/

/*-----------------------------------------------------------------------
   Validate the _Spacing value.

   Input Parameters:
      p_Spacing - the spacing value
      p_Length - the length value

   Returns:
      "error" or "ok"
-----------------------------------------------------------------------*/
Procedure Validate_Spacing:

Define INPUT PARAMETER p_Spacing as integer NO-UNDO.
Define INPUT PARAMETER p_Length  as integer NO-UNDO.

   if      b_field._extent > 1
     and ( p_Spacing < p_Length
     or    p_Spacing = ?        )
     then do:
       message "Spacing must be greater than or equal to field length."
      	      view-as ALERT-BOX ERROR
      	      buttons OK.
       return "error".
     end.
     else
       return "ok".
end.


/*-----------------------------------------------------------------------
   Validate the _Scale value.

   Input Parameters:
      p_Scale - the scale value

   Returns:
      "error" or "ok"
-----------------------------------------------------------------------*/
Procedure Validate_Scale:

Define INPUT PARAMETER p_Scale as integer NO-UNDO.

   if ( p_Scale <= -10 OR p_Scale >= 50 )
    AND CAN-DO( "Scaled Ubyte,Scaled Uword,"
              + "Scaled Ulong word,Scaled Uquad word"
              , trim(substring(INPUT FRAME fldprops s_Fld_DType,1,20,"character"))
              )
    then do:
     message "Scale must be between -10 and +50 for Scaled Unsigned types."
             view-as ALERT-BOX ERROR buttons OK.
     return "error".
     end.

   else if p_Scale <= -127 OR p_Scale >= 127
    then do:
      message "Scale must be between -127 and +127."
               view-as ALERT-BOX ERROR
      	       buttons OK.
      return "error".
     end.
    else return "ok".

end.


/*-----------------------------------------------------------------------
   Validate the Offset value.

   Input Parameters:
      p_Offset - the field offset value
      p_Length - the length value

   Returns:
      "error" or "ok"
-----------------------------------------------------------------------*/
Procedure Validate_Offset:

Define INPUT PARAMETER p_Offset as integer NO-UNDO.
Define INPUT PARAMETER p_Length as integer NO-UNDO.

   find _File where RECID(_File) = s_TblRecId.
   if p_Offset + p_Length > _File._For-Size then 
   do:
      message "The field offset plus the length cannot" SKIP
      	      "be greater than the record size of"
      	       STRING(_File._For-Size) + "."
      	      view-as ALERT-BOX ERROR buttons OK.
      return "error".
   end.
   return "ok".
end.


/*----------------------------------------------------------------------*/
Procedure ISAM_Fld:  /* For CISAM and NETISAM */

Define var modifiable as logical NO-UNDO.
Define var ext        as integer NO-UNDO.
Define var ix         as integer NO-UNDO.

   modifiable = (if NOT s_Adding AND s_Fld_InIndex then no else yes).
   ix = LOOKUP(s_Fld_Gatetype, user_env[12]).

   run adedict/FLD/_dfltgat.p(FALSE).

   display b_Field._Fld-stoff
      	   b_Field._Fld-stlen
      	   b_Field._For-spacing
      with frame isamfld.

   do ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE  ON STOP UNDO, LEAVE:
      if p_ReadOnly then
      	 update s_btn_Cancel s_btn_Help with frame isamfld.
      else do:
      	 ext = (if s_Adding then input frame newfld b_Field._Extent
      	       	     	    else input frame fldprops b_Field._Extent).
      	 set b_Field._Fld-stoff    when modifiable
	     b_Field._Fld-stlen    when modifiable
      	     b_Field._For-spacing  when ext > 0
      	     s_btn_OK 
      	     s_btn_Cancel
      	     s_btn_Help
	     with frame isamfld.

      	 if NOT s_Adding then
      	    {adedict/setdirty.i &Dirty = "true"}.
      	 if modifiable OR ext > 0 then
      	    retval = "mod".
      end.
   end.
end.


/*----------------------------------------------------------------------*/
Procedure CTOSISAM_Fld:

   run adedict/FLD/_dfltgat.p(FALSE).

   display b_Field._Fld-stoff 
      	   b_Field._Fld-stlen
      	   b_Field._For-spacing
      	   with frame ctosfld.

   do ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE  ON STOP UNDO, LEAVE:
      if p_ReadOnly then
	 update s_btn_Cancel s_btn_Help with frame ctosfld.
      else do:
	 set  b_Field._Fld-stoff    when s_Adding
	      b_Field._Fld-stlen    when s_Adding AND b_Field._Fld-stlen > 0
	      b_Field._For-spacing  when b_Field._Extent > 0
	      s_btn_OK 
	      s_btn_Cancel
      	      s_btn_Help
	      with frame ctosfld.

      	 if NOT s_Adding then
      	    {adedict/setdirty.i &Dirty = "true"}.
      	 if s_Adding OR b_Field._Extent > 0 then
      	    retval = "mod".
      end.
   end.
end.


/*----------------------------------------------------------------------*/
Procedure RMS_Fld:

Define var modifiable as logical NO-UNDO.

   modifiable = (if s_Adding then true else
      	         if NOT s_Fld_InIndex then true else
      	       	 false).

   run adedict/FLD/_dfltgat.p(FALSE).

   display b_Field._Fld-stoff
      	   b_Field._Fld-stlen
      	   b_Field._For-spacing
      	   b_Field._For-scale when s_Fld_Typecode = {&DTYPE_DECIMAL}
      with frame rmsfld.

   do ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE  ON STOP UNDO, LEAVE:
      if p_ReadOnly then
	 update s_btn_Cancel s_btn_Help with frame rmsfld.
      else do:
	 set b_Field._Fld-stoff    when modifiable
	     b_Field._Fld-stlen    when modifiable AND b_Field._Fld-stlen = 0
	     b_Field._For-spacing  when b_Field._Extent > 0
	     b_Field._For-scale    when s_Fld_Typecode = {&DTYPE_DECIMAL}
	     s_btn_OK 
	     s_btn_Cancel
      	     s_btn_Help
	     with frame rmsfld.

      	 if NOT s_Adding then
      	    {adedict/setdirty.i &Dirty = "true"}.
      	 if (modifiable OR b_Field._Extent > 0 OR 
      	     s_Fld_Typecode = {&DTYPE_DECIMAL}) then
      	    retval = "mod".
      end.
   end.
end.


/*----------------------------------------------------------------------*/
Procedure RDB_Fld:

   display b_Field._For-name 
      	   b_Field._Fld-stoff
      	   b_Field._For-scale when s_Fld_Typecode = {&DTYPE_DECIMAL} AND
      	       	     	           s_Fld_Gatetype <> "quad"
      	       	     	      /* all scaled types + float & double */
      	   b_Field._for-id 
      	   with frame rdbfld.

   do ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE  ON STOP UNDO, LEAVE:
      if p_ReadOnly then
	 update s_btn_Cancel s_btn_Help with frame rdbfld.
      else do:
	 set  b_Field._Fld-stoff 
	      b_Field._For-scale when s_Fld_Typecode = {&DTYPE_DECIMAL} AND
      	       	     	              s_Fld_Gatetype <> "quad"
      	       	     	      	 /* all scaled types + float & double */
	      s_btn_OK 
	      s_btn_Cancel
      	      s_btn_Help
	      with frame rdbfld.

      	 if NOT s_Adding then
      	    {adedict/setdirty.i &Dirty = "true"}.
      	 retval = "mod".
      end.
   end.
end.


/*----------------------------------------------------------------------*/
Procedure ORACLE_Fld:

   display b_Field._For-name 
      	   b_field._Fld-stoff 
      	   with frame oraclefld.

   do ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE  ON STOP UNDO, LEAVE:
      if p_ReadOnly then
	 update s_btn_Cancel s_btn_Help with frame oraclefld.
      else do:
	 set  s_btn_OK 
	      s_btn_Cancel
      	      s_btn_Help
	      with frame oraclefld.
      end.
   end.
end.


/*----------------------------------------------------------------------*/
Procedure SYBASE_Fld:

   display b_Field._For-name 
      	   b_field._Fld-stoff 
      	   with frame sybasefld.

   do ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE  ON STOP UNDO, LEAVE:
      if p_ReadOnly then
	 update s_btn_Cancel s_btn_Help with frame sybasefld.
      else do:
	 set  s_btn_OK 
	      s_btn_Cancel
      	      s_btn_Help
	      with frame sybasefld.
      end.
   end.
end.


/*----------------------------------------------------------------------*/
Procedure AS400_Fld:

   display b_Field._Fld-stoff 
      	   b_Field._Fld-stlen 
           b_Field._fld-misc2[6]
      with frame as400fld.

   do ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE  ON STOP UNDO, LEAVE:
      if p_ReadOnly then
	 update s_btn_Cancel s_btn_Help with frame as400fld.
      else do:
	 set  s_btn_OK 
	      s_btn_Cancel
      	      s_btn_Help
	      with frame as400fld.
      end.
   end.
end.


/*----------------------------------------------------------------------*/
Procedure ODB_Fld:

   display b_Field._For-name 
      	   b_Field._Fld-stoff 
      	   b_Field._Fld-Misc1[2]
      	   b_Field._Fld-misc1[1]      	  
      	   with frame odbfld.

   do ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE  ON STOP UNDO, LEAVE:
      if p_ReadOnly then
	 update s_btn_Cancel s_btn_Help with frame odbfld.
      else do:
	    set s_btn_OK 
	        s_btn_Cancel
      	    s_btn_Help
	        with frame odbfld.
      end.
   end.
end.


/*==============================Mainline Code================================*/

/* Run the appropriate routine, based on the gateway. */
assign
  db_type = s_DbCache_Type[s_DbCache_ix]
  edbtyp  = {adecomm/ds_type.i
               &direction = "itoe"
               &from-type = "db_type"
               }
  odbtyp  = {adecomm/ds_type.i
               &direction = "ODBC"
               &from-type = "db_type"
               }.

case (db_type):
   when "CISAM" OR
   when "NETISAM" then
      proc = "ISAM_Fld".
   when "CTOSISAM" then
      proc = "CTOSISAM_Fld".
   when "RDB" then
      proc = "RDB_Fld".
   when "RMS" then
      proc = "RMS_Fld".
   when "ORACLE" then
      proc = "ORACLE_Fld".
   when "SYBASE" then
      proc = "SYBASE_Fld".
   when "AS400" then
      proc = "AS400_Fld".
   otherwise
      proc = ( if can-do(odbtyp,db_type)
                 then "ODB_Fld"
                 else ""
                 ).
end.

if proc <> "" then run VALUE(proc).
return retval.




/***********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/*----------------------------------------------------------------------------

File: _fldprop.p

Description:
   Set up the field properties window so the user can view or modify the 
   information on a field.  Since this window is non-modal, we just do the
   set up here.  All triggers must be global.

   All of this code is in an include file so that we can use it for fields
   and domains.

Author: Laura Stern

Date Created: 02/05/92 
    Modified: 07/14/98 D. McMann Added _Owner to _File find
              05/19/99 Mario B.  Adjust Width Field browser integration.
              09/26/02 D. McMann Added check for SQL table
----------------------------------------------------------------------------*/

/*---------------------------- Declarations --------------------------------*/

&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/FLD/fldvar.i shared}

/*----------------------------Mainline code----------------------------------*/

find _File where _File._File-name = "_Field"
             and _File._Owner = "PUB" NO-LOCK.
if NOT can-do(_File._Can-read, USERID("DICTDB")) then
do:
   message s_NoPrivMsg "see field definitions."
      view-as ALERT-BOX ERROR buttons Ok in window s_win_Browse.
   return.
end.

/* Don't want Cancel if moving to next field - only when window opens */
if s_win_Fld = ? then
   s_btn_Close:label in frame fldprops = "Cancel".

/* Open the window if necessary */
run adedict/_openwin.p
   (INPUT   	  "Field Properties",
    INPUT   	  frame fldprops:HANDLE,
    INPUT         {&OBJ_FLD},
    INPUT-OUTPUT  s_win_Fld).

/* Have to run graying so that Adjust Width Browser can't be opened when *
 * when this window is open                                              */
RUN adedict/_brwgray.p (INPUT NO).

/* We haven't finished fiddling with frame yet so to set status line
   don't use display statement.
*/
s_Status:screen-value in frame fldprops = "". /* clears from last time */

s_Fld_ReadOnly = (s_ReadOnly OR s_DB_ReadOnly).
if NOT s_Fld_ReadOnly then
do:
   if NOT can-do(_File._Can-write, USERID("DICTDB")) then
   do:
      s_Status:screen-value in frame fldprops = 
      	 s_NoPrivMsg + " modify field definitions.".
      s_Fld_ReadOnly = true.
   end.
   else do:
      find _File where RECID(_File) = s_TblRecId.
      if _File._Frozen then
      do:
      	 s_Status:screen-value in frame fldprops =
      	    "Note: This table is frozen and cannot be modified.".
      	 s_Fld_ReadOnly = true.
      end.
      ELSE IF _File._Db-lang > {&TBLTYP_SQL} THEN DO:
        s_Status:screen-value in frame fldprops =
      	    "Note: {&PRO_DISPLAY_NAME}/SQL92 table cannot be modified.".
      	 s_Fld_ReadOnly = true.
      END.
   end.
end.

{adedict/FLD/fdprop.i &Frame    = "frame fldprops"
      	       	       &ReadOnly = "s_Fld_ReadOnly"}









/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _fldval.p

Description:   
   Display and handle the field validation dialog box.

Input Parameter:
   p_ReadOnly - The read only flag to check (could be for flds or domains).

Returns: "mod" if user OK'ed changes (though we really don't
      	 check to see if the values actually are different),
      	 "" if user Cancels.

Author: Laura Stern

Date Created: 02/17/92 

Modified on 07/08/94 by gfs - Fixed bug 94-06-14-073.

----------------------------------------------------------------------------*/


&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/FLD/fldvar.i shared}

Define INPUT PARAMETER p_ReadOnly as logical NO-UNDO.

Define var retval as char NO-UNDO init "". /* return value */

form
   SKIP({&TFM_WID})
   "Expression that must be TRUE for the entered value:"    at  2 
      	       	     view-as TEXT
   SKIP
   b_Field._Valexp   view-as EDITOR SCROLLBAR-VERTICAL
                     SIZE 73 by 3 {&STDPH_ED4GL_SMALL}      at  2  
   SKIP({&VM_WIDG})
   "Field Validation Message:" 	       	     	      	    at  2   
      	       	     view-as TEXT
   SKIP
   b_Field._Valmsg   format "x(72)" {&STDPH_FILL}           at  2  
   
   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}
   
   with frame fldvalid
        NO-LABELS 
        DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel
        view-as DIALOG-BOX TITLE "Field Validation".


/*------------------------------Trigger Code---------------------------------*/

/*-----WINDOW-CLOSE-----*/
on window-close of frame fldvalid
   apply "END-ERROR" to frame fldvalid.


/*----- SELECTION of OK BUTTON -----*/
on GO of frame fldvalid	/* or OK because of AUTO-GO */
do:
   Define var msg  as char NO-UNDO.
   Define var expr as char NO-UNDO.

   assign
      msg = TRIM(input frame fldvalid b_Field._Valmsg)
      expr = TRIM(input frame fldvalid b_Field._Valexp).


   if NOT (msg = "" OR msg = ?) then 
   do:  /* message is not blank */
      if expr = "" OR expr = ? then    
      do:
      	 message "Please enter a validation expression to" SKIP
      	       	 "go along with your validation message."
      	       	 view-as ALERT-BOX ERROR buttons OK.
      	 apply "entry" to b_Field._Valexp in frame fldvalid.
      	 return NO-APPLY.
      end.
   end.
   else  /* message is blank */ 
      if NOT (expr = "" OR expr = ?) then 
      do:
	 message "Please enter a validation message to" SKIP
		  "go along with your validation expression."
		  view-as ALERT-BOX ERROR buttons OK.
	 apply "entry" to b_Field._Valexp in frame fldvalid.
	 return NO-APPLY.
      end.
end.


/*----- HELP -----*/
on HELP of frame fldvalid OR choose of s_btn_Help in frame fldvalid
    RUN "adecomm/_kwhelp.p" (INPUT b_Field._Valexp:HANDLE,
                             INPUT "dict",
                             INPUT {&Field_Validation_Dlg_Box}).

/*------------------------------Mainline Code--------------------------------*/

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame fldvalid" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}

/* So Return doesn't hit default button in editor widget */
b_Field._Valexp:RETURN-INSERT = yes.

display b_Field._Valmsg b_Field._Valexp with frame fldvalid.

do ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE ON STOP UNDO, LEAVE:
   if p_ReadOnly then
   do:
      display b_Field._Valmsg b_Field._Valexp with frame fldvalid.
      update s_btn_Cancel with frame fldvalid.
   end.
   else do:
      update b_Field._Valexp  
      	     b_Field._Valmsg
      	     s_btn_Ok  	      
      	     s_btn_Cancel
      	     s_btn_Help
      	     with frame fldvalid.

      /* Remove any line feeds (which we get on WINDOWS) and remove
      	 extraneous spaces and carriage returns. */
      b_Field._Valexp = TRIM(replace (b_Field._Valexp, CHR(13), "")).

      if NOT s_Adding then
      	 {adedict/setdirty.i &Dirty = "true"}.
      retval = "mod".
   end.
end.

hide frame fldvalid.
return retval.
/*********************************************************************
* Copyright (C) 2008 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _newfld.p

Description:
   Display and handle the add field boxes and then add
   the field if the user presses OK.

Author: Laura Stern

Date Created: 02/05/92 
    Modified: 07/10/98 Added _Owner check for _File.
              12/11/98 Check for duplicate order numbers, warn and prevent.
              05/01/00 DLM Added _owner to find that was missed 20000428020
              10/01/02 DLM Changed check for SQL tables.
              01/17/03 DLM Added support for lob data types
              07/01/03 DLM Added support for DATETIME and DATETIME-tz
              09/12/03 DLM Moved blank name check to above running BLOB, CLOB 
                       procedure
              09/16/03 DLM Added U1 trigger for data type field
              09/24/03 DLM Check for data type change from U1 trigger in Leave
                       trigger
              10/08/03 DLM Changed for modifying copied LOB fields 20031007-028
              10/25/05 KSM Removed usage of _ianum to locate storage area 
                           20051018-026
              10/28/05 KSM Added code to use _ianum if uncommitted table or
                           fall back on schema area for LOBs
              05/24/06 fernando Added support for int64 datatype
              06/08/06 fernando Hide toint64 button
              06/15/06 fernando Make sure we call setlob when leaving data type to
                                enable/disable needed fields depending on the type.
              06/26/08 fernando Removed encryption area from list
              02/22/08 fernando Adjust display data type length for Dsrv schemas
----------------------------------------------------------------------------*/


&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/FLD/fldvar.i shared}
{adedict/capab.i}
{prodict/pro/fldfuncs.i}


DEFINE VARIABLE Last_Order AS INTEGER INIT ?. /* YES-UNDO*//* to set _Order field */
DEFINE VARIABLE Record_Id  AS RECID              NO-UNDO.  /* table record Id */
DEFINE VARIABLE Copy_Hit   AS LOGICAL INIT FALSE NO-UNDO.  /* Flag - was copy hit? */
DEFINE VARIABLE IsPro      AS LOGICAL            NO-UNDO.  /* true if db is Prog. */
DEFINE VARIABLE copied     AS LOGICAL            NO-UNDO.  
DEFINE VARIABLE added      AS LOGICAL INIT FALSE NO-UNDO.
DEFINE VARIABLE odbtyp     AS CHARACTER          NO-UNDO.
DEFINE VARIABLE isodbc     AS LOGICAL INIT FALSE NO-UNDO.
DEFINE VARIABLE islob      AS LOGICAL            NO-UNDO.
DEFINE VARIABLE cObjList   AS CHARACTER          NO-UNDO.

/* Reminder: Here's what's in user_env:

      user_env[11] - the long form of the gateway type (string), i.e., the
      	       	     type description.
      user_env[12] - list of gateway types (strings)
      user_env[13] - list of _Fld-stlen values for each data type (this is
      	       	     the storage length)
      user_env[14] - list of gateway type codes (_Fld-stdtype).
      user_env[15] - list of progress types that map to gateway types
      user_env[16] - the gateway type family - to indicate what data types
      	       	     can be modified to what other data types.
      user_env[17] - the default-format per foreign data-type.
*/


/*===========================Internal Procedures=============================*/


/*----------------------------------------------------------------------------
   SetDataTypes

   Get the list of data types appropriate for the current gateway.  For
   non-progress types, also get default information associated with that
   type and just store it so we can set defaults when we need to.
----------------------------------------------------------------------------*/
PROCEDURE SetDataTypes:

Define VARIABLE types as char    NO-UNDO.
Define VARIABLE num   as integer NO-UNDO.
DEFINE VARIABLE s_res AS LOGICAL NO-UNDO.


   if IsPro THEN DO:
      assign
      	 types = "CHARACTER,DATE,DECIMAL,INTEGER,LOGICAL,DATETIME,DATETIME-TZ,BLOB,CLOB,RAW,RECID"
      	 num = 11.
      IF NOT is-pre-101b-db THEN
          /* not a pre-10.1B db, include int64 */
          ASSIGN types = REPLACE(types, "INTEGER","INTEGER,INT64")
              num = 12.
   END.
   else do:
      /* Compose a string to pass to list-items function where each entry
      	 is a data type that looks like "xxxx (yyyy)" where
      	 xxxx is the gateway type and yyyy is the progress type
      	 that it maps to.
      */
      types = "".
      do num = 1 to NUM-ENTRIES(user_env[11]) - 1:
      	 types = types + (if num = 1 then "" else ",") +
      	       	 STRING(ENTRY(num, user_env[11]), "x({&FOREIGN_DTYPE_DISPLAY})") + 
      	       	 "(" + ENTRY(num, user_env[15]) + ")".
      end.
      num = num - 1.  /* undo terminating loop iteration */
   end.
   
   s_lst_Fld_DType:list-items in frame newfld = types.
   s_lst_Fld_DType:inner-lines in frame newfld = 
      (if num <= 12 then num else 12).
end.


/*----------------------------------------------------------------------------
   SetDefaults

   Set default values based on the chosen data type.  Display all new values.
   
   When we get domains:
   Copy the values from an existing domain into the display variables for 
   the new field or domain.  Display all new values.

   Output
      s_Fld_Protype  - Progress data type string
      s_Fld_Typecode - The underlying integer data type (dtype field) 
      s_Fld_Gatetype - The gateway type
----------------------------------------------------------------------------*/
Procedure SetDefaults:
  /*  If the user has selected a lob, make sure the toggle boxes are set
      to no and make insensitive */

  IF s_Fld_DType:SCREEN-VALUE IN FRAME newfld = "BLOB" THEN DO:
    IF s_Fld_array:SCREEN-VALUE IN FRAME newfld = "yes" THEN
      ASSIGN s_Fld_array:SCREEN-VALUE IN FRAME newfld = "no".
    IF b_field._Mandatory:SCREEN-VALUE IN FRAME newfld = "yes" THEN
      ASSIGN b_field._Mandatory:SCREEN-VALUE IN FRAME newfld = "no".
    IF b_field._Fld-case:SCREEN-VALUE IN FRAME newfld = "yes" THEN
      ASSIGN b_Field._Fld-case:SCREEN-VALUE IN FRAME newfld = "no".
    ASSIGN b_field._Mandatory:SENSITIVE IN FRAME newfld = NO
           b_field._Fld-case:SENSITIVE IN FRAME newfld = NO
          s_Fld_array:SENSITIVE IN FRAME newfld = NO.
  END.
  ELSE IF s_Fld_DType:SCREEN-VALUE IN FRAME newfld = "CLOB" THEN DO:
    IF s_Fld_array:SCREEN-VALUE IN FRAME newfld = "yes" THEN
      ASSIGN s_Fld_array:SCREEN-VALUE IN FRAME newfld = "no".
    IF b_field._Mandatory:SCREEN-VALUE IN FRAME newfld = "yes" THEN
      ASSIGN b_field._Mandatory:SCREEN-VALUE IN FRAME newfld = "no".
    ASSIGN b_field._Mandatory:SENSITIVE IN FRAME newfld = NO
           s_Fld_array:SENSITIVE IN FRAME newfld = NO.
  END.
  ELSE 
    ASSIGN b_field._Mandatory:SENSITIVE IN FRAME newfld = YES
           b_field._Fld-case:SENSITIVE IN FRAME newfld = YES
          s_Fld_array:SENSITIVE IN FRAME newfld = YES.

  {adedict/FLD/setdflts.i &Frame = "frame newfld"} 

end.

/*-------------------------------------------------------------------------
    setlob
    
    This procedure handles the different fields that must be set or hidden
    when defining a lob object. It's also called when moving from a LOB to
    another type so that the correct fields are displayed / hidden.
    
--------------------------------------------------------------------------*/    
PROCEDURE setlob:

    IF s_Fld_Dtype:SCREEN-VALUE IN FRAME newfld = "BLOB" OR
       s_Fld_Dtype:SCREEN-VALUE IN FRAME newfld = "CLOB" THEN  DO:

      /* disable all the fields not applicable to LOBs */
      ASSIGN s_lob_size:HIDDEN IN FRAME newfld = NO
             s_lob_Area:HIDDEN IN FRAME newfld = NO
             s_btn_lob_Area:HIDDEN IN FRAME newfld = NO
             /* all the other ones */
             b_Field._Format:HIDDEN IN FRAME newfld = YES
             s_btn_Fld_Format:HIDDEN IN FRAME newfld = YES
             s_btn_Fld_ViewAs:SENSITIVE in frame newfld = FALSE
             s_btn_Fld_Validation:SENSITIVE IN FRAME newfld = FALSE
             s_btn_Fld_Triggers:SENSITIVE IN FRAME newfld = FALSE
             s_btn_Fld_StringAttrs:SENSITIVE IN FRAME newfld = FALSE
             b_Field._Label:SENSITIVE IN FRAME newfld = FALSE  	    
             b_Field._Col-label:SENSITIVE IN FRAME newfld = FALSE   
             b_Field._Initial:SENSITIVE IN FRAME newfld = FALSE
             b_Field._Help:SENSITIVE IN FRAME newfld = FALSE 
             b_Field._Mandatory:SENSITIVE IN FRAME newfld = FALSE
             s_Fld_Array:SENSITIVE IN FRAME newfld = FALSE.  

      /* make sure the fields are enabled, if here for the first time */
      IF s_lob_size:SENSITIVE = NO THEN
         ASSIGN s_lob_size:SENSITIVE  = YES.

      IF s_lob_area:SENSITIVE = NO THEN
         ASSIGN s_lob_area:SENSITIVE = YES
                s_btn_lob_Area:SENSITIVE = YES.

      /* some are specific to CLOBs */
      IF s_Fld_Dtype:SCREEN-VALUE IN FRAME newfld = "CLOB" THEN DO:
         ASSIGN
               s_clob_cp:HIDDEN IN FRAME newfld = FALSE
               s_clob_col:HIDDEN IN FRAME newfld = FALSE
               s_btn_clob_cp:HIDDEN IN FRAME newfld = FALSE
               s_btn_clob_col:HIDDEN IN FRAME newfld = FALSE
               /* the ones at the same position must be hidden */
               b_Field._Label:HIDDEN IN FRAME newfld = TRUE
               b_Field._Col-label:HIDDEN IN FRAME newfld = TRUE.

         IF s_clob_cp:SENSITIVE = NO THEN
            ASSIGN s_clob_cp:SENSITIVE  = TRUE
                   s_btn_clob_cp:SENSITIVE  = TRUE.

         IF s_clob_col:SENSITIVE = NO THEN
            ASSIGN s_clob_col:SENSITIVE  = TRUE
                   s_btn_clob_col:SENSITIVE  = TRUE.

      END.
      ELSE DO:   /* must be a BLOB */
          ASSIGN
                s_clob_cp:HIDDEN IN FRAME newfld = TRUE
                s_clob_col:HIDDEN IN FRAME newfld = TRUE
                s_btn_clob_cp:HIDDEN IN FRAME newfld = TRUE
                s_btn_clob_col:HIDDEN IN FRAME newfld = TRUE
                /* the ones at the same position must be hidden */
                b_Field._Label:HIDDEN IN FRAME newfld = FALSE
                b_Field._Col-label:HIDDEN IN FRAME newfld = FALSE.
      END.
    END.
    ELSE  DO:
        /* not a LOB field, enable all the fields except for the ones specific
          for LOBs
        */
        ASSIGN s_lob_size:HIDDEN IN FRAME newfld = TRUE
               s_lob_Area:HIDDEN IN FRAME newfld = TRUE
               s_btn_lob_Area:HIDDEN IN FRAME newfld = TRUE
               s_clob_cp:HIDDEN IN FRAME newfld = TRUE
               s_clob_col:HIDDEN IN FRAME newfld = TRUE
               s_btn_clob_cp:HIDDEN IN FRAME newfld = TRUE
               s_btn_clob_col:HIDDEN IN FRAME newfld = TRUE
               /* all the other ones */
               b_Field._Format:HIDDEN IN FRAME newfld = FALSE
               s_btn_Fld_Format:HIDDEN IN FRAME newfld = FALSE
               b_Field._Label:HIDDEN IN FRAME newfld = FALSE  	    
               b_Field._Col-label:HIDDEN IN FRAME newfld = FALSE   
               s_btn_Fld_ViewAs:SENSITIVE in frame newfld = FALSE
               s_btn_Fld_ViewAs:SENSITIVE in frame newfld = TRUE
               s_btn_Fld_Validation:SENSITIVE IN FRAME newfld = TRUE
               s_btn_Fld_Triggers:SENSITIVE IN FRAME newfld = TRUE
               s_btn_Fld_StringAttrs:SENSITIVE IN FRAME newfld = TRUE
               b_Field._Label:SENSITIVE IN FRAME newfld = TRUE  	    
               b_Field._Col-label:SENSITIVE IN FRAME newfld = TRUE   
               b_Field._Initial:SENSITIVE IN FRAME newfld = TRUE
               b_Field._Help:SENSITIVE IN FRAME newfld = TRUE 
               b_Field._Mandatory:SENSITIVE IN FRAME newfld = TRUE
               s_Fld_Array:SENSITIVE IN FRAME newfld = TRUE.  
    END.

END.

/*===============================Triggers====================================*/

/* include file contains trigger for s_lob_size and s_clob_cp */
{adedict/FLD/lob-misc.i &Frame = "frame newfld"}


/*-----WINDOW-CLOSE-----*/
on window-close of frame newfld
   apply "END-ERROR" to frame newfld.


/*----- HIT of OK BUTTON -----*/
on choose of s_btn_OK in frame newfld
   s_OK_Hit = yes.
   /* The GO trigger will fire after this. */


/*----- HIT of ADD BUTTON or GO -----*/
on GO of frame newfld	/* or Create because it's auto-go */
do:
   Define var no_name  as logical NO-UNDO.
   Define var obj      as char 	  NO-UNDO.
   Define var ins_name as char    NO-UNDO.
   Define var ix       as integer NO-UNDO.

   obj = (if s_CurrObj = {&OBJ_FLD} then "field" else "domain").
  
    run adedict/_blnknam.p
      (INPUT b_Field._Field-name:HANDLE in frame newfld,
       INPUT obj, OUTPUT no_name).
   if no_name then do:
      s_OK_Hit = no.
      return NO-APPLY.
   end.
   
   IF s_Fld_Dtype:SCREEN-VALUE IN FRAME newfld = "BLOB" OR
      s_Fld_Dtype:SCREEN-VALUE IN FRAME newfld = "CLOB" OR
      s_Fld_Dtype:SCREEN-VALUE IN FRAME newfld = "XLOB" THEN DO:
     
       ASSIGN islob = TRUE.

       IF b_Field._Fld-stlen = ? THEN
          RUN SetDefaults.

       RUN setlob.
   END.
   ELSE DO:
       /* if the user is moving from a LOB field to some other type, call
          setlob again just so that we enable the correct fields */
       IF islob THEN
          RUN setlob.

       ASSIGN islob = FALSE.
   END.

   /* Set some gateway defaults in case they haven't been set yet */
   run adedict/FLD/_dfltgat.p (FALSE).

   /* Do some gateways related validation */
   run adedict/FLD/_valgate.p.
   if RETURN-VALUE = "error" then do:
      s_OK_Hit = no.
      return NO-APPLY.
   end.

   do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      run adecomm/_setcurs.p ("WAIT").

      /* NOTE: the data type variables s_Fld_Protype/Gatetype etc. have
      	 been set from the trigger on change of data type.  b_Field._stdtype
      	 has also been set.
      */

      IF s_Fld_Protype = "INT64" THEN DO:
         IF DECIMAL(B_Field._Initial:SCREEN-VALUE) > 9223372036854775807 OR 
            DECIMAL(B_Field._Initial:SCREEN-VALUE) < -9223372036854775808 THEN DO:
             MESSAGE "Initial Value has value too large for int64"
                 VIEW-AS ALERT-BOX ERROR BUTTONS OK.
             UNDO.
         END.
      END.

      assign
	 b_Field._File-recid = Record_Id
	 b_Field._Data-Type = s_Fld_Protype /*WHEN s_Fld_Protype <> "CLOB"*/
     b_Field._For-type = s_Fld_Gatetype
     input frame newfld b_Field._Format
	 input frame newfld b_Field._Field-Name
	 input frame newfld b_Field._Initial WHEN NOT islob 
	 input frame newfld b_Field._Label   WHEN NOT islob
	 input frame newfld b_Field._Col-label WHEN NOT islob
	 input frame newfld b_Field._Mandatory WHEN NOT islob
	 input frame newfld b_Field._Decimals WHEN NOT islob
	 input frame newfld b_Field._Fld-case WHEN s_Fld_Protype <> "BLOB"
	 input frame newfld b_Field._Extent WHEN NOT islob
	 input frame newfld b_Field._Order
	 input frame newfld b_Field._Help WHEN NOT islob
	 input frame newfld b_Field._Desc.

     /* for clob/blobs, we have some additional fields to populate */
     IF islob THEN DO:
          FIND _Area WHERE _Area._Area-name = s_lob_area:SCREEN-VALUE IN FRAME newfld NO-ERROR.
          IF AVAILABLE _Area THEN DO:
            ASSIGN b_field._Fld-stlen = _Area._Area-number
                   b_Field._Width = s_lob_wdth
                   b_Field._Fld-Misc2[1] = CAPS(INPUT FRAME newfld s_lob_size).
            IF b_field._Initial <> ? THEN
              ASSIGN b_field._Initial = ?.
            
            RELEASE _Area.

          END.
          ELSE MESSAGE "Area " s_lob_area:SCREEN-VALUE IN FRAME newfld " is not valid"
               VIEW-AS ALERT-BOX.

          /* some are specific to CLOB fields */
          IF s_Fld_Protype = "CLOB" THEN DO:

              IF _Db._Db-xl-name = "undefined" AND 
                s_clob_cp:SCREEN-VALUE = "*Use DB Code Page"  THEN DO:
                  MESSAGE "The database code page is 'undefined' " SKIP
                          "A clob cannot be defined with this code page." SKIP(1)
                          "Select a code page other than 'Use DB Code Page'." SKIP
                      VIEW-AS ALERT-BOX ERROR.
                  UNDO, LEAVE.
              END.

              IF s_clob_cp:SCREEN-VALUE <> "*Use DB Code Page" THEN
                ASSIGN b_Field._Charset = INPUT FRAME newfld s_clob_cp:SCREEN-VALUE
                       b_Field._Collation = INPUT FRAME newfld s_clob_col:SCREEN-VALUE
                       b_Field._Attributes1 = 2. 
              ELSE 
                ASSIGN b_Field._Charset = _Db._Db-xl-name
                       b_Field._Collation = _Db._Db-coll-name
                       b_Field._Attributes1 = 1. 
          END.
      END.

      /* For certain gateways we store the character length in the _Decimals
	 field to support certain SQL operations.
      */
      if (s_Fld_TypeCode = {&DTYPE_CHARACTER} AND 
	  INDEX(s_Fld_Capab, {&CAPAB_CHAR_LEN_IN_DEC}) <> 0) then
	 b_Field._Decimals = b_Field._Fld-stlen.

      Last_Order = b_Field._Order.

      /* Add entry to appropriate list in the correct order */
      if s_CurrObj = {&OBJ_FLD} then
      	 run adedict/FLD/_ptinlst.p (INPUT b_Field._Field-Name,
      	       	     	      	     INPUT b_Field._Order).     

      {adedict/setdirty.i &Dirty = "true"}
      display "Field Created" @ s_Status with frame newfld.
      added = yes.
      run adecomm/_setcurs.p ("").
      return.
   end.

   /* Will only get here if there's an error. */
   run adecomm/_setcurs.p ("").
   s_OK_Hit = no.
   return NO-APPLY.
end.

/*----------U1 on Data Type Selection List ----------*/
on "U1" of s_Fld_DType in frame newfld
do:
     RUN SetDefaults.  /* sets s_Fld_Typecode */
     RUN setlob.    

     /*Assign s_fld_dtype to stop leave trigger from firing */
   ASSIGN s_fld_dtype = s_Fld_Dtype:SCREEN-VALUE.
end.


/*----- LEAVE of DATA TYPE FIELD -----*/

ON LEAVE OF s_Fld_DType IN FRAME newfld,
            s_btn_Fld_DType IN FRAME newfld,
            s_lst_Fld_DType IN FRAME newfld
DO:
   DEFINE VARIABLE lob AS LOGICAL NO-UNDO.

   ASSIGN cObjList = STRING(s_Fld_DType:HANDLE) + ',' +
                     STRING(s_btn_Fld_DType:HANDLE) + ',' +
                     STRING(s_lst_Fld_DType:HANDLE).

   /* If the ENTRY and LEAVE fields are part of the mock combo-box then
      we don't want to fire the leave event. */
   IF CAN-DO(cObjList,STRING(LAST-EVENT:WIDGET-ENTER)) AND
      CAN-DO(cObjList,STRING(LAST-EVENT:WIDGET-LEAVE)) THEN
     RETURN.

   /* See if type changed first.  If user had changed format or initial 
      value, for example, we don't want to clobber with defaults if we 
      don't have to. (* - los 12/27/94)
   */

   if s_Fld_DType <> s_Fld_DType:screen-value in frame newfld THEN DO:
       /* check if we are changing from a lob type so that we enable/disable
          the right fields 
       */
       IF s_Fld_DType = "BLOB" OR s_Fld_DType = "CLOB" OR s_Fld_DType = "XLOB" THEN 
          ASSIGN lob = YES.

    run SetDefaults.  /* sets s_Fld_Typecode */

    /* this will enable or disable some fields if we are changing to 
       or from a lob type 
    */
    IF s_Fld_Dtype:SCREEN-VALUE IN FRAME newfld = "BLOB" OR
       s_Fld_Dtype:SCREEN-VALUE IN FRAME newfld = "CLOB" OR 
       s_Fld_Dtype:SCREEN-VALUE IN FRAME newfld = "XLOB" OR islob OR lob THEN
       RUN setlob. 

   END.
   
end.


/*----- LEAVE of FORMAT FIELD -----*/
on leave of b_Field._Format in frame newfld 
do:
   /* Set format to default if it's blank and fix up initial value
      if data type is logical based on the format. */
   run adedict/FLD/_dfltfmt.p   
      (INPUT b_Field._Format:HANDLE in frame newfld,
       INPUT b_Field._Initial:HANDLE in frame newfld,
       INPUT 0,
       INPUT false). 
end.


/*----- HIT of FORMAT EXAMPLES BUTTON -----*/
on choose of s_btn_Fld_Format in frame newfld
do:
   Define var fmt as CHAR  NO-UNDO.
   IF s_Fld_DType:SCREEN-VALUE = "BLOB" OR s_Fld_DType:SCREEN-VALUE = "CLOB" THEN RETURN NO-APPLY.
   /* Allow user to pick a different format from examples */
   fmt = input frame newfld b_Field._Format.
   run adedict/FLD/_fldfmts.p (INPUT s_Fld_Typecode, INPUT-OUTPUT fmt).
   b_Field._Format:SCREEN-VALUE in frame newfld = fmt .
end.


/*----- VALUE-CHANGED of ARRAY TOGGLE -----*/
on value-changed of s_Fld_Array in frame newfld
do:
   IF s_Fld_DType:SCREEN-VALUE = "BLOB" OR s_Fld_DType:SCREEN-VALUE = "CLOB" THEN RETURN NO-APPLY.
   if SELF:screen-value = "yes" then
   do:
      b_Field._Extent:sensitive in frame newfld = true.
      b_Field._Extent:screen-value = "1".  /* default to non-zero value */
      apply "entry" to b_Field._Extent in frame newfld.
   end.
   else 
      assign
      	 b_Field._Extent:sensitive in frame newfld = false
      	 b_Field._Extent:screen-value in frame newfld = "0".
end.


/*----- HIT of COPY BUTTON -----*/
on choose of s_btn_Fld_Copy in frame newfld
do:
   if INDEX(s_Fld_Capab, {&CAPAB_COPY}) = 0 THEN
        IF NOT (isodbc AND _file._For-Type = "BUFFER" AND
                _File._For-Owner = ? AND _File._For-Name = "NONAME") THEN
        do:
            message "You may not copy fields for this database type."
      	         view-as ALERT-BOX ERROR buttons OK.
            return NO-APPLY.
        end.  
   /* Flag that copy was hit.  The add wait-for will break and we'll
      call the copy program from there.  We must do this so that pressing
      Done after copy will not undo the addition of the copied fields.
   */
   Copy_Hit = true.
end.


/*----- HIT of VIEW-AS BUTTON -----*/
on choose of s_btn_Fld_ViewAs in frame newfld
do:
   Define var no_name as logical NO-UNDO.
   Define var mod     as logical NO-UNDO.
   
   {adedict/forceval.i}  /* force leave trigger to fire */
   IF s_Fld_DType:SCREEN-VALUE = "BLOB" OR s_Fld_DType:SCREEN-VALUE = "CLOB" THEN RETURN NO-APPLY.
   run adedict/_blnknam.p
      (INPUT b_Field._Field-name:HANDLE in frame newfld,
       INPUT "field", OUTPUT no_name).
   if no_name then return NO-APPLY.

   run adecomm/_viewas.p (INPUT s_Fld_ReadOnly, INPUT s_Fld_Typecode,
      	       	     	  INPUT s_Fld_ProType, 
      	       	     	  INPUT-OUTPUT b_Field._View-as, OUTPUT mod).
end.

/*---------- LEAVE OF ORDER FIELD ---------*/
on leave of b_Field._order in frame newfld
DO:
      /* Avoid the test if the field hasn't changed */
      IF b_Field._Order = INT(b_Field._Order:SCREEN-VALUE IN FRAME newfld) THEN
         LEAVE. 
      /* Is the new order number a duplicate?  Don't allow it.  */
      IF CAN-FIND(FIRST _Field WHERE
                        _Field._File-recid = s_TblRecId AND
                        _Field._Order =
			INT(b_Field._Order:SCREEN-VALUE IN FRAME newfld) AND
			_Field._Order <> b_Field._Order) THEN 
      DO:
	 MESSAGE "Order number " +
	 TRIM(b_Field._Order:SCREEN-VALUE IN FRAME newfld) "already exists." 
	 VIEW-AS ALERT-BOX ERROR BUTTONS OK.
	 /* set order number back to its current value */
	 b_Field._Order:SCREEN-VALUE IN FRAME newfld = STRING(b_Field._Order).
        RETURN NO-APPLY.
      END.
END.

/*----- HELP -----*/
on HELP of frame newfld OR choose of s_btn_Help in frame newfld
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Create_Field_Dlg_Box}, ?).


/*============================Mainline code==================================*/

Define var msg     as char NO-UNDO.
Define var copytbl as char NO-UNDO init "".
Define var copyfld as char NO-UNDO init "".

find _File WHERE _File._File-name =  "_Field"
             AND _File._Owner = "PUB"
             NO-LOCK.
if NOT can-do(_File._Can-create, USERID("DICTDB")) then
do:
   if s_CurrObj = {&OBJ_FLD} then
      msg = "create fields.".
   else
      msg = "create domains.".
   message s_NoPrivMsg msg view-as ALERT-BOX ERROR buttons Ok.
   return.
end.

find _File where RECID(_File) = s_TblRecId.
msg = "".
if _File._Db-lang >= {&TBLTYP_SQL} then
   msg = "This is a {&PRO_DISPLAY_NAME}/SQL table.  Use ALTER TABLE/ADD COLUMN.".
else if _File._Frozen then  
   msg = "This table is frozen and cannot be modified.".
if msg <> "" then
do:
   message msg view-as ALERT-BOX ERROR buttons OK.
   return.
end.

/* Get ODBC types in case this is an ODBC db */
odbtyp = { adecomm/ds_type.i
           &direction = "ODBC"
           &from-type = "odbtyp"}.
           
/* See if this db is an ODBC db */      
IF CAN-DO(odbtyp, s_DbCache_Type[s_DbCache_ix]) THEN ASSIGN isodbc = yes.

/* Get gateway capabilities */
run adedict/_capab.p (INPUT {&CAPAB_FLD}, OUTPUT s_Fld_Capab).

/* allow add if ODBC BUFFER table */
if INDEX(s_Fld_Capab, {&CAPAB_ADD}) = 0 THEN
    IF NOT (isodbc AND _file._For-Type = "BUFFER" AND
            _File._For-Owner = ? AND _File._For-Name = "NONAME") THEN
    do:
        message "You may not add a field definition for this database type."
            view-as ALERT-BOX ERROR buttons OK.
        return.
    end.    


/* Set dialog box title to show which table this field will belong to. */
frame newfld:title = "Create Field for Table " + s_CurrTbl.

/* Set the record id of the table that this field will belong to or of the
   domain table which means this field is really a domain. */
if s_CurrObj = {&OBJ_FLD} then
   Record_Id =  s_TblRecId.
else
   Record_Id = s_DomRecId.

IsPro = {adedict/ispro.i}.

/* InIndex and InView aren't relevant on "add", Order# isn't relevant 
   for domains, copy is only used in create not props. toint64 is only
   for field properties.
*/
assign
   s_Fld_InIndex:hidden  in frame newfld = yes
   s_Fld_InView:hidden   in frame newfld = yes
   s_btn_Fld_Copy:hidden in frame newfld = no
   b_Field._Order:hidden in frame newfld =
      (if s_CurrObj = {&OBJ_DOM} then yes else no)
   s_btn_Fld_Gateway:sensitive in frame newfld = 
      (if IsPro then no else yes)
    s_btn_toint64:HIDDEN in frame newfld = yes.

/* specific to LOB fields */
ASSIGN s_lob_size:HIDDEN IN FRAME newfld = YES
       s_lob_Area:HIDDEN IN FRAME newfld = YES
       s_btn_lob_Area:HIDDEN IN FRAME newfld = YES
       s_clob_cp:HIDDEN IN FRAME newfld = YES
       s_clob_col:HIDDEN IN FRAME newfld = YES
       s_btn_clob_cp:HIDDEN IN FRAME newfld = YES
       s_btn_clob_col:HIDDEN IN FRAME newfld = YES.

/* Adjust the data type fill-in and list: font and width. */
{adedict/FLD/dtwidth.i &Frame = "Frame newfld" &Only1 = "FALSE"}

/* Run time layout for button area.  This defines eff_frame_width 
   Since this is a shared frame we have to avoid doing this code 
   more than once.
*/
if frame newfld:private-data <> "alive" then
do:
   frame newfld:private-data = "alive".

   {adecomm/okrun.i  
      &FRAME = "frame newfld" 
      &BOX   = "s_rect_Btns"
      &OK    = "s_btn_OK" 
      &HELP  = "s_btn_Help"
   }

   /* So Return doesn't hit default button in editor widget. */
   b_Field._Desc:RETURN-INSERT in frame newfld = yes.

   /* runtime adjustment of "Optional" title band to the width of the frame */
   s_Optional:width-chars in frame newfld = eff_frame_width - ({&HFM_WID} * 2).
end.

/* Fill data type combo box based on the gateway */
run SetDataTypes.
{adecomm/cbdrop.i &Frame  = "frame newfld"
      	       	  &CBFill = "s_Fld_DType"
      	       	  &CBList = "s_lst_Fld_DType"
      	       	  &CBBtn  = "s_btn_Fld_DType"
     	       	  &CBInit = """"}
                  

/* FILL THE SELECTION LIST OF AREAS FOR BLOB / CLOB FIELDS */

FIND DICTDB._Db WHERE RECID(_Db) = _File._Db-recid NO-LOCK.

s_lst_lob_area:list-items in frame newfld = "".

IF _File._For-type <> ? THEN
  ASSIGN s_lob_Area = "N/A".
ELSE DO:
  IF _File._File-number <> ? THEN DO:
    FIND _storageobject WHERE _Storageobject._Db-recid      = s_DbRecId AND 
                              _Storageobject._Object-type   = 1         AND 
                              _Storageobject._Object-number = _File._File-Number NO-LOCK.

    IF AVAILABLE _StorageObject THEN
      FIND DICTDB._Area 
         WHERE DICTDB._Area._Area-number = _StorageObject._Area-number NO-LOCK.
    ELSE
      FIND DICTDB._Area WHERE DICTDB._Area._Area-number = 6 NO-LOCK.
  END.
  ELSE
    FIND DICTDB._Area WHERE DICTDB._Area._Area-num = _File._ianum.

  ASSIGN s_lob_Area = DICTDB._Area._Area-name.
END.

FOR EACH DICTDB._Area FIELDS (_Area-num _Area-type _Area-name) WHERE DICTDB._Area._Area-num > 6 
                    AND DICTDB._Area._Area-type = 6 
                    AND NOT CAN-DO({&INVALID_AREAS}, DICTDB._AREA._Area-name) NO-LOCK:

    IF DICTDB._Area._Area-name = s_lob_Area THEN
       s_res = s_lst_lob_area:ADD-FIRST(DICTDB._Area._Area-name) in frame newfld.
    ELSE
       s_res = s_lst_lob_area:add-last(DICTDB._Area._Area-name) in frame newfld.
END.
FIND DICTDB._Area WHERE DICTDB._Area._Area-num = 6 NO-LOCK.
ASSIGN s_res = s_lst_lob_area:add-last(DICTDB._Area._Area-name) in frame newfld
     bnum = s_lst_lob_area:num-items in frame newfld
     s_lst_lob_area:inner-lines in frame newfld = (if bnum <= 5 then bnum else 5). 


/* fill Area combo box */
{adecomm/cbdrop.i &Frame  = "frame newfld"
                &CBFill = "s_lob_Area"
                &CBList = "s_lst_lob_area"
                &CBBtn  = "s_btn_lob_Area"
                &CBInit = """"}

/* FILL IN LIST OF CODE PAGES AND COLLATIONS FOR CLOB FIELDS */
ASSIGN s_clob_cp = "*Use DB Code Page"
     hldcp = GET-CODEPAGES
     s_lst_clob_cp:LIST-ITEMS IN FRAME newfld = ""
     s_res = s_lst_clob_cp:ADD-FIRST(s_clob_cp) IN FRAME newfld.

DO i = 1 TO NUM-ENTRIES(hldcp):
  IF ENTRY(i, hldcp) <> "undefined" AND 
     ENTRY(i, hldcp) <> "UCS2"      AND 
     ENTRY(i, hldcp) <> "GB18030"   THEN
    s_res = s_lst_clob_cp:ADD-LAST(ENTRY(i, hldcp)) in frame newfld.
END.

/* fill code page combo box */
{adecomm/cbdrop.i &Frame  = "frame newfld"
                &CBFill = "s_clob_cp"
                &CBList = "s_lst_clob_cp"
                &CBBtn  = "s_btn_clob_cp"
                &CBInit = """"}

ASSIGN s_clob_col = DICTDB._DB._Db-coll-name
     s_lst_clob_col:LIST-ITEMS IN FRAME newfld = ""
     s_res = s_lst_clob_col:ADD-FIRST("*Use DB Collation") in frame newfld.

/* fill collation combo box */
{adecomm/cbdrop.i &Frame  = "frame newfld"
                &CBFill = "s_clob_col"
                &CBList = "s_lst_clob_col"
                &CBBtn  = "s_btn_clob_col"
                &CBInit = """"}

/* make sure these are hidden */
ASSIGN s_btn_lob_Area:HIDDEN IN FRAME newfld = YES
       s_btn_clob_cp:HIDDEN IN FRAME newfld = YES
       s_btn_clob_col:HIDDEN IN FRAME newfld = YES.


/* Erase any status from the last time */
s_Status = "".
display s_Status with frame newfld.
ASSIGN s_btn_Done:label in frame newfld = "Cancel".      

/* if this is a LOB field, we have less fields to enable now */
IF islob THEN DO:
   enable b_Field._Field-Name 
          s_Fld_DType
          s_lob_area
          s_btn_lob_Area
          b_Field._Order     when s_CurrObj = {&OBJ_FLD} 
          s_lob_size
          b_Field._Desc
          s_btn_OK
          s_btn_Add
          s_btn_Done
          s_btn_Help
         with frame newfld.   
END.
ELSE DO:
enable b_Field._Field-Name  
       s_btn_Fld_Copy
       s_Fld_DType          
       s_btn_Fld_DType
       b_Field._Format      
       s_btn_Fld_Format     
       b_Field._Label  	    
       b_Field._Col-label   
       b_Field._Initial
       b_Field._Order 	    when s_CurrObj = {&OBJ_FLD} 
       b_Field._Desc
       b_Field._Help
       b_Field._Mandatory   when INDEX(s_Fld_Capab, {&CAPAB_CHANGE_MANDATORY}) 
      	       	     	      	       > 0 
       b_Field._Fld-case    WHEN NOT islob /* this may be disabled later */
       s_Fld_Array
       s_btn_Fld_Triggers
       s_btn_Fld_Validation
       s_btn_Fld_ViewAs
       s_btn_Fld_StringAttrs
       s_btn_Fld_Gateway    when NOT IsPro
       s_btn_OK
       s_btn_Add
       s_btn_Done
       s_btn_Help
       with frame newfld.

END.

/* The rule is ENABLE effects the TAB order but x:SENSITIVE = yes does not. 
   Now readjust tab orders for stuff not in the ENABLE set but
   which may, in fact be sensitive at some point during this .p.
*/
assign
   s_Res = s_lst_Fld_DType:move-after-tab-item
      	       (s_btn_Fld_DType:handle in frame newfld) in frame newfld
   s_Res = b_Field._Decimals:move-before-tab-item
      	       (b_Field._Desc:handle in frame newfld) in frame newfld
   s_Res = b_Field._Fld-case:move-before-tab-item
      	       (s_Fld_Array:handle in frame newfld) in frame newfld
   s_Res = b_Field._Extent:move-after-tab-item
      	       (s_Fld_Array:handle in frame newfld) in frame newfld
   s_Res = s_lob_area:MOVE-AFTER-TAB-ITEM
               (s_btn_Fld_DType:HANDLE IN FRAME newfld) IN FRAME newfld
   s_Res = s_btn_lob_area:MOVE-AFTER-TAB-ITEM
               (s_lob_area:HANDLE IN FRAME newfld) IN FRAME newfld
   s_Res = s_lst_lob_area:MOVE-AFTER-TAB-ITEM
               (s_btn_lob_area:HANDLE IN FRAME newfld) IN FRAME newfld
   s_Res = s_lob_size:MOVE-AFTER-TAB-ITEM
                (b_Field._Order:HANDLE IN FRAME newfld) IN FRAME newfld
   s_Res = s_clob_cp:MOVE-AFTER-TAB-ITEM
                (s_btn_lob_area:HANDLE IN FRAME newfld) IN FRAME newfld
   s_Res = s_btn_clob_cp:MOVE-AFTER-TAB-ITEM
                (s_clob_cp:HANDLE IN FRAME newfld) IN FRAME newfld
   s_Res = s_clob_col:MOVE-AFTER-TAB-ITEM
                (s_btn_clob_cp:HANDLE IN FRAME newfld) IN FRAME newfld
   s_Res = s_btn_clob_col:MOVE-AFTER-TAB-ITEM
                (s_clob_col:HANDLE IN FRAME newfld) IN FRAME newfld
   .
   
/* Each add will be a subtransaction. */
s_OK_Hit = no.
add_subtran:
repeat ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE  ON STOP UNDO, LEAVE:
   /* Do this up top here, to be sure we committed the last create */
   if s_OK_Hit then leave add_subtran.

   if added AND s_btn_Done:label in frame newfld <> "Close" then
      s_btn_Done:label in frame newfld = "Close".

   if Copy_Hit then
   do:
      /* This will copy fields and end the sub-transaction so that "Done" 
      	 will not undo it. */
      Copy_Hit = false.  /* reset flag */
      run adedict/FLD/_fldcopy.p (INPUT-OUTPUT Last_Order,
      	       	     	      	 OUTPUT copytbl, OUTPUT copyfld,
      	       	     	      	 OUTPUT copied).
      if copied then 
      do:
      	 display "Copy Completed" @ s_Status with frame newfld.
      	 added = yes.
      end.
   end.
   else do:
      create b_Field.

      /* default a unique order # */
      if Last_Order = ? then
      do:
	 find LAST _Field USE-INDEX _Field-Position 
	    where _Field._File-recid = Record_Id NO-ERROR.
	 Last_Order = (if AVAILABLE _Field then _Field._Order + 10 else 10).
      end.
      else
	 Last_Order = Last_Order + 10.

      if copytbl = "" then
      do:
      	 /* This is a brand new field */

	 b_Field._Order = Last_Order.
    
	 /* Set defaults based on the current data type (either the first
	    in the list or whatever was chosen last time).
	 */
	 run SetDefaults.
    
	 /* Reset some other default values */
	 assign
	    s_Fld_Array = false
	    b_Field._Extent:screen-value in frame newfld  = "0"
	    b_Field._Extent:sensitive in frame newfld = no
	    b_Field._Fld-case:screen-value in frame newfld = "no".

     /* defauts for lob fields */
     ASSIGN  s_lob_size = "100M"
             s_lob_size:SCREEN-VALUE IN FRAME newfld = s_lob_size
             s_lob_wdth = 104857600.

      	 /* Display any remaining attributes */
	 display "" @ b_Field._Field-Name /* blank instead of ? */
      	       	 s_Optional
		 b_Field._Label     WHEN s_Fld_Typecode <> {&DTYPE_CLOB}
		 b_Field._Col-label WHEN s_Fld_Typecode <> {&DTYPE_CLOB}
		 b_Field._Mandatory
		 b_Field._Help
		 b_Field._Desc 
		 b_Field._Order
		 s_Fld_Array
		 with frame newfld.       
      end.
      else do:  
      	 /* Set the field values based on a field chosen as a template
      	    in the Copy dialog box.
      	 */
      	 find _File where _File._Db-recid = s_DbRecId AND
      	       	     	  _File._File-name = copytbl AND
                         ( _File._Owner = "PUB"  OR _File._Owner = "FOREIGN").
      	 find _Field of _File where _Field._Field-name = copyfld.
         
      	 assign
      	    b_Field._Field-name = _Field._Field-name
      	    b_Field._Data-type  = _Field._Data-type
      	    b_Field._Format     = _Field._Format
      	    b_Field._Initial    = _Field._Initial
      	    b_Field._Order    	= Last_Order.
      	 {prodict/dump/copy_fld.i &from=_Field &to=b_Field &all=false}

         IF (b_field._Data-type = "BLOB" OR b_Field._Data-type = "CLOB") THEN DO:
            DEFINE BUFFER b_Area FOR _Area.
            
            /* Find the storage object so that we can see which area the lob is stored
               in and then find the area to display the name to the user if record has
               been committed.  Else find area using number in _fld-stlen 
               _Fld-stlen holds the object number once the field is created by the Progress client 
            */
            IF _Field._Field-rpos <> ? THEN DO: /* if the field was commited */
               FIND _storageobject WHERE _Storageobject._Db-recid = s_DbRecId
                                     AND _Storageobject._Object-type = 3
                                     AND _Storageobject._Object-number = b_Field._Fld-stlen
                                     NO-LOCK.

               /* _Fld-stlen contains the unique object number once the field is created by the Progress
                  client. For new fields, we pass the area number in _Fld-stlen, so reset it now. Once
                  this field is created by the Progress client, it will reassign it to the object number
               */
               ASSIGN b_field._Fld-stlen = _StorageObject._Area-number.

               FIND b_Area WHERE b_Area._Area-number = _StorageObject._Area-number NO-LOCK.
            END.
            ELSE
               FIND b_Area WHERE b_Area._Area-number = b_Field._Fld-stlen NO-LOCK.

           ASSIGN s_lob_size:SCREEN-VALUE IN FRAME newfld = _Field._Fld-Misc2[1]
                  s_lob_wdth = _Field._Width
                  s_lob_Area:SCREEN-VALUE IN FRAME newfld = b_Area._Area-name.

           RELEASE _storageobject NO-ERROR.
           RELEASE b_Area.

         END.

         IF b_field._Data-type = "CLOB" THEN DO:

           /* set code page and collation just like copied field */
           IF _Field._Charset = _Db._Db-xl-name THEN
              ASSIGN s_clob_cp:SCREEN-VALUE IN FRAME newfld = "*Use DB Code Page".
           ELSE                                        
              ASSIGN s_clob_cp:SCREEN-VALUE IN FRAME newfld =  _Field._Charset.

           IF b_Field._Collation = _Db._Db-coll-name THEN
              ASSIGN s_clob_col:SCREEN-VALUE IN FRAME newfld = "*Use DB Collation".
           ELSE
              ASSIGN s_clob_col:SCREEN-VALUE IN FRAME newfld = _Field._Collation.

           ASSIGN b_field._Charset   = _Field._Charset
                  b_Field._Collation = _Field._Collation.
         END.

      	 assign
      	    s_Fld_DType = b_Field._Data-Type
      	    s_Fld_Array = (if b_Field._Extent > 0 then yes else no)
      	    s_Fld_Protype = b_Field._Data-type
	        s_Fld_Gatetype = b_Field._For-type
	        s_Fld_Typecode = _Field._dtype.        

      	 /* Make sensitive/label adjustments to fld-case and _Decimals based
      	    on data type chosen. */
      	    run adedict/FLD/_dtcust.p 
      	       (INPUT b_Field._Fld-case:HANDLE in frame newfld,
      	       	INPUT b_Field._Decimals:HANDLE in frame newfld).

      	 display
	    b_Field._Field-name
        s_Fld_DType
        s_Optional
	    b_Field._Format  WHEN NOT islob
	    s_lob_area       WHEN islob
	    s_btn_lob_Area   WHEN islob
	    b_Field._Label   WHEN s_Fld_Typecode <> {&DTYPE_CLOB}  
	    b_Field._Col-label WHEN s_Fld_Typecode <> {&DTYPE_CLOB}
	    b_Field._Initial   

	    b_Field._Order     
	    b_Field._Fld-case 	 when s_Fld_Typecode = {&DTYPE_CHARACTER}
	    b_Field._Decimals  	 when s_Fld_Typecode = {&DTYPE_DECIMAL}
	    s_lob_size             WHEN islob
	    b_Field._Mandatory 
        s_Fld_Array
	    b_Field._Extent      when b_Field._Extent > 0
	    b_Field._Desc      
	    b_Field._Help      
      	    with frame newfld.

      	 /* Reset the drop down value for data types */
      	 s_lst_Fld_DType:screen-value in frame newfld = CAPS(s_Fld_DType).

      	 /* Reset these for next loop iteration. */
      	 assign
      	    copytbl = ""
      	    copyfld = "".

          /* force trigger to fire on blobs and clobs*/
         IF s_fld_Dtype = "BLOB" OR s_fld_Dtype = "CLOB" THEN
            ASSIGN islob = TRUE.

         /* make sure we enable/disable the proper fields */
         RUN setlob.

      end.
      
      wait-for choose of s_btn_OK in frame newfld,
      	       	     	 s_btn_Add in frame newfld,
      	       	     	 s_btn_Fld_Copy in frame newfld OR
      	       GO of frame newfld
      	       FOCUS b_Field._Field-Name in frame newfld.

      /* Undo the create of b_Field so that when we repeat we don't end up
	 with a bogus field with all unknown values. */
      if Copy_Hit then
	 undo add_subtran, next add_subtran.
   end.
end.

hide frame newfld. 
return.

/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/


/*----------------------------------------------------------------------------

File: _ptinlst.p

Description:
   Put the new field or existing field whose name or order # has changed
   into the browse select list in the correct position.

Input Parameters:
   p_Name  - The name of the new or modified field
   p_Order - The new or modified order# for this field.

Author: Laura Stern

Date Created: 12/01/92 


----------------------------------------------------------------------------*/

{adedict/dictvar.i shared}
{adedict/brwvar.i shared}


Define INPUT PARAMETER p_Name  as char 	  NO-UNDO.
Define INPUT PARAMETER p_Order as integer NO-UNDO.

Define var ins_name as char    NO-UNDO.

if s_Order_By = {&ORDER_ALPHA} then
   find FIRST _Field where _Field._File-recid = s_TblRecId AND
	     	      	   _Field._Field-Name > p_Name
      NO-ERROR.
else
   find FIRST _Field where _Field._File-recid = s_TblRecId AND
	     	      	    _Field._Order > p_Order
      NO-ERROR.

ins_name = (if AVAILABLE _Field then _Field._Field-name else "").

/* if create button pushed that caused blob, clob, or xlob procedure to run
   we don't want to put in list twice */
IF s_lst_flds:LOOKUP(p_name) = 0 THEN
  run adedict/_newobj.p 
    (INPUT s_lst_Flds:HANDLE in frame browse,
     INPUT p_Name,
     INPUT ins_name,
     INPUT s_Flds_Cached,
     INPUT {&OBJ_FLD}).
/***********************************************************************
* Copyright (C) 2000,2006,2008 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/*----------------------------------------------------------------------------

File: _renam.p

Description:
   Display and handle the global field rename dialog box.

Author: Laura Stern

Date Created: 03/27/92 
    Modified: D. McMann 06/29/98 Added _Owner check to find of _File.

----------------------------------------------------------------------------*/


&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/FLD/fldvar.i shared}

DEFINE VARIABLE Fld_Old_Name    AS CHARACTER     NO-UNDO.
DEFINE VARIABLE Fld_New_Name    AS CHARACTER     NO-UNDO.
DEFINE VARIABLE msgRenam        AS CHARACTER VIEW-AS EDITOR NO-BOX INNER-CHARS 62 INNER-LINES 2 NO-UNDO.

FORM
   SKIP({&TFM_WID})
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
   msgRenam NO-LABELS AT 2 SKIP
&ELSE
   "This renames a field throughout all tables. The new field name" VIEW-AS TEXT    	      	    AT  2  SKIP
   "must not already be in use in any table in the database." VIEW-AS TEXT AT 2  SKIP
&ENDIF 
   SKIP({&VM_WIDG})

   Fld_Old_Name	     label "&Old Field Name" COLON 18     	       	   
                    format "x(32)"  {&STDPH_FILL}         SKIP({&VM_WID})
   Fld_New_Name	     label "&New Field Name" COLON 18
      	             format "x(32)"  {&STDPH_FILL}

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}

   WITH FRAME fld_rename THREE-D
        VIEW-AS DIALOG-BOX TITLE "Globally Rename Fields"
        DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel
        SIDE-LABELS.

IF SESSION:SCHEMA-CHANGE = "New Objects" THEN DO:
   MESSAGE 'You can not rename fields when SESSION:SCHEMA-CHANGE = "New Objects".'
       VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  ASSIGN msgRenam:SCREEN-VALUE =
    "This renames a field throughout all tables. The new field name " +
    "must not already be in use in any table in the database.".
    msgRenam:READ-ONLY = yes.

  ENABLE msgRenam WITH FRAME fld_rename.
&ENDIF

/*-------------------------------Triggers------------------------------------*/

/*-----WINDOW-CLOSE-----*/
on window-close of frame fld_rename
   apply "END-ERROR" to frame fld_rename.

/*----- HIT of OK BUTTON or GO ----- */
on GO of frame fld_rename  /* or GO due to AUTO-GO */
do:
   DEFINE VARIABLE name   AS CHARACTER    NO-UNDO.
   DEFINE VARIABLE nname  AS CHARACTER    NO-UNDO.
   DEFINE VARIABLE num    AS INTEGER      NO-UNDO.
   DEFINE VARIABLE isfroz AS LOGICAL      NO-UNDO.
   DEFINE VARIABLE isview AS LOGICAL      NO-UNDO.
   DEFINE VARIABLE issql  AS LOGICAL      NO-UNDO.
   DEFINE VARIABLE msg    AS CHARACTER    NO-UNDO.
   DEFINE VARIABLE answer AS LOGICAL      NO-UNDO.

   name = input frame fld_rename Fld_Old_Name.
   if name = "" OR name = ? then
   do:
      message "Please enter the name of a field to rename."
      	       VIEW-AS ALERT-BOX ERROR  buttons OK.
      apply "entry" to Fld_Old_Name in frame fld_rename.
      return NO-APPLY.
   end.

   nname = input frame fld_rename Fld_New_Name.
   if nname = "" OR nname = ? then
   do:
      message "Please enter the new name."
      	       VIEW-AS ALERT-BOX ERROR  buttons OK.
      apply "entry" to Fld_New_Name in frame fld_rename.
      return NO-APPLY.
   end.

   /* Make sure none of the tables are frozen, views or sql tables.  If 
      this loop completes, num will be the number of tables that we
      found the field name in.
   */
   run adecomm/_setcurs.p ("WAIT").
   for each _File where _File._DB-recid = s_DbRecId
                    AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN"),
       each _Field of _File
       where _Field._Field-Name = name
       while NOT (isfroz OR issql OR isview):

      isfroz = _file._Frozen.
      isview = can-find(FIRST _View-ref where
      	       	     	_View-ref._Ref-Table = _File._File-Name AND
      	       	     	_View-ref._Base-Col = _Field._Field-Name).
      issql = (_File._Db-lang >= {&TBLTYP_SQL}).
      num = num + 1.      
   end.   
   run adecomm/_setcurs.p ("").

   msg = "".
   if isfroz then
      msg = "One or more of the tables containing this field is frozen.".
   else if isview then
      msg = "This field is used in a view.".
   else if issql then
      msg = "This field name is used in a {&PRO_DISPLAY_NAME}/SQL table.".

   if msg <> "" then
   do:
      message msg SKIP "You cannot rename."
      	      VIEW-AS ALERT-BOX ERROR
      	      buttons OK.
      return NO-APPLY.
   end.

   if num = 1 then
      message "There is 1 occurrence of this field." SKIP
      	      "Are you sure you want to rename it?"
      	      VIEW-AS alert-box question buttons YES-NO update answer.
   else
      message "There are" num "occurrences of this field." SKIP
      	      "Are you sure you want to rename them?"
      	      VIEW-AS alert-box question buttons YES-NO update answer.
   if NOT answer then
      return NO-APPLY.
end.


/*----- LEAVE of NEW NAME ----- */
on leave of Fld_Old_Name in frame fld_rename
do:
   DEFINE VARIABLE name AS CHARACTER    NO-UNDO.

   name = TRIM(Self:SCREEN-VALUE).
   SELF:SCREEN-VALUE = name.  /* redisplay trimmed name */

   if name = "" then return.

   FIND FIRST _Field where _Field._Field-Name = NAME NO-LOCK NO-ERROR.
   IF AVAILABLE _Field THEN DO:
       /* if one of the encryption schema tables, don't let it go through */
       FIND FIRST _File OF _Field WHERE 
           NOT CAN-DO({&INVALID_SCHEMA_TABLES},_File._File-name) NO-LOCK NO-ERROR.
       IF NOT AVAILABLE _File THEN
           RELEASE _Field.
   END.

   IF NOT AVAILABLE _Field THEN
   do:
      message "The field to rename is not in any table."
      	      VIEW-AS ALERT-BOX ERROR
      	      buttons OK.
      return NO-APPLY.
   end.
end.


/*----- LEAVE of NEW NAME ----- */
on leave of Fld_New_Name in frame fld_rename
do:
   DEFINE VARIABLE okay AS LOGICAL NO-UNDO.
   DEFINE VARIABLE name AS CHARACTER    NO-UNDO.

   name = TRIM(Self:SCREEN-VALUE).
   SELF:SCREEN-VALUE = name.  /* redisplay trimmed name */

   if name = "" then return.

   FIND FIRST _Field where _Field._Field-Name = NAME NO-LOCK NO-ERROR.
   IF AVAILABLE _Field THEN DO:
       /* if one of the encryption schema tables, act as if it doesn't exist 
          It will get blocked in _valname.p as an invalid name due to the
          underscore at the beginning of the name
       */
       FIND FIRST _File OF _Field NO-LOCK.
       IF CAN-DO({&INVALID_SCHEMA_TABLES},_File._File-name) THEN
           RELEASE _Field.
   END.

   IF AVAILABLE _Field THEN
   do:
      message "The new name is already in use in some table."
      	      VIEW-AS ALERT-BOX ERROR
      	      buttons OK.
      return NO-APPLY.
   end.

   /* Make sure the new name is a valid identifier for Progress. */
   run adecomm/_valname.p (INPUT name, INPUT true, OUTPUT okay).

   if NOT okay then
      return NO-APPLY. 
end.


/*----- HELP -----*/
on HELP of frame fld_rename OR choose of s_btn_Help in frame fld_rename
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", 
      	       	     	     {&Globally_Rename_Fields_Dlg_Box}, ?).


/*----------------------------Mainline code----------------------------------*/

DEFINE VARIABLE msg_text AS CHARACTER NO-UNDO.

find _File WHERE _File._File-name = "_Field"
             AND _File._Owner = "PUB".
if NOT can-do(_File._Can-write, USERID("DICTDB")) then
do:
   message s_NoPrivMsg "modify fields."
      VIEW-AS ALERT-BOX ERROR buttons Ok.
   return.
end.

/* This find's the first non-system table  */
find FIRST _Field where _Field._Field-name < "_" NO-ERROR.
if NOT AVAILABLE _Field then
do:
   message "There are no user-defined fields in this database."
      	    VIEW-AS ALERT-BOX ERROR
      	    buttons OK.
   return.
end.



/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame fld_rename" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}

do ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE  ON STOP UNDO, LEAVE:
   update Fld_Old_Name 	
      	  Fld_New_Name
      	  s_btn_Ok   	
      	  s_btn_Cancel
      	  s_btn_Help
      	  with frame fld_rename.   

   run adecomm/_setcurs.p ("WAIT").

   for each _File where _File._DB-recid = s_DbRecId
                    AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN"),
       each _Field of _File where _Field._Field-Name = Fld_Old_Name:
   	 _Field._Field-Name = Fld_New_Name.
   end.

   /* Reflect the change in the edit field window if it's up. - Note
      if the user had typed over the name field but hasn't saved yet,
      this will clobber his change.  Also change the value in the field list.
   */
   if s_win_Fld <> ? AND s_CurrFld = Fld_Old_Name then
   do:
      b_Field._Field-Name = Fld_New_Name.
      display b_Field._Field-Name with frame fldprops.
   end.

   if s_Flds_Cached then
   do:
      /* If there's more than one item in list and order is
      	 alphabetical, remove the entry and re-add to make sure
      	 new name is in alpabetical order.
      */
      if s_Order_By = {&ORDER_ALPHA} AND
         s_lst_Flds:NUM-ITEMS in frame browse > 1 then
      do:
       	 s_Res = s_lst_Flds:delete(Fld_Old_Name) in frame browse.
      	 run adedict/FLD/_ptinlst.p (INPUT Fld_New_Name, INPUT 0).
      end.
      else do:
      	 /* Just change the name in place. */      	  
	 {adedict/repname.i
	    &OldName = Fld_Old_Name
	    &NewName = Fld_New_Name
	    &Curr    = s_CurrFld
	    &Fill    = s_FldFill
	    &List    = s_lst_Flds}
      end.
   end.

   {adedict/setdirty.i &Dirty = "true"}
end.

run adecomm/_setcurs.p ("").
hide frame fld_rename.
return.





/***********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/*----------------------------------------------------------------------------

File: _renum.p

Description:
   Display and handle the field renumber dialog box to renumber all
   the field order numbers for a table.

Author: Laura Stern

Date Created: 03/23/92 
    Modified: D. McMann Added _Owner to find of _File
      	      Mario B. 11/17/98 Changed renumbering from using a fixed offset
	                        of - 10000 for pre-conversion to using * -1 to
				prevent conflicts when a 10000+ Order# exists.
              D. McMann 06/10/02 Added check for session schema change attribute

----------------------------------------------------------------------------*/

&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/FLD/fldvar.i shared}

Define var NumFlds   	      as integer NO-UNDO init 0.
Define var Fld_Renum_Start    as integer NO-UNDO.
Define var Fld_Renum_Incr     as integer NO-UNDO.
Define var Fld_Order          as char    NO-UNDO format "x(16)".

Define var Overflow_Msg1      as char  NO-UNDO
   init "The highest allowed _Order value is 99999.".
Define var Overflow_Msg2      as char  NO-UNDO
   init "These values will cause _Order to overflow.".

Define buffer x_File for _File.

form
   SKIP({&TFM_WID})
   "The current field order setting determines the order in which":t65  VIEW-AS TEXT AT 2 
   SKIP
   "fields are read for renumbering.":t65  VIEW-AS TEXT at 2
   SKIP({&VM_WIDG})

   Fld_Renum_Start   label "&Start Numbering From"    colon 28
      	       	     format ">>,>>>" {&STDPH_FILL}
   SKIP({&VM_WID})

   Fld_Renum_Incr    label "&Increment Each by"	      colon 28
      	       	     format ">>,>>>" {&STDPH_FILL} 

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}

   with frame fld_renum
        view-as DIALOG-BOX
        TITLE "Renumber Fields in Table " + x_file._File-Name
        DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel
        SIDE-LABELS.


/*-------------------------------Triggers------------------------------------*/

/*-----WINDOW-CLOSE-----*/
on window-close of frame fld_renum
   apply "END-ERROR" to frame fld_renum.


/*----- HIT of OK BUTTON OR GO -----*/
on GO of frame fld_renum   /* OR OK due to AUTO-GO */
do:
   Define var start   	as integer NO-UNDO.
   Define var incr    	as integer NO-UNDO. 
   Define var nextnum 	as integer NO-UNDO.
   Define var orignum   as integer NO-UNDO.

   /* Status frame */
   FORM
      SKIP(1)
      SPACE(3) orignum  LABEL "Changing" format ">>>>9"
      	       nextnum  LABEL "To"       format ">>>>9"
      SPACE(3)
      SKIP(1)
      with frame stat SIDE-LABELS view-as dialog-box.

   start = input frame fld_renum Fld_Renum_Start.
   incr = input frame fld_renum Fld_Renum_Incr.
   
   if start + incr * (NumFlds - 1) > 99999 then
   do:
      message Overflow_Msg1 SKIP Overflow_Msg2
      	      view-as ALERT-BOX ERROR
      	      buttons OK.
      return NO-APPLY.
   end.

   /* Let's do it. */
   nextnum = start.

   do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      run adecomm/_setcurs.p (INPUT "WAIT").

      /* We have to make sure that the new numbers don't conflict with any
      	 existing numbers.  
      */
      for each _Field of x_File:
      	 _Field._Order = _Field._Order * -1.
      end.

      session:immediate-display = yes.

      if s_Order_By = {&ORDER_ALPHA} then
	 for each _Field of x_File by _Field._Field-Name:
      	    display _Field._Order * -1 @ orignum nextnum with frame stat.
	    _Field._Order = nextnum.
	    nextnum = nextnum + incr.
	 end.
      else
	 for each _Field of x_File by _Field._Order DESCENDING:
      	    display _Field._Order * -1 @ orignum  nextnum with frame stat.
	    _Field._Order = nextnum.
	    nextnum = nextnum + incr.
	 end.
      
      hide frame stat no-pause.
      session:immediate-display = no.

      /* Refresh any current display to reflect this change. We don't have
      	 to redisplay the field list, since if fields are displayed by
      	 order, they are renumbered in that same order anyway. */
      if s_win_Fld <> ? then
      do:
      	 find _Field of x_File where _Field._Field-Name = s_CurrFld.
      	 b_Field._Order = _Field._Order.
      	 display b_Field._Order with frame fldprops.
      end.
      
      {adedict/setdirty.i &Dirty = "true"}
      run adecomm/_setcurs.p (INPUT "").
      return.
   end.

   /* Get here only if error - leave dialog box up and let user hit cancel */
   run adecomm/_setcurs.p (INPUT "").
   return NO-APPLY.	 
end.


/*----- LEAVE of RENUM-INCR ----- */
on leave of Fld_Renum_Incr in frame fld_renum
do:
   Define var incr as integer NO-UNDO.

   incr = INTEGER(SELF:screen-value).

   if incr <= 0 OR incr = ? then 
   do:	 
      message "Please enter a positive number to increment by."
      	      view-as ALERT-BOX ERROR buttons OK.
      return NO-APPLY.
   end.
end.


/*----- HELP -----*/
on HELP of frame fld_renum OR choose of s_btn_Help in frame fld_renum
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", 
      	       	     	     {&Renumber_Order_Numbers_Dlg_Box}, ?).


/*----------------------------Mainline code----------------------------------*/

Define var msg_text as char NO-UNDO.


find _File WHERE _File._File-name = "_Field"
             AND _File._Owner = "PUB".
if NOT can-do(_File._Can-write, USERID("DICTDB")) then
do:
   message s_NoPrivMsg "modify fields."
      view-as ALERT-BOX ERROR buttons Ok.
   return.
end.

/* Check some other conditions */
msg_text = "".
find x_File where x_File._File-Name = s_CurrTbl AND
     x_File._DB-recid = s_DbRecId AND
     (x_File._Owner = "PUB" OR x_File._Owner = "_FOREIGN").

/* The _numfld field is only updated at commit time so if dict is 
   dirty - count the number the slow way.
*/
if NOT s_DictDirty then
   NumFlds = x_File._numfld - 1.  
else
   for each _Field of x_File:
      NumFlds = NumFlds + 1.
   end.

if x_File._Db-lang >= {&TBLTYP_SQL} then
   msg_text = "You cannot change the order of {&PRO_DISPLAY_NAME}/SQL fields.".

if msg_text = "" then
   if x_File._Frozen then 
      msg_text = "The definitions for this table have been frozen.".

if msg_text = "" then
   if NumFlds = 0 then
      msg_text = "There are no fields in this table to be renumbered.".

IF SESSION:SCHEMA-CHANGE = "New Objects" THEN
   ASSIGN msg_text = 'You can not renumber fields when SESSION:SCHEMA-CHANGE = "New Objects".'.


if msg_text <> "" then
do:
   message msg_text view-as ALERT-BOX ERROR buttons OK.
   return.
end.   

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame fld_renum" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}

Fld_Renum_Start = 10.
Fld_Renum_Incr = 10.
Fld_Order = (if s_Order_By = {&ORDER_ALPHA} then "alphabetical"
      	       	     	      	       	    else "by order number").
/*display Fld_Order with frame fld_renum.*/

do ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE:
   update Fld_Renum_Start  
      	  Fld_Renum_Incr
       	  s_btn_Ok         
      	  s_btn_Cancel
      	  s_btn_Help
      with frame fld_renum.

   /* OK Processing is done in trigger */
end.

hide frame fld_renum.
return.





/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _savedom.p

Description:
   Save any changes the user made in the domain property window. 

Returns: "error" if the save is not complete for any reason, otherwise "".

Author: Laura Stern

Date Created: 07/15/92

----------------------------------------------------------------------------*/

/*------------------------------------------------------------------
   Comment out the whole thing until (if ever) we support domains)

&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/FLD/fldvar.i shared}


Define var oldname as char CASE-SENSITIVE NO-UNDO.
Define var newname as char CASE-SENSITIVE NO-UNDO.
Define var no_name as logical 	       	  NO-UNDO.

current-window = s_win_Dom.

run adedict/_blnknam.p
   (INPUT b_Field._Field-name:HANDLE in frame domprops,
    INPUT "domain", OUTPUT no_name).
if no_name then return "error".

oldname = b_Field._Field-Name.
newname = input frame domprops b_Field._Field-Name.

do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
   run adecomm/_setcurs.p ("WAIT").

   /* Triggers, validation and gateway have already been saved.  We
   	 just need to move main property values into buffer. */
   assign
      b_Field._Field-name = newname
      input frame domprops b_Field._Format
      input frame domprops b_Field._Initial
      input frame domprops b_Field._Label
      input frame domprops b_Field._Col-label
      input frame domprops b_Field._Mandatory
      input frame domprops b_Field._Decimals
      input frame domprops b_Field._Fld-case
      input frame domprops b_Field._Help
      input frame domprops b_Field._Desc.
   
   if oldname <> newname then
   do:
      /* Change name in list in browse window */
      {adedict/repname.i
         &OldName = oldname
         &NewName = newname
         &Curr    = s_CurrDom
      	 &Fill    = s_DomFill
         &List    = s_lst_Doms}
   end.

   {adedict/setdirty.i &Dirty = "true"}.
   display "Domain Modified" @ s_Status with frame domprops.
   run adecomm/_setcurs.p ("").
   return "".
end.

run adecomm/_setcurs.p ("").
return "error".
------------------------------------------------------------------*/
/*********************************************************************
* Copyright (C) 2006,2008 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _savefld.p

Description:
   Save any changes the user made in the field property window.

Returns: "error" if the save is not complete for any reason, otherwise "".

Author: Laura Stern

Date Created: 07/15/92

History:
    tomn    7/96    Added condition on assigment for _decmimals field to not
                    write the unknown value (?) to the database.  The idea 
                    being that this is the default value for this field, so it
                    should not change if it is never enabled (i.e., _decimals
                    is not appropriate for that data type), but in the case of
                    some foreign char fields where we store size information in
                    this field, we display a "?" on the screen instead, and we
                    will not be overwriting the size info with "?". 
    fernando 06/08/06 Added support for int64
    fernando 04/08/08 Remove time field for ORACLE if changing to datetime

----------------------------------------------------------------------------*/


&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/FLD/fldvar.i shared}
{adedict/capab.i}


Define var oldname  as char CASE-SENSITIVE NO-UNDO.
Define var newname  as char CASE-SENSITIVE NO-UNDO.
Define var oldorder as integer	       	   NO-UNDO.
Define var neworder as integer	       	   NO-UNDO.
Define var junk     as logical       	   NO-UNDO.
Define var no_name  as logical 	       	   NO-UNDO.
Define var remove   as logical 	       	   NO-UNDO.
Define var stat     as logical 	       	   NO-UNDO.
Define var num      as integer	       	   NO-UNDO.

DEFINE BUFFER tmpField FOR DICTDB._Field.

current-window = s_win_Fld.

run adedict/_blnknam.p
   (INPUT b_Field._Field-name:HANDLE in frame fldprops,
    INPUT "field", OUTPUT no_name).
if no_name then return "error".

run adedict/FLD/_valgate.p.
if RETURN-VALUE = "error" then return "error".

assign
   oldname  = b_Field._Field-Name
   newname  = input frame fldprops b_Field._Field-Name
   oldorder = b_Field._Order
   neworder = input frame fldprops b_Field._Order.

do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
   
   run adecomm/_setcurs.p ("WAIT").
   
   /* Triggers, validation and gateway have already been saved.  We
      just need to move main property values into buffer.  For data types
      check if changed first. Progress, normally won't let you change
      data types.
   */
   if b_Field._Data-type <> s_Fld_Protype THEN DO:
      /* if moving from date to datetime for an ORACLE schema, check if
         schema contains the time portion for the date field, and remove it.
      */
      IF s_DbCache_Type[s_DbCache_ix] = "ORACLE" AND
         (b_field._dtype = {&DTYPE_DATE} OR b_field._dtype = {&DTYPE_CHARACTER})
         AND s_Fld_Protype BEGINS "datetime" THEN DO:

         FIND FIRST tmpField WHERE tmpField._File-recid = 
             b_field._File-recid AND tmpField._For-name = b_field._For-name AND
             tmpField._For-type = "TIME" NO-ERROR.

         IF AVAILABLE tmpField THEN DO:
             /* remove it from the browse view */
            stat = s_lst_Flds:delete(tmpField._field-name) in frame browse.
            DELETE tmpField. /* delete it */
         END.
      END.

      b_Field._Data-type = s_Fld_Protype.
   END.
   if b_Field._For-type <> s_Fld_Gatetype then
      b_Field._For-type = s_Fld_Gatetype.

   assign
      b_Field._Field-name = newname
      input frame fldprops b_Field._Format
      input frame fldprops b_Field._Order
      input frame fldprops b_Field._Desc.

   /* For a Progress db, most fields are not valid for CLOB/BLOB fields */
   IF {adedict/ispro.i} AND (b_field._dtype = {&DTYPE_BLOB} OR  b_field._dtype = {&DTYPE_CLOB}) THEN DO:
      ASSIGN b_Field._Fld-Misc2[1] = input frame fldprops s_lob_size.
             b_Field._Width = s_lob_wdth.
   END.
   ELSE DO:
       IF b_field._dtype = {&DTYPE_INT64} OR b_Field._Data-type = "int64" THEN DO:
          IF DECIMAL(B_Field._Initial:SCREEN-VALUE) > 9223372036854775807 OR 
             DECIMAL(B_Field._Initial:SCREEN-VALUE) < -9223372036854775808 THEN DO:
              MESSAGE "Initial Value has value too large for int64"
                  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
              RUN adecomm/_setcurs.p ("").
              RETURN "error".
          END.
       END.

       ASSIGN
           input frame fldprops b_Field._Help
           input frame fldprops b_Field._Initial
           input frame fldprops b_Field._Label
           input frame fldprops b_Field._Col-label
           input frame fldprops b_Field._Mandatory
           input frame fldprops b_Field._Decimals
             when b_field._decimals:screen-value ne "?":u.
   END.

   if b_Field._Extent:visible in frame fldprops AND
      b_Field._Extent:sensitive in frame fldprops then
      assign input frame fldprops b_Field._Extent.

   if b_Field._Fld-case:visible in frame fldprops AND
      b_Field._Fld-case:sensitive in frame fldprops then
      assign input frame fldprops b_Field._Fld-case.

   /* For certain gateways we store the character length in the _Decimals
      field to support certain SQL operations.
   */
   if (s_Fld_TypeCode = {&DTYPE_CHARACTER} AND 
       INDEX(s_Fld_Capab, {&CAPAB_CHAR_LEN_IN_DEC}) <> 0) then
      b_Field._Decimals = b_Field._Fld-stlen.

   /* Determine if we have to remove the field's entry in the browse list
      to reposition it based on a new name or order#.  If there's only
      one field we don't have to bother.
   */
   remove = no.
   num = s_lst_Flds:NUM-ITEMS in frame browse.
   if oldname <> newname AND
      s_Order_By = {&ORDER_ALPHA} AND
      num > 1 then
      	 remove = yes.
   if NOT remove AND 
      oldorder <> neworder AND
      s_Order_By = {&ORDER_ORDER#} AND
      num > 1 then
      	 remove = yes.

   if remove then 
   do:
      stat = s_lst_Flds:delete(oldname) in frame browse.
      run adedict/FLD/_ptinlst.p (INPUT newname, INPUT neworder).
   end.
   else if oldname <> newname then
   do:
      /* Just change the name in place */
      {adedict/repname.i
	 &OldName = oldname
	 &NewName = newname
	 &Curr    = s_CurrFld
	 &Fill    = s_FldFill
	 &List    = s_lst_Flds}
   end.

   {adedict/setdirty.i &Dirty = "true"}.
   display "Field Modified" @ s_Status with frame fldprops.
   run adecomm/_setcurs.p ("").
   return "".
end.

run adecomm/_setcurs.p ("").
return "error".



/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _sqlwptr.p

Description: 
   In order to run the Adjust SQL Width browser from the Refresh_Props internal
   procedure in _objsel.p, this had to be created.  It automatically assumes 
   adedict directory, but since the browser code is shared between the gui and 
   tty dictionaries, it is located in prodict/gui.  So, this points to it.
   
Author: Mario Brunetti

Date Created: 05/11/99

-------------------------------------------------------------------------------*/

RUN prodict/gui/_guisqlw.p. 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _valgate.p

Description:
   Do some gateway related validation when the user tries to add or modify
   a field.

Returns: "error" if an error was detected or "ok" otherwise.

Author: Laura Stern

Date Created: 09/30/92 

----------------------------------------------------------------------------*/


&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adecomm/cbvar.i shared}
{adedict/uivar.i shared}
{adedict/FLD/fldvar.i shared}
{adedict/capab.i}

Define var decim as integer NO-UNDO.

if INDEX(s_Fld_Capab, {&CAPAB_OFFLEN_REQ}) <> 0 then
do:
   if b_Field._Fld-stoff = ? then
   do:
      message "You must enter a position (record offset) for this field." SKIP
      	      "Select the ""Data Server..."" button to enter a value."
      	      view-as ALERT-BOX ERROR buttons OK.
      return "error".
   end.

   if b_Field._Fld-stlen = 0 then
   do:
      message "Field length must be greater than 0." SKIP
      	      "Select the ""Data Server..."" button to enter a value."
      	      view-as ALERT-BOX ERROR buttons OK.
      return "error".
   end.
end.

if INDEX(s_Fld_Capab, {&CAPAB_DECIMALS_REQ}) <> 0 then
   decim = (if s_Adding then input frame newfld b_Field._Decimals
      	       	     	else input frame fldprops b_Field._Decimals).
   if decim = ? AND s_Fld_Typecode = {&DTYPE_DECIMAL} then
   do:
      message "You must enter a value for Decimals."
      	      view-as ALERT-BOX ERROR buttons OK.
      return "error".
   end.

/* in RMS the scale needs to be between -10 and 50 for Binary Types
 * and between -127 and 127 for other types.
 * We check for that in the DataServer window (adedict/FLD/_fldgate.p).
 * However, an User could have a field of an "other" type with a scale
 * outside the range for a binary-type, and try to change the type from
 * this "other" type to a binary type. We want to disallow to save this
 * field in such a case. So we check for that here
 * RDB might work the same, so we inlcude it in the if-condition
 *                                                     (hutegger 03/95)
 */
if  s_DbCache_Type[s_DbCache_ix] = "RMS"
 or s_DbCache_Type[s_DbCache_ix] = "RDB"
 then do:
  if ( b_Field._For-Scale <= -10 OR b_Field._For-Scale >= 50 )
   AND CAN-DO( "SBin1,SBin2,SBin4,SBin8"
             , b_Field._For-Type
             )
   then do:
     message
       "Scale must be between -10 and +50 for Scaled Unsigned types." skip
       "Choose the button ~"Data Server~" and adjust the scale." 
       view-as ALERT-BOX ERROR buttons OK.
     return "error".
     end.

   else if b_Field._For-Scale <= -127 OR b_Field._For-Scale >= 127
    then do:
     message
       "Scale must be between -127 and +127."                   skip
       "Choose the button ~"Data Server~" and adjust the scale."
       view-as ALERT-BOX ERROR buttons OK.
     return "error".
     end.
 
   end.
  
return "ok".



/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: dtwidth.i

Description:
   For gateways, the data type list is multi-column so we need to
   use fixed font in order to line up the columns.  This makes
   the string wider so we need to make the data type fill-in and
   list wider (especially for proportional spaced font).

Arguments:
   &Frame = name of frame, e.g., "Frame newfld"
   &Only1 = true if there will be no data type list (e.g. for properties
      	    when you can't change the type).

Author: Laura Stern

Date Created: 08/20/93 

----------------------------------------------------------------------------*/

if IsPro OR {&Only1} then 
   assign
      s_Fld_DType:font 	    in {&Frame} = ?
      s_lst_Fld_DType:font  in {&Frame} = ?
      s_Fld_DType:width     in {&Frame} = b_Field._Field-name:width in {&Frame} 
      s_lst_Fld_DType:width in {&Frame} = b_Field._Field-name:width in {&Frame}.
else
   assign
      s_Fld_DType:font 	    in {&Frame} = 0
      s_lst_Fld_DType:font  in {&Frame} = 0
      s_Fld_DType:width     in {&Frame} = 40
      s_lst_Fld_DType:width in {&Frame} = 40.
/*********************************************************************
* Copyright (C) 2006-2009 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: fdprop.i

Description:
   Set up the field/domain properties window so the user can view or modify
   the information on a field or domain.  Since this window is non-modal,
   we just do the set up here.  All triggers must be global.

   This is set up to work for both domains and fields so we don't have to
   maintain this code twice.

Argument:
   &Frame    = the frame name we are dealing with: either "frame fldprops"
      	       or "frame domprops".

   &ReadOnly = the read only flag to set.

Author: Laura Stern

Date Created: 02/05/92 
    Modified: 04/01/98 D. McMann Added display of _field-rpos
              01/31/03 D. McMann Added support for Blobs
              08/26/03 D. McMann Display of updated LOB fields 20030826-013
              06/08/06 fernando  Added support for int64
              06/13/07 fernando  Support for Clob for DataServers
              02/22/08 fernando Adjust display data type length for Dsrv schemas
              04/15/09 fernando Support for BLOB for MSS
----------------------------------------------------------------------------*/


{adedict/capab.i}

/* Reminder: Here's what's in user_env:

      user_env[11] - the long form of the gateway type (string), i.e., the
      	       	     type description.
      user_env[12] - list of gateway types (strings)
      user_env[13] - list of _Fld-stlen values for each data type (this is
      	       	     the storage length)
      user_env[14] - list of gateway type codes (_Fld-stdtype).
      user_env[15] - list of progress types that map to gateway types
      user_env[16] - the gateway type family - to indicate what data types
      	       	     can be modified to what other data types.
      user_env[17] - the default-format per foreign data-type.
*/

/*----------------------------Mainline code----------------------------------*/

Define var item_hidden  as logical NO-UNDO.
Define var name      	as char    NO-UNDO.
Define var record_id 	as recid   NO-UNDO.
Define var ispro     	as logical NO-UNDO. /* Is it a progress db? */
Define var junk         as logical NO-UNDO. /* for irrelevant output parm */
Define var gate_type    as char    NO-UNDO. /* gateway data type string */
Define var pro_type    	as char    NO-UNDO. /* Progress data type string */
Define var curr_type    as char    NO-UNDO. /* current "gate (pro)" value */
Define var family       as char    NO-UNDO. /* Data type family */ 
Define var type_ix      as integer NO-UNDO. /* Index of data type in list */
Define var num 	     	as integer NO-UNDO. /* Used for a loop index */
Define var len 	     	as integer NO-UNDO. /* Length of data type string */
Define var change_type  as logical NO-UNDO. /* Can user change data type? */
Define var change_ext   as logical NO-UNDO. /* Can user change extent? */

/* Run time layout for button area. This defines eff_frame_width.
   Since this is a shared frame we have to avoid doing this code 
   more than once.
*/
if frame fldprops:private-data <> "alive" then
do:
   /* okrun.i widens frame by 1 for margin */
   assign
      s_win_Fld:width = s_win_Fld:width + 1
      frame fldprops:private-data = "alive".

   {adecomm/okrun.i  
      &FRAME = "{&Frame}" 
      &BOX   = "s_rect_Btns"
      &OK    = "s_btn_Save" 
      &HELP  = "s_btn_Help"   
   }

   /* So Return doesn't hit default button in editor widget */
   b_Field._Desc:RETURN-INSERT in {&Frame} = yes.

   /* runtime adjustment of "Optional" title band to the width of the frame */
   s_Optional:width-chars in {&Frame} = eff_frame_width - ({&HFM_WID} * 2).
end.

ispro = {adedict/ispro.i}.

/* InView and InIndex and Order# aren't relevant for domains. Copy
   isn't relevant except for adding.
*/
assign
   item_hidden = (if s_CurrObj = {&OBJ_DOM} then yes else no)
   s_Fld_InIndex:hidden  in {&Frame} = item_hidden
   s_Fld_InView:hidden   in {&Frame} = item_hidden
   s_btn_Fld_Copy:hidden in {&Frame} = yes
   b_Field._Order:hidden in {&Frame} = item_hidden
   s_btn_Fld_Gateway:sensitive in {&Frame} = NOT ispro.

ASSIGN s_lob_size:HIDDEN IN {&FRAME} = YES
       s_lob_Area:HIDDEN IN {&FRAME} = YES
       s_btn_lob_Area:HIDDEN IN {&FRAME} = YES
       s_clob_cp:HIDDEN IN {&FRAME} = YES
       s_clob_col:HIDDEN IN {&FRAME} = YES
       s_btn_clob_cp:HIDDEN IN {&FRAME} = YES
       s_btn_clob_col:HIDDEN IN {&FRAME} = YES
       s_lst_lob_Area:HIDDEN IN {&FRAME} = YES
       s_lst_clob_cp :HIDDEN IN {&FRAME} = YES
       s_lst_clob_col:HIDDEN IN {&FRAME} = YES.

/* Get general field gateway capabilities */
run adedict/_capab.p (INPUT {&CAPAB_FLD}, OUTPUT s_Fld_Capab).

/* Read the current record data into the b_Field buffer. */
name = (if s_CurrObj = {&OBJ_FLD} then s_CurrFld else s_CurrDom).
record_id = (if s_CurrObj = {&OBJ_FLD} then s_TblRecId else s_DomRecId).
                                                             
find b_Field where b_Field._File-recid = record_id AND
       	       	   b_Field._Field-Name = name.

/* Determine if this field participates in an index or view definition. */
if s_CurrObj = {&OBJ_FLD} then
do:
   s_Fld_InIndex = can-find (FIRST _Index-field OF b_Field).
   s_Fld_InView = can-find (FIRST _View-ref where
      	       	     	    _View-ref._Ref-Table = s_CurrTbl AND
      	       	     	    _View-ref._Base-Col = b_Field._Field-name).
end.

if {&ReadOnly} = false then
   {&ReadOnly} = (s_DB_ReadOnly OR s_ReadOnly).

/* Initialize array flag.
   Set the original progress and gate types.  If user changes the data
   type, these will be updated.
*/
assign
   s_Fld_Array = (if b_Field._Extent > 0 then yes else no)
   s_Fld_Protype = b_Field._Data-type
   s_Fld_Gatetype = b_Field._For-type
   s_Fld_Typecode = b_Field._dtype 
   change_type = no.


/* Make sensitivity/label adjustments to fld-case and _Decimals based
   on data type chosen. */
run adedict/FLD/_dtcust.p (INPUT b_Field._Fld-case:HANDLE in {&Frame},
      	       	     	   INPUT b_Field._Decimals:HANDLE in {&Frame}).

/* for clob/blob fields, we hide the format and decimals and show some other specific
   fields.  For clob fields only, we hide label and col-label to show codepage and collation
   information
*/
IF ispro AND (b_field._dtype = {&DTYPE_BLOB} OR b_field._dtype = {&DTYPE_CLOB}) THEN DO:
   ASSIGN s_lob_size:HIDDEN IN {&FRAME} = NO
          s_lob_Area:HIDDEN IN {&FRAME} = NO
          b_Field._Decimals:HIDDEN IN {&FRAME} = YES
          b_Field._Format:HIDDEN IN {&FRAME} = YES
          s_btn_Fld_Format:HIDDEN IN {&FRAME} = YES.

  IF b_field._dtype = {&DTYPE_CLOB} THEN
     ASSIGN s_clob_cp:HIDDEN IN {&FRAME} = NO
            s_clob_col:HIDDEN IN {&FRAME} = NO
            b_Field._Label:HIDDEN IN {&FRAME} = YES
            b_Field._Col-label:HIDDEN IN {&FRAME} = YES.
  ELSE
     ASSIGN s_clob_cp:HIDDEN IN {&FRAME} = YES
            s_clob_col:HIDDEN IN {&FRAME} = YES
            b_Field._Label:HIDDEN IN {&FRAME} = NO
            b_Field._Col-label:HIDDEN IN {&FRAME} = NO.
END.
ELSE
   ASSIGN s_lob_size:HIDDEN IN {&FRAME} = YES
          s_lob_Area:HIDDEN IN {&FRAME} = YES
          b_Field._Decimals:HIDDEN IN {&FRAME} = NO
          b_Field._Format:HIDDEN IN {&FRAME} = NO
          s_btn_Fld_Format:HIDDEN IN {&FRAME} = NO.
   
/* For Progress db's, allow user to change an integer field to int64 by 
   displaying the button. But only for 10.1B and later dbs.
*/
IF ispro AND NOT is-pre-101b-db AND b_field._dtype = {&DTYPE_INTEGER} THEN DO:

    ASSIGN s_btn_toint64:HIDDEN IN {&FRAME} = NO
           s_btn_toint64:SENSITIVE IN {&FRAME} = YES.
END.
ELSE 
    ASSIGN s_btn_toint64:HIDDEN IN {&FRAME} = YES.

/* The CHANGE_DATA_TYPE capability indicates if any types are changeable
   from any other.  Even then, certain types cannot be changed.  We can only
   change between types of the same data type family.  If the family is
   0, then the type is an orphan and cannot be modified.

   First determine the user_env entry that matches the current type and
   compose the select list value "gatetype (protype)" - if non-progress.
*/
if NOT ispro then
do:
   /* if schema holder is read-only, Dsrv schema is also read-only */
   IF CAN-DO(DBRESTRICTIONS("DICTDB"), "Read-Only") THEN
      {&ReadOnly} = TRUE.

   /* Find the entry in the table which matches the current gatetype type */
   type_ix = LOOKUP(s_Fld_Gatetype, user_env[12]).

   /* The following is for Oracle backward compatability and for backends
      like ODBC:
      The old ora_typ scheme for numbers was 3 entries where gatetype/protype 
      were "Number/Decimal, Number/Integer, Number/Logical".  Now there are 
      actually separate gateway data types, 5 altogether: "Number/Decimal, 
      Decimal/Decimal Float/Decimal Integer/Integer, Logical/Logical.  
      Unfortunately, the old combo (e.g., Number/integer) still exists 
      in oracle databases and this does not match any current ora_typ table 
      combination.  So this code is to find the correct entry.  Match the 
      one with the same data type code # as "Number" but with the correct 
      progress type.  All these entries should be contiguous.
      There is also the case (currently only for odb) where the user can
      associate different progress types with the same gate type.  So
      as with the Oracle case, there are multiple entries where the data
      type code is the same (and in this case the gateway type is also
      the same) but the progress type is different.
   */
   if ENTRY(type_ix, user_env[15]) <> s_Fld_Protype then
   do:
      dtype_search:
      do type_ix = type_ix + 1 to NUM-ENTRIES(user_env[14]) while
      	 INTEGER(ENTRY(type_ix, user_env[14])) = b_Field._Fld-stdtype:

      	 if ENTRY(type_ix, user_env[15]) = s_Fld_Protype then
      	    leave dtype_search.
      end.
   end.
   /* Remember the current "gatetype (protype)" display value - used
      later to set selection.  
      Caution: Use user_env[15] value here instead of s_Fld_Protype just to 
      make sure we get the same case (upper/lower) as below so value set 
      in select-list works.
   */
   gate_type = ENTRY(type_ix, user_env[11]).  /* the long form */
   curr_type = STRING(gate_type, "x({&FOREIGN_DTYPE_DISPLAY})") + "(" + 
      	       ENTRY(type_ix, user_env[15]) + ")".
end.

if INDEX(s_Fld_Capab, {&CAPAB_CHANGE_DATA_TYPE}) <> 0 AND NOT {&ReadOnly} then
do:
   /* type_ix is based on For-Type and I know that Progress doesn't allow changing of 
      data types so I know this is valid here.  Get the data type family.
   */
   family = ENTRY(type_ix, user_env[16]).

   /* MSS doesn't allow varbinary(n) support for BLOB */
   IF family <> "0" AND s_DbCache_Type[s_DbCache_ix] = "MSS" THEN DO:
      IF CAN-DO("varbinary,longvarbinary",s_Fld_Gatetype) THEN DO:
         /* varbinary(max) reported as varbinary with zero precision by MSS native driver
            or as longvarchar for other drivers. But the schema pull sets precision
            to 32000 in the schema for the native driver case.
            We do not support varbinary(n) for blob support but (n) can only be
            a number between 1 and 8000 inclusive  for varbinary(n). 
            So let's check the varbinary(n) case.
            Also, if field has the filestream option set, we only support blob mapping.
         */
         IF (b_Field._Fld-misc2[4] = "filestream") OR 
            (b_Field._Fld-misc1[1] >= 1 AND b_Field._Fld-misc1[1] <= 8000) THEN 
             family = "0".
      END.
   END.

   if family <> "0" then
   do:
      assign
      	 change_type = yes
      	 s_lst_Fld_DType:list-items in {&Frame} = "".  /* clear the list */
     
      /* Look through the families - find the matching ones and add the
      	 corresponding data type to the combo list. 
      */
      do num = 1 to NUM-ENTRIES(user_env[16]):
      	 if family = ENTRY(num, user_env[16]) then
      	 do:
      	    /* The list entry has the format: "gatetype (pro type)". */
      	    assign
      	       gate_type = ENTRY(num, user_env[11])
      	       pro_type = ENTRY(num, user_env[15]).
      	  
               IF ( b_field._dtype <> {&DTYPE_RECID} AND pro_type = "RECID" AND
                                      s_DbCache_type[s_DbCache_ix] = "MSS" )  
               THEN NEXT. 
	         assign
	            s_Res = s_lst_Fld_DType:add-last(STRING(gate_type, "x({&FOREIGN_DTYPE_DISPLAY})") + 
      	       	     	      	              "(" + pro_type + ")")
      	       	       in {&Frame}.
      	 end.
      end.
	 
      num = s_lst_Fld_DType:num-items in frame fldprops.
      s_lst_Fld_DType:inner-lines in frame fldprops = 
      	 (if num <= 10 then num else 10).

      /* Adjust the data type fill-in and list: font and width. Have
      	 to do this before cbdrop which positions the drop button 
      */
      {adedict/FLD/dtwidth.i &Frame = "{&Frame}" &Only1 = "FALSE"}

      /* cbtdrop.i is included in edittrig.i because of non-modal-ness. */
      {adecomm/cbcdrop.i &Frame  = "{&Frame}"
		         &CBFill = "s_Fld_DType"
		         &CBList = "s_lst_Fld_DType"
		     	 &CBBtn  = "s_btn_Fld_DType"
		     	 &CBInit = "curr_type"}
   end.
end.

if NOT change_type then
do:
   /* Disable the data type fill-in and the combo box components since
      the data type is not modifiable. */
   assign
      s_Fld_DType:sensitive in {&Frame} = false
      s_btn_Fld_DType:visible in {&Frame} = false 
      s_lst_Fld_DType:visible in {&Frame} = false.

   if ispro then
      s_Fld_DType = s_Fld_Protype.
   else 
      s_Fld_DType = curr_type.
   s_Fld_DType:screen-value in {&Frame} = s_Fld_DType.

   /* Adjust the data type fill-in and list: font and width. */
   {adedict/FLD/dtwidth.i &Frame = "{&Frame}" &Only1 = "TRUE"}
end.

/* get some specific info for LOBs */
IF ispro AND (b_field._dtype = {&DTYPE_BLOB} OR  b_field._dtype = {&DTYPE_CLOB}) THEN DO:

    /* Find the storage object so that we can see which area the lob is stored
       in and then find the area to display the name to the user if record has
       been committed.  Else find area using number in _fld-stlen 
       _Fld-stlen holds the object number once the field is created by the Progress client 
    */
    IF b_field._Field-rpos <> ? THEN DO: /* if the field was commited */
        FIND _storageobject WHERE _Storageobject._Db-recid = s_DbRecId
                             AND _Storageobject._Object-type = 3
                             AND _Storageobject._Object-number = b_Field._Fld-stlen
                             NO-LOCK.
        FIND _Area WHERE _Area._Area-number = _StorageObject._Area-number NO-LOCK.
   END.
   ELSE
       FIND _Area WHERE _Area._Area-number =  b_Field._Fld-stlen NO-LOCK.

  ASSIGN s_lob_size = b_Field._Fld-Misc2[1]
         s_lob_wdth = b_Field._Width
         s_lob_Area  = _Area._Area-name.
  
  RELEASE _Area.
  RELEASE _storageobject.

  /* specific codepage/collation information for CLOBs */
  IF b_field._dtype = {&DTYPE_CLOB} THEN
     ASSIGN s_clob_cp = b_Field._Charset
            s_clob_col = b_Field._Collation.
END.

display  b_Field._Field-Name  b_Field._Mandatory
      	 b_Field._Format      
         b_Field._Label       WHEN b_field._dtype <> {&DTYPE_CLOB}
         b_Field._Col-label   WHEN b_field._dtype <> {&DTYPE_CLOB}
         s_Fld_Array
      	 b_Field._Initial     b_Field._Desc        
      	 b_Field._Help        s_Optional
      	 b_Field._Extent
         b_Field._Field-rpos
      	 b_Field._Order       when s_CurrObj = {&OBJ_FLD}
      	 b_Field._Decimals    when b_Field._dtype = {&DTYPE_DECIMAL}
      	 b_Field._Fld-case    when b_Field._dtype = {&DTYPE_CHARACTER} OR b_field._Dtype = {&DTYPE_CLOB}
      	 s_Fld_InIndex        when s_CurrObj = {&Obj_FLD}
      	 s_Fld_InView  	      when s_CurrObj = {&Obj_FLD}
   with {&Frame}.

IF (b_Field._Dtype = {&DTYPE_BLOB} OR b_Field._Dtype = {&DTYPE_CLOB}) AND NOT ispro  THEN
    DISPLAY b_field._Fld-case WITH {&Frame}.

IF ispro AND (b_field._dtype = {&DTYPE_BLOB} OR  b_field._dtype = {&DTYPE_CLOB}) THEN DO:
    DISPLAY s_lob_area s_lob_size WITH {&Frame}.
    
    ASSIGN b_Field._Format:HIDDEN IN {&Frame} = TRUE
           s_btn_Fld_Format:HIDDEN IN {&FRAME} = YES .
    
    IF b_field._dtype = {&DTYPE_CLOB} THEN
       DISPLAY s_clob_cp s_clob_col WITH {&Frame}.
END.


if {&ReadOnly} then
do:
   IF (b_Field._Dtype = {&DTYPE_BLOB} OR b_Field._Dtype = {&DTYPE_CLOB}) AND ispro THEN DO:
       DISABLE ALL WITH {&Frame}.
       ENABLE s_btn_close s_btn_Prev s_btn_Next WITH {&Frame} .
       APPLY "entry" TO s_btn_close IN {&Frame}.     
   END.
   ELSE DO:
     disable all except
	    s_btn_Fld_Triggers  
        s_btn_Fld_Validation
	    s_btn_Fld_ViewAs
	    s_btn_Fld_StringAttrs
	    s_btn_Close
	    s_btn_Prev
	    s_btn_Next
	    s_btn_Help
	  with {&Frame}.

     enable s_btn_Fld_Triggers 
	   s_btn_Fld_Validation    
	   s_btn_Fld_ViewAs        
	   s_btn_Fld_StringAttrs   
	   s_btn_Fld_Gateway       WHEN NOT ispro
	   s_btn_Close
	   s_btn_Prev
	   s_btn_Next
	   s_btn_Help
	   with {&Frame}.
   END.
end.
else do:
   find _File of b_field no-lock no-error.
   change_ext = (  b_Field._Extent > 0
            AND  (
                  ( INDEX(s_Fld_Capab, {&CAPAB_CHANGE_EXTENT}) <> 0
            AND     NOT s_Fld_InIndex
                  )
            OR    ( available _File
            AND     CAN-DO("PROCEDURE,FUNCTION,BUFFER",_File._For-type)
            AND     s_DbCache_Type[s_DbCache_ix] = "ORACLE"
                  )
                 )
                ).
   release _File.
   /* Desensitize explicitly in case they were enabled from a previous 
      iteration. */
   if NOT change_ext then
      assign
      	 s_Fld_Array:sensitive in {&Frame} = no
      	 b_Field._Extent:sensitive in {&Frame} = no.

   IF (b_Field._Dtype = {&DTYPE_BLOB} OR b_Field._Dtype = {&DTYPE_CLOB}) THEN DO:
       
     IF ispro THEN DO:

       DISABLE ALL EXCEPT 
              b_Field._Field-Name 
              b_Field._Order
              s_lob_size
              b_Field._Desc
       WITH {&Frame}.

       ENABLE b_Field._Field-Name 
              b_Field._Order     when s_CurrObj = {&OBJ_FLD} 
              b_Field._Desc
              s_lob_size
              b_field._Fld-case WHEN b_Field._Dtype = {&DTYPE_CLOB}
              s_btn_OK
              s_btn_Save
              s_btn_Close
              s_btn_Prev
              s_btn_Next
              s_btn_Help
              with {&Frame}.

       /* adjust s_lob_size tab order */
       ASSIGN s_Res = s_lob_size:move-after-tab-item
              (b_Field._Order:handle in {&Frame}) in {&Frame}.

       IF b_Field._Dtype = {&DTYPE_CLOB} THEN DO:
          IF b_field._Fld-case:SCREEN-VALUE IN {&Frame} <> STRING(b_Field._Fld-case) THEN
             ASSIGN b_field._Fld-case:SCREEN-VALUE IN {&Frame} = STRING(b_Field._Fld-case).
       END.

       APPLY "entry" to b_Field._Field-Name in {&Frame}.
     END.
     ELSE DO: /* DataServers */

         DISABLE all except
            s_btn_Close
    	    s_btn_Prev
    	    s_btn_Next
    	    s_btn_Help
    	  with {&Frame}.

         IF change_type THEN
            s_lst_Fld_DType:SENSITIVE = YES.

         ENABLE b_Field._Field-Name 
                s_Fld_DType	     when change_type 
                s_btn_Fld_DType    when change_type
                b_Field._Order     when s_CurrObj = {&OBJ_FLD} 
                b_Field._Desc
                s_btn_Fld_Gateway  WHEN NOT ispro
                s_btn_OK
          	    s_btn_Save
                s_btn_Close
                s_btn_Prev
                s_btn_Next
                s_btn_Help
                with {&Frame}.
     END.
     APPLY "entry" to b_Field._Field-Name in {&Frame}.
   END.
   ELSE DO:
    
   /* ENABLE effects the TAB order */
     enable b_Field._Field-Name 
            s_Fld_DType	     when change_type 
      	  s_btn_Fld_DType    when change_type
      	  b_Field._Format 
      	  s_btn_Fld_Format
      	  b_Field._Label
      	  b_Field._Col-label
      	  b_Field._Initial
      	  b_Field._Order     when s_CurrObj = {&OBJ_FLD} 
      	  b_Field._Desc
      	  b_Field._Help
      	  b_Field._Mandatory when INDEX(s_Fld_Capab, {&CAPAB_CHANGE_MANDATORY}) 
      	       	     	      	 > 0 
      	  s_Fld_Array        when change_ext
      	  b_Field._Extent    when change_ext 
      	  s_btn_Fld_Triggers
      	  s_btn_Fld_Validation
      	  s_btn_Fld_ViewAs
      	  s_btn_Fld_StringAttrs
      	  s_btn_Fld_Gateway  when NOT ispro
      	  s_btn_OK
      	  s_btn_Save
      	  s_btn_Close
      	  s_btn_Prev
      	  s_btn_Next
      	  s_btn_Help
      	  with {&Frame}.

   /* Now readjust tab orders for stuff not in the ENABLE list but
      which may in fact be sensitive.
   */
   if change_type then
      s_Res = s_lst_Fld_DType:move-after-tab-item
		  (s_btn_Fld_DType:handle in {&Frame}) in {&Frame}.
   assign
      s_Res = b_Field._Decimals:move-before-tab-item
		  (b_Field._Desc:handle in {&Frame}) in {&Frame}
      /* do this one to be sure we have a stable anchor for fld-case */
      s_Res = b_Field._Mandatory:move-after-tab-item 
		  (b_Field._Help:handle in {&Frame}) in {&Frame}
      s_Res = b_Field._Fld-case:move-after-tab-item
		  (b_Field._Mandatory:handle in {&Frame}) in {&Frame}
      .

  IF s_btn_toint64:SENSITIVE IN {&Frame} THEN
     s_Res = s_btn_toint64:MOVE-BEFORE-TAB-ITEM
            (b_Field._Format:handle in {&Frame}) in {&Frame}.

   apply "entry" to b_Field._Field-Name in {&Frame}.
   END.
end.
/*********************************************************************
* Copyright (C) 2006,2008 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: fldprop.f

Description:   
   This file contains the form for adding and editing the main field and
   domain properties.  It has the full set of properties.  Some properties
   may be relevant on display but not on add, for fields but not for
   domains.  In these cases, the form will be customized at run time by
   making the offending component(s) invisible.

Arguments:
   &frame_phrase - this should be a frame phrase for the frame that we want
                   to associate this form with. e.g., "frame foo OVERLAY".
 
Author: Laura Stern

Date Created: 02/04/92 
    Modified: 04/01/98 Added display of _field-rpos
              06/08/06 Support for int64
              08/25/08 Changing format for _Initial - OE00168292

----------------------------------------------------------------------------*/

&SCOPED-DEFINE TFM_WID 0.05
&SCOPED-DEFINE VM_WIDG 0.33

form
   SKIP({&TFM_WID})
   b_Field._Field-Name 	label "Field &Name"     colon 18 {&STDPH_FILL} SPACE(.3)
   s_btn_Fld_Copy                               
   SKIP({&VM_WID})

   s_Fld_DType          label "Data T&ype"      colon 18 {&STDPH_FILL} 
   s_btn_Fld_DType   
   s_btn_toint64        at row-of s_btn_Fld_DType col-of  s_Fld_DType + 30 /*col-of s_btn_Fld_DType   */
   SKIP({&VM_WIDG})

   s_Optional           no-label                at    2 
   SKIP(.2) 
   
   /* we will show either the Format or the area name (for lobs), so keep them at the same location */
   b_Field._Format      label "&Format"         colon 18 {&STDPH_FILL} 
                        format "x(48)"                                 SPACE(.3)
   s_btn_Fld_Format 
   
   s_lob_Area           LABEL "&Area"      AT col 18 ROW-OF b_Field._Format COLON-ALIGNED {&STDPH_FILL}
   s_btn_lob_Area
   SKIP({&VM_WID}) 

   /* we will show either the label or the code page (for clob), so keep them at the same location */
   b_Field._Label 	label "La&bel"          colon 18 {&STDPH_FILL}
                        format "x(48)"
                        
   s_clob_cp         LABEL "&Code Page"      AT col 18 ROW-OF b_Field._Label COLON-ALIGNED {&STDPH_FILL} s_btn_clob_cp
   SKIP({&VM_WID}) 
   
   /* we will show either the column-label or the collation (for clob), so keep them at the same location */
   b_Field._Col-label   label "Col&umn Label"   colon 18 {&STDPH_FILL}
                        format "x(48)"
   s_clob_col           LABEL "Colla&tion"   AT col 18 ROW-OF b_Field._Col-label COLON-ALIGNED {&STDPH_FILL} s_btn_clob_col                        
   SKIP({&VM_WID}) 

   b_Field._Initial     label "&Initial Value"  colon 18 {&STDPH_FILL}
                        format "x(100)" 
                        view-as fill-in size 48 by 1
   SKIP({&VM_WID}) 
   
   b_Field._Order	label "&Order #"        colon 18 {&STDPH_FILL}
                        format ">>>>9"          SPACE({&HM_WIDG})
   /* R10 is so if we change label to "Bit offset" it will work */
   b_Field._Decimals    label "Decimal&s":R10            {&STDPH_FILL}
   b_Field._Field-rpos  label "Position" colon 65 {&STDPH_FILL}
   
   /* we will show either the Decimals or the Max Size (for lobs), so keep them at the same location */
   s_lob_size             LABEL "&Max Size" AT COLUMN-OF b_Field._Decimals ROW-OF b_Field._Decimals {&STDPH_FILL}  
   
   SKIP({&VM_WID})

   b_Field._Desc        label "Descri&ption"    colon 18 {&STDPH_EDITOR}
                        view-as EDITOR SCROLLBAR-VERTICAL
                        SIZE 65 by 2
   SKIP({&VM_WID})

   b_Field._Help        label "He&lp Text"      colon 18 {&STDPH_FILL}
                        format "x(63)" 
                        view-as fill-in size 65 by 1
   SKIP(.2)

   b_Field._Mandatory   label "&Mandatory"      at    20
                        view-as TOGGLE-BOX      SPACE ({&HM_WIDG})
   b_Field._Fld-case    label "C&ase-Sensitive" 
                        view-as TOGGLE-BOX      SPACE ({&HM_WIDG})
   s_Fld_Array          label "E&xtent"        
                        view-as TOGGLE-BOX     
   b_Field._Extent	no-label                {&STDPH_FILL}
   SKIP({&VM_WIDG})

   s_btn_Fld_Triggers    	       	        at    2 SPACE({&HM_BTN})
   s_btn_Fld_Validation                                 SPACE({&HM_BTN})
   s_btn_Fld_ViewAs                                     SPACE({&HM_BTN})
   s_btn_Fld_StringAttrs                                SPACE({&HM_BTN})
   s_btn_Fld_Gateway                                     
   SKIP(.25)

   s_Status             NO-LABEL format "x(50)" at    2
                        view-as TEXT 

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = yes
      &OK     = s_btn_OK
      &CANCEL = {&apply_btn}
      &OTHER  = "{&other_btns}"
      &HELP   = s_btn_Help}

   s_Fld_InIndex        no-label view-as TEXT   at col 60 row 1.35
   SKIP
   s_Fld_InView         no-label view-as TEXT   at     60 

   /* Will be repositioned at run time */   
   s_lst_Fld_DType      NO-LABEL                at col 1 row 1
   s_lst_lob_Area       NO-LABEL                at col 1 row 1
   s_lst_clob_cp        NO-LABEL                at col 1 row 1
   s_lst_clob_col       NO-LABEL                at col 1 row 1
   
   with {&frame_phrase} SIDE-LABELS SCROLLABLE.

   /* OE00168292 -adjusting Initial width */
   b_Field._Initial:width-chars = b_Field._Col-label:width-chars.


/*********************************************************************
* Copyright (C) 2008 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: fldvar.i

Description:   
   Include file which defines the user interface components and related data
   for the main field editor window and its subsidiary dialog boxes.   
 
Arguments:
   {1} - this is either "new shared" or "shared".

Author: Laura Stern

Date Created: 02/04/92
    Modified: 06/18/98 Change DTYPE_RAW from 6 to 8 DLM
              05/24/06 fernando Added support int64 datatype
              06/08/06 fernando Added s_btn_toint64
              02/22/08 fernando Adjust display data type length for Dsrv schemas
 
----------------------------------------------------------------------------*/


Define {1} buffer   b_Field for _Field. 
Define {1} frame newfld.    /* for create field dialog box */
Define {1} frame fldprops.  /* field properties */


/* The main field properties - mostly we user the record buffer. 
   Note: We can't use the data type or format field of the record buffer 
   as part of a combo box - combo triggers would have to have
   "Using buffer" phrase.  So create a variable for it.
*/
Define button  s_btn_Fld_DType IMAGE-UP FILE "btn-down-arrow".
Define {1} var s_Fld_DType     as char format "x(34)" NO-UNDO.
Define {1} var s_lst_Fld_Dtype as char
   view-as SELECTION-LIST SINGLE  
   INNER-CHARS 32 INNER-LINES 9 SCROLLBAR-VERTICAL.

DEFINE BUTTON s_btn_toint64 LABEL "-> in&t64" {&STDPH_OKBTN}.

DEFINE BUTTON s_btn_lob_Area IMAGE-UP FILE "btn-down-arrow".

DEFINE {1} VARIABLE s_lob_Area AS CHARACTER FORMAT "x(32)" NO-UNDO.
DEFINE {1} VARIABLE s_lst_lob_Area AS CHARACTER
      VIEW-AS SELECTION-LIST SINGLE
      INNER-CHARS 32 INNER-LINES 5 SCROLLBAR-VERTICAL.

DEFINE BUTTON s_btn_clob_cp IMAGE-UP FILE "btn-down-arrow".

DEFINE {1} VARIABLE s_clob_cp AS CHARACTER FORMAT "x(32)" NO-UNDO.
DEFINE {1} VARIABLE s_lst_clob_cp AS CHARACTER
     VIEW-AS SELECTION-LIST SINGLE SORT
     INNER-CHARS 32 INNER-LINES 5 SCROLLBAR-VERTICAL.

DEFINE BUTTON s_btn_clob_col IMAGE-UP FILE "btn-down-arrow".

DEFINE {1} VARIABLE s_clob_col AS CHARACTER FORMAT "x(32)" NO-UNDO.
DEFINE {1} VARIABLE s_lst_clob_col AS CHARACTER
     VIEW-AS SELECTION-LIST SINGLE SORT
     INNER-CHARS 32 INNER-LINES 5 SCROLLBAR-VERTICAL.

DEFINE {1} VARIABLE s_lob_size AS CHARACTER FORMAT "x(10)" INITIAL "100M" NO-UNDO.

Define button s_btn_Fld_Format LABEL "&Examples..." SIZE 15 by 1.125.

Define {1} var s_Fld_Array     as logical NO-UNDO.
Define {1} var s_Fld_InIndex   as logical NO-UNDO 
   format "Member of an Index: yes/Member of an Index: no". 
Define {1} var s_Fld_InView    as logical NO-UNDO
   format "Member of a View: yes/Member of a View: no". 

Define button s_btn_Fld_Copy   label "Copy Fiel&d..." SIZE 17 by 1.125.

Define button s_btn_Fld_Triggers    label "Tri&ggers..."     SIZE 17 by 1.125.
Define button s_btn_Fld_Validation  label "Valida&tion..."   SIZE 17 by 1.125.
Define button s_btn_Fld_ViewAs      label "Vie&w-As..."      SIZE 17 by 1.125.
Define button s_btn_Fld_StringAttrs label "St&ring Attrs..." SIZE 17 by 1.125.
Define button s_btn_Fld_Gateway	  label "DataSer&ver..."   SIZE 17 by 1.125.

/* Variable and Frame definition for fields that are BLOBS */
Define button btn_Ok     label "OK"     {&STDPH_OKBTN} AUTO-GO.
Define button btn_Cancel label "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
Define rectangle rect_Btns {&STDPH_OKBOX}.
Define button    btn_Help label "&Help" {&STDPH_OKBTN}.

/*Variable to hold size of LOB fields in bytes */
DEFINE {1} VARIABLE s_lob_wdth       AS DECIMAL            NO-UNDO.

/* This is the form for the field properties and new field windows.    
*/
{adedict/FLD/fldprop.f  
   &frame_phrase = "frame fldprops NO-BOX
		    default-button s_btn_OK cancel-button s_btn_Close"
   &apply_btn    = s_btn_Save
   &other_btns   = "SPACE({&HM_DBTN}) s_btn_Close SPACE({&HM_DBTNG}) 
		    s_btn_Prev SPACE({&HM_DBTN}) s_btn_Next"
}

{adedict/FLD/fldprop.f  
   &frame_phrase = "frame newfld view-as dialog-box TITLE ""Create Field""
      	       	    default-button s_btn_Add cancel-button s_btn_Done"
   &apply_btn    = s_btn_Add
   &other_btns   = "SPACE({&HM_DBTN}) s_btn_Done"
}

 
/* Variables to save data type info. */
Define {1} var s_Fld_Gatetype as char  	 NO-UNDO.  /* gate dtype short string */
Define {1} var s_Fld_Protype  as char  	 NO-UNDO.  /* pro dtype string */
Define {1} var s_Fld_Typecode as integer NO-UNDO.  /* Data type integer code */	

/* Field capabilities to handle gateways properly. */
Define {1} var s_Fld_Capab as char NO-UNDO.

/* Symbolic constants for dtype values. */
&global-define 	  DTYPE_CHARACTER   1
&global-define 	  DTYPE_DATE  	    2
&global-define 	  DTYPE_LOGICAL     3
&global-define 	  DTYPE_INTEGER	    4
&global-define 	  DTYPE_DECIMAL	    5
&global-define 	  DTYPE_RAW   	    8
&global-define 	  DTYPE_RECID 	    7
&global-define 	  DTYPE_BLOB       18
&global-define 	  DTYPE_CLOB       19 
&global-define 	  DTYPE_XLOB       20 
&global-define 	  DTYPE_DATETM     34
&global-define 	  DTYPE_DATETMTZ   40  
&global-define 	  DTYPE_INT64	   41

/* adjusting of the InView and InIndex fields */
do with frame fldprops:
  assign
    s_Fld_InIndex:x = s_btn_Fld_Gateway:x
                    + s_btn_Fld_Gateway:width-pixels
                    - s_Fld_InIndex:width-pixels
    s_Fld_InView:x  = s_btn_Fld_Gateway:x
                    + s_btn_Fld_Gateway:width-pixels
                    - s_Fld_InView:width-pixels.
  end.
do with frame newfld:
  assign
    s_Fld_InIndex:x = s_btn_Fld_Gateway:x
                    + s_btn_Fld_Gateway:width-pixels
                    - s_Fld_InIndex:width-pixels
    s_Fld_InView:x  = s_btn_Fld_Gateway:x
                    + s_btn_Fld_Gateway:width-pixels
                    - s_Fld_InView:width-pixels.
  end.


/* defines the length of the foreign data type string when concatenating the OE data type
   for display purposes, so that the OE types are all aligned.
*/
&global-define 	  FOREIGN_DTYPE_DISPLAY   16


/**********************************************************************
* Copyright (C) 2006,2008-2009 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

/*----------------------------------------------------------------------------

File: setdflts.i

Description:
   Set default values based on the chosen data type.

Arguments:
   &Frame = the frame name, e.g., "frame newtbl".


IMPORTANT: Do not change the b_Field buffer.  All changes must be made to
   widgets directly or to temporary variables.  Otherwise our SAVE strategy
   is messed up.

/* Reminder: Here's what's in user_env:

      user_env[11] - the long form of the gateway type (string), i.e., the
      	       	     type description.
      user_env[12] - list of gateway types (strings)
      user_env[13] - list of _Fld-stlen values for each data type (this is
      	       	     the storage length)
      user_env[14] - list of gateway type codes (_Fld-stdtype).
      user_env[15] - list of progress types that map to gateway types
      user_env[16] - the gateway type family - to indicate what data types
      	       	     can be modified to what other data types.
      user_env[17] - the default-format per foreign data-type.
*/

Author: Laura Stern

Date Created: 09/24/92 
     History: 06/06/02 D. McMann Added check for timestamp's initial value.
              01/31/03 D. McMann Added support for lobs
              07/01/03 D. McMann Added support for DATETIME and DATETIME-TZ
              05/19/04 K. McIntosh Added case for RAW fields to set initial value to ""
              05/24/06 fernando    Added support for int64 fields
              02/22/08 fernando    Adjust display data type length for Dsrv schemas
              04/15/09 fernando    Support for BLOB for MSS

----------------------------------------------------------------------------*/


Define var type_idx  as integer  NO-UNDO.  /* index into datatypes list */
Define var junk      as logical  NO-UNDO.  /* output parm we don't care about */
Define var fmt       as char     NO-UNDO.
Define var len       as integer  NO-UNDO.  /* stlen */

DEFINE VAR lobMode   AS INTEGER  NO-UNDO. /*1 = from lob, 2 = to lob */

&IF "{&FRAME}" = "frame fldprops" &THEN
IF NOT {adedict/ispro.i} THEN DO:
    IF s_Fld_Typecode = {&DTYPE_BLOB} THEN
        lobMode = 1.
    ELSE IF INDEX (s_Fld_DType:SCREEN-VALUE IN FRAME fldprops, "BLOB") > 0 THEN
        lobMode = 2.             
END.

&ENDIF

s_Fld_DType = s_Fld_DType:screen-value in {&Frame}.

if {adedict/ispro.i} then
   assign
      s_Fld_Protype = s_Fld_DType
      s_Fld_Gatetype = ?.
else do: 
   /* Set gateway defaults including, the progress data type that
      the gateway type maps to.  See description of user_env at 
      top of file.
   */

   assign
      /* Use s_Fld_Gatetype temporarily to find the correct
      	 user_env entry.  It will be reset below.  We can't just
      	 do a lookup of s_Fld_DType in the data type select list
      	 to get the index because for properties the select list
      	 may not have the full complement of types.
      */
      s_Fld_Gatetype = TRIM(SUBSTR(s_Fld_DType, 1, {&FOREIGN_DTYPE_DISPLAY},"character")) /* the long version */
      type_idx = LOOKUP(s_Fld_Gatetype, user_env[11])
      s_Fld_Protype = TRIM(SUBSTR(s_Fld_DType, {&FOREIGN_DTYPE_DISPLAY} + 2,-1,"character"))
      /* Remove the trailing parenthesis */
      s_Fld_Protype = SUBSTR(s_Fld_Protype,1,LENGTH(s_Fld_Protype,"character") - 1,"character").

   /* Make sure we have the right user_env entry.  There may be more than
      one with this gate type description.  Find the one where the pro
      type matches as well.
   */
   do while ENTRY(type_idx, user_env[15]) <> s_Fld_Protype:
      type_idx = type_idx + 1.
   end.

   /* Set foreign type code and length from cached gateway info. 
      If stlen is already > 0, and the len in the table = 0, meaning
      the length is not strictly dictated by the type, don't
      overwrite the non-zero value with zero.
   */
   b_Field._Fld-stdtype = INTEGER(ENTRY(type_idx, user_env[14])).
   len = INTEGER(ENTRY(type_idx, user_env[13])).
   if NOT s_Fld_InIndex
    AND ( b_Field._Fld-stlen = ? OR len > 0 ) then
      b_Field._Fld-stlen = len.

      /* Set data types for save later and also so we can get the 
   	 format - the one piece of info we have not got in 
   	 user_env array. 
      */
      s_Fld_Gatetype = ENTRY(type_idx, user_env[12]). /* the short version */
end.

/* Set the underlying progress type code whether we are dealing with
   Progress or other gateway. */
case s_Fld_Protype:
   when "Character"    then s_Fld_Typecode = {&DTYPE_CHARACTER}.
   when "Date"	       then s_Fld_Typecode = {&DTYPE_DATE}.
   when "Logical"      then s_Fld_Typecode = {&DTYPE_LOGICAL}.
   when "Integer"      then s_Fld_Typecode = {&DTYPE_INTEGER}.
   when "Int64"        then s_Fld_Typecode = {&DTYPE_INT64}.
   when "Decimal"      then s_Fld_Typecode = {&DTYPE_DECIMAL}.
   when "RECID"	       then s_Fld_Typecode = {&DTYPE_RECID}.
   when "RAW"          then s_Fld_Typecode = {&DTYPE_RAW}.
   when "BLOB"         then s_Fld_Typecode = {&DTYPE_BLOB}.   
   WHEN "CLOB"         THEN s_Fld_Typecode = {&DTYPE_CLOB}. 
   WHEN "XLOB"         THEN s_Fld_Typecode = {&DTYPE_XLOB}.
   WHEN "DATETIME"     THEN s_Fld_Typecode = {&DTYPE_DATETM}.
   WHEN "DATETIME-TZ"  THEN s_Fld_Typecode = {&DTYPE_DATETMTZ}.
end.

/* Set format default based on data type.  This will also set initial
   value if data type is logical. */
run adedict/FLD/_dfltfmt.p 
   (INPUT b_Field._Format:HANDLE in {&Frame},
    INPUT b_Field._Initial:HANDLE in {&Frame},
    INPUT b_Field._Fld-stlen,
    INPUT true). 

/* Make visibility/label adjustments to fld-case and _Decimals based
   on data type chosen. */
run adedict/FLD/_dtcust.p (INPUT b_Field._Fld-case:HANDLE in {&Frame},
      	       	     	   INPUT b_Field._Decimals:HANDLE in {&Frame}).

/* Set other defaults. */
case s_Fld_Typecode:
   when {&DTYPE_CHARACTER} THEN DO: 
     /* OE00169243 - date/Timestamp foreign fields need ? as initial value */
     IF s_Fld_Gatetype BEGINS "Timestamp" OR 
        s_Fld_Gatetype = "date" THEN
        ASSIGN b_Field._Initial:screen-value in {&Frame} = ?. 
     ELSE
        ASSIGN b_Field._Initial:screen-value in {&Frame} = "".
   END.
   /* DTYPE_LOGICAL - Initial value is the only thing to set and it 
      has been done in _dfltfmt.p */
   when {&DTYPE_LOGICAL} then .
      
   when {&DTYPE_INTEGER} OR WHEN {&DTYPE_INT64} then
   do:
      assign
         b_Field._Initial:screen-value in {&Frame} = "0".
      if s_Fld_Gatetype = "Bits" then
      	 b_Field._Decimals:screen-value in {&Frame} = "0".
   end.      	 
   when {&DTYPE_DECIMAL} then
      assign
         b_Field._Initial:screen-value in {&Frame} = "0"
         b_Field._Decimals:screen-value in {&Frame} = "2".
   WHEN {&DTYPE_RAW} THEN
      ASSIGN
         b_Field._Initial:SCREEN-VALUE IN {&Frame} = "".
   WHEN {&DTYPE_DATE} OR WHEN {&DTYPE_DATETM} OR WHEN {&DTYPE_DATETMTZ} THEN DO:
       ASSIGN b_Field._Initial:screen-value in {&Frame} = ?.

       /* if Dataservers, and changing from date/datetime/tz, keep initial value
          as today/now
       */
       IF (s_Fld_Gatetype BEGINS "Timestamp" OR s_Fld_Gatetype = "date") AND 
           CAN-DO("TODAY,NOW", UPPER(b_Field._Initial)) THEN DO:
           IF s_Fld_Typecode = {&DTYPE_DATE} THEN
              ASSIGN b_Field._Initial:screen-value in {&Frame} = "TODAY".
           ELSE
              ASSIGN b_Field._Initial:screen-value in {&Frame} = "NOW".
       END.
   END.
   otherwise
      assign
	 b_Field._Initial:screen-value in {&Frame} = ?.
end.

&IF "{&FRAME}" = "frame fldprops" &THEN

/* handle to/from BLOB type change */
IF lobMode > 0 THEN DO WITH {&FRAME}:
    
    /* first leave format alone */
    b_Field._Format:SCREEN-VALUE = b_Field._Format.

    IF lobMode = 2 /* TO LOB */ THEN DO:
    
      IF s_Fld_array:SCREEN-VALUE = "yes" THEN
         ASSIGN s_Fld_array:SCREEN-VALUE = "no".
      IF b_field._Mandatory:SCREEN-VALUE = "yes" THEN
         ASSIGN b_field._Mandatory:SCREEN-VALUE = "no".

      /* disable all the fields not applicable to LOBs */
      ASSIGN b_field._Mandatory:SENSITIVE = NO
             s_Fld_array:SENSITIVE = NO
             b_Field._Format:SENSITIVE = FALSE
             s_btn_Fld_ViewAs:SENSITIVE = FALSE
             s_btn_Fld_Validation:SENSITIVE = FALSE
             s_btn_Fld_Triggers:SENSITIVE = FALSE
             s_btn_Fld_StringAttrs:SENSITIVE = FALSE
             b_Field._Label:SENSITIVE = FALSE  	    
             b_Field._Col-label:SENSITIVE = FALSE   
             b_Field._Initial:SENSITIVE = FALSE
             b_Field._Help:SENSITIVE = FALSE 
             b_Field._Mandatory:SENSITIVE = FALSE
             s_Fld_Array:SENSITIVE = FALSE.  
    END.
    ELSE DO: /* FROM LOB */

      /* make sure initial is the unknown value for varbinary foreign type */
      IF b_Field._Initial:SCREEN-VALUE = "" THEN DO:
        IF index(s_Fld_Gatetype, "varbinary") > 0 THEN
            b_Field._Initial:SCREEN-VALUE = ?.
      END.

      /* not a LOB field, enable all the fields except for the ones specific
        for LOBs
      */
      ASSIGN b_field._Mandatory:SENSITIVE = YES
             b_field._Fld-case:SENSITIVE = YES
             s_Fld_array:SENSITIVE = YES
             b_Field._Format:SENSITIVE = YES
             s_btn_Fld_ViewAs:SENSITIVE = FALSE
             s_btn_Fld_ViewAs:SENSITIVE = TRUE
             s_btn_Fld_Validation:SENSITIVE = TRUE
             s_btn_Fld_Triggers:SENSITIVE = TRUE
             s_btn_Fld_StringAttrs:SENSITIVE = TRUE
             b_Field._Label:SENSITIVE = TRUE  	    
             b_Field._Col-label:SENSITIVE = TRUE   
             b_Field._Initial:SENSITIVE = TRUE
             b_Field._Help:SENSITIVE = TRUE 
             b_Field._Mandatory:SENSITIVE = TRUE
             s_Fld_Array:SENSITIVE = TRUE.  

      /* restore the values from the record */
      ASSIGN
             b_field._Mandatory:SCREEN-VALUE = STRING(b_field._Mandatory)
             b_field._Fld-case:SCREEN-VALUE = STRING(b_field._Fld-case)
             b_Field._Format:SCREEN-VALUE = b_field._Format
             s_Fld_Array = (if b_Field._Extent > 0 then yes else no).
    END.
END.
&ENDIF
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: blobvar.i

Description:   
   Include file which defines the user interface components and related data
   for the lob fields editor window and its subsidiary dialog boxes.   
 
Arguments:
   {1} - this is either "new shared" or "shared".

Author: Donna L. McMann

Date Created: 01/31/03
     History: 08/27/03 Changed Size Label
              09/03/03 Changed blob-size format 20030829-039
----------------------------------------------------------------------------*/

DEFINE {1} VARIABLE blob-size AS CHARACTER FORMAT "x(10)" NO-UNDO.
DEFINE {1} VARIABLE wdth      AS DECIMAL                  NO-UNDO.  
DEFINE {1} VARIABLE size-type AS CHARACTER FORMAT "x"     NO-UNDO.

DEFINE {1} FRAME bfldprop.

&SCOPED-DEFINE VM_WIDG 0.33


FORM
  SKIP({&VM_WID})  
  b_Field._Field-name LABEL "&Field Name" colon 18 {&STDPH_FILL}
   SKIP({&VM_WID})
  s_Blob_Area LABEL "Area" COLON 18 {&STDPH_FILL}
   SKIP({&VM_WID})
  blob-size LABEL "&Max Size" COLON 18 {&STDPH_FILL}
   SKIP({&VM_WID})
  b_Field._Order label "&Order #"        colon 18 {&STDPH_FILL}
    SKIP({&VM_WID})

  {adecomm/okform.i
      &BOX = "rect_btns"
      &STATUS = no
      &OK     = btn_OK
      &CANCEL = btn_Cancel
      &HELP   = btn_Help
   }
  with FRAME bfldprop 
  VIEW-AS DIALOG-BOX THREE-D  
  SIDE-LABELS ROW 5 COLUMN 5 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
   TITLE "Blob Field Attributes".
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: blobvar.i

Description:   
   Include file which defines the user interface components and related data
   for the lob fields editor window and its subsidiary dialog boxes.   
 
Arguments:
   {1} - this is either "new shared" or "shared".

Author: Donna L. McMann

Date Created: 01/31/03
     History: 08/27/03 Changed Size label
              09/03/03 Change clob-size format 20030829-039
  
----------------------------------------------------------------------------*/

DEFINE {1} VARIABLE clob-size AS CHARACTER FORMAT "x(10)" NO-UNDO.
DEFINE {1} VARIABLE wdth      AS DECIMAL                  NO-UNDO.  
DEFINE {1} VARIABLE size-type AS CHARACTER FORMAT "x"     NO-UNDO.

DEFINE {1} FRAME cfldprop.

&SCOPED-DEFINE VM_WIDG 0.33


FORM
  SKIP({&VM_WID})  
  b_Field._Field-name LABEL "&Field Name" colon 18 {&STDPH_FILL}
   SKIP({&VM_WID})
  s_clob_Area LABEL "Area" COLON 18 {&STDPH_FILL}
   SKIP({&VM_WID})
  clob-size LABEL "&Max Size" COLON 18 {&STDPH_FILL}
   SKIP({&VM_WID})
  b_Field._Order label "&Order #"        colon 18 {&STDPH_FILL}
    SKIP({&VM_WID})
  b_Field._Fld-case LABEL "Case &Sensitive" COLON 18 {&STDPH_FILL}
    SKIP({&VM_WID})
  b_Field._Charset LABEL "Code Page" COLON 18 {&STDPH_FILL}
    SKIP({&VM_WID})
  b_Field._Collation LABEL "Collation" COLON 18 {&STDPH_FILL}
    SKIP({&VM_WID})

  {adecomm/okform.i
      &BOX = "rect_btns"
      &STATUS = no
      &OK     = btn_OK
      &CANCEL = btn_Cancel
      &HELP   = btn_Help
   }
  with FRAME cfldprop 
  VIEW-AS DIALOG-BOX THREE-D  
  SIDE-LABELS ROW 5 COLUMN 5 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
   TITLE "Clob Field Attributes".
/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
  File: adedict/FLD/lob-misc.i

  Description: Include with triggers for clob / blob fields used by the
               field properties dialogs (_newfld.p and _dcttran.p)
               
  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Fernando de Souza

  Created: August 10, 2005
  History:
  
------------------------------------------------------------------------*/

&SCOPED-DEFINE CTYPE (IF iType = 1 THEN "Blob" ELSE "Clob")

DEFINE VARIABLE bnum       AS INTEGER            NO-UNDO.
DEFINE VARIABLE hldcp      AS CHARACTER          NO-UNDO.
DEFINE VARIABLE i          AS INTEGER            NO-UNDO.


ON LEAVE OF s_lob_size IN {&Frame} 
DO:
DEFINE VARIABLE cType     AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE iType     AS INTEGER                   NO-UNDO.
DEFINE VARIABLE size-type AS CHARACTER FORMAT "x"      NO-UNDO.

  ASSIGN cType = s_Fld_DType:SCREEN-VALUE IN {&FRAME}
         iType = (IF cType = "BLOB" THEN 1 ELSE 2)
         s_lob_size = CAPS(INPUT {&Frame} s_lob_size).

  IF NOT isNumeric(SUBSTRING(s_lob_size,1,1)) THEN DO:
    MESSAGE {&CTYPE} " field size must begin with a numeric character!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    
    s_lob_size:SCREEN-VALUE IN {&Frame} = "100M".
    
    RETURN NO-APPLY.
  END.
  ELSE IF badFormat(ctype,"s_lob_size",s_lob_size) THEN DO:
    MESSAGE {&CTYPE} " field size contains invalid characters!" SKIP(1)
            "Please enter a numeric value followed by one of" SKIP
            "the following alphabetic values:" SKIP(1) 
            "B = Bytes" SKIP
            "K or KB = Kilobytes" SKIP
            "M or MB = Megabytes" SKIP
            "G or GB = Gigabytes" SKIP
       VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    
    s_lob_size:SCREEN-VALUE IN {&Frame} = "100M".
    
    RETURN NO-APPLY.
  END.
  IF INDEX(s_lob_size, "K") <> 0 THEN
    ASSIGN size-type = "K".
  ELSE IF INDEX(s_lob_size, "M") <> 0 THEN
    ASSIGN size-type = "M".
  ELSE IF INDEX(s_lob_size, "G") <> 0 THEN
    ASSIGN size-type = "G".
  ELSE IF INDEX(s_lob_size, "B") <> 0 THEN
    ASSIGN size-type = "B".
  ELSE IF INDEX("ACDEFHIJLNOPQRSTUVWXYZ", SUBSTRING(s_lob_size, LENGTH(s_lob_size), 1)) <> 0 THEN DO:
    MESSAGE "Size of " (IF iType = 1 THEN "blob" ELSE "clob") " must be expressed as #B, #K, #M, or #G"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    s_lob_size:SCREEN-VALUE IN {&FRAME} = "100M".
    RETURN NO-APPLY.
  END.    
  ELSE 
    ASSIGN size-type = "B"
           s_lob_size = s_lob_size + "B"
           s_lob_size:SCREEN-VALUE IN {&FRAME} = s_lob_size.
   
  CASE size-type:
    WHEN "K" THEN DO:
        ASSIGN s_lob_wdth = INTEGER(TRIM(SUBSTRING(s_lob_size, 1, (INDEX(s_lob_size, "K") - 1)))).
        ASSIGN s_lob_wdth = (s_lob_wdth * 1024).
    END.
    WHEN "M" THEN DO:
        ASSIGN s_lob_wdth = INTEGER(TRIM(SUBSTRING(s_lob_size, 1, (INDEX(s_lob_size, "M") - 1)))).
        ASSIGN s_lob_wdth = (s_lob_wdth * (1024 * 1024)).
    END.
    WHEN "G" THEN
        ASSIGN s_lob_wdth = INTEGER(TRIM(SUBSTRING(s_lob_size, 1, (INDEX(s_lob_size, "G") - 1))))
               s_lob_wdth = (s_lob_wdth * (1024 * 1024 * 1024) - 1).
    OTHERWISE
        ASSIGN s_lob_wdth = INTEGER(TRIM(SUBSTRING(s_lob_size, 1, (INDEX(s_lob_size, "B") - 1)))). 
  END CASE.

  IF s_lob_wdth < 1 OR s_lob_wdth > 1073741823 THEN DO:
    MESSAGE "Size of " {&CTYPE} " must be between 1B and 1G" SKIP
               "The default value is 100M" SKIP
           VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        /* Set size to default 1Mb */
       s_lob_size:SCREEN-VALUE IN {&FRAME} = "100M".
    RETURN NO-APPLY.
  END.
END.

/* When code page changes, we need to redo the collations that belong to that
   code page.  adecomm/cbtdrop.i applys U1 to this variable.
*/   

ON "U1" OF s_clob_cp IN {&Frame}
DO:
    IF s_clob_cp:SCREEN-VALUE <> "*Use DB Code Page" THEN DO:
      ASSIGN hldcp = GET-COLLATIONS(s_clob_cp:SCREEN-VALUE)
             s_clob_cp = s_clob_cp:SCREEN-VALUE.
         
      DO i = 1 TO NUM-ENTRIES(hldcp):
        IF i = 1 THEN
          ASSIGN s_clob_col = ENTRY(i, hldcp)
                 s_clob_col:SCREEN-VALUE = ENTRY(i, hldcp).
          s_res = s_lst_clob_col:ADD-LAST(ENTRY(i, hldcp)) IN {&Frame}.
      END.
    END.
    ELSE 
      ASSIGN s_clob_col = DICTDB._DB._Db-coll-name
             s_lst_clob_col:LIST-ITEMS IN {&Frame} = ""
             s_res = s_lst_clob_col:ADD-FIRST("*Use DB Collation") IN {&Frame}.
    RETURN.
END.

ON LEAVE OF s_clob_cp IN {&Frame} DO:

  ASSIGN s_lst_clob_col:LIST-ITEMS IN {&Frame} = "".
  IF s_clob_cp:SCREEN-VALUE <> "*Use DB Code Page" THEN DO:
    ASSIGN hldcp = GET-COLLATIONS(s_clob_cp:SCREEN-VALUE)
           s_clob_cp = s_clob_cp:SCREEN-VALUE.
         
    DO i = 1 TO NUM-ENTRIES(hldcp):
      IF i = 1 THEN
        ASSIGN s_clob_col = ENTRY(i, hldcp)
               s_clob_col:SCREEN-VALUE = ENTRY(i, hldcp).
        s_res = s_lst_clob_col:ADD-LAST(ENTRY(i, hldcp)) IN {&Frame}.
    END.
  END.
  ELSE DO:
    ASSIGN s_clob_col = DICTDB._DB._Db-coll-name
       s_lst_clob_col:LIST-ITEMS IN {&Frame} = ""
       s_res = s_lst_clob_col:ADD-FIRST("*Use DB Collation") IN {&Frame}
       s_clob_col:SCREEN-VALUE IN {&Frame} = "*Use DB Collation" .
     
  END.
  RETURN.
END.
/*********************************************************************
* Copyright (C) 2006 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _fldint64.p

Description:   
   Display and handle the int->int64 change confirmation dialog box.

Returns: "mod" if user OK'ed change
      	 "" if user Cancels.

Author: Fernando de Souza
                      
Date Created: 06/08/06

Modified:

----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES

{adedict/dictvar.i shared}
{adedict/uivar.i shared}
DEFINE NEW GLOBAL SHARED VARIABLE l_show AS LOGICAL NO-UNDO INIT NO
                                             VIEW-AS TOGGLE-BOX.

DEFINE BUTTON b_yes LABEL "Yes" {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON b_no LABEL "No"   {&STDPH_OKBTN} AUTO-ENDKEY.

Define var retval as char NO-UNDO init "". /* return value */

FORM
   SKIP({&TFM_WID})
   "If you change this field's data type to int64,  you will not be able to":t71  at  3 
      	       	    view-as TEXT 
   SKIP
   "change the data type back to integer after you commit the changes.":t70  at  3 
      	       	    view-as TEXT 
   SKIP
   "To revert this change back, you will need to dump/load this table.":t72  at  3 
                      view-as TEXT 
   SKIP(.3)
   "Do you really want to change this field's data type?"  at  3 
                      view-as TEXT 
   SKIP(.5)
   l_show LABEL "&Don't show me this again (for this session)" AT 3
 
   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = b_yes
      &CANCEL = b_no
      &HELP   = s_btn_Help
      }
   with frame confirmation
        DEFAULT-BUTTON b_yes CANCEL-BUTTON b_no
        NO-LABELS  CENTERED
        view-as DIALOG-BOX TITLE "Confirmation of data type change".

/*------------------------------Trigger Code---------------------------------*/

/*-----WINDOW-CLOSE-----*/
on window-close of frame confirmation
   apply "END-ERROR" to frame confirmation.

/*----- SELECTION of OK BUTTON or GO -----*/
/*
on GO of frame confirmation	   /* or OK due to AUTO-GO */
do:
   retval = "mod".
end.
*/

/*----- HELP -----*/

on HELP of frame confirmation OR choose of s_btn_Help in frame confirmation
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Field_Properties_Window}, ?).

/*------------------------------Mainline Code--------------------------------*/

/* assume that the user is ok with the change if they chose not to see this message */
IF l_show THEN
   RETURN "mod".

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame confirmation" 
   &BOX   = "s_rect_Btns"
   &OK    = "b_yes" 
   &HELP  = "s_btn_Help" 
}

do ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE  ON STOP UNDO, LEAVE:
      update b_yes  	      
      	     b_no
      	     s_btn_Help
             l_show
      	     with frame confirmation.

      ASSIGN retval = "mod".
             l_show = INPUT FRAME confirmation l_show.
end.

hide frame confirmation.
return retval.



/**********************************************************************
* Copyright (C) 2000,2006-2007 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

/*----------------------------------------------------------------------------

File: _idxprop.p

Description:
   Set up the index properties window so the user can view or modify the 
   information on an index.  Since this window is non-modal, we just do the
   set up here.  All triggers must be global.

Author: Laura Stern

Date Created: 04/29/92

Last modified on:

08/26/94 by gfs       Added Recid index support.
03/26/98 by D. McMann Added Area support.
04/20/98 by D. McMann Change how we get area name, must use storageobject.
05/14/98 by D. McMann 98-05-13-028 _Idx-num not assigned until committed must
                      use _ianum instead.
08/16/00 D. McMann  Added _db-recid to StorageObject find 20000815029
06/08/06 fernando   Support for large key entries
08/21/06 fernando   Fix can-write check on _Index (20051216-011).
11/16/07 fernando   Support for _aud-audit-data* indexes deactivation
----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES

{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adedict/IDX/idxvar2.i shared}
{adedict/IDX/idxvar.i shared}

{adedict/capab.i}

Define var err 	     as logical NO-UNDO.
Define var capab     as char    NO-UNDO.
Define var frstfld   as char	NO-UNDO init "".
Define var lst_item  as char	NO-UNDO.
Define var name_mod  as logical NO-UNDO. /* name modifiable */
DEFINE VAR idx_mod   AS LOGICAL NO-UNDO INIT YES.
DEFINE VAR canAudDeact AS LOGICAL NO-UNDO.

/*============================Mainline code==================================*/

find _File WHERE _file._File-name = "_Index"
             AND _File._Owner = "PUB" NO-LOCK.
if NOT can-do(_File._Can-read, USERID("DICTDB")) then
do:
   message s_NoPrivMsg "see index definitions."
      view-as ALERT-BOX ERROR buttons Ok in window s_win_Browse.
   return.
end.
if NOT can-do(_File._Can-write, USERID("DICTDB")) then
   ASSIGN idx_mod = NO.

find _File WHERE _File._File-name = "_Index-Field"
             AND _File._Owner = "PUB" NO-LOCK.
if NOT can-do(_File._Can-read, USERID("DICTDB")) then
do:
   message s_NoPrivMsg "see index definitions."
      view-as ALERT-BOX ERROR buttons Ok in window s_win_Browse.
   return.
end.
if NOT can-do(_File._Can-write, USERID("DICTDB")) then
   ASSIGN idx_mod = NO.

/* Don't want Cancel if moving to next index - only when window opens */
if s_win_Idx = ? then
   s_btn_Close:label in frame idxprops = "Cancel".

/* Open the window if necessary */
run adedict/_openwin.p
   (INPUT   	  "Index Properties",
    INPUT   	  frame idxprops:HANDLE,
    INPUT         {&OBJ_IDX},
    INPUT-OUTPUT  s_win_Idx).

/* Run time layout for button area. Since this is a shared frame we 
   have to avoid doing this code more than once.
*/
if frame idxprops:private-data <> "alive" then
do:
   /* okrun.i widens frame by 1 for margin */
   assign
      s_win_Idx:width = s_win_Idx:width + 1
      frame idxprops:private-data = "alive".

   {adecomm/okrun.i  
      &FRAME = "frame idxprops" 
      &BOX   = "s_rect_Btns"
      &OK    = "s_btn_OK" 
      &HELP  = "s_btn_Help"
   }

   /* So Return doesn't hit default button in editor widget */
   b_Index._Desc:RETURN-INSERT in frame idxprops = yes.
end.

/* First clear the select list in case it had stuff in it from the last time. */
s_lst_IdxFlds:LIST-ITEMS = "".

find _File where RECID(_File) = s_TblRecId.
find b_Index of _File where b_Index._Index-Name = s_CurrIdx.
if _File._Prime-Index = RECID(b_Index) then
   s_Idx_Primary = yes.
else
   s_Idx_Primary = no.

s_Idx_Word = (if b_Index._Wordidx = 0 OR b_Index._Wordidx = ? then no else yes).

IF _File._For-type <> ? THEN
  ASSIGN idx-area-name = "N/A".
ELSE DO:
  IF b_Index._Idx-num <> ? THEN DO:
    FIND _StorageObject WHERE _StorageObject._Db-recid = _File._Db-recid
                          AND _StorageObject._Object-type = 2
                          AND _StorageObject._Object-number = b_Index._Idx-num
                          NO-LOCK NO-ERROR.
    IF AVAILABLE _StorageObject THEN                                              
      FIND _Area WHERE _Area._Area-number = _StorageObject._Area-number NO-LOCK.
    ELSE
      FIND _Area WHERE _Area._Area-number = 6 NO-LOCK.  
  END.
  ELSE 
    FIND _Area WHERE _Area._Area-number = b_Index._ianum NO-LOCK.
    
  ASSIGN idx-area-name = _Area._Area-name.
END.  

find LAST _Index-Field of b_Index NO-ERROR.
if AVAILABLE _Index-Field then /* the default index has no fields */
   s_Idx_Abbrev = _Index-Field._Abbreviate.

IF s_dbCache_type[s_dbCache_ix] <> "PROGRESS" THEN DO: /* Foreign DB */
   ASSIGN ActRec:LABEL = "R&OWID".
   IF  b_Index._I-MISC2[1] begins "u"
    OR b_Index._I-MISC2[1]    =   "a"
    THEN ASSIGN
       ActRec:SENSITIVE = true
       ActRec           = false.
   ELSE IF b_Index._I-MISC2[1] begins "ru"
    OR     b_Index._I-MISC2[1]    =   "ra"
    THEN ASSIGN 
       ActRec:SENSITIVE = false
       ActRec           = true.
    ELSE ASSIGN
       ActRec:SENSITIVE = false
       ActRec           = false.
END.
ELSE ASSIGN ActRec:LABEL = "Ac&tive"
            ActRec       = b_Index._Active.
        
IF _File._For-type = ? AND NOT is-pre-101b-db THEN DO:
    /* for Progress db's, check if large key entries is not enabled, and display
       information. We only have to do this for 10.1B and later dbs
    */
    FIND DICTDB._Database-feature WHERE _DBFeature_Name = "Large Keys" NO-LOCK NO-ERROR.
    IF AVAILABLE DICTDB._Database-feature THEN DO:
        IF DICTDB._Database-feature._DBFeature_Enabled EQ "1" THEN
            s_msg = "".
        ELSE
            s_msg = "** Large key entries support not enabled".

        RELEASE DICTDB._Database-feature.
    END.
    ELSE
        s_msg = "".
END.

/* we will allow some of the indexes on the _aud-audit-data tables to be
   deactivated. The primary index and the _audit-time index cannot be
   deactivated.
*/
IF (NOT s_Idx_Primary) AND (_file-name BEGINS "_aud-audit-data") AND
   (b_Index._Index-Name NE "_audit-time") THEN
   ASSIGN canAudDeact = YES.

/* Set status line */
display "" @ s_Status s_msg ActRec with frame idxprops. /* clears from last time */

s_Idx_ReadOnly = (s_DB_ReadOnly OR s_ReadOnly).
if NOT s_Idx_ReadOnly then
do:
   if NOT idx_mod then
   do:
      display s_NoPrivMsg + " modify index definitions." @ s_Status
      	 with frame idxprops.
      s_Idx_ReadOnly = true.
   end.

   find _File where RECID(_File) = s_TblRecId.
   if _File._Frozen then
   do:
       IF NOT canAudDeact THEN DO:
          s_Status:screen-value in frame idxprops =
    	"Note: This file is frozen and cannot be modified.".
          s_Idx_ReadOnly = true.
       END.
   end.
   ELSE IF _File._Db-lang > {&TBLTYP_SQL} THEN DO:
      s_Status:screen-value in frame idxprops =
   	 "Note: {&PRO_DISPLAY_NAME}/SQL92 table cannot be modified.".
      s_Idx_ReadOnly = true.
   END.
end.

/* Setup field list and it's labels */
s_txt_List_Labels[1] = STRING(" ", "x(53)") + "A(sc)/".
s_txt_List_Labels[2] = STRING("Index Field", "x(33)") +
                       STRING("Data Type", "x(20)") +
                       "D(esc)".

/* Fill up the list of index fields */
for each b_idx-list.
   delete b_idx-list.
end.

for each _Index-Field of b_Index:
   find _Field where RECID(_Field) = _Index-Field._Field-recid.
   create b_idx-list.
   assign b_idx-list.fld-nam = _Field._Field-name
          b_idx-list.fld-typ = _field._Data-type
          b_idx-list.asc-desc = if _Index-Field._Ascending then "A"
                             else "D"
          b_idx-list.comp-seq = _Index-seq.
 
   if frstfld = "" then
      frstfld = lst_item.
end.
s_lst_IdxFlds:screen-value = frstfld.  /* set selection to the first fld */

open query q-idx-list for each b_idx-list no-lock.


display b_Index._Index-Name	 
        idx-area-name
    	b_Index._Desc
   	    s_Idx_Primary
    	ActRec
    	b_Index._Unique
    	s_Idx_Word
   	    s_Idx_Abbrev
       b-idx-list  
   with frame idxprops.


if s_Idx_ReadOnly OR canAudDeact then
do:
   disable all EXCEPT	
      b-idx-list
	  s_btn_Close 
	  s_btn_Prev
	  s_btn_Next
	  s_btn_Help
	  with frame idxprops.

   ActRec:sensitive in frame idxprops = no.

   enable  
      b-idx-list
	  s_btn_Close 
	  s_btn_Prev
	  s_btn_Next
	  s_btn_Help
	  with frame idxprops.

   IF canAudDeact THEN DO:
      IF     
          &IF "{&WINDOW-SYSTEM}" begins "MS-WIN"
            &THEN ActRec:Label = "Ac&tive"
            &ELSE ActRec:Label = "Active"
          &ENDIF
        AND b_Index._Active /*AND INDEX(capab, {&CAPAB_INACTIVATE}) > 0*/
        THEN do:
         /* ActRec:sensitive in frame idxprops = YES.*/
          enable ActRec
                 s_btn_OK
	             s_btn_Save
               with frame idxprops.
      END.
   END.

   apply "entry" to s_btn_Close in frame idxprops.
end.
else do:
   /* Get gateway capabilities */
   run adedict/_capab.p (INPUT {&CAPAB_IDX}, OUTPUT capab).

   /* Note: In Progress, you change the primary index by setting this one to
      be primary but you can't make a primary index be not-primary.  You
      can make an index inactive but not active - that is done via proutil. 
      In some gateways, making inactive and changing primary aren't allowed
      at all.

      Explicitly disable based on these conditions in case these were
      sensitive from the last index, and then conditionally enable (using
      ENABLE verb) below to make sure the TAB order comes out right.
   */
   if b_Index._Index-Name = "default" then
      assign
      	 b_Index._Index-Name:sensitive in frame idxprops = no
      	 name_mod = false.
   else
      name_mod = true.

   if s_Idx_Primary OR INDEX(capab, {&CAPAB_CHANGE_PRIMARY}) = 0 then
      s_Idx_Primary:sensitive in frame idxprops = no.
      
   if (NOT b_Index._Active OR INDEX(capab, {&CAPAB_INACTIVATE}) = 0)
      AND 
        &IF "{&WINDOW-SYSTEM}" begins "MS-WIN"
          &THEN ActRec:Label = "Ac&tive"
          &ELSE ActRec:Label = "Active"
        &ENDIF
      THEN ActRec:sensitive in frame idxprops = no.
   
   if INDEX(capab, {&CAPAB_CHANGE_UNIQ}) = 0 then
      b_Index._Unique:sensitive in frame idxprops = no.

   enable b_Index._Index-Name when name_mod
      	  b_Index._Desc
      	  s_Idx_Primary   when NOT s_Idx_Primary AND
      	       	     	       INDEX(capab, {&CAPAB_CHANGE_PRIMARY}) > 0
      	  b_Index._Unique when INDEX(capab, {&CAPAB_CHANGE_UNIQ}) > 0 	 
          b-idx-list
      	  s_btn_OK
	  s_btn_Save
	  s_btn_Close
	  s_btn_Prev
	  s_btn_Next
      	  s_btn_Help
      with frame idxprops.

IF     
    &IF "{&WINDOW-SYSTEM}" begins "MS-WIN"
      &THEN ActRec:Label = "Ac&tive"
      &ELSE ActRec:Label = "Active"
    &ENDIF
  AND b_Index._Active AND INDEX(capab, {&CAPAB_INACTIVATE}) > 0
  THEN enable ActRec with frame idxprops.

  if name_mod then apply "entry" to b_Index._Index-Name in frame idxprops.
              else apply "entry" to b_Index._Desc in frame idxprops.
  end.


return.







/*********************************************************************
* Copyright (C) 2008 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _newidx.p

Description:
   Display and handle the add index dialog box and then add the index
   if the user presses OK.

Author: Laura Stern

Date Created: 04/22/92

History:
	gfs	11/04/94	Fixed problem with sensitive on Asc/Desc
	DLM     03/26/98    Added area support
	DLM     04/20/98    Default _index now has an _index-field associated
	                    with it.  Added code to delete fields when the first
	                    index is added.
	DLM     06/08/98    Changed s_btn_Idx_Area and s_Lst_Idx_Area as being
	                    hidden when adding an index to a dataserver.
	                    98-05-20-038 
	DLM     07/14/98    Added _Owner to _file finds
    Mario B 12/28/98    Add s_In_Schema_Area enabling one time notification.
    DLM     05/15/00    Removed warning message if only Schema Area in DB
    DLM     01/30/03    Changed which procedure is called for builiding field
                        list so that a data type can be excluded from the list
                        This needed to be done for LOB support
    KSM	02/26/05    Added warning message for adding "Active" index while 
                        on-line
    fernando 10/03/07   Handle comma on the area name - OE00135682
    fernando 06/26/08 Removed encryption area from list   
----------------------------------------------------------------------------*/


&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/IDX/idxvar2.i shared}
{adedict/IDX/idxvar.i shared}
{adedict/capab.i}

/* General processing variables */
Define var num_flds  as integer NO-UNDO. /* # of index flds chosen */
Define var max_flds  as integer NO-UNDO.
Define var capab     as char   	NO-UNDO.
Define var all_cnt   as integer NO-UNDO.
Define var added     as logical NO-UNDO INIT no.
Define var num       as integer NO-UNDO.
Define var curr_type as CHARACTER NO-UNDO.

DEFINE VARIABLE ans AS LOGICAL NO-UNDO.


Define buffer x_File for _File.


/*=========================Internal Procedures===============================*/

/*-----------------------------------------------------------------
   Remove the selected field name from one list and add it
   to the other.

   Input Parameters:
      p_lst_Add  - Handle of selection list to add the name to.
      p_lst_Rmv  - Handle of selection list to remove name from.
      p_To_Index - True, if the field is being added to the index or
      	       	   false if field is being removed from the index.
------------------------------------------------------------------*/
PROCEDURE Transfer_Name:

Define INPUT parameter p_lst_Add  as widget-handle NO-UNDO.
Define INPUT parameter p_lst_Rmv  as widget-handle NO-UNDO.
Define INPUT parameter p_To_Index as logical       NO-UNDO.

Define var fldname as char    NO-UNDO.
Define var cnt 	   as integer NO-UNDO.
Define var pos     as integer NO-UNDO.
Define var nxtname as char    NO-UNDO.
Define var ix      as integer NO-UNDO.  /* loop index */

   /* Get the selected name from the "remove list". */
   fldname = p_lst_Rmv:screen-value.

   /* Remove this name from the "remove list" */
   run adecomm/_delitem.p (INPUT p_lst_Rmv, INPUT fldname, OUTPUT cnt).

   if p_To_Index then
   do:
      /* Add ascending/descending marker.  For Word indexes, this 
      	 isn't relevant 
      */
      fldname = (if input frame newidx s_Idx_Word 
      	       	   then STRING("A", "x(3)")
      	       	   else STRING(input frame newidx s_IdxFld_AscDesc, "x(3)"))
      	        + fldname.
      
      /* Index field order is in the order they are added. */
      s_Res = p_lst_Add:ADD-LAST(fldname). 
   end.
   else do:
      /* Remove ascending/descending marker */
      fldname = SUBSTR(fldname, 4, 32).

      /* Insert field back in it's proper place.  Determine the position
      	 this field took in original field list.  Look from this point
      	 down in original list until we find an entry that is still in
      	 the left hand field list.  This is the entry we want to insert
      	 above.
      */
      pos = LOOKUP(fldname, s_lst_IdxFldChoice:private-data in frame newidx).
      do ix = pos + 1 to all_cnt:
      	 nxtname = ENTRY(ix, s_lst_IdxFldChoice:private-data in frame newidx).
      	 if p_lst_Add:LOOKUP(nxtname) <> 0
      	    then leave.
      end.      
      if ix > all_cnt then
      	 s_Res = p_lst_Add:ADD-LAST(fldname). 
      else
      	 s_Res = p_lst_Add:INSERT(fldname, nxtname).
   end.

   /* Select the fldname value, making sure it's in view. */
   p_lst_Add:screen-value = fldname.
   run adecomm/_scroll.p (INPUT p_lst_Add, INPUT fldname).
end.


/*-----------------------------------------------------------------
   Move an entry down or up in the index fields list.

   Input Parameters:
      p_Incr - Amount to add to the list position to get the new
      	       position (either 1 or - 1).
      p_Down - True if moving down, False if moving up.

------------------------------------------------------------------*/
PROCEDURE Move_Entry:

Define INPUT parameter p_Incr as integer       NO-UNDO.
Define INPUT parameter p_Down as logical       NO-UNDO.

Define var lst_flds as widget-handle NO-UNDO.
Define var pos      as integer 	     NO-UNDO.
Define var fldname  as char   	     NO-UNDO.

   lst_flds = s_lst_IdxFlds:HANDLE in frame newidx. /* for convenience */

   /* Get the selected name from the list. */
   fldname = lst_flds:screen-value.
   
   /* Get the position of the item to insert in front of.  If moving down
      this will be +1 - actually, we want to insert in front of the one 2
      slots down but that will be only one slot down once this one is 
      removed.  If moving up, this will be -1.	
   */
   pos = lst_flds:LOOKUP(fldname) + p_Incr.

   /* Delete the item */
   s_Res = lst_flds:DELETE(fldname).

   if p_Down AND pos > num_flds - 1 then /* - 1 'cause of item just deleted */
      s_Res = lst_Flds:ADD-LAST(fldname).
   else if NOT p_Down AND pos = 0 then
      s_Res = lst_Flds:ADD-FIRST(fldname).
   else
      s_Res = lst_Flds:INSERT(fldname, lst_Flds:ENTRY(pos)).

   /* Select the fldname value, making sure it's in view. */
   lst_Flds:screen-value = fldname.
   run adecomm/_scroll.p (INPUT lst_Flds, INPUT fldname).

   /* Move up and down buttons may need enabling/disabling */
   run Adjust_Move_Btns.
end.


/*-----------------------------------------------------------------
   Adjust the sensitive-ness of the "Move Up" and "Move Down" buttons.
   There must be at least 2 items in the list for these to make
   sense.  Also, if the last item is selected, disable Move Down.
   Similarly, if the first item is selected, disable Move Up.

------------------------------------------------------------------*/
PROCEDURE Adjust_Move_Btns:

Define var val as char NO-UNDO.

   val = s_lst_IdxFlds:screen-value in frame newidx.

   s_btn_IdxFldDwn:sensitive in frame newidx = 
      (if num_flds > 1 AND 
       val <> s_lst_IdxFlds:ENTRY(num_flds) in frame newidx then
       yes else no).	 
   s_btn_IdxFldUp:sensitive in frame newidx = 
      (if num_flds > 1 AND 
       val <> s_lst_IdxFlds:ENTRY(1) in frame newidx then
       yes else no).	 
end.


/*-----------------------------------------------------------------
   Add the currently selected field to the list of index fields.
------------------------------------------------------------------*/
PROCEDURE Add_Field:
   Define var val as char NO-UNDO.

   run Transfer_Name (INPUT s_lst_IdxFlds:HANDLE in frame newidx,
      	       	      INPUT s_lst_IdxFldChoice:HANDLE in frame newidx,
      	       	      INPUT true).

   num_flds = num_flds + 1.

   /* Now that we know there's at least one index field, user can
      remove fields or set the asc/desc flag */
   assign
      s_lst_IdxFlds:sensitive in frame newidx = yes
      s_btn_IdxFldRmv:sensitive in frame newidx = yes.

   if NOT input frame newidx s_Idx_Word then
      s_IdxFld_AscDesc:sensitive in frame newidx = yes.

   /* Move-Up and move-down buttons may need enabling/disabling */
   run Adjust_Move_Btns.

   /* Can only support up to max_flds fields in an index.  Also if there's
      no fields left to add, disable add button. */
   if ( num_flds = max_flds OR
        s_lst_IdxFldChoice:NUM-ITEMS in frame newidx = 0) then
      s_btn_IdxFldAdd:sensitive in frame newidx = no.
end.


/*--------------------------------------------------------------------
   Remove the currently selected field from the list of index fields.
---------------------------------------------------------------------*/
PROCEDURE Remove_Field:
   run Transfer_Name (INPUT s_lst_IdxFldChoice:HANDLE in frame newidx,
      	       	      INPUT s_lst_IdxFlds:HANDLE in frame newidx,
      	       	      INPUT false).

   num_flds = num_flds - 1.

   if num_flds = 0 then
      assign
      	 s_lst_IdxFlds:sensitive in frame newidx = no
      	 s_IdxFld_AscDesc:sensitive in frame newidx = no
      	 s_btn_IdxFldRmv:sensitive in frame newidx = no.

   /* Move up and down buttons may need enabling/disabling */
   run Adjust_Move_Btns.
   
   if num_flds < max_flds then
      /* Make sure add button is sensitive now. */
      s_btn_IdxFldAdd:sensitive in frame newidx = yes.
end.


/*===============================Triggers====================================*/

/*-----WINDOW-CLOSE-----*/
on window-close of frame newidx
   apply "END-ERROR" to frame newidx.


/*----- HIT of OK BUTTON -----*/
on choose of s_btn_OK in frame newidx
   s_OK_Hit = yes.
   /* The GO trigger will fire after this. */


/*----- HIT of ADD (Index) BUTTON or GO -----*/
on GO of frame newidx	/* or Create - because it's auto-go */
do:
   Define var fnum   	as integer NO-UNDO.
   Define var flds   	as char    NO-UNDO.
   Define var name   	as char    NO-UNDO.
   Define var id     	as recid   NO-UNDO.
   Define var primary 	as logical NO-UNDO.
   Define var defname   as char    NO-UNDO.
   Define var wordidx   as logical NO-UNDO.
   Define var answer    as logical NO-UNDO.
   Define var no_name   as logical NO-UNDO.
   Define var ins_name  as char    NO-UNDO.
   Define var is_data   as logical NO-UNDO.
   Define var tmpfile   as char    NO-UNDO.
   Define var xnum_proc as char    NO-UNDO.
   DEFINE VARIABLE lOk  AS LOGICAL NO-UNDO.

   /* If On-Line and index is active */
   IF SESSION:SCHEMA-CHANGE <> "" AND
      SESSION:SCHEMA-CHANGE <> ?  AND
     INPUT FRAME newidx b_Index._Active THEN DO:
     MESSAGE "The Data Dictionary has detected that you are attempting to" SKIP
             "add an ACTIVE index while ON-LINE.  If some other user is"   SKIP
		 "locking the table you are attempting to update, when you"    SKIP
             "commit, your changes may be lost."                           SKIP(1)
             "Do you wish to continue?"
	   VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO-CANCEL 
                           TITLE "ON-LINE Index Add" UPDATE lOk.
     IF (lOk = FALSE) THEN RETURN NO-APPLY.
     ELSE IF (lOk = ?) THEN APPLY "WINDOW-CLOSE" TO FRAME newidx.
   END.
   run adedict/_blnknam.p
      (INPUT b_Index._Index-name:HANDLE in frame newidx,
       INPUT "index", OUTPUT no_name).
   if no_name then do:
      s_OK_Hit = no.
      return NO-APPLY.
   end.
   
   
   if num_flds = 0 then
   do:
      message "You must specify at least one field" SKIP
      	      "for the index."
      	 view-as ALERT-BOX ERROR  buttons OK.    
      s_OK_Hit = no.
      return NO-APPLY.
   end.
 
   IF NOT s_In_Schema_Area THEN DO:
     APPLY "LEAVE" TO idx-area-name.
     IF NOT ans THEN DO:
        s_OK_Hit = no.  /* in case ok was hit */
        APPLY "ENTRY" TO idx-area-name.
        return NO-APPLY.
     END.
   END.       
  
   flds = s_lst_IdxFlds:LIST-ITEMS in frame newidx. /* Get all fields in list */

   wordidx = input frame newidx s_Idx_Word.
   if wordidx = yes then
   do:
      if num_flds > 1 then
      do:
	 message "An index that is word-indexed" SKIP
		 "can only have one field component" SKIP
		 "(though that may be an array field)."
      	    view-as ALERT-BOX ERROR  buttons OK.    
      	 s_OK_Hit = no.
	 return NO-APPLY.
      end.

      /* Since we don't allow primary, unique or abbreviated to be on
      	 when Word indexed is chosen, or vice versa, we don't need to 
      	 check that.
      */

      name = SUBSTR(flds, 4, 32).  /* We know now there's only 1 fld */
      find _Field of x_File where _Field._Field-Name = name.
      if _Field._Data-Type <> "Character" then
      do:
	 message "You can only specify word-indexed when" SKIP
		 "the index contains a character field."
      	    view-as ALERT-BOX ERROR  buttons OK.    
      	 s_OK_Hit = no.
	 return NO-APPLY.
      end.                  
   end.
   else do: /* Word index was not specified */
      do fnum = 1 to num_flds:
	 name = SUBSTR(ENTRY(fnum, flds), 4, 32).
	 find _Field of x_File where _Field._Field-Name = name.
	 if _Field._Extent > 0 then
	 do:
      	    message "Only a word index can contain an array field."
	       view-as ALERT-BOX ERROR  buttons OK.    
      	    s_OK_Hit = no.
	    return NO-APPLY.
	 end.
      end.

      if input frame newidx s_Idx_Abbrev = yes then
      do:
      	 /* Get last field specified for the index */
      	 assign
      	    name = s_lst_IdxFlds:ENTRY(num_flds) in frame newidx
            name = SUBSTR(name, 4, 32).

      	 find _Field of x_File where _Field._Field-Name = name.
      	 if _Field._Data-Type <> "Character" then
      	 do:
	    message "Abbreviate is an index option that lets you" SKIP
      	       	    "conveniently search for a partial match based" SKIP
      	       	    "on the first few characters of a field (like" SKIP
      	       	    "using BEGINS) in the FIND ...USING statement." SKIP(1)
      	       	    "This option is only available on indexes that" SKIP
      	       	    "have a character field as their last index" SKIP
      	       	    "component."
      	       view-as ALERT-BOX ERROR  buttons OK.    
      	    s_OK_Hit = no.
	    return NO-APPLY.
      	 end.     
      end.

      if input frame newidx b_Index._Unique = yes AND
      	 input frame newidx b_Index._Active = yes then
      do:   
      	 /* Before putting up this horrible message, check to see if
      	    there's data in the table.  If there's no data the user 
      	    shouldn't need to worry.  _isdata.i won't compile unless 
      	    table is committed and in that case, we know there's no data
      	    either.  There's no way to suppress compile errors from showing
      	    up on the screen (e.g., NO-ERROR won't do it) so do output to 
      	    file to redirect them so the user won't see anything.
      	 */
      	 run adecomm/_tmpfile.p (INPUT "", INPUT ".dct", OUTPUT tmpfile).
      	 output to VALUE(tmpfile).
      	 do ON STOP UNDO, LEAVE:
      	    run adedict/_isdata.i (OUTPUT is_data) VALUE(s_CurrTbl).
      	 end.
      	 output close.
      	 os-delete VALUE(tmpfile).
      	 if compiler:error then
      	    is_data = false.  /* table isn't committed yet */
      	 if is_data then
      	 do:
      	    answer = yes.   /* set's yes as default button */
      	    message 
      	       "If {&PRO_DISPLAY_NAME} finds duplicate values while creating" SKIP
      	       "this new unique index, it will UNDO the entire" SKIP
      	       "transaction, causing you to lose any schema changes" SKIP
      	       "made within the same transaction." SKIP(1)
      	       "Recommendations:" SKIP(1)
      	       "If you are sure there are no duplicate values OR" SKIP
      	       "if you did not make any other schema changes within" SKIP
      	       "this transaction, then select OK to add this new" SKIP
      	       "unique index." SKIP(1)
      	       "Otherwise, select Cancel.  You can then close the" SKIP
      	       "dialog, commit the transaction (Edit/Commit from the menu)" SKIP
      	       "and then add the index." SKIP(1)
      	       "Another alternative is to change the index to inactive," SKIP
      	       "and activate it later by running ~"proutil -C idxbuild ~"."
      	       view-as ALERT-BOX WARNING buttons OK-CANCEL update answer.
      	    if answer = false then
      	    do:
      	       s_OK_Hit = no.
      	       return NO-APPLY.
      	    end.
      	 end.
      end.
   end.

   do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      run adecomm/_setcurs.p ("WAIT").
   
      assign
	 b_Index._File-recid = s_TblRecId
	 input frame newidx b_Index._Index-name
	 input frame newidx b_Index._Unique
	 input frame newidx b_Index._Active
	 input frame newidx b_Index._Desc.

      IF idx-area-name = "N/A"  THEN
        ASSIGN b_Index._ianum = 6.
      ELSE  DO:
        FIND _Area WHERE _Area._Area-name = INPUT FRAME newidx idx-area-name NO-LOCK.
        ASSIGN b_Index._ianum = _Area._Area-number
               idx-area-name = INPUT FRAME newidx idx-area-name.
      END.
      
      b_Index._Wordidx = (if wordidx then 1 else ?).
      
      if INDEX(capab, {&CAPAB_GATE_IDXNUM}) > 0 then
      do:
      	 /* Call gateway specific routine to get index number */
      	 assign xnum_proc = "prodict/gate/_gatxnum.p".
      	 run VALUE(xnum_proc) 
      	    (INPUT  s_TblRecId, 
      	     OUTPUT b_Index._Idx-num).
      end.

      /* Create a record for each index field. */
      do fnum = 1 to num_flds:
      	 name = SUBSTR(ENTRY(fnum, flds), 4, 32).
      	 find _Field of x_File where _Field._Field-Name = name.

	 create _Index-Field.
      	 assign
      	    _Index-Field._Index-recid = RECID(b_Index)
      	    _Index-Field._Field-recid = RECID(_Field)
      	    _Index-Field._Index-seq   = fnum
      	    _Index-Field._Abbreviate  = 
      	       (if fnum = num_flds then input frame newidx s_Idx_Abbrev else no)
      	    _Index-Field._Ascending =
      	       (if SUBSTR(ENTRY(fnum, flds), 1, 1) = "A" then yes else no).
      end.

      /* We've got a confusing situation here.  Some facts.
      	 1. If the table that this index belongs to has not been committed
      	    to the database then the default index will not have been
      	    created yet. x_File.dft-pk (which indicates if there's a
      	    default index) will be false.
      	 2. x_File._Prime-Index will be ? if the table hasn't been committed
      	    and the user hasn't already created a primary index.  It could
      	    also be ? for some gateways. I don't know what the exact
      	    circumstances of this are but it means there's no primary index.
      	 3. If the table has been committed, there will only be a default
      	    index if no other non-word-index has been created.  If there
      	    is a default, _dft-pk will be true.
      	 4. If we are currently creating a non-word index, we want to
      	    make it primary if there isn't another primary index already
      	    (besides the default).
      	 
      	 So: Set primary to yes if we want to make this index the new
      	 primary index.
      */
      if x_File._Prime-Index = ? AND NOT wordidx then
      	 primary = yes.
      else if x_File._dft-pk AND NOT wordidx then
      do:
      	 /* Delete the default index */
      	 assign
      	    id = x_File._Prime-Index  /* recid of default index */
      	    primary = yes
      	    x_File._dft-pk = false.

      	 find _Index where RECID(_Index) = id.
      	 defname = _Index._Index-Name.
      	 FOR EACH _Index-field WHERE _Index-field._Index-recid = RECID(_Index).
      	   DELETE _Index-field.
      	 end.  
      	 delete _Index.
      	 
      	 /* Remove the default index from the list in the browse window.  
      	    (we don't care about output parm - just use fnum variable) */
      	 run adecomm/_delitem.p (INPUT s_lst_Idxs:HANDLE in frame browse,
      	       	     	        INPUT defname, OUTPUT fnum). 
      end.
      else
      	 primary = no.
      
      /* If there is no primary index, or the the user explicitly wants
      	 this index to be the primary one, set the primary index flag 
      	 in the _File record. 
      */
      if (primary OR
      	  input frame newidx s_Idx_Primary = yes) then
      do:
	 x_File._Prime-Index = RECID(b_Index).
      	 s_Status = " - Made this the primary index".
      end.
      else 
      	 s_Status = "".
         
      /* Add entry to indexes list in alphabetical order */
      find FIRST _Index where _Index._File-recid = s_TblRecId AND
      	     	      	      _Index._Index-Name > b_Index._Index-Name 
         NO-ERROR.

      ins_name = (if AVAILABLE _Index then _Index._Index-name else "").
      run adedict/_newobj.p
         (INPUT s_lst_Idxs:HANDLE in frame browse,
          INPUT b_Index._Index-name,
          INPUT ins_name,
          INPUT s_Idxs_Cached,
          INPUT {&OBJ_IDX}).
   
      {adedict/setdirty.i &Dirty = "true"}.
      display "Index Created" + s_Status @ s_Status with frame newidx.
      added = yes.
      run adecomm/_setcurs.p ("").   
      return.
   end.

   /* Only get here if there's an error.  Leave box up and let the user
      fix the problem or Cancel. */
   run adecomm/_setcurs.p ("").   
   s_OK_Hit = no.
   return NO-APPLY.
end.


/* ------on leave of idx-area-name ----*/
ON LEAVE OF idx-area-name in frame newidx 
do:
  ASSIGN ans = FALSE.
  IF NOT s_In_Schema_Area AND num > 1 THEN DO:
    IF INPUT FRAME newidx idx-area-name = "Schema Area" THEN DO:
      MESSAGE "Progress Software Corporation does not recommend" SKIP
              "creating user indices in the Schema Area."  Skip(1)
              "Should indices be created in this area?" SKIP (1)
              VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE ans .
      IF ans THEN
        ASSIGN s_In_Schema_Area = TRUE.        
      ELSE DO:
        ASSIGN s_In_Schema_Area = TRUE.
        RETURN NO-APPLY.
      END.
    END.
    ELSE
      ASSIGN ans = TRUE.
  END.
  ELSE IF NOT s_In_Schema_Area AND INPUT FRAME newidx idx-area-name = "Schema Area" THEN DO:
    MESSAGE "Progress Software Corporation does not recommend" SKIP
            "creating user indices in the Schema Area. " SKIP (1)
            "See the System Administration Guide on how to" SKIP
            "create other data areas." SKIP (1)
            VIEW-AS ALERT-BOX WARNING.
    ASSIGN s_In_Schema_Area = TRUE
           ans          = TRUE.
  END.  
  ELSE 
    ASSIGN ans = true.      
END.  


/*----- HIT of ADD >> (add field) BUTTON -----*/
on choose of s_btn_IdxFldAdd in frame newidx
   run Add_Field.


/*----- DEFAULT-ACTION (DBL-CLICK or RETURN) of FIELD CHOICE LIST -----*/
on default-action of s_lst_IdxFldChoice in frame newidx
   run Add_Field.


/*----- HIT of REMOVE >> (remove field) BUTTON -----*/
on choose of s_btn_IdxFldRmv in frame newidx 
   run Remove_Field.


/*----- HIT of MOVE DOWN BUTTON -----*/
on choose of s_btn_IdxFldDwn in frame newidx 
   run Move_Entry(1, TRUE).


/*----- HIT of MOVE UP BUTTON -----*/
on choose of s_btn_IdxFldUp in frame newidx 
   run Move_Entry(-1, FALSE).


/*----- DEFAULT-ACTION (DBL-CLICK or RETURN) of INDEX FIELD LIST -----*/
on default-action of s_lst_IdxFlds in frame newidx
   run Remove_Field.


/*----- VALUE-CHANGED of ASC/DESC RADIO SET -----*/
on value-changed of s_IdxFld_AscDesc in frame newidx  
do:
   Define var oldval as char NO-UNDO.
   Define var newval as char NO-UNDO.

   assign
      oldval = s_lst_IdxFlds:screen-value in frame newidx
      newval = STRING(TRIM(SELF:screen-value), "x(3)") + SUBSTR(oldval, 4, 32).

   s_Res = s_lst_IdxFlds:replace(newval, oldval) in frame newidx = no.
   s_lst_IdxFlds:screen-value in frame newidx = newval.  /* reset selection */
end.


/*----- VALUE-CHANGED of INDEX FIELDS LIST -----*/
on value-changed of s_lst_IdxFlds in frame newidx
do:
   /* Reflect ascending/descending value for this entry in radio set. */
   if NOT input frame newidx s_Idx_Word then
      s_IdxFld_AscDesc:screen-value in frame newidx = 
      	 substr(SELF:screen-value, 1, 1).

   /* Move up and down buttons may need enabling/disabling */
   run Adjust_Move_Btns.
end.


/*----- VALUE-CHANGED of WORD INDEX TOGGLE -----*/
on value-changed of s_Idx_Word in frame newidx
do:
   Define var ix     	as integer NO-UNDO.
   Define var sel    	as char    NO-UNDO.
   Define var olditem 	as char    NO-UNDO.
   Define var newitem 	as char    NO-UNDO.

   if SELF:screen-value = "yes" then 
   do:
      /* If user turns word indexing on, turn off primary, unique and
      	 abbreviated and disable ascending/descending. 
      */
      assign
	 s_Idx_Primary:screen-value in frame newidx = "no"
	 b_Index._Unique:screen-value in frame newidx = "no"
	 s_Idx_Abbrev:screen-value in frame newidx = "no"
      	 s_IdxFld_AscDesc:screen-value in frame newidx = "A"
      	 s_IdxFld_AscDesc:sensitive in frame newidx = no.

      /* Also set all the Asc/Desc flags to "A" */
      sel = s_lst_IdxFlds:screen-value in frame newidx.
      do ix = 1 to s_lst_IdxFlds:num-items:
      	 olditem = s_lst_IdxFlds:entry(ix) in frame newidx.
      	 if SUBSTR(olditem, 1, 1) = "D" then
      	 do:
      	    assign
      	       newitem = olditem
      	       SUBSTR(newitem, 1, 1) = "A"
      	       s_Res = s_lst_IdxFlds:replace(newitem, olditem) in frame newidx.
      	    if olditem = sel then
      	       s_lst_IdxFlds:screen-value in frame newidx = newitem.
      	 end.
      end.
   end.
   else
      /* Enable Asc/Desc if there are any fields in the list */
      if s_lst_IdxFlds:num-items > 0 then 
      	 s_IdxFld_AscDesc:sensitive in frame newidx = yes.
end.


/*----- VALUE-CHANGED of PRIMARY TOGGLE -----*/
on value-changed of s_Idx_Primary in frame newidx
do:
   /* Primary and word indexed are incompatible */
   if SELF:screen-value = "yes" then do:
      s_Idx_Word:screen-value in frame newidx = "no".
      s_IdxFld_AscDesc:sensitive in frame newidx = yes.
   end.
end.


/*----- VALUE-CHANGED of UNIQUE TOGGLE -----*/
on value-changed of b_Index._Unique in frame newidx
do:
   /* Unique and word indexed are incompatible */
   if SELF:screen-value = "yes" then do:
      s_Idx_Word:screen-value in frame newidx = "no".
      s_IdxFld_AscDesc:sensitive in frame newidx = yes.
   end.
end.


/*----- VALUE-CHANGED of ABBREVIATED TOGGLE -----*/
on value-changed of s_Idx_Abbrev in frame newidx
do:
   /* Abbreviated and word indexed are incompatible */
   if SELF:screen-value = "yes" then do:
      s_Idx_Word:screen-value in frame newidx = "no".
      s_IdxFld_AscDesc:sensitive in frame newidx = yes.
   end.
end.


/*----- HELP -----*/
on HELP of frame newidx OR choose of s_btn_Help in frame newidx
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Create_Index_Dlg_Box}, ?).


/*============================Mainline code==================================*/

Define var frstfld  as char    NO-UNDO init "".
Define var char_fld as logical NO-UNDO init yes.
Define var cmax     as char    NO-UNDO.
Define var access   as logical NO-UNDO.

/* Check permissions */
find _File WHERE _File._File-name =  "_Index"
             AND _File._Owner = "PUB" NO-LOCK.
if NOT can-do(_File._Can-create, USERID("DICTDB")) then
do:
   message s_NoPrivMsg "create indexes."
      view-as ALERT-BOX ERROR buttons Ok.
   return.
end.
find _File WHERE _File._FIle-name = "_Index-Field"
             AND _File._Owner = "PUB" NO-LOCK.
if NOT can-do(_File._Can-create, USERID("DICTDB")) then
do:
   message s_NoPrivMsg "create indexes."
      view-as ALERT-BOX ERROR buttons Ok.
   return.
end.
find _File where RECID(_File) = s_TblRecId.
if _File._Frozen then  
do:
   message "This table is frozen and cannot be modified."
      view-as ALERT-BOX ERROR buttons Ok.
   return.
end.

/* OE00135682 - use other delimiter in case area name has comma */
s_lst_idx_Area:DELIMITER in frame newidx = CHR(1).

/* Set up for filling the list of all fields from the current table */
find x_File where RECID(x_file) = s_TblRecId.

if x_File._Db-lang >= {&TBLTYP_SQL} then
do:
   message "This is a {&PRO_DISPLAY_NAME}/SQL table." SKIP
      	   "You must use the CREATE INDEX statement."
	   view-as ALERT-BOX ERROR buttons OK.
   return.
end.
IF x_File._For-type <> ? THEN
  ASSIGN idx-area-name = "N/A"
         s_Lst_Idx_Area:hidden in frame newidx = yes
         s_btn_Idx_Area:HIDDEN in frame newidx = yes.
ELSE DO:
  s_lst_idx_area:list-items in frame newidx = "".
  FIND FIRST DICTDB._Area WHERE DICTDB._Area._Area-num > 6 
                            AND DICTDB._Area._Area-type = 6 
                            AND NOT CAN-DO({&INVALID_AREAS}, DICTDB._AREA._Area-name)
                          NO-LOCK NO-ERROR.
  IF AVAILABLE DICTDB._Area THEN
    ASSIGN idx-area-name = DICTDB._AREA._Area-name.
  ELSE DO:
    FIND DICTDB._Area WHERE DICTDB._Area._Area-num = 6 NO-LOCK.
    ASSIGN idx-area-name = DICTDB._AREA._Area-name
           s_In_Schema_Area = TRUE.
  END.  
  
  for each DICTDB._Area FIELDS (_Area-num _Area-type _Area-name) WHERE DICTDB._Area._Area-num > 6 
               AND DICTDB._Area._Area-type = 6 
               AND NOT CAN-DO({&INVALID_AREAS}, DICTDB._AREA._Area-name) NO-LOCK:
    s_res = s_lst_idx_Area:add-last(DICTDB._Area._Area-name) in frame newidx.
  END.

  FIND DICTDB._Area WHERE DICTDB._Area._Area-num = 6 NO-LOCK.
  ASSIGN s_res = s_lst_idx_Area:add-last(DICTDB._Area._Area-name) in frame newidx.
  
  num = s_lst_Idx_Area:num-items in frame newidx.
  s_Lst_Idx_Area:inner-lines in frame newidx = (if num <= 5 then num else 5).  
  assign idx-area-name:font  in frame newidx = 0
         s_lst_idx_Area:font in frame newidx = 0
         idx-Area-name:width  in frame newidx = 34
         s_lst_idx_Area:width in frame newidx = 38.

  {adecomm/cbdrop.i &Frame  = "frame newidx"
      	       	  &CBFill = "idx-area-name"
      	       	  &CBList = "s_lst_idx_Area"
      	       	  &CBBtn  = "s_btn_idx_area"
     	       	  &CBInit = """"}


   {adecomm/cbcdrop.i &Frame  = "frame newidx"
		         &CBFill = "idx-area-name"
		         &CBList = "s_lst_idx_Area"
		     	 &CBBtn  = "s_btn_idx_Area"
		     	 &CBInit = "curr_type"}
END.
    
find FIRST _Field of x_File NO-ERROR.
if NOT AVAILABLE _Field then
do:
   message "You must first create fields for this" SKIP
      	   "table before you can create an index."
      view-as ALERT-BOX ERROR  buttons OK.
   return.
end.

/* Get gateway capabilities */
run adedict/_capab.p (INPUT {&CAPAB_IDX}, OUTPUT capab).
if INDEX(capab, {&CAPAB_ADD}) = 0 then
do:
   message "You may not add an index definition for this database type."
      view-as ALERT-BOX ERROR buttons OK.
   return.
end.

/* Set dialog box title to show which table this index will belong to. */
frame newidx:title = "Create Index for Table " + s_CurrTbl.

/* Get the max # of components that can be in the index for this gateway */
run adedict/_capab.p (INPUT {&CAPAB_IDXMAX}, OUTPUT cmax).
max_flds = INTEGER(cmax).

/* Determine if the word indexed and abbreviated fields should be sensitive.
   They will be if there are any character fields in this table. */
find FIRST _Field of x_File where _Field._Data-Type = "Character" NO-ERROR.
if NOT AVAILABLE _Field then
   char_fld = no.

/* Run time layout for button area.  Since this is a shared frame we have 
   to avoid doing this code more than once.
*/
if frame newidx:private-data <> "alive" then
do:
   frame newidx:private-data = "alive".

   {adecomm/okrun.i  
      &FRAME = "frame newidx" 
      &BOX   = "s_rect_Btns"
      &OK    = "s_btn_OK" 
      &HELP  = "s_btn_Help"
   }

   /* So Return doesn't hit default button in editor widget. */
   b_Index._Desc:RETURN-INSERT in frame newidx = yes.
end.

/*
   Explicitly disable based on these conditions in case these were
   sensitive from the last time round.  Then conditionally enable (using
   ENABLE verb) below to make sure the TAB order comes out right.
*/
if NOT (char_fld AND INDEX(capab, {&CAPAB_WORD_INDEX}) > 0) then
   s_Idx_Word:sensitive in frame newidx = no.
if NOT char_fld then
   s_Idx_Abbrev:sensitive in frame newidx = no.

s_Status = "".
display s_Status with frame newidx. /* erases val from the last time */
s_btn_Done:label in frame newidx = "Cancel".

enable b_Index._Index-Name   
       idx-area-name when idx-area-name <> "N/A"
       s_btn_Idx_Area when idx-area-name <> "N/A"
       b_Index._Desc
       s_Idx_Primary
       b_Index._Active
       b_Index._Unique
       s_Idx_Word    	when char_fld AND INDEX(capab, {&CAPAB_WORD_INDEX}) > 0
       s_Idx_Abbrev   when char_fld
       s_lst_IdxFldChoice
       s_btn_IdxFldAdd
       s_btn_OK
       s_btn_Add
       s_btn_Done
       s_btn_Help
       with frame newidx.

/* Since we will be enabling/disabling various widgets as the user adds/deletes
   fields from the index, and since we don't want to ENABLE all widgets up
   front (and then immediately disable them), we can't rely on enable to 
   set the TAB order properly.  Reset the tab position for all un-enabled
   widgets which may become sensitized as user users the frame.
*/
assign
   s_Res = s_lst_Idx_Area:move-after-tab-item
      	       (s_btn_Idx_Area:handle in frame newidx) in frame newidx
   s_Res = s_btn_IdxFldRmv:move-after-tab-item 
      	       (s_btn_IdxFldAdd:handle in frame newidx) in frame newidx
   s_Res = s_btn_IdxFldDwn:move-after-tab-item 
      	       (s_btn_IdxFldRmv:handle in frame newidx) in frame newidx
   s_Res = s_btn_IdxFldUp:move-after-tab-item 
      	       (s_btn_IdxFldDwn:handle in frame newidx) in frame newidx
   s_Res = s_lst_IdxFlds:move-after-tab-item 
      	       (s_btn_IdxFldUp:handle in frame newidx) in frame newidx
   s_Res = s_IdxFld_AscDesc:move-after-tab-item 
      	       (s_lst_IdxFlds:handle in frame newidx) in frame newidx
   .

/* Each add will be a subtransaction */
s_OK_Hit = no.
add_subtran:
repeat ON ERROR UNDO,LEAVE  ON ENDKEY UNDO,LEAVE  ON STOP UNDO, LEAVE:
   /* Do this up top here, to be sure we committed the last create */
   if s_OK_Hit then leave add_subtran.

   if added AND s_btn_Done:label in frame newidx <> "Close" then
      s_btn_Done:label in frame newidx = "Close".

   create b_Index.
   num_flds = 0.

   /* Have to display all fields, so on 2nd or 3rd add, any entered values
      will be cleared. */
   assign
      s_Idx_Primary = no
      b_Index._Active = yes
      b_Index._Unique = no
      s_Idx_Word = no
      s_IdxFld_AscDesc = "A"
      s_Idx_Abbrev = no.

   /* Clear and refill the field list in the appropriate sort order */
   s_lst_IdxFldChoice:LIST-ITEMS in frame newidx = "".
   s_lst_IdxFldChoice:private-data in frame newidx = "".
   run adedict/_getflst.p
      (INPUT   s_lst_IdxFldChoice:HANDLE in frame newidx,
       INPUT   s_TblRecId, 
       INPUT   ?,
       INPUT   (if s_Order_By = {&ORDER_ALPHA} then true else false),
       INPUT   "",
       INPUT   "BLOB,CLOB,XLOB",
       INPUT   0,
       INPUT   "",
       OUTPUT  access).
   if NOT access then undo add_subtran, leave add_subtran.

   assign
      /* Keep a comma separated list of the original contents of this list.
      	 Keep it in private data since if we put it in a regular variable
      	 we run out of variable space when the database is very big.  
      	 Private data is in different data space.
      */
      s_lst_IdxFldChoice:private-data in frame newidx = 
      	 s_lst_IdxFldChoice:LIST-ITEMS in frame newidx
      all_cnt = NUM-ENTRIES(s_lst_IdxFldChoice:private-data in frame newidx)
      s_lst_IdxFlds:LIST-ITEMS in frame newidx = "" /* clear the list */
   
      /* Reset sensitiveness of widgets */
      s_lst_IdxFlds:sensitive in frame newidx = false
      s_btn_IdxFldAdd:sensitive in frame newidx = true
      s_btn_IdxFldRmv:sensitive in frame newidx = false
      s_btn_IdxFldDwn:sensitive in frame newidx = false
      s_btn_IdxFldUp:sensitive in frame newidx = false.

   display "" @ b_Index._Index-Name /* blank instead of ? */
           idx-area-name
      	   s_Idx_Primary
       	   b_Index._Active
       	   b_Index._Unique
       	   s_Idx_Word
      	   s_Idx_Abbrev
      	   s_lst_IdxFldChoice
      	   s_lst_IdxFlds
      	   s_IdxFld_AscDesc
       	   b_Index._Desc
       with frame newidx.

   /* Set selection to first item in list of fields */
   s_lst_IdxFldChoice:screen-value in frame newidx =
      s_lst_IdxFldChoice:entry(1) in frame newidx.

   wait-for choose of s_btn_OK in frame newidx,
      	              s_btn_Add in frame newidx OR
      	    GO of frame newidx
      	    FOCUS b_Index._Index-Name in frame newidx.
end.

/* Reset private data to free memory - it could be big */
s_lst_IdxFldChoice:private-data in frame newidx = "".

hide frame newidx.
return.







/*********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights*
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _saveidx.p

Description:
   Save any changes the user made in the index property window. 

Returns: "error" if the save is not complete for any reason, otherwise "".

Author: Laura Stern

Date Created: 07/14/92

History:
    04/19/96    tomn        Added rowid support for multi-component indexes. 
    12/09/94    gfs         Added check and warning if user wants non-unique index
                            for RECID support.
    08/26/94    gfs         Added Recid index support.
    
    11/16/07    fernando    Support for _aud-audit-data* indexes deactivation

----------------------------------------------------------------------------*/


&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adedict/IDX/idxvar2.i shared}
{adedict/IDX/idxvar.i shared}

Define var oldname   as char CASE-SENSITIVE NO-UNDO.
Define var newname   as char CASE-SENSITIVE NO-UNDO.
Define var active    as logical             NO-UNDO.
Define var answer    as logical 	          NO-UNDO.
Define var no_name   as logical 	          NO-UNDO.
Define var ins_name  as char                NO-UNDO.
Define var nxtname   as char   	          NO-UNDO.
Define var fordb     as logical             NO-UNDO. /* foreign db? y/n */
Define var warnmsg   as character           NO-UNDO.
Define var warnflg   as char                NO-UNDO.
Define var choice    as logical init no     NO-UNDO.
Define var l_ifldcnt as integer             NO-UNDO.

DEFINE BUFFER bfr_Index FOR _Index.

current-window = s_win_Idx.

IF s_dbCache_type[s_dbCache_ix] <> "PROGRESS" THEN fordb = yes.
ELSE fordb = no.

if input frame idxprops s_Idx_Primary AND
   b_Index._Wordidx <> 0 AND b_Index._Wordidx <> ? then
do:
   message "An index that is word-indexed" SKIP
           "cannot be the primary index."
   	    view-as ALERT-BOX ERROR  buttons OK.
   return "error".
end.

/* Check if name is blank and return if it is */
run adedict/_blnknam.p
   (INPUT b_Index._Index-Name:HANDLE in frame idxprops,
    INPUT "index", OUTPUT no_name).
if no_name then return "error".

assign
  oldname = b_Index._Index-Name
  newname = input frame idxprops b_Index._Index-Name.

do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
   run adecomm/_setcurs.p ("WAIT").  

   /* Do old/new name check in case name is "default".  If we try to 
      assign it Progress will complain. */
   if oldname <> newname then
      b_Index._Index-Name = newname.
 
   if b_Index._Desc:sensitive in frame idxprops then
      ASSIGN input frame idxprops b_Index._Desc.

   if s_Idx_Primary:sensitive in frame idxprops then
      ASSIGN input frame idxprops s_Idx_Primary.

   ASSIGN input frame idxprops ActRec.
      
  IF NOT fordb THEN ASSIGN 
      active = input frame idxprops ActRec. /* formerly b_Index._Active */

   if b_Index._Unique:sensitive in frame idxprops then
      assign
      	 input frame idxprops b_Index._Unique.

   if s_Idx_Primary then
   do:
      /* Make the index primary.  If it already was, so, it still is. */
      find _File where RECID(_File) = s_TblRecId.
      _File._Prime-Index = RECID(b_Index).
   end.
   
   if NOT active AND b_Index._Active AND NOT fordb then
   do:
      answer = yes.  /* set's yes as default button */
      message "If you make this index inactive, the only way to" SKIP
   	      "to reactivate it is to run proutil." SKIP(1) 
   	      "Are you sure you want to deactivate it?"
   	      view-as ALERT-BOX INFORMATION  buttons YES-NO UPDATE answer.
      if answer then
      	 ASSIGN b_Index._Active = no
      	        ActRec = no.
      else
      	 display ActRec with frame idxprops.  /* resets toggle */
   end.

   IF fordb and substring(b_index._I-Misc2[1],1,1) <> "r" AND 
        INPUT FRAME idxprops ActRec = TRUE THEN
   DO:
      /* user wants to make this a recid index */
      FIND _File OF b_Index.

      assign
        l_ifldcnt = 0
        warnflg   = "nnn"
        warnmsg   = "".

      for each _Index-field of b_Index, _Field of _Index-field:
        /* warn the user if there are concerns about doing this! */
        l_ifldcnt = l_ifldcnt + 1.  /* count index fields */

        IF    b_Index._I-misc2[1]   = "u"
          AND b_Index._Unique       = TRUE
          AND _Field._Mandatory     = TRUE
          AND SUBSTR(warnflg, 1, 1) = "n"  /* hasn't already been set by previous index field */
         THEN ASSIGN
               warnmsg = warnmsg +
                         "The precision or scale of index field allows values incorrect for ROWID-Index."
                         + chr(10)
               SUBSTR(warnflg, 1, 1) = "ynn".
        
        IF b_Index._Unique = FALSE
          AND SUBSTR(warnflg, 2, 1) = "n"  /* hasn't already been set by previous index field */
         THEN ASSIGN
               warnmsg = warnmsg +
                         "This index is not Unique - Your application has to take care of that."
                         + chr(10)
               SUBSTR(warnflg, 2, 1) = "y".

        IF _Field._Mandatory = FALSE
          AND SUBSTR(warnflg, 3, 1) = "n"  /* hasn't already been set by previous index field */
         THEN ASSIGN
               warnmsg = warnmsg +
                         "Index field is not Mandatory - Your application has to take care of that."
                         + chr(10)
               SUBSTR(warnflg, 3, 1) = "y".
      end.  /* for each */        

      ASSIGN
        warnmsg = warnmsg + "Are you sure you want to make this the index for ROWID support?"
        choice  = no.
      MESSAGE warnmsg VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE choice.

      IF choice THEN DO: /* Yes, user wants to do it! */
        FIND FIRST bfr_Index of _File WHERE bfr_Index._I-misc2[1] begins "r" 
          EXCLUSIVE-LOCK NO-ERROR. /* existing Recid index */

        IF s_dbCache_type[s_dbCache_ix] = "ORACLE"
          THEN ASSIGN
                b_Index._I-misc2[1] = "r" + b_Index._I-misc2[1]
                _File._Fil-misc1[4] = _Field._Fld-stoff.
                                   /*----- ODBC -----*/
          ELSE IF l_ifldcnt > 1 OR _Field._For-type <> "INTEGER"
            THEN ASSIGN
                  b_Index._I-misc2[1] = "r" + b_Index._I-misc2[1]
                  _File._Fil-misc1[2] = b_Index._idx-num  /* rowid info */
                  _File._Fil-misc1[1] = ?                 /* recid      */
                  _File._Fil-misc2[3] = ?.                /*  info      */
            ELSE ASSIGN
                  b_Index._I-misc2[1] = "r" + b_Index._I-misc2[1]
                  _File._Fil-misc1[2] = b_Index._idx-num                   /* rowid info */
                  _File._Fil-misc1[1] = _Field._Fld-stoff * -1             /* recid      */
                  _File._Fil-misc2[3] = ( IF    _Field._Fld-misc2[3] <> ?  /*  info      */
                                           THEN _Field._Fld-misc2[3] 
                                           ELSE _Field._For-name ).
        IF AVAILABLE bfr_Index
          THEN ASSIGN
                bfr_Index._I-misc2[1] = substring(bfr_Index._I-misc2[1], 2).
      END.

      ELSE DO: /* user said no, so set it back to off and stay in screen*/
        ASSIGN ActRec = no.
        DISPLAY ActRec WITH FRAME idxprops.
        RUN adecomm/_setcurs.p ("").
        RETURN "error".
      END.
   END.
   
   if oldname <> newname then
   do:
      /* If name was changed change the name in the browse list.
	 If there's more than one index, delete and re-insert to
	 make sure the new name is in alphabetical order.
      */
      if s_lst_Idxs:NUM-ITEMS in frame browse > 1 then
      do:
	 s_Res = s_lst_Idxs:delete(oldname) in frame browse.

      	 /* put name in non-case-sensitive variable for search */
      	 ins_name = newname.  
      	 find FIRST _Index where _Index._File-recid = s_TblRecId AND
     	     	      	      	 _Index._Index-Name > ins_name 
      	    NO-ERROR.

      	 nxtname = (if AVAILABLE _Index then _Index._Index-name else "").
	 run adedict/_newobj.p
	    (INPUT s_lst_Idxs:HANDLE in frame browse,
	     INPUT ins_name,
	     INPUT nxtname,
	     INPUT s_Idxs_Cached,
	     INPUT {&OBJ_IDX}).
      end.
      else do:
      	 /* Change name in place in browse window list. */
      	 {adedict/repname.i
      	    &OldName = oldname
   	    &NewName = newname
   	    &Curr    = s_CurrIdx
      	    &Fill    = s_IdxFill
   	    &List    = s_lst_Idxs}
      end.
   end.
   
   {adedict/setdirty.i &Dirty = "true"}.
   display "Index Modified" @ s_Status with frame idxprops.
   run adecomm/_setcurs.p ("").   
   return "".
end.

run adecomm/_setcurs.p ("").
return "error".

/**********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

/*----------------------------------------------------------------------------

File: idxprop.f

Description:   
   This file contains the form for showing index properties.

Author: Laura Stern

Date Created: 04/29/92
     History: 03/26/98 D. McMann Added Area name 
              06/08/06 fernando   Support for large keys
----------------------------------------------------------------------------*/

&IF "{&WINDOW-SYSTEM}" begins "MS-WIN" &THEN
   &global-define  lbl_col  4.5
   &global-define  lst_col  4.0
&ELSE
   &global-define  lbl_col  7.5
   &global-define  lst_col  7.0
&ENDIF

/* Note: both the declarations for b_Index buffer and the browser on the
   temp-table query have been moved into the .f file to emphasize the
   importance that they all be declared NEW SHARED at the same time.  This
   was not always the case and it was the cause of a major bug.  (Any
   dictionary bug is a major bug.)     DRH 4/32/97                       */
Define {1} buffer b_Index for DICTDB._Index. 

define {1} browse b-idx-list query q-idx-list 
       display fld-nam column-label "Field Name" 
               fld-typ column-label "Field Type"
               asc-desc column-label "A(SC)/!D(esc)"
       with 7 down width 65.

form
   SKIP({&TFM_WID})

   b_Index._Index-Name label "Index &Name"     colon 13  {&STDPH_FILL}
   SKIP({&VM_WID})
   idx-area-name   label "Area" colon 13 
   SKIP({&VM_WID})
   b_Index._Desc       label "Descri&ption"    colon 13
                       view-as EDITOR SCROLLBAR-VERTICAL
      	       	       INNER-CHARS 52 INNER-LINES 2  {&STDPH_EDITOR}
   SKIP({&VM_WIDG})

   s_Idx_Primary     	label "Pri&mary"       at  2
      	       	     	view-as TOGGLE-BOX     SPACE({&HM_WIDG})
   ActRec       	label "Ac&tive"         
      	       	     	view-as TOGGLE-BOX     SPACE({&HM_WIDG})
   b_Index._Unique 	label "Uni&que"         
      	       	     	view-as TOGGLE-BOX     SPACE({&HM_WIDG})
   s_Idx_Word           label "&Word Index"     
                        view-as TOGGLE-BOX     SPACE({&HM_WIDG})
   s_Idx_Abbrev         label "A&bbreviated"     
      	       	     	view-as TOGGLE-BOX 
   SKIP({&VM_WIDG})
  
   b-idx-list           at 7
   
   SKIP(.25)
   s_msg NO-LABEL      format "x(50)" at  7 view-as TEXT 
   SKIP(.25)
   s_Status            NO-LABEL format "x(55)" at  2
                       view-as TEXT 

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = yes
      &OK     = s_btn_OK
      &CANCEL = s_btn_Save
      &OTHER  = "SPACE({&HM_DBTN}) s_btn_Close 
                 SPACE({&HM_DBTNG}) s_btn_Prev SPACE({&HM_DBTN}) s_btn_Next"
      &HELP   = s_btn_Help}

   with frame idxprops
      default-button s_btn_OK cancel-button s_btn_Close
      SIDE-LABELS NO-BOX.

/**********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

/*----------------------------------------------------------------------------

File: idxvar.i

Description:   
   Include file which defines the user interface components and related data
   for the add index dialog box.
 
Arguments:
   {1} - this is either "new shared" or "shared".

Author: Laura Stern

Date Created:  04/22/92 
     History:  03/26/98 D. McMann Added support for Areas
               06/08/06 fernando  Support for large keys
----------------------------------------------------------------------------*/
Define {1} frame newidx.    /* new index dialog box */
Define {1} frame idxprops.  /* index properties */

	   
/* The variables needed for both add and properties - we also use the 
   b_Index record buffer. */
Define {1} var s_Idx_Primary as logical NO-UNDO.
Define {1} var s_Idx_Abbrev  as logical NO-UNDO.
Define {1} var s_Idx_Word    as logical NO-UNDO.  
Define {1} var s_lst_IdxFlds as char    NO-UNDO. 
Define {1} var index-area-number as integer format ">>>9" INIT 6 NO-UNDO.

/* variables used for Area name select for creating new indexes */
Define {1} var idx-area-name as character format "x(32)" NO-UNDO.
Define button  s_btn_Idx_Area IMAGE-UP FILE "btn-down-arrow".
Define {1} var s_lst_Idx_Area as char view-as  SELECTION-LIST SINGLE   
   INNER-CHARS 32 INNER-LINES 5 SCROLLBAR-VERTICAL.



/* Variables needed for the add index dialog only. */
Define {1} var s_lst_IdxFldChoice as char NO-UNDO.

Define button s_btn_IdxFldAdd label "&Add >>"     SIZE 15 by 1.125.
Define button s_btn_IdxFldRmv label "<< &Remove"  SIZE 15 by 1.125.
Define button s_btn_IdxFldDwn label "Move &Down"  SIZE 15 by 1.125.
Define button s_btn_IdxFldUp  label "Move &Up"    SIZE 15 by 1.125.

Define {1} var s_IdxFld_AscDesc as char NO-UNDO
   view-as radio-set horizontal
   radio-buttons "A&scending", "A", "D&escending", "D".

/* Variables needed for index properties only. */
Define {1} var s_txt_List_Labels as char NO-UNDO extent 2.
Define {1} var ActRec as logical no-undo view-as toggle-box.
DEFINE {1} VAR s_msg AS CHAR NO-UNDO.

/* These are the forms for the index properties and new index windows. */
{adedict/IDX/idxprop.f "{1}"}
{adedict/IDX/newidx.f}



/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: idxvar2.i

Description:   
   Browser Needed for the IDX properties screen
Arguments:
   {1} - this is either "new shared" or "shared".

Author: Kathy Kelley

Date Created: 12/03/96 
----------------------------------------------------------------------------*/

Define {1} temp-table idx-list
            Field fld-nam as character format "x(32)"
            field fld-typ as character format "x(20)"
            field asc-desc as character format "x(1)"
            field comp-seq as integer
        INDEX comp-seq AS PRIMARY comp-seq.

define {1} buffer b_idx-list for idx-list.
define {1} query q-idx-list for b_idx-list scrolling.




/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: newidx.f

Description:   
   This file contains the form for adding an index.

Author: Laura Stern

Date Created: 04/22/92
    Modified: 03/26/98 DLM Added Area Support
----------------------------------------------------------------------------*/


form
   SKIP({&TFM_WID})
 
  b_Index._Index-Name 	label "Index &Name"  colon 20 {&STDPH_FILL}
   SKIP({&VM_WID})
   idx-area-name label "Area"  colon 20  s_btn_Idx_Area
   SKIP({&VM_WID})
   b_Index._Desc        label "Descri&ption" colon 20
      	       	     	view-as EDITOR SCROLLBAR-VERTICAL
      	       	     	SIZE 46 BY 2                 {&STDPH_EDITOR}
   SKIP({&VM_WIDG})

   s_Idx_Primary     	label "Pri&mary"    at 9 
      	       	     	view-as TOGGLE-BOX  SPACE({&HM_WIDG})
   b_Index._Active   	label "Ac&tive" 	    
      	       	     	view-as TOGGLE-BOX  SPACE({&HM_WIDG})
   b_Index._Unique 	label "Uni&que"      
      	       	     	view-as TOGGLE-BOX  SPACE({&HM_WIDG})
   s_Idx_Word           label "&Word Index"  
                        view-as TOGGLE-BOX  SPACE({&HM_WIDG})
   s_Idx_Abbrev         label "A&bbreviated"     
      	       	     	view-as TOGGLE-BOX 
   SKIP({&VM_WIDG})

   "Select field to add to index:":t33   	    at 2
                        view-as TEXT                               
   "New Index's Fields:":t25 		    at 51
                        view-as TEXT                               
   SKIP

   s_lst_IdxFldChoice 	NO-LABEL      	    at 2
                        view-as SELECTION-LIST SINGLE 
                        INNER-CHARS 25 INNER-LINES 12
                        SCROLLBAR-V SCROLLBAR-H        
   
   s_lst_IdxFlds     	NO-LABEL       	    at 51 
                        view-as SELECTION-LIST SINGLE 
                        INNER-CHARS 28 INNER-LINES 12     
                        SCROLLBAR-V SCROLLBAR-H       
   SKIP({&VM_WID})

   s_IdxFld_AscDesc	NO-LABEL            at 51
   SKIP(.1)

   s_Status             NO-LABEL            at 2
                        format "x(50)" view-as TEXT 

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = yes
      &OK     = s_btn_OK
      &CANCEL = s_btn_Add /* where cancel button usually goes */
      &OTHER  = "SPACE({&HM_DBTN}) s_btn_Done"
      &HELP   = s_btn_Help}

   s_btn_IdxFldAdd   	      	       	     at col 33 row 8 SKIP({&VM_WID})
   s_btn_IdxFldRmv   	      	       	     at     33       SKIP({&VM_WIDG})
   s_btn_IdxFldDwn                           at     33       SKIP({&VM_WID})
   s_btn_IdxFldUp                            at     33

   s_lst_Idx_Area      NO-LABEL                at col 1 row 1

   with frame newidx
      default-button s_btn_Add cancel-button s_btn_Done
      SIDE-LABELS SCROLLABLE THREE-D
      TITLE "Create Index" view-as DIALOG-BOX.




/**********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

/*----------------------------------------------------------------------------

File: _newseq.p

Description:
   Display and handle the add sequence dialog box and then add the sequence
   if the user presses OK.

Author: Laura Stern

Date Created: 02/20/92 
    Modified: 07/14/98 D. McMann Added _Owner to _file finds.
              05/25/06 fernando  Support for 64-bit sequences

----------------------------------------------------------------------------*/


&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adedict/SEQ/seqvar.i shared}
{adedict/capab.i}

DEFINE VAR added     AS LOGICAL NO-UNDO INIT no.
Define var capab     AS CHAR    NO-UNDO.
DEFINE VAR l       AS LOGICAL   NO-UNDO.
DEFINE VAR cTemp   AS CHARACTER NO-UNDO.

/*-------------------------------Triggers------------------------------------*/

/* Triggers shared by create and edit triggers */
{adedict/SEQ/seqtrig.i &frame = "frame newseq"}


/*----- HIT of OK BUTTON -----*/
on choose of s_btn_OK in frame newseq
   s_OK_Hit = yes.
   /* The GO trigger will fire after this. */


/*----- HIT of OK or ADD (auto-go) -----*/
on GO of frame newseq 
do:
   run adedict/SEQ/_saveseq.p
      (b_Sequence._Seq-name:HANDLE in frame newseq,
       input frame newseq b_Sequence._Seq-Incr,
       input frame newseq s_Seq_Limit,
       b_Sequence._Seq-Init:HANDLE in frame newseq,
       input frame newseq b_Sequence._Cycle-Ok).

   if RETURN-VALUE = "error" then
   do:
      s_OK_Hit = no.
      return NO-APPLY.
   end.
   else added = yes.
end.


/*-----WINDOW-CLOSE-----*/
on window-close of frame newseq
   apply "END-ERROR" to frame newseq.


/*----- HELP -----*/
on HELP of frame newseq OR choose of s_btn_Help in frame newseq
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Create_Sequence_Dlg_Box}, ?).

/*----------------------------Mainline code----------------------------------*/

find _File WHERE _File._File-name = "_Sequence"
             AND _File._Owner = "PUB" NO-LOCK.
             
if NOT can-do(_File._Can-create, USERID("DICTDB")) then
do:
   message s_NoPrivMsg "create sequences."
      view-as ALERT-BOX ERROR buttons Ok.
   return.
end.

/* Get gateway capabilities */
run adedict/_capab.p (INPUT {&CAPAB_SEQ}, OUTPUT capab).

if INDEX(capab, {&CAPAB_ADD}) = 0 then
do:
   message "You may not add a sequence definition for this database type."
      view-as ALERT-BOX ERROR buttons OK.
   return.
end.

/* what type of sequence */
s_Seq_Type = s_DbCache_Type[s_DbCache_ix].

IF s_Large_Seq = NO THEN
   ASSIGN s_Large_Seq_info = "** 64-bit sequences support not enabled".
ELSE /* if yes or ? */
   ASSIGN s_Large_Seq_info = "".

/* Run time layout for button area.  Since this is a shared frame we have 
   to avoid doing this code more than once.
*/
if frame newseq:private-data <> "alive" then
do:
   frame newseq:private-data = "alive".

   {adecomm/okrun.i  
      &FRAME = "frame newseq" 
      &BOX   = "s_rect_Btns"
      &OK    = "s_btn_OK" 
      &HELP  = "s_btn_Help"
   }
end.

/* Erases value from the last time.  */
s_Status = "".
display s_Status s_Large_Seq_info with frame newseq.
s_btn_Done:label in frame newseq = "Cancel".

/* Note: the order of enables will govern the TAB order. */
enable b_Sequence._Seq-Name  b_Sequence._Seq-Init  b_Sequence._Seq-Incr
       s_Seq_Limit   	     b_Sequence._Cycle-Ok
       s_btn_OK
       s_btn_Add     	     
       s_btn_Done
       s_btn_Help
       with frame newseq.

/* adjust the format if 64-bit sequence support is not turned on */
IF s_Large_Seq NE YES THEN DO:
    /* don't resize the fill-in */
    IF s_Seq_Limit:AUTO-RESIZE IN FRAME newseq THEN
       ASSIGN s_Seq_Limit:AUTO-RESIZE IN FRAME newseq = NO
              b_Sequence._Seq-Ini:AUTO-RESIZE IN FRAME newseq = NO
              b_Sequence._Seq-Incr:AUTO-RESIZE IN FRAME newseq = NO.

    ASSIGN s_Seq_Limit:FORMAT IN FRAME newseq = "->,>>>,>>>,>>9"
           b_Sequence._Seq-Init:FORMAT IN FRAME newseq = "->,>>>,>>>,>>9" 
           b_Sequence._Seq-Incr:FORMAT IN FRAME newseq = "->,>>>,>>>,>>9".
END.

/* Each add will be a subtransaction */
s_OK_Hit = no.
add_subtran:
repeat ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE  ON STOP UNDO, LEAVE:
   /* Do this up top here, to be sure we committed the last create */
   if s_OK_Hit then leave add_subtran.

   if added AND s_btn_Done:label in frame newseq <> "Close" then
      s_btn_Done:label in frame newseq = "Close".

   create b_Sequence.

   assign
      s_Seq_Limit:label in frame newseq = "&Upper Limit"
      s_Seq_Limit = ?.

   display "" @ b_Sequence._Seq-Name  /* blank instead of ? */
      	   b_Sequence._Seq-Init  
      	   b_Sequence._Seq-Incr
           s_Seq_Limit           
      	   b_Sequence._Cycle-Ok 

	   (IF INDEX(capab,{&CAPAB_OWNER})    = 0 
             then "n/a" else b_Sequence._Seq-misc[2]) @ b_Sequence._Seq-misc[2]

	   (IF INDEX(capab,{&CAPAB_FOR_NAME}) = 0 
             then "n/a" else b_Sequence._Seq-misc[1]) @ b_Sequence._Seq-misc[1]
           IF INDEX(s_Seq_Type,"ORACLE") = 0 then "n/a" ELSE IF 
             b_Sequence._Seq-misc[8] = ? THEN "<Local-Db>" ELSE
             b_Sequence._Seq-misc[8] @ b_Sequence._Seq-misc[8]

      	   with frame newseq.

   wait-for choose of s_btn_OK, s_btn_Add in frame newseq OR
      	    GO of frame newseq
      	    FOCUS b_Sequence._Seq-Name in frame newseq.
end.

hide frame newseq.
return.





/**********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

/*----------------------------------------------------------------------------

File: _saveseq.p

Description:
   Save any changes the user made in the new sequence or sequence property 
   window.

Input Parameters:
   p_NameHdl - Widget handle of sequence name field in frame
   p_Incr    - New frame value of increment
   p_Limit   - New frame value of limit
   p_Init    - Widget handle of initial value in frame
   p_Cycle   - New frame value of cycle

Returns: "error" if the save is not complete for any reason, otherwise "".

Author: Laura Stern

Date Created: 10/19/92
History:  D. McMann 08/08/02 Eliminated any sequences whose name begins "$" - Peer Direct
          fernando  05/25/06 Added support for large sequences

----------------------------------------------------------------------------*/

&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adedict/SEQ/seqvar.i shared}

Define INPUT PARAMETER p_NameHdl as widget-handle NO-UNDO.
Define INPUT PARAMETER p_Incr 	 as int64  	  NO-UNDO.
Define INPUT PARAMETER p_Limit   as int64       NO-UNDO.
Define INPUT PARAMETER p_Init    as widget-handle NO-UNDO.
Define INPUT PARAMETER p_Cycle   as logical   	  NO-UNDO.

Define var incr     as INT64 NO-UNDO.
Define var limit    as INT64 NO-UNDO.
Define var initval  as INT64 NO-UNDO.
Define var cycle    as logical NO-UNDO.
Define var oldname  as char    NO-UNDO CASE-SENSITIVE.
Define var newname  as char    NO-UNDO CASE-SENSITIVE.
Define var no_name  as logical NO-UNDO.
Define var stat     as char    NO-UNDO init "error".

/*=============================Internal Procedures=========================*/

/* Add the new or renamed sequence to the browse window list */
PROCEDURE Add_to_List:
   Define INPUT PARAMETER p_name   as char NO-UNDO.  /* name to insert */
   Define var  	     	  ins_name as char NO-UNDO.
   
   find FIRST _Sequence where _Sequence._Db-recid = s_DbRecId AND
                          NOT _Sequence._Seq-name BEGINS "$"  AND
     	     	      	      _Sequence._Seq-Name > p_name 
      NO-ERROR.

   ins_name = (if AVAILABLE _Sequence then _Sequence._Seq-name else "").
   run adedict/_newobj.p
      (INPUT s_lst_Seqs:HANDLE in frame browse,
       INPUT p_name,
       INPUT ins_name,
       INPUT s_Seqs_Cached,
       INPUT {&OBJ_SEQ}).
end.


/*==============================Mainline Code=============================*/

if NOT s_Adding then current-window = s_win_Seq.
run adedict/_blnknam.p (INPUT p_NameHdl, INPUT "sequence", OUTPUT no_name).
if no_name then return "error".

initval = INT64(P_Init:screen-value).

if p_Incr > 0 then
do:
   if p_Limit <= initval then
   do:
      message "The upper limit must be greater than the initial value."
   	      view-as ALERT-BOX ERROR buttons OK.
      apply "entry" to p_Init.
      return "error".
   end.
end.
else /* p_Incr < 0 */
do:
   if p_Limit >= initval then
   do:
      message "The lower limit must be less than the initial value."
   	       view-as ALERT-BOX ERROR buttons OK.
      apply "entry" to p_Init.
      return "error".
   end.
end.

if NOT s_Adding then
   oldname = b_Sequence._Seq-Name.
newname = p_NameHdl:screen-value.

do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
   run adecomm/_setcurs.p ("WAIT").
   if s_Adding then 
      assign
      	 b_Sequence._Db-recid = s_DbRecId.

   assign
      b_Sequence._Seq-Name = newname
      b_Sequence._Seq-Init = initval
      b_Sequence._Seq-Incr = p_Incr
      b_Sequence._Cycle-Ok = p_Cycle
      s_Seq_Limit = p_Limit.

   if p_Incr > 0 then
      assign
   	 b_Sequence._Seq-Min = initval
   	 b_Sequence._Seq-Min = ?
   	 b_Sequence._Seq-Max = p_Limit.
   else  
      assign
   	 b_Sequence._Seq-Min = p_Limit
   	 b_Sequence._Seq-Max = ?
   	 b_Sequence._Seq-Max = initval.

   /* Make adjustments to browse and edit windows. */
   if s_Adding then
      run Add_to_List (INPUT b_Sequence._Seq-Name).
   else do:
      if oldname <> newname then
      do:
	 /* If name was changed change the name in the browse list.
	    If there's more than one sequence, delete and re-insert to
	    make sure the new name is in alphabetical order.
	 */
	 if s_lst_Seqs:NUM-ITEMS in frame browse > 1 then
	 do:
	    s_Res = s_lst_Seqs:delete(oldname) in frame browse.
      	    run Add_to_List (INPUT newname).
      	 end.
      	 else do:
	    /* Change name in place in browse window list. */
	    {adedict/repname.i
	       &OldName = oldname
	       &NewName = newname
	       &Curr    = s_CurrSeq
	       &Fill    = s_SeqFill
	       &List    = s_lst_Seqs}  
      	 end.
      end.  
   end.
   
   /* This assures that the record buffer will be flushed.  Without
      this, Progress can't find current value of sequence (which currently 
      we don't access in the dictionary but we might.)
   */
   if s_Adding then
      release b_Sequence.

   {adedict/setdirty.i &Dirty = "true"}.
   if s_Adding then
      display "Sequence Created" @ s_Status with frame newseq. 
   else
      display "Sequence Modified" @ s_Status with frame seqprops.
   stat = "".  /* success (not "error") */
end.

run adecomm/_setcurs.p ("").
return stat.




/**********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

/*----------------------------------------------------------------------------

File: _seqprop.p

Description:
   Display the sequence properties for editing.

Author: Laura Stern

Date Created: 02/21/92 
    Modified: 07/14/98 D. McMann Added _Owner to _file finds.
              05/25/06 fernando  Support for 64-bit sequences    
----------------------------------------------------------------------------*/


&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/uivar.i shared}
{adedict/SEQ/seqvar.i shared}
{adedict/capab.i}

Define var capab  AS CHAR NO-UNDO.
DEFINE VAR l       AS LOGICAL   NO-UNDO.
DEFINE VAR cTemp   AS CHARACTER NO-UNDO.

/*----------------------------Mainline code----------------------------------*/

/* Get the sequence type */
s_Seq_Type = s_DbCache_Type[s_DbCache_ix].  

find _File WHERE _File._File-name = "_Sequence"
             AND _File._Owner = "PUB" NO-LOCK.
             
if NOT can-do(_File._Can-read, USERID("DICTDB")) then
do:
   message s_NoPrivMsg "see sequence definitions."
      view-as ALERT-BOX ERROR buttons Ok in window s_win_Browse.
   return.
end.

/* Get gateway capabilities */
run adedict/_capab.p (INPUT {&CAPAB_SEQ}, OUTPUT capab).


if LENGTH(capab) = 0 then
do:
   message "Sequences are not supported for this database type."
      view-as ALERT-BOX ERROR buttons OK.
   return.
end.

/* check if this db supports 64-bit sequences. Just care about s_Large_Seq really.
*/
/* dbs running with pre-10.01B servers will have no knowledge of large key entries
   support, so don't need to display message (in which case s_Large_Seq = ?)
*/
IF s_Large_Seq = NO THEN
   ASSIGN s_Large_Seq_info = "** 64-bit sequences support not enabled".
ELSE /* if YES or ? */
   ASSIGN s_Large_Seq_info = "".

/* Don't want Cancel if moving to next seq - only when window opens */
if s_win_Seq = ? then
   s_btn_Close:label in frame seqprops = "Cancel".

/* Open the window if necessary */
run adedict/_openwin.p
   (INPUT   	  "Sequence Properties",
    INPUT   	  frame seqprops:HANDLE,
    INPUT         {&OBJ_SEQ},
    INPUT-OUTPUT  s_win_Seq).

/* Run time layout for button area. Since this is a shared frame we 
   have to avoid doing this code more than once.
*/
if frame seqprops:private-data <> "alive" then
do:
   /* okrun.i widens frame by 1 for margin */
   assign
      s_win_Seq:width = s_win_Seq:width + 1
      frame seqprops:private-data = "alive".

   {adecomm/okrun.i  
      &FRAME = "frame seqprops" 
      &BOX   = "s_rect_Btns"
      &OK    = "s_btn_OK" 
      &HELP  = "s_btn_Help"
   }
end.

/* Find the _Sequence record to edit. */
find b_Sequence where b_Sequence._Seq-Name = s_CurrSeq AND 
     b_Sequence._Db-recid = s_DbRecId.

/* Set the limit value to the upper or lower limit depending on if increment
   is positive or negative. */
if b_Sequence._Seq-Incr > 0 then
   assign
      s_Seq_Limit = b_Sequence._Seq-Max
      s_Seq_Limit:label in frame seqprops = "&Upper Limit".
else
   assign
      s_Seq_Limit = b_Sequence._Seq-Min
      s_Seq_Limit:label in frame seqprops = "&Lower Limit".

/* adjust the format if 64-bit sequences support is not turned on, or not
   available (s_large_seq will be ? in that case)
*/
IF s_Large_Seq NE YES THEN DO:
    /* don't resize the fill-in */
    IF s_Seq_Limit:AUTO-RESIZE IN FRAME seqprops THEN
       ASSIGN s_Seq_Limit:AUTO-RESIZE IN FRAME seqprops = NO
              b_Sequence._Seq-Ini:AUTO-RESIZE IN FRAME seqprops = NO
              b_Sequence._Seq-Incr:AUTO-RESIZE IN FRAME seqprops = NO.

    ASSIGN s_Seq_Limit:FORMAT IN FRAME seqprops = "->,>>>,>>>,>>9"
           b_Sequence._Seq-Ini:FORMAT IN FRAME seqprops = "->,>>>,>>>,>>9" 
           b_Sequence._Seq-Incr:FORMAT IN FRAME seqprops = "->,>>>,>>>,>>9".
END.

/* find current value for Progress db only*/
IF INDEX(capab,{&CAPAB_FOR_NAME}) = 0 THEN DO:
   /* if the sequence was just created and not saved yet, the above statement will fail */
   s_Seq_Current_Value = TRIM(STRING(DYNAMIC-CURRENT-VALUE(s_CurrSeq, s_CurrDb),"->,>>>,>>>,>>>,>>>,>>>,>>9")) NO-ERROR.
   IF ERROR-STATUS:ERROR THEN
       s_Seq_Current_Value = "".
END.
ELSE 
    s_Seq_Current_Value = "n/a".

/* Set status line */
display "" @ s_Status s_Large_Seq_info with frame seqprops. /* clears from last time */

s_Seq_ReadOnly = (s_ReadOnly OR s_DB_ReadOnly).
if NOT s_Seq_ReadOnly then
   if NOT can-do(_File._Can-write, USERID("DICTDB")) then
   do:
      display s_NoPrivMsg + " modify sequence definitions." @ s_Status
      	 with frame seqprops.
      s_Seq_ReadOnly = true.
   end.

display b_Sequence._Seq-Name  b_Sequence._Seq-Init    b_Sequence._Seq-Incr
        s_Seq_Limit 	      b_Sequence._Cycle-Ok
        s_Seq_Current_Value
        (IF INDEX(capab,{&CAPAB_OWNER})    = 0 
          then "n/a" else b_Sequence._Seq-misc[2]) @ b_Sequence._Seq-misc[2]
        (IF INDEX(capab,{&CAPAB_FOR_NAME}) = 0 
          then "n/a" else b_Sequence._Seq-misc[1]) @ b_Sequence._Seq-misc[1]
	IF INDEX(s_Seq_Type,"ORACLE") = 0 then "n/a" ELSE IF 
             b_Sequence._Seq-misc[8] = ? THEN "<Local-Db>" ELSE
             b_Sequence._Seq-misc[8] @ b_Sequence._Seq-misc[8]
        
        with frame seqprops.

/* Note: the order of enables will govern the TAB order. */
if s_Seq_ReadOnly then
do:
   disable all except
	  s_btn_Close
	  s_btn_Prev
	  s_btn_Next
	  s_btn_Help
	  with frame seqprops.
   enable s_btn_Close
	  s_btn_Prev
	  s_btn_Next
	  s_btn_Help
	  with frame seqprops.
   apply "entry" to s_btn_Close in frame seqprops.
end.
else do:
   enable b_Sequence._Seq-Name WHEN  INDEX(capab,{&CAPAB_RENAME}) <> 0
          b_Sequence._Seq-Init WHEN  INDEX(capab,{&CAPAB_MODIFY}) <> 0
          b_Sequence._Seq-Incr WHEN  INDEX(capab,{&CAPAB_MODIFY}) <> 0
	  s_Seq_Limit          WHEN  INDEX(capab,{&CAPAB_MODIFY}) <> 0
	  b_Sequence._Cycle-Ok WHEN  INDEX(capab,{&CAPAB_MODIFY}) <> 0
	  s_btn_OK             WHEN (INDEX(capab,{&CAPAB_MODIFY}) <> 0
	                         OR  INDEX(capab,{&CAPAB_RENAME}) <> 0)	      	  
	  s_btn_Save           WHEN (INDEX(capab,{&CAPAB_MODIFY}) <> 0
	                         OR  INDEX(capab,{&CAPAB_RENAME}) <> 0)	      	  
          s_btn_Close
      	  s_btn_Prev 	      
      	  s_btn_Next
      	  s_btn_Help
	  with frame seqprops.

   apply "entry" to b_Sequence._Seq-Name in frame seqprops.
end.









/**********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

/*----------------------------------------------------------------------------

File: seqprop.f

Description:   
   This file contains the form for adding and editing sequences.

Arguments:
   &frame_phrase - this should be a frame phrase for the frame that we want
                   to associate this form with. e.g., "frame foo OVERLAY".
   &apply_btn    - The apply button (e.g., Save or Create)
   &other_btns   - phrase for layout of other default buttons
   &col1         - column for lining up the colons
   &col2         - column for other stuff
   &prop         - only defined for sequence properties
 
Author: Laura Stern

Date Created: 02/20/92 
    Modified: 05/25/06 fernando   Support for large sequences

----------------------------------------------------------------------------*/


form
   SKIP({&TFM_WID})

   b_Sequence._Seq-Name	   label "Sequence &Name"   colon {&col1} {&STDPH_FILL}
   SKIP({&VM_WID})

   b_Sequence._Seq-Init	   label "Initial &Value"   format "->,>>>,>>>,>>>,>>>,>>>,>>9"
                                                    colon {&col1} {&STDPH_FILL}
   SKIP({&VM_WID})

   b_Sequence._Seq-Incr    label "&Increment by"    format "->,>>>,>>>,>>>,>>>,>>>,>>9"
                                                    colon {&col1} {&STDPH_FILL}
   SKIP({&VM_WID})

   s_Seq_Limit 	     	   label "&Upper Limit"	    format "->,>>>,>>>,>>>,>>>,>>>,>>9"
                                                    colon {&col1} {&STDPH_FILL}
   SKIP({&VM_WID})

   b_Sequence._Cycle-Ok    label "C&ycle at Limit?" at    {&col2}
      	       	     	   view-as toggle-box                
   SKIP({&VM_WID})
   
&if defined(prop) &then
    s_Seq_Current_Value    label "Current Value" format "X(30)" colon {&col1} {&STDPH_FILL}
    SKIP({&VM_WID})
&endif

   b_Sequence._Seq-misc[1] label "&DataServer Name" colon {&col1} {&STDPH_FILL}
   format "x(32)" SKIP({&VM_WID})

   b_Sequence._Seq-misc[2] label "&Owner"	    colon {&col1} {&STDPH_FILL}

   b_Sequence._Seq-misc[8]  label "DB &Link"        colon {&col1}  
                        format "x(21)"                       {&STDPH_FILL}
   
   s_Large_Seq_info        no-label format "X(40)" at 2 
   SKIP(.25)           
   s_Status                NO-LABEL format "x(50)"  at    2 
                           view-as TEXT 
   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = yes
      &OK     = s_btn_OK
      &CANCEL = {&apply_btn}
      &OTHER  = "{&other_btns}"
      &HELP   = s_btn_Help}
   
   with {&frame_phrase} SIDE-LABELS.








/**********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

/*----------------------------------------------------------------------------

File: seqtrig.i

Description:
   Triggers for add or modify Sequence.  This is in an include file so
   that we can have the same code that works on different frames, one for
   the add case and one for the modify case.

Argument:
   {&frame} - then name of the frame that we're working with.  This will be
      	      of the form "frame x".

Author: Laura Stern

Date Created: 02/21/92 
    Modified: 05/25/06 fernando   Support for large sequences

----------------------------------------------------------------------------*/

/*----- LEAVE of INCREMENT -----*/
on leave of b_Sequence._Seq-Incr in frame newseq,
      	    b_Sequence._Seq-Incr in frame seqprops
do:
   Define var incr as int64 NO-UNDO.
   Define var incr_i as INT NO-UNDO.

   incr = input {&frame} b_Sequence._Seq-Incr.
   if incr = 0 then
   do:
      if NOT s_Adding then current-window = s_win_Seq.
      message "Increment can be negative or positive but not 0."
      	       view-as ALERT-BOX ERROR
      	       buttons OK.
      s_Valid = no.
      return NO-APPLY.
   end.

   if incr < 0 then 
   do:
      /* this check avoids flashing */
      if s_Seq_Limit:label in {&frame} <> "Lower Limit" then
      	 s_Seq_Limit:label in {&frame} = "&Lower Limit".
   end.
   else do: 
      if s_Seq_Limit:label in {&frame} <> "Upper Limit" then 
      	 s_Seq_Limit:label in {&Frame} = "&Upper Limit".
   end.

   /* s_Large_Seq can be ? for pre-10.1B dbs */
   IF s_Large_Seq NE YES THEN DO:
       /* try to cast it to an int, and display the message generated
          by the client
       */
       ASSIGN incr_i = incr NO-ERROR.

       IF ERROR-STATUS:ERROR THEN DO:
           MESSAGE ERROR-STATUS:GET-MESSAGE(1)
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
           RETURN NO-APPLY.
       END.
   END.
end.

ON LEAVE OF b_Sequence._Seq-Init in frame newseq,
      	    b_Sequence._Seq-Init in frame seqprops
DO:
   Define var incr as INT NO-UNDO.

   /* s_Large_Seq can be ? for pre-10.1B dbs */
   IF s_Large_Seq NE YES THEN DO:
   
       /* try to cast it to an int, and display the message generated
          by the client
       */
       incr = input {&frame} b_Sequence._Seq-Init NO-ERROR.

       IF ERROR-STATUS:ERROR THEN DO:
           MESSAGE ERROR-STATUS:GET-MESSAGE(1)
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
           RETURN NO-APPLY.
       END.
   END.
END.

ON LEAVE OF s_Seq_Limit in frame newseq,
      	    s_Seq_Limit in frame seqprops
DO:
   Define var incr as INT NO-UNDO.

   /* s_Large_Seq can be ? for pre-10.1B dbs */
   IF s_Large_Seq NE YES THEN DO:
       /* try to cast it to an int, and display the message generated
          by the client
       */
       ASSIGN incr = input {&frame} s_Seq_Limit NO-ERROR.
    
       IF ERROR-STATUS:ERROR THEN DO:
           MESSAGE ERROR-STATUS:GET-MESSAGE(1)
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
           RETURN NO-APPLY.
       END.
   END.
END.
/**********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

/*----------------------------------------------------------------------------

File: seqvar.i

Description:   
   Include file which defines the user interface components for the add
   sequence and edit sequence forms.
 
Arguments:
   {1} - this is either "new shared" or "shared".

Author: Laura Stern

Date Created: 02/20/92 
    Modified: 05/25/06 fernando   Support for large sequences

----------------------------------------------------------------------------*/


Define {1} buffer b_Sequence  for DICTDB._Sequence.

Define {1} frame newseq.    /* for adding a new sequence */
Define {1} frame seqprops.  /* sequence properties */
Define {1} var s_Seq_Type     as   char                      NO-UNDO. 
Define {1} var s_Seq_Limit    like DICTDB._Sequence._Seq-max NO-UNDO.
DEFINE {1} VAR s_Large_Seq_info    AS CHAR                   NO-UNDO.
DEFINE {1} VAR s_Seq_Current_Value AS CHAR                   NO-UNDO.

/* This is the form for the seqprops and newseq windows. */
&IF "{&WINDOW-SYSTEM}" begins "MS-WIN" &THEN
   {adedict/SEQ/seqprop.f  
      &frame_phrase = "frame seqprops NO-BOX 
       default-button s_btn_OK cancel-button s_btn_Close"
      &apply_btn  = s_btn_Save
      &other_btns = "SPACE({&HM_DBTN}) s_btn_Close SPACE({&HM_DBTNG}) 
     s_btn_Prev SPACE({&HM_DBTN}) s_btn_Next"
      &col1 = 19
      &col2 = 21
      &prop = 1
   }
&ENDIF

{adedict/SEQ/seqprop.f  
   &frame_phrase = "frame newseq view-as DIALOG-BOX TITLE ""Create Sequence""
                 default-button s_btn_Add cancel-button s_btn_Done"
   &apply_btn  = s_btn_Add
   &other_btns = "SPACE({&HM_DBTN}) s_btn_Done"
   &col1 = 19
   &col2 = 21
}



/***********************************************************************
* Copyright (C) 2000,2006-2008 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/*----------------------------------------------------------------------------

File: _newtbl.p

Description:
   Display and handle the add table dialog box and then add the table
   if the user presses OK.

   Note: Currently only Progress files added through this code.
   All others are created via a gateway utility.  However, this is
   is set up to work for all gateways. 

Author: Laura Stern

Date Created: 03/13/92

History:
Added _Owner to _File finds D. McMann 07/14/98
Added support of Area names D. McMann 03/25/98
Modified on 12/07/94 by gfs - added support for ODBC
Modified on 07/08/94 by gfs - Bug 94-06-14-177 (again)
Modified on 07/07/94 by gfs - Bug 94-06-14-177
Mario B 12/28/98 Add s_In_Schema_Area enabling one time notification.
DLM      05/15/00 Removed warning message if only Schema Area in DB
Donna M. 04/23/02 Added assignment of new table recid variable 
10/01/02 DLM Changed check for SQL tables
fernando 09/27/06 Use different delimiter for area name combo-box - 20051228-008
fernando 06/26/08 Removed encryption area from list
----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/TBL/tblvar.i shared}
{adedict/capab.i}


DEFINE VARIABLE capab  AS CHARACTER            NO-UNDO.
DEFINE VARIABLE added  AS LOGICAL   INITIAL no NO-UNDO.
DEFINE VARIABLE isodbc AS LOGICAL   INITIAL no NO-UNDO.
DEFINE VARIABLE num    AS INTEGER              NO-UNDO.
DEFINE VARIABLE curr_type as CHARACTER         NO-UNDO.
DEFINE VARIABLE ans AS LOGICAL NO-UNDO.

/*===============================Triggers====================================*/

/*-----WINDOW-CLOSE-----*/
on window-close of frame newtbl
   apply "END-ERROR" to frame newtbl.


/*----- HIT of OK BUTTON -----*/
on choose of s_btn_OK in frame newtbl
   s_OK_Hit = yes.
   /* The GO trigger will fire after this. */


/*----- HIT of OK BUTTON or ADD BUTTON or GO -----*/
on GO of frame newtbl	/* or buttons - because they're auto-go */
do:
   Define var no_name  as logical NO-UNDO.
   Define var nxtname  as char    NO-UNDO.

   run adedict/_blnknam.p
      (INPUT b_File._File-name:HANDLE in frame newtbl,
       INPUT "table", OUTPUT no_name).
   if no_name then do:
      s_OK_Hit = no.  /* in case ok was hit */
      return NO-APPLY.
   end.
 
   IF NOT s_In_Schema_Area THEN DO:
     APPLY "LEAVE" TO s_Tbl_Area.
     IF NOT ans THEN DO:
        s_OK_Hit = no.  /* in case ok was hit */
        APPLY "ENTRY" TO s_Tbl_Area.
        return NO-APPLY.
     END.
   END.       

   do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      run adecomm/_setcurs.p ("WAIT").
    
      IF NOT s_Show_Hidden_Tbls AND input frame newtbl b_File._Hidden THEN DO:
            ASSIGN MENU-ITEM mi_Show_Hidden:CHECKED in MENU s_mnu_View = TRUE.
            APPLY "VALUE-CHANGED" TO MENU-ITEM mi_Show_Hidden in MENU s_mnu_View.
      END.

      ASSIGN b_File._DB-recid = s_DbRecId
             input frame newtbl b_File._File-name 
	         input frame newtbl b_File._Dump-Name
	         input frame newtbl b_File._Hidden
	         input frame newtbl b_File._For-Size
      	     input frame newtbl b_File._File-label
	         input frame newtbl b_File._Desc
             input frame newtbl b_File._Fil-misc2[6]
             n_tblrecid = RECID(b_File).
      
      FIND _Area WHERE _Area._Area-name = input frame newtbl s_Tbl_Area NO-LOCK.
      ASSIGN b_File._ianum = _Area._Area-num
             s_Tbl_Area = input frame newtbl s_tbl_area.
             
      if s_Tbl_Type:sensitive in frame newtbl then
      	 b_File._For-type = input frame newtbl s_Tbl_Type.
      if b_File._For-name:sensitive in frame newtbl then
      	 b_File._For-name = input frame newtbl b_File._For-name.
      
      /* For ODBC databases, the file's foreign type is "BUFFER"*/
      
      IF isodbc AND b_File._For-Name = ? AND b_File._For-Owner = ? THEN 
         ASSIGN 
            b_file._For-Type = "BUFFER" 
            b_File._For-Name = "NONAME".

      /* Add entry to tables list in alphabetical order */

      if s_Show_hidden_Tbls OR NOT b_File._Hidden then
      do:
      	 {adedict/TBL/nexttbl.i &Name = b_File._File-Name  
      	       	     	      	&Next = nxtname}
	 run adedict/_newobj.p
	    (INPUT s_lst_Tbls:HANDLE in frame browse,
	     INPUT b_File._File-name,
	     INPUT nxtname,
	     INPUT s_Tbls_Cached,
	     INPUT {&OBJ_TBL}).
      end.

      {adedict/setdirty.i &Dirty = "true"}.
      display "Table Created" @ s_Status with frame newtbl.
      added = yes.
      run adecomm/_setcurs.p ("").
      return.
   end.

   /* We only get here if an error occurred. Dialog box should remain
      on the screen so return NO-APPLY. */  
   run adecomm/_setcurs.p ("").
   s_OK_Hit = no.
   return NO-APPLY.  
end.


/*----- LEAVE of CREATE BUTTON -----*/
on LEAVE of s_btn_Add in frame newtbl
   display "" @ s_Status with frame newtbl. /* clear status line */


/*----- HELP -----*/
on HELP of frame newtbl OR choose of s_btn_Help in frame newtbl
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Create_Table_Dlg_Box}, ?).

/* ------on leave of s_Tbl_Area ----*/
ON LEAVE OF s_Tbl_Area in frame newtbl 
do:
  ASSIGN ans = FALSE.
  IF NOT s_In_Schema_Area AND num > 1 THEN DO:
    IF INPUT FRAME newtbl s_Tbl_Area = "Schema Area" THEN DO:
      MESSAGE "Progress Software Corporation does not recommend" SKIP
              "creating user tables in the Schema Area."  Skip(1)
              "Should tables be created in this area?" SKIP (1)
              VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE ans .
      IF ans THEN
        ASSIGN s_In_Schema_Area = TRUE.        
      ELSE DO:
        ASSIGN s_In_Schema_Area = TRUE.
        RETURN NO-APPLY.
      END.
    END.
    ASSIGN ans = TRUE.
  END.
  ELSE IF NOT s_In_Schema_Area AND INPUT FRAME newtbl s_Tbl_Area = "Schema Area" THEN DO:
    MESSAGE "Progress Software Corporation does not recommend" SKIP
            "putting user tables into the Schema Area. " SKIP (1)
            "See the System Administration Guide on how to" SKIP
            "create data areas." SKIP (1)
            VIEW-AS ALERT-BOX WARNING.
    ASSIGN s_In_Schema_Area = TRUE
           ans          = TRUE.
  END. 
  ELSE
    ASSIGN ans = TRUE.       
END.  
        
/*============================Mainline code==================================*/

find _File WHERE _File._File-name = "_File"
             AND _File._Owner = "PUB" NO-LOCK.
             
if NOT can-do(_File._Can-create, USERID("DICTDB")) then
do:
   message s_NoPrivMsg "create tables."
      view-as ALERT-BOX ERROR buttons Ok.
   return.
end.

/* Get gateway capabilities */
run adedict/_capab.p (INPUT {&CAPAB_TBL}, OUTPUT capab).

if INDEX(capab, {&CAPAB_ADD}) = 0 then
do:
   message "You may not add a table definition for this database type."
      view-as ALERT-BOX ERROR buttons OK.
   return.
end.

/* Get ODBC types in case this is an ODBC db */
odbtyp = { adecomm/ds_type.i
           &direction = "ODBC"
           &from-type = "odbtyp"}.
           
/* See if this db is an ODBC db */      
IF CAN-DO(odbtyp, s_DbCache_Type[s_DbCache_ix]) THEN ASSIGN isodbc = yes.

/* Since this is a shared frame we have to avoid doing this code more
   than once.
*/
if frame newtbl:private-data <> "alive" then
do:
   frame newtbl:private-data = "alive".

   /* Run time layout for button area.  This defines eff_frame_width */
   {adecomm/okrun.i  
      &FRAME = "frame newtbl" 
      &BOX   = "s_rect_Btns"
      &OK    = "s_btn_OK" 
      &HELP  = "s_btn_Help"
   }
   
   /* So Return doesn't hit default button in editor widget. */
   b_File._Desc:RETURN-INSERT in frame newtbl = yes.
   
   /* runtime adjustment of "Optional" title band to the width of the frame */
   s_optional:width-chars in frame newtbl = eff_frame_width - ({&HFM_WID} * 2).
end.

/* Erase any status from the last time */
s_Status = "".
display s_Status with frame newtbl.
s_btn_Done:label in frame newtbl = "Cancel".

s_Tbl_Type = s_DbCache_Type[s_DbCache_ix].

/* 20051228-008 - use other delimiter in case area name has comma */
s_lst_file_Area:DELIMITER in frame newtbl = CHR(1).

s_lst_file_area:list-items in frame newtbl = "".
FIND FIRST DICTDB._Area WHERE DICTDB._Area._Area-num > 6 
                          AND DICTDB._Area._Area-type = 6 AND
                    NOT CAN-DO({&INVALID_AREAS}, DICTDB._AREA._Area-name)  NO-LOCK NO-ERROR.
IF AVAILABLE DICTDB._Area THEN
  ASSIGN s_Tbl_Area = DICTDB._AREA._Area-name.
ELSE DO:
  FIND DICTDB._Area WHERE DICTDB._Area._Area-num = 6 NO-LOCK.
  ASSIGN s_Tbl_Area = DICTDB._AREA._Area-name
         s_In_Schema_Area = TRUE.
END.  
  
for each DICTDB._Area  FIELDS (_Area-num _Area-type _Area-name)
            WHERE DICTDB._Area._Area-num > 6 
               AND DICTDB._Area._Area-type = 6 
               AND NOT CAN-DO({&INVALID_AREAS}, DICTDB._AREA._Area-name) NO-LOCK:
  s_res = s_lst_file_Area:add-last(DICTDB._Area._Area-name) in frame newtbl.
END.

FIND DICTDB._Area WHERE DICTDB._Area._Area-num = 6 NO-LOCK.
  ASSIGN s_res = s_lst_file_Area:add-last(DICTDB._Area._Area-name) in frame newtbl.
  
num = s_lst_File_Area:num-items in frame newtbl.
s_Lst_File_Area:inner-lines in frame newtbl = (if num <= 5 then num else 5).  
 assign
      s_Tbl_Area:font  in frame newtbl = 0
      s_lst_File_Area:font in frame newtbl = 0
      s_Tbl_Area:width  in frame newtbl = 38
      s_lst_File_Area:width in frame newtbl = 38.

{adecomm/cbdrop.i &Frame  = "frame newtbl"
      	       	  &CBFill = "s_Tbl_area"
      	       	  &CBList = "s_lst_File_Area"
      	       	  &CBBtn  = "s_btn_File_area"
     	       	  &CBInit = """"}


/* cbtdrop.i is included in edittrig.i because of non-modal-ness. */
      {adecomm/cbcdrop.i &Frame  = "frame newtbl"
		         &CBFill = "s_Tbl_area"
		         &CBList = "s_lst_File_Area"
		     	 &CBBtn  = "s_btn_File_Area"
		     	 &CBInit = "curr_type"}

/* Each add will be a subtransaction */
s_OK_Hit = no.
add_subtran:
repeat ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE  ON STOP UNDO, LEAVE:
   /* Do this up top here, to be sure we committed the last create */
   if s_OK_Hit then leave add_subtran.

   if added AND s_btn_Done:label in frame newtbl <> "Close" then
      s_btn_Done:label in frame newtbl = "Close".

   create b_File.
   
/* moved enable statement to behind the create statement to avoid */
/* problems with buffer b_File <hutegger, 94/02/03> */
/* Note: the order of enables will govern the TAB order. */

   enable   
       b_File._File-Name
       s_Tbl_Area
       s_btn_File_area
       b_File._Dump-Name
       b_File._Hidden
       s_Tbl_Type          when INDEX(capab, {&CAPAB_TBL_TYPE_ADD}) > 0
       b_File._File-label
       b_File._Desc
       b_File._Fil-misc2[6]
       b_File._For-Size	   when INDEX(capab, {&CAPAB_CHANGE_TBL_SIZE}) > 0
       b_file._For-Name	   when INDEX(capab, {&CAPAB_CHANGE_FOR_NAME}) > 0
       s_btn_Tbl_Triggers
       s_btn_Tbl_Validation
       s_btn_Tbl_StringAttrs
       s_btn_OK
       s_btn_Add
       s_btn_Done
       s_btn_Help
       with frame newtbl.

assign s_Res = s_lst_File_Area:move-after-tab-item
      	       (s_btn_File_Area:handle in frame newtbl) in frame newtbl.

   /* Have to display all fields, so on 2nd or 3rd add, any entered values
      will be cleared. */
   display "" @ b_File._File-Name   /* display blank instead of ? */
           s_Tbl_Area
           s_btn_File_Area
           s_optional
      	   s_Tbl_Type
      	   "" @ b_File._Dump-Name
      	   b_File._Hidden
      	   b_File._Frozen
      	   b_File._File-label
      	   b_File._Desc
           b_File._Fil-misc2[6]
      	   b_File._For-Size when INDEX(capab, {&CAPAB_TBL_SIZE}) > 0

      	   (if INDEX(capab, {&CAPAB_FOR_NAME}) = 0 then
      	       "n/a"
      	    else
      	       b_File._For-Name
      	   ) @ b_File._For-Name

      	   (if INDEX(capab, {&CAPAB_OWNER}) = 0 then
      	       "n/a"
      	    else
      	       b_File._For-Owner
      	   ) @ b_File._For-Owner
 
          /* Display oracle dist. db status */
       
             IF INDEX(s_Tbl_Type,"ORACLE") = 0 then "n/a" ELSE IF 
             b_File._Fil-misc2[8] = ? THEN "<Local-Db>" ELSE
             b_File._Fil-misc2[8] @ b_File._Fil-misc2[8]
             
      	   with frame newtbl.

   wait-for choose of s_btn_OK, s_btn_Add in frame newtbl OR
      	    GO of frame newtbl
      	    FOCUS b_File._File-Name in frame newtbl.
end.
     

hide frame newtbl.

if s_OK_Hit then /* but not Create */
      apply "choose" to MENU-ITEM mi_Crt_Field in MENU s_mnu_Create.
return.


/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _savetbl.p

Description:
   Save any changes the user made in the table property window. 

Returns: "error" if the save is not complete for any reason, otherwise "".

Author: Laura Stern

Date Created: 07/14/92
    Modified: D. McMann 06/29/98 Added _Owner to _File find

----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adedict/TBL/tblvar.i shared}

Define var oldname  as char CASE-SENSITIVE NO-UNDO.
Define var newname  as char CASE-SENSITIVE NO-UNDO.
Define var junk     as logical       	   NO-UNDO.
Define var no_name  as logical 	       	   NO-UNDO.
Define var cnt      as integer             NO-UNDO.
Define var oldhid   as logical             NO-UNDO.
Define var nxtname  as char                NO-UNDO.
Define var ins_name as char                NO-UNDO.

current-window = s_win_Tbl.

/* Check if name is blank and return if it is */
run adedict/_blnknam.p
   (INPUT b_File._File-Name:HANDLE in frame tblprops,
    INPUT "table", OUTPUT no_name).
if no_name then return "error".

assign
   oldname = b_File._File-Name
   newname = input frame tblprops b_File._File-Name
   oldhid  = b_File._Hidden.

do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
   run adecomm/_setcurs.p ("WAIT").

   /* Any sub-dialog changes (e.g., triggers)  have already been saved.  
      We just need to move main property values into buffer. */
   assign
      b_File._File-Name = newname
      input frame tblprops b_File._Dump-Name
      input frame tblprops b_File._Hidden
      input frame tblprops b_File._For-Size
      input frame tblprops b_File._File-label
      input frame tblprops b_File._Desc
      input frame tblprops b_File._Fil-misc2[6].

   if b_File._For-Name:sensitive in frame tblprops then
      b_File._For-Name = input frame tblprops b_File._For-Name.
   if s_Tbl_Type:sensitive in frame tblprops then
      b_File._For-type = input frame tblprops s_Tbl_Type.
  
   if NOT oldhid AND b_File._Hidden AND NOT s_Show_Hidden_Tbls then
   do:
      /* If hidden was changed to yes, and Show_Hidden flag is off, 
      	 remove the table from the browse window table list. */
      run adecomm/_delitem.p (INPUT s_lst_Tbls:HANDLE in frame browse, 
      	       	     	     INPUT oldname, OUTPUT cnt).
      apply "value-changed" to s_lst_Tbls in frame browse.
      if cnt = 0 then
      	 /* If this was the last item in the list, the browse window and menu
      	    may need some adjusting. */
      	 run adedict/_brwadj.p (INPUT {&OBJ_TBL}, INPUT cnt).
   end.
   else if oldhid AND NOT b_File._Hidden AND NOT s_Show_Hidden_Tbls then
   do:
      /* If hidden was changed to no and Show_Hidden flag is off,
      	 add table to the browse list.  This can only happen if the
      	 table was changed to hidden and then changed back
      	 before switching to any other table.
      */
      find FIRST _File where _File._Db-recid = s_DbRecId AND
			     _File._File-Name > b_File._File-name AND
			     (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN") AND
      	       	     	     NOT _File._Hidden
	       	     	     NO-ERROR.
      
      nxtname = (if AVAILABLE _File then _File._File-name else "").
      run adedict/_newobj.p
      	 (INPUT s_lst_Tbls:HANDLE in frame browse,
	  INPUT b_File._File-name,
	  INPUT nxtname,
	  INPUT s_Tbls_Cached,
	  INPUT {&OBJ_TBL}).
   end.
   else if oldname <> newname AND 
      	NOT (b_File._Hidden AND NOT s_Show_Hidden_Tbls) then
   do:
      /* If name was changed and the table is currently showing 
      	 change the name in the browse list.
         If there's more than one table, delete and re-insert to
      	 make sure the new name is in alphabetical order.
      */
      if s_lst_Tbls:NUM-ITEMS in frame browse > 1 then
      do:
       	 s_Res = s_lst_Tbls:delete(oldname) in frame browse.

      	 /* Put in non case-sensitive variable for next search. */
      	 ins_name = newname.  
      	 {adedict/TBL/nexttbl.i &Name = ins_name
      	       	     	      	&Next = nxtname}
      	 run adedict/_newobj.p
	    (INPUT s_lst_Tbls:HANDLE in frame browse,
	     INPUT ins_name,
	     INPUT nxtname,
	     INPUT s_Tbls_Cached,
	     INPUT {&OBJ_TBL}).
      end.
      else do:
	 /* Change name in place in browse window list */
	 {adedict/repname.i
	    &OldName = oldname
	    &NewName = newname
	    &Curr    = s_CurrTbl
	    &Fill    = s_TblFill
   	    &List    = s_lst_Tbls}
      end.
   end.

   {adedict/setdirty.i &Dirty = "true"}.
   /* If we just made the last table hidden, the property sheet may be
      gone (from brwadj.p)!  So we'd better check before doing this.
   */
   if s_win_Tbl <> ? then
      display "Table modified" @ s_Status with frame tblprops.
   run adecomm/_setcurs.p ("").
   return "".
end.

run adecomm/_setcurs.p ("").
return "error".



/***********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/*----------------------------------------------------------------------------

File: _tblprop.p

Description:
   Display table properties for the current table in the edit window.

Author: Laura Stern

Date Created: 03/16/92
    Modified: 01/19/98 DLM Added display of s_Tbl_Area for _ianum
                           or N/A for dataserver tables.
              03/26/98 DLM Changed area number to area name for display
              04/20/98 DLM changed logic to find area based on storageobject
                           instead of _file ianum.
              04/22/98 DLM Changed how to know to display "NA" for area.  
              05/05/98 DLM Changed find for _area 98-05-05-054   
              06/05/98 DLM Changed find for _area again 98-06-05-015  
              07/10/98 DLM Added _Owner check on _File.     
              05/19/99 Mario B.  Adjust Width Field browser integration.
              08/16/00 DLM Added _db-recid to StorageObject find 20000815029
              10/01/02 DLM Changed check for SQL tables
              10/12/06 fernando Don't show DataServer button if Progress table
----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES

/* copied from prodict/users/uservar.i */
&GLOBAL-DEFINE PRO_DISPLAY_NAME OpenEdge

{adedict/dictvar.i shared}
{adedict/uivar.i shared}
{adedict/TBL/tblvar.i shared}
{adedict/capab.i}


/*----------------------------Mainline code----------------------------------*/

Define var name_editable    as logical     NO-UNDO.
Define var capab            as char        NO-UNDO.
Define var junk	            as logical     NO-UNDO.
Define var junk-i           as integer     NO-UNDO.

find _File WHERE _File._File-name = "_File"
             AND _File._Owner = "PUB"
             NO-LOCK.
if NOT can-do(_File._Can-read, USERID("DICTDB")) then
do:
   message s_NoPrivMsg "see table definitions."
      view-as ALERT-BOX ERROR buttons Ok in window s_win_Browse.
   return.
end.

/* Don't want Cancel if moving to next table - only when window opens */
if s_win_Tbl = ? then
   s_btn_Close:label in frame tblprops = "Cancel".

/* Open the window if necessary */
run adedict/_openwin.p
   (INPUT   	  "Table Properties",
    INPUT   	  frame tblprops:HANDLE,
    INPUT         {&OBJ_TBL},
    INPUT-OUTPUT  s_win_Tbl).

/* Run Graying because Adjust Width Browse can't co-exist with this code */
RUN adedict/_brwgray.p (INPUT NO).

/* Run time layout for button area.  This defines eff_frame_width.
   Since this is a shared frame we have to avoid doing this code more
   than once.
*/
if frame tblprops:private-data <> "alive" then
do:
   /* okrun.i widens frame by 1 for margin */
   assign
      frame tblprops:private-data = "alive"
      s_win_Tbl:width = s_win_Tbl:width + 1.  

   {adecomm/okrun.i  
      &FRAME = "frame tblprops" 
      &BOX   = "s_rect_Btns"
      &OK    = "s_btn_OK" 
      &HELP  = "s_btn_Help"
   }

   /* So Return doesn't hit default button in editor widget */
   b_File._Desc:RETURN-INSERT in frame tblprops = yes.

   /* runtime adjustment of "Optional" title band to the width of the frame */
   s_Optional:width-chars in frame tblprops = eff_frame_width - 
      	       	     	      	       	      ({&HFM_WID} * 2).
end.

/* Get the record for the selected table */
find b_File where RECID(b_File) = s_TblRecId.

/* Get gateway capabilities */
run adedict/_capab.p (INPUT {&CAPAB_TBL}, OUTPUT capab).

/* Figure out what the table type is */
s_Tbl_Type =
   (
   if b_File._Db-lang >= {&TBLTYP_SQL} then
      "{&PRO_DISPLAY_NAME}/SQL"
   else if b_File._File-Number >= {&TBLNUM_FASTTRK_START} AND
      	   b_File._File-Number <= {&TBLNUM_FASTTRK_END} then
      "FAST TRACK Schema"
   else if b_File._File-Number < 0 then  /* all other negative numbers */
      "{&PRO_DISPLAY_NAME} Schema"
   else if INDEX(capab, {&CAPAB_TBL_TYPE_MOD}) = 0 then
      /* Only concat on gateway name if user can't change the type */
      s_DbCache_Type[s_DbCache_ix] + " " /* gateway type */
   else ""
   ) + 
   (
   if b_File._For-Type = ? then
      ""
   else 
      b_File._For-Type
   ).

/* Count the number of indexes this table has */
s_Tbl_IdxCnt = 0.
for each _Index of b_File:
   s_Tbl_IdxCnt = s_Tbl_IdxCnt + 1.
end.


/* ORACLE and ODBC allows Indexes to be selected for RowID-support
   If the current _Db is of one of these types, we move the three
   standard-buttons to the left and make the ds-button visible.
   Otherwise, we move the three buttons to there centered position
   and make sure the DataServer button is invisible
*/
do with frame tblprops:

   assign
      junk   = can-do(odbtyp + ",ORACLE",s_DbCache_Type[s_DbCache_ix])
      junk-i = frame tblprops:width-pixels
             - frame tblprops:border-left-pixels
             - frame tblprops:border-right-pixels
             - s_btn_Tbl_Triggers:width-pixels
             - s_btn_Tbl_Validation:width-pixels
             - s_btn_Tbl_StringAttrs:width-pixels
             - ( if junk
                  then s_btn_Tbl_ds:width-pixels
                  else 0
               )
      junk-i = junk-i
             / ( if junk
                  then 5
                  else 4
               )
      s_btn_Tbl_Triggers:x      = junk-i
      s_btn_tbl_Validation:x    = junk-i 
                                + s_btn_Tbl_Triggers:x
                                + s_btn_Tbl_Triggers:width-pixels
      s_btn_tbl_StringAttrs:x   = junk-i 
                                + s_btn_Tbl_Validation:x
                                + s_btn_Tbl_Validation:width-pixels
      s_btn_tbl_ds:width-pixels = ( if junk
                                     then s_btn_Tbl_Triggers:width-pixels
                                     else 1
                                  )
      s_btn_tbl_ds:x            = ( if junk
                                     then junk-i 
                                      + s_btn_Tbl_StringAttrs:x
                                      + s_btn_Tbl_StringAttrs:width-pixels
                                     else 1
                                  ) 
      s_btn_Tbl_ds:hidden       = NOT junk.
  end.  /* do with frame tblprops */


/* Set the status line */
display "" @ s_Status with frame tblprops. /* clears from last time */

s_Tbl_ReadOnly = (s_DB_ReadOnly OR s_ReadOnly).
if NOT s_Tbl_ReadOnly then
do:
   if NOT can-do(_File._Can-write, USERID("DICTDB")) then
   do:
      display s_NoPrivMsg + " modify table definitions." @ s_Status
      	 with frame tblprops.
      s_Tbl_ReadOnly = true.
   end.
   else if b_File._Frozen then
   do:
      display "Note: This table is frozen and cannot be modified." @ s_Status
      	 with frame tblprops.
      s_Tbl_ReadOnly = true.
   end.
   ELSE IF b_File._Db-lang > {&TBLTYP_SQL} THEN DO:
      DISPLAY "Note: {&PRO_DISPLAY_NAME}/SQL92 table, cannot be modified." @ s_Status
           WITH FRAME tblprops.
       ASSIGN s_tbl_Readonly = TRUE.
   END.
end.

IF b_File._For-type <> ? THEN
  ASSIGN s_Tbl_Area = "N/A".
ELSE DO:
  IF b_File._File-number <> ? THEN DO:
    FIND _StorageObject WHERE _StorageObject._Db-recid = b_File._Db-recid
                          AND _StorageObject._Object-type = 1
                          AND _StorageObject._Object-number = b_File._File-number
                          NO-LOCK NO-ERROR.
    IF AVAILABLE _StorageObject THEN                      
       FIND _Area WHERE _Area._Area-number = _StorageObject._Area-number NO-LOCK.
     ELSE
       FIND _Area WHERE _Area._Area-number = 6 NO-LOCK. 
  END.
  ELSE
    FIND _Area WHERE _Area._Area-number = b_File._ianum NO-LOCK.
      
  ASSIGN s_Tbl_Area = _Area._Area-name. 
END.   

s_btn_File_Area:visible in frame tblprops = false.
s_lst_File_Area:visible in frame tblprops = false.

display  b_File._File-Name
        s_Tbl_Area 
      	 s_optional
   	 s_Tbl_Type 
      	 b_File._Dump-Name
      	 b_File._Hidden
   	 b_File._Frozen
      	 b_File._For-Size    when INDEX(capab, {&CAPAB_TBL_SIZE}) > 0
      	 b_File._File-label
         b_File._Desc 
         b_File._Fil-misc2[6]
      	
      	 /* Oracle db link */
      	 IF INDEX(s_Tbl_Type,"ORACLE") = 0 then "n/a" ELSE IF 
          b_File._Fil-misc2[8] = ? THEN "<Local-Db>" ELSE
          b_File._Fil-misc2[8] @ b_File._Fil-misc2[8]
   
      	 /* owner */
      	 (if b_File._Db-lang >= {&TBLTYP_SQL} then
      	    ENTRY(1, b_File._Owner) 
      	  else if INDEX(capab, {&CAPAB_OWNER}) = 0 then
      	    "n/a"
      	  else      	    
      	    b_File._For-Owner
      	 ) @ b_File._For-Owner

      	 /* gateway name */
      	 (if INDEX(capab, {&CAPAB_FOR_NAME}) = 0 then
      	    "n/a"
      	  else
      	    b_File._For-Name
      	 ) @ b_File._For-Name
   with frame tblprops.
      	 
if s_Tbl_ReadOnly then
do:
   disable all except
	  s_btn_Tbl_Triggers 
	  s_btn_Tbl_Validation 
	  s_btn_Tbl_StringAttrs
	  s_btn_Close 
	  s_btn_Prev
	  s_btn_Next
	  s_btn_Help
	  with frame tblprops.
   enable s_btn_Tbl_Triggers 
	  s_btn_Tbl_Validation 
	  s_btn_Tbl_StringAttrs
	  s_btn_Close 
	  s_btn_Prev
	  s_btn_Next
	  s_btn_Help
	  with frame tblprops.
   apply "entry" to s_btn_Tbl_Triggers in frame tblprops.
end.
else do:
   /* User is not allowed to modify the name of a SQL table or a view.  Also 
      some gateways don't allow rename. */
   if b_File._Db-lang >= {&TBLTYP_SQL} OR
      CAN-FIND(FIRST _View-ref
	       where _View-ref._Ref-Table = b_File._File-Name) then
      name_editable = false.
   else if INDEX(capab, {&CAPAB_RENAME}) = 0 then
      name_editable = false.
   else
      name_editable = true.
   
   /* Note: the order of enables will govern the TAB order. */
   enable b_File._File-Name   when name_editable
          b_File._Hidden
	  b_File._Dump-Name
       	  s_Tbl_Type          when INDEX(capab, {&CAPAB_TBL_TYPE_MOD}) > 0
      	  b_File._File-label
	  b_File._Desc
          b_File._Fil-misc2[6]
	  b_File._For-Size    when INDEX(capab, {&CAPAB_CHANGE_TBL_SIZE}) > 0
	  b_file._For-Name    when INDEX(capab, {&CAPAB_CHANGE_FOR_NAME}) > 0
	  s_btn_Tbl_Triggers
	  s_btn_Tbl_Validation
	  s_btn_Tbl_StringAttrs
	  s_btn_Tbl_ds WHEN NOT s_btn_Tbl_ds:hidden
      	  s_btn_OK
	  s_btn_Save
	  s_btn_Close
      	  s_btn_Prev
      	  s_btn_Next
      	  s_btn_Help
	  with frame tblprops.

   if name_editable then
      apply "entry" to b_File._File-Name in frame tblprops.
   else
      apply "entry" to b_File._Dump-Name in frame tblprops.
end.













/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _tblsas.p -table string attributes dialog box

Description:   
   Display and handle the dialog box for specifying string attributes
   for a table.

Returns: "mod" if user OK'ed changes (though we really don't
      	 check to see if the values actually are different),
      	 "" if user Cancels.

Author: Laura Stern

Date Created: 04/05/93 

----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/uivar.i shared}
{adedict/TBL/tblvar.i shared}
{adedict/menu.i shared}

Define var retval as char NO-UNDO init "". /* return value */

FORM
   SKIP({&TFM_WID})
   "String attribute options are:":t41      at 2 view-as TEXT SKIP
   "T, R, L, C, U and # of characters.":t41 at 2 view-as TEXT 
   SKIP({&VM_WIDG})

   b_File._File-Label-SA  colon 22 label "&Label" {&STDPH_FILL} 
   SKIP({&VM_WID})

   b_File._Valmsg-SA	  colon 22 label "&Validation Message" {&STDPH_FILL}
   SKIP({&VM_WID})

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}
   
   with frame tbl_string_attrs
   SIDE-LABELS 
   DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel
   view-as DIALOG-BOX TITLE "Table String Attributes".


/*--------------------------------Triggers-----------------------------------*/

/*-----WINDOW-CLOSE-----*/
on window-close of frame tbl_string_attrs
   apply "END-ERROR" to frame tbl_string_attrs.


/*---- GO or OK -----*/
on GO of frame tbl_string_attrs
do:
   DO ON ERROR UNDO, LEAVE:
      assign 
	 b_File._File-Label-SA
	 b_File._Valmsg-SA.

      if NOT s_Adding then
      	 {adedict/setdirty.i &Dirty = "true"}.
      retval = "mod".
      return.
   END.

   /* error occurred */
   apply "entry" to b_File._File-Label-SA in frame tbl_string_attrs.
   return no-apply.  
end.


/*----- HELP -----*/
on HELP of frame tbl_string_attrs OR 
   choose of s_btn_Help in frame tbl_string_attrs
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", 
      	       	     	     {&Table_String_Attributes_Dlg_Box}, ?).


/*------------------------------Mainline Code--------------------------------*/

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame tbl_string_attrs" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}

do ON ERROR UNDO,LEAVE  ON ENDKEY UNDO,LEAVE:
   /* Do the actual field assignment in GO trigger instead of using 
      update so that if an error occurs, the dialog won't flash.
   */

   display (if b_File._File-Label-SA = ? then "" else b_File._File-Label-SA)
      	       @ b_File._File-Label-SA
      	   (if b_File._Valmsg-SA = ? then "" else b_File._Valmsg-SA) 
      	       @ b_File._Valmsg-SA
      	   with frame tbl_string_attrs.

   enable b_File._File-Label-SA   when NOT s_Tbl_ReadOnly
	  b_File._Valmsg-SA	  when NOT s_Tbl_ReadOnly
      	  s_btn_OK  	      	  when NOT s_Tbl_ReadOnly
      	  s_btn_Cancel
      	  s_btn_Help
      	  with frame tbl_string_attrs.

   wait-for choose of s_btn_OK in frame tbl_string_attrs OR 
      	    GO of frame tbl_string_attrs
      	    focus b_File._File-Label-SA.
end.

hide frame tbl_string_attrs.
return retval.

/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _tblval.p

Description:   
   Display and handle the table validation dialog box.

Returns: "mod" if user OK'ed changes (though we really don't
      	 check to see if the values actually are different),
      	 "" if user Cancels.

Author: Laura Stern

Date Created: 02/18/92 

Modified on 07/08/94 by gfs - Fixed bug 94-06-14-073.

----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES

{adedict/dictvar.i shared}
{adedict/uivar.i shared}
{adedict/TBL/tblvar.i shared}
{adedict/menu.i shared}

Define var retval as char NO-UNDO init "". /* return value */

form
   SKIP({&TFM_WID})
   "Expression that must be TRUE to allow record deletions:":t62  at  2 
      	       	    view-as TEXT 
   SKIP
   b_File._Valexp   view-as EDITOR SCROLLBAR-VERTICAL
                    SIZE 73 BY 3 {&STDPH_ED4GL_SMALL}         at  2 
   SKIP({&VM_WIDG})

   "Message to be displayed for disallowed deletions:":t62 	      at  2   
      	       	    view-as TEXT
   SKIP
   b_File._Valmsg   format "x(72)" {&STDPH_FILL}   	      at  2  

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}
   
   with frame tblvalid
        DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel
        NO-LABELS  
        view-as DIALOG-BOX TITLE "Table Validation".


/*------------------------------Trigger Code---------------------------------*/

/*-----WINDOW-CLOSE-----*/
on window-close of frame tblvalid
   apply "END-ERROR" to frame tblvalid.


/*----- SELECTION of OK BUTTON or GO -----*/
on GO of frame tblvalid	   /* or OK due to AUTO-GO */
do:
   Define var msg  as char NO-UNDO.
   Define var expr as char NO-UNDO.

   assign
      msg = TRIM(input frame tblvalid b_File._Valmsg)
      expr = TRIM(input frame tblvalid b_File._Valexp).

   if NOT (msg = "" OR msg = ?) then 
   do:  /* message is not blank */
      if expr = "" OR expr = ? then    
      do:
      	 message "Please enter a validation expression to" SKIP
      	       	 "go along with your validation message."
      	       	 view-as ALERT-BOX ERROR buttons OK.
      	 apply "entry" to b_File._Valexp in frame tblvalid.
      	 return NO-APPLY.
      end.
   end.
   else  /* message is blank */ 
      if NOT (expr = "" OR expr = ?) then 
      do:
	 message "Please enter a validation message to" SKIP
		  "go along with your validation expression."
		  view-as ALERT-BOX ERROR buttons OK.
	 apply "entry" to b_File._Valexp in frame tblvalid.
	 return NO-APPLY.
      end.
end.


/*----- HELP -----*/
on HELP of frame tblvalid OR choose of s_btn_Help in frame tblvalid
    RUN "adecomm/_kwhelp.p" (INPUT b_File._Valexp:HANDLE,
                             INPUT "dict",
                             INPUT {&Table_Validation_Dlg_Box}).

/*------------------------------Mainline Code--------------------------------*/

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame tblvalid" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}

/* So Return doesn't hit default button in editor widget */
b_File._Valexp:RETURN-INSERT = yes.

display b_File._Valmsg b_File._Valexp with frame tblvalid.

do ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE  ON STOP UNDO, LEAVE:
   if s_Tbl_ReadOnly then
   do:
      display b_File._Valmsg b_File._Valexp with frame tblvalid.
      update s_btn_Cancel with frame tblvalid.
   end.
   else do:
      update b_File._Valexp   
      	     b_File._Valmsg
      	     s_btn_Ok  	      
      	     s_btn_Cancel
      	     s_btn_Help
      	     with frame tblvalid.

      /* Remove any line feeds (which we get on WINDOWS) and remove
      	 extraneous spaces and carriage returns. */
      b_File._Valexp = TRIM(replace (b_File._Valexp, CHR(13), "")).

      if NOT s_Adding then
      	 {adedict/setdirty.i &Dirty = "true"}.
      retval = "mod".
   end.
end.

hide frame tblvalid.
return retval.



/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: nexttbl.i

Description:
   Find the next table, alphabetically, in the current database.

Arguments:
   &Name - table name to get next for
   &Next - "next" variable - will get set with the name of the next
      	   table (or "" if there is no next)

Author: Laura Stern

Date Created: 07/22/93
    Modified: 06/29/98 D. McMann Added _Owner to _File find

----------------------------------------------------------------------------*/

if s_Show_Hidden_Tbls then
   find FIRST _File where _File._Db-recid = s_DbRecId AND
       		     	  _File._File-Name > {&Name} AND
       		     	  (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")       		     	  
      	     	          NO-ERROR.
else
   find FIRST _File where _File._Db-recid = s_DbRecId AND
       		     	  _File._File-Name > {&Name} AND
      	     	      	  NOT _File._Hidden AND
       		     	  (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
      	     	          NO-ERROR.

{&Next} = (if AVAILABLE _File then _File._File-name else "").

/**********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/


/*----------------------------------------------------------------------------

File: tblprop.f

Description:   
   This file contains the form for adding and editing table properties (not
   including triggers and validation info).  All information is in the form.
   Some will be grayed or made invisible if it is not relevant (e.g., for
   gateway vs. Progress tables).

Arguments:
   &frame_phrase - this should be a frame phrase for the frame that we want
                   to associate this form with. e.g., "frame foo OVERLAY".
   &apply_btn    - The apply button (e.g., Save or Create)
   &other_btns   - phrase for layout of other default buttons
   &col1         - column for lining up the colons
   &col2         - column for other stuff
   &colbtn       - column for sub-dialog buttons.

Author: Laura Stern

Date Created: 03/05/92
    Modified: 01/19/98 DLM Added variable s_tbl_area for either the 
                           _ianum or N/A for dataserver tables 
              03/26/98 DLM Changed display of area number to area name
              06/15/06 fernando Changed Dump-name to allow 32 characters

----------------------------------------------------------------------------*/

form
                                                             SKIP({&TFM_WID})
   b_File._File-Name 	label "Table &Name"   colon {&col1}   
                        view-as fill-in size 42 by 1
                        {&STDPH_FILL}                        SKIP({&VM_WID}) 

   s_Tbl_Area           label "&Area" colon {&col1} s_btn_File_Area
    SKIP({&VM_WID})
 
  s_Optional           no-label at 2                        SKIP({&VM_WIDG})
      
  b_File._Dump-Name 	label "Dump &File"    colon {&col1} 
                        view-as fill-in size 42 by 1  format "X(32)"
                        {&STDPH_FILL}                        SPACE(5)      

   s_Tbl_Type           label "Table Type"   colon {&col1}
                        {&STDPH_FILL}
                        view-as fill-in size 20 by 1         SPACE(2)
                        
   b_File._Hidden       label "H&idden"
      	       	     	view-as TOGGLE-BOX                   SPACE(3)
      	       	     	
   b_File._Frozen    	label "Fr&ozen"          
                        view-as TOGGLE-BOX                   SKIP({&VM_WID})


   b_File._File-label   label "&Label"        colon {&col1} 
                        {&STDPH_FILL}
                        view-as fill-in size 42 by 1         SKIP({&VM_WID})

   b_File._Desc	     	label "Descri&ption"  colon {&col1}
                        view-as EDITOR SCROLLBAR-VERTICAL
                        size 42 BY 4 {&STDPH_EDITOR}         SKIP({&VM_WID})

   b_File._Fil-misc2[6] label "R&eplication" format "x(50)"
                        view-as fill-in size 42 by 1
                        {&STDPH_FILL}        colon {&col1}
                                                             SKIP({&VM_WID})

   b_File._Fil-misc2[8] label "DB Link"      colon {&col1}  
                        view-as fill-in size 14 by 1         SPACE(2.5)

   b_File._For-Size     label "Record Size"                
                        {&STDPH_FILL}
                                                            SKIP({&VM_WID})
                                                             
   b_File._For-Name     label "DataServer Name" colon {&col1}  
                        view-as fill-in size 42 by 1
                        {&STDPH_FILL}                        SKIP({&VM_WID})
                        
   b_File._For-Owner    label "Owner"            colon {&col1}       
                        view-as fill-in size 42 by 1
                        {&STDPH_FILL}                        SKIP({&VM_WIDG})

   s_btn_Tbl_Triggers                         at  {&colbtn}  SPACE({&HM_BTN})
   s_btn_Tbl_Validation                                      SPACE({&HM_BTN})
   s_btn_Tbl_StringAttrs             
   {&ds_btn}                                                 SKIP(.25)
   
    s_Status             no-label format "x(50)" at     2
                        view-as TEXT 

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = yes
      &OK     = s_btn_OK
      &CANCEL = "{&apply_btn} "
      &OTHER  = "{&other_btns} "
      &HELP   = "s_btn_Help"
      }

    s_lst_File_Area      NO-LABEL                at col 1 row 1
   
   with {&frame_phrase} SIDE-LABELS.





/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: tblvar.i

Description:   
   Include file which defines the user interface components and related data
   for the main table editor window.
 
Arguments:
   {1} - this is either "new shared" or "shared".

Author: Laura Stern

Date Created: 03/06/92 
    Modified: 01/19/98 Added variable s_Tbl_Area to hold character value of
                       either the _ianum or N/A for dataserer
                       tables.
              03/26/98 Added variables necessary to create selection list
                       of available areas
----------------------------------------------------------------------------*/


Define {1} buffer   b_File          for  DICTDB._File. 

Define {1} frame newtbl.    /* for create table dialog box */
Define {1} frame tblprops.  /* table properties */

/* The main table properties - mostly we user the record buffer. */
Define {1} var s_Tbl_Type     as char  format "x(20)"   NO-UNDO. 
Define {1} var s_Tbl_IdxCnt   as integer format ">>>9"  NO-UNDO.

Define {1} var file-area-number as integer format ">>>9" init 6 NO-UNDO.

Define button s_btn_Tbl_Triggers    label "Tri&ggers..."     SIZE 17 by 1.125.
Define button s_btn_Tbl_Validation  label "Valida&tion..."   SIZE 17 by 1.125.
Define button s_btn_Tbl_StringAttrs label "St&ring Attrs..." SIZE 17 by 1.125.
Define button s_btn_Tbl_ds          label "DataSer&ver..."   SIZE 17 by 1.125.

Define button  s_btn_File_Area IMAGE-UP FILE "btn-down-arrow".
Define {1} var s_Tbl_Area     as char  format "x(32)"  NO-UNDO.
Define {1} var s_lst_File_Area as char view-as  SELECTION-LIST SINGLE   
   INNER-CHARS 32 INNER-LINES 5 SCROLLBAR-VERTICAL.

/* These are the forms for the table properties and new table windows. */
&IF "{&WINDOW-SYSTEM}" begins "MS-WIN" &THEN
   {adedict/TBL/tblprop.f  
      &frame_phrase = "frame tblprops NO-BOX 
       default-button s_btn_OK cancel-button s_btn_Close"
      &apply_btn  = s_btn_Save
      &ds_btn     = "SPACE({&HM_BTN}) s_btn_Tbl_ds"
      &other_btns = "SPACE({&HM_DBTN}) s_btn_Close SPACE({&HM_DBTNG}) 
     s_btn_Prev SPACE({&HM_DBTN}) s_btn_Next"
      &col1       = 18
      &col2       = 20
      &colbtn     = 4.5
   }
&ELSE /* motif */
   {adedict/TBL/tblprop.f  
      &frame_phrase = "frame tblprops NO-BOX 
       default-button s_btn_OK cancel-button s_btn_Close"
      &apply_btn  = s_btn_Save
      &ds_btn     = "SPACE({&HM_BTN}) s_btn_Tbl_ds"
      &other_btns = "SPACE({&HM_DBTN}) s_btn_Close SPACE({&HM_DBTNG}) 
     s_btn_Prev SPACE({&HM_DBTN}) s_btn_Next"
      &col1       = 20
      &col2       = 22
      &colbtn     = 2
   }
   
&ENDIF

{adedict/TBL/tblprop.f  
   &frame_phrase = "frame newtbl view-as DIALOG-BOX TITLE ""Create Table"" 
                default-button s_btn_OK cancel-button s_btn_Done"
   &apply_btn  = s_btn_Add
   &ds_btn     = "   "
   &other_btns = "SPACE({&HM_DBTN}) s_btn_Done"
   &col1       = 18
   &col2       = 20
   &colbtn     = 4
}

/* Symbolic constants */

/* for file number (_File-Number) values. */
&global-define   TBLNUM_FASTTRK_START   -29
&global-define   TBLNUM_FASTTRK_END     -7

define variable odbtyp   as character no-undo.

assign
  odbtyp = {adecomm/ds_type.i
              &direction = "odbc"
              &from-type = "odbtyp"
           }.
/*----------------------------------------------------------------*/
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _trigdlg.p

Description:
   Code for handling the file and field trigger dialog boxes.  The user
   can add, delete and modify triggers.

Input Parameters:
   p_Obj    - Either {&OBJ_TBL} or {&OBJ_FLD} to indicate which kind of 
	      triggers we're working on.
   p_Events - A comma delimited list of the events appropriate for this
	      object type. 
   p_Name   - The widget handle for the name field in the parent dialog or
	      window for the table or field we are adding the trigger to.
   p_Help   - The help context for this dialog box 

Returns: "mod" if user made any changes in here,
	 "" otherwise.

Author: Laura Stern

Date Created: 10/29/92 

tomn     95/08/01   added support for "Event" and "Procedure" combo-box mnemonics
gfs      94/07/14   fixed 94-07-13-005.
gfs      94/07/07   fixed 94-06-14-073.
gfs      94/06/20   fixed 94-06-14-056.
gfs      94/05/24   removed cbdrop and implemented core combo-box widget
		    Bug 94-05-09-078
hutegger 94/02/10   commented LARGE-attribut in editor-widget (BUG:94-02-09-034) 
McMann   98/07/10   Added DBVERSION and _Owner check for _file.
McMann   98/10/08   Added available check for b_file.
McMann   99/10/15   Changed DBVERSION check to use DICTDB
----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared} /* Common UI definitions */

Define INPUT PARAMETER p_Obj     as integer         NO-UNDO.
Define INPUT PARAMETER p_Events  as char            NO-UNDO.
Define INPUT PARAMETER p_Name    as widget-handle   NO-UNDO.
Define INPUT PARAMETER p_Help    as integer         NO-UNDO.

Define shared buffer b_File  for _File.
Define shared buffer b_Field for _Field.
Define        buffer b_ttrig for _File-Trig.
Define        buffer b_ftrig for _Field-Trig.

/* Trigger attributes for form */
Define var trig_event      as char    format "x(18)"                 
				      view-as combo-box sort       NO-UNDO.
Define var trig_proc       as char    format "x(60)"
				      view-as fill-in size 25 by 1 NO-UNDO.
Define var trig_crc        as logical view-as TOGGLE-BOX           NO-UNDO.
Define var trig_override   as logical view-as TOGGLE-BOX           NO-UNDO.

/* Variable containing trigger code being editted */
Define var trig_txt as char NO-UNDO
	 VIEW-AS EDITOR /*LARGE*/ SCROLLBAR-VERTICAL SCROLLBAR-HORIZONTAL 
	 SIZE 74 BY 10. 

/* Defines common buttons etc, used here and by UIB */
{adecomm/trigdlg.i 
   &Insert_Lbl = "&Insert File..." 
   &Insert_Wid = 17
   &Apply_Action = "Save"
}
		  
/* Other Buttons for form.  Don't use standard close or cancel button. 
   If it's auto-endkey, all the changes in the dialog will be undone.
*/
Define button btn_Close   label "Cancel" {&STDPH_OKBTN}.
Define button btn_file    label "Fi&les..." SIZE 9 by 1.125.

/* Miscellaneous */
Define var new_trig     as logical NO-UNDO.          
Define var tmpfile      as char    NO-UNDO.
Define var new_crc_val  as integer NO-UNDO.
Define var old_crc_val  as integer NO-UNDO.
Define var proc_read    as char    NO-UNDO 
			init "" case-sens.  /* last file read in */ 
Define var committed    as logical NO-UNDO. /* Is table/fld committed to DB? */
Define var can_update   as logical NO-UNDO. /* user has privileges */
Define var new_trigfile as logical NO-UNDO. /* TrigFile changed */
DEFINE VAR trig_event_lbl AS CHAR FORMAT "X(7)"  VIEW-AS TEXT INIT "Eve&nt:".
DEFINE VAR trig_proc_lbl  AS CHAR FORMAT "X(11)" VIEW-AS TEXT INIT "Proc&edure:".

FORM
   SKIP({&TFM_WID})

   trig_event_lbl  at  2 NO-LABEL
   trig_proc_lbl   at 27 NO-LABEL
   "Options: "     at 64 view-as TEXT
   trig_crc        at 73 LABEL "Chec&k CRC" 
   SKIP({&VM_WID})
   
   trig_event      at  2 NO-LABEL {&STDPH_FILL} SPACE(0)
   trig_proc       at 27 NO-LABEL {&STDPH_FILL} SPACE(.3)
   btn_File                     
   trig_override   at 73 LABEL "Overrida&ble"
   SKIP ({&VM_WID})
	  
   trig_txt              NO-LABEL {&STDPH_ED4GL}

   {&TRIG_LAYOUT}
   SKIP({&VM_WIDG})

   s_Status        at  2 NO-LABEL format "x(50)" 
			 view-as TEXT
   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Save /* where cancel btn usually is */
      &OTHER  = "SPACE({&HM_DBTN}) btn_Close"
      &HELP   = s_btn_Help}

   with frame trigedit 
      DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON btn_Close
      THREE-D NO-LABELS SCROLLABLE VIEW-AS DIALOG-BOX.

/* Added to support mnemonics in MS-WINDOWS for combo-box labels (tomn 8/1/95) */      
ASSIGN
  trig_event:SIDE-LABEL-HANDLE IN FRAME trigedit = trig_event_lbl:HANDLE
  trig_proc:SIDE-LABEL-HANDLE  IN FRAME trigedit = trig_proc_lbl:HANDLE
  trig_event:LABEL = trig_event_lbl
  trig_proc:LABEL = trig_proc_lbl.

/*========================Internal Procedures===============================*/

/* These provide editor functionality */
{adecomm/dedit.i}    /* Edit Defines */
{adecomm/dsearch.i}  /* Search Defines */
{adecomm/pedit.i}    /* Edit Procedures */
{adecomm/psearch.i}  /* Search Procedures */


/*--------------------------------------------------------------
   Initialize the widgets for a new trigger.

   Input Parameter:
      p_All - true = initialize all attributes,
	      false = only initialize the trigger code contents.
---------------------------------------------------------------*/
PROCEDURE Init_Trigger:

   Define INPUT PARAMETER p_All as logical NO-UNDO.

   if p_All then 
   do:
      assign
	 trig_proc      = ""
	 trig_override  = no
	 trig_crc       = (if committed then yes else no)
	 tgl_syntax     = (if committed then yes else no).
      display trig_proc trig_override trig_crc tgl_syntax
	      with frame trigedit.
   end.

   /* Set default trigger code in widget and underlying variable. 
      Use the name from the parent dialog or window to get the name
      of the new table or field or the modified name from an existing
      object.
   */
   trig_txt =
      "TRIGGER PROCEDURE FOR " + trig_event + " OF " + 
      (if p_Obj = {&OBJ_FLD} then s_Currtbl + "." + p_Name:screen-value
			     else p_Name:screen-value) + 
      ".".
   trig_txt:screen-value in frame trigedit = trig_txt.

   /* Set the cursor to after predefined portion of text. */
   trig_txt:CURSOR-OFFSET in frame trigedit = LENGTH(trig_txt) + 1. 
end.


/*--------------------------------------------------------------
   Get the trigger for the event currently in the event fill-in,
   if there is one defined, and initialize the dialog widgets 
   with this trigger's attributes.

   Input Parameter:
      p_refresh - true - if we need to show values on the screen
		  and re-read the trigger from the file.
		  false - if we just save the trigger and we
		  just need to reset program variable etc.
---------------------------------------------------------------*/
PROCEDURE Get_Trigger:

Define INPUT PARAMETER refresh as logical NO-UNDO.

Define var fname      as char    NO-UNDO.  /* file name */
Define var read       as logical NO-UNDO.  /* i.e., past tense of read */

   assign
      new_trig = false
      trig_event = trig_event:screen-value in frame trigedit
      old_crc_val = ?.

   if p_Obj = {&OBJ_TBL} then
   do:
      find b_ttrig of b_File where b_ttrig._Event = trig_event NO-ERROR.
      if AVAILABLE b_ttrig then
	 assign
	    trig_proc      = b_ttrig._Proc-Name
	    trig_override  = b_ttrig._Override
	    trig_crc       = (if b_ttrig._Trig-CRC = ? then no else yes)
	    old_crc_val    = b_ttrig._Trig-CRC.
      else
	 new_trig = true.
   end.
   else do:
      find b_ftrig of b_Field where b_ftrig._Event = trig_event NO-ERROR.
      if AVAILABLE b_ftrig then
	 assign
	    trig_proc      = b_ftrig._Proc-Name
	    trig_override  = b_ftrig._Override
	    trig_crc       = (if b_ftrig._Trig-CRC = ? then no else yes)
	    old_crc_val    = b_ftrig._Trig-CRC.
      else
	 new_trig = true.
   end.
   new_crc_val = old_crc_val. 

   if new_trig then
      run Init_Trigger (INPUT true).
   else do:
      tgl_syntax = trig_crc.  /* have to compile to get crc value */
      if refresh then
      do:
	 display trig_proc trig_override trig_crc tgl_syntax
		 with frame trigedit.

	 /* Look for this procedure and load it if it's out there. */
	 fname = SEARCH(trig_proc). /* get the full file name */
	 if fname = ? then 
	 do:
	    read = false.
	    message "Cannot find trigger procedure" trig_proc SKIP
		    "Initializing trigger code for new procedure."
		    view-as ALERT-BOX ERROR buttons OK.
	 end.
	 else 
	    read = trig_txt:read-file(fname) in frame trigedit. 
      end.
      else read = true.
      
      if NOT read then
	 /* Set code to initial default value. */
	 run Init_Trigger (INPUT false).
      else
	 /* Save this original trigger text in the underlying variable for
	    later comparison to editor widget value.
	 */
	 trig_txt = trig_txt:screen-value in frame trigedit.

      /* Set the cursor to start of trigger. */
      /* gfs: added 'if refresh' to keep cursor from moving back
       * to the top after a SAVE
       */
      if refresh then trig_txt:CURSOR-OFFSET in frame trigedit = 1.
   end.
   proc_read = trig_proc.  /* remember which proc was read last */

   /* You can only delete an existing trigger so: */
   btn_delete:sensitive = (if NOT new_trig AND can_update then yes else no).
end.


/*--------------------------------------------------------------
   Check to see if anything attributes for the given event has 
   been changed by the user.

   Output Parameter:
      p_Changed - Set to true if anything changed, 
		  false otherwise.
---------------------------------------------------------------*/
PROCEDURE Trig_Changed:

   Define OUTPUT PARAMETER p_Changed as logical NO-UNDO.

   Define var old_proc as char NO-UNDO case-sens.
   Define var new_proc as char NO-UNDO case-sens.

   /* Case matters in file names on Unix */
   assign
      old_proc = trig_proc
      new_proc = input frame trigedit trig_proc.

   p_Changed = 
      (if old_proc      = new_proc                           AND
	  trig_crc      = input frame trigedit trig_crc      AND
	  trig_override = input frame trigedit trig_override AND
	  trig_txt      = input frame trigedit trig_txt    
      then false else true).

   /* Only if we're going to save crc, check if it's different.  Otherwise
      old value will be ? and new val may be something else because
      user checked syntax - this shouldn't show up as a change.
   */
   if NOT p_Changed AND
      input frame trigedit trig_crc AND 
      old_crc_val <> new_crc_val then
	 p_Changed = true.
end.

   
/*--------------------------------------------------------------
   Save this trigger - which really means create a new one or  
   modify an existing one (by delete and recreate).  
   trig_event is the event of the current trigger we're trying 
   to save.

   Output Parameters:
      p_Save - yes, if save was successful, no otherwise.  
---------------------------------------------------------------*/
PROCEDURE Save_Trigger:

   Define OUTPUT PARAMETER p_Save  as logical NO-UNDO.

   Define var fname        as char    NO-UNDO.
   Define var saved        as logical NO-UNDO.
   Define var tproc        as char    NO-UNDO.
   Define var crc          as logical NO-UNDO.
   
   tproc = input frame trigedit trig_proc.
   p_Save = no.
   if tproc = "" then
   do:
      message "Please enter the name of a file to store" SKIP
	      "the trigger code in."
	       view-as ALERT-BOX ERROR buttons OK.
      apply "entry" to trig_proc in frame trigedit.
      return.         
   end.
   
   run adecomm/_setcurs.p ("WAIT").
   save_block:
   do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      if NOT new_trig then
      do:
	 /* You can't modify a trigger def, so delete this one and
	    recreate it. 
	 */
	 if p_Obj = {&OBJ_TBL} then
	    delete b_ttrig.
	 else
	    delete b_ftrig.
      end.   

      /* If the trigger code wasn't recompiled, new_crc_val will equal
	 the original value.  So if user wants to check crc save this
	 and we'll either get the new value or reset it to the original.
      */
      crc = input frame trigedit trig_crc.
      if p_Obj = {&OBJ_TBL} then
      do:
	 create b_ttrig.
	 assign
	    b_ttrig._File-Recid = RECID(b_File)
	    b_ttrig._Event = trig_event
	    b_ttrig._Proc-Name = tproc
	    b_ttrig._Override = input frame trigedit trig_override
	    b_ttrig._Trig-CRC = (if NOT crc then ? else new_crc_val).
      end.
      else do:
	 create b_ftrig.
	 assign
	    b_ftrig._File-Recid = s_TblRecId
	    b_ftrig._Field-Recid = RECID(b_Field)
	    b_ftrig._Event = trig_event
	    b_ftrig._Proc-Name = tproc
	    b_ftrig._Override = input frame trigedit trig_override.
	    b_ftrig._Trig-CRC = (if NOT crc then ? else new_crc_val).
      end.

      /* Save the code in the OS file. If we can't find the file, 
	 it will be saved in the current directory */
      fname = SEARCH(tproc).
      if fname = ? then fname = tproc.
      saved = trig_txt:SAVE-FILE(fname) in frame trigedit.
      if NOT saved then 
      do:
	 message "Unable to save trigger code in file."
		 view-as alert-box error buttons ok.
	 UNDO save_block, LEAVE save_block.
      end.

      old_crc_val = new_crc_val. /* Reset old val to match stored value */
      if NOT s_Adding then
	 {adedict/setdirty.i &Dirty = "true"}
      p_Save = yes.
      display "Trigger Saved" @ s_Status with frame trigedit.
      if btn_Close:label in frame trigedit <> "Close" then
	 btn_Close:label in frame trigedit = "Close".
   end.

   run adecomm/_setcurs.p ("").
   return.  
end.


/*--------------------------------------------------------------
   Determine if a syntax check is needed or do it anyway if
   "force" is true.  If the syntax check is done, reposition  
   the cursor to the offending spot of there is an error.

   Input Parameters:
      p_Force - compile unconditionally.  Also, if this is true,
		put up "success" message in an alert box, othewise
		use the status area.

   Output Parameters:
      p_Compiled - yes, if compile was successful, no otherwise.
---------------------------------------------------------------*/
PROCEDURE Check_Syntax:

   Define INPUT  PARAMETER p_Force    as logical NO-UNDO.   
   Define OUTPUT PARAMETER p_Compiled as logical NO-UNDO.

   /* Check syntax 
      if forced, or 
      if it's a new trigger and auto-check is on (which we've forced on 
	 if crc is yes) or
      if it's not a new trigger and crc is yes - user could have modified
	 the trigger code outside the dictionary and just want to reset
	 the crc value, so even if nothing's been modified, recompile - or
      if it's not a new trigger, user changed the trig code and says
	 auto-check (which again must be on if crc is yes)
   */
   p_Compiled = yes.
   if NOT (p_Force OR
	   (new_trig AND input frame trigedit tgl_syntax) OR
	   (NOT new_trig AND input frame trigedit trig_crc) OR
	   (NOT new_trig AND input frame trigedit tgl_syntax AND
	    trig_txt <> trig_txt:screen-value in frame trigedit)) then
      return.

   /* Store trigger code in temporary file and compile it. */
   run adecomm/_setcurs.p ("WAIT").
   run adecomm/_tmpfile.p (INPUT "", INPUT ".dct", OUTPUT tmpfile).
   s_Res = trig_txt:SAVE-FILE(tmpfile) in frame trigedit.

   compile VALUE(tmpfile) NO-ERROR.
   run adecomm/_setcurs.p ("").

   if compiler:error then 
   do:
      message error-status:get-message(1)
	 view-as alert-box error buttons OK.
      assign
	 trig_txt:CURSOR-OFFSET in frame trigedit = 
	    INTEGER(compiler:FILE-OFFSET).
	 p_Compiled = no.
      apply "entry" to trig_txt in frame trigedit.
   end.
   else do:
      rcode-info:filename = tmpfile.
      new_crc_val = rcode-info:crc-value.
      if p_Force then
	 message "Syntax is Correct" view-as alert-box information buttons ok.
      else
	 display "Syntax is Correct" @ s_Status with frame trigedit.
   end.

   OS-DELETE VALUE(tmpfile).
end.


/*--------------------------------------------------------------
   Do OK processing which also happens automatically when the
   user switches to another trigger.

   Input Parameters:
      p_NoSaveMsg - True if we should display no save because of
		    no change message.

   Output Parameters:
      p_Success - Set to yes if we didn't need to do anything
		  or if we did everything went all right.
---------------------------------------------------------------*/
PROCEDURE Do_Ok:

   Define INPUT  PARAMETER p_NoSaveMsg as logical NO-UNDO.
   Define OUTPUT PARAMETER p_Success   as logical NO-UNDO.

   Define var changed  as logical NO-UNDO.

   p_Success = yes.
   run Trig_Changed (OUTPUT changed).  

   /* For existing triggers we will check syntax anyway if crc 
      is yes in case the code was changed outside the dictionary -
      we need the new crc value.
   */
   if (new_trig AND changed) OR
       (NOT new_trig) then
   do:
      run Check_Syntax (INPUT false, OUTPUT p_Success).
      /* Another thing that may be different now is the crc value */
      if input frame trigedit trig_crc AND
	 new_crc_val <> old_crc_val then
	    changed = true.
   end.

   /* Assuming no syntax errors (or we didn't try to compile), try
      to save only if something's changed.
   */
   if p_Success then
      if changed then
	 run Save_Trigger (OUTPUT p_Success).
      else if p_NoSaveMsg then
	 display "Nothing was changed.  No save was done." @ s_Status
	    with frame trigedit.
end.


/*--------------------------------------------------------------
   We've already set a flag (committed) to indicate whether or
   not the table and/or field that the trigger belongs to 
   have been committed to the database or not.  If not, the
   trigger will definitely not compile because we know the
   trigger refers to that object and we know it is not in the schema
   cache yet.  Of course, other un-committed tables, field, indexes
   or sequences may be referenced by the trigger and there's 
   no way for us to know that.

   So at least, if we know, put up a message explaining what
   is going on.
---------------------------------------------------------------*/
PROCEDURE Check_Committed:

   if NOT committed then
   do:
      message "Trigger code that references uncommitted schema objects"  SKIP
	      "(e.g., a table or field that you've just created in"     SKIP
	      "this dictionary session) will not compile successfully." SKIP(1)
	      "This is the case with this trigger."                     SKIP(1)
	      "You can save your trigger code now but if you want"      SKIP
	      "to make sure there are no syntax errors, you must"       SKIP
	      "commit all your changes first (use the menu: "           SKIP
	      "Edit->Commit Transaction)."                              SKIP(1)
	      "NOTE: Choosing ~"Check CRC~" will require that the"      SKIP
	      "trigger code be compiled before it is saved."
	 view-as ALERT-BOX INFORMATION buttons OK.
      return "error".
   end.
   return "".            
end.


/*===============================Triggers=============================*/

/* Text editing triggers */
{adecomm/trigtrig.i &Frame = "frame trigedit"}


/*-----WINDOW-CLOSE-----*/
on window-close of frame trigedit
   apply "END-ERROR" to frame trigedit.


/*----- HELP -----*/
on HELP of frame trigedit OR choose of s_btn_Help in frame trigedit
    RUN "adecomm/_kwhelp.p" (INPUT trig_txt:HANDLE,
                             INPUT "dict"  , 
                             INPUT p_Help ).

/*----- SELECTION of OK BUTTON or GO -----*/
on GO of frame trigedit   /* or OK due to AUTO-GO */
do:

   Define var success as logical NO-UNDO init yes.
   Define var procval as char    NO-UNDO case-sens.

   procval = TRIM(trig_proc:screen-value in frame trigedit).
   trig_proc:screen-value in frame trigedit = procval. 
   if   SEARCH(procval) <> ?
    and new_trigfile = true   /* did user just want to use */
    then do:          /* a different file as trigger-code? */
     assign new_trigfile = false.
     RETURN NO-APPLY. 
     end.

   run Do_Ok (INPUT false, OUTPUT success).
   if NOT success then
      return NO-APPLY.
end.


/*----- SELECTION of SAVE BUTTON -----*/
on choose of s_btn_Save in frame trigedit
do:
   Define var success as logical NO-UNDO init yes.

   /* In case save button was pushed with accelerator */
   {adedict/forceval.i}

   run Do_Ok (INPUT true, OUTPUT success).
   if success then
      run Get_Trigger (false).
end.

/*---- VALUE-CHANGED of EVENT-----*/
on value-changed of trig_event in frame trigedit
do:
   Define var success as logical NO-UNDO init yes.

   /* NOTE: trig_event is the value before it just got
      changed. 
   */

   run Do_Ok (INPUT false, OUTPUT success).

   if success then
   do:
      /* Save new current event in underlying variable */
      trig_event = trig_event:screen-value in frame trigedit.
   
      /* Get the trigger associated with the new event chosen. */
      Run Get_Trigger (true).
   end.
   else do:
      /* Either there was a syntax error or a save error.
	 Reset the event back to what it was and stay put.
      */
      assign
	 trig_event:screen-value in frame trigedit = trig_event.
      return NO-APPLY.
   end.
END.


/*---- LEAVE of PROC NAME -----*/
on leave of trig_proc in frame trigedit
do:
   Define var fname   as char    NO-UNDO.
   Define var answer  as logical NO-UNDO.
   Define var procval as char    NO-UNDO case-sens.

   /* proc_read keeps track of the name of last file that was read into
      the editor widget.  If it hasn't changed, don't do anything.
   */
   procval = TRIM(trig_proc:screen-value in frame trigedit).
   trig_proc:screen-value in frame trigedit = procval. 
   if proc_read = procval then
      return.

   /* If this procedure exists already, ask the user what he wants. */
   fname = SEARCH(procval).
   if fname <> ? then 
   do:
      answer = ?.
      message "This file already exists." SKIP
	      "Do you want to read it in?" SKIP
	      "Select:" SKIP
	      "   Yes to use the contents of the existing file" SKIP
	      "   No to overwrite the file's contents" SKIP
	      "   Cancel to enter a different file name."
	      view-as ALERT-BOX QUESTION buttons YES-NO-CANCEL update answer.
      if answer then
      do:
	 s_Res = trig_txt:read-file(fname) in frame trigedit.
	 trig_txt = trig_txt:screen-value in frame trigedit.
      end.
      else if answer = ? then /* user chose Cancel */
      do:
	 s_Valid = no.
	 return NO-APPLY.
      end.
   end.
   assign
     new_trigfile = true
     proc_read    = procval.
end.


/*----- VALUE-CHANGED of CHECK CRC TOGGLE -----*/
on value-changed of trig_crc in frame trigedit
do:
   /* If user wants to check crc and it was not on before
      he must compile before saving.
   */
   if SELF:screen-value = "yes" then
   do:
      run Check_Committed.
      if return-value = "error" then
      do:
	 SELF:screen-value = "no".
	 return.
      end.

      tgl_syntax:screen-value in frame trigedit = "yes".
   end.
end.


/*----- VALUE-CHANGED of TGL_SYNTAX TOGGLE -----*/
on value-changed of tgl_syntax in frame trigedit
do:
   /* If user wants to check crc, he must compile before saving */
   if SELF:screen-value = "no" then
      trig_crc:screen-value in frame trigedit = "no".
   else do:  
      /* User is trying to set auto-check on */
      run Check_Committed.
      if return-value = "error" then
	 SELF:screen-value = "no".
   end.
end.


/*----- CHOOSE of BUTTON INSERT -----*/
on choose of btn_insert in frame trigedit
   run InsertFile (h_Editor).

 
/*---- SELECTION of CHECK SYNTAX BUTTON -----*/
on choose of btn_now in frame trigedit
do:
   Define var err as logical NO-UNDO.

   run Check_Committed.
   if return-value = "error" then
      return NO-APPLY.

   run Check_Syntax (INPUT true, OUTPUT err).
end.


/*---- SELECTION of REVERT BUTTON -----*/
on choose of btn_revert in frame trigedit
do:
   display trig_proc trig_crc trig_override trig_txt 
	   with frame trigedit.   
   
   /* Reset last proc_read and crc value */
   assign
      proc_read = trig_proc
      new_crc_val = old_crc_val.
end.


/*---- SELECTION of DELETE BUTTON -----*/
on choose of btn_delete in frame trigedit
do:
   Define var answer as logical NO-UNDO.

   message "Are you sure you want to delete the" trig_event "trigger?"
      view-as ALERT-BOX QUESTION buttons YES-NO update answer.
   if answer = no then return.

   if NOT new_trig then
   do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      if p_Obj = {&OBJ_TBL} then
	 delete b_ttrig.
      else
	 delete b_ftrig.
   
      if NOT s_Adding then    /* if not adding table or field */
	 {adedict/setdirty.i &Dirty = "true"}
      if btn_Close:label in frame trigedit <> "Close" then
	 btn_Close:label in frame trigedit = "Close".
   end.
  
   /* Reinitialize widgets */
   run Init_Trigger (INPUT true).
   new_trig = true.
   btn_delete:sensitive in frame trigedit = no.
end.


/*---- SELECTION of FILE BUTTON -----*/
on choose of btn_file in frame trigedit
do:
   Define var pname      as char    NO-UNDO.
   Define var picked_one as logical NO-UNDO.

   pname = trig_proc:screen-value in frame trigedit.
   system-dialog GET-FILE pname 
		 filters            "*.p" "*.p"
		 default-extension  ".p"
		 title              "Find Trigger Procedure" 
		 update             picked_one.
   if picked_one then   
   do:
      trig_proc:screen-value in frame trigedit = pname.
      s_Res = trig_txt:read-file(pname) in frame trigedit.
      trig_txt = trig_txt:screen-value in frame trigedit.
      proc_read = pname.
   end.
end.


/*---- LEAVE of EVENT FILL-IN -----*/
/* Syntax is only checked if they click on Now button or if they
   switch triggers. Saved status is only displayed when you switch
   triggers or hit save button - so we only need to clear status on 
   leave of these two widgets.
*/
on leave of trig_event, btn_now, s_btn_Save in frame trigedit
   display "" @ s_Status with frame trigedit.  /* clear status line */


/*===========================Mainline code==================================*/

/* Deal with privileges  
   To simplify we will do the following.  If the user does not have read
   privileges - he can't do anything.  If he does not have write, create or
   delete privileges than he can see triggers but cannot do anything else.
   To prevent this we will disable everything but the event drop down.
*/
IF NOT AVAILABLE b_File THEN
  FIND b_File WHERE RECID(b_File) = s_TblRecId NO-LOCK.

IF INTEGER(DBVERSION("DICTDB")) > 8 THEN DO:
  if p_Obj = {&OBJ_TBL} then
    find _File WHERE _File._File-name = "_File-Trig"
                 AND _File._Owner = "PUB"
                 NO-LOCK.
  else
    find _File WHERE _File._File-name = "_Field-Trig"
                 AND _File._Owner = "PUB"
                 NO-LOCK.
END.
ELSE DO:
  if p_Obj = {&OBJ_TBL} then
     find _File "_File-Trig".
  else
     find _File "_Field-Trig".
END.

if NOT can-do(_File._Can-read, USERID("DICTDB")) then
do:
   message s_NoPrivMsg "see trigger definitions."
	   view-as ALERT-BOX ERROR buttons Ok.
   return.
end.

if p_Obj = {&OBJ_TBL} then
   can_update = NOT s_Tbl_ReadOnly.
else
   can_update = NOT s_Fld_ReadOnly.

if ( NOT can-do(_File._Can-write, USERID("DICTDB")) OR
     NOT can-do(_File._Can-create, USERID("DICTDB")) OR
     NOT can-do(_File._Can-delete, USERID("DICTDB")) ) then 
do:
   message s_NoPrivMsg "either create, update or delete trigger definitions.".
   can_update = no.
end.

/* See if the table or field we are adding/editing is committed to the
   database yet.  This is done by compiling a little program that
   accesses the object and seeing if it compiles. 
   There's no nice way to suppress compile errors from showing
   up on the screen (e.g., NO-ERROR won't do it) so do output to 
   file to redirect them so the user won't see anything.
*/
run adecomm/_tmpfile.p (INPUT "", INPUT ".dct", OUTPUT tmpfile).
output to VALUE(tmpfile).
do ON STOP UNDO, LEAVE:
   if p_Obj = {&OBJ_TBL} then
      run adecomm/_istbl.i VALUE(s_CurrDb) 
			   VALUE(p_Name:screen-value).
   else
      run adecomm/_isfld.i VALUE(s_CurrDb) 
			   VALUE(s_CurrTbl) 
			   VALUE(p_Name:screen-value).
END.
output close.
os-delete VALUE(tmpfile).
committed = NOT compiler:error.

/* Customize the title to reflect table vs. field. */
frame trigedit:title = (if p_Obj = {&OBJ_TBL} then "Table Triggers"
					      else "Field Triggers").

/* Fill the event select list and default the current event to the first
   one in the list.  Set auto-indent on editor widget.
   Set return-insert so Return doesn't hit default button in editor widget.
*/
assign
   trig_event:LIST-ITEMS in frame trigedit = p_Events
   trig_event:INNER-LINES in frame trigedit = 
   trig_event:NUM-ITEMS in frame trigedit
   trig_event = trig_event:ENTRY(1) in frame trigedit
   trig_event:screen-value = trig_event
   
   h_Editor = trig_txt:HANDLE in frame trigedit /* used by trigdlg.i */
   trig_txt:RETURN-INSERT = yes
   trig_txt:AUTO-INDENT in frame trigedit = true.

   
/* Run time layout.  This defines eff_frame_width */
{adecomm/okrun.i  
   &FRAME = "frame trigedit" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}

run Adjust_Trig_Layout 
   (INPUT eff_frame_width,
    INPUT tgl_syntax_lbl:HANDLE in frame trigedit,
    INPUT btn_now:HANDLE in frame trigedit,
    INPUT tgl_syntax:HANDLE in frame trigedit,
    INPUT btn_replace:HANDLE IN FRAME trigedit,
    INPUT btn_next:HANDLE IN FRAME trigedit,
    INPUT btn_prev:HANDLE IN FRAME trigedit,
    INPUT btn_find:HANDLE IN FRAME trigedit,
    INPUT btn_insert:HANDLE IN FRAME trigedit,
    INPUT btn_copy:HANDLE IN FRAME trigedit,
    INPUT btn_paste:HANDLE IN FRAME trigedit,
    INPUT btn_delete:HANDLE IN FRAME trigedit,
    INPUT btn_revert:HANDLE IN FRAME trigedit).

/* Initialize the widgets with the trigger defined on the first event
   in the event list - if there is one.
*/
run Get_Trigger (true).

display tgl_syntax_lbl with frame trigedit.
if can_update then
   enable 
	  trig_event 
	  trig_proc   btn_File  
	  trig_crc    trig_override 
	  trig_txt 
	  btn_cut     btn_copy      btn_paste
	  btn_find    btn_prev      btn_next
	  btn_replace btn_insert
	  btn_revert
	  btn_now     tgl_syntax
	  s_btn_OK    s_btn_Save
	  btn_Close   s_btn_Help
	  with frame trigedit.
else
   enable trig_event 
	  btn_Close  s_btn_Help
	  with frame trigedit.

/* Fix up TAB positions for everything not in enable list */
assign
   s_Res        = btn_delete:move-before-tab-item(btn_revert:HANDLE) in frame trigedit
   new_trigfile = false.

do ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE:
   wait-for choose of s_btn_OK in frame trigedit,
		      btn_Close in frame trigedit OR
	    GO of frame trigedit 
	    FOCUS trig_event.
end.

hide frame trigedit.
if btn_Close:label in frame trigedit = "Close" then
   return "mod".
else
   return "".




/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _blnknam.p

Description:
   Determine if the name of an object is blank or ?. 

Input Parameters:
   p_Widget - The handle to the widget holding the name to check.
   p_Obj    - String denoting the object type that this name belongs to
      	      (e.g., "table").
   
Output Parameters:
   p_Blank  - Set to true if name is blank or ?.
 
Author: Laura Stern

Date Created: 07/10/92 

----------------------------------------------------------------------------*/

Define INPUT  PARAMETER p_Widget as widget-handle NO-UNDO.
Define INPUT  PARAMETER p_Obj    as char       	  NO-UNDO.
Define OUTPUT PARAMETER p_Blank  as logical  	  NO-UNDO.

Define var name as char NO-UNDO.

p_Obj = p_Obj + ".".
name = p_Widget:screen-value.

if name = "" OR name = "?" then
do:
   message "Please enter a name for this" p_Obj
   	    view-as ALERT-BOX ERROR buttons OK.
   p_Blank = true.

   /* Set focus there so the user can enter a name */
   apply "entry" to p_Widget. 
end.
else
   p_Blank = false.
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _brwadj.p

Description:
   Adjust the browse window.  This means hide and show things based on
   what the user just selected.
 
Input Parameters:
   p_Obj_Num   - The symbolic object number (e.g., {&OBJ_TBL}) of the 
      	         type of object that was just selected for display or 
      	         which just had an item added or deleted from it's browse
      	         list.  This will be {&OBJ_DB} only when a new database
      	         is selected or we perform an undo on the current database.

      	         When the database toggle icon is selected, no browse
      	         window changes need to occur except for the action button
      	         label change (done in brwtrig.i).

   p_Cnt       - For all object types except database, this should be
      	         the number of items in the select list for this type.
      	       	 If we've just added or deleted an item from the list
      	       	 the list may have become empty or a previously empty
      	       	 list may now have an item in it and we may need to
      	       	 adjust things.  Even if the user has just chosen a object
      	       	 type to display, we have to know if the list has anything
      	         in it or not to know whether to display children etc.

      	         For databases, This should be a 0 to indicate that there
      	         is no useable database. Otherwise it should be set to any
      	       	 non-zero value.

Author: Laura Stern

Date Created: 03/27/92 
Modified Date:  11/27/96  kkelley  Removed text under icons for WIN95.  
                                   Code commented out has WIN95 at the beginning
----------------------------------------------------------------------------*/

{adedict/dictvar.i shared}
{adedict/brwvar.i shared}

Define INPUT PARAMETER p_Obj_Num   as integer NO-UNDO.
Define INPUT PARAMETER p_Cnt 	   as integer NO-UNDO.


/*---------------------------Internal Procedures---------------------------*/

/*-------------------------------------------------------------------
   Hide or make visible the list box and fill-in and label for the 
   specified object type.
   Use the hidden attribute instead of visible to minimize flashing
   on startup.

   Input Parameter:
      p_Obj    - The object type of the list box to hide or view.
      p_Show   - Set to yes to make list visible, no to hide it
-------------------------------------------------------------------*/
PROCEDURE Show_List:

Define INPUT PARAMETER p_Obj  as integer NO-UNDO.
Define INPUT PARAMETER p_Show as logical NO-UNDO.

Define var hide_it as logical NO-UNDO.

   hide_it = NOT p_Show.


   if p_Obj = {&OBJ_FLD} OR p_Obj = {&OBJ_IDX} then
      s_Lvl2Lbl:hidden in frame browse = hide_it.
   else
      s_Lvl1Lbl:hidden in frame browse = hide_it.

   case (p_Obj):
      when {&OBJ_TBL} then
      do:
      	 assign
            s_lst_Tbls:hidden in frame browse = hide_it
     	    s_TblFill:hidden  in frame browse = hide_it.
      	 
      	   if p_Show then 
      	      s_Lvl1Lbl:screen-value in frame browse = " Tables".   
        
      end.

      when {&OBJ_SEQ} then
      do:
      	 assign
      	    s_lst_Seqs:hidden in frame browse = hide_it
      	    s_SeqFill:hidden  in frame browse = hide_it.
      	 
      	    if p_Show then 
      	       s_Lvl1Lbl:screen-value in frame browse = " Sequences".   
       
      end.
      when {&OBJ_FLD} then
      do:
      	 assign
            s_lst_Flds:hidden in frame browse = hide_it
      	    s_FldFill:hidden  in frame browse = hide_it.
      	 
      	    if p_Show then 
      	       s_Lvl2Lbl:screen-value in frame browse = " Fields".   
       
      end.
      when {&OBJ_IDX} then
      do:
      	 assign
            s_lst_Idxs:hidden in frame browse = hide_it
      	    s_IdxFill:hidden  in frame browse = hide_it.
      	 
      	    if p_Show then 
      	       s_Lvl2Lbl:screen-value in frame browse = " Indexes". 
       
      end.
   end.
end.


/*------------------------------------------------------------------
   Hide or make visible the toggle icons for the specified level
   (1 - tbl/seq/dom, 2 - fld, idx).
   Use the hidden attribute instead of visible to minimize flashing
   on startup.

   Input Parameter:
      p_Level - 1 or 2 
      p_Show  - Set to yes to make toggles visible, no to hide them
-------------------------------------------------------------------*/
PROCEDURE Show_Toggles:

Define INPUT PARAMETER p_Level 	  as integer NO-UNDO.
Define INPUT PARAMETER p_Show 	  as logical NO-UNDO.

Define var hide_it as logical NO-UNDO.

   hide_it = NOT p_Show.
   if p_Level = 1 then
      assign
      	 s_icn_Tbls:hidden   in frame browse = hide_it      	 
      	 s_icn_Seqs:hidden   in frame browse = hide_it      	 
        .
   else 
      assign
      	 s_icn_Flds:hidden   in frame browse = hide_it      	 
      	 s_icn_Idxs:hidden   in frame browse = hide_it.
end.


/*-----------------------------Mainline Code------------------------------*/

Define var fill_widget  as widget-handle  NO-UNDO.
Define var lst_widget   as widget-handle  NO-UNDO.
Define var msg          as char           NO-UNDO.

case (p_Obj_Num):
   when {&OBJ_DB} then
   do:
      /* This stuff will be hidden regardless of the db choice. */
      /* run Show_List (INPUT {&OBJ_DOM}, INPUT no). */
      run Show_List (INPUT {&OBJ_SEQ}, INPUT no).
      run Show_List (INPUT {&OBJ_FLD}, INPUT no).
      run Show_List (INPUT {&OBJ_IDX}, INPUT no).
      
      /* Delete any open edit windows. */
      run adedict/_delwins.p (INPUT no).

      if p_Cnt <> 0 then
      do: 
	 /* Allow user to choose what object they want to work with */
      	 run Show_Toggles (INPUT 1, INPUT yes).

	 /* Indicate that all the lists need to be refilled if the user
	    chooses to display them. */
      	 {adedict/uncache.i 
      	    &List   = "s_lst_Tbls"
      	    &Cached = "s_Tbls_Cached"
      	    &Curr   = "s_CurrTbl"}
      	 
      	 {adedict/uncache.i 
      	    &List   = "s_lst_Seqs"
      	    &Cached = "s_Seqs_Cached"
      	    &Curr   = "s_CurrSeq"}
      	 {adedict/uncache.i 
      	    &List   = "s_lst_Flds"
      	    &Cached = "s_Flds_Cached"
      	    &Curr   = "s_CurrFld"}
      	 {adedict/uncache.i 
      	    &List   = "s_lst_Idxs"
      	    &Cached = "s_Idxs_Cached"
      	    &Curr   = "s_CurrIdx"}

      	 /* Unpush whatever object button is down. We could cause db button
      	    to be pushed here, but we know that the tables button is about
      	    to be selected by default so don't bother.
      	 */
      	 run adedict/_btnup.p.
      
      	 assign
	    s_CurrObj = {&OBJ_NONE}
	    s_Lvl1Obj = {&OBJ_NONE}
	    s_Lvl2Obj = {&OBJ_NONE}
	    s_icn_Flds:PRIVATE-DATA = ?
	    s_icn_Idxs:PRIVATE-DATA = ?.

      	 /* If database prop window is up from a previous database,
      	    refresh it with props for the current database. */
      	 if s_win_Db <> ? then
      	    run adedict/DB/_dbprop.p.
      end.
      else do:
      	 /* Don't allow the user to try looking at schema objects - there
      	    is no accessible database chosen. */
      	 run Show_Toggles (INPUT 1, INPUT no).
      	 run Show_List (INPUT {&OBJ_TBL}, INPUT no). 
      	 run Show_Toggles (INPUT 2, INPUT no).  /* hide level 2 toggles */

      	 /* Make sure the current object button is "Database". */
      	 run adedict/_brwbtn.p (INPUT {&OBJ_DB}, 
      	       	     	         INPUT s_icn_Dbs:HANDLE in frame browse,
      	       	     	      	 INPUT false).
      end.
   end.

   when {&OBJ_FLD} OR
   when {&OBJ_IDX} then
   do:
      /* Set up for some common "empty list" processing below */
      assign
         fill_widget = (if p_Obj_Num = {&OBJ_FLD}
            then s_FldFill:HANDLE in frame browse
            else s_IdxFill:HANDLE in frame browse)
         msg = (if p_Obj_Num = {&OBJ_FLD} 
            then "(no fields)"
            else "(no indexes)").

      /* Things to adjust if a different object has been selected */
      if s_Lvl2Obj <> p_Obj_Num then 
      do:
      	 /* Since there is a separate list box for each type (so the values
      	    can be cached), hide the currently displayed list box at the 2nd
      	    level before displaying the one with the type of objects  we want.
      	 */
      	 if s_Lvl2Obj <> {&OBJ_NONE} then
            run Show_List (INPUT s_Lvl2Obj, INPUT no).

      	 run Show_List (INPUT p_Obj_Num, INPUT yes).
	 s_Lvl2Obj = p_Obj_Num.
      end.
   end.  /* end case for level 2 objects */

   otherwise /* {&OBJ_TBL}  {&OBJ_SEQ} */
   do:
      /* Adjust children of tables if we've just gone from empty to
      	 non-empty table list or vice versa */
      if p_Obj_Num = {&OBJ_TBL} then
      do:
	 if p_Cnt = 0 then
	 do:
	    /* Hide toggles and lists of children if table list is empty */
      	    run Show_Toggles (INPUT 2, INPUT no).
	    run Show_List (INPUT {&OBJ_FLD}, INPUT no).
	    run Show_List (INPUT {&OBJ_IDX}, INPUT no).
      	    s_Lvl2Obj = {&OBJ_NONE}.
	 end.        
	 else 
	    /* Make toggles for children visible if table isn't empty */
      	    run Show_Toggles (INPUT 2, INPUT yes).
      end.

      /* Set up for some common "empty-list" processing below */
      assign
	 fill_widget =
	    (if p_Obj_Num = {&OBJ_TBL} then
	       s_TblFill:HANDLE in frame browse
	    else if p_Obj_Num = {&OBJ_SEQ} then
	       s_SeqFill:HANDLE in frame browse
	    else ?  )
      	 msg = 
	    (if p_Obj_Num = {&OBJ_TBL} then
	       "(no tables)"
	    else if p_Obj_Num = {&OBJ_SEQ} then
	       "(no sequences)"
	    else "(no indexes)").

      /* Things to adjust if a different object has been selected */
      if s_Lvl1Obj <> p_Obj_Num then 
      do:
      	 /* Since there is a separate list box for each type (so the values
      	    can be cached), hide the currently displayed list box at the first
      	    level before displaying the one with the type of objects  we want.
      	 */
      	 if s_Lvl1Obj <> {&OBJ_NONE} then
      	    run Show_List (INPUT s_Lvl1Obj, INPUT no).
      	 run Show_List (INPUT p_Obj_Num, INPUT yes).

      	 /* If tables was toggled on, show level 2 toggles unless the
      	    table list is empty.  If one of the children lists was displayed
      	    the last time tables were selected then display it again. */
	 if p_Obj_Num = {&OBJ_TBL} AND p_Cnt > 0 then
      	 do:
      	    run Show_Toggles (INPUT 2, INPUT yes).
      	    if s_icn_Flds:PRIVATE-DATA in frame browse = "curr" then
      	    do:
      	       run Show_List (INPUT {&OBJ_FLD}, INPUT yes).
      	       s_Lvl2Obj = {&OBJ_FLD}.
      	    end.
      	    else if s_icn_Idxs:PRIVATE-DATA in frame browse = "curr" then
      	    do:
      	       run Show_List (INPUT {&OBJ_IDX}, INPUT yes).
      	       s_Lvl2Obj = {&OBJ_IDX}.
      	    end.
      	 end.
	 else do:
      	    /* Domains and sequences have no associated level 2 items */
      	    run Show_Toggles (INPUT 2, INPUT no).
      	    run Show_List (INPUT {&OBJ_FLD}, INPUT no).
      	    run Show_List (INPUT {&OBJ_IDX}, INPUT no).
	    s_Lvl2Obj = {&OBJ_NONE}.
	 end.
      
	 s_Lvl1Obj = p_Obj_Num.
      end.
   end.  /* end case for level 1 objects */
end.  /* end case */


/* If the list is empty, disable it and put a message in the fill-in:
   e.g., (no tables).
*/
if p_Obj_Num <> {&OBJ_DB} then
do:
   if p_Cnt = 0 then 
      assign
      	 fill_widget:screen-value = msg
      	 fill_widget:sensitive = no.
   else 
      assign
      	 fill_widget:sensitive = yes.
end.

/* Gray/ungray menu items based on new selections. For efficiency, don't 
   do this under one circumstance: if we've switched to some database
   we will cause the table list to be displayed by default - that will
   cause this to be re-called and we will gray the menus then based on
   what tables there are etc.
*/
if NOT (p_Obj_Num = {&OBJ_DB} AND p_Cnt <> 0) then
   run adedict/_brwgray.p (INPUT false).





/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _brwbtn.p (push browse button)

Description:
   Do some stuff that is necessary when the user pushes one of the object
   buttons on the browse window (or when the codes needs to select the database
   object because there are no connected databases).
 
Input Parameters:
   p_Obj       	   - The object type of the button pushed.
   p_Icn       	   - The icon widget for this object type.
   p_Lvl2_Remember - If true: if a level 2 button is currently pushed and
      	       	     we switch to a non-level object, remember which level 2
      	       	     object was current.
      	       	     If false: we don't care to remember.  In fact, reset
      	       	     the flag on both buttons.

Author: Laura Stern

Date Created: 09/23/92 

----------------------------------------------------------------------------*/

{adedict/dictvar.i shared}
{adedict/brwvar.i shared}

Define INPUT PARAMETER p_Obj  	       as integer       NO-UNDO.
Define INPUT PARAMETER p_Icn  	       as widget-handle NO-UNDO.
Define INPUT PARAMETER p_Lvl2_Remember as logical     	NO-UNDO.

/* Set to button down icon */
case p_Obj:
   when {&OBJ_DB} then
      s_Res = p_Icn:LOAD-IMAGE("adeicon/db-d").
   when {&OBJ_TBL} then
      s_Res = p_Icn:LOAD-IMAGE("adeicon/table-d").  
   when {&OBJ_SEQ} then
      s_Res = p_Icn:LOAD-IMAGE("adeicon/seq-d").
   when {&OBJ_FLD} then
      s_Res = p_Icn:LOAD-IMAGE("adeicon/flds-d").
   when {&OBJ_IDX} then
      s_Res = p_Icn:LOAD-IMAGE("adeicon/index-d").
end.

/* Un-push whatever button is currently pushed in. */
run adedict/_btnup.p.

/* For level 2 objects, remember which one is pushed. Then if we 
   switch from table to sequence and back again we want to reshow
   (not repush - only table will be pushed in) the list that was 
   selected last. 
*/
if p_Lvl2_Remember then
   if p_Obj <> {&OBJ_FLD} AND p_Obj <> {&OBJ_IDX} then  /* for efficiency */
   do:
      if s_CurrObj = {&OBJ_FLD} then 
	 assign
	    s_icn_Flds:PRIVATE-DATA in frame browse = "curr"
	    s_icn_Idxs:PRIVATE-DATA in frame browse = "notcurr".
      else if s_CurrObj = {&OBJ_IDX} then
	 assign
	    s_icn_Flds:PRIVATE-DATA in frame browse = "notcurr"
	    s_icn_Idxs:PRIVATE-DATA in frame browse = "curr".
   end.
else
   assign
      s_icn_Flds:PRIVATE-DATA in frame browse = ?
      s_icn_Idxs:PRIVATE-DATA in frame browse = ?.

s_CurrObj = p_Obj.

/* Reset labels */
case s_CurrObj:
   when {&OBJ_DB} then
      assign
   	 s_btn_Create:label in frame browse = "C&reate Database..."
   	 s_btn_Props:label in frame browse = "Database &Properties"
   	 s_btn_Delete:hidden in frame browse = yes. /* no such function */
   when {&OBJ_TBL} then
      assign
   	 s_btn_Create:label in frame browse = "C&reate Table..."
   	 s_btn_Props:label in frame browse = "Table &Properties..."
   	 s_btn_Delete:label in frame browse = "De&lete Table"
   	 s_btn_Delete:hidden in frame browse = no.
  
   when {&OBJ_SEQ} then
      assign
   	 s_btn_Create:label in frame browse = "C&reate Sequence..."
   	 s_btn_Props:label in frame browse = "Sequence &Properties..."
   	 s_btn_Delete:label in frame browse = "De&lete Sequence"
   	 s_btn_Delete:hidden in frame browse = no.
   when {&OBJ_FLD} then
      assign
   	 s_btn_Create:label in frame browse = "C&reate Field..."
   	 s_btn_Props:label in frame browse = "Field &Properties..."
   	 s_btn_Delete:label in frame browse = "De&lete Field"
   	 s_btn_Delete:hidden in frame browse = no.
   when {&OBJ_IDX} then
      assign
   	 s_btn_Create:label in frame browse = "C&reate Index..."
   	 s_btn_Props:label in frame browse = "Index &Properties..."
   	 s_btn_Delete:label in frame browse = "De&lete Index"
   	 s_btn_Delete:hidden in frame browse = no.
end.

/* Make sure these are visible.  They should be except for the first time.
   Put this here to make sure the buttons don't appear with the wrong
   label on them at startup.  If already visible, this SHOULD be fast.
*/
assign
   s_btn_Create:hidden in frame browse = no
   s_btn_Props:hidden in frame browse = no.


/*********************************************************************
* Copyright (C) 2006,2009 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------
File: _brwgray.p

Description:
   On each change of state in the dictionary, this is called to gray or ungray
   menu items as appropriate for the state.  States are based on
   what is selected.  See dictvar.i for a more complete comment on
   the meaning of each state.  The enabled-ness of the browse buttons 
   (create/props/delete) is also adjusted here.
   
   NOTE: Undo and Commit are handled by a different mechanism.
      	 Undo and commit are grayed/ungrayed based on whether
      	 the dictionary is dirty or not.  Connect and disconnect are 
      	 also handled separately - Connect is always sensitive.  Disconnect
      	 is sensitive unless there are no databases in the list. 

Input Parameter:
   p_Init - yes  - initialize the gray tables.
      	    no   - gray/ungray menu items as appropriate.

Author: Laura Stern

Date Created: 03/26/92 
    Modified: 01/14/98 D. McMann added graying out of create button when
                                 AS400 or ORACLE databases
              05/19/99 Mario B.  Adjust Width Field browser integration.   
              03/22/00 D. McMann Added support for MS SQL Server 7 (MSS)   
              09/18/02 D. McMann Added verify data report 		 
              07/19/05 kmcintos  Added Auditing Reports
              07/27/05 kmcintos  Added check for db connection before creating
                                 a buffer for _file 20050727-027.
              04/07/09 fernando  Support for encryption reports
----------------------------------------------------------------------------*/
CREATE WIDGET-POOL.

{adedict/dictvar.i shared}
{adedict/menu.i shared}
{adedict/brwvar.i shared}

Define INPUT PARAMETER p_Init as logical NO-UNDO.

/* Indicates which items need to be grayed (no) or ungrayed (yes). */
Define var ungray    as logical extent {&NUM_GRAY_ITEMS} NO-UNDO.
Define var read_only as logical                          NO-UNDO.

DEFINE VARIABLE lAuditing AS LOGICAL                     NO-UNDO.
DEFINE VARIABLE lSecurity AS LOGICAL                     NO-UNDO.

DEFINE VARIABLE hMenuItem AS HANDLE                      NO-UNDO.
DEFINE VARIABLE hBuffer   AS HANDLE                      NO-UNDO.

&Global-define    DETAILEDTBL      1 
&Global-define    QUICKTBL         2 
&Global-define    FLDRPT_CURRTBL   3
&Global-define    FLDRPT_ALLTBLS   4
&Global-define    IDXRPT_CURRTBL   5
&Global-define    IDXRPT_ALLTBLS   6
&Global-define    QUICKVIW   	 7
&Global-define    QUICKSEQ   	 8 
&Global-define    TRIG_RPT    	 9
&Global-define    QUICKUSR    	 10 
&Global-define    RELRPT_CURRTBL   11
&Global-define    RELRPT_ALLTBLS   12
&Global-define    EXIT	      	 13
&Global-define    DELETE           14
&Global-define    PROPERTIES	 15
&Global-define    CRT_DATABASE	 16
&Global-define    CRT_TABLE   	 17
&Global-define    CRT_SEQUENCE	 18
&Global-define    CRT_FIELD   	 19
&Global-define    CRT_INDEX   	 20
&Global-define    FIELD_RENAME	 21
&Global-define    FIELD_RENUMBER   22
&Global-define    SQL_WIDTH        23
&Global-define    SHOW_HIDDEN 	 24
&Global-define    ORDER_FIELDS	 25
&Global-define    BUTTON_CREATE    26
&Global-define    BUTTON_PROPS     27   
&Global-define    BUTTON_DELETE    28   
&Global-define    MODE_DATABASE    29
&Global-define    MODE_TABLE       30
&Global-define    MODE_SEQUENCE    31
&Global-define    MODE_FIELD       32
&Global-define    MODE_INDEX       33
&Global-define    DATA_RPT         34
&Global-define    REPORTS_MENU     35
&Global-define    ENC_REPORTS      36
&Global-define    ALTBUF_REPORT    37


Define var item   as integer  	    NO-UNDO. /* index into Gray_Items array */
Define var h_item as widget-handle  NO-UNDO. /* menu item handle value */


/*--------------------------- Mainline Code --------------------------------*/
if p_Init then
do:
   assign
      Gray_Items[{&DETAILEDTBL}]    = MENU-ITEM mi_DetailedTbl:HANDLE
      Gray_Items[{&QUICKTBL}]  	    = MENU-ITEM mi_QuickTbl:HANDLE
      Gray_Items[{&FLDRPT_CURRTBL}] = MENU-ITEM mi_f_CurrTbl:HANDLE
      Gray_Items[{&FLDRPT_ALLTBLS}] = MENU-ITEM mi_f_AllTbls:HANDLE
      Gray_Items[{&IDXRPT_CURRTBL}] = MENU-ITEM mi_i_CurrTbl:HANDLE
      Gray_Items[{&IDXRPT_ALLTBLS}] = MENU-ITEM mi_i_AllTbls:HANDLE
      Gray_Items[{&QUICKVIW}]       = MENU-ITEM mi_QuickViw:HANDLE
      Gray_Items[{&QUICKSEQ}]       = MENU-ITEM mi_QuickSeq:HANDLE
      Gray_Items[{&TRIG_RPT}] 	    = MENU-ITEM mi_Trigger:HANDLE
      Gray_Items[{&QUICKUSR}]       = MENU-ITEM mi_QuickUsr:HANDLE
      Gray_Items[{&RELRPT_CURRTBL}] = MENU-ITEM mi_r_CurrTbl:HANDLE
      Gray_Items[{&RELRPT_ALLTBLS}] = MENU-ITEM mi_r_AllTbls:HANDLE
      Gray_Items[{&DATA_RPT}]       = MENU-ITEM mi_Width:HANDLE
      Gray_Items[{&EXIT}]     	    = MENU-ITEM mi_Exit:HANDLE
      Gray_Items[{&DELETE}]   	    = MENU-ITEM mi_Delete:HANDLE
      Gray_Items[{&PROPERTIES}]     = MENU-ITEM mi_Properties:HANDLE
      Gray_Items[{&CRT_DATABASE}]   = MENU-ITEM mi_Crt_Database:HANDLE
      Gray_Items[{&CRT_TABLE}] 	    = MENU-ITEM mi_Crt_Table:HANDLE
      Gray_Items[{&CRT_SEQUENCE}]   = MENU-ITEM mi_Crt_Sequence:HANDLE
      Gray_Items[{&CRT_FIELD}] 	    = MENU-ITEM mi_Crt_Field:HANDLE
      Gray_Items[{&CRT_INDEX}] 	    = MENU-ITEM mi_Crt_Index:HANDLE
      Gray_Items[{&FIELD_RENAME}]   = MENU-ITEM mi_Field_Rename:HANDLE
      Gray_Items[{&FIELD_RENUMBER}] = MENU-ITEM mi_Field_Renumber:HANDLE
      Gray_Items[{&SQL_WIDTH}]      = MENU-ITEM mi_SQL_Width:HANDLE
      Gray_Items[{&SHOW_HIDDEN}]    = MENU-ITEM mi_Show_Hidden:HANDLE
      Gray_Items[{&ORDER_FIELDS}]   = MENU-ITEM mi_Order_Fields:HANDLE
      Gray_Items[{&BUTTON_CREATE}]  = s_btn_Create:HANDLE in frame browse
      Gray_Items[{&BUTTON_PROPS}]   = s_btn_Props:HANDLE in frame browse
      Gray_Items[{&BUTTON_DELETE}]  = s_btn_Delete:HANDLE in frame browse
      Gray_Items[{&MODE_DATABASE}]  = MENU-ITEM mi_Mode_Db:HANDLE
      Gray_Items[{&MODE_TABLE}]     = MENU-ITEM mi_Mode_Tbl:HANDLE
      Gray_Items[{&MODE_SEQUENCE}]  = MENU-ITEM mi_Mode_Seq:HANDLE
      Gray_Items[{&MODE_FIELD}]     = MENU-ITEM mi_Mode_Fld:HANDLE
      Gray_Items[{&MODE_INDEX}]     = MENU-ITEM mi_Mode_Idx:HANDLE
      Gray_Items[{&REPORTS_MENU}]   = SUB-MENU s_mnu_Reports:HANDLE
      Gray_Items[{&ENC_REPORTS}]    = SUB-MENU s_mnu_Enc_Rep:HANDLE
      Gray_Items[{&ALTBUF_REPORT}]  = MENU-ITEM mi_AltBufPool:HANDLE
      .

   /* Initialize these. */
   assign
      MENU-ITEM mi_Undo:sensitive = false
      MENU-ITEM mi_Commit:sensitive = false
      MENU-ITEM mi_Connect:sensitive = true
      MENU-ITEM mi_Disconnect:sensitive = true.

   return.
end.
/*-----------------------End of Init code-------------------------------*/

ungray = no.  /* init array to no's */
read_only = s_ReadOnly OR s_DB_ReadOnly.

/* For each progressive state determine which items should be enabled */
if s_DictState >= {&STATE_NO_DB_SELECTED} then
   assign
      ungray[{&EXIT}] = yes
      ungray[{&CRT_DATABASE}] = yes
      ungray[{&BUTTON_CREATE}] = yes
      ungray[{&MODE_DATABASE}] = yes.

if s_DictState >= {&STATE_NO_OBJ_SELECTED} then
do:
   assign
      ungray[{&REPORTS_MENU}] = YES
      ungray[{&DETAILEDTBL}] = yes
      ungray[{&QUICKTBL}] = yes
      ungray[{&FLDRPT_ALLTBLS}] = yes
      ungray[{&IDXRPT_ALLTBLS}] = yes
      ungray[{&QUICKVIW}] = yes
      ungray[{&QUICKSEQ}] = yes
      ungray[{&QUICKUSR}] = yes
      ungray[{&TRIG_RPT}] = yes
      ungray[{&RELRPT_ALLTBLS}] = yes
      ungray[{&DATA_RPT}] = YES
      ungray[{&ALTBUF_REPORT}] = YES.

   if s_CurrObj = {&OBJ_DB} then
      assign
      	 ungray[{&PROPERTIES}] = yes
      	 ungray[{&BUTTON_PROPS}] = yes.
   ELSE if read_only then
      	 ungray[{&BUTTON_CREATE}] = no.      
      	 
   if NOT read_only then
      assign
	 ungray[{&CRT_TABLE}] = yes
	 ungray[{&MODE_TABLE}] = YES
	 ungray[{&CRT_SEQUENCE}] = yes
	 ungray[{&MODE_SEQUENCE}] = yes.
    
    /* IF foreign database do not let user create tables or sequences */	 
    if s_DbCache_Type[s_DbCache_ix] = "ORACLE" OR
       s_DbCache_Type[s_DbCache_ix] = "ODBC"   OR
       s_DbCache_Type[s_DbCache_ix] = "MSS"    OR
       s_DbCache_Type[s_DbCache_ix] = "AS400"  THEN
       ASSIGN ungray[{&CRT_TABLE}] = no
              ungray[{&CRT_SEQUENCE}] = no
              ungray[{&BUTTON_CREATE}] = no
              ungray[{&DATA_RPT}] = NO
              ungray[{&ALTBUF_REPORT}] = NO.
    ELSE DO:
        /* check if encryption is enabled for the database */
        IF CONNECTED("DICTDB") THEN DO:
           CREATE BUFFER hBuffer FOR TABLE "DICTDB._database-feature" NO-ERROR.
           IF VALID-HANDLE(hBuffer) THEN DO:
              hBuffer:FIND-FIRST("WHERE _database-feature._dbfeature_name = ~'encryption~'",
                             NO-LOCK) NO-ERROR.
              IF hBuffer:AVAILABLE THEN DO:
                 IF hBuffer::_dbfeature_enabled = "1" THEN
                    ungray[{&ENC_REPORTS}] = YES.
              END.
              DELETE OBJECT hBuffer.
           END.
        END.
    END.
end.

if s_DictState = {&STATE_OBJ_SELECTED} then
do:
   if s_Lvl1Obj = {&OBJ_TBL} then
      assign
      	 ungray[{&SHOW_HIDDEN}] = yes.

   if ((s_CurrObj = {&OBJ_TBL} AND s_CurrTbl <> "") OR
       (s_CurrObj = {&OBJ_SEQ} AND s_CurrSeq <> "") OR
       (s_CurrObj = {&OBJ_FLD} AND s_CurrFld <> "") OR
       (s_CurrObj = {&OBJ_IDX} AND s_CurrIdx <> "")) then
   do:
      assign
      	 ungray[{&PROPERTIES}] = yes
      	 ungray[{&BUTTON_PROPS}] = yes.
      if NOT read_only then
      	 assign
      	    ungray[{&DELETE}] = yes
      	    ungray[{&BUTTON_DELETE}] = yes.
   end.
   if (s_Lvl1Obj = {&OBJ_TBL} AND s_CurrTbl <> "") OR s_win_Tbl <> ? then
   do:
      assign
      	 ungray[{&FLDRPT_CURRTBL}] = yes
      	 ungray[{&IDXRPT_CURRTBL}] = yes
      	 ungray[{&RELRPT_CURRTBL}] = yes.
      
      if s_DbCache_type[s_DbCache_ix] = "PROGRESS" THEN
         ungray[{&SQL_WIDTH}]      = yes.

      if NOT read_only then
      	 assign
	    ungray[{&CRT_FIELD}] = yes
	    ungray[{&CRT_INDEX}] = yes
      	    ungray[{&FIELD_RENAME}] = yes
	    ungray[{&FIELD_RENUMBER}] = yes
      	    ungray[{&MODE_FIELD}] = yes
      	    ungray[{&MODE_INDEX}] = yes.
      	    
      if s_DbCache_Type[s_DbCache_ix] = "ORACLE" OR
         s_DbCache_Type[s_DbCache_ix] = "ODBC"   OR
         s_DbCache_Type[s_DbCache_ix] = "MSS"   OR
         s_DbCache_Type[s_DbCache_ix] = "AS400"  THEN
        ASSIGN ungray[{&CRT_FIELD}] = no
               ungray[{&BUTTON_CREATE}] = no.

      IF s_DbCache_Type[s_DbCache_ix] = "AS400" THEN        
        ASSIGN ungray[{&CRT_INDEX}] = no.       
        
      /* The following handles the graying of items when Adjust SQL Width    *
       * browse screen is open. 
      */
      IF s_win_Width <> ? THEN
        ASSIGN 
           ungray[{&BUTTON_CREATE}]  = IF s_CurrObj = {&OBJ_TBL} OR 
                                          s_CurrObj = {&OBJ_FLD} THEN 
                                             NO ELSE YES
           ungray[{&BUTTON_PROPS}]   = IF s_CurrObj = {&OBJ_FLD} THEN 
                                             NO ELSE YES

           ungray[{&CRT_TABLE}]      = NO
           ungray[{&DELETE}]         = IF s_CurrObj = {&OBJ_FLD} THEN
	                                     NO ELSE YES
           ungray[{&PROPERTIES}]     = IF s_CurrObj = {&OBJ_FLD} THEN
	                                     NO ELSE YES
           ungray[{&CRT_FIELD}]      = NO
           ungray[{&FIELD_RENAME}]   = NO
           ungray[{&FIELD_RENUMBER}] = NO.

   end.

   if (s_Lvl1Obj = {&OBJ_SEQ} AND s_CurrTbl <> "") OR s_win_Tbl <> ? THEN
      IF s_win_Width <> ? THEN
         ASSIGN
            ungray[{&CRT_TABLE}] = NO.          
         
   if (s_Lvl2Obj = {&OBJ_FLD} AND s_CurrFld <> "") then
      assign
      	 ungray[{&ORDER_FIELDS}] = yes.
    if s_CurrObj = {&OBJ_IDX} AND NOT read_only AND
       (s_DbCache_Type[s_DbCache_ix] = "ORACLE" OR
	    s_DbCache_Type[s_DbCache_ix] = "ODBC" OR
        s_DbCache_Type[s_DbCache_ix] = "MSS" ) THEN
      ASSIGN ungray[{&BUTTON_CREATE}] = yes.

     IF s_CurrObj = {&OBJ_IDX} AND
        s_DbCache_Type[s_DbCache_ix] = "AS400" THEN
           ASSIGN ungray[{&CRT_INDEX}] = no
                  ungray[{&BUTTON_CREATE}] = no.
                            
                  
     IF s_win_Width <> ? AND s_CurrObj = {&OBJ_FLD} THEN
        ASSIGN
           ungray[{&BUTTON_DELETE}] = NO.      
           
     IF s_win_Width <> ? AND s_CurrObj = {&OBJ_IDX} THEN
        ASSIGN
           ungray[{&DELETE}] = yes
           ungray[{&PROPERTIES}] = yes.
                 

     IF s_win_FLD <> ? THEN
        ASSIGN
           ungray[{&SQL_WIDTH}] = NO.      
  
end.

/* Now enable all those we just set "yes" for.  Whatever is left "no"
   in the ungray array needs to be disabled.
*/
do item = 1 to {&NUM_GRAY_ITEMS}:
   if Gray_Items[item] <> ? then
      Gray_Items[item]:sensitive = ungray[item].     
end.

IF CONNECTED("DICTDB") THEN DO:
  CREATE BUFFER hBuffer FOR TABLE "DICTDB._file".
  hBuffer:FIND-FIRST("WHERE _tbl-type EQ ~'S~'" + 
                     " AND _file-name BEGINS ~'_aud-~'",NO-LOCK) NO-ERROR.
  lAuditing = hBuffer:AVAILABLE.
  hBuffer:FIND-FIRST("WHERE _tbl-type EQ ~'S~'" + 
                     " AND _file-name BEGINS ~'_sec-~'",NO-LOCK) NO-ERROR.
  lSecurity = hBuffer:AVAILABLE.

  DELETE OBJECT hBuffer.
END.

hMenuItem = SUB-MENU s_mnu_Aud_Rep:HANDLE:FIRST-CHILD.

DO WHILE VALID-HANDLE(hMenuItem):
  IF hMenuItem:NAME BEGINS "mi_ADRpt" THEN
    hMenuItem:SENSITIVE = lAuditing.
  ELSE IF hMenuItem:NAME BEGINS "mi_CSRpt" THEN
    hMenuItem:SENSITIVE = lSecurity.

  hMenuItem = hMenuItem:NEXT-SIBLING.
END.
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _brwlist.p

Description:
   Fill one of the selection lists shown in the browse window.

Input Parameter:
   p_Obj - The object type indicating which list to fill.
 
Author: Laura Stern

Date Created: 02/04/92 
    Modified: 07/10/98 D. McMann Added _Owner to _File find.
              08/08/02 D. McMann Eliminated any sequences whose name begins "$" - Peer Direct

----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/uivar.i shared}


Define INPUT parameter p_Obj as integer NO-UNDO.


/*----------------------------------------------------------------------
   Do some common processing for all objects.

   Input Parameters:
      p_Obj    - The object type indicating which list to fill.
      p_List   - Handle of selection list for this object

   Input/Output Parameters:
      p_Cached - Cached flag

   Output Parameters:
      p_Curr   - Set to the selected value in the list (the first value).

----------------------------------------------------------------------*/
PROCEDURE Finish_Up:

Define INPUT   	     PARAMETER p_Obj  as integer     	 NO-UNDO.
Define INPUT   	     PARAMETER p_List as widget-handle 	 NO-UNDO.
Define INPUT-OUTPUT  PARAMETER p_Cached as logical    	 NO-UNDO.

Define var val as char NO-UNDO.

   if NOT p_Cached then  
   do:
      val = p_List:Entry(1).
      if val <> ? then  /* will be ? if list is empty */
      	 p_List:SCREEN-VALUE = val.
      apply "value-changed" to p_List.
      p_Cached = true.
   end.

   /* view and hide stuff in the browse window. */
   run adedict/_brwadj.p (INPUT p_Obj, INPUT p_List:num-items).
end.   


/*---------------------------Mainline code-------------------------------*/

Define var access as logical NO-UNDO.

CURRENT-WINDOW = s_win_Browse.
s_DictState = {&STATE_OBJ_SELECTED}.

case p_Obj:
   when {&OBJ_TBL} then
   do:
      if NOT s_Tbls_Cached then
      do: 
      	 run adecomm/_tbllist.p
      	    (INPUT  s_lst_Tbls:HANDLE in frame browse,
      	     INPUT  s_Show_Hidden_Tbls,
      	     INPUT  s_DbRecId,
      	     INPUT  "",
             INPUT  " " , /* all foreign types allowed (hutegger 95/06) */
                   /* BUFFER,FUNCTION,PACKAGE,PROCEDURE,SEQUENCE,VIEW", */
      	     OUTPUT access).
      end.

      run Finish_Up (INPUT p_Obj,
      	       	     INPUT s_lst_Tbls:HANDLE in frame browse,
      	       	     INPUT-OUTPUT s_Tbls_Cached).
   end.  

   when {&OBJ_SEQ} then
   do:
      if NOT s_Seqs_Cached then
      do:
      	 find _File WHERE _File._File-name = "_Sequence"
      	              AND _File._Owner = "PUB"
      	              NO-LOCK.
      	 if NOT can-do(_File._Can-read, USERID("DICTDB")) then
      	    message s_NoPrivMsg "see any sequence information."
      	       view-as ALERT-BOX ERROR buttons OK.
      	 else
	    for each _Sequence where _Sequence._Db-recid = s_DbRecId
                             AND NOT _Sequence._Seq-name BEGINS "$":
	       s_Res = s_lst_Seqs:add-last(_Sequence._Seq-name) in frame browse.
	    end.
      end.
   
      run Finish_Up (INPUT p_Obj,
      	       	     INPUT s_lst_Seqs:HANDLE in frame browse,
      	       	     INPUT-OUTPUT s_Seqs_Cached).
   end.

   when {&OBJ_FLD} then
   do:
      if s_CurrTbl = "" then return.
   
      if NOT s_Flds_Cached then
      do:
      	 run adecomm/_fldlist.p
      	    (INPUT   s_lst_Flds:HANDLE in frame browse,
      	     INPUT   s_TblRecId,
      	     INPUT   (if s_Order_By = {&ORDER_ALPHA} then true else false),
      	     INPUT   "",
      	     INPUT   ?,
	     INPUT   no,
      	     INPUT   "",
      	     OUTPUT  access).
      end.
   
      run Finish_Up (INPUT p_Obj,
      	       	     INPUT s_lst_Flds:HANDLE in frame browse,
      	       	     INPUT-OUTPUT s_Flds_Cached).
   end.

   when {&OBJ_IDX} then
   do:
      if s_CurrTbl = "" then return.
   
      if NOT s_Idxs_Cached then
      do:
      	 find _File WHERE _File._File-name = "_Index"
      	              AND _File._Owner = "PUB"
      	              NO-LOCK.
      	 if NOT can-do(_File._Can-read, USERID("DICTDB")) then
      	    message s_NoPrivMsg "see any index information."
      	       view-as ALERT-BOX ERROR buttons OK.
      	 else
	    for each _Index where _Index._File-recid = s_TblRecId:
	       s_Res = s_lst_Idxs:add-last(_Index._Index-name) in frame browse.
	    end.
      end.

      run Finish_Up (INPUT p_Obj,
      	       	     INPUT s_lst_Idxs:HANDLE in frame browse,
      	       	     INPUT-OUTPUT s_Idxs_Cached).
   end.
end. /* case */






/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _btnup.p

Description:
   Toggle whichever one of the browse window "show object" buttons is pushed 
   in to be un-pushed.  This means bring the "up" button to the top of 
   the z order stack so that this is the one users see.

Author: Laura Stern

Date Created: 09/22/92 

----------------------------------------------------------------------------*/

{adedict/dictvar.i shared}
{adedict/brwvar.i shared}

case s_CurrObj:
   when {&OBJ_DB} then
      s_Res = s_Icn_Dbs:LOAD-IMAGE("adeicon/db-u").
   when {&OBJ_TBL} then
      s_Res = s_Icn_Tbls:LOAD-IMAGE("adeicon/table-u").
   when {&OBJ_SEQ} then
      s_Res = s_Icn_Seqs:LOAD-IMAGE("adeicon/seq-u").
   when {&OBJ_FLD} then
      s_Res = s_Icn_Flds:LOAD-IMAGE("adeicon/flds-u").
   when {&OBJ_IDX} then
      s_Res = s_Icn_Idxs:LOAD-IMAGE("adeicon/index-u").
end.


/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _capab.p

Description:
   Return the set of capabilities for a particular category and gateway
   (the gateway type of the current database).
 
Input Parameters:
   p_Category  - The capability category (e.g, &CAPAB_TBL).

Output Parameters:
   p_Var       - The variable to store the capability string in.

Author: Laura Stern

Date Created: 06/05/92

History:
    99/08/02    D. McMann   added sequence support for AS/400
    98/06/29    D. McMann   added delete sequence capability for Oracle
    94/12/06    gfs         added add table for odbc
    94/08/12    hutegger    added uniqueness-changable for ora,syb & rdb
    94/01/27    hutegger    added sequence-capab's

----------------------------------------------------------------------------*/

{adedict/dictvar.i shared}
{adedict/capab.i}

Define INPUT   PARAMETER p_Category as integer  NO-UNDO.
Define OUTPUT  PARAMETER p_Var      as char     NO-UNDO.

/*
   Capabilities are retrieved by extracting the corresponding entry
   in the xxx_capab string (a comma separated list).

   Category:
   1 - Table capabilities (&CAPAB_TBL)
      a = CAPAB_ADD  	      	 (can add)
      n = CAPAB_FOR_NAME  	 (has foreign name)
      f = CAPAB_CHANGE_FOR_NAME  (can change foreign name)
      r = CAPAB_RENAME	      	 (can rename)
      o = CAPAB_OWNER	      	 (has owner name)
      # = CAPAB_TBL_NUMBER       (has table number)
      s = CAPAB_TBL_SIZE	 (has table size)
      z = CAPAB_CHANGE_TBL_SIZE  (can change table size)
      t = CAPAB_TBL_TYPE_ADD     (can set table type on add)
      m = CAPAB_TBL_TYPE_MOD     (can change table type)

   2 - Field capabilities (&CAPAB_FLD)
      a = CAPAB_ADD  	      	 (can add)
      c = CAPAB_COPY 	      	 (can copy)
      t = CAPAB_CHANGE_DATA_TYPE (can change data type)
      e = CAPAB_CHANGE_EXTENT    (can change extent (when not in index))
      l = CAPAB_OFFLEN_REQ       (offset and length required)
      d = CAPAB_DECIMALS_REQ     (decimals required)
      s = CAPAB_CHAR_LEN_IN_DEC  (store character length in _Decimals field)
      m = CAPAB_CHANGE_MANDATORY (can set/change mandatory)
      v = CAPAB_CHANGE_CASE_SENS (can set/change case sensitivity)

   3 - Index capabilities (&CAPAB_IDX)
      a = CAPAB_ADD  	      	 (can add)
      d = CAPAB_DELETE	      	 (can delete)
      i = CAPAB_INACTIVATE    	 (can inactivate)
      p = CAPAB_CHANGE_PRIMARY	 (can change primary)
      w = CAPAB_WORD_INDEX    	 (word index allowed)
      f = CAPAB_FIELD_COMP    	 (field components as opposed to pos/offset)
      u = CAPAB_CHANGE_UNIQ      (can change uniqueness)
      # = CAPAB_GATE_IDXNUM      (call gateway specific routine to get index #)

   4 - Index; max # of components (&CAPAB_IDXMAX)

   5 - Sequence capabilities (&CAPAB_SEQ)
      a = CAPAB_ADD  	      	 (can add)
      d = CAPAB_DELETE           (can delete)
      m = CAPAB_MODIFY  	 (can modify anything beyond name)
      n = CAPAB_FOR_NAME  	 (has foreign name)
      o = CAPAB_OWNER	      	 (has owner name)
      r = CAPAB_RENAME	      	 (can rename)
      s = CAPAB_SEQ_SUPPORTED  	 (on that DataServer)
*/
         
Define var odbtyp   	  as char                                         NO-UNDO.
Define var pro_capab 	  as char init "ar#    ,acmv   ,adfipw,16,admrs"  NO-UNDO.
Define var rms_capab 	  as char init "nfors  ,actelds,f     ,64,     "  NO-UNDO.
Define var rdb_capab 	  as char init "nrs    ,t      ,fpu   ,16,     "  NO-UNDO.
Define var cisam_capab 	  as char init "nfrs   ,actelds,      , 8,     "  NO-UNDO.
Define var netisam_capab  as char init "nfrs   ,actelds,      , 8,     "  NO-UNDO.
Define var oracle_capab   as char init "nor    ,tsm    ,adfpu#,16,dnors"  NO-UNDO.
Define var sybase_capab   as char init "nor    ,mv     ,adfpu#,16,     "  NO-UNDO.
Define var as400_capab 	  as char init "nr     ,ldm    ,f     ,64,ds   "  NO-UNDO.
Define var ctosisam_capab as char init "anfrsz ,actlds ,adp   ,16,     "  NO-UNDO.
Define var odb_capab      as char init "anro    ,tdm    ,adfpu#,16,dnors"  NO-UNDO.


/*-----------------------------------------------------------------------*/

Define var idx as integer NO-UNDO.

case (s_DbCache_Type[s_DbCache_ix]):
   when "RDB" then assign
      p_Var  = ENTRY(p_Category, rdb_capab).
   when "ORACLE" then assign
      p_Var  = ENTRY(p_Category, oracle_capab).
   when "SYBASE" then assign
      p_Var  = ENTRY(p_Category, sybase_capab).
   when "RMS" then assign
      p_Var  = ENTRY(p_Category, rms_capab).
   when "CISAM" then assign
      p_Var  = ENTRY(p_Category, cisam_capab).
   when "NETISAM" then assign
      p_Var  = ENTRY(p_Category, netisam_capab).
   when "AS400" then assign
      p_Var  = ENTRY(p_Category, as400_capab).
   when "CTOSISAM" then assign
      p_Var  = ENTRY(p_Category, ctosisam_capab).
   otherwise assign 
      odbtyp = { adecomm/ds_type.i
                   &direction = "ODBC"
                   &from-type = "odbtyp"
                   }
      p_Var  = ( if can-do(odbtyp,s_DbCache_Type[s_DbCache_ix])
                   then ENTRY(p_Category, odb_capab)
                   else ENTRY(p_Category, pro_capab)
                   ).
end case.

assign p_Var = TRIM(p_Var).
/*********************************************************************
* Copyright (C) 2006,2008-2009 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _changed.p

Description: 
   The user is trying to close a property window or replace it's contents.
   Determine if anything has changed that he hasn't saved.  If so, ask him
   if he wants to save stuff.

Input Parameter:
   p_Obj    - The object type of the property window we're dealing with.
   p_Revert - True means: if there were changes and the user does not want to
      	      save, refresh the screen to reflect the old values.  This
      	      looks good but it also makes the widgets and the buffer match
      	      up so that if something else happens which requires checking
      	      for changes we won't think that changes have occurred again.

      	      False means: Don't refresh values on screen because the 
      	      properties are about to be closed or replaced with another
      	      object so don't spend the time and avoid flashing.

Output Parameter:
   p_Error - Set to true if something was modified and the save produced
      	     an error.

Author: Laura Stern

Date Created: 06/06/92 

Last modified on:

08/26/94 by gfs       Added Recid index support.
05/19/99 by Mario B.  Adjust Width Field browser integration.
09/19/02 by D. McMann Changed SQL Width to Max Width
06/08/06    fernando  Added support for int64
04/15/09    fernando  BLOB support for MSS
----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/uivar.i   shared}
{adecomm/cbvar.i   shared}

{adedict/TBL/tblvar.i   shared}
{adedict/SEQ/seqvar.i   shared}
{adedict/FLD/fldvar.i   shared}
{adedict/IDX/idxvar2.i  shared}
{adedict/IDX/idxvar.i   shared}
{prodict/gui/widthvar.i shared}

{adedict/capab.i}

Define INPUT   PARAMETER p_Obj    as integer NO-UNDO.
Define INPUT   PARAMETER p_Revert as logical NO-UNDO.
Define OUTPUT  PARAMETER p_Error  as logical NO-UNDO.

/*--------------------------Mainline Code---------------------------------*/

Define var changed  as logical NO-UNDO.
Define var save_ans as logical NO-UNDO.
Define var junk     as logical NO-UNDO.
Define var for_size as logical NO-UNDO.
Define var for_name as logical NO-UNDO.
Define var capab    as char    NO-UNDO.
Define var name     as char    NO-UNDO case-sensitive.

Define var msg1     as char    NO-UNDO init
   "You have made changes to".
Define var msg2     as char    NO-UNDO init
   "Do you want to save these changes?".

p_Error = no.

case (p_Obj):
   when {&OBJ_TBL} then
   do:
      /* For reasons too lengthy to explain here, this is done this way   *
       * so that s_CurrObj stays at {&OBJ_TBL}.  {&OBJ_WIDTH} has limited *
       * use and is not a real object, but a window.  Still, it needed to *
       * be defined for other tools.  5/22/99 - Mario B.                  */
      IF s_win_Width <> ? THEN
      DO:
         changed = no.
         chg-loop: FOR EACH w_Field NO-LOCK:  
            FIND _Field WHERE _Field._File-Recid = w_Field._File-Recid AND
                              _Field._Field-Name = w_Field._Field-Name 
            NO-LOCK NO-ERROR.
            IF AVAIL _Field THEN 
            DO:
               changed = w_Field._Width <> _Field._Width.  
               IF changed THEN LEAVE chg-loop.
            END.
         END.
         IF changed THEN
         DO:
            current-window = s_win_Width.
            MESSAGE msg1 "Max Width Values." SKIP msg2
                    view-as ALERT-BOX QUESTION buttons YES-NO update save_ans
                    in window s_win_Width.
         	    
            IF save_ans THEN
            DO:
               run prodict/gui/_savwidt.p.
               IF RETURN-VALUE = "error" THEN p_Error = YES.
               run prodict/gui/_guisqlw.p.
            END.
            ELSE
               RUN prodict/gui/_guisqlw.p.
	 END. 
      ELSE 
         RUN prodict/gui/_guisqlw.p.
      END.

      /* If the Table Properties window is not open, no need to check for *
       * changes.                                                         */
      IF s_win_Tbl = ? THEN RETURN.
      
      /* If edit object was just deleted, don't check for changes  */
      if NOT AVAILABLE b_File THEN
         RETURN.

      if s_Tbl_ReadOnly then return.

      /* For gateway stuff, if the attribute is not supported by the gateway
      	 "n/a" will be displayed there or the attribute will invisible,
      	 meaning the value won't match the buffer but in that case, we
      	 don't care.
      */
      run adedict/_capab.p (INPUT {&CAPAB_TBL}, OUTPUT capab).
      for_name = INDEX(capab, {&CAPAB_TBL_SIZE}) > 0 AND
      	       	 INDEX(capab, {&CAPAB_CHANGE_TBL_SIZE}) > 0.
      for_size = INDEX(capab, {&CAPAB_FOR_NAME}) > 0 AND
      	       	 INDEX(capab, {&CAPAB_CHANGE_FOR_NAME}) > 0.

      name = b_File._File-Name.
      changed =
      	 input frame tblprops b_File._File-Name  <> name OR
      	 input frame tblprops b_File._Dump-Name  <> b_File._Dump-Name  OR
      	 input frame tblprops b_File._Hidden     <> b_File._Hidden     OR
      	 input frame tblprops b_File._File-label <> b_File._File-label OR
      	 input frame tblprops b_File._Desc       <> b_File._Desc.

      if NOT changed AND for_name then
      	 changed = input frame tblprops b_File._For-Name <> b_File._For-Name.

      if NOT changed AND for_size then 
      	 changed = input frame tblprops b_File._For-Size <> b_File._For-Size.

      /*--- Save policy has been changed --------------------------------
      	 this is obsolete but leave in case we change our minds!

      if NOT changed then
      	 /* Check if changes were made in validation or trigger sub-dialogs */
      	 run adedict/TBL/tblworkf.p (INPUT {&CMP_WORK}, OUTPUT changed).
      -----------------------------------------------------------------*/
      if changed then 
      do:
      	 current-window = s_win_Tbl.
      	 message msg1 "table properties." SKIP msg2
       	    view-as ALERT-BOX QUESTION buttons YES-NO update save_ans
      	    in window s_win_Tbl.

      	 if save_ans then
      	 do:
      	    run adedict/TBL/_savetbl.p. 
      	    if RETURN-VALUE = "error" then p_Error = yes.
      	 end.
      	 else do:
      	    /*--- Save policy has been changed --------------------------------
      	       this is obsolete but leave in case we change our minds!

      	    /* Undo validation and trigger changes.  Main property changes
      	       haven't been saved yet (still in widgets). */
      	    run adedict/TBL/tblworkf.p (INPUT {&ALL_FROM_WORK}, OUTPUT junk).
      	    ----------------------------------------------------------------*/
      	    
      	    /* Reset the widgets in the main display to show old values. */
      	    if p_Revert then
      	    do:
      	       display 	b_File._File-Name
		     	b_File._Dump-Name
			b_File._Hidden
			b_File._Desc
      	       	     	b_File._For-Name when for_name
			b_File._For-Size when for_size
      	       	  with frame tblprops.
      	    end.
      	 end.
      end.
   end.

   when {&OBJ_SEQ} then
   do:
      /* If edit object was just deleted, don't check for changes */
      if NOT AVAILABLE b_Sequence then return.

      if s_Seq_ReadOnly then return.

      name = b_Sequence._Seq-Name.
      changed =
      	 input frame seqprops b_Sequence._Seq-Name <> name OR
      	 input frame seqprops b_Sequence._Seq-Init <> b_Sequence._Seq-Init OR
      	 input frame seqprops b_Sequence._Seq-Incr <> b_Sequence._Seq-Incr OR
      	 input frame seqprops b_Sequence._Cycle-Ok <> b_Sequence._Cycle-Ok OR
      	 input frame seqprops s_Seq_Limit    	   <> s_Seq_Limit.      	 

      if changed then 
      do:
      	 current-window = s_win_Seq.
      	 message msg1 "sequence properties." SKIP msg2 
       	    view-as ALERT-BOX QUESTION buttons YES-NO update save_ans
      	    in window s_win_Seq.
      	 if save_ans then
      	 do:   
      	    run adedict/SEQ/_saveseq.p
      	       (b_Sequence._Seq-name:HANDLE in frame seqprops,
       	        input frame seqprops b_Sequence._Seq-Incr,
		input frame seqprops s_Seq_Limit,
		b_Sequence._Seq-Init:HANDLE in frame seqprops,
		input frame seqprops b_Sequence._Cycle-Ok).
      	    if RETURN-VALUE = "error" then p_Error = yes.
      	 end.
      	 else if p_Revert then
      	 do:
      	    /* Reset the widgets in the main display to show old values. */
      	    display b_Sequence._Seq-Name
	       	    b_Sequence._Seq-Init
      	       	    b_Sequence._Seq-Incr
      	       	    s_Seq_Limit
 	       	    b_Sequence._Cycle-Ok
      	       with frame seqprops.

	    if b_Sequence._Seq-Incr < 0 then
	       s_Seq_Limit:label in frame seqprops = "Lower limit:".
	    else
	       s_Seq_Limit:label in frame seqprops = "Upper limit:".
      	 end.
      end.
   end.

   when {&OBJ_FLD} then
   do:
      /* If edit object was just deleted, don't check for changes */
      if NOT AVAILABLE b_Field then return.

      if s_Fld_ReadOnly then return.

      name = b_Field._Field-Name.
      changed =
      	 input frame fldprops b_Field._Field-Name <> name                OR
      	 input frame fldprops b_Field._Order      <> b_Field._Order      OR
      	 ((input frame fldprops b_Field._Desc     <> b_Field._Desc) AND
          input frame fldprops b_Field._Desc NE "" AND b_Field._Desc NE ?).

      /* for a Progress db, check if the user changed an integer field to
         int64 
      */
      IF {adedict/ispro.i} AND b_Field._Data-type <> s_Fld_Protype AND
          b_field._dtype = {&DTYPE_INTEGER} AND s_Fld_Protype = "int64" THEN
          changed = YES.

      IF NOT changed THEN DO:
          /* For a Progress db, most fields are not valid for CLOB/BLOB fields */
          IF {adedict/ispro.i} AND (b_field._dtype = {&DTYPE_BLOB} OR  b_field._dtype = {&DTYPE_CLOB}) THEN DO:
             changed = input frame fldprops s_lob_size <> b_Field._Fld-Misc2[1].
          END.
          ELSE  
              changed =  input frame fldprops b_Field._Format 	  <> b_Field._Format     OR
                         input frame fldprops b_Field._Initial    <> b_Field._Initial    OR
                         input frame fldprops b_Field._Mandatory  <> b_Field._Mandatory  OR
                         input frame fldprops b_Field._Help       <> b_Field._Help.

              /* _Label and _Col-label may not be sensitive if CLOB and DataServers */
              IF NOT changed THEN DO:
                  changed = (IF b_Field._Label:SENSITIVE THEN input frame fldprops b_Field._Label  <> b_Field._Label ELSE NO) OR
                            (IF b_Field._Col-Label:SENSITIVE THEN input frame fldprops b_Field._Label  <> b_Field._Label ELSE NO).

                 IF NOT changed AND s_Fld_DType:SENSITIVE IN frame fldprops THEN
                    changed = s_Fld_Protype <> b_Field._Data-type.
              END.
      END.

      if NOT changed then
      do:
      	 if b_Field._dtype = {&DTYPE_DECIMAL} then
      	    changed =
      	       input frame fldprops b_Field._Decimal <> b_Field._Decimal.
      	 else if b_Field._dtype = {&DTYPE_CHARACTER} OR b_Field._dtype = {&DTYPE_CLOB} then
      	    changed = 
      	       input frame fldprops b_Field._Fld-case <> b_Field._Fld-case.
      end.

      /*--- Save policy has been changed --------------------------------
        this is obsolete but leave in case we change our minds!

      if NOT changed then
      	 /* Check if changes were made in validation, trigger or gateway
      	    sub-dialogs */
      	 run adedict/FLD/fldworkf.p (INPUT {&CMP_WORK}, OUTPUT changed).
      -------------------------------------------------------------------*/

      if changed then 
      do:
      	 current-window = s_win_Fld.
      	 message msg1 "field properties." SKIP msg2 
       	    view-as ALERT-BOX QUESTION buttons YES-NO update save_ans
      	    in window s_win_Fld.

      	 if save_ans then
      	 do:
      	    run adedict/FLD/_savefld.p.
      	    if RETURN-VALUE = "error" then p_Error = yes.
      	 end.
      	 else do:
      	    /*--- Save policy has been changed --------------------------------
               this is obsolete but leave in case we change our minds!

      	    /* Undo validation, trigger and gateway changes.  Main
      	       property changes haven't been saved yet (still in widgets). */
      	    run adedict/FLD/fldworkf.p (INPUT {&ALL_FROM_WORK}, OUTPUT junk).
      	    -----------------------------------------------------------------*/

      	    /* Reset the widgets in the main display to show old values. */
      	    if p_Revert then
      	    do:
      	       display b_Field._Field-Name 
      	       	       b_Field._Format
      	       	       b_Field._Label
      	       	       b_Field._Col-Label
      	       	       b_Field._Initial
      	       	       b_Field._Mandatory
      	       	       b_Field._Order
      	       	       b_Field._Desc
      	       	       b_Field._Help
      	       	       b_Field._Decimals when b_Field._dtype = {&DTYPE_DECIMAL}
      	       	       b_Field._Fld-case when b_Field._dtype = {&DTYPE_CHARACTER}
      	       	  with frame fldprops.
      	    end.
      	 end.
      end.
   end.

   when {&OBJ_IDX} then
   do:
      /* If edit object was just deleted, don't check for changes */
      if NOT AVAILABLE b_Index then return.

      if s_Idx_ReadOnly then return.

      name = b_Index._Index-Name.
      changed =
      	 input frame idxprops b_Index._Index-Name <> name                OR
      	 input frame idxprops s_Idx_Primary       <> s_Idx_Primary       OR
      	 input frame idxprops ActRec              <> ActRec              OR
      	 input frame idxprops b_Index._Desc       <> b_Index._Desc.

      if changed then 
      do:
      	 current-window = s_win_Idx.
      	 message msg1 "index properties." SKIP msg2
       	    view-as ALERT-BOX QUESTION buttons YES-NO update save_ans
      	    in window s_win_Idx.
      	 if save_ans then
      	 do:
      	    run adedict/IDX/_saveidx.p.
      	    if RETURN-VALUE = "error" then p_Error = yes.
      	 end.
      	 else if p_Revert then
      	    display  b_Index._Index-Name
      	       	     s_Idx_Primary
      	       	     ActRec
      	       	     b_Index._Desc
      	       with frame idxprops.
      end.
   end.

   when {&OBJ_DOM} then
   do:
      /* Add this when we support domain.  Domains and field will have
      	 to use different buffers and work files.  This needs fixing!
      */
   end.
end.


/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _closwin.p

Description:
   Close the current edit window.
 
Author: Laura Stern

Date Created: 04/24/92
    Modified: 05/19/99 Mario B.  Adjust Width Field browser integration.
              05/28/99 Mario B.  Added call to _closqlw.p.
    
----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}

{adedict/DB/dbvar.i shared}
{adedict/TBL/tblvar.i shared}
{adedict/SEQ/seqvar.i shared}
{adedict/FLD/fldvar.i shared}
{adedict/IDX/idxvar2.i shared}
{adedict/IDX/idxvar.i shared}

case (SELF):
   when s_win_Db then do:
      {adedict/delwin.i &Win = s_win_Db &Obj = {&OBJ_DB}}
   end.
   when s_win_Tbl then do:
      {adedict/delwin.i &Win = s_win_Tbl &Obj = {&OBJ_TBL}}
      RUN adedict/_brwgray.p (INPUT NO).       
   end.   
   when s_win_Seq then do:
      {adedict/delwin.i &Win = s_win_Seq &Obj = {&OBJ_SEQ}}
   end.
   when s_win_Fld then do:
      {adedict/delwin.i &Win = s_win_Fld &Obj = {&OBJ_FLD}}
      RUN adedict/_brwgray.p (INPUT NO).      
   end.
   when s_win_Idx then do:
      {adedict/delwin.i &Win = s_win_Idx &Obj = {&OBJ_IDX}}
   end.
   when s_win_Width then do:
      RUN prodict/gui/_closqlw.p.
      {adedict/delwin.i &Win = s_win_Width &Obj = {&OBJ_WIDTH}}
      RUN adedict/_brwgray.p (INPUT NO).
   end.

end.

return ERROR.

/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/


/*----------------------------------------------------------------------------

File: _dcttran.p

Description:
   The main dictionary transaction loop.  It also contains the wait-for
   block for when we are in browse mode.  In either case, this is only
   run when the current dictionary database is connected and we can
   therefore look at it's schema.

   This is separated from dictmain.p so that all references to metaschema
   files (i.e., all database references) have a place to be scoped to,
   namely this .p.  This way they can stay around as long as we're  
   dealing with a single database.  When we switch databases, or disconnect
   a database, we have to return to main temporarily so that Progress can
   clean up after itself with respect to that database.  Then this procedure
   can be reentered for a new database.
    
Author: Laura Stern

Date Created: 04/14/92 
    Modified: 05/19/99 Mario B.  Adjust Width Field browser integration.
----------------------------------------------------------------------------*/

&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i  shared}
{adedict/menu.i     shared}
{adedict/uivar.i    shared}
{adedict/brwvar.i   shared}    
{adecomm/cbvar.i    shared}
{adedict/DB/dbvar.i shared}

{adedict/TBL/tblvar.i   "new shared"}
{adedict/SEQ/seqvar.i   "new shared"}
{adedict/FLD/fldvar.i   "new shared"}
{adedict/IDX/idxvar2.i  "shared"}
{adedict/IDX/idxvar.i   "new shared"}
{prodict/gui/widthvar.i "shared"}

/* Local variables */
Define var answer    as logical  NO-UNDO.

/*=============================== Triggers ===================================*/

{adedict/edittrig.i} /* triggers for the edit (properties) windows */


/* include file contains trigger for s_lob_size and s_clob_cp */
{prodict/pro/fldfuncs.i}
{adedict/FLD/lob-misc.i &Frame = "frame fldprops"}

/*============================= Mainline code ================================*/

/* Here's our main transaction loop.  Most actions occur within triggers
   generated from within the wait-for state.  However, we must return here
   (by applying "U2" to frame browse) whenever we want to commit or undo
   the transaction.  The transaction is everything that happened since the
   user started working with the current database in the dictionary or
   everything since the last explicit commit - whichever is later.
   s_Trans tells us what transaction action to take.  s_ActionProc can be
   set to an action to perform after we commit or abort.
*/
s_Trans = {&TRANS_NONE}.
s_Browse_Stat = "".

tranblk:
repeat transaction ON ERROR UNDO, RETRY:
   /* In case we were undoing or committing stat msg will have text
      in it.  Display that and reset cursor.
   */
   if s_Browse_Stat <> "" then
   do:
      display s_Browse_Stat with frame browse.
      run adecomm/_setcurs.p ("").
   end.

   /* If we're done, clearly we get out of here.  But also, if user has
      just committed we have to pop up and come back down so that
      the schema cache gets updated.
   */
   if s_Trans = {&TRANS_DONE} OR s_Trans = {&TRANS_COMMIT} then
   do:
      /* Property window widgets (except DB window) are not scoped above
      	 this level.  If we are done, they need to be closed anyway.
      	 If we're committing, we'd better close them otherwise when we
      	 come back in - they are screwed up. 
      */
      run adedict/_delwins.p (INPUT yes).
      leave tranblk.
   end.
   ELSE IF s_Trans = {&TRANS_UNDO} THEN DO:
       /* need to refresh the data in the DB properties window, if it was up when the user chose to
         undo the transaction.
       */
       if s_win_Db <> ? then
            run adedict/DB/_dbprop.p.
   END.

   /* Open up the tables list by default if no other list is showing.
      This will happen we we've switched to a new database. */
   if s_Lvl1Obj = {&OBJ_NONE} then
      apply "mouse-select-down" to s_icn_Tbls in frame browse.

   /* If index list was showing when user committed, then in case the
      default index is added upon committing we have to refresh the
      index list. */
   if s_Lvl2Obj = {&OBJ_IDX} then
   do:
      {adedict/uncache.i
      	    &List   = "s_lst_Idxs"
      	    &Cached = "s_Idxs_Cached"
      	    &Curr   = "s_CurrIdx"}
      run adedict/_brwlist.p (INPUT {&OBJ_IDX}).
   end.

   if s_Browse_Stat <> "" then
   do:
      /* Above processing may have erased status - so re display it */
      display s_Browse_Stat with frame browse.
      s_Browse_Stat = "".  
   end.

   /* In case we're just starting up, get rid of logo window and
      make sure browse window is in view. 
   */
   if s_win_Logo <> ? then 
   do:
      /* We're in start up mode */
      run adecomm/_setcurs.p ("").
      session:immediate-display = no. 
      delete widget s_win_Logo.
      s_win_Logo = ?.
      current-window = s_win_Browse.
      view frame browse.
   end.

   /* If list had the focus from last time, return it there */
   if s_Dblst_Focus then
      Wait-for "U2" of frame browse FOCUS s_lst_Dbs.
   else
      Wait-for "U2" of frame browse.

   current-window = s_win_Browse.  /* to parent alert boxes and msgs */
   
   if s_DictDirty then
   do:
      if s_Trans = {&TRANS_ASK_AND_DO} OR
         s_Trans = {&TRANS_ASK_AND_EXIT} then
      do:
      	 /* The actions to take are either switch database, disconnect, 
      	    exit or run another ADE tool.
      	 */
         IF user_env[34] <> "Y" AND user_env[34] <> "N" THEN DO:

      	   answer = yes.  /* the default */
      	   message "You have made changes in the current"    SKIP
      	       	 "database, that are not committed."       SKIP(1)
      	       	 "Do you want to commit your changes?" 
      	       	  view-as ALERT-BOX QUESTION
      	          buttons YES-NO
      	       	  update answer in window s_win_Browse.
         END.
         ELSE
             ASSIGN answer = (IF user_env[34] = "Y" THEN TRUE ELSE FALSE).

	   if answer = no THEN DO:
	     display "Transaction Undone" @ s_Browse_Stat with frame browse.
	     if s_Trans = {&TRANS_ASK_AND_DO} then
      	    do:
      	       {adedict/setdirty.i &Dirty = "false"}.
      	 end.
      	 else
      	     s_DictState = {&STATE_DONE}.
      	             
      	    /* Cause return from this .p so we can do the required
      	       action (e.g., switch databases etc.).
      	    */
	     undo tranblk, leave tranblk. 
	   end.
       else if answer = yes then /* Commit and then take action */
      	 do:
   	    /* flag that we're done but let code drop through 
      	       the end of the repeat first. */
	    if s_Trans = {&TRANS_ASK_AND_EXIT} then
      	       s_DictState = {&STATE_DONE}.
      	    s_Trans = {&TRANS_DONE}.
       end.
     end.  /* end of ASK_AND_DO/ASK_AND_EXIT */

     else if s_Trans = {&TRANS_UNDO} then
      do:
      	 {adedict/setdirty.i &Dirty = "false"}.

      	 /* Since anything could have changed, just close up
      	    everything and let the user start again. */
      	 s_DictState = {&STATE_NO_OBJ_SELECTED}.
      	 run adedict/_brwadj.p (INPUT {&OBJ_DB}, INPUT 1).

      	 run adecomm/_setcurs.p ("WAIT"). /* while undoing */
      	 s_Browse_Stat = "Transaction Undone". 	/* to be displayed when done */
	 undo tranblk, next tranblk.
      end.

      /* else s_Trans = {&TRANS_COMMIT} and we'll fall through to
      	 commit the transaction. 
      */
   end.  /* end Dict was dirty */

   else do:
      /* Dict is not dirty, s_Trans is either ASK_AND_EXIT or ASK_AND_DO. */
      if s_Trans = {&TRANS_ASK_AND_EXIT} then
      	 s_DictState = {&STATE_DONE}.
      leave tranblk.
   end.

   /* If we got here, we want to commit the transaction. */

   run adecomm/_setcurs.p ("WAIT"). /* while committing */
   /* CISAM renumbers the field-pos whenever a field gets added, */
   /* deleted or it's name changed. Triggers are referenced also */
   /* by field-pos, so we have to run that program               */
   /* The same goes for RMS             (hutegger 02/95)         */
   if  s_DbCache_type[s_DbCache_ix] = "CISAM"
    or s_DbCache_type[s_DbCache_ix] = "RMS"
    then RUN prodict/gate/_gat_atg.p (s_DbCache_Pname[s_DbCache_ix]).
    
   s_Browse_Stat = "Transaction committed".  /* to be displayed when done */
   {adedict/setdirty.i &Dirty = "false"}.
end. 

return.




/***********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/


/*----------------------------------------------------------------------------

File: _delete.p

Description:
   Process the Delete command to delete the currently selected object.

Input Parameters:
   p_Obj - The object type to delete.
 
Author: Laura Stern

Date Created: 02/24/92 
    Modified: 07/14/98 Added _Owner to _File finds D. McMann
              08/08/02 Eliminated any sequences whose name begins "$" - Peer Direct D. McMann
              10/01/02 DLM Changed check for SQL tables

----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adedict/capab.i}


Define INPUT PARAMETER p_Obj as integer.

Define var confirmed as logical init no.  /* this IS undoable */
Define var capab     as char    NO-UNDO.
Define var obj_str   as char    NO-UNDO.


/*========================Internal Procedures===============================*/

/*--------------------------------------------------------------------
   Remove the deleted item from the appropriate list in the browse
   window and if the deleted item is being shown in an edit window,
   destroy that window. 

   Input Parameters:
      p_List - The widget handle of the list to remove the item from.
      p_Val  - The name of the item deleted, i.e., the value to remove
      	       from the list.
      p_Obj  - The symbolic object number (e.g., {&OBJ_TBL})
----------------------------------------------------------------------*/
PROCEDURE CleanupDisplay:

Define INPUT   	     parameter p_List  as widget-handle.
Define INPUT   	     parameter p_Val   as char.
Define INPUT   	     parameter p_Obj   as integer.

Define var cnt as integer NO-UNDO.

   run adecomm/_delitem.p (INPUT p_List, INPUT p_Val, OUTPUT cnt).

   apply "value-changed" to p_List.      
   if cnt = 0 then
      /* If this was the last item in the list, the browse window and menu
      	 may need some adjusting. */
      run adedict/_brwadj.p (INPUT p_Obj, INPUT cnt).
end.


/*============================Mainline code================================*/

CURRENT-WINDOW = s_win_Browse.
s_Browse_Stat:screen-value in frame browse = "". /* clear status line */

CASE p_Obj:

   when {&OBJ_TBL} then
   do:
      find _File WHERE _File._File-name = "_File"
                   AND _File._Owner = "PUB" NO-LOCK.
      if NOT can-do(_File._Can-delete, USERID("DICTDB")) then
      do:
      	 message s_NoPrivMsg "delete table definitions."
      	    view-as ALERT-BOX ERROR buttons OK.
      	 return.
      end.
   
      find _File where RECID(_File) = s_TblRecId.
    
      /* Do some more checking to see if this file is deletable */
      if can-find (FIRST _View-ref
      	       	   where _View-ref._Ref-Table = _File._File-Name)
	 OR _File._Frozen then
      do:
	 message
	    "Frozen tables and tables participating in views cannot be deleted."
      	    view-as ALERT-BOX ERROR buttons OK.
	 return.
      end.   
   
      if _File._Db-lang >= {&TBLTYP_SQL} then
      do:
	 message "This is a {&PRO_DISPLAY_NAME}/SQL table.  Use DROP TABLE."
      	       	  view-as ALERT-BOX ERROR buttons OK.
	 return.
      end.
   
      /* In Progress, we need an active primary index to delete a file. */
      if {adedict/ispro.i} then
      do:
	 find _Index where RECID(_Index) = _File._Prime-Index NO-ERROR.
	 if AVAILABLE _Index AND NOT _Index._Active then
	 do:
	    message "Tables without an active primary index cannot be deleted."
      	       	     view-as ALERT-BOX ERROR buttons OK.
	    return.
	 end.
      end.
      
      do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      	 /* Note: if there's an error, confirmed will remain "no". */
      	 confirmed = yes.  /* default to yes */
      	 message "Are you sure you want to delete table" s_CurrTbl "?"
      	       	  view-as ALERT-BOX QUESTION buttons YES-NO
      	       	  update confirmed.

      	 if confirmed then
      	 do:
	    /* delete tbl, it's indexes, fields and triggers */
      	    run adecomm/_setcurs.p ("WAIT").
	    {adecomm/deltable.i}

      	    run CleanupDisplay (INPUT s_lst_Tbls:HANDLE in frame browse,
      	       	     	        INPUT s_CurrTbl,
      	       	     	        INPUT {&OBJ_TBL}).
      	    obj_str = "Table".
      	    current-window = s_win_Browse.  /* cleanup may have changed it */
      	 end.
      end.
   end.

   when {&OBJ_SEQ} then
   do:
      /* Get gateway capabilities */
      run adedict/_capab.p (INPUT {&CAPAB_SEQ}, OUTPUT capab).
      if INDEX(capab, {&CAPAB_DELETE}) = 0 then
      do:
      	 message "You may not delete a sequence for this database type."
      	    view-as ALERT-BOX ERROR buttons OK.
      	 return.
      end.

      find _File WHERE _File._File-name = "_Sequence"
                   AND _File._Owner = "PUB" NO-LOCK.
      if NOT can-do(_File._Can-delete, USERID("DICTDB")) then
      do:
      	 message s_NoPrivMsg "delete sequence definitions."
      	    view-as ALERT-BOX ERROR buttons Ok.
      	 return.
      end.
   
      do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      	 /* Note: if there's an error, confirmed will remain "no". */
      	 confirmed = yes.  /* default to yes */
      	 message "Are you sure you want to delete sequence" s_CurrSeq "?"
      	       	  view-as ALERT-BOX QUESTION buttons YES-NO
      	       	  update confirmed.

      	 if confirmed then
      	 do:
      	    run adecomm/_setcurs.p ("WAIT").
      	    find _Sequence where _Sequence._Db-recid = s_DbRecId
                             AND _Sequence._Seq-Name = s_CurrSeq.
      	    delete _Sequence.

      	    run CleanupDisplay (INPUT s_lst_Seqs:HANDLE in frame browse,
      	       	     	        INPUT s_CurrSeq,
      	       	     	        INPUT {&OBJ_SEQ}).
      	    obj_str = "Sequence".
      	    current-window = s_win_Browse.  /* cleanup may have changed it */
      	 end.
      end.
   end.

   when {&OBJ_FLD} then
   do:
      find _File WHERE _File._File-name = "_Field"
                   AND _File._Owner = "PUB" NO-LOCK.
      if NOT can-do(_File._Can-delete, USERID("DICTDB")) then
      do:
      	 message s_NoPrivMsg "delete field definitions."
      	    view-as ALERT-BOX ERROR buttons Ok.
      	 return.
      end.
   
      find _File where RECID(_File) = s_TblRecId.
      if _File._Db-lang >= {&TBLTYP_SQL} then
      do:
	 message "This is a {&PRO_DISPLAY_NAME}/SQL table.  Use ALTER TABLE/DROP COLUMN."
      	       	  view-as ALERT-BOX ERROR buttons OK.
	 return.
      end.
      if _File._Frozen then
      do:
      	 message "This field belongs to a frozen table." SKIP
      	       	 "It cannot be deleted"
      	       	  view-as ALERT-BOX ERROR buttons OK.
      	 return.
      end.
      
      find _Field of _File where _Field._Field-Name = s_CurrFld.
   
      /* Determine if this field participates in an index or view definition. */
      if can-find (FIRST _Index-field OF _Field) then
      do:
	 message "This field is used in an Index - cannot delete."
      	       	  view-as ALERT-BOX ERROR buttons OK.
	 return.
      end.
      if can-find (FIRST _View-ref where
		     _View-ref._Ref-Table = s_CurrTbl AND
		     _View-ref._Base-Col = _Field._Field-name) then
      do:
	 message "This field is used in a View - cannot delete."
      	       	  view-as ALERT-BOX ERROR buttons OK.
	 return.
      end.
   
      do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      	 /* Note: if there's an error, confirmed will remain "no". */
      	 confirmed = yes.  /* default to yes */
      	 message "Are you sure you want to delete field" s_CurrFld "?"
      	       	  view-as ALERT-BOX QUESTION buttons YES-NO
      	       	  update confirmed.

      	 if confirmed then
      	 do:
	    /* Delete associated triggers, then the field record. */
      	    run adecomm/_setcurs.p ("WAIT").
	    for each _Field-trig of _Field:
	       delete _Field-trig.
	    end.
	    delete _Field.

      	    run CleanupDisplay (INPUT s_lst_Flds:HANDLE in frame browse,
      	       	     	        INPUT s_CurrFld,
      	       	     	        INPUT {&OBJ_FLD}).
      	    obj_str = "Field".
      	    current-window = s_win_Browse.  /* cleanup may have changed it */
	 end.
      end.
   end.

   when {&OBJ_IDX} then
   do:
      /* Get gateway capabilities */
      run adedict/_capab.p (INPUT {&CAPAB_IDX}, OUTPUT capab).
      if INDEX(capab, {&CAPAB_DELETE}) = 0 then
      do:
      	 message "You may not delete an index definition for this database type."
      	    view-as ALERT-BOX ERROR buttons OK.
      	 return.
      end.

      find _File WHERE _File._File-name = "_Index"
                   AND _File._Owner = "PUB" NO-LOCK.
      if NOT can-do(_File._Can-delete, USERID("DICTDB")) then
      do:
      	 message s_NoPrivMsg "delete index definitions."
      	    view-as ALERT-BOX ERROR buttons Ok.
      	 return.
      end.
   
      find _File where RECID(_File) = s_TblRecId.
      if _File._Db-lang >= {&TBLTYP_SQL} then
      do:
	 message "This is a {&PRO_DISPLAY_NAME}/SQL table.  Use the DROP INDEX statement."
      	       	  view-as ALERT-BOX ERROR buttons OK.
	 return.
      end.
      if _File._Frozen then
      do:
      	 message "This index belongs to a frozen table." SKIP
      	       	 "It cannot be deleted"
      	       	  view-as ALERT-BOX ERROR buttons OK.
      	 return.
      end.
   
      find _Index of _File where _Index._Index-Name = s_CurrIdx.
      if _File._Prime-Index = RECID(_Index) then
      do:
	 message "You cannot delete the primary index of a table."
      	       	  view-as ALERT-BOX ERROR buttons OK.
	 return.
      end.
   
      do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      	 /* Note: if there's an error, confirmed will remain "no". */
      	 confirmed = yes.  /* default to yes */
      	 message "Are you sure you want to delete index" s_CurrIdx "?"
      	       	  view-as ALERT-BOX QUESTION buttons YES-NO
      	       	  update confirmed.

      	 if confirmed then
      	 do:
	    /* First delete the index fields, then the _Index record itself. */
      	    run adecomm/_setcurs.p ("WAIT").
	    for each _Index-Field of _Index:
	       delete _Index-Field.
	    end.
	    delete _Index.

      	    run CleanupDisplay (INPUT s_lst_Idxs:HANDLE in frame browse,
      	       	     	        INPUT s_CurrIdx,
      	       	     	        INPUT {&OBJ_IDX}).
      	    obj_str = "Index".
      	    current-window = s_win_Browse.  /* cleanup may have changed it */
	 end.
      end.
   end.

   otherwise 
   do:
      /* This should never happen */
   end.

end case.

/* Make sure cursor is reset. Do it here so we know it will happen.
   Whether delete was successful or if STOP occurred or if they never
   confirmed - it won't matter.
*/
run adecomm/_setcurs.p ("").

if confirmed then
do:
   display obj_str + " deleted." @ s_Browse_Stat with frame browse.
   {adedict/setdirty.i &Dirty = "true"}.
end.







/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _delwins.p

Description:
   Delete any open edit windows.

Input Parameter:
   p_Db - Set to yes to include the DB window in the set of windows to
      	  close.
 
Author: Laura Stern

Date Created: 04/24/92 
    Modified: 05/19/99 Mario B.  Adjust Width Field browser integration.
              05/28/99 Mario B.  Added call to _closqlw.p.
----------------------------------------------------------------------------*/

{adedict/dictvar.i shared}

Define INPUT PARAMETER p_Db as logical NO-UNDO.

if p_Db then
   if s_win_Db <> ? then
   do:
      {adedict/delwin.i &Win = s_win_Db &Obj = {&OBJ_DB}}
   end.

if s_win_Tbl <> ? then
do:
   {adedict/delwin.i &Win = s_win_Tbl &Obj = {&OBJ_TBL}}
end.

if s_win_Seq <> ? then
do:
   {adedict/delwin.i &Win = s_win_Seq &Obj = {&OBJ_SEQ}}
end.

if s_win_Fld <> ? then
do:
   {adedict/delwin.i &Win = s_win_Fld &Obj = {&OBJ_FLD}}
end.

if s_win_Idx <> ? then
do:
   {adedict/delwin.i &Win = s_win_Idx &Obj = {&OBJ_IDX}}
end.

IF s_win_Width <> ? THEN
DO:
   RUN prodict/gui/_closqlw.p.
   {adedict/delwin.i &Win = s_win_Width &Obj = {&OBJ_WIDTH}}
END.

/* Menu graying needs to be run because of SQL Width Browse */
RUN adedict/_brwgray.p (INPUT NO). 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: adedict/_dictfdb.p

Description:
    checks if the schmeaholder has also a PROGRESS-Schema in it
    
Input-Output Pramaeters:
    dbnum   gets increased by one if PROGRESS-Schemaholder contains no 
    PROGRESS-Schema
    
    
History:
    hutegger    94/06/13    creation
    D. McMann   98/06/29    Added _Owner to can-find
    D. McMann   03/10/17    Add NO-LOCK statement to _Db find in support of on-line schema add
    
--------------------------------------------------------------------*/

DEFINE INPUT-OUTPUT PARAMETER dbnum as integer.

/*------------------------------------------------------------------*/

        find first DICTDB._db where DICTDB._db._db-name = ? NO-LOCK no-error.         
        if available DICTDB._Db
         AND NOT can-find(first DICTDB._file of DICTDB._db             
                         where DICTDB._file._file-number > 0
                           AND (DICTDB._File._Owner = "PUB" 
                                 OR DICTDB._File._Owner = "_FOREIGN"))  
          then assign dbnum = dbnum + 1.               


/*------------------------------------------------------------------*/

/*********************************************************************
* Copyright (C) 2006 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _dictg.p

Description:   
   This is the mainline code for the GUI version of the dictionary.
 
Author: Laura Stern

Date Created: 01/28/92 
Modified Date:  11/27/96    kkelley  Removed labels under icons in dictionary for WIN95
                                     Code commented out has WIN95 at the beginning
                05/19/99 Mario B.  Adjust Width Field browser integration.
                D. McMann 02/21/03 Replaced GATEWAYS with DATASERVERS
                10/10/04 K. McIntosh Added code to reset SESSION:SUPPRESS-WARNINGS when
                                     user cancels.  Bug # 20041108-002
----------------------------------------------------------------------------*/

&SCOPED-DEFINE DICTG dictg
&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i      "new shared"}
{prodict/user/uservar.i "new"       }
&UNDEFINE DICTG 
{adedict/brwvar.i       "new shared"}
{adedict/capab.i                    }
{adedict/uivar.i        "new shared"}
{adedict/menu.i         "new shared"}
{adecomm/cbvar.i        "new shared"}
{adedict/DB/dbvar.i     "new shared"}
{adedict/IDX/idxvar2.i  "new shared"}
{prodict/fhidden.i}
{prodict/gui/widthvar.i "new shared"} 
/*
 *    The global var h_ade_tool is maintained in adecomm/adestds.i.
 *    This is here just as reminder because the Dictionary main
 *    routine (this one) does not directly include it. So we must
 *    define it separately here.
 *     
 * */
Define New Global Shared Var h_ade_tool as handle no-undo.

Define var capab     as char     NO-UNDO.
Define var dbnum     as integer  NO-UNDO.
Define var dbcnt     as integer         NO-UNDO.
Define var istrans   as logical  initial TRUE. /* not no-undo! */
Define var wid       as decimal  NO-UNDO.
Define var ht        as decimal  NO-UNDO.
define var wid2      as decimal  no-undo.
Define var ade_tool  as char     NO-UNDO.
Define var supw_sav  as logical  NO-UNDO.

/* Variables needed for Taskbar orientation check */
DEFINE VARIABLE TBOrientation AS CHARACTER NO-UNDO.
DEFINE VARIABLE TBHeight      AS INTEGER   NO-UNDO.
DEFINE VARIABLE TBWidth       AS INTEGER   NO-UNDO.
DEFINE VARIABLE AutoHide      AS LOGICAL   NO-UNDO.

/* For keeping track of disabled widgets on running another ADE tool. */
Define temp-table widg_list
   field h_widget as widget-handle.
   
/* For keeping track of # dbs connected on running another ADE tool. */
Define var save_numdbs as integer  NO-UNDO.


/*===========================Startup Frame Defs==============================*/

/* This stuff must be out here (scoped to .p rather than in the 
   Startup_Options internal procedure) in order to use the global
   color variable for frame's graphics.
*/
Define var choice as char NO-UNDO init "Connect"
   view-as RADIO-SET 
   RADIO-BUTTONS  "Connect to an &Existing Database",  "Connect",
                            "&Create a New Database",                "Create",
                            "Continue with &No Database",        "Continue".
                              
FORM
   SKIP({&TFM_WID})
   "There is no database connected."  at 2 view-as TEXT SKIP({&VM_WIDG})
   choice                                            at 2      
   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}
   with frame startup 
   no-labels default-button s_btn_OK cancel-button s_btn_Cancel 
   view-as DIALOG-BOX TITLE "Dictionary Startup".

/* This is the frame for the logo window that comes up to show the
   user that something's happening on startup so we can delay viewing
   of window till the last minute and avoid flashing.
*/
Define image dict_icon FILE "adeicon/dict%".
Define var loading as char NO-UNDO init "Loading..." format "x(10)".
FORM
   SKIP({&TFM_WID})
   SPACE(10) dict_icon SPACE({&HM_WIDG}) loading SPACE(9)
   SKIP({&TFM_WID})
   with frame logo no-labels.
   

/*================= Triggers (and Related Internal Procedures)===============*/

{adedict/brwtrig.i}   /* browse window triggers */
{adedict/menutrig.i}  /* menu triggers */
{prodict/gui/widttrig.i}  /* Adjust SQL Width window triggers */

/*===========================Internal Procedures=============================*/

/*------------------------------------------------------------------------ 
   Make it easy on startup when there is no current database, by prompting
   the user to create or connect a database.  Use "choice" flag instead
   of performing actions in triggers just so that the startup dialog box
   will disappear before the connect or create boxes appear.  It looks
   a bit cleaner.

   Return: If user wants to exit the dictionary return "exit" else "".
------------------------------------------------------------------------*/
PROCEDURE Startup_Options:

   Define var retval as char NO-UNDO.

   /*----- HELP -----*/
   on HELP of frame startup OR choose of s_btn_Help in frame startup
      RUN "adecomm/_adehelp.p" 
               ("dict", "CONTEXT", {&Startup_Options_Dlg_Box}, ?).


   /*----- WINDOW CLOSE -----*/
   on window-close of frame startup 
      apply "END-ERROR" to frame startup.      

   /* Adjust for standard graphic layout. */
   {adecomm/okrun.i
      &FRAME = "frame startup"
      &BOX   = s_rect_Btns
      &OK    = s_btn_OK
      &HELP  = s_btn_Help}

   retval = "exit".
   do on ERROR undo, leave  on ENDKEY undo, leave:
      update 
               choice s_btn_OK s_btn_Cancel s_btn_Help 
               with frame startup.
      retval = "".
   end.

   if retval <> "exit" then  /* user didn't close window or Cancel */
   do:
      if choice = "create" then
         run adedict/DB/_newdb.p.
      else if choice = "connect" then
         run adedict/DB/_connect.p (INPUT ?).
      /* else continue */
   end.

   return retval.
end.


/*------------------------------------------------------------------------ 
   The user has chosen a tool from the tool menu.  Before running it
   we have to make sure any transaction is completed and get out of
   the transaction block.  
------------------------------------------------------------------------*/
PROCEDURE Prepare_For_ADE_Tool_Run:

Define INPUT PARAMETER p_ProgName as char NO-UNDO.

   assign
      ade_tool = p_ProgName  /* Set a variable scoped to .p */
      s_ActionProc = "Run_ADE_Tool".

   if s_DictState = {&STATE_NO_DB_SELECTED} then
      /* We have no database so there's no transaction.  But break
               out of the wait-for anyway.  If the other tool connects
               to a database, we must be back in the repeat loop so we
               can run _dcttran.p.
      */
      apply "U1" to frame browse.
   else do:
      /* Cause transaction to break (the user can save or not)
               and then do the ADE Tool thing.
      */
      s_Trans = {&TRANS_ASK_AND_DO}.
      apply "U2" to frame browse.
   end.
END.


/*------------------------------------------------------------------------ 
   Disable the dictionary, run another ADE tool and then reenable
   myself.
------------------------------------------------------------------------*/
PROCEDURE Run_ADE_Tool:

   /*----- Disable Dictionary -----*/
   run disable_widgets.

   /*----- Run the tool -----*/
   run VALUE(ade_tool).

   /*---- Reenable Dictionary -----*/
   run enable_widgets.

END.

/*------------------------------------------------------------------------ 
   Disable the Dictionary.
------------------------------------------------------------------------*/
PROCEDURE disable_widgets:
   Define var widg           as widget-handle NO-UNDO.

   /*----- Disable the dictionary -----*/

   /* Delete property windows */
    run adedict/_delwins.p (INPUT yes).

   /* Disable menu bar.  This only does top level menu items */
   menu s_mnu_Dict:sensitive = no.

   /* Reset this to what it was when dict started */
   session:suppress-warnings = supw_sav.
   
   /* Disable any visible and enabled widgets. Keep track of the widget handles,
      so we can reenable them later.
   */
   widg = frame browse:first-child.  /* this will be a field group */
   widg = widg:first-child.
   
   /* First clear the list */
   for each widg_list:
      delete widg_list.
   end.
   
   do while widg <> ?:
      if widg:visible = yes AND widg:sensitive = yes then
      do:
         widg:sensitive = no.
         create widg_list.   
         widg_list.h_widget = widg.
      end.
      widg = widg:next-sibling.
   end.

   /* Unset global active ade tool procedure handle. */
   assign h_ade_tool = ?.
   
   /* Save # dbs connected. */
   save_numdbs = NUM-DBS.

END.


/*------------------------------------------------------------------------ 
   Enable the Dictionary.
------------------------------------------------------------------------*/
PROCEDURE enable_widgets:
   Define var widg           as widget-handle NO-UNDO.
   Define var name         as char          NO-UNDO.
   Define var all_conn  as logical       NO-UNDO init yes.
   Define var ix             as integer       NO-UNDO.

   /*---- Reenable Dictionary -----*/

   /* Set global active ade tool procedure handle to Dictionary. */
   assign h_ade_tool = this-procedure.

   /* Reenable menu bar */
   current-window = s_win_Browse.
   menu s_mnu_Dict:sensitive = yes.

   /* Reenable any disabled widgets */
   for each widg_list:
      widg_list.h_widget:sensitive = yes.
   end.
   
   /* Reset session attribute, in case the other tool clobbered it. */
   assign
      session:system-alert-boxes = yes
      session:suppress-warnings = yes.


    /* Clear the whole cache and start again. */  
    assign
         s_lst_Dbs:LIST-ITEMS in frame browse = ""
         s_DbCache_Cnt        = 0
         s_DbCache_Pname      = ""
         s_DbCache_Holder     = ""
         s_DbCache_Type       = "".

   run adedict/DB/_getdbs.p.

   /* Reset database selection to whatever DICTDB is now or the first
    * entry in the list.
    * If DICTDB is of foreign type we set DICTDB to its schemaholder
    */
   if s_lst_Dbs:NUM-ITEMS in frame browse > 0 then
   do:
      if DBTYPE("DICTDB") <> "PROGRESS"
       then do:
        assign
          dbnum = s_lst_Dbs:LOOKUP( " " 
                                  + LDBNAME("DICTDB")
                                  + "("
                                  + SDBNAME("DICTDB")
                                  + ")") in frame browse.
        CREATE ALIAS DICTDB FOR DATABASE VALUE(SDBNAME("DICTDB")).
        end.
       else assign
        dbnum = s_lst_Dbs:LOOKUP(LDBNAME("DICTDB")) in frame browse.
      if dbnum = 0 then dbnum = 1.
      name = s_lst_Dbs:entry(dbnum) in frame browse.
      s_lst_Dbs:screen-value in frame browse = name.
      display name @ s_DbFill with frame browse.
   end.
   else
      display "" @ s_DbFill with frame browse.

   /* Switch to the new database (or no database).  
      This will reset s_CurrDb, fix browse window, menu graying etc.
      If previously connected db is still connected, alot of this is
      redundant - but this is the cleanest way to do it.
   */
   s_ask_gateconn = no.
   run adedict/DB/_switch.p.
END.



/*============================= Mainline code ================================*/


do ON STOP UNDO, LEAVE:
   /* Set up triggers or gray pieces of standard tool menu.  It also checks
      to see if Dictionary is already running.
   */
   {adecomm/toolrun.i &MENUBAR               = "s_mnu_Dict"
                      &EXCLUDE_DICT          = yes 
                      &DISABLE_WIDGETS_PROC  = Prepare_For_ADE_Tool_Run
                      &DISABLE_ONLY          = yes
   }
   if tool_bomb then return.  /* Dictionary is already running so quit */

   /* Set global active ade tool procedure handle to Dictionary. */
   assign h_ade_tool = this-procedure.

   pause 0 before-hide.
   assign
      supw_sav = session:suppress-warnings /* save current value */
      session:suppress-warnings = yes /*no warnings on platform specific funcs*/
      session:system-alert-boxes = yes.
   use "" NO-ERROR.  /* resets to startup default file directory */
   
   /* Create the dictionary browse window */
   create window s_win_Browse 
      assign
         x = 0
         y = 20
         scroll-bars = no
         title = "Data Dictionary"
         menubar = MENU s_mnu_Dict:HANDLE
         status-area = no
         message-area = no
   
      triggers:
         on window-close do:
            run Do_Exit.      /* in menutrig.i */
            return no-apply.  /* to avoid beep */
         end.
      end triggers.

      IF SESSION:WINDOW-SYSTEM BEGINS "MS-WIN":U THEN DO: 
         ASSIGN TBOrientation= ""
            TBHeight = 0
            TBWidth = 0.
         RUN adeshar/_taskbar.p (OUTPUT TBOrientation, OUTPUT TBHeight,
                                 OUTPUT TBWIdth,       OUTPUT AutoHide).
    
         IF NOT AutoHide THEN DO:
            IF TBOrientation = "LEFT":U AND s_win_Browse:X <= TBWidth THEN
               ASSIGN s_win_Browse:X = TBWidth.
            IF TBOrientation = "TOP":U THEN DO:
               IF s_win_Browse:Y <= TBHeight THEN s_win_Browse:Y = TBHeight.
            END.
            IF TBOrientation = "BOTTOM" AND s_win_Browse:Y + s_win_Browse:HEIGHT-P > SESSION:HEIGHT-P - TBHeight THEN DO:
               s_win_Browse:Y = s_win_Browse:Y - ((s_win_Browse:Y + s_win_Browse:HEIGHT-P) - (SESSION:HEIGHT-P - TBHeight)).
               if s_win_Browse:Y < 0 then s_win_Browse:y = 20.   
            END.
            IF TBOrientation = "RIGHT" AND s_win_Browse:X + s_win_Browse:WIDTH-P > SESSION:WIDTH-P - TBWidth THEN DO:
               s_win_Browse:X = s_win_Browse:X - ((s_win_Browse:X + s_win_Browse:WIDTH-P) - (SESSION:WIDTH-P - TBWidth)).
               if s_win_Browse:X < 0 then s_win_browse:X = 0.
            end.
         END. /* if NOT AutoHide */
      END. /* if SESSION:WINDOW-SYSTEM BEGINS "MS-WIN" */

   assign
      frame browse:parent = s_win_Browse
      s_Res = s_win_Browse:load-icon("adeicon/dict%").
   
   /* Resize the window to fit the browse frame */
   assign
      ht = frame browse:height-chars
      wid = frame browse:width-chars
      wid2 = s_win_browse:width-chars.
   if wid > wid2 then
      assign s_win_Browse:width-chars = wid
             s_win_Browse:max-width = wid. 
   else
       assign frame browse:width-chars = wid2.
  
   assign s_win_Browse:height-char = ht
          s_win_browse:max-height = ht.
 
   create window s_win_Logo
      assign
         x = 150
         y = 100
         scroll-bars = no
         title = "Data Dictionary"
         status-area = no
         message-area = no.
 
   IF SESSION:WINDOW-SYSTEM BEGINS "MS-WIN":U THEN DO: 
 
      IF NOT AutoHide THEN DO:
         IF TBOrientation = "LEFT":U AND s_win_Logo:X <= TBWidth THEN
            ASSIGN s_win_Logo:X = TBWidth + 150.
         IF TBOrientation = "TOP":U THEN DO:
            IF s_win_Logo:Y <= TBHeight THEN s_win_Logo:Y = TBHeight + 50.
         END.
         IF TBOrientation = "BOTTOM" AND s_win_Logo:Y + s_win_Logo:HEIGHT-P > SESSION:HEIGHT-P - TBHeight THEN
            s_win_Logo:Y = s_win_Logo:Y - ((s_win_Logo:Y + s_win_Logo:HEIGHT-P) + (SESSION:HEIGHT-P - TBHeight)).
         IF TBOrientation = "RIGHT" AND s_win_Logo:X + s_win_Logo:WIDTH-P > SESSION:WIDTH-P - TBWidth THEN
            s_win_Logo:X = s_win_Logo:X - ((s_win_Logo:X + s_win_Logo:WIDTH-P) - (SESSION:WIDTH-P - TBWidth)).
      END. /* IF NOT AutoHide */
   END. /* IF SESSION:WINDOW-SYSTEM BEGINS "MS-WIN" */
  
 
   /* Resize the window to fit the logo frame */
   assign
      ht = frame logo:height-chars
      wid = frame logo:width-chars
      s_win_Logo:height-chars = ht
      s_win_Logo:width-chars = wid
      s_win_Logo:max-height = ht
      s_win_Logo:max-width = wid.
   
   current-window = s_win_Logo.
   session:immediate-display = yes.
   display dict_icon loading with frame logo.
   run adecomm/_setcurs.p ("WAIT").
   
   
   /* Determine if we are in read-only mode  */
   do ON ERROR UNDO:   /* do the little istrans trick */
      istrans = false.
      undo, leave.
   end.
   
   s_ReadOnly = (istrans OR (PROGRESS = "Query") OR (PROGRESS = "Run-Time")).
   
   /* Set up the browse combo boxes. This enables the fill-ins and lists. */
   {adecomm/cbdown.i &Frame  = "frame browse"
                     &CBFill = "s_DbFill"
                     &CBList = "s_lst_Dbs"
                     &CBInit = """"}
   
   {adecomm/cbdown.i &Frame  = "frame browse"
                     &CBFill = "s_TblFill"
                     &CBList = "s_lst_Tbls"
                     &CBInit = """"}
   
   {adecomm/cbdown.i &Frame  = "frame browse"
                     &CBFill = "s_SeqFill"
                     &CBList = "s_lst_Seqs"
                     &CBInit = """"}
   
   {adecomm/cbdown.i &Frame  = "frame browse"
                     &CBFill = "s_FldFill"
                     &CBList = "s_lst_Flds"
                     &CBInit = """"}
   
   {adecomm/cbdown.i &Frame  = "frame browse"
                     &CBFill = "s_IdxFill"
                     &CBList = "s_lst_Idxs"
                     &CBInit = """"}
   assign
      /* Activate remaining widgets (i.e., buttons) in the browse window. All 
         are active even though, depending on what`s selected, some may be 
               hidden.
      */ 
      s_icn_Dbs:sensitive  in frame browse = yes
      s_icn_Tbls:sensitive in frame browse = YES
      s_icn_Seqs:sensitive in frame browse = yes
      s_icn_Flds:sensitive in frame browse = yes
      s_icn_Idxs:sensitive in frame browse = yes
   
      /* Make most of things invisible to avoid flashing on startup. Leave
         table stuff visible for now until we see if we've got a database
         or not. 
      */
      
      s_SeqFill:hidden    in frame browse = yes
      s_lst_Seqs:hidden   in frame browse = yes
      s_icn_Flds:hidden   in frame browse = YES
      s_FldFill:hidden    in frame browse = yes
      s_lst_Flds:hidden   in frame browse = yes
      s_icn_Idxs:hidden   in frame browse = YES
      s_IdxFill:hidden    in frame browse = yes
      s_lst_Idxs:hidden   in frame browse = yes
   
      s_btn_Create:hidden in frame browse = yes
      s_btn_Props:hidden  in frame browse = yes
      s_btn_Delete:hidden in frame browse = yes.

   IF SESSION:PIXELS-PER-COL = 6 AND SESSION:PIXELS-PER-ROW = 21 THEN
     /* Japanese Windows */
     ASSIGN s_icn_dbs:Y in frame browse  = s_icn_dbs:Y in frame browse - 10
            s_icn_Tbls:Y in frame browse = s_icn_dbs:Y in frame browse
            s_icn_Seqs:Y in frame browse = s_icn_dbs:Y in frame browse
            s_icn_Flds:Y in frame browse = s_icn_dbs:Y in frame browse
            s_icn_Idxs:Y in frame browse = s_icn_dbs:Y in frame BROWSE .  
 
   assign s_DbLbl2:screen-value in frame browse = s_DbLbl2.
   /* Set up the menu/button graying tables. */
   run adedict/_brwgray.p (INPUT true).
   
   /* Fills the browse select list and set s_CurrDb. */
   run adedict/DB/_getdbs.p.
   dbcnt = s_lst_Dbs:NUM-ITEMS in frame browse.
   if dbcnt > 0 then
   do:
      if DBTYPE("DICTDB") <> "PROGRESS"
       then do:
        assign
          dbnum = s_lst_Dbs:LOOKUP( " " 
                                  + LDBNAME("DICTDB")
                                  + "("
                                  + SDBNAME("DICTDB")
                                  + ")") in frame browse.
        CREATE ALIAS DICTDB FOR DATABASE VALUE(SDBNAME("DICTDB")).
        end.
       else assign
        dbnum = s_lst_Dbs:LOOKUP(LDBNAME("DICTDB")) in frame browse.
      if dbnum = 0 then dbnum = 1.
      
      /* if the current schema is a schema-holder for a foreign db
         and there are no user-defined tables in it, default to the
         foreign db <hutegger 94/06> unless this module doesn't support
         that gateway (los 12/28/94) 
      */
      if    dbnum + 1 <= dbcnt
        AND s_dbcache_type[dbnum]      = "PROGRESS"
        AND s_dbcache_type[dbnum + 1] <> "PROGRESS"
        AND CAN-DO(DATASERVERS, s_dbcache_type[dbnum + 1])
        then RUN adedict/_dictfdb.p (INPUT-OUTPUT dbnum).
                                 /* ev. select schema of foreign db */  
      
      assign
         s_CurrDb = s_lst_Dbs:ENTRY(dbnum) in frame browse
         s_lst_Dbs:screen-value in frame browse = s_CurrDb.
   end.
   else 
      assign
         s_icn_Tbls:hidden in frame browse = YES
         s_TblFill:hidden  in frame browse = yes
         s_lst_tbls:hidden in frame browse = yes
         s_icn_Seqs:hidden in frame browse = yes.
   
   s_DbFill:screen-value in frame browse = s_CurrDb.
   ASSIGN fhidden = no.
   
   /* Initialize dirty flag */
   {adedict/setdirty.i &Dirty = "false"}.
   
   /* Make it very apparent that we're in read only modes so user knows why
      things are grayed out.
   */
   if s_ReadOnly then
      if istrans then
         message "Note: The dictionary is in read-only mode since" SKIP
                 "you are in the middle of a transaction."
            view-as ALERT-BOX INFORMATION buttons OK.
      else
         message "Note: Because of the version of {&PRO_DISPLAY_NAME} you are" SKIP
                 "using, the dictionary is in read-only mode."
            view-as ALERT-BOX INFORMATION buttons OK.
   
   /* Make it easy on startup when there is no current database, by 
      prompting the user to create or connect a database. 
   */
   if s_CurrDb = "" then
   do:
      /* remove wait cursor while in dlg */
      run adecomm/_setcurs.p ("").  
      display "" @ loading with frame logo.
   
      run Startup_Options.
      if RETURN-VALUE = "exit" then
      do:
         delete widget s_win_Logo.
         delete widget s_win_Browse.
         session:suppress-warnings = supw_sav.
         return.
      end.
   
      display "Loading..." @ loading with frame logo.
      
      run adecomm/_setcurs.p ("WAIT"). 
   end.
   
   /* This causes all kinds of work to be done based on the currently
      selected database (or no database).  s_DictState will be set. */
   s_ask_gateconn = no. /* don't ask for connection (hutegger 95/05) */
   run adedict/DB/_switch.p.
   s_ActionProc = "".

   /* As long as there is no database selected, we'll hang out here.
      As soon as we connect to a database, we'll run _dcttran.p 
      which will take control for as long as we are working with that 
      database.
   */
   mainloop: 
   repeat:
      if s_DictState = {&STATE_DONE} then
         leave mainloop.
   
      if s_DictState = {&STATE_NO_DB_SELECTED} then
      do:
         if s_win_Logo <> ? then 
         do:
            /* We're in start up mode */
            run adecomm/_setcurs.p ("").
            session:immediate-display = no.
            delete widget s_win_Logo.
            s_win_Logo = ?.
            current-window = s_win_Browse.
            view frame browse.
         end.
         wait-for "U1" of frame browse.   
      end.
      else
         run adedict/_dcttran.p.
   
      /* ActionProc may switch databases or disconnect a database. 
         Either way, our state may change. */
      if s_ActionProc <> "" then
      do:
         run VALUE(s_ActionProc).
         s_ActionProc = "".
      end.
   end.         /* end repeat */
end.  /* end do ON STOP */

/* Delete all dictionary windows and help window if it's up. */
if s_win_Logo <> ? then /* this means user hit STOP before we even begun */
do:
   run adecomm/_setcurs.p ("").
   session:immediate-display = no.
   delete widget s_win_Logo.
end.

run adedict/_delwins.p (INPUT yes).
run adecomm/_adehelp.p ("dict", "QUIT", ?, ?).
if s_win_Browse <> ? then
   delete widget s_win_Browse.
session:suppress-warnings = supw_sav.  /* reset to saved value */









/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _isdata.i

Description: 
   Check to see if there is any data in this table.  This will be compiled
   at run time when we know what the table name is.
 
Argument:
   &1  - The table to check.

Output Parameter:
   p_IsData - Flag - set to yes if there is data, no otherwise.

Author: Laura Stern

Date Created: 11/16/92 

----------------------------------------------------------------------------*/

Define OUTPUT parameter p_IsData as logical NO-UNDO.


p_IsData = CAN-FIND(FIRST {1}).
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _leavnam.p

Description:
   The name field of a create dialog or property window has been "left".
   Check the name to see if it's allright.

   Note: This is a separate .p instead of an internal procedure in edittrig.i
   in order to make edittrig.i smaller.  I was hitting the size limit!.

Input Parameters:
   p_OrigName - If editing, this was the original name before we sensitive it
      	        for edit.  If adding, this is ignored.
   p_Win      - If editing the window to parent any alert boxes to.  If
      	        adding this is ignored.

Output Parameters:
   p_Name     - Set to the new name value.
   p_Okay     - Set to:
      	       	  yes if name is okay, and validation on it should continue.
      	       	  no  if name is invalid and caller should return NO-APPLY
      	       	  ?   if name if blank or unchanged and caller should return
      	       	      without further processing.
 
Author: Laura Stern

Date Created: 07/14/92 

----------------------------------------------------------------------------*/

{adedict/dictvar.i shared}

Define INPUT  PARAMETER p_OrigName  as char    	      NO-UNDO.
Define INPUT  PARAMETER p_Win  	    as widget-handle  NO-UNDO.
Define OUTPUT PARAMETER p_Name 	    as char 	      NO-UNDO.
Define OUTPUT PARAMETER p_Okay 	    as logical 	      NO-UNDO.


p_Name = TRIM (SELF:screen-value). 
p_Okay = ?.

if NOT s_Adding then
do:
   /* If editing and the name hasn't been changed from what it started 
      as, do nothing. */ 
   if LC(p_OrigName) = LC(p_Name) then
      return.

   /* To parent any alert boxes properly.  Since add is modal, we know 
      it's parent is still correct. */
   current-window = p_Win.
end.

/* Make sure the name is a valid identifier for Progress.  Allow it
   to be blank or unknown. */
run adecomm/_valname.p (INPUT p_Name, INPUT true, OUTPUT p_Okay).

if p_Okay then
   SELF:screen-value = p_Name.  /* Reset the trimmed value */





/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _newobj.p

Description:
   Add the name of the object just created to the appropriate list box,
   select it and cause it to scroll into view.

Input Parameters
   p_List   - The list box widget to add the item to.
   p_Name   - The name of the object (i.e., the string) to add to the list.
   p_InsPos - The name of the object who's position the new entry will take
      	      (i.e., the name that we will insert the new one in front of).
      	      If this is blank, the new name will be added at the end.
   p_Cached - Flag indicating if select list is currently cached.
   p_Obj    - The symbolic object number (e.g., {&OBJ_TBL})

Author: Laura Stern

Date Created: 03/02/92 

----------------------------------------------------------------------------*/

{adedict/dictvar.i shared}
{adedict/brwvar.i shared}


Define INPUT PARAMETER p_List 	 as widget-handle NO-UNDO.
Define INPUT PARAMETER p_Name 	 as char  	  NO-UNDO.
Define INPUT PARAMETER p_InsPos  as char     	  NO-UNDO.
Define INPUT PARAMETER p_Cached  as logical  	  NO-UNDO.
Define INPUT PARAMETER p_Obj     as integer  	  NO-UNDO.


if p_Cached then
do:
   if p_InsPos = "" then
      s_Res = p_List:ADD-LAST(p_Name).
   else
      s_Res = p_List:INSERT(p_Name, p_InsPos).

   p_List:screen-value = p_Name.
   run adecomm/_scroll.p (INPUT p_List, INPUT p_Name).

   apply "value-changed" to p_List.

   /* If this is the only item in the list, (i.e., the list was previously
      empty) the browse window and menu may need some adjusting. */
   if p_List:NUM-ITEMS = 1 then
      run adedict/_brwadj.p (INPUT p_Obj, INPUT 1).
end.




/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _nextobj.p

Description:
   Get the next or previous of an object and update the property window
   and possibly the browse window to show the new object.   

Input Parameter: 
   p_Obj  - The object type (e.g., OBJ_TBL)
   p_Next - True - Do Next;  False - do Previous
      
Author: Laura Stern

Date Created: 05/03/92 
    Modified: 06/29/98 D. McMann Added _Owner to _File find
              05/19/99 Mario B.  Adjust Width Field browser integration.
              08/08/02 D. McMann Eliminated any sequences whose name begins "$" - Peer Direct

----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i  shared}
{adedict/uivar.i    shared}
{adedict/brwvar.i shared}    
{adecomm/cbvar.i    shared}

{adedict/TBL/tblvar.i shared}
{adedict/SEQ/seqvar.i shared}
{adedict/FLD/fldvar.i shared}
{adedict/IDX/idxvar2.i shared}
{adedict/IDX/idxvar.i shared}


Define INPUT PARAMETER p_Obj  as integer NO-UNDO.
Define INPUT PARAMETER p_Next as logical NO-UNDO.

Define var nxttbl as char NO-UNDO.

case p_Obj:
   when {&OBJ_TBL} then	
   do:
      if p_Next then 
      do:
      	 {adedict/TBL/nexttbl.i &Name = s_CurrTbl
      	       	     	      	&Next = nxttbl}
	 if nxttbl <> "" then
	 do:
	    run adecomm/_setcurs.p ("WAIT").
	    s_lst_Tbls:screen-value in frame browse = nxttbl.
      	    s_TblFill:screen-value in frame browse = nxttbl.
      	    run adedict/_objsel.p (INPUT {&OBJ_TBL}).
	    run adecomm/_setcurs.p ("").
	 end.
	 else do:
	    IF s_win_Tbl <> ? THEN
      	       current-window = s_win_Tbl.
	    ELSE IF s_win_Width <> ? THEN
	       current-window = s_win_Width.
	    message "You are at the last table." 
      	       view-as alert-box information buttons ok.
      	 end.
      end.
      else do:
	 find _File where _File._Db-recid = s_DbRecId AND
			  _File._File-Name = s_CurrTbl AND
			  (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN").
      	 if s_Show_Hidden_Tbls then
	    find PREV _File use-index _File-name
	      where _File._Db-recid = s_DbRecId 
	        and (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN") NO-ERROR.
      	 else
	    find PREV _File use-index _File-name 
      	      where NOT _File._Hidden and _File._Db-recid = s_DbRecId 
      	        and (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN") NO-ERROR.
      
	 if AVAILABLE _File then
	 do:
	    run adecomm/_setcurs.p ("WAIT").
	    s_lst_Tbls:screen-value in frame browse = _File._File-Name.
      	    s_TblFill:screen-value in frame browse  = _File._File-Name.
      	    run adedict/_objsel.p (INPUT {&OBJ_TBL}).
	    run adecomm/_setcurs.p ("").
	 end.
	 else do:
	    IF s_win_Tbl <> ? THEN
               current-window = s_win_Tbl.
	    ELSE IF s_win_Width <> ? THEN
	       current-window = s_win_Width.
	    message "You are at the first table."
	       view-as alert-box information buttons ok.
      	 end.
      end.
   end.
   when {&OBJ_SEQ} then
   do:	 
      if p_Next then
      do:
	 find FIRST _Sequence where _Sequence._Db-recid = s_DbRecId 
                            AND NOT _Sequence._Seq-Name BEGINS "$"
                            AND _Sequence._Seq-Name > s_CurrSeq NO-ERROR.
      
	 if AVAILABLE _Sequence then
	 do:
	    run adecomm/_setcurs.p ("WAIT").
	    s_lst_Seqs:screen-value in frame browse = _Sequence._Seq-Name.
      	    s_SeqFill:screen-value in frame browse = _Sequence._Seq-Name.
      	    run adedict/_objsel.p (INPUT {&OBJ_SEQ}).
	    run adecomm/_setcurs.p ("").
	 end.
	 else do:
      	    current-window = s_win_Seq.
	    message "You are at the last sequence."
	       view-as alert-box information buttons ok.
      	 end.
      end.
      else do:
	 find _Sequence where _Sequence._Db-recid = s_DbRecId 
                      AND NOT _Sequence._Seq-Name BEGINS "$"
                      AND _Sequence._Seq-Name = s_CurrSeq.
	 find PREV _Sequence where _Sequence._Db-recid = s_DbRecId 
                      AND NOT _Sequence._Seq-Name BEGINS "$"
                      use-index _Seq-name NO-ERROR.
      
	 if AVAILABLE _Sequence then
	 do:
	    run adecomm/_setcurs.p ("WAIT").
	    s_lst_Seqs:screen-value in frame browse = _Sequence._Seq-Name.
      	    s_SeqFill:screen-value in frame browse = _Sequence._Seq-Name.
      	    run adedict/_objsel.p (INPUT {&OBJ_SEQ}).
	    run adecomm/_setcurs.p ("").
	 end.
	 else do:
      	    current-window = s_win_Seq.
	    message "You are at the first sequence."
	       view-as alert-box information buttons ok.
      	 end.
      end.
   end.

   when {&OBJ_FLD} then
   do:	 
      if p_Next then
      do:
      	 find _File where RECID(_File) = s_TblRecId.
	 find _Field of _File where _Field._Field-Name = s_CurrFld.
	 if s_Order_By = {&ORDER_ALPHA} THEN
	    find NEXT _Field of _File use-index _Field-name NO-ERROR.
	 ELSE
	    find NEXT _Field of _File use-index _Field-position NO-ERROR.
	  
	 if AVAILABLE _Field then
	 do:
	    run adecomm/_setcurs.p ("WAIT").
      	    if s_Flds_Cached then
      	    do:
	       s_lst_Flds:screen-value in frame browse = _Field._Field-Name.
      	       s_FldFill:screen-value in frame browse = _Field._Field-Name.
      	    end.
      	    run adedict/_objsel.p (INPUT {&OBJ_FLD}).
	    run adecomm/_setcurs.p ("").
	 end.
	 else do:
      	    current-window = s_win_Fld.
	    message "You are at the last field."
	       view-as alert-box information buttons ok.
      	 end.
      end.
      else do:
      	 find _File where RECID(_File) = s_TblRecId.
	 find _Field of _File where _Field._Field-Name = s_CurrFld.
	 if s_Order_By = {&ORDER_ALPHA} THEN
	    find PREV _Field of _File use-index _Field-name NO-ERROR.
	 ELSE
	    find PREV _Field of _File use-index _Field-position NO-ERROR.
      
	 if AVAILABLE _Field then
	 do:
	    run adecomm/_setcurs.p ("WAIT").
      	    if s_Flds_Cached then
      	    do:
	       s_lst_Flds:screen-value in frame browse = _Field._Field-Name.
      	       s_FldFill:screen-value in frame browse = _Field._Field-Name.
      	    end.
	    run adedict/_objsel.p (INPUT {&OBJ_FLD}).
	    run adecomm/_setcurs.p ("").
	 end.
	 else do:
      	    current-window = s_win_Fld.
	    message "You are at the first field."
	       view-as alert-box information buttons ok.
      	 end.
      end.
   end.

   when {&OBJ_IDX} then
   do:	 
      if p_Next then 
      do:
      	 find _File where RECID(_File) = s_TblRecId.
	 find FIRST _Index of _File where _Index._Index-name > s_CurrIdx 
      	    NO-ERROR.
      
	 if AVAILABLE _Index then
	 do:	
	    run adecomm/_setcurs.p ("WAIT").
      	    if s_Idxs_Cached then
      	    do:
	       s_lst_Idxs:screen-value in frame browse = _Index._Index-Name.
      	       s_IdxFill:screen-value in frame browse = _Index._Index-Name.
      	    end.
	    run adedict/_objsel.p (INPUT {&OBJ_IDX}).
	    run adecomm/_setcurs.p ("").
	 end.
	 else do:
      	    current-window = s_win_Idx.
	    message "You are at the last index."
	       view-as alert-box information buttons ok.
      	 end.
      end.
      else do:
      	 find _File where RECID(_File) = s_TblRecId.
	 find _Index of _File where _Index._Index-Name = s_CurrIdx.
	 find PREV _Index of _File use-index _Index-name NO-ERROR.
      
	 if AVAILABLE _Index then
	 do:
	    run adecomm/_setcurs.p ("WAIT").
      	    if s_Idxs_Cached then
      	    do:
	       s_lst_Idxs:screen-value in frame browse = _Index._Index-Name.
      	       s_IdxFill:screen-value in frame browse = _Index._Index-Name.
      	    end.
	    run adedict/_objsel.p (INPUT {&OBJ_IDX}).
	    run adecomm/_setcurs.p ("").
	 end.
	 else do:
      	    current-window = s_win_Idx.
	    message "You are at the first index."
	       view-as alert-box information buttons ok.
      	 end.
      end.
   end.
end.




/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _objsel.p

Description: 
   Code to run when we are switching to a different object -
   e.g., because the user clicked on a browse select list entry or
   because the code has changed the selection (because of delete or Next
   etc.)

Input Parameter: 
   p_Obj - The object type of the object selected (e.g., OBJ_TBL)
      
Author: Laura Stern

Date Created: 05/03/92 
    Modified: 06/30/98 D. McMann Added  (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
                                 to find of _File
              10/14/03 D. McMann Add check for LOB support
----------------------------------------------------------------------------*/

{adedict/dictvar.i shared}
{adedict/brwvar.i shared}


Define INPUT PARAMETER p_Obj as integer NO-UNDO.

Define var save_name as char NO-UNDO.


/*========================Internal Procedures===========================*/

/*-----------------------------------------------------------------------
   The user has single clicked on a select list item.  Do some initial
   processing for this action.

   Input Parameters:
      p_Lst  - The list widget for this object
      p_Win  - The window widget for this object

   Input/Output Parameters:
      p_Curr - The name for the current object of the type clicked on

  Returns: "done" if not further processing should occur.  
      	   Otherwise "".

-----------------------------------------------------------------------*/
PROCEDURE Init_Object_Selection:

Define INPUT PARAMETER 	      p_Lst  as widget-handle NO-UNDO.
Define INPUT PARAMETER 	      p_Win  as widget-handle NO-UNDO.
Define INPUT-OUTPUT PARAMETER p_Curr as char 	      NO-UNDO.

   /* If this is the value already selected don't do anything. */
   if p_Curr = p_Lst:screen-value then
      return "done".
 
   /* Save the current value and reset it based on the current selection */
   save_name = p_Curr.
   p_Curr = p_Lst:screen-value.
   if p_Curr = ? then p_Curr = "".

   return "".
end.


/*-----------------------------------------------------------------------
   Refresh properties in the appropriate edit window if a new object
   of the same type is chosen and the edit window is already open.

   Input Parameters:
      p_Obj  - The object type we're dealing with (e.g., {&OBJ_FLD})
      p_Curr - The current value for selected object of this type.
      p_Func - The name of the function to call to display properties

   Input-Output Parameters:
      p_Win - Handle of the properties window

   Output Parameters:
      p_Err  - Set to true if properties window is up and user wants
      	       tries to save before switching objects and an error occurs.
      	       We don't really want to switch when this happens or we've 
      	       got a big mess.
-----------------------------------------------------------------------*/
PROCEDURE Refresh_Props:

Define INPUT   	     PARAMETER p_Obj   as integer     	NO-UNDO.
Define INPUT   	     PARAMETER p_Curr  as char  	NO-UNDO.
Define INPUT   	     PARAMETER p_Func  as char  	NO-UNDO.
Define INPUT-OUTPUT  PARAMETER p_Win   as widget-handle NO-UNDO.
Define OUTPUT  	     PARAMETER p_Err   as logical       NO-UNDO.

Define var saveobj as integer NO-UNDO.

   p_Err = no.
   if p_Win <> ? then
   do:
      /* Make sure there is an object to show.  There may not be if we
      	 just switched to a table with no fields, if we just toggled to
      	 not showing hidden tables and there are no other tables in the 
      	 database, etc.
      */
      if p_Curr <> "" then
      do:
      	 /* Make sure we're not clobbering changes before switching. If 
      	    we're in add mode, don't check - we already did that before
      	    bringing up add dialog.  Also, if changes were made and an
      	    error occurs while saving, don't continue.
      	 */
      	 if NOT s_Adding then
      	 do:
      	    run adedict/_changed.p (INPUT p_Obj, INPUT no, OUTPUT p_Err).
      	    if p_Err then return.
      	 end.

      	 /* The field properties routine depends on s_CurrObj being set to
      	    know what to do (since field props routine currently deals with
      	    fields and domains).  However, we're not necessarily in field 
      	    mode just because we're showing field properties.  e.g., While 
      	    field props window is up, user may be in table mode and when 
      	    he clicks on a different table, the fields for that table are
      	    shown and the field props window is refreshed.  But the user
      	    wants to remain in table mode.  So save the current object
      	    change it temporarily for property set up and then restore it.
      	 */
      	 saveobj = s_CurrObj.
      	 s_CurrObj = p_Obj.
      	 run VALUE("adedict/" + p_Func).  /* call properties routine */
      	 s_CurrObj = saveobj.
      end.
      else do:
      	 {adedict/delwin.i &Win = p_Win &Obj = p_Obj}
      end.
   end.
end.
   

/*============================Mainline Code===============================*/

Define var save_id as recid NO-UNDO.
Define var err     as logical NO-UNDO.

s_Browse_Stat:screen-value in frame browse = "". /* clear status line */

case p_Obj:
   when {&OBJ_DB} then
   do:
      /* If user clicked again on database that's already the current
      	 one, don't do anything.
      */
     if s_lst_Dbs:screen-value in frame browse = s_CurrDb
      then return.
   
      /* Cause whichever wait-for we're in to break so we can switch 
      	 databases (see _dictg.p and _dcttran.p).
	 s_CurrDb isn't reset till switchdb since the the user may decide to
	 continue using the current database after all (may decide not to 
      	 commit).

         If user switched Dbs by using cursor in Db list, we want to
      	 return focus to the list instead of defaulting to the fill-in.
      	 So remember if list has the focus.
      	 focus should never be ? here (I don't think) but the
      	 GUI focus model is a bit wierd so sometimes it is.  
      */
      s_ActionProc = "adedict/DB/_switch.p".
      if focus <> ? then
      	 s_Dblst_Focus = (if s_lst_Dbs:handle in frame browse = 
      	       	     	  focus:handle then yes else no).

      /* When the wait-for breaks and if we are in the database fill-in,
      	 we will get a leave trigger for it.  If the user just got here
      	 because he typed the first letter of a db name, the leave
      	 trigger will cause the full name to be displayed in the fill-in.
      	 We don't want this.  So define another leave trigger that will
      	 supercede the real one.  This will then go out of scope and won't
      	 interfere with the real one when a normal leave event happens -
      	 e.g., due to TAB.
      */
      on leave of s_DbFill in frame browse do:
      end.

      if s_DictDirty then
      do:
	 s_Trans = {&TRANS_ASK_AND_DO}.
	 apply "U2" to frame browse.
      end.
      else 
	 if s_DictState = {&STATE_NO_DB_SELECTED} then
	    apply "U1" to frame browse.
	 else
	    apply "U2" to frame browse.
   end.

   when {&OBJ_TBL} then	
   do:
      run Init_Object_Selection 
      	 (INPUT s_lst_Tbls:HANDLE in frame browse,
	  INPUT s_win_Tbl,
	  INPUT-OUTPUT s_CurrTbl).
      if RETURN-VALUE = "done" then return.
   
      save_id = s_TblRecId.
      if s_CurrTbl = "" then 
      do:
	 s_TblRecId = 0.
      	 if s_win_Tbl <> ? then
      	 do:
      	    {adedict/delwin.i &Win = s_win_Tbl &Obj = {&OBJ_TBL}}
      	 end.
      	 if s_win_Fld <> ? then
      	 do:
      	    {adedict/delwin.i &Win = s_win_Fld &Obj = {&OBJ_FLD}}
      	 end.
      	 if s_win_Idx <> ? then
      	 do:
      	    {adedict/delwin.i &Win = s_win_Idx &Obj = {&OBJ_IDX}}
      	 end.
      	 IF s_win_Width <> ? THEN
      	 DO:
      	    {adedict/delwin.i &Win = s_win_Width &Obj = {&OBJ_TBL}}
      	 END.
      end.
      else do:
	 run adedict/_setid.p (INPUT {&OBJ_TBL}, OUTPUT s_TblRecId).
   
	 /* Since resetting table selection can in turn reset field or index
	    selection, we have to check for changes in the field and index
	    properties windows as well as in the table window (done in 
	    Refresh_Props) before allowing the action to continue.
	 */
	 if s_win_Fld <> ? then
	    run adedict/_changed.p (INPUT {&OBJ_FLD}, INPUT yes, OUTPUT err).
      	 if NOT err AND s_win_Idx <> ? then
  	    run adedict/_changed.p (INPUT {&OBJ_IDX}, INPUT yes, OUTPUT err).
        
	 if NOT err then
	    run Refresh_Props (INPUT {&OBJ_TBL}, s_CurrTbl, "TBL/_tblprop.p", 
			       INPUT-OUTPUT s_win_Tbl,
			       OUTPUT err).
       
       /* If the Adjust SQL Width window is already up, refresh properties */
       IF NOT err AND s_win_Tbl = ? THEN
       run Refresh_Props (INPUT {&OBJ_TBL}, s_CurrTbl, "FLD/_sqlwptr.p",
                         INPUT-OUTPUT s_win_Width, OUTPUT err). 

	 if err then 
	 do:
	    /* Reset everything as if the user never changed the selection. */
	    s_CurrTbl = save_name.
	    s_TblRecId = save_id.
	    s_TblFill:screen-value in frame browse = s_CurrTbl.
	    s_lst_Tbls:screen-value = s_CurrTbl.
	    return.
	 end.
      end.
   
      /* Regardless of which child list is displayed (if any), make sure the
	 next time they are displayed, they are refreshed based on the new
	 table selection. */
      {adedict/uncache.i 
	 &List   = "s_lst_Flds"
	 &Cached = "s_Flds_Cached"
	 &Curr   = "s_CurrFld"}
      {adedict/uncache.i 
	 &List   = "s_lst_Idxs"
	 &Cached = "s_Idxs_Cached"
	 &Curr   = "s_CurrIdx"}
   
      /* Cause whichever list is showing to be redisplayed now. If there's no
	 table (e.g., the last table was just deleted) these lists will become 
	 invisible so don't bother. 
      */
      if s_CurrTbl <> "" then
      do:
	 if s_Lvl2Obj = {&OBJ_FLD} then
      	 do:
      	    /* This will eventually cause refresh of prop window if it's up */
	    run adedict/_brwlist.p (INPUT {&OBJ_FLD}).

      	    /* What I want is to refresh index window with first index for 
      	       this table.  This is a first attempt - but objsel doesn't
      	       work because it assumes browse list is up-to-date for
      	       current table and it isn't so just close the window.
      	    */
      	    if s_win_Idx <> ? then
      	    do:      	       
      	       {adedict/delwin.i &Win = s_win_Idx &Obj = {&OBJ_IDX}}
      	    end.
      	 end.
	 else if s_Lvl2Obj = {&OBJ_IDX} then
      	 do:
      	    /* This will eventually cause refresh of prop window if it's up */
	    run adedict/_brwlist.p (INPUT {&OBJ_IDX}).

      	    /* What I want is to refresh field window with first field for 
      	       this table.  This is a first attempt - but objsel doesn't
      	       work because it assumes browse list is up-to-date for
      	       current table and it isn't so just close the window.
      	    */
      	    if s_win_Fld <> ? then
      	    do:      	       
      	       {adedict/delwin.i &Win = s_win_Fld &Obj = {&OBJ_FLD}}
      	    end.
      	 end.
      end.
   end.

   when {&OBJ_SEQ} then
   do:	 
      run Init_Object_Selection 
      	 (INPUT s_lst_Seqs:HANDLE in frame browse,
	  INPUT s_win_Seq,
	  INPUT-OUTPUT s_CurrSeq).
      if RETURN-VALUE = "done" then return.
   
      /* If the edit window is already up, refresh properties */
      run Refresh_Props (INPUT {&OBJ_SEQ}, s_CurrSeq, "SEQ/_seqprop.p",
			 INPUT-OUTPUT s_win_Seq,
			 OUTPUT err).
   
      if err then
      do:
	 /* Reset everything as if the user never changed the selection. */
	 s_CurrSeq = save_name.
	 s_SeqFill:screen-value in frame browse = s_CurrSeq.
	 s_lst_Seqs:screen-value = s_CurrSeq.
	 return.
      end.
   end.

   when {&OBJ_FLD} then
   do:	 
      run Init_Object_Selection 
      	 (INPUT s_lst_Flds:HANDLE in frame browse,
      	  INPUT s_win_Fld,
	  INPUT-OUTPUT s_CurrFld).
      if RETURN-VALUE = "done" then return.

      /* LOBs do not need to have the fld properties screen refreshed so just
         return as being done */
      IF user_env[35] = "lob" THEN DO:
        ASSIGN user_env[35] = "".
        RETURN "done".
      END.

      /* If the edit window is already up, refresh properties */
      run Refresh_Props (INPUT {&OBJ_FLD}, s_CurrFld, "FLD/_fldprop.p",
			 INPUT-OUTPUT s_win_Fld,
			 OUTPUT err).
   
      if err then
      do:
	 /* Reset everything as if the user never changed the selection. */
	 s_CurrFld = save_name.
	 s_FldFill:screen-value in frame browse = s_CurrFld.
	 s_lst_Flds:screen-value = s_CurrFld.
	 return.
      end.
   end.

   when {&OBJ_IDX} then
   do:	 
      run Init_Object_Selection 
      	 (INPUT s_lst_Idxs:HANDLE in frame browse,
	  INPUT s_win_Idx,
	  INPUT-OUTPUT s_CurrIdx).
      if RETURN-VALUE = "done" then return.
   
      /* If the edit window is already up, refresh properties */
      run Refresh_Props (INPUT {&OBJ_IDX}, s_CurrIdx, "IDX/_idxprop.p",
			 INPUT-OUTPUT s_win_Idx,
			 OUTPUT err).
   
      if err then
      do:
	 /* Reset everything as if the user never changed the selection. */
	 s_CurrIdx = save_name.
	 s_IdxFill:screen-value in frame browse = s_CurrIdx.
	 s_lst_Idxs:screen-value = s_CurrIdx.
	 return.
      end.
   end.
end.





/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _openwin.p

Description:
   A new object has just been selected or double clicked on.  Prepare for
   showing the properties for the selected schema object by opening the 
   window.  

   If the window is already open, don't do anything.  We only want to 
   de-iconify or move to the front if user explicitly asked for
   properties - not if they just switch objects or delete an object 
   causing a different one to be current etc and this code is called in 
   all of these situations.

Input Parameter:
   p_Title  - The title for the window.
   p_Frame  - The widget handle of the frame to be displayed in the window.
      	      It is used to determine the height and width for the window.
   p_Obj    - Object # (which type of prop window is it?)

Input/Output Parameter:
   p_WinHdl - Widget handle for the window to open or refresh. 

Author: Laura Stern

Date Created: 06/08/92 

----------------------------------------------------------------------------*/

{adedict/dictvar.i shared}


Define INPUT   	    parameter p_Title  as char	      	NO-UNDO.
Define INPUT   	    parameter p_Frame  as widget-handle NO-UNDO.
Define INPUT        parameter p_Obj    as integer       NO-UNDO.
Define INPUT-OUTPUT parameter p_WinHdl as widget-handle NO-UNDO.

Define var wid  as decimal NO-UNDO.
Define var ht   as decimal NO-UNDO.
Define var newx as integer NO-UNDO.
Define var newy as integer NO-UNDO.

/* If window isn't open yet, then open it */
if p_WinHdl = ? then
do:
   assign
      /* Add on fudge factor for window decorations.  It doesn't have to
      	 be accurate.
      */ 
      ht = p_Frame:height-pixels + 30
      wid = p_Frame:width-pixels + 15
      newx = s_win_Browse:x + 60
      newy = s_win_Browse:y + 30.

   if newx + wid > session:width-pixels then
      newx = session:width-pixels - wid.
   if newy + ht > session:height-pixels then
      newy = session:height-pixels - ht.

   /* Create with the default size */
   create window p_WinHdl
      assign
         title = p_Title
      	 message-area = no
      	 status-area = no
      	 scroll-bars = no
      	 x = (if s_x_Win[p_Obj] = ? then newx else s_x_Win[p_Obj])
      	 y = (if s_y_Win[p_Obj] = ? then newy else s_y_Win[p_Obj])
      triggers:
         on window-close PERSISTENT 
  	  run adedict/_closwin.p.
      end triggers.
   s_Res = p_WinHdl:load-icon("adeicon/dict%").	/* set minimize icon */

   /* Then resize to fit the frame */
   assign
      ht = p_Frame:height-chars
      wid = p_Frame:width-chars
      p_WinHdl:height-chars = ht
      p_WinHdl:width-chars = wid
      p_WinHdl:max-height = ht
      p_WinHdl:max-width = wid
      p_WinHdl:visible = yes.

   CURRENT-WINDOW = p_WinHdl.
   apply "entry" to p_WinHdl. /* give the window focus */
end.














/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------

File: _setid.p

Description:
   Set p_Id to the recid of the _File record for the current table.

Input Parameter:
   p_ObjType - the type of object (DB or TBL )

Output Parameter:
   p_Id - The place to store the record Id 

Author: Laura Stern

Date Created: 02/07/92 
    Modified: 06/30/98 D. McMann Added  (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
                                 to find of _File
              03/27/02 D. McMann Added new _file find based on new table recid
                                 variable.    
              10/17/03 D. McMann Add NO-LOCK statement to _Db find in support of on-line schema add               
-----------------------------------------------------------------------*/

{adedict/dictvar.i shared}

Define input  parameter p_ObjType   as integer.
Define output parameter p_Id        as recid.



if p_ObjType = {&OBJ_DB}
 then do:
   FIND DICTDB._Db
     where DICTDB._Db._DB-Name = (if {adedict/ispro.i}
                                   then ? 
                                   else s_CurrDb
                                 ) NO-LOCK.
   p_Id = RECID(_Db).
  end.

 else do:  /* table */
   if p_ObjType = {&OBJ_TBL} then DO:

      find first DICTDB._File where DICTDB._File._DB-recid  = s_DbRecId
                                and DICTDB._File._File-name = s_CurrTbl
                            and  (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
                          NO-LOCK NO-ERROR.
       
      IF NOT AVAILABLE DICTDB._File THEN 
      _f-loop:        
      FOR EACH DICTDB._File where DICTDB._File._File-name = s_CurrTbl 
                              AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
                              NO-LOCK:
          
        IF DICTDB._File._db-recid = s_DbRecid THEN DO:
          assign p_id = RECID(DICTDB._File).
          LEAVE _f-loop.
        END.
      END.                         
      ELSE 
      p_Id = RECID(DICTDB._File).
      IF p_id = ? THEN
          ASSIGN p_Id = n_tblrecid.
   end.
  end.     /* table */





/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: browse.f

Description:   
   This file contains the form for the browse frame of the dictionary
   as well as the frame for the icon palette.
 
Author: Laura Stern

Date Created: 01/28/92 

History:

    11/09/94    gfs     Reduced size of DD window & frame so that it fits on
                        Japanese WINDOWS.
    11/27/96    kkelley Removed text under icons in dictionary for WIN95                    
----------------------------------------------------------------------------*/


/* Form for browse window */
Form
   SKIP({&TFM_WID})

   s_icn_Dbs         at  2
   s_icn_Tbls        at 20 SPACE({&HM_BTNG})
   s_icn_Seqs              
   s_icn_Flds        at 51 SPACE({&HM_BTNG})
   s_icn_Idxs        
   SKIP(1)
  /* Removed Text Under Icons for WIN95
     s_DbLbl           at  2  NO-LABEL format "x(11)" view-as TEXT
     s_TblLbl          at 20  NO-LABEL format "x(9)"  view-as TEXT
     s_SeqLbl          at row-of s_TblLbl col-of s_icn_Seqs  
                              NO-LABEL format "x(11)" view-as TEXT
     s_FldLbl          at 51  NO-LABEL format "x(9)"  view-as TEXT
     s_IdxLbl          at row-of s_FldLbl col-of s_icn_Idxs
       		         NO-LABEL format "x(9)"  view-as TEXT
  */
   s_DbLbl2          at  2  NO-LABEL format "x(15)" view-as TEXT {&STDPH_SDIV}
   s_Lvl1Lbl         at 20  NO-LABEL format "x(28)" view-as TEXT {&STDPH_SDIV}
   s_Lvl2Lbl         at 51  NO-LABEL format "x(28)" view-as TEXT {&STDPH_SDIV}

   SKIP(.2)

   s_DbFill          at  2           format "x(11)" {&STDPH_FILL}
                                     view-as FILL-IN size 15 by 1
   s_TblFill         at 20           format "x(32)" {&STDPH_FILL}
                                     view-as FILL-IN size 28 by 1
   s_SeqFill         at row-of s_TblFill col-of s_TblFill 
                                     format "x(32)"	{&STDPH_FILL}
                                     view-as FILL-IN size 28 by 1
   s_FldFill         at 51           format "x(32)"	{&STDPH_FILL}
                                     view-as FILL-IN size 28 by 1
   s_IdxFill         at row-of s_FldFill col-of s_FldFill 
                                     format "x(32)"	{&STDPH_FILL}
                                     view-as FILL-IN size 28 by 1

   SKIP(.1)                                     

   s_lst_Dbs         at 2            view-as SELECTION-LIST SINGLE 
                                     size 15 by 5.5 
                                     SCROLLBAR-V SCROLLBAR-H
   s_lst_Tbls        at 20           view-as SELECTION-LIST SINGLE 
                                     size 28 by 5.5
                                     SCROLLBAR-V SCROLLBAR-H
   s_lst_Seqs        at row-of s_lst_Tbls col-of s_lst_tbls
                                     view-as SELECTION-LIST SINGLE 
                                     size 28 by 5.5
                                     SCROLLBAR-V SCROLLBAR-H
   s_lst_Flds        at 51           view-as SELECTION-LIST SINGLE 
                                     size 28 by 5.5
                                     SCROLLBAR-V SCROLLBAR-H
   s_lst_Idxs        at row-of s_lst_Flds col-of s_lst_Flds
                                     view-as SELECTION-LIST SINGLE 
                                     size 28 by 5.5
                                     SCROLLBAR-V SCROLLBAR-H
                            SPACE(1) 
   SKIP({&VM_WIDG}) 

   s_btn_Create      at 4   SPACE({&HM_BTN})
   s_btn_Props              SPACE({&HM_BTN})
   s_btn_Delete           

   SKIP(.2)
   s_Browse_Stat     at  2  NO-LABEL format "x(70)" view-as TEXT 
                           
   with frame browse three-d NO-LABELS NO-BOX SCROLLABLE.


/*-------------------------------------------------------------------------

  This was the spacing when we had 3 icons across - tables, domains, seq.-
  in case we re-instate domains some day.

   s_icn_Tbls        at 20
   s_icn_Doms        at 32     
   s_icn_Seqs        at 44       

   SKIP
   
   s_TblLbl          at 20  NO-LABEL format "x(6)" view-as TEXT
   s_DomLbl          at 33  NO-LABEL format "x(5)" view-as TEXT
   s_SeqLbl          at 43  NO-LABEL format "x(9)" view-as TEXT
-----------------------------------------------------------------------*/


/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: brwtrig.i

Description:
   Here we have all the trigger definitions for the browse window of the
   dictionary.
 
Author: Laura Stern

Date Created: 02/04/92 
    Modified: 05/19/99 Mario B.  Adjust Width Field browser integration.
----------------------------------------------------------------------------*/


/*========================Internal Procedures===========================*/

/*------------------------------------------------------------------------
   Respond to request for create of an object.  By the time we get here
   s_CurrObj is already set to this object type since we caused the
   browse button for this type to be pushed, if it wasn't already.

   Input Parameters:
      p_Obj  - The object type the user wants to create (e.g., {&OBJ_SEQ})
      p_Win  - Handle to the property window for this object type.
      p_Func - The function to call to bring up create dialog box.
------------------------------------------------------------------------*/
PROCEDURE Do_Create:

Define INPUT PARAMETER p_Obj  as integer       NO-UNDO.
Define INPUT PARAMETER p_Win  as widget-handle NO-UNDO.
Define INPUT PARAMETER p_Func as char  	       NO-UNDO.

Define var err as logical NO-UNDO.

   /* Make sure we're not clobbering changes before adding new obj. If the 
      user saves changes and an error occurs, don't continue. */
   if p_Win <> ? then
   do:
      run adedict/_changed.p (INPUT p_Obj, INPUT yes, OUTPUT err).
      if err then return.
   end.

   s_Adding = true.

   current-window = s_win_Browse.
   run VALUE("adedict/" + p_Func).
   s_Adding = false.
end.


/*-----------------------------------------------------------------------
   This is called to perform the "default-action", e.g., the double
   click or RETURN action from a selection list in the browse window.

   Note: When the user double clicks we get a single click (selection) 
   event first.  So single click processing has already occurred by the
   time we get here.

   Input Parameters:
      p_Obj  - The object type we're dealing with (e.g., {&OBJ_FLD})

-----------------------------------------------------------------------*/
PROCEDURE Do_Dbl_Click:

Define INPUT PARAMETER p_Obj as integer NO-UNDO.

Define var winhdl as widget-handle NO-UNDO.
Define var icnhdl as widget-handle NO-UNDO.
Define var func   as char          NO-UNDO.

   case p_Obj:
      when {&OBJ_DB} then
      	 assign
      	    winhdl = s_win_Db
      	    icnhdl = s_icn_Dbs:HANDLE in frame browse
      	    func   = "adedict/DB/_dbprop.p".
      when {&OBJ_TBL} then
      DO:
         assign
      	    winhdl = s_win_Tbl 
      	    icnhdl = s_icn_Tbls:HANDLE in frame browse
      	    func   = "adedict/TBL/_tblprop.p".
      END.      	    
      when {&OBJ_SEQ} then 
         assign
      	    winhdl = s_win_Seq 
      	    icnhdl = s_icn_Seqs:HANDLE in frame browse
      	    func   = "adedict/SEQ/_seqprop.p".
      when {&OBJ_FLD} then
      DO:
         IF s_win_Width <> ? THEN LEAVE.
         assign
      	    winhdl = s_win_Fld
      	    icnhdl = s_icn_Flds:HANDLE in frame browse
      	    func   = "adedict/FLD/_fldprop.p".
      END.      	    
      when {&OBJ_IDX} then
         assign
      	    winhdl = s_win_Idx
      	    icnhdl = s_icn_Idxs:HANDLE in frame browse
      	    func   = "adedict/IDX/_idxprop.p".
   end.
   if winhdl = ? then /* window isn't open yet */
   do:
      run Push_Obj_Button (p_Obj, icnhdl, true).
      if p_Obj = {&OBJ_DB} then
      	 /* This is done here and not in _dbprop.p because dbprops
      	    is called from elsewhere, when we don't want to call
      	    _openwin.p.  This is not true of the other OBJ types.
      	 */
	 run adedict/_openwin.p
	    (INPUT "Database Properties",
	     INPUT frame dbprops:HANDLE,
      	     INPUT {&OBJ_DB},
	     INPUT-OUTPUT s_win_Db).
      run VALUE(func).
   end.
   else do: 
      winhdl:window-state = WINDOW-NORMAL.  /* un-minimized */
      s_Res = winhdl:move-to-top().
      apply "entry" to winhdl. /* give the window focus */
   end.
end.


/*------------------------------------------------------------------------
   Respond to the user clicking on the "Create" button in the browse
   window.
------------------------------------------------------------------------*/
PROCEDURE Choose_Create:
   Define var err as logical NO-UNDO.

   s_Browse_Stat:screen-value in frame browse = "". /* clear status line */

   case s_CurrObj:
      when {&OBJ_DB} then
      	 run adedict/DB/_newdb.p.

      when {&OBJ_TBL} then
      do:
	 /* Since adding a table will reset table selection which in turn
	    can reset field or index selection, we have to check for changes
	    in the field and index properties windows as well as in the table
	    window (done in Do-Create) before allowing the action to continue.
	 */
	 if s_Lvl2Obj = {&OBJ_FLD} AND s_win_Fld <> ? then
	    run adedict/_changed.p (INPUT {&OBJ_FLD}, INPUT yes, OUTPUT err).
	 else if s_Lvl2Obj = {&OBJ_IDX} AND s_win_Idx <> ? then
	    run adedict/_changed.p (INPUT {&OBJ_IDX}, INPUT yes, OUTPUT err).
      
	 if NOT err then 
      	 do:
	    run Do_Create (INPUT {&OBJ_TBL}, 
      	       	     	   INPUT s_win_Tbl, 
      	       	     	   INPUT "TBL/_newtbl.p").
      	 end.
      end.
      when {&OBJ_SEQ} then 
         run Do_Create (INPUT {&OBJ_SEQ}, 
      	       	     	INPUT s_win_Seq, 
      	       	     	INPUT "SEQ/_newseq.p").

      when {&OBJ_FLD} then 
      	 run Do_Create (INPUT {&OBJ_FLD}, 
      	       	     	INPUT s_win_Fld, 
      	       	     	INPUT "FLD/_newfld.p").

      when {&OBJ_IDX} then
      	 run Do_Create (INPUT {&OBJ_IDX}, 
      	       	     	INPUT s_win_Idx, 
      	       	     	INPUT "IDX/_newidx.p").
   end.
end.


/*------------------------------------------------------------------------
   Respond to the user clicking on the "Properties" button in the browse
   window.

   Do what would happen if the user double clicked - Call routine
   that get's called on single click and then routine that gets
   called on double click (which already knows that single click
   came first). 
------------------------------------------------------------------------*/
PROCEDURE Choose_Properties:

   case s_CurrObj:
      when {&OBJ_DB} then
      do:
      	 run adedict/_objsel.p (INPUT {&OBJ_DB}).
      	 run Do_Dbl_Click (INPUT ({&OBJ_DB})).
      end.
      when {&OBJ_TBL} then
      do:
      	 run adedict/_objsel.p (INPUT {&OBJ_TBL}).
      	 run Do_Dbl_Click (INPUT ({&OBJ_TBL})).
      end.      
      when {&OBJ_SEQ} then
      do:
      	 run adedict/_objsel.p (INPUT {&OBJ_SEQ}).
      	 run Do_Dbl_Click (INPUT ({&OBJ_SEQ})).
      end.
      when {&OBJ_FLD} then
      do:
      	 run adedict/_objsel.p (INPUT {&OBJ_FLD}).
      	 run Do_Dbl_Click (INPUT ({&OBJ_FLD})).
      end.
      when {&OBJ_IDX} then
      do:
      	 run adedict/_objsel.p (INPUT {&OBJ_IDX}).
      	 run Do_Dbl_Click (INPUT ({&OBJ_IDX})).
      end.
   end.
end.


/*-----------------------------------------------------------------------
   The user just clicked on a "Show Object" button.  This won't get
   called if the button is already down.  Otherwise, push it in and 
   unpush whatever other button is currently pushed in.  Reset s_CurrObj 
   and adjust the labels on the Create/Props/Delete buttons to pertain 
   to this object type.

   Input Parameters:
      p_Obj    - The object type we're dealing with (e.g., {&OBJ_FLD})
      p_Btn    - The "down" button for this object type.
      p_Nolist - The select list is already visible and up to date - 
      	       	 don't refresh it.

-----------------------------------------------------------------------*/
PROCEDURE Push_Obj_Button:

Define INPUT   PARAMETER p_Obj    as integer 	   NO-UNDO.
Define INPUT   PARAMETER p_Btn    as widget-handle NO-UNDO.
Define INPUT   PARAMETER p_Nolist as logical       NO-UNDO.

   s_Browse_Stat:screen-value in frame browse = "". /* clear status line */

   if p_Obj = s_CurrObj then
      return.

   if    p_Obj = {&OBJ_SEQ}
     and index(capab,"s") = 0
     then do:
       message
         "This DataServer does not support sequences."
         view-as alert-box.
       RETURN "no seqence supported".
       end. 

   run adedict/_brwbtn.p (INPUT p_Obj, INPUT p_Btn, INPUT true).   

   if   p_Obj = {&OBJ_DB} 
     OR p_Obj = {&OBJ_TBL}
     then run adedict/_capab.p (INPUT {&CAPAB_SEQ}, OUTPUT capab).
       
   /* Display the list (which calls _brwadj.p which calls brwgray) */
   if p_Obj <> {&OBJ_DB} AND NOT p_Nolist
     then run adedict/_brwlist.p (INPUT p_Obj).
     else run adedict/_brwgray.p (INPUT false).

end.


/*=======================================================================
      	       	     	   ENDKEY in Browse Window
=======================================================================*/

/*----- END-ERROR of BROWSE WINDOW-----*/
on END-ERROR of frame browse 
   return NO-APPLY.


/*=======================================================================
     	       	     	HELP for the browse window
=======================================================================*/

/*----- HELP anywhere -----*/
on HELP anywhere
   RUN "adecomm/_adehelp.p" ("dict", "TOPICS", {&Data_Dictionary_Window}, ?).


/*=======================================================================
      	       	     	"Object Mode" Toggle Buttons
=======================================================================*/

/*----- SELECTION of DATABASES BUTTON -----*/
On mouse-select-down of s_icn_Dbs in frame browse
   run Push_Obj_Button (INPUT {&OBJ_DB}, 
      	       	     	INPUT s_icn_Dbs:HANDLE in frame browse,
      	       	     	INPUT false).


/*----- SELECTION of TABLES BUTTON -----*/
On mouse-select-down of s_icn_Tbls in frame browse
   run Push_Obj_Button (INPUT {&OBJ_TBL}, 
      	       	     	INPUT s_icn_Tbls:HANDLE in frame browse,
      	       	     	INPUT false).

/*----- SELECTION of SEQUENCES BUTTON -----*/
On mouse-select-down of s_icn_Seqs in frame browse
   run Push_Obj_Button (INPUT {&OBJ_SEQ}, 
      	       	     	INPUT s_icn_Seqs:HANDLE in frame browse,
      	       	     	INPUT false).


/*----- SELECTION of FIELDS BUTTON -----*/
On mouse-select-down of s_icn_Flds in frame browse
   run Push_Obj_Button (INPUT {&OBJ_FLD}, 
      	       	     	INPUT s_icn_Flds:HANDLE in frame browse,
      	       	     	INPUT false).


/*----- SELECTION of INDEX BUTTON -----*/
On mouse-select-down of s_icn_Idxs in frame browse
   run Push_Obj_Button (INPUT {&OBJ_IDX}, 
      	       	     	INPUT s_icn_Idxs:HANDLE in frame browse,
      	       	     	INPUT false).



/*========================================================================
  	     	    Select List Selection-Change Events

   These VALUE-CHANGED events occurs if the user clicks on an item in a list,
   or when the code sets selection (e.g., after populating the box, after
   adding a new item or after deleting an item).

   For all below - Look for U1.  U1 is applied by combo box code.  We have to 
   get U1 of Fill to signal a value change in select list since value-changed 
   trigger on list widget can't apply U1 to list widget (itself) - the trigger 
   won't fire.  The opposite is also true - when selection changes due to 
   typing into fill-in we have to apply event to select list.  So U1 of either 
   fill or list means value changed and we have to look for both.
========================================================================*/


/*----- SELECTION of a DATABASE -----*/
on U1 of s_DbFill in frame browse, s_lst_Dbs in frame browse
   run adedict/_objsel.p (INPUT {&OBJ_DB}).


/*----- SELECTION of a TABLE -----*/
on U1 of s_TblFill in frame browse, s_lst_Tbls in frame browse
   run adedict/_objsel.p (INPUT {&OBJ_TBL}).


/*----- SELECTION of a SEQUENCE -----*/
on U1 of s_lst_Seqs in frame browse, s_SeqFill in frame browse
   run adedict/_objsel.p (INPUT {&OBJ_SEQ}).


/*----- SELECTION of a FIELD -----*/
on U1 of s_lst_Flds in frame browse, s_FldFill in frame browse
   run adedict/_objsel.p (INPUT {&OBJ_FLD}).


/*----- SELECTION of an INDEX -----*/
on U1 of s_lst_Idxs in frame browse, s_IdxFill in frame browse
   run adedict/_objsel.p (INPUT {&OBJ_IDX}).


/*=======================================================================
      	       	     	Double-Click in a Select List

   Note: When the user double clicks we get a single click (selection) 
   event first.  So single click processing has already occurred by the
   time we get here.
=======================================================================*/

/*----- DBL-CLK of a DATABASE -----*/
on default-action of s_lst_Dbs in frame browse
   run Do_Dbl_Click (INPUT ({&OBJ_DB})).


/*----- DBL-CLK of a TABLE -----*/
on default-action of s_lst_Tbls in frame browse
   run Do_Dbl_Click (INPUT ({&OBJ_TBL})).


/*----- DBL-CLK of a SEQUENCE -----*/
on default-action of s_lst_Seqs in frame browse
   run Do_Dbl_Click (INPUT ({&OBJ_SEQ})).


/*----- DBL-CLK of a FIELD -----*/
on default-action of s_lst_Flds in frame browse
   run Do_Dbl_Click (INPUT ({&OBJ_FLD})).


/*----- DBL-CLK of an INDEX -----*/
on default-action of s_lst_Idxs in frame browse
   run Do_Dbl_Click (INPUT ({&OBJ_IDX})).


/*=======================================================================
     	    Selection of an Action Button (Create/Properties/Delete)
=======================================================================*/

/*----- SELECTION of CREATE BUTTON -----*/
on choose of s_btn_Create in frame browse
   run Choose_Create.


/*----- SELECTION of PROPERTIES BUTTON -----*/
on choose of s_btn_Props in frame browse
   run Choose_Properties.


/*----- SELECTION of DELETE BUTTON ----- */
On choose of s_btn_Delete in frame browse
   run adedict/_delete.p (INPUT s_CurrObj).

/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: brwvar.i

Description:   
   Include file which defines the user interface components in the browse
   window of the dictionary.
 
Arguments:
   {1} - this is either "new shared" or "shared".

Author: Laura Stern

Date Created: 01/28/92 
Date Modified: 11/27/96 kkelley - removed text under data dictionary icons

----------------------------------------------------------------------------*/

Define {1} frame browse.

/* Toggling icons for selecting which object type is current. */
Define button s_icn_Dbs  image  FILE "adeicon/db-u" tooltip "Databases".
Define button s_icn_Tbls image  FILE "adeicon/table-u" tooltip "Tables".
Define button s_icn_Seqs image  FILE "adeicon/seq-u" tooltip "Sequences".
Define button s_icn_Flds image  FILE "adeicon/flds-u" tooltip "Fields".
Define button s_icn_Idxs image  FILE "adeicon/index-u" tooltip "Indexes".

/* Label for each level of object to indicate what is being displayed. */
Define {1} var s_DbLbl2  as char NO-UNDO init " Databases".
Define {1} var s_Lvl1Lbl as char NO-UNDO.
Define {1} var s_Lvl2Lbl as char NO-UNDO.

/* Fill-in fields for searching through selection lists */
Define {1} var s_DbFill  as char NO-UNDO.
Define {1} var s_TblFill as char NO-UNDO.
Define {1} var s_SeqFill as char NO-UNDO.
Define {1} var s_FldFill as char NO-UNDO.
Define {1} var s_IdxFill as char NO-UNDO.

/* Selection Lists for the lists of database objects. The view-as and size
   specifications are in the form (in browse.f) so that all formatting is
   done in one place.
*/
Define {1} var s_lst_Dbs  as char NO-UNDO.
Define {1} var s_lst_Tbls as char NO-UNDO.
Define {1} var s_lst_Seqs as char NO-UNDO.
Define {1} var s_lst_Flds as char NO-UNDO.
Define {1} var s_lst_Idxs as char NO-UNDO.

/* Action buttons to perform Create, Modify and Delete operations. The
   labels on these will change depending on the current object.  So
   for example, it s_btn_Create might say "Create Table" or "Create Index".
*/
Define button s_btn_Create SIZE 24 by 1.125.
Define button s_btn_Props  SIZE 24 by 1.125.
Define button s_btn_Delete SIZE 24 by 1.125.

/* Status line variable */
Define {1} var s_Browse_Stat as char NO-UNDO.

/* Form definition for the browse and icon frames. - must be here,
   below all widget definitions. */
{adedict/browse.f}







/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------
File: capab.i

Description:   
   Definitions related to capabilities for various gateways.
 
Author: Laura Stern

Date Created: 06/05/92 
hutegger    94/01/27    added CAPAB_SEQ and CAPAB_MODIFY
----------------------------------------------------------------------------*/

/* Capability categories */
&global-define 	  CAPAB_TBL   	    1
&global-define 	  CAPAB_FLD   	    2
&global-define 	  CAPAB_IDX   	    3
&global-define 	  CAPAB_IDXMAX      4
&global-define 	  CAPAB_SEQ   	    5

/* Capabilities within the categories */
&global-define CAPAB_ADD     	      "a"  /* can add */

&global-define CAPAB_RENAME           "r"  /* can rename */
&global-define CAPAB_FOR_NAME         "n"  /* has foreign name */
&global-define CAPAB_CHANGE_FOR_NAME  "f"  /* can change foreign name */
&global-define CAPAB_OWNER            "o"  /* has owner name */  
&global-define CAPAB_TBL_NUMBER       "#"  /* has table number */
&global-define CAPAB_TBL_SIZE	      "s"  /* has table size */
&global-define CAPAB_CHANGE_TBL_SIZE  "z"  /* can change table size */
&global-define CAPAB_TBL_TYPE_ADD     "t"  /* can set table type on add */
&global-define CAPAB_TBL_TYPE_MOD     "m"  /* can change table type */

&global-define CAPAB_COPY	      "c"  /* can copy fields */
&global-define CAPAB_CHANGE_DATA_TYPE "t"  /* can change data type */
&global-define CAPAB_CHANGE_EXTENT    "e"  /* can change extent 
      	       	     	      	       	      (if not in index) */
&global-define CAPAB_OFFLEN_REQ       "l"  /* offset & length required */
&global-define CAPAB_DECIMALS_REQ     "d"  /* decimals required */
&global-define CAPAB_CHAR_LEN_IN_DEC  "s"  /* store character length in 
      	       	     	      	       	      _Decimals field */
&global-define CAPAB_CHANGE_MANDATORY "m"  /* can change mandatory */
&global-define CAPAB_CHANGE_CASE_SENS "v"  /* can change case sensitivity */

&global-define CAPAB_DELETE  	      "d"  /* can delete */
&global-define CAPAB_INACTIVATE       "i"  /* can inactivate index */
&global-define CAPAB_CHANGE_PRIMARY   "p"  /* can change primary index */
&global-define CAPAB_WORD_INDEX       "w"  /* word index allowed */
&global-define CAPAB_FIELD_COMP       "f"  /* index has field components 
      	       	     	      	       	      (not pos/offset components) */
&global-define CAPAB_CHANGE_UNIQ      "u"  /* can change uniqueness */
&global-define CAPAB_GATE_IDXNUM      "#"  /* call gateway specific routine 
      	       	     	      	       	      to get index # */
&global-define CAPAB_MODIFY           "m"  /* can modify anything beyond name */
&global-define CAPAB_SEQ_SUPPORTED    "s"  /* seq sup. on that DataServer */


/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: delwin.i

Description:
   Close the given property window.
 
Argument
   &Win - handle of window to close.
   &Obj - the object # for this object

Author: Laura Stern

Date Created: 05/13/92 

----------------------------------------------------------------------------*/

if {&Win} <> ? then
do:
   assign
      s_x_Win[{&Obj}] = {&Win}:x
      s_y_Win[{&Obj}] = {&Win}:y.
   
   delete widget {&Win}.
   {&Win} = ?.
end.

/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/


/* dictghlp.i */


/* This include file defines the help context strings that 
   PROGRESS tools use to display help topics from the 
   DICTxxx.HLP file. 
   
   Please contact Documentation to make changes to this file. 
   Thanks. 
*/

/*
   The form used in this file is:

	   <Name of the Help Topic>
	   &Global-define <context-string> <context-number>


   NOTE: Context strings are listed in the approximate order they
   appear on the Dictionary Menubar

   This file replaces gdict.i.

*/

/* Editor Help Contents screen */
&Global-define Main_Index 49153

/* Data Dictionary Window  */
&Global-define Data_Dictionary_Window 49154

/* Startup Options Dialog Box */
&Global-define Startup_Options_Dlg_Box 49155

/* Detailed Table Report Dialog Box
   Quick Table Report Dialog Box
   Quick Field Report Dialog Box
   Quick Index Report Dialog Box
   View Report Dialog Box
   Sequence Report Dialog Box
   User Report Dialog Box
   Table Relations Report Dialog Box
   Storage Areas Report Dialog Box*/
/* Common dialog called from adecomm */

/* Report Options Dialog Box */
/* Common dialog called from adecomm */

/* Print Options Dialog Box  */
/* Common dialog called from adecomm */

/* Create Database Dialog Box  */
/* Common dialog called from adecomm */

/* Create Table Dialog Box  */
&Global-define Create_Table_Dlg_Box 49157

/* Create Sequence Dialog Box  */
&Global-define Create_Sequence_Dlg_Box 49158

/* Create Field for Table Dialog Box  */
&Global-define Create_Field_Dlg_Box 49159

/* Format Examples for Data Type Dialog Box */
&Global-define Format_Examples_Dlg_Box 49160

/* Create Index for Table Dialog Box */
&Global-define Create_Index_Dlg_Box 49161

/* Table Triggers Dialog Box */
&Global-define Table_Triggers_Dlg_Box 49162

/* Table Validation Dialog Box */
&Global-define Table_Validation_Dlg_Box 49163

/* Field Triggers Dialog Box */
&Global-define Field_Triggers_Dlg_Box 49164

/* Field Validation Dialog Box */
&Global-define Field_Validation_Dlg_Box 49165

/* MOVED TO COMMENG */
/* View-as Phrase Dialog Box */
/* &Global-define View_as_Phrase_Dlg_Box 49166 */

/* Copy Fields Dialog Box */
&Global-define Copy_Fields_Dlg_Box 49167

/* Rename Field Dialog Box */
&Global-define Rename_Field_Dlg_Box 49168

/* Globally Rename Fields Dialog Box */
&Global-define Globally_Rename_Fields_Dlg_Box 49169

/* Renumber Order Numbers Dialog Box */
&Global-define Renumber_Order_Numbers_Dlg_Box 49170

/* Database Properties Window */
&Global-define Database_Properties_Window 49171

/* Table Properties Window */
&Global-define Table_Properties_Window 49172

/* ROWID-Index Dialog Box */
&Global-define RowID_Idx_Dlg_Box 49240

/* ROWID-Index Detail Dialog Box */
&Global-define RowID_Idx_Dtl_Dlg_Box 49241

/* Field Properties Window */
&Global-define Field_Properties_Window 49173

/* Sequence Properties Window */
&Global-define Sequence_Properties_Window 49174

/* Index Properties Window */
&Global-define Index_Properties_Window 49175

/* Old topic replaced by Specific Fields dialog boxes */
/* Gateways Dialog Box */
&Global-define Gateways_Dlg_Box 49176

/* Menu Commands Help Screen */
&Global-define Menu_Commands 49177

/* Table String Attributes dialog box */
&Global-define Table_String_Attributes_Dlg_Box 49178

/* Specific Fields dialog box */
&Global-define AS400_Specific_Flds__Dlg_Box 49179

/* Specific Fields dialog box */
&Global-define CISAM_Specific_Flds__Dlg_Box 49180

/* Specific Fields dialog box */
&Global-define ODBC_Specific_Flds_Dlg_Box 49181

/* Specific Fields dialog box */
&Global-define ORACLE_Specific_Flds__Dlg_Box 49182

/* Specific Fields dialog box */
&Global-define SYBASE_Specific_Flds_Dlg_Box 49183

/* Help->How To help topic */
&Global-define How_To 49184

/* SQL Width Browse screen help */
&Global-define Adjust_Field_Width_Dialog_Box 1

/* Specific Fields dialog box */
&Global-define MSS_Specific_Flds_Dlg_Box 20 

/* Blob Fields dialog box */
&Global-define Blob_Field_Att_Dlg_Box 19 

/* Clob Fields dialog box */
&Global-define Clob_Field_Att_Dlg_Box 26 

/*********************************************************************
* Copyright (C) 2006,2008-2009 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------
File: dictvar.i
OB
Description:   
   This include file contains the definition of miscellaneous shared
   dictionary variables.
 
Arguments:
   {1} - this is either "new shared" or "shared".

Author: Laura Stern
Date Created: 01/28/92

History:
       12/28/98 Mario B.  Add s_In_Schema_Area enabling one time notification.
       05/19/99 Mario B.  Adjust Width Field browser integration.     
       04/23/02 Donna M.  Added new table recid variable
       03/14/06 fernando  Handle case with too many tables selected - bug 20050930-006.
       06/12/06 fernando  support for int64
       09/21/06 fernando  menu report - gray it if no db connected
       06/26/08 fernando  Adding INVALID_AREAS pre-processor
       04/07/09 fernando  Increasing NUM_GRAY_ITEMS for enc reports
----------------------------------------------------------------------------*/
{adecomm/adestds.i}  

/* Help context defines and the name of the help file */
{adedict/dictghlp.i}


/* We have a cache for Db info since we can't necessarily get any info
   about foreign databases unless they're connected - which they don't
   have to be.  The browse window db select list acts as the cache for
   the logical names.
*/
Define {1} var s_DbCache_ix     as integer           NO-UNDO init 0.
Define {1} var s_DbCache_Cnt    as integer    	     NO-UNDO init 0.
Define {1} var s_DbCache_Pname  as char    extent 50 NO-UNDO.
Define {1} var s_DbCache_Holder as char    extent 50 NO-UNDO.
Define {1} var s_DbCache_Type   as char    extent 50 NO-UNDO.

/* These are the current database, table, domain, sequence, field and index
   based upon the user's selection in the browse window.
*/
Define {1} var s_CurrDb   as char init "" NO-UNDO.
Define {1} var s_CurrTbl  as char init "" NO-UNDO.
Define {1} var s_CurrDom  as char init "" NO-UNDO.
Define {1} var s_CurrSeq  as char init "" NO-UNDO.
Define {1} var s_CurrFld  as char init "" NO-UNDO.
Define {1} var s_CurrIdx  as char init "" NO-UNDO.


/* s_TblRecId is the table record Id for the currently selected table.
   s_DomRecId is the record Id that domains are associated with for a given
   database and DbRecId is the recid of the _DB record for the current
   database.
*/
Define {1} var s_DbRecId   as recid    NO-UNDO.       
Define {1} var s_TblRecId  as recid    NO-UNDO.
Define {1} var s_DomRecId  as recid    NO-UNDO.
DEFINE {1} VAR n_tblRecid  AS RECID    NO-UNDO.

/* These come in handy for a bunch of things. */
&global-define    OBJ_NONE    0
&global-define    OBJ_TBL     1
&global-define    OBJ_DOM     2
&global-define    OBJ_SEQ     3
&global-define    OBJ_FLD     4
&global-define    OBJ_IDX     5
&global-define    OBJ_DB      6
&global-define    OBJ_WIDTH   7

/* These are the different "states" the dictionary can be in which are
   essentially based on what the current selection is.  They are used for
   menu graying and browse window adjustments.
   Note that each state is a step up from the previous one.
   
   NO_DB_SELECTED    - No database is selected (there are none connected)
   NO_OBJ_SELECTED   - The current database is accessible, but the user hasn't
      	       	       selected any object (tbl,dom,seq,fld,idx) yet.
      	       	       NOTE: with the current UI, this state is only temporary
      	       	       since we always select table by default once a database
      	       	       is selected.
   OBJ_SELECTED	     - The current database is accessible and there is 
      	       	       a selected object. 

   This state is special in that it doesn't participate in this state
   hierarchy.

   DONE	       	     - We are about to exit the dictionary so we're in
      	       	       a cleanup state.
*/
Define {1} var s_DictState as integer NO-UNDO.

&global-define NUM_STATES     	       4
&global-define STATE_DONE     	       0
&global-define STATE_NO_DB_SELECTED    1
&global-define STATE_NO_OBJ_SELECTED   2
&global-define STATE_OBJ_SELECTED      3

/* Gray_Items:
   This is a list of widget handles for all menu items and icon widgets
   that need graying. 
*/
&global-define  NUM_GRAY_ITEMS   37
Define {1} var Gray_Items  as widget-handle extent {&NUM_GRAY_ITEMS}  NO-UNDO.


/* This variable indicates which component at the 1st level of hierarchy 
   (TBL, SEQ) and which component at the 2nd level of hierarchy
   (FLD, IDX) is currently active, so when user does "new" we know what
   function to perform.
*/
Define {1} var s_Lvl1Obj as integer init {&OBJ_NONE} NO-UNDO.
Define {1} var s_Lvl2Obj as integer init {&OBJ_NONE} NO-UNDO.


/* CurrObj indicates what type of object is currently being added 
   or set up in one of the edit windows.  It is not always used -
   only when there is code shared between object types and we need to
   know which one we're working on right now.  This happens with fields
   and domains, and with field and table triggers, for example.
   s_Adding is true if we're adding vs. editing the object.
*/
Define {1} var s_CurrObj as integer NO-UNDO.
Define {1} var s_Adding as logical NO-UNDO.


/* This will be the name of the procedure to run to execute the
   current command. */
Define {1} var s_ActionProc as char format "x(10)" init ""  NO-UNDO.

/* s-Trans indicates what transaction action to take.
   NONE	       	  - The base state - no transaction request has been made.
   COMMIT         - Can be requested from the menu.
   UNDO           - Can be requested from the menu.
   ASK_AND_DO  	  - ask the user: commit/undo or continue.  If the user
      	            chooses commit or undo, perform some action (e.g.,
      	       	    switch databases, or disconnect a database)
   ASK_AND_EXIT   - ask the user: commit/abort or continue.  If the user
      	            chooses commit or abort, exit the dictionary.
   DONE	       	  - Used internally to control the transaction loop.
*/
&global-define 	  TRANS_NONE  	       0
&global-define 	  TRANS_COMMIT         1
&global-define 	  TRANS_UNDO           2
&global-define 	  TRANS_ASK_AND_DO     3
&global-define 	  TRANS_ASK_AND_EXIT   4
&global-define    TRANS_DONE  	       5

Define {1} var s_Trans as integer init 1 NO-UNDO.


/* ism_typ.p calls _ism_udt.p which needs drec_id to be defined
 * drec_db is the TTY-AdminTool equivalent to s_DbRecId in the GUI-Dict
 */
Define {1} var drec_db     as recid    NO-UNDO.       

/* dictg.p also includes prodict/user/uservar.i, which defines user_env,
 * so we shouldn't redefine it here
 */
&IF "{&DICTG}"  <> "dictg"
&THEN

/* user_env is Used to get gateway data type and default info.  Each array
   entry is filled with a comma separated list. There is one extra element
   in each (i.e., there's an extra comma on the end of each that shouldn't
   be there) so make sure to account for it.   user_env must be defined as
   it is in prodict/user/uservar.i (old dictionary).  s_Gate_Typ_Proc is set
   to the name of the .p (prodict/xxx/xxx_typ.p) that sets this info.

      user_env[11] - list of progress types that map to gateway types
      user_env[12] - list of gateway types (strings)
      user_env[13] - list of gateway type codes (_Fld-stdtype).
      user_env[14] - list of _Fld-stlen values for each data type (this is
      	       	     the storage length)
      user_env[15] - the long form of the gateway type (string), i.e., the
      	       	     type description.
      user_env[16] - the gateway type family - to indicate what data types
      	       	     can be modified to what other data types.
*/
Define {1} var user_env        as char  extent 35 NO-UNDO.

/* for bug fix 20050930-006 */
DEFINE {1} VARIABLE user_longchar         AS LONGCHAR NO-UNDO.

&ENDIF
Define {1} var s_Gate_Typ_Proc as char            NO-UNDO. 

/* These indicate whether each list box in the browse window (for tables,
   domains, etc.) already contain the correct info.  'yes' means that the
   data is already in there and the widget just needs to be made visible.
   'no' means we haven't filled the list yet for the current database.
*/
Define {1} var s_Tbls_Cached as logical init false NO-UNDO.
Define {1} var s_Doms_Cached as logical init false NO-UNDO.
Define {1} var s_Seqs_Cached as logical init false NO-UNDO.
Define {1} var s_Flds_Cached as logical init false NO-UNDO.
Define {1} var s_Idxs_Cached as logical init false NO-UNDO.


/* These are the handles for the non-modal dictionary windows */
Define {1} var s_win_Browse as widget-handle NO-UNDO.
Define {1} var s_win_Db     as widget-handle NO-UNDO.
Define {1} var s_win_Tbl    as widget-handle NO-UNDO.
Define {1} var s_win_Seq    as widget-handle NO-UNDO.
Define {1} var s_win_Fld    as widget-handle NO-UNDO.
Define {1} var s_win_Dom    as widget-handle NO-UNDO.
Define {1} var s_win_Idx    as widget-handle NO-UNDO.
Define {1} var s_win_Logo   as widget-handle NO-UNDO.
Define {1} var s_win_Width  as widget-handle NO-UNDO.

/* To remember where each window was when it was closed, so it
   can reopen in the same place.
*/
Define {1} var s_x_Win as integer extent 7 NO-UNDO init ?.
Define {1} var s_y_Win as integer extent 7 NO-UNDO init ?.


/* s_DictDirty is true if the dictionary is dirty.  This means that at least
   1 undo-able/commit-able action has been executed.
*/
Define {1} var s_DictDirty as logical NO-UNDO.


/* Read only flags - ReadOnly will be true if dictionary was entered
   while in a transaction or if the user is running certain versions of
   Progress, such as RUN-ONLY Progress.  DB_ReadOnly will be true if 
   the user chose a read-only database.  xxx_ReadOnly will take both of
   these into account and may add other qualifications (like frozen for
   tables or privileges) to indicate if the object being viewed is editable
   or not.
*/
Define {1} var s_ReadOnly     as logical NO-UNDO.
Define {1} var s_DB_ReadOnly  as logical NO-UNDO.
Define {1} var s_Tbl_ReadOnly as logical NO-UNDO.
Define {1} var s_Dom_ReadOnly as logical NO-UNDO.
Define {1} var s_Seq_ReadOnly as logical NO-UNDO.
Define {1} var s_Fld_ReadOnly as logical NO-UNDO.
Define {1} var s_Idx_ReadOnly as logical NO-UNDO.


/* This is a comma separated list of old (V5/V6) databases that we've 
   come across because they're connected but we haven't added to the 
   db list because this dictionary can't work with them.  We only want
   to make note of them to the user once.  This list keeps track of
   them so that every time we connect, we don't re-notice them and
   re-tell the user about how they can't use these databases.
*/
Define {1} var s_OldDbs as char NO-UNDO init "".


/* Miscellaneous flags and their values. Auto_Connect is turned on when
   the user creates a new database, so we know to bring up the connect
   box after the database switch happens. DbLst_Focus remember if the
   Db list has focus (instead of Db fill-in) when we switch databases.
   ask_gateconn indicates if we should ask about connecting when
   switching to a gateway database - e.g, so we don't ask if the user 
   wants to connect after just disconnecting.
*/
&global-define ORDER_ALPHA    1
&global-define ORDER_ORDER#   2
Define {1} var s_Order_By     	  as integer init {&ORDER_ORDER#} NO-UNDO.

Define {1} var s_Show_Hidden_Tbls as logical init no  	          NO-UNDO.
Define {1} var s_Auto_Connect     as logical init no  	          NO-UNDO.
Define {1} var s_Dblst_Focus      as logical init no              NO-UNDO.
Define {1} var s_ask_gateconn     as logical init yes             NO-UNDO.

/* This is used for method calls for the result status to be returned in. */
Define {1} var s_Res as logical NO-UNDO.

/* Miscellaneous constants */

/* This is stored in the _File._Db-Lang field.  0 means it is not SQL */
&global-define 	  TBLTYP_SQL  1

/* List of areas that should not be available to the user */
&GLOBAL-DEFINE INVALID_AREAS "Encryption Policy Area":U

/* List of schema tables to be filtered out */
&GLOBAL-DEFINE INVALID_SCHEMA_TABLES "_sec-db-policy,_sec-obj-policy,_sec-pwd-policy":U

/* This variable controls the warning given to the user to indicate they
   are adding tables or indices to the schema area.  We only want to give
   the warning once per session
*/
Define {1} var s_In_Schema_Area as logical init no NO-UNDO.

/* set when a pre-101b db, so we don't allow 10.1B stuff */
DEFINE {1} VARIABLE is-pre-101b-db   AS LOGICAL               NO-UNDO.

/* to indicate if large sequence support is on or not */
DEFINE {1} VAR s_Large_Seq AS LOGICAL NO-UNDO INIT ?.
/*********************************************************************
* Copyright (C) 2006 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: edittrig.i

Description:
   Here we have all the trigger definitions for the edit (properties)
   windows.
 
Author: Laura Stern

Date Created: 02/04/92 
     History: 06/29/98 D. McMann Added _owner to finds and for each for _files
              11/16/98 Mario B. Added trigger on _Order to trap duplicate entry.
	                        Made leave trigger fire on GO of fldprops.
              05/19/99 Mario B.  Adjust Width Field browser integration.
	      06/17/99 Mario B. Fixed running of brwgray.p in field prop trigs.
	      09/02/99 Mario B. 199909092-025 Long dumpname error on create.  
          01/10/00 D. McMann 19990511008 Added forceval.i on GO trigger in
                             table properties.
          05/24/2005 Added GO trigger and changed choose trigger to s_btn_cancel in dbprops
          06/08/2006 fernando Added trigger for s_btn_toint64 - support for int64
	      
----------------------------------------------------------------------------*/

/*======================Triggers for Browse Window===========================*/

/*----- HELP anywhere -----*/
on HELP anywhere
   RUN "adecomm/_adehelp.p" ("dict", "TOPICS", {&Data_Dictionary_Window}, ?).


/*====================Triggers for Database Properties=======================*/

/*----- END-ERROR or OK BUTTON in DBPROPS FRAME -----*/
on END-ERROR of frame dbprops OR choose of s_btn_cancel in frame dbprops
do:
   {adedict/delwin.i &Win = s_win_Db &Obj = {&OBJ_DB}}
   return NO-APPLY.  /* don't really do end-key processing */
end.

/*----- HELP in DBPROPS FRAME -----*/
on HELP of frame dbprops OR choose of s_btn_Help in frame dbprops
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", 
      	       	     	     {&Database_Properties_Window}, ?).

/*----- HIT of OK BUTTON or GO -----*/
on GO of frame dbprops
do:
    
   /* if the fields are not sensitive for input, user can't update anything, so we can skip the call
      to _savdbprop.p (it has a reference to _db-detail, and the table may not exist, so avoid calling
      it if we know there is nothing to be updated).
   */
   IF s_Db_Description:sensitive in frame dbprops THEN DO:
       run adedict/DB/_savdbprop.p.
       if RETURN-VALUE = "error" then
          return NO-APPLY.
   END.

  {adedict/delwin.i &Win = s_win_Db &Obj = {&OBJ_DB}}
   RUN adedict/_brwgray.p (INPUT NO).  /* For Adjust Width Browser graying */   
end.

/*======================Triggers for Table Properties=======================*/

/*----- END-ERROR OR CLOSE BUTTON of TBLPROPS FRAME -----*/
on END-ERROR of frame tblprops OR choose of s_btn_Close in frame tblprops
do:
   {adedict/delwin.i &Win = s_win_Tbl &Obj = {&OBJ_TBL}}
   RUN adedict/_brwgray.p (INPUT NO).  /* For Adjust Width Browser graying */   
   return NO-APPLY.  /* otherwise it will undo everything! */
end.

/*----- HIT of SAVE BUTTON -----*/
on choose of s_btn_Save in frame tblprops
do:
   {adedict/forceval.i}  /* force leave trigger to fire */
   run adedict/TBL/_savetbl.p.
   IF (RETURN-VALUE <> "error" AND
       s_btn_Close:label in frame tblprops <> "Close") then
      s_btn_Close:label in frame tblprops = "Close".
end.


/*----- HIT of OK BUTTON or GO -----*/
on GO of frame tblprops
do:
   {adedict/forceval.i}
   run adedict/TBL/_savetbl.p.
   if RETURN-VALUE = "error" then
      return NO-APPLY.

   {adedict/delwin.i &Win = s_win_Tbl &Obj = {&OBJ_TBL}}
   RUN adedict/_brwgray.p (INPUT NO).  /* For Adjust Width Browser graying */   
end.


/*----- HIT of NEXT button -----*/
on choose of s_btn_Next in frame tblprops
do:
   {adedict/forceval.i}  /* force leave trigger to fire */
   run adedict/_nextobj.p ({&OBJ_TBL}, true).
end.


/*----- HIT of PREV button -----*/
on choose of s_btn_Prev in frame tblprops
do:
   {adedict/forceval.i}  /* force leave trigger to fire */
   run adedict/_nextobj.p ({&OBJ_TBL}, false).
end.


/*----- LEAVE of SAVE BUTTON -----*/
on leave of s_btn_Save in frame tblprops
   /* Since status is displayed only after save is hit */
   display "" @ s_Status with frame tblprops. /* clear status line */


/*----- HELP in TBLPROPS FRAME -----*/
on HELP of frame tblprops OR choose of s_btn_Help in frame tblprops 
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Table_Properties_Window}, ?).


/*----- LEAVE of NAME FIELD -----*/
on leave of b_File._File-Name 	 in frame newtbl,
            b_File._File-Name 	 in frame tblprops
do:

   Define var okay  as logical NO-UNDO.
   Define var name  as char    NO-UNDO.
   Define var dname as char    NO-UNDO.

   if s_Adding then
      display "" @ s_Status with frame newtbl.  /* clear status after add */

   run adedict/_leavnam.p (INPUT b_File._File-Name, INPUT s_win_Tbl,
      	       	     	   OUTPUT name, OUTPUT okay).

   if okay = ? then return.
   if NOT okay then do:
      s_Valid = no.
      return NO-APPLY.
   end.

   /* Make sure there isn't already an object with this name.  Since there is
      a unique index on Name/recid in _File, this would be caught by Progress
      eventually.  But let's check ourselves to give quicker feedback and to
      be consistent with the old dictionary.
   */
   if can-find (_File where _File._Db-recid = s_DbRecId 
                        and _File._File-Name = name
                       and (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN"))
    then do:
      message "A table with this name already exists in this database."
      	 view-as ALERT-BOX ERROR
      	 buttons OK.
      ASSIGN s_Valid  = no
             s_OK_Hit = no.
      return NO-APPLY.
   end.

   /* Name is ok.  For Add, default the dump-name if it has no value yet. */
   if s_Adding then 
   do:   
      dname = input frame newtbl b_File._Dump-name.

      if dname = "" OR dname = ? then
      	 b_File._Dump-name:screen-value in frame newtbl = LC(name). /* lower case */
	 ASSIGN s_Valid = TRUE.
      	 apply "leave" to b_File._Dump-name in frame newtbl.
	 IF NOT s_Valid THEN
	 DO:
            APPLY "ENTRY" TO b_File._Dump-name in frame newtbl.
	    RETURN NO-APPLY.    
         END.	    
	 ELSE ASSIGN s_Valid = FALSE.
   end.
end.


/*----- LEAVE of DUMP NAME -----*/
on leave of b_File._Dump-name in frame newtbl,
      	    b_File._Dump-name in frame tblprops
do:
   Define var dname as char NO-UNDO.
   Define var name  as char NO-UNDO.

   dname = TRIM(SELF:screen-value).

   /* If we're editing and name hasn't changed, then it's OK */
   if NOT s_Adding AND dname = b_File._Dump-name then
      return.

   if (dname = "?" OR dname = "") then
   do:
      /* Default to the name of the file, lower-cased if there is one. */
      if s_Adding then
      	 name = LC(input frame newtbl b_File._File-Name).
      else
      	 name = LC(input frame tblprops b_File._File-Name).

      if name = "" OR name = ? then return.
      
      SELF:screen-value = name.
      dname = name.
   end.

   /* make sure name doesn't have space characters */
   IF INDEX(dname, " ") > 0 THEN DO:
      MESSAGE "Invalid character in Dump Name" VIEW-AS ALERT-BOX ERROR.
	  s_Valid = no.
	  RETURN NO-APPLY.
   END.

   /* Make sure the name is unique. */
   find first _File
      where _File._Db-recid = s_DbRecId
        AND _File._Dump-name = dname 
        AND RECID(_File) <> RECID(b_File)
        AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
      NO-ERROR.
   if AVAILABLE _File then
   do:
      if NOT s_Adding then current-window = s_win_Tbl.
      message "This dump name is not unique within this database." 
      	 view-as ALERT-BOX ERROR
      	 buttons OK.
      s_Valid = no.
      return NO-APPLY. 
   end.
end.


/*----- LEAVE of RECORD SIZE (_For-Size) -----*/
on leave of b_File._For-size in frame newtbl,
      	    b_File._For-size in frame tblprops
do:
   Define var recsize as integer NO-UNDO.

   recsize = INTEGER (SELF:screen-value).
   if recsize = ? OR recsize = 0 then
   do:
      if NOT s_Adding then current-window = s_win_Tbl.
      message "Record Size must be a positive integer."
      	 view-as ALERT-BOX ERROR
      	 buttons OK.
      s_Valid = no.
      return NO-APPLY.
   end.
end.


/*----- LEAVE of GATEWAY NAME (_For-name) -----*/
on leave of b_File._For-name in frame newtbl,
      	    b_File._For-name in frame tblprops
do:
   Define var gname as char NO-UNDO.

   gname = TRIM(SELF:screen-value).
   if gname = "?" OR gname = "" then
   do:
      if NOT s_Adding then current-window = s_win_Tbl.
      message "Data Server name is required."
      	 view-as ALERT-BOX ERROR buttons OK.
      s_Valid = no.
      return NO-APPLY.
   end.
end.


/*----- HIT of DATASERVER BUTTON -----*/ /**/
on choose of s_btn_Tbl_ds in frame tblprops
do:
   Define var widg    as widget-handle NO-UNDO.
   Define var no_name as logical       NO-UNDO.

   {adedict/forceval.i}  /* force leave trigger to fire */

   if s_Adding then
      /* Add is modal - current-window is already set */
      widg = b_File._File-name:HANDLE in frame newtbl.
   else do:
      widg = b_File._File-name:HANDLE in frame tblprops.
      current-window = s_win_Tbl.
   end.

   run adedict/_blnknam.p
      (INPUT widg, INPUT "table", OUTPUT no_name).
   if no_name then return NO-APPLY.

   RUN prodict/gate/_gat_row.p
     ( INPUT s_DbCache_Type[s_DbCache_ix],
       INPUT RECID(b_File)
     ).
   IF (NOT s_Adding AND RETURN-VALUE = "mod" AND
       s_btn_Close:label in frame tblprops <> "Close") then
      s_btn_Close:label in frame tblprops = "Close".
end.
/**/

/*----- HIT of VALIDATION BUTTON -----*/
on choose of s_btn_Tbl_Validation in frame newtbl,
      	     s_btn_Tbl_Validation in frame tblprops
do:
   Define var widg    as widget-handle NO-UNDO.
   Define var no_name as logical       NO-UNDO.

   {adedict/forceval.i}  /* force leave trigger to fire */

   if s_Adding then
      /* Add is modal - current-window is already set */
      widg = b_File._File-name:HANDLE in frame newtbl.
   else do:
      widg = b_File._File-name:HANDLE in frame tblprops.
      current-window = s_win_Tbl.
   end.

   run adedict/_blnknam.p
      (INPUT widg, INPUT "table", OUTPUT no_name).
   if no_name then return NO-APPLY.

   run adedict/TBL/_tblval.p.
   IF (NOT s_Adding AND RETURN-VALUE = "mod" AND
       s_btn_Close:label in frame tblprops <> "Close") then
      s_btn_Close:label in frame tblprops = "Close".
end.


/*----- HIT of TRIGGERS BUTTON -----*/
on choose of s_btn_Tbl_Triggers in frame newtbl,
      	     s_btn_Tbl_Triggers in frame tblprops
do:
   Define var widg    as widget-handle NO-UNDO.
   Define var no_name as logical       NO-UNDO.
   Define var junk    as logical       NO-UNDO.

   {adedict/forceval.i}  /* force leave trigger to fire */

   if s_Adding then
      /* Add is modal - current-window is already set */
      widg = b_File._File-name:HANDLE in frame newtbl.
   else do:
      widg = b_File._File-name:HANDLE in frame tblprops.
      current-window = s_win_Tbl.
   end.

   /* Check if name is blank and return if it is */
   run adedict/_blnknam.p
      (INPUT widg, INPUT "table", OUTPUT no_name).
   if no_name then return NO-APPLY.

   
   run adedict/TRIG/_trigdlg.p (INPUT {&OBJ_TBL}, 
			       INPUT
"CREATE,DELETE,FIND,WRITE,REPLICATION-CREATE,REPLICATION-DELETE,REPLICATION-WRITE",
      	       	     	       INPUT widg,
      	       	     	       INPUT {&Table_Triggers_Dlg_Box}).
   IF (NOT s_Adding AND RETURN-VALUE = "mod" AND
       s_btn_Close:label in frame tblprops <> "Close") then
      s_btn_Close:label in frame tblprops = "Close".
end.


/*----- HIT of STRING ATTRIBUTES BUTTON -----*/
on choose of s_btn_Tbl_StringAttrs in frame newtbl,
      	     s_btn_Tbl_StringAttrs in frame tblprops
do:
   Define var widg    as widget-handle NO-UNDO.
   Define var no_name as logical       NO-UNDO.

   {adedict/forceval.i}  /* force leave trigger to fire */

   if s_Adding then
      /* Add is modal - current-window is already set */
      widg = b_File._File-name:HANDLE in frame newtbl.
   else do:
      widg = b_File._File-name:HANDLE in frame tblprops.
      current-window = s_win_Tbl.
   end.

   run adedict/_blnknam.p
      (INPUT widg, INPUT "table", OUTPUT no_name).
   if no_name then return NO-APPLY.

   run adedict/TBL/_tblsas.p.
   IF (NOT s_Adding AND RETURN-VALUE = "mod" AND
       s_btn_Close:label in frame tblprops <> "Close") then
      s_btn_Close:label in frame tblprops = "Close".
end.


/*==================Triggers for Field/Domain Properties======================*/

/*----- END-ERROR OR CLOSE BUTTON of FLDPROPS FRAME -----*/
on END-ERROR of frame fldprops OR choose of s_btn_Close in frame fldprops
do:
   {adedict/delwin.i &Win = s_win_Fld &Obj = {&OBJ_FLD}}
   RUN adedict/_brwgray.p (INPUT NO).  /* For Adjust Width Browser graying */
   return NO-APPLY.  /* otherwise it will undo everything! */
end.

/*----- HIT of SAVE BUTTON -----*/
on choose of s_btn_Save in frame fldprops
do:
   {adedict/forceval.i}  /* force leave trigger to fire */
   run adedict/FLD/_savefld.p.
   IF (RETURN-VALUE <> "error" AND
       s_btn_Close:label in frame fldprops <> "Close") then
      s_btn_Close:label in frame fldprops = "Close".
end.


/*----- HIT of OK BUTTON or GO -----*/
on GO of frame fldprops
do:
   {adedict/forceval.i}  /* force leave trigger to fire */
   run adedict/FLD/_savefld.p.
   if RETURN-VALUE = "error" then
      return NO-APPLY.
   {adedict/delwin.i &Win = s_win_Fld &Obj = {&OBJ_FLD}}
   run adedict/_brwgray.p (INPUT NO).  /* For Adjust Width Browser graying */
end.


/*----- HIT of NEXT button -----*/
on choose of s_btn_Next in frame fldprops
do:
   {adedict/forceval.i}  /* force leave trigger to fire */
   run adedict/_nextobj.p ({&OBJ_FLD}, true).
end.


/*----- HIT of PREV button -----*/
on choose of s_btn_Prev in frame fldprops
do:
   {adedict/forceval.i}  /* force leave trigger to fire */
   run adedict/_nextobj.p ({&OBJ_FLD}, false).
end.


/*----- LEAVE of FIELD SAVE BUTTON -----*/
on leave of s_btn_Save in frame fldprops
   display "" @ s_Status with frame fldprops. /* clear status line */


/*----- HELP in FLDPROPS FRAME -----*/
on HELP of frame fldprops OR choose of s_btn_Help in frame fldprops 
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Field_Properties_Window}, ?).


/*----- HIT of VALIDATION BUTTON (newfld/fldprops)-----*/
on choose of s_btn_Fld_Validation in frame newfld,
      	     s_btn_Fld_Validation in frame fldprops
do:
   Define var widg     as widget-handle NO-UNDO.
   Define var no_name  as logical       NO-UNDO.
   Define var readonly as logical       NO-UNDO.

   {adedict/forceval.i}  /* force leave trigger to fire */

   IF s_Fld_DType:SCREEN-VALUE IN FRAME newfld = "BLOB" OR 
      s_Fld_DType:SCREEN-VALUE IN FRAME newfld = "CLOB" OR 
      s_Fld_DType:SCREEN-VALUE IN FRAME newfld = "XLOB" THEN 
     RETURN NO-APPLY.
  

   if s_Adding then
      /* Add is modal - current-window is already set */
      widg = b_Field._Field-name:HANDLE in frame newfld.
   else do:
      widg = b_Field._Field-name:HANDLE in frame fldprops.
      current-window = s_win_Fld.
   end.

   run adedict/_blnknam.p
      (INPUT widg, INPUT "field", OUTPUT no_name).
   if no_name then return NO-APPLY.

   run adedict/FLD/_fldval.p (INPUT s_Fld_ReadOnly).
   IF (NOT s_Adding AND RETURN-VALUE = "mod" AND
       s_btn_Close:label in frame fldprops <> "Close") then
      s_btn_Close:label in frame fldprops = "Close".
end.

/*----- HIT of TRIGGERS BUTTON (newfld/fldprops) -----*/
on choose of s_btn_Fld_Triggers in frame newfld,
      	     s_btn_Fld_Triggers in frame fldprops
do:
   Define var widg    as widget-handle NO-UNDO.
   Define var no_name as logical       NO-UNDO.
   Define var junk    as logical       NO-UNDO.

   {adedict/forceval.i}  /* force leave trigger to fire */

   IF s_Fld_DType:SCREEN-VALUE IN FRAME newfld = "BLOB" OR 
      s_Fld_DType:SCREEN-VALUE IN FRAME newfld = "CLOB" OR 
      s_Fld_DType:SCREEN-VALUE IN FRAME newfld = "XLOB" THEN 
        RETURN NO-APPLY.
   
   if s_Adding then
      /* Add is modal - current-window is already set */
      widg = b_Field._Field-name:HANDLE in frame newfld.
   else do:
      widg = b_Field._Field-name:HANDLE in frame fldprops.
      current-window = s_win_Fld.
   end.

   run adedict/_blnknam.p
      (INPUT widg, INPUT "field", OUTPUT no_name).
   if no_name then return NO-APPLY.
   
   run adedict/TRIG/_trigdlg.p (INPUT {&OBJ_FLD}, 
			       INPUT "ASSIGN",
      	       	   INPUT widg,
      	       	   INPUT {&Field_Triggers_Dlg_Box}).
   IF (NOT s_Adding AND RETURN-VALUE = "mod" AND
       s_btn_Close:label in frame fldprops <> "Close") then
      s_btn_Close:label in frame fldprops = "Close".
end.


/*----- HIT of VIEW-AS BUTTON (fldprops)-----*/
on choose of s_btn_Fld_ViewAs in frame fldprops
do:
   Define var mod  as logical NO-UNDO.
   Define var temp as char    NO-UNDO.

   /* trigger for new field is in _newfld.p because dtype
      source is different */

   Define var no_name as logical NO-UNDO.

   {adedict/forceval.i}  /* force leave trigger to fire */

    IF s_Fld_DType:SCREEN-VALUE IN FRAME newfld = "BLOB" OR 
       s_Fld_DType:SCREEN-VALUE IN FRAME newfld = "CLOB" OR 
       s_Fld_DType:SCREEN-VALUE IN FRAME newfld = "XLOB" THEN 
     RETURN NO-APPLY.
  

   current-window = s_win_Fld.
   
   run adedict/_blnknam.p
      (INPUT b_Field._Field-name:HANDLE in frame fldprops, 
       INPUT "field", OUTPUT no_name).
   if no_name then return NO-APPLY.

   /* Can't update field directly as in-out parm because if read-only
      this causes an error.
   */
   temp = b_Field._View-as.
   run adecomm/_viewas.p
      (INPUT s_Fld_ReadOnly, INPUT b_Field._dtype, INPUT s_Fld_ProType,
       INPUT-OUTPUT temp, OUTPUT mod).
   if mod then do:   
      b_Field._View-as = temp. 
      {adedict/setdirty.i &Dirty = "true"}.
      if (s_btn_Close:label in frame fldprops <> "Close") then
      	 s_btn_Close:label in frame fldprops = "Close".
   end.
end.


/*----- HIT of STRING ATTRIBUTES BUTTON (newfld/fldprops)-----*/
on choose of s_btn_Fld_StringAttrs in frame newfld,
      	     s_btn_Fld_StringAttrs in frame fldprops
do:
   Define var widg     as widget-handle NO-UNDO.
   Define var no_name  as logical       NO-UNDO.
   Define var readonly as logical       NO-UNDO.
   Define var mod      as logical      	NO-UNDO.

   {adedict/forceval.i}  /* force leave trigger to fire */
   
   IF s_Fld_DType:SCREEN-VALUE IN FRAME newfld = "BLOB" OR 
      s_Fld_DType:SCREEN-VALUE IN FRAME newfld = "CLOB" OR 
      s_Fld_DType:SCREEN-VALUE IN FRAME newfld = "XLOB" THEN   
     RETURN NO-APPLY.
  

   if s_Adding then
      /* Add is modal - current-window is already set */
      widg = b_Field._Field-name:HANDLE in frame newfld.
   else do:
      widg = b_Field._Field-name:HANDLE in frame fldprops.
      current-window = s_win_Fld.
   end.

   run adedict/_blnknam.p
      (INPUT widg, INPUT "field", OUTPUT no_name).
   if no_name then return NO-APPLY.

   run adecomm/_fldsas.p (INPUT s_Fld_ReadOnly, 
      	       	     	 BUFFER b_Field, OUTPUT mod).
   if mod AND NOT s_Adding then do:
      {adedict/setdirty.i &Dirty = "true"}.
      if s_btn_Close:label in frame fldprops <> "Close" then
      	 s_btn_Close:label in frame fldprops = "Close".
   end.
end.

/*----- HIT of GATEWAY BUTTON (newfld/fldprops)-----*/

on choose of s_btn_Fld_Gateway in frame newfld,
      	     s_btn_Fld_Gateway in frame fldprops
do:
   Define var widg     as widget-handle NO-UNDO.
   Define var no_name  as logical       NO-UNDO.
   Define var readonly as logical       NO-UNDO.

   {adedict/forceval.i}  /* force leave trigger to fire */

   if s_Adding then
      /* Add is modal - current-window is already set */
      widg = b_Field._Field-name:HANDLE in frame newfld.
   else do:
      widg = b_Field._Field-name:HANDLE in frame fldprops.
      current-window = s_win_Fld.
   end.

   run adedict/_blnknam.p
      (INPUT widg, INPUT "field", OUTPUT no_name).
   if no_name then return NO-APPLY.

   run adedict/FLD/_fldgate.p (INPUT s_Fld_ReadOnly).
   IF (NOT s_Adding AND RETURN-VALUE = "mod" AND
       s_btn_Close:label in frame fldprops <> "Close") then
      s_btn_Close:label in frame fldprops = "Close".
end.

/*----- LEAVE of NAME FIELD -----*/
on leave of b_Field._Field-Name in frame newfld,
      	    b_Field._Field-Name in frame fldprops
do:
   Define var okay   	as logical.
   Define var name   	as char.
   Define var record_id as recid.
   Define var win    	as widget-handle.

   if s_Adding then
      display "" @ s_Status with frame newfld.  /* clear status after add */

   win = (if s_CurrObj = {&OBJ_FLD} then s_win_Fld else s_win_Dom).
   run adedict/_leavnam.p (INPUT  b_Field._Field-Name, INPUT win, 
      	       	     	   OUTPUT name, OUTPUT okay).
   if okay = ? then return.
   if NOT okay then do:
      s_Valid = no.
      return NO-APPLY.
   end.

   if NOT s_Adding AND s_Fld_InView then
   do:
      message "This field is used in a view - you cannot rename it."
      	       view-as ALERT-BOX ERROR buttons Ok.
      s_Valid = no.
      return NO-APPLY.
   end.

   record_id = (if s_CurrObj = {&OBJ_FLD} then s_TblRecId else s_DomRecId).
   
   /* Make sure there isn't already an object with this name.  Since there is
      a unique index on Name/recid in _Field, this would be caught by Progress
      eventually.  But let's check ourselves to give quicker feedback.
   */
   if can-find (_Field where _Field._File-recid = record_id AND
			     _Field._Field-Name = name) then
   do:
      if s_CurrObj = {&OBJ_FLD} then
	 message "A field with this name already exists in this table."
		  view-as ALERT-BOX ERROR buttons OK.
      else 
	 message "There is already a domain with this name."
		  view-as ALERT-BOX ERROR buttons OK.
      
      s_Valid = no.
      return NO-APPLY.
   end.
end.


/*---- COMBO BOX TRIGGERS for DATA TYPE -----*/
/* Forget about domains for now - deal with this in future. */
{adecomm/cbtdrop.i &Frame  = "frame fldprops"
		   &CBFill = "s_Fld_DType"
		   &CBList = "s_lst_Fld_DType"
		   &CBBtn  = "s_btn_Fld_DType"
		   &CBInit = """"}


/*----- CHANGE of DATA TYPE FIELD -----*/
on /* leave */ U1 of s_Fld_DType in frame fldprops, 
      	       	     s_lst_Fld_DType in frame fldprops
do:
   /* Set other field defaults based on the datatype chosen.  You CAN
      change data types for some gateways.  *See if it's really changed
      1st.  If user had changed format or initial value, for example,
      we don't want to clobber with defaults if we don't have to.
      (* - los 12/27/94)
   */
   if s_Fld_DType <> s_Fld_DType:screen-value in frame fldprops then
   do:
     {adedict/FLD/setdflts.i &Frame = "frame fldprops"} 
   end.
end.


/*----- LEAVE of FORMAT FIELD -----*/
on leave of b_Field._Format in frame fldprops
do:
   /* Set format to default if it's blank and fix up initial value
      if data type is logical based on the format. */
   run adedict/FLD/_dfltfmt.p   
      (INPUT b_Field._Format:HANDLE in frame fldprops,
       INPUT b_Field._Initial:HANDLE in frame fldprops,
       INPUT 0,
       INPUT false). 
end.

/*----- HIT of FORMAT EXAMPLES BUTTON -----*/
on choose of s_btn_Fld_Format in frame fldprops
 	     /* s_btn_Fld_Format in frame domprops */
do:
   Define var fmt as char NO-UNDO.

   /* If adding current window is already set since dlg is modal */
   if NOT s_Adding then current-window = s_win_Fld.

   /* Allow user to pick a different format from examples */
   fmt = input frame fldprops b_Field._Format.
   run adedict/FLD/_fldfmts.p (INPUT s_Fld_Typecode, INPUT-OUTPUT fmt).
   b_Field._Format:SCREEN-VALUE in frame fldprops = fmt.
end.

/*---------- LEAVE OF ORDER FIELD ---------*/
on leave of b_field._order in frame fldprops
DO:
      /* Avoid the test if the field hasn't changed */
      IF b_Field._Order = INT(b_Field._Order:SCREEN-VALUE IN FRAME fldprops)
         THEN LEAVE. 
      /* Is the new order number a duplicate?  Don't allow it.  */
      IF CAN-FIND(FIRST _Field WHERE
                        _Field._File-recid = s_TblRecId AND
                        _Field._Order =
			 INT(b_Field._Order:SCREEN-VALUE IN FRAME fldprops) AND
	                 _Field._Order <> b_Field._Order) THEN 
      DO:
	 MESSAGE "Order number " +
         TRIM(b_Field._Order:SCREEN-VALUE IN FRAME fldprops) "already exists." 
	 VIEW-AS ALERT-BOX ERROR BUTTONS OK.
	 /* set order number back to its current value */
	 b_Field._Order:SCREEN-VALUE IN FRAME fldprops = STRING(b_Field._Order).
        RETURN NO-APPLY.
      END.
END.


/*----- HIT OF TO INT64 BUTTON -----*/
ON CHOOSE OF s_btn_toint64 IN FRAME fldprops
DO:
    /* check int -> int64 change for progress db */
    /* just to be safe */
    IF {adedict/ispro.i} AND b_field._dtype = {&DTYPE_INTEGER} THEN DO:
    
      RUN adedict/FLD/_fldint64.p.
      IF NOT RETURN-VALUE = "mod" THEN
         return NO-APPLY.

       ASSIGN s_Fld_Protype = "int64"
              s_Fld_TypeCode = {&DTYPE_INT64}
              s_Fld_DType:screen-value in frame fldprops = s_Fld_Protype
              s_btn_toint64:SENSITIVE IN FRAME fldprops = NO.
    END.
END.

/*====================Triggers for Sequence Properties=======================*/

/* Some sequence triggers (Save button, GO from create, leave increment */
{adedict/SEQ/seqtrig.i &frame = "frame seqprops"}


/*----- END-ERROR OR CLOSE BUTTON of SEQPROPS FRAME -----*/
on END-ERROR of frame seqprops OR choose of s_btn_Close in frame seqprops
do:
   {adedict/delwin.i &Win = s_win_Seq &Obj = {&OBJ_SEQ}}
   return NO-APPLY.  /* otherwise everything will be undone! */
end.


/*----- HIT of OK BUTTON or GO -----*/
on GO of frame seqprops
do:
   run adedict/SEQ/_saveseq.p
      (b_Sequence._Seq-name:HANDLE in frame seqprops,
       input frame seqprops b_Sequence._Seq-Incr,
       input frame seqprops s_Seq_Limit,
       b_Sequence._Seq-Init:HANDLE in frame seqprops,
       input frame seqprops b_Sequence._Cycle-Ok).

   if RETURN-VALUE = "error" then
      return NO-APPLY.

   {adedict/delwin.i &Win = s_win_Seq &Obj = {&OBJ_SEQ}}
end.


/*----- HIT of SAVE BUTTON -----*/
on choose of s_btn_Save in frame seqprops
do:
   {adedict/forceval.i}  /* force leave trigger to fire */
   run adedict/SEQ/_saveseq.p
      (b_Sequence._Seq-name:HANDLE in frame seqprops,
       input frame seqprops b_Sequence._Seq-Incr,
       input frame seqprops s_Seq_Limit,
       b_Sequence._Seq-Init:HANDLE in frame seqprops,
       input frame seqprops b_Sequence._Cycle-Ok).
   IF (RETURN-VALUE <> "error" AND
       s_btn_Close:label in frame seqprops <> "Close") then
      s_btn_Close:label in frame seqprops = "Close".
end.


/*----- HIT of NEXT button -----*/
on choose of s_btn_Next in frame seqprops
do:
   {adedict/forceval.i}  /* force leave trigger to fire */
   run adedict/_nextobj.p ({&OBJ_SEQ}, true).
end.


/*----- HIT of PREV button -----*/
on choose of s_btn_Prev in frame seqprops
do:
   {adedict/forceval.i}  /* force leave trigger to fire */
   run adedict/_nextobj.p ({&OBJ_SEQ}, false).
end.


/*----- HELP in SEQPROPS FRAME -----*/
on HELP of frame seqprops OR choose of s_btn_Help in frame seqprops 
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", 
      	       	     	     {&Sequence_Properties_Window}, ?).


/*----- LEAVE of NAME FIELD -----*/
on leave of b_Sequence._Seq-Name in frame newseq,
      	    b_Sequence._Seq-Name in frame seqprops
do:
   Define var okay as logical.
   Define var name as char.

   if s_Adding then
      display "" @ s_Status with frame newseq.  /* clear status after add */

   run adedict/_leavnam.p (INPUT  b_Sequence._Seq-Name, 
      	       	     	   INPUT  s_win_Seq, 
      	       	     	   OUTPUT name, OUTPUT okay).
   if okay = ? then return.
   if NOT okay then do:
      s_Valid = no.
      return NO-APPLY.
   end.

   /* Make sure there isn't already an object with this name.  Since there is
      a unique index on Name/recid in _File, this would be caught by Progress
      eventually.  But let's check ourselves to give quicker feedback and to
      be consistent with the old dictionary.
   */
   if can-find (_Sequence where _Sequence._Seq-Name = name) then
   do:
      message "A sequence with this name already exists in this database."
      	 view-as ALERT-BOX ERROR
      	 buttons OK.
      s_Valid = no.
      return NO-APPLY.
   end.
end.


/*----- LEAVE of SAVE BUTTON -----*/
on leave of s_btn_Save in frame seqprops
   display "" @ s_Status with frame seqprops. /* clear status line */


/*=====================Triggers for Index Properties======================*/

/*----- END-ERROR OR CLOSE BUTTON of IDXPROPS FRAME -----*/
on END-ERROR of frame idxprops OR choose of s_btn_Close in frame idxprops
do:
   {adedict/delwin.i &Win = s_win_Idx &Obj = {&OBJ_IDX}}
   return NO-APPLY.  /* otherwise everything will be undone! */
end.


/*----- HIT of SAVE BUTTON -----*/
on choose of s_btn_Save in frame idxprops
do:
   {adedict/forceval.i}  /* force leave trigger to fire */
   run adedict/IDX/_saveidx.p.
   IF (RETURN-VALUE <> "error" AND
       s_btn_Close:label in frame idxprops <> "Close") then
      s_btn_Close:label in frame idxprops = "Close".
end.


/*----- HIT of OK BUTTON or GO -----*/
on GO of frame idxprops
do:
   run adedict/IDX/_saveidx.p.
   if RETURN-VALUE = "error" then
      return NO-APPLY.

   {adedict/delwin.i &Win = s_win_Idx &Obj = {&OBJ_IDX}}
end.


/*----- LEAVE of SAVE BUTTON -----*/
on leave of s_btn_Save in frame idxprops
   display "" @ s_Status with frame idxprops. /* clear status line */


/*----- HIT of NEXT button -----*/
on choose of s_btn_Next in frame idxprops
do:
   {adedict/forceval.i}  /* force leave trigger to fire */
   run adedict/_nextobj.p ({&OBJ_IDX}, true).
end.


/*----- HIT of PREV button -----*/
on choose of s_btn_Prev in frame idxprops
do:
   {adedict/forceval.i}  /* force leave trigger to fire */
   run adedict/_nextobj.p ({&OBJ_IDX}, false).
end.


/*----- HELP in IDXPROPS FRAME -----*/
on HELP of frame idxprops OR choose of s_btn_Help in frame idxprops 
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Index_Properties_Window}, ?).


/*----- LEAVE of NAME FIELD -----*/
on leave of b_Index._Index-Name in frame newidx,
      	    b_Index._Index-Name in frame idxprops
do:
   Define var okay as logical.
   Define var name as char.
   Define var record_id as recid.

   if s_Adding then
      display "" @ s_Status with frame newidx.  /* clear status after add */

   run adedict/_leavnam.p (INPUT  b_Index._Index-Name,
      	       	     	   INPUT  s_win_Idx, 
      	       	     	   OUTPUT name, OUTPUT okay).
   if okay = ? then return.
   if NOT okay then do:
      s_Valid = no.
      return NO-APPLY.
   end.
   
   /* Make sure there isn't already an object with this name.  Since there is
      a unique index on Name/recid in _Index, this would be caught by Progress
      eventually.  But let's check ourselves to give quicker, clearer feedback.
   */
   if can-find (_Index where _Index._File-recid = s_TblRecId AND
			     _Index._Index-Name = name) then
   do:
      message "An index with this name already exists for this table."
	       view-as ALERT-BOX ERROR
	       buttons OK.
      
      s_Valid = no.
      return NO-APPLY.
   end.
end.






/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: forceval.i

Description:
   This is to enforce validation when the user hits a default button
   (other than an AUTO-GO button) by hitting RETURN or "presses" a button
   by using it's keyboard accelerator.  In these cases, Progress does
   not generate any LEAVE events, so we have to do it ourselves.

Author: Laura Stern

Date Created: 05/25/92 
----------------------------------------------------------------------------*/


s_Widget = focus:handle.
if s_Widget <> SELF:handle then 
do:
   s_Valid = yes.
   apply "LEAVE" to s_Widget.
   if NOT s_Valid then
      return NO-APPLY.
end.
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: gateproc.i

Description:
   Configure the name of a gateway routine to call.

Arguments:
   &Suffix - the routine name suffix (following _ora for example).
   &Name   - the variable to set.

Author: Laura Stern

Date Created: 08/12/93 
     History: 04/04/00 D. McMann Added MSS database type.

----------------------------------------------------------------------------*/

&IF DEFINED(GATEPROC_VAR) = 0 &THEN /* in case someone includes this twice */
   Define var gdb_type  as char NO-UNDO.
   Define var gdb_otype as char NO-UNDO.
   &global-define GATEPROC_VAR ""
&ENDIF

assign
  gdb_type = s_DbCache_Type[s_DbCache_ix]
  gdb_otype = { adecomm/ds_type.i
                  &direction = "ODBC"
                  &from-type = "gdb_type"
                  }
  {&Name} = "prodict/" + 
   (if      gdb_type = "MSS"           then "mss/_mss{&Suffix}.p"
    else if gdb_type = "RDB"           then "rdb/_rdb{&Suffix}.p"
    else if gdb_type = "ORACLE"        then "ora/_ora{&Suffix}.p"
    else if gdb_type = "SYBASE"        then "syb/_syb{&Suffix}.p"
    else if gdb_type = "AS400"         then "as4/_as4{&Suffix}.p"
    else if gdb_type = "CTOSISAM"      then "bti/_bti{&Suffix}.p"
    else if CAN-DO(gdb_otype,gdb_type) then "odb/_odb{&Suffix}.p"
    else "").

/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: ispro.i

Description:
   Determine if the current database is a progress database.  This is 
   meant to be plugged into an IF statement - e.g., if {ispro.i} then...
 
Author: Laura Stern

Date Created: 03/05/92

----------------------------------------------------------------------------*/


(s_DbCache_Type[s_DbCache_ix] = "PROGRESS")
/*********************************************************************
* Copyright (C) 2005,2008-2009 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------
File: menu.i

Description:
   This include file contains the definition of the dictionary menu.
 
Arguments:
   {1} - this is either "new shared" or "shared".

Author: Laura Stern

Date Created: 02/17/92 
    Modified: 01/05/98 Added Storage Area Report for V9
              05/19/99 Mario B.  Adjust Width Field browser integration.   
              09/18/02 D. McMann Added verify data report  
              10/01/02 D. McMann Change menu name for Adjust Schema
              07/19/05 kmcintos  Added Auditing Reports
              10/27/08 fernando  Added Encryption Reports
              04/07/09 fernando  Added Alternate Buffer Pool Report
----------------------------------------------------------------------------*/

{adecomm/toolmenu.i &EXCLUDE_DICT = yes}


Define sub-menu s_mnu_QuickFld
   menu-item mi_f_CurrTbl   label "&Selected Table"
   menu-item mi_f_AllTbls   label "&All Tables".

Define sub-menu s_mnu_QuickIdx
   menu-item mi_i_CurrTbl   label "&Selected Table"
   menu-item mi_i_AllTbls   label "&All Tables".

Define sub-menu s_mnu_TblRel
   menu-item mi_r_CurrTbl   label "&Selected Table"
   menu-item mi_r_AllTbls   label "&All Tables".

DEFINE SUB-MENU s_mnu_Aud_Rep
   MENU-ITEM mi_ADRpt_AudPol    LABEL "Track Audit &Policy Changes"
   MENU-ITEM mi_ADRpt_DbSchma   LABEL "Track Database &Schema Changes"
   MENU-ITEM mi_ADRpt_AudAdmn   LABEL "Track &Audit Data Administration (Dump/Load)"
   MENU-ITEM mi_ADRpt_TblAdmn   LABEL "Track Application &Data Administration (Dump/Load)"
   RULE
   MENU-ITEM mi_ADRpt_UsrAct    LABEL "Track &User Account Changes"
   MENU-ITEM mi_ADRpt_SecPerm   LABEL "Track Security Per&missions Changes"
   MENU-ITEM mi_ADRpt_Dba       LABEL "&Track SQL Permissions Changes"
   MENU-ITEM mi_ADRpt_AuthSys   LABEL "Track Authe&ntication System Changes"
   RULE
   MENU-ITEM mi_CSRpt_CltSess   LABEL "&Client Session Authentication Report"
   MENU-ITEM mi_ADRpt_DbAdmin   LABEL "Database Administ&ration Report (Utilities)"
   MENU-ITEM mi_ADRpt_AppLogin  LABEL "Database Access Report (Lo&gin/Logout/etc...)"
   RULE
   MENU-ITEM mi_ADRpt_EncPol    LABEL "Track &Encryption Policy Changes"
   MENU-ITEM mi_ADRpt_KeyStore  LABEL "Track &Key Store Changes"
   MENU-ITEM mi_ADRpt_EncAdmin  LABEL "Database Encr&yption Administration (Utilities)"
   RULE
   MENU-ITEM mi_ADRpt_Cust      LABEL "Custom Audit Data &Filter Report".

DEFINE SUB-MENU s_mnu_Enc_Rep
   MENU-ITEM mi_EncPolQuick     LABEL "&Quick Encryption Policies"
   MENU-ITEM mi_EncPolDetailed  LABEL "&Detailed Encryption Policies".

Define sub-menu s_mnu_Reports	
   menu-item mi_DetailedTbl   	 label "&Detailed Table..."
   menu-item mi_QuickTbl         label "Quick &Table"
   sub-menu s_mnu_QuickFld       label "Quick &Field"
   sub-menu s_mnu_QuickIdx       label "Quick &Index"
   menu-item mi_QuickViw         label "PRO/SQL &View"
   menu-item mi_QuickSeq      	 label "&Sequence"
   menu-item mi_Trigger	      	 label "Tri&gger"
   menu-item mi_QuickUsr         label "&User"
   sub-menu  s_mnu_TblRel        label "Table &Relations"
   menu-item mi_QuickArea        label "Storage &Areas"
   MENU-ITEM mi_Width            label "Verify Data &Width"
   MENU-ITEM mi_AltBufPool       label "Alternate &Buffer Pool"
   RULE
   SUB-MENU  s_mnu_Aud_Rep       LABEL "Auditing R&eports"
   SUB-MENU  s_mnu_Enc_Rep       LABEL "Encryption &Policy Reports".

Define sub-menu s_mnu_Database
   menu-item mi_Crt_Database	 label "&Create..."   ACCELERATOR "SHIFT-F3"
   menu-item mi_Connect		 label "Co&nnect..."  ACCELERATOR "F3"
   menu-item mi_Disconnect    	 label "&Disconnect"  ACCELERATOR "F8"
   sub-menu  s_mnu_Reports	 label "&Reports"
   menu-item mi_Exit		 label "E&xit".
      
Define sub-menu s_mnu_Edit	
   menu-item mi_Undo	      	 label "&Undo Transaction"  ACCELERATOR "CTRL-Z"
   menu-item mi_Commit	      	 label "&Commit Transaction" 
      	       	     	      	       	     	      	    ACCELERATOR "CTRL-Y"
   RULE	     
   menu-item mi_Delete      	 label "&Delete"            ACCELERATOR "CTRL-D"
   menu-item mi_Properties	 label "&Properties..."     ACCELERATOR "CTRL-P".
      
Define sub-menu s_mnu_Create      
   menu-item mi_Crt_Table	 label "&Table..."    ACCELERATOR "CTRL-T"
   menu-item mi_Crt_Sequence	 label "&Sequence..." ACCELERATOR "CTRL-S"
   menu-item mi_Crt_Field     	 label "&Field..."    ACCELERATOR "CTRL-F"
   menu-item mi_Crt_Index     	 label "&Index..."    ACCELERATOR "CTRL-X".
/*
Define sub-menu s_mnu_SQL_Props    
   menu-item mi_SQL_Width          label "Adjust Field Width".
*/   
Define sub-menu s_mnu_Options
   menu-item mi_Field_Rename   	 label "&Globally Rename Fields..."
   menu-item mi_Field_Renumber 	 label "&Renumber Fields in Table..."
   menu-item mi_SQL_Width        label "Adjust Field Width".  
   RULE
   menu-item mi_Mode_Db 	 label "&Database Mode" ACCELERATOR "SHIFT-F6"
   menu-item mi_Mode_Tbl 	 label "&Table Mode"    ACCELERATOR "SHIFT-F7"
   menu-item mi_Mode_Seq	 label "&Sequence Mode" ACCELERATOR "SHIFT-F8"
   menu-item mi_Mode_Fld	 label "&Field Mode"    ACCELERATOR "SHIFT-F9"
   menu-item mi_Mode_Idx	 label "&Index Mode"    ACCELERATOR "SHIFT-F10".

Define sub-menu s_mnu_View
   menu-item mi_Order_Fields  label "&Order Fields Alphabetically"
   menu-item mi_Show_Hidden   label "&Show Hidden Tables" TOGGLE-BOX.

Define sub-menu s_mnu_Help SUB-MENU-HELP
   MENU-ITEM mi_Master      LABEL "OpenEdge &Master Help"
   menu-item mi_Contents    label "Data Dictionary &Help Topics"
   RULE
   menu-item mi_messages    label "M&essages..."
   menu-item mi_recent      label "&Recent Messages..."
   RULE
   menu-item mi_About       label "&About Dictionary".

Define {1} menu s_mnu_Dict
   MENUBAR
   sub-menu s_mnu_Database	 label "&Database"
   sub-menu s_mnu_Edit		 label "&Edit"
   sub-menu s_mnu_Create      	 label "&Create"
   sub-menu s_mnu_View	      	 label "&View"
   sub-menu s_mnu_Options	 label "&Options"
   sub-menu mnu_Tools            label "&Tools"
   sub-menu s_mnu_Help	      	 label "&Help".

/*********************************************************************
* Copyright (C) 2005,2008-2009 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: menutrig.i

Description:
   Here we have all the trigger definitions for the selection of menu items.
 
Author: Laura Stern

Date Created: 02/17/92 
    Modified: 01/06/98 DLM     Added area report section
              12/30/98 Mario B Call _guivget.p b4 _qviwrpt.p.  Bug 98-08-13-026
              05/19/99 Mario B.  Adjust Width Field browser integration.  
              04/13/00 DLM     Added long path name support    
              09/18/02 D. McMann Added verify data report 
              10/01/02 D. McMann Changed menu name for Adjust Schema
              07/19/05 kmcintos  Added Auditing Reports
              10/27/08 fernando  Added Encryption Reports
              04/07/09 fernando  Added Alternate Buffer Pool Report
----------------------------------------------------------------------------*/


/*===========================Internal Procedures=========================*/

/*----------------------------------------------------------------
   See if the user made any changes in a property window 
   that he hasn't saved.  This (_changed.p) will ask if he wants 
   to save and do the save if he says yes. 

   Returns: "error" if an error occurs when the user tries to 
      	    save, otherwise, "".
---------------------------------------------------------------*/
Procedure Check_For_Changes:

   Define var err as logical NO-UNDO.

   err = no.
   if s_win_Tbl <> ? then
      run adedict/_changed.p (INPUT {&OBJ_TBL}, yes, OUTPUT err).
   if NOT err AND s_win_Seq <> ? then
      run adedict/_changed.p (INPUT {&OBJ_SEQ}, yes, OUTPUT err).   
   if NOT err AND s_win_Fld <> ? then
      run adedict/_changed.p (INPUT {&OBJ_FLD}, yes, OUTPUT err).
   if NOT err AND s_win_Idx <> ? then
      run adedict/_changed.p (INPUT {&OBJ_IDX}, yes, OUTPUT err).

   if err then 
      return "error".
   else
      return "".
End.


/*------------------------------------------------------------------------ 
   Do Exit processing.

------------------------------------------------------------------------*/
PROCEDURE Do_Exit:
   s_Trans = {&TRANS_ASK_AND_EXIT}.
   if s_DictState = {&STATE_NO_DB_SELECTED} then
   do:
      /* There's nothing to ask, since there can be no transaction
      	 so we're done */
      s_DictState = {&STATE_DONE}.
      apply "U1" to frame browse.
   end.
   else do:
      /* Check to see if user has made any changes in open property windows
	 that he hasn't saved.  If there are, and he saves now, and an error
	 occurs, don't continue with exit.
      */
      run Check_For_Changes.
      if RETURN-VALUE = "error" then return.
      if s_DictDirty THEN do:
        DEFINE VARIABLE answer AS LOGICAL.
      
        ASSIGN answer =  yes.
        MESSAGE "You have made changes in the current"    SKIP
               "database that are not committed.  Answering"    SKIP  
               "YES will commit your changes, NO will undo them."   SKIP (1)
      	       "Do you want to commit your changes?" 
      	      VIEW-AS ALERT-BOX WARNING  buttons YES-NO-CANCEL
      	      UPDATE answer IN WINDOW s_win_Browse.                                  
      	         
        IF answer = ? THEN DO: 
          ASSIGN s_trans = {&TRANS_NONE}.
          RETURN.
        END.
        ELSE IF answer = yes THEN 
            ASSIGN user_env[34] = "Y".  
        ELSE 
            ASSIGN user_env[34] = "N".	    
                                        
      end.
      /* Here, we have to ask commit or undo (if dict is dirty) and in
      	 any event, get out of the transaction loop. */
      apply "U2" to frame browse.
   end.
end.


/*=========================DATABASE menu=================================*/

/*----- CREATE DATABASE -----*/
On choose of MENU-ITEM mi_Crt_Database in MENU s_mnu_Database
do:
   if s_CurrObj <> {&OBJ_DB} then
      run Push_Obj_Button (INPUT  {&OBJ_DB}, 
      	       	     	   INPUT  s_icn_Dbs:HANDLE in frame browse,
      	       	     	   INPUT  false).
   run Choose_Create.
end.


/*----- CONNECT -----*/
On choose of MENU-ITEM mi_Connect in MENU s_mnu_Database
   run adedict/DB/_connect.p (INPUT ?).


/*----- DISCONNECT -----*/
On choose of MENU-ITEM mi_Disconnect in MENU s_mnu_Database
do:
   Define var answer as logical init yes NO-UNDO.

   /* If it's not dirty then ask "are you sure" here.  Otherwise
      dicttran will ask about committing and user can cancel 
      disconnect then. */
   if NOT s_DictDirty then
   do:
      current-window = s_win_Browse.
      message "Are you sure you want to disconnect database" s_CurrDb "?"
      	       view-as ALERT-BOX QUESTION
      	       buttons YES-NO
      	       update answer in window s_win_Browse.
   end.
   ELSE DO:
     MESSAGE "You have made changes in the current"    SKIP
             "database that are not committed.  Answering"    SKIP  
             "YES will commit your changes, NO will undo them."   SKIP (1)
             "Do you want to commit your changes?" 
     VIEW-AS ALERT-BOX WARNING  buttons YES-NO-CANCEL
     UPDATE answer IN WINDOW s_win_Browse.                                  

     IF answer = ? THEN RETURN.
     ELSE IF answer = yes THEN 
       ASSIGN user_env[34] = "Y".  
     ELSE 
       ASSIGN user_env[34] = "N".	    
   END.
   if answer THEN DO:
      /* Make sure any changes are committed or undone before disconnecting */
      s_Trans = {&TRANS_ASK_AND_DO}.
      s_ActionProc = "adedict/DB/_dconn.p".
      apply "U2" to frame browse.
   end.
end.


/*----- EXIT ----- */
On choose of MENU-ITEM mi_Exit in MENU s_mnu_Database
   run Do_Exit.


/*----------------------------- REPORTS sub-menu---------------------------*/

Define var which_tbl as char init "t" NO-UNDO
   view-as RADIO-SET
   radio-buttons "Selected Table", "t", "ALL Tables", "a".

Form 
   SKIP(.5)
   "Report on:" at 4 view-as TEXT SKIP
   which_tbl    at 4 	          SKIP(1)
   s_btn_Ok     at 2 SPACE(2)
   s_btn_Cancel      SPACE(1)
   SKIP(.5)
   with frame tbl_select no-labels
      	      view-as DIALOG-BOX TITLE "Report Table Options".


/*----- DETAILED TABLE REPORT -----*/
On choose of MENU-ITEM mi_DetailedTbl in MENU s_mnu_Reports
do:
   current-window = s_win_Browse.
   if s_CurrTbl = "" then
   do:
      message "There are no tables in this database to look at."
      	  view-as ALERT-BOX ERROR buttons OK.
      return.
   end.

   run adecomm/_dtblrpt.p
      (INPUT s_DbRecId,
       INPUT s_CurrDb, 
       INPUT s_DbCache_Type[s_DbCache_ix],
       INPUT (if s_Order_By = {&ORDER_ORDER#} then "o" else "a"),
       INPUT (if which_tbl = "a" then "ALL" else s_CurrTbl),
       INPUT yes).
end.


/*----- QUICK TABLE REPORT -----*/
On choose of MENU-ITEM mi_QuickTbl in MENU s_mnu_Reports
do:
   current-window = s_win_Browse.
   run adecomm/_qtblrpt.p
      (INPUT s_DbRecId,    
       INPUT  s_CurrDb, 
       INPUT s_DbCache_Type[s_DbCache_ix]).
end.


/*----- QUICK FIELD REPORT -----*/
On choose of MENU-ITEM mi_f_CurrTbl in MENU s_mnu_QuickFld
do:
   current-window = s_win_Browse.
   run adecomm/_qfldrpt.p
      (INPUT s_DbRecId,
       INPUT s_CurrDb,
       INPUT s_DbCache_Type[s_DbCache_ix],
       INPUT s_CurrTbl,
       INPUT (if s_Order_By = {&ORDER_ORDER#} then "o" else "a")).
end.

On choose of MENU-ITEM mi_f_AllTbls in MENU s_mnu_QuickFld
do:
   current-window = s_win_Browse.
   if s_CurrTbl = "" then
   do:
      message "There are no fields in this database to look at."
      	  view-as ALERT-BOX ERROR buttons OK.
      return.
   end.

   run adecomm/_qfldrpt.p
      (INPUT s_DbRecId,
       INPUT s_CurrDb,
       INPUT s_DbCache_Type[s_DbCache_ix],
       INPUT "ALL",
       INPUT (if s_Order_By = {&ORDER_ORDER#} then "o" else "a")).
end.

/*----- QUICK INDEX REPORT -----*/
On choose of MENU-ITEM mi_i_CurrTbl in MENU s_mnu_QuickIdx
do:
   current-window = s_win_Browse.
   run adecomm/_qidxrpt.p
      (INPUT s_DbRecId,
       INPUT s_CurrDb,
       INPUT s_DbCache_Type[s_DbCache_ix],
       INPUT s_CurrTbl,
       INPUT "").
end.

On choose of MENU-ITEM mi_i_AllTbls in MENU s_mnu_QuickIdx
do:
   current-window = s_win_Browse.
   if s_CurrTbl = "" then
   do:
      message "There are no indexes in this database to look at."
      	  view-as ALERT-BOX ERROR buttons OK.
      return.
   end.

   run adecomm/_qidxrpt.p
      (INPUT s_DbRecId,
       INPUT s_CurrDb,
       INPUT s_DbCache_Type[s_DbCache_ix],
       INPUT "ALL",
       INPUT "").
end.


/*----- QUICK VIEW REPORT -----*/
On choose of MENU-ITEM mi_QuickViw in MENU s_mnu_Reports
do:
   current-window = s_win_Browse.
   user_env = "a".  /* Means all is an allowable choice */
   run prodict/gui/_guivget.p.
   /* Get out if cancel is selected */
   IF user_env[1] = "" OR user_env[1] = ? THEN RETURN.
   run adecomm/_qviwrpt.p
      (INPUT s_DbRecId,    
       INPUT s_CurrDb,
       INPUT s_DbCache_Type[s_DbCache_ix],
       user_env[1]). 
end.


/*----- QUICK SEQUENCE REPORT -----*/
On choose of MENU-ITEM mi_QuickSeq in MENU s_mnu_Reports
do:
   current-window = s_win_Browse.
   run adecomm/_qseqrpt.p
      (INPUT s_DbRecId,    
       INPUT s_CurrDb,
       INPUT s_DbCache_Type[s_DbCache_ix]).
end.


/*----- TRIGGER REPORT -----*/
On choose of MENU-ITEM mi_Trigger in MENU s_mnu_Reports
do:
   current-window = s_win_Browse.
   run adecomm/_trigrpt.p
      (INPUT s_DbRecId,    
       INPUT s_CurrDb,
       INPUT s_DbCache_Type[s_DbCache_ix]).
end.


/*----- QUICK USER REPORT -----*/
On choose of MENU-ITEM mi_QuickUsr in MENU s_mnu_Reports
do:
   current-window = s_win_Browse.
   run adecomm/_qusrrpt.p
      (INPUT s_DbRecId,    
       INPUT s_CurrDb,
       INPUT s_DbCache_Type[s_DbCache_ix]).
end.


/*----- FILE RELATIONS REPORT -----*/
On choose of MENU-ITEM mi_r_CurrTbl in MENU s_mnu_TblRel
do:
   current-window = s_win_Browse.
   if s_CurrTbl = "" then
   do:
      message "There are no tables in this database to look at."
      	  view-as ALERT-BOX ERROR buttons OK.
      return.
   end.

   run adecomm/_trelrpt.p
      (INPUT s_DbRecId,
       INPUT s_CurrDb,
       INPUT s_DbCache_Type[s_DbCache_ix],
       INPUT s_CurrTbl,
       INPUT "").
end.

On choose of MENU-ITEM mi_r_AllTbls in MENU s_mnu_TblRel
do:
   current-window = s_win_Browse.
   if s_CurrTbl = "" then
   do:
      message "There are no tables in this database to look at."
      	  view-as ALERT-BOX ERROR buttons OK.
      return.
   end.

   run adecomm/_trelrpt.p
      (INPUT s_DbRecId,
       INPUT s_CurrDb,
       INPUT s_DbCache_Type[s_DbCache_ix],
       INPUT "ALL",
       INPUT "").
end.

/*----- QUICK Area REPORT -----*/
On choose of MENU-ITEM mi_QuickArea in MENU s_mnu_Reports
do:
   current-window = s_win_Browse.
   run adecomm/_qarerpt.p
      (INPUT s_DbRecId).
end.

/*--------Data Width Report ----*/
ON CHOOSE OF MENU-ITEM mi_Width IN MENU s_mnu_Reports DO: 
    CURRENT-WINDOW = s_win_Browse.

    RUN prodict/misc/_rptwdat.p
    (INPUT s_dbRecId,
     INPUT s_CurrDb,
     INPUT "PROGRESS",
     INPUT "",
     INPUT s_TblRecId).
END.

/*--------Alternate Buffer Pool Report ----*/
ON CHOOSE OF MENU-ITEM mi_AltBufPool IN MENU s_mnu_Reports DO: 
    CURRENT-WINDOW = s_win_Browse.

    DO ON STOP UNDO, LEAVE.
       RUN prodict/misc/_rptaltbuf.p.
    END.
END.

/*------    Track Audit Policy Changes Report            -------*/
ON CHOOSE OF MENU-ITEM mi_ADRpt_AudPol   IN MENU s_mnu_Aud_Rep DO:
  user_env[9] = "1".
  RUN prodict/misc/_rptaud.p. /* AUD_POL_MNT */
END.

/*------    Track Database Schema Changes Report         -------*/
ON CHOOSE OF MENU-ITEM mi_ADRpt_DbSchma  IN MENU s_mnu_Aud_Rep DO:
  user_env[9] = "2".
  RUN prodict/misc/_rptaud.p. /* SCH_CHGS */
END.

/*------    Track Audit Data Administration Report       -------*/
ON CHOOSE OF MENU-ITEM mi_ADRpt_AudAdmn  IN MENU s_mnu_Aud_Rep DO:
  user_env[9] = "3".
  RUN prodict/misc/_rptaud.p. /* AUD_DATA_ADMIN */
END.

/*------    Track Application Data Administration Report-------*/
ON CHOOSE OF MENU-ITEM mi_ADRpt_TblAdmn  IN MENU s_mnu_Aud_Rep DO:
  user_env[9] = "4".
  RUN prodict/misc/_rptaud.p. /* DATA_ADMIN */
END.
  
/*------    Track User Account Changes Report            -------*/
ON CHOOSE OF MENU-ITEM mi_ADRpt_UsrAct   IN MENU s_mnu_Aud_Rep DO:
  user_env[9] = "5".
  RUN prodict/misc/_rptaud.p. /* USER_MAINT */
END.

/*------    Track Security Permissions Changes Report       -------*/
ON CHOOSE OF MENU-ITEM mi_ADRpt_SecPerm  IN MENU s_mnu_Aud_Rep DO:
  user_env[9] = "6".
  RUN prodict/misc/_rptaud.p. /* SEC_PERM_MNT */
END.

/*------    Track Database Administrator Changes Report -------*/
ON CHOOSE OF MENU-ITEM mi_ADRpt_Dba      IN MENU s_mnu_Aud_Rep DO:
  user_env[9] = "7".
  RUN prodict/misc/_rptaud.p. /* DBA_MAINT */
END.

/*------    Track Authentication System Changes Report   -------*/
ON CHOOSE OF MENU-ITEM mi_ADRpt_AuthSys  IN MENU s_mnu_Aud_Rep DO:
  user_env[9] = "8".
  RUN prodict/misc/_rptaud.p. /* AUTH_SYS */
END.

/*------    Client Session Authentication Report         -------*/
ON CHOOSE OF MENU-ITEM mi_CSRpt_CltSess IN MENU s_mnu_Aud_Rep DO:
  user_env[9] = "9".
  RUN prodict/misc/_rptaud.p. /* CLT_SESS */
END.

/*------    Database Administration Report               -------*/
ON CHOOSE OF MENU-ITEM mi_ADRpt_DbAdmin IN MENU s_mnu_Aud_Rep DO:
  user_env[9] = "10".
  RUN prodict/misc/_rptaud.p. /* DB_ADMIN */
END.

/*------    Database Access Report                       -------*/
ON CHOOSE OF MENU-ITEM mi_ADRpt_AppLogin IN MENU s_mnu_Aud_Rep DO:
  user_env[9] = "11".
  RUN prodict/misc/_rptaud.p. /* DB_ACCESS */
END.

/*------    Custom Audit Data Filter Report              -------*/
ON CHOOSE OF MENU-ITEM mi_ADRpt_Cust IN MENU s_mnu_Aud_Rep DO:
  user_env[9] = "12".
  RUN prodict/misc/_rptaud.p. /* CUST_RPT */
END.

/*------    Track Encryption Policy Changes              -------*/
ON CHOOSE OF MENU-ITEM mi_ADRpt_EncPol IN MENU s_mnu_Aud_Rep DO:
  user_env[9] = "13".
  RUN prodict/misc/_rptaud.p. /* ENC_POL */
END.

/*------    Track Key-store Changes                      -------*/
ON CHOOSE OF MENU-ITEM mi_ADRpt_KeyStore IN MENU s_mnu_Aud_Rep DO:
  user_env[9] = "14".
  RUN prodict/misc/_rptaud.p. /* ENC_KEYSTORE */
END.

/*------   Database Encryption Administration (Utilities) -------*/
ON CHOOSE OF MENU-ITEM mi_ADRpt_EncAdmin IN MENU s_mnu_Aud_Rep DO:
  user_env[9] = "15".
  RUN prodict/misc/_rptaud.p. /* ENC_ADMIN */
END.

/*------    Encryption Report - Quick                      -------*/

ON CHOOSE OF MENU-ITEM mi_EncPolQuick IN MENU s_mnu_Enc_Rep DO:
  user_env[9] = "1".
  RUN prodict/misc/_rptencp.p.
END.

/*------    Encryption Report - Detailed                   -------*/
ON CHOOSE OF MENU-ITEM mi_EncPolDetailed IN MENU s_mnu_Enc_Rep DO:
   current-window = s_win_Browse.
   if s_CurrTbl = "" then
   do:
      message "There are no tables in this database to look at."
      	  view-as ALERT-BOX ERROR buttons OK.
      return.
   end.

   user_env[9] = "2," + (if which_tbl = "a" then "ALL" else s_CurrTbl).

   RUN prodict/misc/_rptencp.p.
END.

/*=============================Edit menu=================================*/

/*----- UNDO ----- */
On choose of MENU-ITEM mi_Undo in MENU s_mnu_Edit
do:
   Define var answer as logical init yes NO-UNDO.

   current-window = s_win_Browse.
   message "Are you sure you want to undo your changes?"
      	    view-as ALERT-BOX QUESTION
      	    buttons YES-NO
      	    update answer in window s_win_Browse.

   if answer then
   do:
      /* If focus is in Db list, we want it to remain there instead
      	 of defaulting to fill-in.  So remember if list has the focus.      	  
      */
      if focus <> ? then
      	 s_Dblst_Focus = (if s_lst_Dbs:handle in frame browse = 
      	       	       	  focus:handle then yes else no).

      s_Trans = {&TRANS_UNDO}.
      apply "U2" to frame browse.
   end.
end.


/*----- COMMIT ----- */
On choose of MENU-ITEM mi_Commit in MENU s_mnu_Edit
do:
   Define var answer as logical NO-UNDO init yes.

   /* Check to see if user has made any changes in open property windows
      that he hasn't saved.  If there are, and he saves now, and an error
      occurs, don't continue.  
   */
   run Check_For_Changes.
   if RETURN-VALUE = "error" then return.

   current-window = s_win_Browse.
   message "Commiting your changes may potentially take a long time." SKIP
      	   "Are you sure you want to commit your changes?"
      	    view-as ALERT-BOX QUESTION  buttons YES-NO  update answer
      	   in window s_win_Browse.

   if answer then
   do:
      /* If focus is in Db list, we want it to remain there instead
      	 of defaulting to fill-in.  So remember if list has the focus.      	  
      */
      if focus <> ? then
      	 s_Dblst_Focus = (if s_lst_Dbs:handle in frame browse = 
      	       	     	  focus:handle then yes else no).

      s_Trans = {&TRANS_COMMIT}.
      apply "U2" to frame browse.
   end.
end.


/*----- DELETE ----- */
On choose of MENU-ITEM mi_Delete in MENU s_mnu_Edit
   run adedict/_delete.p (INPUT s_CurrObj).


/*----- PROPERTIES ----- */
On choose of MENU-ITEM mi_Properties in MENU s_mnu_Edit
   run Choose_Properties.


/*===========================Create menu=================================*/

/*----- TABLE -----*/
On choose of MENU-ITEM mi_Crt_Table in MENU s_mnu_Create
do:
   if s_CurrObj <> {&OBJ_TBL} then
      run Push_Obj_Button (INPUT {&OBJ_TBL}, 
      	       	     	   INPUT s_icn_Tbls:HANDLE in frame browse,
      	       	     	   INPUT  false).
   run Choose_Create.
end.

/*----- SEQUENCE -----*/
On choose of MENU-ITEM mi_Crt_Sequence in MENU s_mnu_Create
do:
   if s_CurrObj <> {&OBJ_SEQ} then
      run Push_Obj_Button (INPUT {&OBJ_SEQ}, 
      	       	     	   INPUT s_icn_Seqs:HANDLE in frame browse,
      	       	     	   INPUT  false).
   run Choose_Create.
end.


/*----- FIELD -----*/
On choose of MENU-ITEM mi_Crt_Field in MENU s_mnu_Create
do:
   if s_CurrObj <> {&OBJ_FLD} then
      run Push_Obj_Button (INPUT {&OBJ_FLD}, 
      	       	     	   INPUT s_icn_Flds:HANDLE in frame browse,
      	       	     	   INPUT  false).
   run Choose_Create.
end.


/*----- INDEX -----*/
On choose of MENU-ITEM mi_Crt_Index in MENU s_mnu_Create
do:
   if s_CurrObj <> {&OBJ_IDX} then
      run Push_Obj_Button (INPUT {&OBJ_IDX}, 
      	       	     	   INPUT s_icn_Idxs:HANDLE in frame browse,
      	       	     	   INPUT  false).
   run Choose_Create.
end.


/*=============================View menu=================================*/

/*----- SHOW HIDDEN TABLES ----- */
On value-changed of MENU-ITEM mi_Show_Hidden in MENU s_mnu_View
do:
   /* Toggle the flag */
   s_Show_Hidden_Tbls = NOT s_Show_Hidden_Tbls.
   fhidden = s_Show_Hidden_Tbls.
   
   /* redisplay the table list if it is currently visible */
   {adedict/uncache.i 
      &List   = "s_lst_Tbls"
      &Cached = "s_Tbls_Cached"
      &Curr   = "s_CurrTbl"}

   if s_Lvl1Obj = {&OBJ_TBL} then
   do:
      if s_CurrObj <> {&OBJ_TBL} then
      	 run adedict/_brwbtn.p (INPUT {&OBJ_TBL}, 
      	       	     	      	 INPUT s_icn_Tbls:HANDLE in frame browse, 
      	       	     	      	 INPUT false).   
      	 
      run adedict/_brwlist.p (INPUT {&OBJ_TBL}).
   end.
end.


/*----- ORDER FIELDS ----- */
On choose of MENU-ITEM mi_Order_Fields in MENU s_mnu_View
do:
   DEF VAR err AS LOG NO-UNDO.
   /* Change the menu label to indicate what the user will change to
      if he picks that option. 
   */
   if s_Order_By = {&ORDER_ALPHA} then
      assign
      	 s_Order_By = {&ORDER_ORDER#}
      	 SELF:label = "Order Fields Alphabetically".
   else
      assign
      	 s_Order_By = {&ORDER_ALPHA}
      	 SELF:label = "Order Fields by Order Number".

   /* redisplay the field list if it is currently visible */
   {adedict/uncache.i 
      &List   = "s_lst_Flds"
      &Cached = "s_Flds_Cached"
      &Curr   = "s_CurrFld"}

   if s_Lvl2Obj = {&OBJ_FLD} then
      run adedict/_brwlist.p (INPUT {&OBJ_FLD}).

   IF s_win_Width <> ? THEN
   DO:
      run adedict/_changed.p (INPUT {&OBJ_TBL}, yes, OUTPUT err). 
      IF err THEN
      DO:
         MESSAGE "An error occured in module" THIS-PROCEDURE:FILE-NAME "." SKIP
                 "Please notify Progress Software Corporation"
	 VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      RETURN NO-APPLY.
      END.
      RUN prodict/gui/_guisqlw.p.
   END.

end.


/*==========================Options menu=================================*/

/*----- RENUMBER FIELDS ----- */
On choose of MENU-ITEM mi_Field_Renumber in MENU s_mnu_Options
do:
   current-window = s_win_Browse. /* parents dialog to browse window */
   run adedict/FLD/_renum.p.
end.

/*----- RENAME FIELDS ----- */
On choose of MENU-ITEM mi_Field_Rename in MENU s_mnu_Options
do:
   current-window = s_win_Browse. /* parents dialog to browse window */
   run adedict/FLD/_renam.p.
end.

/*----- ADJUST FIELD WIDTH-- */
On Choose of MENU-ITEM mi_SQL_Width in MENU s_mnu_Options
do:
   /* Have to do this first in case the window is already running and they *
    * made changes they haven't saved.                                     */
   DEF VAR err as LOG.
   IF s_win_Width <> ? THEN
      run adedict/_changed.p (INPUT {&OBJ_TBL}, yes, OUTPUT err). 
   IF ERR THEN
   DO:
      MESSAGE "An error occured in module" THIS-PROCEDURE:FILE-NAME "." SKIP
              "Please notify Progress Software Corporation" VIEW-AS ALERT-BOX
              ERROR BUTTONS OK.
      RETURN NO-APPLY.
   END.       
   RUN prodict/gui/_guisqlw.p.
end.

/*----- DATABASE MODE -----*/
On choose of MENU-ITEM mi_Mode_Db in MENU s_mnu_Options
   apply "mouse-select-down" to s_icn_Dbs in frame browse.

/*----- TABLES MODE -----*/
On choose of MENU-ITEM mi_Mode_Tbl in MENU s_mnu_Options
   apply "mouse-select-down" to s_icn_Tbls in frame browse.

/*----- SEQUENCES MODE -----*/
On choose of MENU-ITEM mi_Mode_Seq in MENU s_mnu_Options
   apply "mouse-select-down" to s_icn_Seqs in frame browse.

/*----- FIELD MODE -----*/
On choose of MENU-ITEM mi_Mode_Fld in MENU s_mnu_Options
   apply "mouse-select-down" to s_icn_Flds in frame browse.

/*----- INDEX MODE -----*/
On choose of MENU-ITEM mi_Mode_Idx in MENU s_mnu_Options
   apply "mouse-select-down" to s_icn_Idxs in frame browse.


/*===========================Help menu==================================*/

on choose of MENU-ITEM mi_Contents in MENU s_mnu_Help
   RUN "adecomm/_adehelp.p" ("dict", "TOPICS", ?, ?).

ON CHOOSE OF MENU-ITEM mi_Master IN MENU s_mnu_Help
   RUN "adecomm/_adehelp.p" ("mast", "TOPICS", ?, ?).

on choose of MENU-ITEM mi_messages in MENU s_mnu_Help
  RUN prohelp/_msgs.p.

on choose of MENU-ITEM mi_recent in MENU s_mnu_Help
  RUN prohelp/_rcntmsg.p.

on choose of MENU-ITEM mi_About in MENU s_mnu_Help
do:
   current-window = s_win_browse.
   run adecomm/_about.p ("Dictionary", "adeicon/dict%").
end.


/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: repname.i

Description:
   The name of a schema object has been changed.  Reflect this change in
   the appropriate selection list.
 
Arguments:
   &OldName - The old object name
   &NewName - The new object name.
   &List    - The list to change the name in.
   &Fill    - The fill-in associated with the list in the browse window.
   &Curr    - The current value variable for this object type.

Author: Laura Stern

Date Created: 04/24/92

----------------------------------------------------------------------------*/

Define var ret as integer.

/* 09-08-92 mikep fix for bug 92-09-01-118

*/

s_Res = {&List}:replace({&NewName}, {&OldName}) in frame browse.
if s_Res = no then 
do:
   ret = lookup({&OldName}, {&List}:list-items in frame browse).
   if ret > 0 then 
      s_Res = {&List}:replace({&NewName},  
                              entry(ret, {&List}:list-items in frame browse))
              in frame browse.
end.

if s_Res = yes then 
do:
    {&List}:screen-value in frame browse = {&NewName}.
    {&Curr} = {&NewName}.

    /* Note - we can't use display here.  We want to change the value of the
       widget whether it's visible right now or not.  Display will make it
       appear and we may not want it to. When it becomes visible we'll 
       see the change.
    */
    {&Fill}:screen-value in frame browse = {&NewName}.
end.

/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: setdirty.i

Description:
   Set s_DictDirty to the given value.  If dict is dirty, enable the undo
   and commit menu options.  Otherwise, gray them.
 
Arguments
   &Dirty - true/false.

Author: Laura Stern

Date Created: 03/27/92

----------------------------------------------------------------------------*/

do:
   s_DictDirty = {&Dirty}.

   MENU-ITEM mi_Undo:sensitive in MENU s_mnu_Edit = {&Dirty}.
   MENU-ITEM mi_Commit:sensitive in MENU s_mnu_Edit = {&Dirty}.
end.

/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: uivar.i

Description:
   Include file defining some common user interface components that are used
   in many places throughout the dictionary.

Author: Laura Stern

Date Created: 02/19/92 
----------------------------------------------------------------------------*/
 
Define button s_btn_OK     label "OK"     {&STDPH_OKBTN} AUTO-GO.
Define button s_btn_Cancel label "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.

/* The label on the Done button will change to "Close" after a
   change occurs that will not be undone (e.g., having added a table).
   These are used in the add dialogs.
*/
/* Added mnemonic for Create button 7/31/95 */
Define button s_btn_Add    label "&Create"  {&STDPH_OKBTN} AUTO-GO.
Define button s_btn_Done   label "Cancel"  {&STDPH_OKBTN} AUTO-ENDKEY.

/* The label on the Close button will change to "Close" after any 
   change occurs that will not be undone (e.g., a change in a sub-dialog).
   These are used for the property windows.
*/
Define button s_btn_Save   label "&Save"  {&STDPH_OKBTN}.
Define button s_btn_Close  label "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.

Define button s_btn_Next   label "&>" SIZE 4 BY {&H_OKBTN} margin-extra default.
Define button s_btn_Prev   label "&<" SIZE 4 BY {&H_OKBTN} margin-extra default.

Define button s_btn_Help   label "&Help"   {&STDPH_OKBTN}.

Define rectangle s_rect_Btns {&STDPH_OKBOX}.

/* "Blue bar" optional text */
define var s_Optional as char initial " Optional" {&STDPH_SDIV}
                              format "x(9)" view-as text.

/* Status line variable */
Define {1} var s_Status as char NO-UNDO.

/* The beginning of any "no permissions" messages. */
Define {1} var s_NoPrivMsg as char NO-UNDO
   init "You do not have permission to".

Define {1} var s_OK_Hit as logical NO-UNDO. /* to control OK processing */
Define {1} var s_Valid  as logical NO-UNDO. /* to control validation 
      	       	     	      	       	       for apply buttons */
Define {1} var s_Widget as widget-handle NO-UNDO. /* general widget handle */
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: uncache.i

Description:
   Clear out one of the browse window selection lists, reset the cached
   flag and set the s_Currxxx variable for a particular object type.

Arguments:
   &List    - The list to clear.
   &Cached  - The cached flag to reset
   &Curr    - The s_Currxxx variable to reset.

Author: Laura Stern

Date Created: 04/26/92 

----------------------------------------------------------------------------*/

/* Clear out the selection list */
{&List}:LIST-ITEMS in frame browse = "".

{&Cached} = false.
{&Curr} = "".
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _getflst.p

Description:
   Fill a selection list with fields.  The fields will be ordered either
   alphabetically or by order #.  The database that these fields are stored 
   in must be aliased to DICTDB before this routine is called.

Input Parameters:
   p_List   - Handle of the selection list widget to add to.
	      p_List:private-data is a comma seperated list of items
	      NOT to be added. OR no items if the entire table-list is
	      to be added.

   p_Recid  - The recid of the table to which these fields belong.
   p_usetbl = If not ? THEN use this table name instead of the actual.
   p_Alpha  - TRUE if order should be alphabetical, FALSE if we want to
      	      order by the _Order value of the field.
   p_Items  - List of fields to included in list.  If this parameter is
              blank, then just the field name is put in the list.  Currently
              the parameter can have the following values in any order:
              1 - just the field name - then is the default
              2 - tablename.fldname
              3 - dbname.tablename.fldname
              T - Name of table containing the field
              F - Format
   p_DType  - The data type to screen for.  If this is ?, then don't screen.
      	      Otherwise it will not select the type in the p_DType list.
      	       	  
   p_ExpandExtent  - 0  field name only for extent field
                     1  extented field name changed to fieldName[1-N].
                     2  extented field names are expanded

  p_CallBack  - The name of the program to run for security of a "" to blow
              this callback off.


Output Parameters:
   p_Stat   - Set to TRUE if list is retrieved (even if there were no fields
      	      this is successful).  Set to FALSE, if user doesn't have access
      	      to fields.

Original Author of adecomm/_getflst.p: Laura Stern, Warren Bare

This file created from original 01/30/2003 D. McMann for creating new indexes

adedict/_getflst.p

History:  10/17/03 DLM Add NO-LOCK statement to _Db find in support of on-line schema add

----------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p_List         AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p_Recid        AS RECID         NO-UNDO.
DEFINE INPUT  PARAMETER p_usetbl       AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p_Alpha        AS LOGICAL       NO-UNDO.
DEFINE INPUT  PARAMETER p_Items        AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p_DType        AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p_ExpandExtent AS INTEGER       NO-UNDO.
DEFINE INPUT  PARAMETER p_CallBack     AS CHARACTER     NO-UNDO.
DEFINE OUTPUT PARAMETER p_Stat         AS LOGICAL       NO-UNDO.

DEFINE BUFFER bField FOR DICTDB._Field.

DEFINE VARIABLE v_dbname  AS CHARACTER      NO-UNDO.
DEFINE VARIABLE err       AS LOGICAL        NO-UNDO.
DEFINE VARIABLE widg      AS widget-handle  NO-UNDO.
DEFINE VARIABLE v_ItemCnt AS INTEGER	       NO-UNDO.
DEFINE VARIABLE v_BldLine AS CHARACTER      NO-UNDO.
DEFINE VARIABLE lInclude  AS LOGICAL        NO-UNDO.
DEFINE VARIABLE i         AS INTEGER        NO-UNDO.
DEFINE VARIABLE fName     AS CHARACTER      NO-UNDO.
DEFINE VARIABLE sep       AS CHARACTER      NO-UNDO.

/************************* Inline code section ***************************/

IF INTEGER(DBVERSION("DICTDB":U)) > 8 THEN
  FIND DICTDB._File WHERE DICTDB._File._FILE-NAME = "_Field":u
                      AND LOOKUP(DICTDB._FILE._OWNER,"PUB,_FOREIGN":U) > 0
                     NO-LOCK.

ELSE
  FIND DICTDB._File "_Field":u NO-LOCK.

IF NOT CAN-DO(DICTDB._File._Can-Read,USERID("DICTDB":u)) THEN DO:
  MESSAGE "You do not have permission to see any field information.":t
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  p_Stat = FALSE.
  RETURN.
END.

/* This is where we find other buffer information that may be needed */
FIND DICTDB._File WHERE RECID(DICTDB._FILE) = p_Recid.
FIND DICTDB._DB WHERE RECID(DICTDB._DB) = _File._DB-recid NO-LOCK.

IF p_Items = "" THEN p_Items = "1":u.

v_dbname = IF _db._db-name NE ? THEN _db._db-name ELSE ldbname("DICTDB":u).

ASSIGN
  widg = p_List:parent 	/* gives me the group */
  widg = widg:parent.  	/* gives me the frame */

RUN adecomm/_setcurs.p ("WAIT":u).

IF p_Alpha THEN DO:
  IF p_DType = ? THEN
    FOR EACH DICTDB.bField 
      WHERE DICTDB.bField._File-Recid = p_Recid 
       AND CAN-DO(DICTDB.bField._Can-Read,USERID("DICTDB":u)) NO-LOCK
      BY DICTDB.bField._Field-Name:
      {adecomm/fldlist.i}
    END.
  ELSE
    FOR EACH DICTDB.bField 
      WHERE DICTDB.bField._File-Recid = p_Recid 
      	 AND INDEX(p_Dtype, bField._Data-Type) = 0 
        AND CAN-DO(DICTDB.bField._Can-Read,USERID("DICTDB":u)) NO-LOCK
      BY DICTDB.bField._Field-Name:
      {adecomm/fldlist.i}
    END.
END.
ELSE DO:
  IF p_DType = ? THEN
    FOR EACH DICTDB.bField 
      WHERE DICTDB.bField._File-Recid = p_Recid  
        AND CAN-DO(DICTDB.bField._Can-Read,USERID("DICTDB":u)) NO-LOCK
      BY DICTDB.bField._Order:
      {adecomm/fldlist.i}
    END.
  ELSE
    FOR EACH DICTDB.bField 
      WHERE DICTDB.bField._File-Recid = p_Recid 
        AND INDEX(p_Dtype, bField._Data-Type) = 0 
        AND CAN-DO(DICTDB.bField._Can-Read,USERID("DICTDB":u)) NO-LOCK
      BY DICTDB.bField._Order:
      {adecomm/fldlist.i}
    END.
END.

RUN adecomm/_setcurs.p ("").
p_Stat = TRUE.

RETURN.

/* _getflst.p - end of file */

?adedict/DB/_connect.p?%   &?  sR?ʾR??!        ?adedict/DB/_dbprop.p??  ??  ?R?ʾR??!        ?adedict/DB/_dconn.p??  '??  ?R?ʾR??!        ?adedict/DB/_getdbs.p??  0>?  ?R?ʾR??!        ?adedict/DB/_getrdbs.p?   >??  ?R?ʾR??!        ?adedict/DB/_newdb.p?.  F??  gR?ʾR??!        ?adedict/DB/_switch.p?  L?  ?R?ʾR??!        ?adedict/DB/cachedb.i,   h?  &R?ʾR??!        ?adedict/DB/dbprop.f?P  l??  ?R?ʾR??!        ?adedict/DB/dbvar.ip?  u?  ?R?ʾR??!        ?                        ?adedict/DB/_savdbprop.p  z??  
#R?ʾR??!        ?adedict/FLD/_dfltfmt.p	*  ??  ,R?ʾR??!        ?adedict/FLD/_dfltgat.p %  ?9?  R?ʾR??!        ?adedict/FLD/_domprop.p4d  ?:?  	*R?ʾR??!        ?adedict/FLD/_dtcust.p??  ?d?  
eR?ʾR??!        ?adedict/FLD/_fldcopy.p?3  ???  <?R?ʾR??!        ?adedict/FLD/_fldfmts.p?#  ???  ._R?ʾR??!        ?adedict/FLD/_fldgate.pK? %??  W?R?ʾR??!        ?adedict/FLD/_fldprop.p?? }??  ?R?ʾR??!        ?adedict/FLD/_fldval.p; ???  5R?ʾR??!        ?  ?adedict/FLD/_newfld.p ??  ??R?ʾR??!        ?adedict/FLD/_ptinlst.p?< ???  ?R?ʾR??!        ?adedict/FLD/_renam.p? F??  '?R?ʾR??!        ?adedict/FLD/_renum.pc? n??  MR?ʾR??!        ?adedict/FLD/_savedom.p? ???  
?R?ʾR??!        ?adedict/FLD/_savefld.pn" ???  jR?ʾR??!        ?adedict/FLD/_sqlwptr.p'? ???  ?R?ʾR??!        ?adedict/FLD/_valgate.pP? ???  7R?ʾR??!        ?adedict/FLD/dtwidth.i?1 ??  %R?ʾR??"        ?adedict/FLD/fdprop.iiW ?>?  U?R?ʾR??"        ?         ?adedict/FLD/fldprop.f/? ??  ?R?ʾR??"        ?adedict/FLD/fldvar.i? 6??  R?ʾR??"        ?adedict/FLD/setdflts.i?' O??  );R?ʾR??"        ?adedict/FLD/blobvar.i?v x??  dR?ʾR??"        ?adedict/FLD/clobvar.i? ?\?  _R?ʾR??"        ?adedict/FLD/lob-misc.i?. ???  ?R?ʾR??"        ?adedict/FLD/_fldint64.p? ???  R?ʾR??"        ?adedict/IDX/_idxprop.p?E ?X?  ,?R?ʾR??"        ?adedict/IDX/_newidx.p?? ???  ?2R?ʾR??"        ?adedict/IDX/_saveidx.py? j/?  #?R?ʾR??"        ?      ?adedict/IDX/idxprop.f?T ???  rR?ʾR??"        ?adedict/IDX/idxvar.i?$ ?Y?  
>R?ʾR??"        ?adedict/IDX/idxvar2.i ???  ?R?ʾR??"        ?adedict/IDX/newidx.f?" ??  ?R?ʾR??"        ?adedict/SEQ/_newseq.p? ???  ?R?ʾR??"        ?adedict/SEQ/_saveseq.p?? ???  ?R?ʾR??"        ?adedict/SEQ/_seqprop.p=d ???  jR?ʾR??"        ?adedict/SEQ/seqprop.f? ?7?  ?R?ʾR??"        ?adedict/SEQ/seqtrig.i?? ??  ?R?ʾR??"        ?adedict/SEQ/seqvar.i#n O?  #R?ʾR??"        ?            ?adedict/TBL/_newtbl.p?? r?  3CR?ʾR??"        ?adedict/TBL/_savetbl.p?? Q??  4R?ʾR??"        ?adedict/TBL/_tblprop.p?o f??  *?R?ʾR??"        ?adedict/TBL/_tblsas.pt? ?v?  ?R?ʾR??"        ?adedict/TBL/_tblval.pi ??  ?R?ʾR??"        ?adedict/TBL/nexttbl.i?? ???  ?R?ʾR??"        ?adedict/TBL/tblprop.f?? ???  ?R?ʾR??"        ?adedict/TBL/tblvar.ik? ?v?  ?R?ʾR??#        ?adedict/TRIG/_trigdlg.p?B ?j?  z?R?ʾR??#        ?adedict/_blnknam.p2? T,?  ?R?ʾR??#        ?           ?adedict/_brwadj.p[? Z?  0?R?ʾR??#        ?adedict/_brwbtn.p%? ???  ?R?ʾR??#        ?adedict/_brwgray.p? ?z?  7#R?ʾR??#        ?adedict/_brwlist.ph: ӝ?  R?ʾR??#        ?adedict/_btnup.p]? ???  :R?ʾR??#        ?adedict/_capab.p?? ???  %R?ʾR??#        ?adedict/_changed.p?? ?  :?R?ʾR??#        ?adedict/_closwin.p>^ =??  nR?ʾR??#        ?adedict/_dcttran.p?? E?  "R?ʾR??#        ?adedict/_delete.p?7 g/?  ,?R?ʾR??#        ?adedict/_delwins.p? ???  ?R?ʾR??#        ? ?adedict/_dictfdb.pI? ???  jR?ʾR??#        ?adedict/_dictg.p	G ??  ^bR?ʾR??#        ?adedict/_isdata.iɧ ?v?  ?R?ʾR??#        ?adedict/_leavnam.p?? a?  	?R?ʾR??#        ?adedict/_newobj.p?x ??  HR?ʾR??#        ?adedict/_nextobj.p?? >?   pR?ʾR??#        ?adedict/_objsel.p?y 5??  5+R?ʾR??#        ?adedict/_openwin.p?? j??  ?R?ʾR??#        ?adedict/_setid.p=; w??  
R?ʾR??#        ?adedict/browse.f?? ???  ?R?ʾR??#        ?adedict/brwtrig.i3? ?S?  8R?ʾR??#        ?    ?adedict/brwvar.i9z ?[?  
?R?ʾR??#        ?adedict/capab.i?? ?L?  bR?ʾR??#        ?adedict/delwin.i?? ???  ?R?ʾR??#        ?adedict/dictghlp.i)? ?W?  ~R?ʾR??#        ?adedict/dictvar.i8 ???  2?R?ʾR??#        ?adedict/edittrig.i&? 	+W?  {?R?ʾR??#        ?adedict/forceval.i?? 	?3?  PR?ʾR??#        ?adedict/gateproc.i(? 	???  ?R?ʾR??#        ?adedict/ispro.i?Y 	?s?  SR?ʾR??#        ?adedict/menu.i>? 	???  ?R?ʾR??$        ?adedict/menutrig.i?? 	?N?  Z?R?ʾR??$        ?         ?adedict/repname.i?: 
*#?  JR?ʾR??$        ?adedict/setdirty.i? 
1m?  ?R?ʾR??$        ?adedict/uivar.i?% 
5J?  	?R?ʾR??$        ?adedict/uncache.i(? 
?!?  R?ʾR??$        ?adedict/_getflst.pP? 
C7?  -R?ʾR??$        ? ?    d                   ?                                                                                                                                                                                                                                                            