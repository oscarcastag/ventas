/* restrict.p */
define variable Selection as integer format "9".
define variable deny-update as logical label "Deny Updates".
define variable deny-query as logical label "Deny Queries".
define variable confirm as logical.
define variable cur-file like _File._File-name label "File".
repeat:
    selection = 0.
    form
	space(14) "Database Restriction Utility"
	skip(1) "This utility lets you make IRREVOCABLE changes to"
	skip(0) "EVERYONE's ability to modify or query database files."
	skip(0) "Before doing this, you should:"
	skip(1) space(10) "- make a copy of the database"
	skip(0) space(10) "- precompile all procedures"
	skip(1) space(3) "Deny (except for precompiled procedures):"
	skip(1) "1. Update access and/or query access to all current files."
	skip(0) "2. Update access and/or query access to individual files."
	skip(0) "3. Addition of new files to the database."
	skip(1) space(20) selection with side-labels column 10.

    set selection auto-ret.
    if input selection = " "
    then next.

    form cur-file
	skip(1) "1. Deny updates"
	skip(0) "2. Deny updates and queries"
	skip(0) "3. Leave current restrictions"
	skip(0) "   unchanged."
	skip(1) selection with frame Rchoice side-labels.

    if selection = 1
    then
    do:
	cur-file = "All".
	display cur-file selection with frame Rchoice.
	set selection auto-ret with frame Rchoice.
	if selection = 1 or selection = 2
	then
	    for each _file where _file-number > 0:
		if   _can-create <> "!root"
		then _can-create  = "!root".
		if   _can-write  <> "!root"
		then _can-write   = "!root".
		if   _can-delete <> "!root"
		then _can-delete  = "!root".
		if selection = 2 and _can-read <> "!root"
		then _can-read = "!root".
	    end.
	else if selection <> 3 then message "Invalid choice".
    end.
    else if selection = 2
    then
    do:
	for each _file where _file-number > 0:
	    deny-update = _can-create = "!root"
		    and   _can-write  = "!root"
		    and   _can-delete = "!root".
	    deny-query =  _can-read   = "!root".
	    display _file-name deny-update deny-query with column 42.
	    if deny-update and deny-query
	    then next.
	    cur-file = _file-name.
	    selection = 1.
	    display cur-file selection with frame Rchoice.
	    set selection auto-ret with frame Rchoice.
	    if selection = 1 or selection = 2
	    then
	    do:
		deny-update = yes.
		if   _can-create <> "!root"
		then _can-create  = "!root".
		if   _can-write  <> "!root"
		then _can-write   = "!root".
		if   _can-delete <> "!root"
		then _can-delete  = "!root".
		if selection = 2 and _can-read <> "!root"
		then
		do:
		    _can-read = "!root".
		    deny-query = yes.
		end.
		display deny-update deny-query.
	    end.
	    else if selection <> 3
	    then
	    do:
		message "Please make a valid choice".
		undo, retry.
	    end.
	end.
    end.
    else if selection = 3
    then
    do:
	confirm = no.
	message "Are you sure you want to deny adding files?"
	    update confirm.
	if confirm
	then
	do for _file:
	    find _file "_file".
	    if   _can-create <> "!root"
	    then _can-create  = "!root".
	end.
    end.
    else message "Please make a valid choice.".
end.
quit.
