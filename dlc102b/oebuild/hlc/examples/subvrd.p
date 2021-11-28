/* global shared variables */
define shared variable g-boolean as logical init "yes".
define shared variable g-integer as integer init 10.
define shared variable g-date as date init 7/25/49.
define shared variable g-char as char init "hlctest".
define shared variable g-decimal as decimal init 3.14.
define shared variable g-recid as recid init 7.

/* nonglobal shared variables */
define shared variable s-boolean as logical init "yes".
define shared variable s-integer as integer init 10.
define shared variable s-date as date init 7/25/49.
define shared variable s-char as char init "hlctest".
define shared variable s-decimal as decimal init 3.14.
define shared variable s-recid as recid init 7.

call SUBVRD.

