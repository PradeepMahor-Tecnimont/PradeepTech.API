--------------------------------------------------------
--  DDL for View TEST1
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TEST1" ("COSTCODE", "NAME", "TMA_GRP") AS 
  (select costcode,name,tma_grp from costmast where tma_grp = 'E' union
select costcode,name,tma_grp from costmast where tma_grp = 'P')

;
