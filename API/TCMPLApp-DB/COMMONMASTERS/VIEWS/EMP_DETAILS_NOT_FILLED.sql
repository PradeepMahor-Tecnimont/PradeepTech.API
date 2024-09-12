--------------------------------------------------------
--  DDL for View EMP_DETAILS_NOT_FILLED
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."EMP_DETAILS_NOT_FILLED" ("EMPNO", "NAME", "PARENT", "ASSIGN", "CO_BUS", "DOJ", "EMAIL") AS 
  select "EMPNO","NAME","PARENT","ASSIGN","CO_BUS", doj,email from (
select a.empno,a.name,a.parent,a.assign, b.co_bus,a.doj,a.email from emplmast A, emp_details B where
a.empno = b.empno (+) and a.status=1 and a.emptype = 'R') c where c.co_bus is null
;
