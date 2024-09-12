--------------------------------------------------------
--  DDL for Package Body NGTS_EMP_ACCESS_ROLES
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."NGTS_EMP_ACCESS_ROLES" AS

    --GET UNIVERSAL PROCESSING MONTH    
    FUNCTION get_univ_pros_month RETURN VARCHAR2 IS
        v_universal_processing_month TSCONFIG.PROS_MONTH%TYPE;
    BEGIN        
        SELECT
           pros_month 
           INTO v_universal_processing_month
        FROM
           timecurr.tsconfig;

        RETURN v_universal_processing_month;
    EXCEPTION
        WHEN OTHERS THEN            
            RETURN 'Err - ' || sqlcode || ' - ' || sqlerrm;
    END;
    

    --GET ROLE NAME
    FUNCTION get_role_desc (
        p_roleid IN VARCHAR2
    ) RETURN VARCHAR2 IS
        vroledesc ngts_role_mast.roles%TYPE;
    BEGIN
        SELECT
            roles
        INTO vroledesc
        FROM
            timecurr.ngts_role_mast
        WHERE
            roleid = TRIM(p_roleid);

        RETURN vroledesc;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Err - ' || sqlcode || ' - ' || sqlerrm;
    END get_role_desc;
    

    --GET ACTION NAME
    FUNCTION get_action_desc (
        p_actionid IN NUMBER
    ) RETURN VARCHAR2 IS
        vactiondesc ngts_action_mast.actiondesc%TYPE;
    BEGIN
        SELECT
            actiondesc
        INTO vactiondesc
        FROM
            timecurr.ngts_action_mast
        WHERE
            actionid = TRIM(p_actionid);

        RETURN vactiondesc;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Err - ' || sqlcode || ' - ' || sqlerrm;
    END get_action_desc;   
    
    
    --GET DEPT FOR EMPNO
    FUNCTION get_emp_dept (
        p_empno VARCHAR2
    ) RETURN SYS_REFCURSOR IS
        o_cursor        SYS_REFCURSOR;
        nempdeptcount   NUMBER;
    BEGIN
        OPEN o_cursor FOR SELECT DISTINCT
                              deptno,
                              name,
                              deptabbr,
                              active,
                              is_on_deputation(deptno) onDeputation                              
                          FROM
                              (
                                  SELECT
                                      a.assign          deptno,
                                      b.name            name,
                                      b.abbr            deptabbr,
                                      nvl(b.active,0)   active
                                  FROM
                                      timecurr.emplmast   a,
                                      timecurr.costmast   b
                                  WHERE
                                      a.emptype IN (
                                          SELECT
                                              emptype
                                          FROM
                                              timecurr.emptypemast
                                          WHERE
                                              nvl(tm, 0) = 1
                                      )
                                      AND a.assign = b.costcode                                      
                                      AND nvl(a.status, 0) = 1
                                      AND nvl(b.active, 0) = 1
                                      AND a.empno = TRIM(p_empno)
                                      
                                  UNION ALL
                                  
                                  SELECT
                                      a.deptno          deptno,
                                      b.name            name,
                                      b.abbr            deptabbr,
                                      nvl(b.active,0)   active
                                  FROM
                                      timecurr.ngts_vuser_dept_roles   a,
                                      timecurr.costmast                b
                                  WHERE
                                      EXISTS (
                                          SELECT
                                              emplmast.*
                                          FROM
                                              timecurr.emplmast
                                          WHERE
                                              emptype IN (
                                                  SELECT
                                                      emptype
                                                  FROM
                                                      timecurr.emptypemast
                                                  WHERE
                                                      nvl(tm, 0) = 1
                                              )
                                              AND nvl(status, 0) = 1
                                              AND empno = TRIM(p_empno)
                                      )
                                      AND a.deptno = b.costcode                                      
                                      AND a.empno = TRIM(p_empno)
                              )
                          ORDER BY
                              deptno;

        RETURN o_cursor;
    END get_emp_dept;
    
    
    --GET ROLE FOR DEPT FOR EMPNO
    FUNCTION get_emp_dept_role (
        p_empno VARCHAR2,
        p_deptno  VARCHAR2
    ) RETURN SYS_REFCURSOR IS
        o_cursor SYS_REFCURSOR;
    BEGIN
        OPEN o_cursor FOR SELECT
            roleid id,
            ngts_emp_access_roles.get_role_desc(roleid) name            
        FROM
            timecurr.ngts_vuser_dept_roles
        WHERE
            deptno = TRIM(p_deptno)
            AND empno = TRIM(p_empno)
        ORDER BY roleid;
        RETURN o_cursor;
    END get_emp_dept_role;
    
    
    --GET ACTION FOR ROLE
    FUNCTION get_role_action (
        p_roleid VARCHAR2
    ) RETURN SYS_REFCURSOR IS
        o_cursor SYS_REFCURSOR;
    BEGIN
        OPEN o_cursor FOR SELECT 
            actionid action
        FROM
            timecurr.ngts_role_action_assign
        WHERE
            roleid = TRIM(p_roleid)
        ORDER BY actionid;
        RETURN o_cursor;    
    END get_role_action;
    
    
    --GET PREFERRED DEPT FOR EMPNO
    FUNCTION get_emp_preferred_dept (
        p_empno VARCHAR2
    ) RETURN SYS_REFCURSOR IS
        o_cursor SYS_REFCURSOR;
    BEGIN
        OPEN o_cursor FOR SELECT
                              a.deptno   deptno,
                              b.name     name
                          FROM
                              timecurr.ngts_prefer_dept   a,
                              timecurr.costmast           b
                          WHERE
                              EXISTS (
                                  SELECT
                                      emplmast.*
                                  FROM
                                      timecurr.emplmast
                                  WHERE
                                      emptype IN (
                                          SELECT
                                              emptype
                                          FROM
                                              timecurr.emptypemast
                                          WHERE
                                              nvl(tm, 0) = 1
                                      )
                                      AND nvl(status, 0) = 1
                                      AND empno = TRIM(p_empno)
                              )
                              AND nvl(b.active, 0) = 1
                              AND a.deptno = b.costcode                              
                              AND a.empno = TRIM(p_empno);

        RETURN o_cursor;
    END get_emp_preferred_dept;
    
    
    --GET PROJECT FOR EMPNO
    FUNCTION get_emp_proj (
        p_empno VARCHAR2,
        p_yearmonth IN VARCHAR2
    ) RETURN SYS_REFCURSOR IS
        o_cursor SYS_REFCURSOR;
    BEGIN
        OPEN o_cursor FOR SELECT DISTINCT
                              a.projno           projno,
                              b.name             name,
                              nvl(b.active, 0)   active,
                              b.timesheet_appr   pmapproval,
                              CASE
                                  WHEN c.datefrom IS NOT NULL THEN
                                      1
                                  ELSE
                                      0
                              END freezeenable,
                              c.datefrom         openfrom,
                              c.dateto           opento,
                              d.reviewfrom       reviewfrom,
                              d.reviewto         reviewto,
                              d.locked           reviewlocked
                          FROM
                              timecurr.ngts_vuser_project_roles       a,
                              timecurr.projmast                       b,
                              timecurr.tm_week_unlock                 c,
                              timecurr.ngts_project_review_period     d
                          WHERE
                              EXISTS (
                                  SELECT
                                      projmast.*
                                  FROM
                                      timecurr.projmast
                                  WHERE
                                      (
                                          (
                                            (( to_number(SUBSTR(TRIM(p_yearmonth),5,2)) > 3 AND to_number(to_char(revcdate, 'YYYYMM')) >= to_number(SUBSTR(TRIM(p_yearmonth),1,4)||'04'))
                                             OR
                                            ( to_number(SUBSTR(TRIM(p_yearmonth),5,2)) < 4 AND to_number(to_char(revcdate, 'YYYYMM')) >= (to_number(SUBSTR(TRIM(p_yearmonth),1,4)||'04')-100)))
                                            AND
                                            (( to_number(SUBSTR(TRIM(p_yearmonth),5,2)) > 3 AND to_number(to_char(sdate, 'YYYYMM')) < to_number(SUBSTR(TRIM(p_yearmonth),1,4)||'04')+100)
                                             OR
                                            ( to_number(SUBSTR(TRIM(p_yearmonth),5,2)) < 4 AND to_number(to_char(sdate, 'YYYYMM')) < (to_number(SUBSTR(TRIM(p_yearmonth),1,4)||'04'))))                                            
                                          )   
                                          OR
                                          ( substr(projno, 1, 5) IN (SELECT projno FROM timecurr.ngts_fixed_project) )
                                      )
                                      AND substr(projno, 1, 5) = a.projno
                              )
                              AND EXISTS (
                                  SELECT
                                      emplmast.*
                                  FROM
                                      timecurr.emplmast
                                  WHERE
                                      emptype IN (
                                          SELECT
                                              emptype
                                          FROM
                                              timecurr.emptypemast
                                          WHERE
                                              nvl(tm, 0) = 1
                                      )
                                      AND nvl(status, 0) = 1
                                      AND empno = TRIM(p_empno)
                              )
                              AND a.projno = substr(b.projno, 1, 5)
                              AND a.projno = c.proj_no (+)
                              AND a.projno = d.projno (+)
                              AND d.locked (+) = 0
                              AND a.empno = TRIM(p_empno)
                          ORDER BY
                              a.projno;

        RETURN o_cursor;
    END get_emp_proj;    
    
    
    --GET ROLE FOR PROJECT FOR EMPNO
    FUNCTION get_emp_proj_role (
        p_empno VARCHAR2,
        p_projno  VARCHAR2
    ) RETURN SYS_REFCURSOR IS
        o_cursor SYS_REFCURSOR;
    BEGIN
        OPEN o_cursor FOR SELECT
            roleid id,
            ngts_emp_access_roles.get_role_desc(roleid) name            
        FROM
            timecurr.ngts_vuser_project_roles
        WHERE
            projno = TRIM(p_projno)
            AND empno = TRIM(p_empno)
        ORDER BY roleid;
        RETURN o_cursor;
    END get_emp_proj_role;     
    
    
    --CHECK IF THE PROJECT IS FREEZE ENABLED
    FUNCTION get_project_freeze_enable (
        p_projno IN VARCHAR2
    ) RETURN SYS_REFCURSOR IS
        o_cursor SYS_REFCURSOR;        
    BEGIN
        OPEN o_cursor FOR SELECT
                              1 freezeenable,
                              datefrom   openfrom,
                              dateto     opento                          
                          FROM
                              timecurr.tm_week_unlock
                          WHERE
                              proj_no = TRIM(p_projno);
        RETURN o_cursor;
    END get_project_freeze_enable;
    
    
    --CHECK IF THE USER IS ON DEPUTATION
    FUNCTION is_on_deputation (
        p_assign IN VARCHAR2
    ) RETURN NUMBER IS
        vdeptno ngts_deputation_dept.deptno%TYPE;
    BEGIN
        SELECT
            deptno
        INTO vdeptno
        FROM
            timecurr.ngts_deputation_dept
        WHERE
            deptno = TRIM(p_assign);

        RETURN 1;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END is_on_deputation;
    
END ngts_emp_access_roles;

/
