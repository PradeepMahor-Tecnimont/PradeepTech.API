--------------------------------------------------------
--  DDL for Procedure DELETEINBETWEENPUNCHLOOP
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "DELETEINBETWEENPUNCHLOOP" AS 
Cursor C1 is Select EmpNo From ss_emplmast where status = 1;
begin
  for  C2 in c1 Loop
    delete_in_between_punch(c2.EmpNo, '17-Nov-11');
  End Loop;
end;

/
