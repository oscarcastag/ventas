#include "hlc.h"

subvwt()
{
    int     ret, index, var, unknown, year, month, day;
    char    buffer[30];
    int     varlen = 30, actlen;
    long    longvar;
    char    message[80];

    year = 0;
    month = 0;
    day = 0;
    longvar = 0;
    index = 0;

    /* First, set all g- variables to unknown */
    unknown = 1;
    var = 0;

    /* g-boolean */
    if (ret = prowtl("g-boolean", index, var, unknown))
    {
	sprintf(message,"prowtl fatal ret %d", ret);
        promsgd(message);
    }

    /* g-integer */
    if (ret = prowti("g-integer", index, longvar, unknown))
    {
	sprintf(message,"prowti fatal ret %d", ret);
        promsgd(message);
    }

    /* g-date */
    if (ret = prowtd("g-date", index, year, month, day, unknown))
    {
	sprintf(message,"prowtd fatal ret %d", ret);
        promsgd(message);
    }

    /* g-char */
    if (ret = prowtc("g-char", index, buffer, unknown))
    {
	sprintf(message,"prowtc fatal ret %d", ret);
        promsgd(message);
    }

    /* g-decimal */
    if (ret = prowtn("g-decimal", index, buffer, unknown))
    {
	sprintf(message,"prowtn fatal ret %d", ret);
        promsgd(message);
    }

    /* g-recid */
    if (ret = prowtr("g-recid", index, longvar, unknown))
    {
	sprintf(message,"prowtr fatal ret %d", ret);
        promsgd(message);
    }

    /* 
       next, set s- variables to:
      
       boolean:   no
       integer:   -233
       date:      12/7/41
       char:      didtest
       decimal:   -2.007
       recid:     2
    */   

    /* s-boolean */
    unknown = 0;
    var = 0;
    if (ret = prowtl("s-boolean", index, var, unknown))
    {
	sprintf(message,"prowtl fatal ret %d", ret);
        promsgd(message);
    }

    /* s-integer */
    longvar = -233L;
    if (ret = prowti("s-integer", index, longvar, unknown))
    {
	sprintf(message,"prowti fatal ret %d", ret);
        promsgd(message);
    }

    /* s-date */
    year = 1941; month = 12; day = 7;
    if (ret = prowtd("s-date", index, year, month, day, unknown))
    {
	sprintf(message,"prowtd fatal ret %d", ret);
        promsgd(message);
    }

    /* s-char */
    p_stcopy(buffer, "didtest");
    if (ret = prowtc("s-char", index, buffer, unknown))
    {
	sprintf(message,"prowtc fatal ret %d", ret);
        promsgd(message);
    }

    /* s-decimal */
    p_stcopy(buffer, "-2.007");
    if (ret = prowtn("s-decimal", index, buffer, unknown))
    {
	sprintf(message,"prowtn fatal ret %d", ret);
        promsgd(message);
    }

    /* s-recid */
    longvar = 2L;
    if (ret = prowtr("s-recid", index, longvar, unknown))
    {
	sprintf(message,"prowtr fatal ret %d", ret);
        promsgd(message);
    }

    return 0;
}
