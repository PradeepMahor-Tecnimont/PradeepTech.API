--------------------------------------------------------
--  DDL for View EMPLOYEENOTFILLED
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."EMPLOYEENOTFILLED" ("ASSIGN", "DESC1", "NOOFEMPL", "DESC2", "PROS_MONTH") AS 
  (
select  assign,'Employee Not Filled' desc1,count(*) as noofempl , 'Summary' desc2, tsconfig.pros_month
 from emplmast,tsconfig where assign like '02%' and emptype in ('R','C','S')
 and status = 1 and empno not in (select empno from time_mast where yymm = (select pros_month from tsconfig)) group by assign,tsconfig.pros_month
 union 
 select  assign,'Employee Not Filled' desc1,1 as noofempl , name desc2 , tsconfig.pros_month
  from emplmast,tsconfig where assign like '02%' and emptype in ('R','C','S')
 and status = 1 and empno not in (select empno from time_mast where yymm = (select pros_month from tsconfig)) 
 )
;
