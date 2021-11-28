/*    HLC Example    hlscreen.p      */

display
   "This example shows the display differences between" skip(0)
   "'raw' and 'cooked' i/o mode using the string 'hello ~\n world'." skip(0)
      with centered title "Example #1" frame one row 3.
pause.
hide all.
call example1.
pause.
hide all.
display "This second test illustrates that output from" skip (0)
	"a 'PUT SCREEN' will not be refreshed as a result of"  skip(0)
	"restoring the screen to raw mode via the 'prosccls'" skip(0)
	"HLC library command.  A High Level Call is made to a C " skip(0)
	"routine which writes data to the screen and then returns " skip(0)
	"to PROGRESS. Prior to this call, output will be placed on" skip(0)
	"the screen by 'DISPLAY' and 'PUT SCREEN' statements."
	with  row 3 frame two title
	"Example #2" centered.
hide all.
display "This frame should be refreshed." with frame refresh row 8 centered.
put screen row 15 "This PUT SCREEN string will not be refreshed.".
pause.
call example2.
