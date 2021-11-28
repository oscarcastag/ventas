/*    HLC Example Menu    */

run loaddb.p.

/***********   BEGIN examples  *******************/

input from terminal.
output to terminal.
define var answer as char format "9".
define var choice as char init "1,2,3,4".
define var last1 as log init yes.
define var last2 as log init yes.


form   skip(4)
       space (4)
	 "  1  -   Installation Test" skip(1) space(4)
	 "  2  -   TANK Capacity Calculation demo  "  skip(1) space(4)
	 "  3  -   Screen raw/cooked demo " skip (1)   space(4)
	 "  4  -   Exit Session" skip(2) space(4)
	 " Enter example selection ===> "  answer no-label
	      with centered title " EXAMPLE MENU " frame example.

form last1 last2 with frame lastcheck.

repeat.
  hide all.
  update answer auto-return
  validate(lookup(answer,choice) <> 0,"Enter one of choices displayed.")
     with frame example.
  hide all.


  if answer = "1" then
   do:
/*  Check to see if need to reinitialize database.  */
    if last1 then
    do:
       last1 = yes.
       last2 = no.
       run initdb.p.
       hide all.
    end.
    last1 = yes.
    run hltest.p.
   end.
   else if answer = "2" then
     do:
/*  Check to see if need to reinitialize database.  */
      if last2 then
      do:
	 last2 = yes.
	 last1 = no.
	 run initdb.p.
	 hide all.
      end.
      last2 = yes.
      run hltank.p.
     end.
    else if answer = "3" then
	  run hlscreen.p.
    else if answer = "4" then
	  quit.
end.
hide all.
quit.
