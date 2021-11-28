/***************************************************************************\
*****************************************************************************
**
**     Program: crord.p
**    Descript:
**
*****************************************************************************
\***************************************************************************/

TRIGGER PROCEDURE FOR Create OF Order.

/* Automatically Increment Order-Number using Next-Ord-Num Sequence */

ASSIGN  order.order-num =  NEXT-VALUE(Next-Ord-Num) 

/* Generate a unique PO using USERID ( If no USERID, use "PO" ) */

order.po = (IF USERID("sports") = "" THEN "PO" ELSE USERID("sports"))
           + STRING(TODAY,"999999") + STRING(Order.Order-Num)

/* Set Order Date to TODAY,  Promise Date to 2 weeks from TODAY */

order.order-date = TODAY
order.promise-date = TODAY + 14.
