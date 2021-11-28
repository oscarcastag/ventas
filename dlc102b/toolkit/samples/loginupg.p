/* login.p - prompt user for userid and password and set the userid */

DEFINE VARIABLE id       LIKE _user._USERID.
DEFINE VARIABLE password LIKE _user._PASSWORD.

DO ON ENDKEY UNDO, RETURN:  /*return if they hit endkey*/
    set id = "sysadm" password = "topsecret".

    IF SETUSERID(id,password) = FALSE
    THEN DO:
       MESSAGE "Sorry, userid/password is incorrect.".
       QUIT.
    END.
    RETURN.
END.
QUIT.
