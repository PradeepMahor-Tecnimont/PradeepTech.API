--------------------------------------------------------
--  DDL for View DESMAS_STATUS_4_REPORT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."DESMAS_STATUS_4_REPORT" ("DESKID", "OFFICE", "FLOOR", "WING", "DESK_TYPE", "DESK_STATUS", "SHAPEID", "SHAPETEXT") AS 
  select deskid, office, floor,wing, desk_type,
 case desk_status when 0 then 'Vacant' else 'Occupied' end Desk_Status,
 shapeid, shapetext
 from
 (

SELECT a.DESKID,
  a.OFFICE,
  a.FLOOR,
  a.WING,
  CASE Trim(a.CABIN)
    WHEN 'C'
    THEN 'Cabin'
    ELSE 'Desks'
  END desk_type,
  dm_is_desk_occupied(a.DESKID) desk_status,
  b.SHAPEID,
  b.SHAPETEXT
FROM dm_deskmaster a,
  dm_deskmaster_visio_id b
WHERE trim(a.DESKID) = trim(b.DESKID(+))
AND a.DESKID NOT LIKE '_MR%'
AND a.DESKID NOT LIKE 'SPD%'
AND a.DESKID NOT IN
  (SELECT dm_desklock.DESKID
  FROM dm_desklock
  WHERE dm_desklock.BLOCKREASON IN (2, 3, 4)
  ) )
;
