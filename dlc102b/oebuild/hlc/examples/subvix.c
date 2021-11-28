#include "hlc.h"

subvix()
{
    int     ret, index, var, unknown;
    long    longvar;
    char    message[80];

    /* first, check that all 12 are unknown */

    for (index = 1; index <= 12; ++index)
    {
        if (ret = prordi("iarray", index, &longvar, &unknown))
         {
            sprintf(message,"prordi fatal ret = %d unknown %d", ret, unknown);
            promsgd(message);
         }
        if (!unknown)
         {
            sprintf(message,"iarray index %d was not unknown", index);
            promsgd(message);
         }
    }

    unknown = 0;
    /* now set them to 1 to 12 */
    for (index = 1; index <= 12; ++index)
    {
	longvar = (long) index;
	if (ret = prowti("iarray", index, longvar, unknown))
         {
	    sprintf(message," prowti fatal ret %d", ret);
            promsgd(message);
         }
    }
    return 0;
}
