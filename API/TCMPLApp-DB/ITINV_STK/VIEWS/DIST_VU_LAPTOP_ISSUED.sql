--------------------------------------------------------
--  DDL for View DIST_VU_LAPTOP_ISSUED
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."DIST_VU_LAPTOP_ISSUED" ("EMPNO", "LAPTOP_AMS_ID", "PERMANENT_ISSUED", "MODIFIED_ON", "LETTER_REF_NO") AS 
  Select
    empno,
    laptop_ams_id,
    permanent_issued,
    modified_on,
    letter_ref_no
From
    dist_laptop_already_issued
Union
Select
    empno,
    assetid,
    'OK',
    Null,
    Null
From
    dm_vu_user_desk_pc
Where
    asset_type = 'NB'
    And assetid Not In (
        Select
            laptop_ams_id
        From
            dist_laptop_already_issued
    )
;
