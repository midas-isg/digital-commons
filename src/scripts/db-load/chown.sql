DO $$DECLARE r record;
BEGIN
	SET SCHEMA 'prod';

    -- for tables and sequences
    FOR r IN SELECT tablename FROM pg_tables
    WHERE NOT schemaname IN ('pg_catalog', 'information_schema')
    AND schemaname = 'prod'
    LOOP
        EXECUTE 'ALTER TABLE '|| r.tablename ||' OWNER TO prod;';
    END LOOP;

    -- for views
    FOR r IN SELECT table_name FROM information_schema.views
    WHERE NOT table_schema IN ('pg_catalog', 'information_schema')
    AND table_schema = 'prod'
    LOOP
        EXECUTE 'ALTER VIEW '|| r.table_name ||' OWNER TO prod;';
    END LOOP;

END$$;