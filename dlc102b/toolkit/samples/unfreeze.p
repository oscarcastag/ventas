/* unfreeze.p */
/* Procedure to unfreeze db-files before making db-changes  */

/* Choose one of the cases below  */

/* Case 1:  Unfreeze all files */

for each _file where _file-number > 0 
                 AND _tbl-type = "T"
                 AND (_Owner = "PUB" OR _Owner = "_Foreign"):
    _frozen = false.
end.

/*
/* Case 2: Unfreeze specific files  */

find _file "myfile1".
_frozen = false.
find _file "myfile2".
_frozen = false.

*/
