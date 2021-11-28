
/* global shared variables */
define new global shared variable g-boolean as logical init "yes".
define new global shared variable g-integer as integer init 10.
define new global shared variable g-date as date init 7/25/49.
define new global shared variable g-char as char init "hlctest".
define new global shared variable g-decimal as decimal init 3.14.
define new global shared variable g-recid as recid init 7.

/* nonglobal shared variables */
define new shared variable s-boolean as logical init "yes".
define new shared variable s-integer as integer init 10.
define new shared variable s-date as date init 7/25/49 format "99/99/9999".
define new shared variable s-char as char init "hlctest".
define new shared variable s-decimal as decimal init 3.14.
define new shared variable s-recid as recid init 7.

output to hlcout.

/*  Init block - since 'init' in define statement doesn't */
/*  reset GLOBAL SHARED variables.                        */

g-boolean =  yes.
g-integer = 10.
g-date = 7/25/49.
g-char = "hlctest".
g-decimal = 3.14.
g-recid = 7.

/* first, see if we can read these variables */
run subvrd.p.

/* next, see if we can set these variables */
run subvwt.p.

display g-boolean
	g-integer
	g-date
	g-char
	g-decimal
	g-recid
with 1 column frame x.

display s-boolean
	s-integer
	s-date
	s-char
	s-decimal
	s-recid
with 1 column frame y.

/* now, read and set some shared buffers */
def new shared buffer custbuf for customer.
def new shared buffer monthbuf for monthly.
def new shared buffer agebuf for agedar.

find first custbuf.
find first monthbuf.
find first agebuf.

/* see if we can read them */
run subfrd.p.

/* see if we can set them */
run subfwt.p.

/* now display them */
display custbuf.cust-num
	custbuf.name
	custbuf.max-credit
	agebuf.ar_invdat
	monthbuf.tf_print with 1 column frame xx.

/* now test array handling */
def new shared var iarray as int init ? extent 12.

/* read them and set to 1,...,12 */
run subvix.p.

display iarray with frame ix.

/* set the mnthly-sales array in custbuf */
run subfix.p.
display custbuf.mnth-sales with frame idx.

/* test argc, arv feature */
call SUBARG "one" "two" "three".
message ".....end of output test...".

/* test screen closing, clearing, reopening */
output to terminal.
message "We should now clear the screen and refresh using C rtn. " .
display "This screen will be refreshed. "
	  with row 5 frame scrtest1.
pause.
call SUBCLR.
call SUBCLS.
message "Back from c program.....".
