/*           HLC example hltank.p                       */

form    skip(3)
space(4)
"  This example is used to calculate available volume      "
 skip(0) space(4)
"  for each tank record stored in a database file.         "
 skip(0) space(4)
"  Since the formula used to perform this calculation      "
 skip(0) space(4)
"  requires trigonometric functions, we will create a      "
 skip(0) space(4)
"  C program to access these functions from the C library. "
skip(3)
 with centered title "TANK Capacity Calculation Demo"
 row 5
 overlay frame tankhdr.

form
"  First, PROGRESS is used to display each record in "
skip(0)
"  the tank file to illustrate the '?' value in the "
skip(0)
"  'tavail' field.  Then C is called to calculate each "
skip(0)
"  'tavail' and update the 'tavail' field.  PROGRESS is"
skip(0)
"  then used to display each computed record."
 with centered title "Before Call to C Program"
 row 10
 overlay frame tank-before.

form
 "  Notice 'tavail'  now contains a numeric value."
skip(0)
 "  This is a result of calling the C program."
with centered title "Return from C program"
row 15
overlay frame tank-after.


/*  Set-up:  To enable this to be selected multiple times       */
/*           of demo menu, need to initialize database.         */


for each tank.
    tavail = ?.
end.

/*  1.  Create a buffer to access the file from the C program.  */

define new shared buffer tankbuf for tank.

/*  2.  Iterate through the file getting one record at a time */
/*      to process in the C program.                          */

view frame tankhdr.
hide all.

for each tankbuf:
   display
	 radius space(3) tlength space(3) depth space(3) tavail
	 with centered title "Tank File".
end.
pause 0.
view frame tank-before.
hide all.

for each tankbuf:
   do transaction:
       call AVCALC.
   end.
   display
	 radius space(3) tlength space(3) depth space(3) tavail
	 with centered title "After Calculation".
end.
pause 0.
view frame tank-after.

output to tank.out.
for each tankbuf:
   do transaction:
       call AVCALC.
   end.
   display
	 radius space(3) tlength space(3) depth space(3) tavail
	 with centered title "After Calculation".
end.
output close.
