/* freeze.p */
/* Procedure to freeze db-files after making db-changes  */

/* Choose one of the cases below  */

/* Case 1:  Freeze all files */

for each _file where _file-number > 0 
                 AND _tbl-type = "T"
                 AND (_Owner = "PUB" OR _Owner = "_Foreign"):
    _frozen = true.
end.

/*
/* Case 2: Freeze specific files  */

find _file "myfile1".
_frozen = true.
find _file "myfile2".
_frozen = true.

*/
