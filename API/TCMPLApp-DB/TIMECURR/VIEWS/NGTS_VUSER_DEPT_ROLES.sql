--------------------------------------------------------
--  DDL for View NGTS_VUSER_DEPT_ROLES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."NGTS_VUSER_DEPT_ROLES" ("DEPTNO", "EMPNO", "ROLEID") AS 
  SELECT DISTINCT
        costcode   deptno,
        hod        empno,
        'R4'       roleid
    FROM
        costmast
    
    UNION
    
    SELECT
        deptno,
        empno,
        roleid
    FROM
        ngts_user_dept_roles
    ORDER BY
        deptno
;
