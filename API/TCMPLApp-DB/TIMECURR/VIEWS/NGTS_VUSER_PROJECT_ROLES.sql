--------------------------------------------------------
--  DDL for View NGTS_VUSER_PROJECT_ROLES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."NGTS_VUSER_PROJECT_ROLES" ("PROJNO", "EMPNO", "ROLEID") AS 
  SELECT DISTINCT
    proj_no   projno,
    prjmngr   empno,
    'R3' roleid
FROM
    projmast

UNION

SELECT DISTINCT
    proj_no   projno,
    prjmngr   empno,
    'R5' roleid
FROM
    projmast
WHERE
    costcode = '0404'
    AND active = 1

UNION

SELECT
    projno,
    empno,
    roleid
FROM
    ngts_user_project_roles
ORDER BY
    projno
;
