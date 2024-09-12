--------------------------------------------------------
--  DDL for View DM_PCLIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."DM_PCLIST" ("COMPNAME") AS 
  SELECT compname 
    
FROM dm_assetcode
where nvl(scrap,0)=0
and trim(compname ) is not null
order by compname
;
