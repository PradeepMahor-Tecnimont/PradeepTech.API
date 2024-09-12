--------------------------------------------------------
--  DDL for View ENG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."ENG" ("COSTCODE", "NAME", "GROUPS", "COSTGRP", "TMA_GRP") AS 
  (select costcode,name,groups,costgrp,tma_grp
from costmast where tma_grp = 'E' )

;
