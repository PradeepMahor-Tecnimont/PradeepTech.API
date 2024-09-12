--------------------------------------------------------
--  DDL for View EMPLMAST_VIEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."EMPLMAST_VIEW" ("PARENT", "OFFICE", "EMPNO", "NAME", "MNGR", "IPADD", "PASSWORD", "EMAIL", "DOB", "DOJ", "COMPANY", "GRADE", "SEX", "DESGCODE", "ASSIGN") AS 
  select parent,office,empno,name,mngr,ipadd,password,email,dob,doj,company,grade,sex,desgcode,assign from emplmast where nvl(status,0)=1 and office not in ('IN','IS')

;
