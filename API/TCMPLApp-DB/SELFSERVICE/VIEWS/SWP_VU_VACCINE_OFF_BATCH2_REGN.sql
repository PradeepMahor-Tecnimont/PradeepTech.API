--------------------------------------------------------
--  DDL for View SWP_VU_VACCINE_OFF_BATCH2_REGN
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SWP_VU_VACCINE_OFF_BATCH2_REGN" ("EMPNO", "EMPLOYEE_NAME", "FAMILY_MEMBER_NAME", "RELATION", "YEAR_OF_BIRTH", "PREFERRED_DATE", "JAB_NUM") AS 
  Select
    f.empno,
    e.name employee_name,
    f.family_member_name,
    f.relation,
    f.year_of_birth,
    b.preferred_date,
    Case
        When f.relation = 'SELF' Then
            b.jab_number
        Else
            Null
    End jab_num
From
    swp_vaccination_office_family    f,
    swp_vaccination_office_batch_2   b,
    ss_emplmast                      e
Where
    f.empno = b.empno
    And f.empno = e.empno
;
  GRANT SELECT ON "SELFSERVICE"."SWP_VU_VACCINE_OFF_BATCH2_REGN" TO "TCMPL_APP_CONFIG";
