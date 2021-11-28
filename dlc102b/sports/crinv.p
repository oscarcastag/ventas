/***************************************************************************\
*****************************************************************************
**
**     Program: crinv.p
**    Descript:
**
*****************************************************************************
\***************************************************************************/

TRIGGER PROCEDURE FOR Create OF Invoice.

/* Automatically increment Invoice Number using Next-Inv-Num Sequence */

ASSIGN invoice.invoice-num = NEXT-VALUE(NEXT-INV-NUM).
