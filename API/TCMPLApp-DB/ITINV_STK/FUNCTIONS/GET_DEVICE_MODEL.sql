--------------------------------------------------------
--  DDL for Function GET_DEVICE_MODEL
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "ITINV_STK"."GET_DEVICE_MODEL" (
    param_ams_id In Varchar2
) Return Varchar2 As
    v_asset_model Varchar2(60);
Begin
    Select
        asset_model
    Into v_asset_model
    From
        ams_asset_master
    Where
        Trim(ams_asset_id) = Trim(param_ams_id);

    Return v_asset_model;
Exception
    When Others Then
        return Null;
End get_device_model;

/
