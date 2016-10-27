-- Define DROP MATERIALIZED VIEW function
-- Source is Listing 3 of http://www.varlena.com/GeneralBits/Tidbits/matviews.html 

-- The function takes as argument schema.matview_name; drops matview from schema (if not exists), and removes record in matviews table

-- NOTE: as the mv_configuration_events is intended to have multiple dependencies, consider executing DROP CASCADE instead, though this is a radical step

CREATE OR REPLACE FUNCTION beta_version.drop_matview(NAME) RETURNS VOID
SECURITY DEFINER
LANGUAGE plpgsql AS $$
DECLARE
    matview ALIAS FOR $1;
    entry beta_version.matviews%ROWTYPE;
BEGIN

    SELECT * INTO entry FROM beta_version.matviews WHERE mv_name = matview;

    IF NOT FOUND THEN
        RAISE EXCEPTION ''Materialized view % does not exist.'', matview;
    END IF;

    EXECUTE ''DROP TABLE '' || matview;
    DELETE FROM beta_version.matviews WHERE mv_name=matview;

    RETURN;
END $$;
