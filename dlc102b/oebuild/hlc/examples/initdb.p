
/*  Initialize database.   */

/*  First clean out database (in case not first time)  */

for each customer.
delete cust.
end.
for each monthly.
delete monthly.
end.
for each agedar.
delete agedar.
end.
for each tank.
delete tank.
end.

/*  Now read in initial values.  */

message "INITIALIZING DATABASE...please standby....".
output to hldata.
run prodict/load_d.p ("ALL","").
/* create signal file to indicate success */
if opsys = "unix" then do:
   unix  cat >hlcsigfile & .
end.
hide all.
output close.
output to terminal.
