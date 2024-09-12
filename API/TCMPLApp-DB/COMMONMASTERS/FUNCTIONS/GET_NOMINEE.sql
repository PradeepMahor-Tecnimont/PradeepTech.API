--------------------------------------------------------
--  DDL for Function GET_NOMINEE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "COMMONMASTERS"."GET_NOMINEE" (p_empno emplmast.empno%type) return type tpfnomineetable  is table of pfint1%ROWTYPE  INDEX BY BINARY_INTEGER;

--AS
--TYPE tPFInt1Table
--IS
 -- TABLE OF PfInt1%ROWTYPE INDEX BY BINARY_INTEGER;
  --vPFInt1Table tPFInt1table;


vPFnominee tpfnomineetable;
begin
   select * into vPFnominee from emp_pf where empno = p_empno;
   return vPFnominee;
--exception   
   --when no_data_found then
     --   p_name := 'NOT FOUND';
       -- return p_name;
end;

/
