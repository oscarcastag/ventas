/* upgrade.p */
/* Start-up procedure for upgrading a run-time db with new db-definitions */

/* Step 1: Supply userid and password for security-administrator  */
display "Loading ..." with no-box.
run loginupg.p.

/* Step 2: Unfreeze db-files  */
run unfreeze.p.

/* Step 3: Load new and changed definitions */

output to  upgrade.log .
RUN prodict/load_df.p ("upgrade.df").

/* Step 4: Freeze db-files  */

run freeze.p.
quit.
