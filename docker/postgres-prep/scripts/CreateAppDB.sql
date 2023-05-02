-- This script creates the POSTGRES_APP_DB database and POSTGRES_APP_USER user if they do not exist.
-- This script must be run as the postgres administrator user.

SELECT 'CREATE DATABASE POSTGRES_APP_DB '
'WITH '
'ENCODING = ''UTF8'' '
'CONNECTION LIMIT = -1 '
'IS_TEMPLATE = False'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'POSTGRES_APP_DB')\gexec
;

-- We need this uuid extension (in public schema) so we can default the creation of a uuid value on insert
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

\connect POSTGRES_APP_DB

do $$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles
      WHERE  rolname = 'POSTGRES_APP_USER') THEN
      BEGIN
        CREATE ROLE "POSTGRES_APP_USER" WITH
            LOGIN
            NOSUPERUSER
            NOCREATEDB
            NOCREATEROLE
            INHERIT
            NOREPLICATION
            NOBYPASSRLS
            CONNECTION LIMIT -1
            PASSWORD 'POSTGRES_APP_PASSWORD';

      EXCEPTION
         WHEN duplicate_object THEN
            NULL;
      END;
   END IF;
end;
$$;

-- Change the owner of the database and public schema to be POSTGRES_APP_USER
ALTER DATABASE POSTGRES_APP_DB OWNER TO POSTGRES_APP_USER;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;

CREATE OR REPLACE FUNCTION public.trigger_updated_date() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
          IF row(NEW.*) IS DISTINCT FROM row(OLD.*) THEN 
              NEW.updatedat = now(); 
              RETURN NEW; 
          ELSE 
              RETURN OLD; 
          END IF;
      END;
    $$;


ALTER FUNCTION public.trigger_updated_date() OWNER TO POSTGRES_APP_USER;