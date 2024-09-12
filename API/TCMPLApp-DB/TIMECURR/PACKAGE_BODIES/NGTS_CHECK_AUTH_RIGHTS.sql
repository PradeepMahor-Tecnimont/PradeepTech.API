--------------------------------------------------------
--  DDL for Package Body NGTS_CHECK_AUTH_RIGHTS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."NGTS_CHECK_AUTH_RIGHTS" AS

    FUNCTION check_auth_rights (
        p_api_url              IN   VARCHAR2,
        p_user_identity_name   IN   VARCHAR2,           
        p_projno               IN   VARCHAR2 DEFAULT NULL,
        p_user_empno           IN   VARCHAR2 DEFAULT NULL,
        p_user_assign_deptno   IN   VARCHAR2 DEFAULT NULL
    ) RETURN VARCHAR2 AS
        ret_empno  VARCHAR2(5);
        ret_deptno VARCHAR2(5);
    BEGIN
        --
        IF p_api_url is NULL THEN
            RETURN 'ERROR';
        END IF;
        
        --CHECK USER EXISTS IN EMPLMAST TABLE
        ret_empno := get_empno(p_user_identity_name);
        IF ret_empno = 'ERROR' THEN
            RETURN ret_empno;
        END IF;              
        
        --To be modified
        IF lower(trim(p_api_url)) = lower('api/getDeptPreferredDeptProj') Or 
           lower(trim(p_api_url)) = lower('api/DeptRolesSum') Or
           lower(trim(p_api_url)) = lower('api/saveDeptRole') Or
           lower(trim(p_api_url)) = lower('api/delDeptRole') Or
           lower(trim(p_api_url)) = lower('api/ProjectRolesSum') Or
           lower(trim(p_api_url)) = lower('api/saveProjectRole') Or
           lower(trim(p_api_url)) = lower('api/delProjectRole') Or
           lower(trim(p_api_url)) = lower('api/GetRolesHirerarchi') Or
           lower(trim(p_api_url)) = lower('api/timesheet/GetAllEmployees') THEN
            RETURN 'Done';
        END IF;
        
        --CHECK R5
        IF lower(trim(p_api_url)) = lower('api/GetCostCode') Or
           lower(trim(p_api_url)) = lower('api/getProjectLastMonth') Or
           lower(trim(p_api_url)) = lower('api/getActivities') Or
           lower(trim(p_api_url)) = lower('api/getAllActivities') Or
           lower(trim(p_api_url)) = lower('api/getProjectForDept') Or
           lower(trim(p_api_url)) = lower('api/getWPCodes') Or
           lower(trim(p_api_url)) = lower('api/GetReasonCode') Or
           lower(trim(p_api_url)) = lower('api/getWorkingHours') Or
           lower(trim(p_api_url)) = lower('api/saveTimesheet') Or
           lower(trim(p_api_url)) = lower('api/timesheet/lockTimesheet') Or
           lower(trim(p_api_url)) = lower('api/GetTimeSheet') Or
           lower(trim(p_api_url)) = lower('api/downloadTimesheet') Or
           lower(trim(p_api_url)) = lower('api/GetEmpTimeSheetList') Or          
           lower(trim(p_api_url)) = lower('api/common/getEmpDetails') Or
           lower(trim(p_api_url)) = lower('api/common/getUserTimesheetDepts') THEN
            --CHECK DEPT BEGINS WITH 02
            ret_deptno := check_deptno(p_user_assign_deptno);
            IF ret_deptno = 'ERROR' THEN
                RETURN ret_deptno;
            END IF;
            
            --SELF FILL
            IF TRIM(ret_empno) = TRIM(p_user_empno) THEN                
                RETURN 'Done';                
            ELSE                
                IF lower(trim(p_api_url)) = lower('api/GetEmpTimeSheetList') Or
                   lower(trim(p_api_url)) = lower('api/common/getUserTimesheetDepts') THEN
                    --R2 - SEC. OR FOCAL POINT / R4 - HoD / R5 - Project Approver
                    RETURN checkEmpnoDeptR2R4(ret_empno, p_user_assign_deptno, p_projno, p_user_empno, p_api_url);
                ELSE
                    --R1 - ON BEHALF / R2 - SEC. OR FOCAL POINT / R4 - HoD / R5 - Project Approver
                    RETURN checkEmpnoDeptR1R2R4(ret_empno, p_user_assign_deptno, p_projno, p_user_empno, p_api_url);
                END IF;
            END IF;
        END IF;
        
        IF lower(trim(p_api_url)) = lower('api/common/setPreferredDept') Or           
           lower(trim(p_api_url)) = lower('api/common/getMyDetails') THEN
            ret_deptno := check_deptno(p_user_assign_deptno);
            IF ret_deptno = 'ERROR' THEN
                RETURN ret_deptno;
            END IF;        
            IF TRIM(ret_empno) = TRIM(p_user_empno) THEN                
                RETURN 'Done';
            ELSE 
                RETURN 'ERROR';
            END IF;
        END IF;        
        
        IF lower(trim(p_api_url)) = lower('api/common/getYears') Or
           lower(trim(p_api_url)) = lower('api/getHolidays') THEN
            RETURN 'Done';
        END IF;        
        
        IF  lower(trim(p_api_url)) = lower('api/GetTSListApprl') THEN
            IF p_projno Is Not Null THEN
                RETURN checkEmpnoProjnoR3R5(ret_empno, p_projno);
            ELSIF p_user_assign_deptno Is Not Null THEN
                RETURN checkEmpnoDeptR2R4(ret_empno, p_user_assign_deptno);
            END IF;
        END IF;                
        
       
        IF lower(trim(p_api_url)) = lower('api/timesheet/bulkLockTimesheet') Or
              lower(trim(p_api_url)) = lower('api/timesheet/bulkUnLockTimesheet') Or
              lower(trim(p_api_url)) = lower('api/timesheet/bulkDeleteTimesheet') THEN
            RETURN checkEmpnoDeptR2R4(ret_empno, p_user_assign_deptno);
        ELSIF lower(trim(p_api_url)) = lower('api/timesheet/projApproveTimesheet') Or
              lower(trim(p_api_url)) = lower('api/timesheet/projUnApproveTimesheet') Or 
              lower(trim(p_api_url)) = lower('api/timesheet/sendMailNotLockedProjTimesheet') Or
              lower(trim(p_api_url)) = lower('api/getProjectOpenDetails') Or              
              lower(trim(p_api_url)) = lower('api/addUpdateProjectOpenDetails') Or
              lower(trim(p_api_url)) = lower('api/updateProjectReviewStatus') Or
              lower(trim(p_api_url)) = lower('api/deleteProjectOpenDetails') THEN
            RETURN checkEmpnoProjnoR3(ret_empno, p_projno);
        ELSIF lower(trim(p_api_url)) = lower('api/timesheet/bulkApproveTimesheet') Or
              lower(trim(p_api_url)) = lower('api/timesheet/bulkUnApproveTimesheet') Or
              lower(trim(p_api_url)) = lower('api/timesheet/bulkPostTimesheet') Or
              lower(trim(p_api_url)) = lower('api/timesheet/bulkUnPostTimesheet') Or 
              lower(trim(p_api_url)) = lower('api/employees') THEN        
            RETURN checkEmpnoDeptR4(ret_empno, p_user_assign_deptno);
        ELSIF lower(trim(p_api_url)) = lower('api/timesheet/sendMailNotFilledTimesheet') Or
              lower(trim(p_api_url)) = lower('api/timesheet/sendMailInvalidTimesheet') Or
              lower(trim(p_api_url)) = lower('api/timesheet/sendMailNotLockedTimesheet') THEN
            RETURN checkEmpnoDeptR2R4R6(ret_empno, p_user_assign_deptno);
        ELSIF lower(trim(p_api_url)) = lower('api/timesheet/sendMailNotPostedTimesheet') THEN
            RETURN checkEmpnoDeptR6(ret_empno, p_user_assign_deptno);
        END IF;        
        
    END check_auth_rights;
    
    --GET EMPNO
    FUNCTION get_empno (
        p_user_identity_name IN VARCHAR2
    ) RETURN VARCHAR2 AS
        v_empno emplmast.empno%TYPE;
    BEGIN
        IF instr(trim(p_user_identity_name), '\') > 0 THEN
            SELECT
                empno
            INTO v_empno
            FROM
                timecurr.emplmast
            WHERE
                nvl(status, 0) = 1
                AND lower(user_domain) = lower(substr(TRIM(p_user_identity_name), instr(TRIM(p_user_identity_name), '\') + 1));

        ELSIF instr(trim(p_user_identity_name), '@') > 0 THEN
            SELECT
                empno
            INTO v_empno
            FROM
                timecurr.emplmast
            WHERE
                nvl(status, 0) = 1
                AND lower(email) = lower(TRIM(p_user_identity_name));

        END IF;

        RETURN v_empno;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'ERROR';
    END get_empno;       

    --CHECK DEPT
    FUNCTION check_deptno (
        p_user_assign_deptno IN VARCHAR2
    ) RETURN VARCHAR2 AS
        v_cost_code costmast.costcode%TYPE;
    BEGIN
        SELECT
            costcode
        INTO v_cost_code
        FROM
            costmast
        WHERE
            costcode LIKE '02%'
            AND nvl(active, 0) = 1
            AND costcode = TRIM(p_user_assign_deptno)
            AND costcode NOT IN (
                SELECT
                    deptno
                FROM
                    ngts_deputation_dept
            );
        RETURN 'Done';
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'ERROR';                
    END;
    

    --ON BEHALF
    --R1 R2 R4 R5
    FUNCTION checkEmpnoDeptR1R2R4 (
        p_user_identity_empno       IN   VARCHAR2,
        p_assign                    IN   VARCHAR2,
        p_projno                    IN   VARCHAR2,
        p_empno                     IN   VARCHAR2,
        p_api_url                   IN   VARCHAR2
    ) RETURN VARCHAR2 AS
        v_empno ngts_vuser_dept_roles.empno%TYPE;
    BEGIN
        SELECT
            empno
        INTO v_empno
        FROM
            timecurr.ngts_vuser_dept_roles
        WHERE
            deptno = TRIM(p_assign)
            AND empno = TRIM(p_user_identity_empno)
            AND roleid IN (
                'R1',
                'R2',                
                'R4'
            );
        RETURN 'Done';
    EXCEPTION
        WHEN OTHERS THEN
            BEGIN
                SELECT
                    empno
                INTO v_empno
                FROM
                    timecurr.ngts_vuser_project_roles
                WHERE
                    projno = TRIM(p_projno)
                    AND empno = TRIM(p_user_identity_empno)
                    AND roleid = 'R3';
                
                RETURN 'Done';
            EXCEPTION
                WHEN OTHERS THEN
                    BEGIN
                        IF lower(trim(p_api_url)) = lower('api/getWorkingHours') Or
                           lower(trim(p_api_url)) = lower('api/GetTimeSheet') Or
                           lower(trim(p_api_url)) = lower('api/common/getEmpDetails') Or
                           lower(trim(p_api_url)) = lower('api/common/getUserTimesheetDepts') THEN
                            SELECT
                                empno
                            INTO v_empno
                            FROM
                                timecurr.ngts_vuser_project_roles
                            WHERE
                                projno = TRIM(p_projno)
                                AND empno = TRIM(p_user_identity_empno)
                                AND roleid = 'R5';
                        
                            RETURN 'Done';
                        ELSE
                            RETURN 'ERROR';
                        END IF;
                        
                    EXCEPTION
                        WHEN OTHERS THEN
                            RETURN 'ERROR';
                    END;
            END;
    END checkEmpnoDeptR1R2R4;   


    --ON BEHALF
    --R1 R2 R4 R5
    FUNCTION checkEmpnoDeptR2R4 (
        p_user_identity_empno       IN   VARCHAR2,
        p_assign                    IN   VARCHAR2,
        p_projno                    IN   VARCHAR2,
        p_empno                     IN   VARCHAR2,
        p_api_url                   IN   VARCHAR2
    ) RETURN VARCHAR2 AS
        v_empno ngts_vuser_dept_roles.empno%TYPE;
    BEGIN
        SELECT
            empno
        INTO v_empno
        FROM
            timecurr.ngts_vuser_dept_roles
        WHERE
            deptno = TRIM(p_assign)
            AND empno = TRIM(p_user_identity_empno)
            AND roleid IN (                
                'R2',                
                'R4'
            );
        RETURN 'Done';
    EXCEPTION
        WHEN OTHERS THEN
            BEGIN
                SELECT
                    empno
                INTO v_empno
                FROM
                    timecurr.ngts_vuser_project_roles
                WHERE
                    projno = TRIM(p_projno)
                    AND empno = TRIM(p_user_identity_empno)
                    AND roleid IN (
                        'R3',
                        'R5'
                    );
                
                RETURN 'Done';
            EXCEPTION
                WHEN OTHERS THEN
                    RETURN 'ERROR';
            END;
    END checkEmpnoDeptR2R4;   


    --BULK LOCK, UNLOCK & DELETE 
    --R2 R4
    FUNCTION checkEmpnoDeptR2R4 (
        p_user_identity_empno       IN   VARCHAR2,
        p_assign                    IN   VARCHAR2
    ) RETURN VARCHAR2 AS
        v_empno ngts_vuser_dept_roles.empno%TYPE;
    BEGIN
        SELECT
            empno
        INTO v_empno
        FROM
            timecurr.ngts_vuser_dept_roles
        WHERE
            deptno = TRIM(p_assign)
            AND empno = TRIM(p_user_identity_empno)
            AND roleid IN (
                'R2',
                'R4'
            );
        RETURN 'Done';
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'ERROR';        
    END checkEmpnoDeptR2R4;

    --PROJECT APPROVE, UNAPPROVE, SEND MAIL TO LOCK & FREEZE
    --R3
    FUNCTION checkEmpnoProjnoR3 (
        p_user_identity_empno       IN   VARCHAR2,
        p_projno                    IN   VARCHAR2
    ) RETURN VARCHAR2 AS
        v_empno ngts_vuser_project_roles.empno%TYPE;
    BEGIN
        SELECT
            empno
        INTO v_empno
        FROM
            timecurr.ngts_vuser_project_roles
        WHERE
            projno = TRIM(p_projno)
            AND empno = TRIM(p_user_identity_empno)
            AND roleid = 'R3';
            
        RETURN 'Done';
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'ERROR';        
    END checkEmpnoProjnoR3;   
    
    
    FUNCTION checkEmpnoProjnoR3R5 (
        p_user_identity_empno       IN   VARCHAR2,
        p_projno                    IN   VARCHAR2
    ) RETURN VARCHAR2 AS
        v_empno ngts_vuser_project_roles.empno%TYPE;
    BEGIN
        SELECT
            empno
        INTO v_empno
        FROM
            timecurr.ngts_vuser_project_roles
        WHERE
            projno = TRIM(p_projno)
            AND empno = TRIM(p_user_identity_empno)
            AND roleid IN (
                'R3',
                'R5'
            );
            
        RETURN 'Done';
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'ERROR';        
    END checkEmpnoProjnoR3R5;       
    
    --BULK APPROVE, UNAPPROVE, POST & UNPOST
    --R4
    FUNCTION checkEmpnoDeptR4 (
        p_user_identity_empno       IN   VARCHAR2,
        p_assign                    IN   VARCHAR2
    ) RETURN VARCHAR2 AS
        v_empno ngts_vuser_dept_roles.empno%TYPE;
    BEGIN
        SELECT
            empno
        INTO v_empno
        FROM
            timecurr.ngts_vuser_dept_roles
        WHERE
            deptno = TRIM(p_assign)
            AND empno = TRIM(p_user_identity_empno)
            AND roleid = 'R4';
            
        RETURN 'Done';
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'ERROR';        
    END checkEmpnoDeptR4;    
        
    --SEND MAIL NOT FILLED, INVALID & NOT LOCKED
    --R2 R4 R6
    FUNCTION checkEmpnoDeptR2R4R6 (
        p_user_identity_empno       IN   VARCHAR2,
        p_assign                    IN   VARCHAR2
    ) RETURN VARCHAR2 AS
        v_empno ngts_vuser_dept_roles.empno%TYPE;
    BEGIN
        SELECT
            empno
        INTO v_empno
        FROM
            timecurr.ngts_vuser_dept_roles
        WHERE
            deptno = TRIM(p_assign)
            AND empno = TRIM(p_user_identity_empno)
            AND roleid IN (
                'R2',
                'R4',
                'R6'
            );
        RETURN 'Done';
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'ERROR';        
    END checkEmpnoDeptR2R4R6;  
        
    --SEND MAIL NOT POSTED
    --R6
    FUNCTION checkEmpnoDeptR6 (
        p_user_identity_empno       IN   VARCHAR2,
        p_assign                    IN   VARCHAR2
    ) RETURN VARCHAR2 AS
        v_empno ngts_vuser_dept_roles.empno%TYPE;
    BEGIN
        SELECT
            empno
        INTO v_empno
        FROM
            timecurr.ngts_vuser_dept_roles
        WHERE
            deptno = TRIM(p_assign)
            AND empno = TRIM(p_user_identity_empno)
            AND roleid = 'R6';
        RETURN 'Done';
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'ERROR';        
    END checkEmpnoDeptR6;     
    
END NGTS_CHECK_AUTH_RIGHTS;

/
