/***************************************************************************\
*****************************************************************************
**
**     Program: delord.p
**    Descript:
**
*****************************************************************************
\***************************************************************************/

TRIGGER PROCEDURE FOR Delete OF Order-Line.

/* Trigger provides an information message when order-lines are deleted */

MESSAGE "Deleting Order Line:" Line-num "Order Num:" Order-Num
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
