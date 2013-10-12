mdb-tables -1 .mdb | xargs -n1 mdb-export -H -I .mdb >export.sql

# mdb-tables - will list the tables in database (-1 will make sure they are one per line)
# xargs with -n1 will force xargs to use one argument at a time, which is the only way mdb-export accepts 
# mdb-export -H will suppress Headers, -I   to export as Insert rather than csv
# output redirection will create a single file for you.
