--------------------------------------------------------
--  DDL for View DESMAS_STATUS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."DESMAS_STATUS" ("DESKID", "STATUS", "EMPNO", "NAME") AS 
  (select p.deskid,p.status,p.empno,q.name from
(select a.deskid,decode(Count(b.assetid),0,'Empty Desk','Occp') Status,
c.empno from dm_deskmaster a,dm_deskallocation b,dm_usermaster c
where a.deskid = b.deskid(+) and a.deskid not in (select deskid from dm_desklock)
and a.deskid = c.deskid(+) group by a.deskid,c.empno) p left outer join ss_emplmast q on p.empno = q.empno)
;
