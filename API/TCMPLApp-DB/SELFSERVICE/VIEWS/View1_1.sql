--------------------------------------------------------
--  DDL for View View1
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."View1" ("DESKID", "STATUS", "EMPNO", "NAME") AS 
  (select p.deskid,p.status,p.empno,q.name from
(select a.deskid,decode(Count(b.assetid),0,'Empty Desk','AssetExist') Status,
c.empno from dm_deskmaster a,dm_deskallocation b,dm_usermaster c
where a.deskid = b.deskid(+) and a.deskid not in (select deskid from dm_desklock)
and a.deskid = c.deskid(+) group by a.deskid,c.empno) p left outer join ss_emplmast q on p.empno = q.empno
)
;
