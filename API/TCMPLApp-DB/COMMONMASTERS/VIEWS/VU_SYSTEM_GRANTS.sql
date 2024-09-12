--------------------------------------------------------
--  DDL for View VU_SYSTEM_GRANTS
--------------------------------------------------------

  
  CREATE OR REPLACE FORCE VIEW "TCMPL_APP_CONFIG"."VU_SYSTEM_GRANTS" ("APPLSYSTEM", "EMPNO", "NAME", "ROLENAMEBYPROJECT", "ROLENAME", "ROLEDESC", "MODULE", "COSTCODE", "ROLE_ON_COSTCODE") AS 
  Select
    Distinct '027'    As "APPLSYSTEM",
        a.empno       As empno,
        b.name,
        a.role_name   As rolenamebyproject,
        a.role_name   As rolename,
        a.role_name   As roledesc,
        a.module_name As module,
        b.parent      As costcode,
        b.parent      As role_on_costcode
    From
        vu_module_user_role_actions                a, vu_emplmast b
    Where
        b.status    = 1
        And a.empno = b.empno
        And a.module_name Not In ('NULL', 'LOGS', 'LC', 'TIMESHEET', 'EMPGENINFO', 'JOB')
    Order By
        a.module_name;

