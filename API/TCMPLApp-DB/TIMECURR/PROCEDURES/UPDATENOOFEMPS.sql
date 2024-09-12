--------------------------------------------------------
--  DDL for Procedure UPDATENOOFEMPS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "TIMECURR"."UPDATENOOFEMPS" as 
begin 
update costmast set noofemps = 0 , NOOFCONS = 0;
update costmast set noofemps =
nvl((select count(empno)
from emplmast
where emplmast.parent = costmast.costcode   
-- aDD THIS LINE IF NO OF EMPLOYEES SHOULD NOT INCLUDE NEW ED DIVISION
--AND EMPNO NOT LIKE '10%'
and emplmast.emptype in ('C','R','F') 
and nvl(emplmast.status,0)=1),0);

update costmast set NOOFCONS =
nvl((select count(empno)
from emplmast
where emplmast.parent = costmast.costcode   
-- aDD THIS LINE IF NO OF EMPLOYEES SHOULD NOT INCLUDE NEW ED DIVISION
--AND EMPNO NOT LIKE '10%'
and emplmast.emptype  IN ('C' ,'F') 
and nvl(emplmast.status,0)=1),0);
commit;
end;

/
