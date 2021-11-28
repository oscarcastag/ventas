#define FUNCTEST(nam, rout)  \
        if (strcmp((nam), (pfunnam)) == 0) \
	    return rout(argc,argv);

/* PROGRAM: PRODSP
 * 
 * Purpose:
 *    Dispatch routine for CALL statement
 *
 */

int
PRODSP(pfunnam, argc, argv)

     char   *pfunnam;    /* Name of function to call */
     int     argc;
     char   *argv[];

{
    /* Use the FUNCTEST macro to set up the calls to your
     * C programs, e.g, if you want CALL FOO to call the
     * entry point mytrig(), say:
     *
     *   FUNCTEST("FOO", mytrig);
     */


    promsgd("Call Statement Failed");
    return 1;
}
  
