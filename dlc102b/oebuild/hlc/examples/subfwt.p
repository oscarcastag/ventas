define shared buffer custbuf for customer.
define shared buffer monthbuf for monthly.
define shared buffer agebuf for agedar.

do transaction:
call SUBFWT.
end.
