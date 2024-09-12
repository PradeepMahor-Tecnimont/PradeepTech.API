--------------------------------------------------------
--  DDL for Procedure GENERATEPUNCH4ALL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SELFSERVICE"."GENERATEPUNCH4ALL" 
(
  P_DATE IN DATE  
) AS 
cursor c1 is
  select distinct empno,pdate from ss_punch where trunc(pdate) >= '24-Feb-2010';
BEGIN
  for c2 in c1 
  loop
    generate_auto_punch(c2.empno,P_DATE);
  end loop;
END GENERATEPUNCH4ALL;


/
