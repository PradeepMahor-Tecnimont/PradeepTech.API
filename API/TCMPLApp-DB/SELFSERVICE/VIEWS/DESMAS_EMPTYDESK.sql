--------------------------------------------------------
--  DDL for View DESMAS_EMPTYDESK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."DESMAS_EMPTYDESK" ("DESKID") AS 
  (select a.deskid from dm_deskmaster a,dm_deskallocation b
where a.deskid = b.deskid(+) and a.deskid not in (select deskid from dm_desklock)
group by a.deskid having Count(b.assetid) = 0)
;
