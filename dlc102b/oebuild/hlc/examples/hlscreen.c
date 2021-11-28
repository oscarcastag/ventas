#include        "hlc.h"

char    *msgbuf = " hello \n world ";
#define MSGLEN     15

int
example1(argc, argv)

	int             argc;
	char   *argv[];

{

	/*

	  Example to show problems with raw versus cooked screen I/O

    */
      proclear();

      write(1, msgbuf, MSGLEN);

      promsgd("First in raw mode - note how the second line");
      promsgd("starts under the end of the first line.");
      promsgd("Now we clear the screen, reopen the terminal in cooked mode, ");
      promsgd("and write out the same string again.");
      sleep(3);
      proclear();
      proscopn();  /* reopen in cooked mode */

      write(1, msgbuf, MSGLEN);

      promsgd("Notice the difference.");
      prosccls( 0 );  /* restore to raw mode, nothing to restore */

      return 0;
}

int
example2(argc, argv)

	int             argc;
	char   *argv[];

{
	int             i;


	proscopn();  /*  Switch to cooked mode.  */
	proclear();  /*  Clear screen.           */

	for (i = 0; i < 15; ++i)
		write(1, msgbuf, MSGLEN);

	promsgd("Now the frame will be explicitly cleared with proclear.."); 
	promsgd("...AND restored by calling prosccls with non-zero argument.");
	sleep(5);

	proclear();  /*  To clear screen output from C program.  */
	prosccls(1 /* refresh */ );

	promsgd("Did the frame refresh?  Note how the ");
	promsgd("PUT SCREEN display did not refresh.");

}
