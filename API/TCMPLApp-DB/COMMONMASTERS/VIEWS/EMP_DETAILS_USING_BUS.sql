--------------------------------------------------------
--  DDL for View EMP_DETAILS_USING_BUS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."EMP_DETAILS_USING_BUS" ("EMPNO", "NAME", "PARENT", "ASSIGN", "DESCRIPTION", "CODE", "PICK_UP_POINT", "R_ADD_1", "R_ADD_2", "R_ADD_3", "R_ADD_4", "P_ADD_1", "P_ADD_2", "P_ADD_3", "P_ADD_4") AS 
  SELECT /*+ NOPARALLEL(EMP_DETAILS, EMP_BUS_MASTER, EMPLMAST, ) */ EMPLMAST.EMPNO, EMPLMAST.NAME, EMPLMAST.PARENT, EMPLMAST.ASSIGN, EMP_BUS_MASTER.DESCRIPTION,
EMP_BUS_MASTER.CODE,emp_details.pick_up_point,emp_details.r_add_1,emp_details.r_add_2,emp_details.r_add_3,emp_details.r_add_4,
emp_details.p_add_1,emp_details.p_add_2,emp_details.p_add_3,emp_details.p_add_4

FROM EMP_DETAILS , EMP_BUS_MASTER , EMPLMAST
WHERE ( (EMP_DETAILS.EMPNO = EMPLMAST.EMPNO) AND
(EMP_BUS_MASTER.CODE(+) = EMP_DETAILS.CO_BUS) AND
 emplmast.status=1 ) and ltrim(Rtrim(emp_details.co_bus)) is not null
ORDER BY EMPLMAST.EMPNO ASC

;
  GRANT SELECT ON "COMMONMASTERS"."EMP_DETAILS_USING_BUS" TO "SELFSERVICE";
