--------------------------------------------------------
--  DDL for View DESMAS_EMP_OFFICE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."DESMAS_EMP_OFFICE" ("EMPNO", "DESKID", "OFFICE", "FLOOR", "WING") AS 
  Select Distinct
    a.empno,
    Trim(a.deskid) deskid,
    Trim(b.office) office,
    Trim(b.Floor) Floor,
    Trim(b.wing) wing
From
    desmas_usermaster   a,
    dm_vu_desk_list     b
Where
    Trim(a.deskid) = Trim(b.deskid)
;
