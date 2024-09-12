--------------------------------------------------------
--  DDL for View EMP_VU_FAMILY_4_INSURANCE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."EMP_VU_FAMILY_4_INSURANCE" ("KEY_ID", "EMPNO", "PERSON_NAME", "DOB", "RELATION") AS 
  Select a.key_id, a.empno, a.member As person_name, a.dob, b.description As relation
From emp_family a, emp_relation_mast b
Where a.relation = b.code
;
