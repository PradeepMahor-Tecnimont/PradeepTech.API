--------------------------------------------------------
--  DDL for View CONSULTQRY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."CONSULTQRY" ("CATEGORY", "OFFICE", "EMPNO", "NAME", "DESGCODE", "PAR", "ASSIGN", "DOR") AS 
  (
select category,office,empno,name,DESGCODE,decode(parent,assign,'',parent) as par,assign,DOR from emplmast where status = 1 and emptype in ('C','S') and (  assign = '0232')
union
select category,office,empno,name,DESGCODE,'' as par,assign,DOR from emplmast where status = 1 and emptype in ('C','S') and (  parent = '0232' and assign <> '0232')
)
;
