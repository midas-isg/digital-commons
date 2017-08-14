export PG=/Library/PostgreSQL/9.6/bin
$PG/psql -d $2 -p$1 -U postgres < $3
