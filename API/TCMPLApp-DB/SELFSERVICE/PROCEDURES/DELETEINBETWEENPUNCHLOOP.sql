--------------------------------------------------------
--  DDL for Procedure DELETEINBETWEENPUNCHLOOP
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SELFSERVICE"."DELETEINBETWEENPUNCHLOOP" AS 
Cursor C1 is Select EmpNo From ss_emplmast where status = 1;
begin
  for  C2 in c1 Loop
    delete_in_between_punch(c2.EmpNo, to_date('09-May-2018','dd-Mon-yyyy'));
  End Loop;
end;


/
