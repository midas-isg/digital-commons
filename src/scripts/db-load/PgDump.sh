export PG=/Library/PostgreSQL/9.6/bin
$PG/pg_dump --port $1 --username "postgres" --format plain --file "$2.$3.dump" --schema "$3" "$2"
