/*   File:   hlprodsp.c               */

#define FUNCTEST(nam, rout)  \
        if (strcmp(nam, pfunnam) == 0) \
	    return rout(argc,argv);

/* PROGRAM: PRODSP
 * 
 *   This is the interface to all C routines that 
 *   PROGRESS has associated 'call' statements to.   
 */

long
PRODSP(pfunnam, argc, argv)

     char   *pfunnam;    /* Name of function to call */
     int     argc;
     char   *argv[];

{
/* Interface to installation test */
    FUNCTEST( "SUBVRD", subvrd)
    FUNCTEST( "SUBVWT", subvwt)
    FUNCTEST( "SUBFRD", subfrd)	
    FUNCTEST( "SUBFWT", subfwt)
    FUNCTEST( "SUBFIX", subfix)
    FUNCTEST( "SUBVIX", subvix)	
    FUNCTEST( "SUBARG", subarg) 
    FUNCTEST( "SUBCLR", subclr) 
    FUNCTEST( "SUBCLS", subcls) 
    FUNCTEST( "SUBINT", subint)
/* Interface to 'screen' examples */
    FUNCTEST ("EXAMPLE1", example1);
    FUNCTEST ("EXAMPLE2", example2);
/* Interface to 'tank' example  */
    FUNCTEST ("AVCALC", hlvcalc);

    return 1;
}
