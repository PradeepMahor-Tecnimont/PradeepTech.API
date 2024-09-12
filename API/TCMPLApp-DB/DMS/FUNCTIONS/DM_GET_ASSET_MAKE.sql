--------------------------------------------------------
--  DDL for Function DM_GET_ASSET_MAKE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DM_GET_ASSET_MAKE" (
    param_asset_id   IN VARCHAR2
) RETURN VARCHAR2 AS
    v_ret_val   VARCHAR2(200);
BEGIN
    SELECT
        asset_make
         ||  ' - '
         ||  asset_model
    INTO
        v_ret_val
    FROM
        ams.as_asset_mast
    WHERE
        TRIM(ams_asset_id) = TRIM(param_asset_id);

    RETURN v_ret_val;
EXCEPTION
    WHEN others THEN
        RETURN NULL;
END dm_get_asset_make;

/
