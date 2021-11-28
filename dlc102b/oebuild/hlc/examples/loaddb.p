hide all.
display  skip(2)
	"  *********   LOADING the database ********* " skip(1)
	"  *********    please stand by............."
	with title "WELCOME TO HLC DEMO PROGRAM" row 5 centered frame hdr.
output to hldemout.
run prodict/load_df.p ("customer.df").
run prodict/load_df.p ("agedar.df").
run prodict/load_df.p ("monthly.df").
run prodict/load_df.p ("tank.df").
/* create signal file to indicate success */
if opsys = "unix" then do:
   unix  cat >hlcsigfile & .
end.
hide all.
