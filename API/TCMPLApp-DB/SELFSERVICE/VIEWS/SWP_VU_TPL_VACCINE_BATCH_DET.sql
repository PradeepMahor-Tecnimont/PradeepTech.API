--------------------------------------------------------
--  DDL for View SWP_VU_TPL_VACCINE_BATCH_DET
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SWP_VU_TPL_VACCINE_BATCH_DET" ("EMPNO", "EMPLOYEE_NAME", "PARENT", "DEPARTMENT_NAME", "GRADE", "EMPTYPE", "EMAIL", "JAB_FOR_THIS_SLOT", "TIME_SLOT", "TRANSPORT", "INOCULATED", "BATCH_KEY_ID") AS 
  Select 

    e.empno,
    e.name employee_name,
    e.parent,
    c.name department_name,
    e.grade,
    e.emptype,
    e.email,
    be.jab_for_this_slot,
    be.time_slot,
    be.transport,
    be.inoculated,
    be.batch_key_id
From
    ss_emplmast                 e,
    ss_costmast                 c,
    swp_tpl_vaccine_batch_emp   be
Where
    e.parent  = c.costcode
    And e.status  = 1
    And e.empno   = be.empno
;
  GRANT SELECT ON "SELFSERVICE"."SWP_VU_TPL_VACCINE_BATCH_DET" TO "TCMPL_APP_CONFIG";
