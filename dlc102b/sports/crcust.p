/***************************************************************************\
*****************************************************************************
**
**     Program: crcust.p
**    Descript:
**
*****************************************************************************
\***************************************************************************/

TRIGGER PROCEDURE FOR Create OF Customer.

/* Automatically Increment Customer Number using Next-Cust-Num Sequence */

ASSIGN Customer.Cust-Num = NEXT-VALUE(Next-Cust-Num).
   
