--------------------------------------------------------
--  DDL for View DM_VU_PROP_FINAL_DESK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."DM_VU_PROP_FINAL_DESK" ("EMPNO1", "DESKID", "OFFICE", "FLOOR", "WING") AS 
  SELECT
    empno       AS empno1,
    targetdesk  deskid,
    office,
    floor,
    wing
FROM
    dms.dm_vu_proposed_desk
UNION ALL
SELECT
    empno1,
    deskid,
    office,
    floor,
    wing
FROM
    dms.desmas_allocation_all
WHERE
    NOT EXISTS (
        SELECT
            *
        FROM
            dms.dm_vu_proposed_desk
        WHERE
            empno = empno1
    )
;
