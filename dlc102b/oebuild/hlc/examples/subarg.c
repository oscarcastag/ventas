int
subarg(argc,argv)

int	argc;
char   *argv[]; 

{
	int	i;
        char    message[80];

	for (i = 1; i < argc; ++i)
        {
	     sprintf(message,"%d argument is %s", i, argv[i]);
             promsgd(message);
        }
	return 0;
}
