--------------------------------------------------------
--  DDL for Package Body NGTS_BULK_TIMESHEET
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."NGTS_BULK_TIMESHEET" AS

    FUNCTION bulklocktimesheetmain (
        p_ids            id_in_table,
        p_user_identity_name   VARCHAR2
    ) RETURN SYS_REFCURSOR IS
        o_cursor  SYS_REFCURSOR;
        out_rec   ngts_id_out_record := ngts_id_out_record(null,null);
        out_tab   ngts_id_out_table  := ngts_id_out_table();
        v_msg     VARCHAR2(4000);
    BEGIN
        FOR i IN 1..p_ids.count LOOP
            v_msg := bulklocktimesheet(p_ids(i), p_user_identity_name);
            out_tab.extend;
            out_rec.mastkeyid := p_ids(i);
            out_rec.msg := v_msg;
            out_tab(1) := out_rec;
            
        END LOOP;        

        OPEN o_cursor FOR SELECT out_rec.mastkeyid, out_rec.msg from dual;
        RETURN o_cursor;
    END;

    --LOCK BULK TIMESHEET BY
    --R2 Role 2	Secretary / FocalPoint     
    --R4 Role 4	HoD
    FUNCTION bulkLockTimesheet (
        p_id                    VARCHAR2,
        p_user_identity_name    VARCHAR2
    ) RETURN VARCHAR2 IS
    BEGIN
        UPDATE time_mast
        SET
            locked = 1
        WHERE
            Nvl(locked, 0) = 0
            AND yymm = ngts_emp_access_roles.get_univ_pros_month
            AND mastkeyid = TRIM(p_id);
        
        IF SQL%FOUND THEN
            INSERT INTO ngts_wf_log
                SELECT
                    sysdate,
                    (
                        SELECT
                            tableid
                        FROM
                            ngts_wf_log_tables_mast
                        WHERE
                            tablename = 'TIME_MAST'
                    ),
                    (
                        SELECT
                            processid
                        FROM
                            ngts_wf_log_process_mast
                        WHERE
                            processname = 'LOCKED'
                    ),
                    ngts_check_auth_rights.get_empno(p_user_identity_name),
                    TRIM(p_id)
                FROM
                    dual;
        
            COMMIT;
            RETURN 'Done';
        ELSE
            ROLLBACK;
            RETURN 'No such record found to lock';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN            
            RETURN 'Err - ' || sqlcode || ' - ' || sqlerrm;
    END bulkLockTimesheet;              
    
    
    --UNLOCK BULK TIMESHEET BY
    --R2 Role 2	Secretary / FocalPoint     
    --R4 Role 4	HoD
    FUNCTION bulkUnLockTimesheet (
        p_id                    VARCHAR2,
        p_user_identity_name    VARCHAR2
    ) RETURN VARCHAR2 IS 
    BEGIN         
        UPDATE time_mast
        SET
            locked = 0
        WHERE
            locked = 1
            AND nvl(approved, 0) = 0
            AND yymm = ngts_emp_access_roles.get_univ_pros_month
            AND mastkeyid = TRIM(p_id);

        IF SQL%FOUND THEN    
            INSERT INTO ngts_wf_log
                SELECT
                    sysdate,
                    (
                        SELECT
                            tableid
                        FROM
                            ngts_wf_log_tables_mast
                        WHERE
                            tablename = 'TIME_MAST'
                    ),
                    (
                        SELECT
                            processid
                        FROM
                            ngts_wf_log_process_mast
                        WHERE
                            processname = 'UNLOCKED'
                    ),
                    ngts_check_auth_rights.get_empno(p_user_identity_name),
                    TRIM(p_id)
                FROM
                    dual;
                    
            COMMIT;
            RETURN 'Done';
        ELSE
            ROLLBACK;
            RETURN 'No such record found to unlock';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN            
            RETURN 'Err - ' || sqlcode || ' - ' || sqlerrm;  
    END bulkUnLockTimesheet;
    
    
    --APPROVE BULK PROJ TIMESHEET BY
    --R3 Role 3	Project Manager    
    FUNCTION projApproveTimesheet (
        p_id                    VARCHAR2,
        p_projno                VARCHAR2,
        p_user_identity_name    VARCHAR2
    ) RETURN VARCHAR2 IS
        nLocked time_mast.locked%TYPE;
    BEGIN
        SELECT
            Nvl(locked,0)
        INTO nLocked
        FROM
            time_mast
        WHERE
            yymm = ngts_emp_access_roles.get_univ_pros_month
            AND mastkeyid = TRIM(p_id);

        IF nLocked = 1 THEN        
            UPDATE time_daily
            SET
                pmapproved = 1
            WHERE
                Nvl(pmapproved,0) = 0
                AND SUBSTR(projno, 1, 5) = TRIM(p_projno)
                AND yymm = ngts_emp_access_roles.get_univ_pros_month
                AND mastkeyid = TRIM(p_id);    
            
            IF SQL%FOUND THEN    
                INSERT INTO ngts_wf_log
                    SELECT
                        sysdate,
                        (
                            SELECT
                                tableid
                            FROM
                                ngts_wf_log_tables_mast
                            WHERE
                                tablename = 'TIME_DAILY'
                        ),
                        (
                            SELECT
                                processid
                            FROM
                                ngts_wf_log_process_mast
                            WHERE
                                processname = 'PM APPROVED'
                        ),
                        ngts_check_auth_rights.get_empno(p_user_identity_name),
                        dailykeyid
                    FROM
                        time_daily
                    WHERE                
                        SUBSTR(projno, 1, 5) = TRIM(p_projno)
                        AND yymm = ngts_emp_access_roles.get_univ_pros_month
                        AND mastkeyid = TRIM(p_id);                
            END IF;                    

            UPDATE time_ot
            SET
                pmapproved = 1
            WHERE
                Nvl(pmapproved,0) = 0
                AND SUBSTR(projno, 1, 5) = TRIM(p_projno)
                AND yymm = ngts_emp_access_roles.get_univ_pros_month
                AND mastkeyid = TRIM(p_id);                
            
            IF SQL%FOUND THEN    
                INSERT INTO ngts_wf_log
                    SELECT
                        sysdate,
                        (
                            SELECT
                                tableid
                            FROM
                                ngts_wf_log_tables_mast
                            WHERE
                                tablename = 'TIME_OT'
                        ),
                        (
                            SELECT
                                processid
                            FROM
                                ngts_wf_log_process_mast
                            WHERE
                                processname = 'PM APPROVED'
                        ),
                        ngts_check_auth_rights.get_empno(p_user_identity_name),
                        otkeyid
                    FROM
                        time_ot
                    WHERE                
                        SUBSTR(projno, 1, 5) = TRIM(p_projno)
                        AND yymm = ngts_emp_access_roles.get_univ_pros_month
                        AND mastkeyid = TRIM(p_id);
            END IF;                    
                
            COMMIT;
            RETURN 'Done';
        ELSE
            RETURN 'No such record found for Project approval';
        END IF;                   
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Err - ' || sqlcode || ' - ' || sqlerrm;  
    END projApproveTimesheet;
    

    --APPROVE BULK TIMESHEET BY
    --R2 Role 2	Secretary / FocalPoint     
    --R4 Role 4	HoD
    FUNCTION bulkApproveTimesheet (
        p_yymm                  VARCHAR2,
        p_id                    VARCHAR2,
        p_user_identity_name    VARCHAR2
    ) RETURN VARCHAR2 IS
        nPMApproved NUMBER;
    BEGIN       
        BEGIN
            SELECT
                pmapproved
            INTO nPMApproved
            FROM
                (
                    SELECT
                        projno, nvl(pmapproved, 0) pmapproved
                    FROM
                        (
                            SELECT
                                projno, pmapproved
                            FROM
                                time_daily
                            WHERE
                                yymm = ngts_emp_access_roles.get_univ_pros_month
                                AND mastkeyid = TRIM(p_id)
                                
                                
                            UNION ALL
                            
                            SELECT
                                projno, pmapproved
                            FROM
                                time_ot
                            WHERE
                                yymm = ngts_emp_access_roles.get_univ_pros_month
                                AND mastkeyid = TRIM(p_id)                                
                        )
                    WHERE
                        projno IN (
                            SELECT
                                projno
                            FROM
                                projmast
                            WHERE
                                nvl(active, 0) = 1
                                AND to_number(TO_CHAR(revcdate, 'YYYYMM')) >= to_number(TRIM(p_yymm))                            
                                AND nvl(timesheet_appr, 0) = 1
                        )
                    ORDER BY
                        pmapproved
                )
            WHERE
                ROWNUM = 1;
        EXCEPTION
            WHEN OTHERS THEN
                nPMApproved := 1;
        END;
    
        IF nPMApproved = 1 THEN
            UPDATE time_mast
            SET
                approved = 1
            WHERE
                nvl(approved, 0) = 0
                AND nvl(locked, 0) = 1
                AND yymm = ngts_emp_access_roles.get_univ_pros_month
                AND mastkeyid = TRIM(p_id);
                
            IF SQL%FOUND THEN    
                INSERT INTO ngts_wf_log
                    SELECT
                        sysdate,
                        (
                            SELECT
                                tableid
                            FROM
                                ngts_wf_log_tables_mast
                            WHERE
                                tablename = 'TIME_MAST'
                        ),
                        (
                            SELECT
                                processid
                            FROM
                                ngts_wf_log_process_mast
                            WHERE
                                processname = 'HOD APPROVED'
                        ),
                        ngts_check_auth_rights.get_empno(p_user_identity_name),
                        TRIM(p_id)
                    FROM
                        dual;
            
                COMMIT;
                RETURN 'Done';
            ELSE
                ROLLBACK;
                RETURN 'No such record found for Approval';
            END IF;
        ELSE            
            RETURN 'No such record found for Approval';
        END IF;    
        
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Err - ' || sqlcode || ' - ' || sqlerrm;
    END bulkApproveTimesheet;
    
   
    --APPROVE BULK PROJ TIMESHEET BY
    --R3 Role 3	Project Manager    
    FUNCTION projUnApproveTimesheet (
        p_id                    VARCHAR2,
        p_projno                VARCHAR2,
        p_user_identity_name    VARCHAR2
    ) RETURN VARCHAR2 IS
        nApproved time_mast.approved%TYPE;
    BEGIN
        SELECT
            nvl(approved, 0)
        INTO nApproved
        FROM
            time_mast
        WHERE
            yymm = ngts_emp_access_roles.get_univ_pros_month
            AND mastkeyid = TRIM(p_id);

        IF nApproved = 0 THEN
            UPDATE time_daily
            SET
                pmapproved = 0
            WHERE
                nvl(pmapproved, 0) = 1
                AND SUBSTR(projno, 1, 5) = TRIM(p_projno)
                AND yymm = ngts_emp_access_roles.get_univ_pros_month
                AND mastkeyid = TRIM(p_id);
            
            IF SQL%FOUND THEN                
                INSERT INTO ngts_wf_log
                    SELECT
                        sysdate,
                        (
                            SELECT
                                tableid
                            FROM
                                ngts_wf_log_tables_mast
                            WHERE
                                tablename = 'TIME_DAILY'
                        ),
                        (
                            SELECT
                                processid
                            FROM
                                ngts_wf_log_process_mast
                            WHERE
                                processname = 'PM UNAPPROVED'
                        ),
                        ngts_check_auth_rights.get_empno(p_user_identity_name),
                        dailykeyid
                    FROM
                        time_daily
                    WHERE                
                        SUBSTR(projno, 1, 5) = TRIM(p_projno)
                        AND yymm = ngts_emp_access_roles.get_univ_pros_month
                        AND mastkeyid = TRIM(p_id);       
            END IF;

            UPDATE time_ot
            SET
                pmapproved = 0
            WHERE
                nvl(pmapproved, 0) = 1
                AND SUBSTR(projno, 1, 5) = TRIM(p_projno)
                AND yymm = ngts_emp_access_roles.get_univ_pros_month
                AND mastkeyid = TRIM(p_id);
            
            IF SQL%FOUND THEN    
                INSERT INTO ngts_wf_log
                    SELECT
                        sysdate,
                        (
                            SELECT
                                tableid
                            FROM
                                ngts_wf_log_tables_mast
                            WHERE
                                tablename = 'TIME_OT'
                        ),
                        (
                            SELECT
                                processid
                            FROM
                                ngts_wf_log_process_mast
                            WHERE
                                processname = 'PM UNAPPROVED'
                        ),
                        ngts_check_auth_rights.get_empno(p_user_identity_name),
                        otkeyid
                    FROM
                        time_ot
                    WHERE                
                        SUBSTR(projno, 1, 5) = TRIM(p_projno)
                        AND yymm = ngts_emp_access_roles.get_univ_pros_month
                        AND mastkeyid = TRIM(p_id);                
            END IF;
            
            COMMIT;
            RETURN 'Done';
        ELSE
            RETURN 'No such record found for reversal of Project Approval';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Err - ' || sqlcode || ' - ' || sqlerrm;
    END projunapprovetimesheet;
    

    --APPROVE BULK TIMESHEET BY
    --R2 Role 2	Secretary / FocalPoint     
    --R4 Role 4	HoD
    FUNCTION bulkUnApproveTimesheet (
        p_id                    VARCHAR2,
        p_user_identity_name    VARCHAR2
    ) RETURN VARCHAR2 IS        
    BEGIN          
        UPDATE time_mast
        SET
            approved = 0
        WHERE            
			Nvl(approved, 0) = 1          
            AND Nvl(posted,0) = 0
            AND yymm = ngts_emp_access_roles.get_univ_pros_month
            AND mastkeyid = TRIM(p_id);
            
        IF SQL%FOUND THEN 
            INSERT INTO ngts_wf_log
                SELECT
                    sysdate,
                    (
                        SELECT
                            tableid
                        FROM
                            ngts_wf_log_tables_mast
                        WHERE
                            tablename = 'TIME_MAST'
                    ),
                    (
                        SELECT
                            processid
                        FROM
                            ngts_wf_log_process_mast
                        WHERE
                            processname = 'HOD UNAPPROVED'
                    ),
                    ngts_check_auth_rights.get_empno(p_user_identity_name),
                    TRIM(p_id)
                FROM
                    dual;
        
            COMMIT;
            RETURN 'Done';
        ELSE
            ROLLBACK;
            RETURN 'No such record found for reversal of Approval';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Err - ' || sqlcode || ' - ' || sqlerrm;
    END bulkUnApproveTimesheet;
    
        
    --POST TIMESHEET BY
    --R4 Role 4	HoD & R6 Role 6 PROCO    
    FUNCTION bulkPostTimesheet (
        p_id                    VARCHAR2,
        p_user_identity_name    VARCHAR2
    ) RETURN VARCHAR2 IS       
    BEGIN
        UPDATE time_mast
        SET
            posted = 1
        WHERE            
			Nvl(posted, 0) = 0
            AND Nvl(approved, 0) = 1
            AND yymm = ngts_emp_access_roles.get_univ_pros_month
            AND mastkeyid = TRIM(p_id);
            
        IF SQL%FOUND THEN
            DELETE FROM timetran
            WHERE
                ( yymm,
                  empno,
                  costcode ) = (
                    SELECT
                        yymm,
                        empno,
                        assign
                    FROM
                        time_mast
                    WHERE
                        yymm = ngts_emp_access_roles.get_univ_pros_month
                        AND mastkeyid = TRIM(p_id)
                );
        
            INSERT INTO timetran (
                yymm,
                empno,
                costcode,
                projno,
                company,
                wpcode,
                activity,
                grp,
                hours,
                othours,
                parent,
                reasoncode
            )
                SELECT
                    yymm,
                    empno,
                    assign,
                    projno,
                    company,
                    wpcode,
                    activity,
                    grp,
                    SUM(nhrs),
                    SUM(ohrs),
                    parent,
                    reasoncode
                FROM
                    postingdata
                WHERE                    
                    yymm = ngts_emp_access_roles.get_univ_pros_month
                    AND mastkeyid = TRIM(p_id)                    
                GROUP BY
                    yymm,
                    empno,
                    assign,
                    projno,
                    company,
                    wpcode,
                    activity,
                    grp,
                    parent,
                    reasoncode;

            INSERT INTO ngts_wf_log
                SELECT
                    sysdate,
                    (
                        SELECT
                            tableid
                        FROM
                            ngts_wf_log_tables_mast
                        WHERE
                            tablename = 'TIME_MAST'
                    ),
                    (
                        SELECT
                            processid
                        FROM
                            ngts_wf_log_process_mast
                        WHERE
                            processname = 'POSTED'
                    ),
                    ngts_check_auth_rights.get_empno(p_user_identity_name),
                    TRIM(p_id)
                FROM
                    dual;
            
            COMMIT;
            RETURN 'Done';                    
        ELSE
            ROLLBACK;
            RETURN 'No such record found for Posting';
        END IF;
        
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Err - ' || sqlcode || ' - ' || sqlerrm;
    END bulkPostTimesheet;  
    
    
    --UNPOST TIMESHEET BY
    --R4 Role 4	HoD
    FUNCTION bulkUnPostTimesheet (
        p_id                    VARCHAR2,
        p_user_identity_name    VARCHAR2
    ) RETURN VARCHAR2 IS       
    BEGIN
        UPDATE time_mast
        SET
            posted = 0
        WHERE            
			Nvl(posted, 0) = 1
            AND yymm = ngts_emp_access_roles.get_univ_pros_month
            AND mastkeyid = TRIM(p_id);
            
        IF SQL%FOUND THEN
            DELETE FROM timetran
            WHERE
                ( yymm,
                  empno,
                  costcode ) = (
                    SELECT
                        yymm,
                        empno,
                        assign
                    FROM
                        time_mast
                    WHERE
                        yymm = ngts_emp_access_roles.get_univ_pros_month
                        AND mastkeyid = TRIM(p_id)
                );                
            
            INSERT INTO tm_history
                SELECT
                    yymm,
                    empno,
                    assign,
                    sysdate,
                    nvl(posted, 0),                    
                    ngts_check_auth_rights.get_empno(p_user_identity_name)
                FROM
                    time_mast
                WHERE
                    yymm = ngts_emp_access_roles.get_univ_pros_month
                    AND mastkeyid = TRIM(p_id);            
            
            INSERT INTO ngts_wf_log
                SELECT
                    sysdate,
                    (
                        SELECT
                            tableid
                        FROM
                            ngts_wf_log_tables_mast
                        WHERE
                            tablename = 'TIME_MAST'
                    ),
                    (
                        SELECT
                            processid
                        FROM
                            ngts_wf_log_process_mast
                        WHERE
                            processname = 'UNPOSTED'
                    ),
                    ngts_check_auth_rights.get_empno(p_user_identity_name),
                    TRIM(p_id)
                FROM
                    dual;

            COMMIT;
            RETURN 'Done';
        ELSE
            ROLLBACK;
            RETURN 'No such record found for UnPosting';
        END IF;
        
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Err - ' || sqlcode || ' - ' || sqlerrm;
    END bulkUnPostTimesheet;                      
    
    
    --DELETE BULK TIMESHEET BY
    --R2 Role 2	Secretary / FocalPoint     
    --R4 Role 4	HoD
    FUNCTION bulkDeleteTimesheet (
        p_id                    VARCHAR2,
        p_user_identity_name    VARCHAR2
    ) RETURN VARCHAR2 IS
        nLocked time_mast.locked%TYPE;
        nPMApproved Number;
    BEGIN
        SELECT
            nvl(locked, 0)
        INTO nLocked
        FROM
            time_mast
        WHERE
            yymm = ngts_emp_access_roles.get_univ_pros_month
            AND mastkeyid = TRIM(p_id);

        IF nLocked = 0 THEN        
            SELECT
                pmapproved
            INTO npmapproved
            FROM
                (
                    SELECT
                        pmapproved
                    FROM
                        (
                            SELECT
                                nvl(pmapproved, 0) pmapproved
                            FROM
                                time_daily
                            WHERE
                                yymm = ngts_emp_access_roles.get_univ_pros_month
                                AND mastkeyid = TRIM(p_id)
                                
                            UNION ALL
                            
                            SELECT
                                nvl(pmapproved, 0) pmapproved
                            FROM
                                time_ot
                            WHERE
                                yymm = ngts_emp_access_roles.get_univ_pros_month
                                AND mastkeyid = TRIM(p_id)
                        )
                    ORDER BY
                        pmapproved DESC
                )
            WHERE
                ROWNUM = 1;        
        
            IF npmapproved = 0 THEN      
                BEGIN
                    INSERT INTO ngts_wf_log
                        SELECT
                            sysdate,
                            (
                                SELECT
                                    tableid
                                FROM
                                    ngts_wf_log_tables_mast
                                WHERE
                                    tablename = 'TIME_OT'
                            ),
                            (
                                SELECT
                                    processid
                                FROM
                                    ngts_wf_log_process_mast
                                WHERE
                                    processname = 'DELETED'
                            ),
                            ngts_check_auth_rights.get_empno(p_user_identity_name),
                            otkeyid
                        FROM
                            time_ot
                        WHERE                
                            yymm = ngts_emp_access_roles.get_univ_pros_month
                            AND mastkeyid = TRIM(p_id);                
                EXCEPTION
                    WHEN OTHERS THEN
                        NULL;                        
                END;
                    
                DELETE time_ot
                WHERE                    
                    yymm = ngts_emp_access_roles.get_univ_pros_month
                    AND mastkeyid = TRIM(p_id);

                BEGIN
                  INSERT INTO ngts_wf_log
                    SELECT
                        sysdate,
                        (
                            SELECT
                                tableid
                            FROM
                                ngts_wf_log_tables_mast
                            WHERE
                                tablename = 'TIME_DAILY'
                        ),
                        (
                            SELECT
                                processid
                            FROM
                                ngts_wf_log_process_mast
                            WHERE
                                processname = 'DELETED'
                        ),
                        ngts_check_auth_rights.get_empno(p_user_identity_name),
                        dailykeyid
                    FROM
                        time_daily
                    WHERE                
                        yymm = ngts_emp_access_roles.get_univ_pros_month
                        AND mastkeyid = TRIM(p_id);                
                EXCEPTION
                    WHEN OTHERS THEN
                        NULL;                        
                END;
                
                DELETE time_daily
                WHERE                    
                    yymm = ngts_emp_access_roles.get_univ_pros_month
                    AND mastkeyid = TRIM(p_id);                    
                
                DELETE time_mast
                WHERE         
                    yymm = ngts_emp_access_roles.get_univ_pros_month
                    AND mastkeyid = TRIM(p_id);

                INSERT INTO ngts_wf_log
                    SELECT
                        sysdate,
                        (
                            SELECT
                                tableid
                            FROM
                                ngts_wf_log_tables_mast
                            WHERE
                                tablename = 'TIME_MAST'
                        ),
                        (
                            SELECT
                                processid
                            FROM
                                ngts_wf_log_process_mast
                            WHERE
                                processname = 'DELETED'
                        ),
                        ngts_check_auth_rights.get_empno(p_user_identity_name),
                        TRIM(p_id)
                    FROM
                        dual;
                
                COMMIT;
                RETURN 'Done';
            ELSE
                RETURN 'Can''t delete record as Project is approved';
            END IF;
         ELSE
            RETURN 'Can''t delete record as it is locked';
         END IF;            
        
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Err - ' || sqlcode || ' - ' || sqlerrm;
    END bulkDeleteTimesheet;     
    
    
    --SEND MAIL TO USERS WHO HAVE NOT FILLED THEIR TIMESHEETS
    --R2 Role 2	Secretary / FocalPoint    
    --R4 Role 4	HoD
    --R6 ROLE 6 PROCO    
    Function sendMailNotFilledTimesheet (
        p_yymm                  VARCHAR2, 
        p_assign                VARCHAR2,
        p_user_identity_name    VARCHAR2
    ) RETURN SYS_REFCURSOR IS                  
        o_cursor        SYS_REFCURSOR;
    BEGIN                        
        OPEN o_cursor FOR SELECT
                              NULL mailto,
                              NULL mailcc,
                              a.email mailbcc,
                              'Timesheet not yet Created' mailsubject,
                              createnotfilledmailbody(p_yymm, (
                                SELECT
                                    name
                                FROM
                                    emplmast
                                WHERE
                                    empno = TRIM(ngts_check_auth_rights.get_empno(p_user_identity_name))
                              )) mailbody,
                              'Text' mailtype,
                              c_mail_from mailfrom
                          FROM
                              emplmast a
                          WHERE
                              a.emptype IN (
                                  SELECT
                                      emptype
                                  FROM
                                      emptypemast
                                  WHERE
                                      nvl(tm, 0) = 1
                              )
                              AND nvl(a.status, 0) = 1
                              AND a.email IS NOT NULL
                              AND NOT EXISTS (
                                  SELECT
                                      time_mast.*
                                  FROM
                                      time_mast b
                                  WHERE
                                      b.yymm = TRIM(p_yymm)
                                      AND b.yymm = ngts_emp_access_roles.get_univ_pros_month
                                      AND b.empno = a.empno
                              )
                              AND EXISTS (
                                  SELECT
                                      c.*
                                  FROM
                                      costmast c
                                  WHERE
                                      c.costcode LIKE '02%'
                                      AND nvl(c.active, 0) = 1
                                      AND c.costcode = a.assign                                      
                                      AND c.costcode NOT IN (SELECT deptno FROM ngts_deputation_dept)
                              )
                              AND nvl(a.costhead, 0) = 0
                              AND a.assign = TRIM(p_assign)
                          ORDER BY
                              a.empno;                        
        RETURN o_cursor;
    END sendMailNotFilledTimesheet;


    --SEND MAIL TO USERS WHO HAVE INVALID TIMESHEETS
    --R2 Role 2	Secretary / FocalPoint    
    --R4 Role 4	HoD
    --R6 ROLE 6 PROCO    
    Function sendMailInvalidTimesheet (
        p_yymm                  VARCHAR2, 
        p_assign                VARCHAR2,
        p_user_identity_name    VARCHAR2
    ) RETURN SYS_REFCURSOR IS                  
        o_cursor        SYS_REFCURSOR;             
    BEGIN
        OPEN o_cursor FOR SELECT
                              NULL mailto,
                              NULL mailcc,
                              a.email mailbcc,
                              'Timesheet is Invalid' mailsubject,
                              createInvalidMailBody(p_yymm, a.empno, a.name, a.assign, ngts_timesheet.ngts_getworkinghours(p_yymm, a.empno), (
                                SELECT
                                    name
                                FROM
                                    emplmast
                                WHERE
                                    empno = TRIM(ngts_check_auth_rights.get_empno(p_user_identity_name))
                              )) mailbody,
                              'Text' mailtype,
                              c_mail_from   mailfrom
                          FROM
                              emplmast a
                          WHERE
                              a.emptype IN (
                                  SELECT
                                      emptype
                                  FROM
                                      emptypemast
                                  WHERE
                                      nvl(tm, 0) = 1
                              )
                              AND nvl(a.status, 0) = 1
                              AND a.email IS NOT NULL
                              AND ngts_timesheet.ngts_getworkinghours(p_yymm, a.empno) != (
                                  SELECT
                                      SUM(
                                          CASE
                                              WHEN nvl(d1, 0) > 0 THEN
                                                  nvl(d1, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d2, 0) > 0 THEN
                                                  nvl(d2, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d3, 0) > 0 THEN
                                                  nvl(d3, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d4, 0) > 0 THEN
                                                  nvl(d4, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d5, 0) > 0 THEN
                                                  nvl(d5, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d6, 0) > 0 THEN
                                                  nvl(d6, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d7, 0) > 0 THEN
                                                  nvl(d7, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d8, 0) > 0 THEN
                                                  nvl(d8, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d9, 0) > 0 THEN
                                                  nvl(d9, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d10, 0) > 0 THEN
                                                  nvl(d10, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d11, 0) > 0 THEN
                                                  nvl(d11, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d12, 0) > 0 THEN
                                                  nvl(d12, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d13, 0) > 0 THEN
                                                  nvl(d13, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d14, 0) > 0 THEN
                                                  nvl(d14, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d15, 0) > 0 THEN
                                                  nvl(d15, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d16, 0) > 0 THEN
                                                  nvl(d16, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d17, 0) > 0 THEN
                                                  nvl(d17, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d18, 0) > 0 THEN
                                                  nvl(d18, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d19, 0) > 0 THEN
                                                  nvl(d19, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d20, 0) > 0 THEN
                                                  nvl(d20, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d21, 0) > 0 THEN
                                                  nvl(d21, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d22, 0) > 0 THEN
                                                  nvl(d22, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d23, 0) > 0 THEN
                                                  nvl(d23, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d24, 0) > 0 THEN
                                                  nvl(d24, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d25, 0) > 0 THEN
                                                  nvl(d25, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d26, 0) > 0 THEN
                                                  nvl(d26, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d27, 0) > 0 THEN
                                                  nvl(d27, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d28, 0) > 0 THEN
                                                  nvl(d28, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d29, 0) > 0 THEN
                                                  nvl(d29, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d30, 0) > 0 THEN
                                                  nvl(d30, 0)
                                              ELSE
                                                  0
                                          END
                                          +
                                          CASE
                                              WHEN nvl(d31, 0) > 0 THEN
                                                  nvl(d31, 0)
                                              ELSE
                                                  0
                                          END
                                      ) d
                                  FROM
                                      time_daily b
                                  WHERE
                                      b.yymm = TRIM(p_yymm)
                                      AND b.wpcode != 4
                                      AND b.yymm = ngts_emp_access_roles.get_univ_pros_month
                                      AND b.empno = a.empno
                              )
                              AND EXISTS (
                                  SELECT
                                      c.*
                                  FROM
                                      costmast c
                                  WHERE
                                      c.costcode LIKE '02%'
                                      AND nvl(c.active, 0) = 1
                                      AND c.costcode = a.assign
                                      AND c.costcode NOT IN (SELECT deptno FROM ngts_deputation_dept)
                              )
                              AND nvl(a.costhead, 0) = 0
                              AND a.assign = TRIM(p_assign)
                          ORDER BY
                              a.empno;  
        
    
        RETURN o_cursor;    
    END sendMailInvalidTimesheet;

    --SEND MAIL TO USERS WHO HAVE NOT LOCKED THEIR TIMESHEETS
    --R2 Role 2	Secretary / FocalPoint    
    --R4 Role 4	HoD
    --R6 ROLE 6 PROCO    
    Function sendMailNotLockedTimesheet (
        p_yymm                  VARCHAR2, 
        p_assign                VARCHAR2,
        p_user_identity_name    VARCHAR2
    ) RETURN SYS_REFCURSOR IS       
        o_cursor        SYS_REFCURSOR;
    BEGIN
        OPEN o_cursor FOR SELECT
                              NULL mailto,
                              NULL mailcc,
                              a.email       mailbcc,
                              'Timesheet not yet Locked' mailsubject,
                              createnotlockedmailbody(p_yymm,(
                                  SELECT
                                      name
                                  FROM
                                      emplmast
                                  WHERE
                                      empno = TRIM(ngts_check_auth_rights.get_empno(p_user_identity_name))
                              )) mailbody,
                              'Text' mailtype,
                              c_mail_from   mailfrom
                          FROM
                              emplmast a
                          WHERE
                              a.emptype IN (
                                  SELECT
                                      emptype
                                  FROM
                                      emptypemast
                                  WHERE
                                      nvl(tm, 0) = 1
                              )
                              AND nvl(a.status, 0) = 1
                              AND a.email IS NOT NULL
                              AND EXISTS (
                                  SELECT
                                      b.*
                                  FROM
                                      time_mast b
                                  WHERE
                                      nvl(locked, 0) = 0
                                      AND b.yymm = TRIM(p_yymm)
                                      AND b.yymm = ngts_emp_access_roles.get_univ_pros_month
                                      AND b.empno = a.empno
                                      AND b.assign = TRIM(p_assign)
                                      AND EXISTS (
                                          SELECT
                                              c.*
                                          FROM
                                              costmast c
                                          WHERE
                                              c.costcode LIKE '02%'
                                              AND nvl(c.active, 0) = 1
                                              AND c.costcode = TRIM(p_assign)
                                              AND c.costcode NOT IN (
                                                  SELECT
                                                      deptno
                                                  FROM
                                                      ngts_deputation_dept
                                              )
                                      )
                              )
                          ORDER BY
                              a.empno;
    
        RETURN o_cursor;
    END sendMailNotLockedTimesheet;
    
    
    --SEND MAIL TO PROJECT USERS WHO HAVE NOT LOCKED THEIR TIMESHEETS    
    --R3 Role 3	Project Manager
    Function sendMailNotLockedProjTimesheet (
        p_yymm                  VARCHAR2, 
        p_projno                VARCHAR2,
        p_user_identity_name    VARCHAR2
    ) RETURN SYS_REFCURSOR IS        
        o_cursor        SYS_REFCURSOR;
    BEGIN
        OPEN o_cursor FOR SELECT
                              NULL mailto,
                              NULL mailcc,
                              a.email mailbcc,
                              'Timesheet not yet Locked' mailsubject,
                              createNotLockedMailBody(p_yymm, (
                                SELECT
                                    name
                                FROM
                                    emplmast
                                WHERE
                                    empno = TRIM(ngts_check_auth_rights.get_empno(p_user_identity_name))
                              )) mailbody,
                              'Text' mailtype,
                              c_mail_from mailfrom
                          FROM
                              emplmast a
                          WHERE
                              a.emptype IN (
                                  SELECT
                                      emptype
                                  FROM
                                      emptypemast
                                  WHERE
                                      nvl(tm, 0) = 1
                              )
                              AND nvl(a.status, 0) = 1
                              AND a.email IS NOT NULL
                              AND EXISTS (
                                  SELECT
                                      time_mast.*
                                  FROM
                                      time_mast b
                                  WHERE
                                      nvl(locked, 0) = 0
                                      AND b.yymm = TRIM(p_yymm)
                                      AND b.yymm = ngts_emp_access_roles.get_univ_pros_month
                                      AND b.empno = a.empno
                              )
                              AND EXISTS (
                                  SELECT
                                      c.*
                                  FROM
                                      costmast c
                                  WHERE
                                      c.costcode LIKE '02%'
                                      AND nvl(c.active, 0) = 1
                                      AND c.costcode = a.assign
                                      AND c.costcode NOT IN (SELECT deptno FROM ngts_deputation_dept)
                              )
                              AND EXISTS (
                                  SELECT
                                      td.*
                                  FROM
                                      time_daily td
                                  WHERE
                                      td.yymm = TRIM(p_yymm)
                                      AND substr(td.projno, 1, 5) = TRIM(p_projno)
                                      AND td.yymm = ngts_emp_access_roles.get_univ_pros_month
                                      AND td.empno = a.empno
                                      
                                  UNION ALL
                                  
                                  SELECT
                                      ot.*
                                  FROM
                                      time_ot ot
                                  WHERE
                                      ot.yymm = TRIM(p_yymm)
                                      AND substr(ot.projno, 1, 5) = TRIM(p_projno)
                                      AND ot.yymm = ngts_emp_access_roles.get_univ_pros_month
                                      AND ot.empno = a.empno
                              )
                          ORDER BY
                              a.empno;     
        RETURN o_cursor;          
    END sendMailNotLockedProjTimesheet;
    
    
    --SEND MAIL TO HoDs WHO HAVE NOT YET POSTED THEIR EMPLOYEES TIMESHEETS'
    --R6 ROLE 6 PROCO
    FUNCTION sendMailNotPostedTimesheet (
        p_yymm                 VARCHAR2,
        p_assign               VARCHAR2,
        p_user_identity_name   VARCHAR2
    ) RETURN SYS_REFCURSOR IS
        o_cursor SYS_REFCURSOR;
    BEGIN
        OPEN o_cursor FOR SELECT DISTINCT
                              NULL mailto,
                              NULL mailcc,
                              c.email       mailbcc,
                              'Timesheets Pending for your Approval/Posting' mailsubject,
                              b.costcode    costcode,
                              b.name        name,
                              'Text' mailtype,
                              c_mail_from   mailfrom
                          FROM
                              emplmast   a,
                              costmast   b,
                              emplmast   c
                          WHERE
                              b.hod = c.empno
                              AND c.email IS NOT NULL
                              AND nvl(c.status, 0) = 1
                              AND a.emptype IN (
                                  SELECT
                                      emptype
                                  FROM
                                      emptypemast
                                  WHERE
                                      nvl(tm, 0) = 1
                              )
                              AND nvl(a.status, 0) = 1
                              AND a.assign LIKE '02%'
                              AND b.costcode NOT IN (
                                  SELECT
                                      deptno
                                  FROM
                                      ngts_deputation_dept
                              )
                              AND ( ( a.assign = b.costcode
                                      AND NOT EXISTS (
                                  SELECT
                                      time_mast.*
                                  FROM
                                      time_mast d
                                  WHERE
                                      nvl(d.posted, 0) = 1
                                      AND d.yymm = TRIM(p_yymm)
                                      AND d.yymm = ngts_emp_access_roles.get_univ_pros_month
                                      AND d.empno = a.empno
                              )
                                      AND a.assign = TRIM(p_assign) )
                                    OR EXISTS (
                                  SELECT
                                      time_mast.*
                                  FROM
                                      time_mast d
                                  WHERE
                                      ( d.locked = 0
                                        OR d.approved = 0
                                        OR d.posted = 0 )
                                      AND d.yymm = TRIM(p_yymm)
                                      AND d.yymm = ngts_emp_access_roles.get_univ_pros_month
                                      AND d.empno = a.empno
                                      AND d.assign = b.costcode
                                      AND d.assign = TRIM(p_assign)
                              ) )
                          ORDER BY
                              c.email;

        RETURN o_cursor;
    END sendmailnotpostedtimesheet;
    
    
    --CREATE MAIL BODY 
    --CALLED BY sendMailNotFilledTimesheet    
    FUNCTION createNotFilledMailBody (
        p_yymm             VARCHAR2,
        p_empname_logged   VARCHAR2
    ) RETURN VARCHAR2 IS
        p_create_msg VARCHAR2(4000);
    BEGIN
        p_create_msg := 'Dear Sir/Madam,' || CHR(13)||CHR(10) || CHR(13)||CHR(10) || CHR(13)||CHR(10);
        p_create_msg := p_create_msg || 'This is to inform you that Timesheet has not yet been Created by you for this month.' || CHR(13)||CHR(10) || CHR(13)||CHR(10);
        p_create_msg := p_create_msg || 'Do the needful at the earliest.' || CHR(13)||CHR(10) || CHR(13)||CHR(10);
        p_create_msg := p_create_msg || 'Waiting for Creating of Timesheet for the month ' || p_yymm ||'.' || CHR(13)||CHR(10) || CHR(13)||CHR(10) || CHR(13)||CHR(10);
        --p_create_msg := p_create_msg || 'Timesheet details are as follows' || CHR(13)||CHR(10) || CHR(13)||CHR(10) || CHR(13)||CHR(10);
        --p_create_msg := p_create_msg || 'Empno : ' || p_empno || ' ' || p_name || CHR(13)||CHR(10) || CHR(13)||CHR(10);
        --p_create_msg := p_create_msg || 'Assigned Costcode : ' || p_assign || CHR(13)||CHR(10) || CHR(13)||CHR(10) || CHR(13)||CHR(10);
        p_create_msg := p_create_msg || 'Please ignore this mail if on Long Term Deputation etc.' || CHR(13)||CHR(10) || CHR(13)||CHR(10) || CHR(13)||CHR(10) || CHR(13)||CHR(10) || CHR(13)||CHR(10);
        p_create_msg := p_create_msg || 'Thanks,' || CHR(13)||CHR(10);
        p_create_msg := p_create_msg || p_empname_logged || CHR(13)||CHR(10) || CHR(13)||CHR(10) || CHR(13)||CHR(10);
        p_create_msg := p_create_msg || 'This is an automated TCMPL Mail.';
        
        RETURN p_create_msg;
    END;
    
    
    --CREATE MAIL BODY 
    --CALLED BY sendMailInvalidTimesheet    
    FUNCTION createinvalidmailbody (
        p_yymm             VARCHAR2,
        p_empno            VARCHAR2,
        p_name             VARCHAR2,
        p_assign           VARCHAR2,
        p_working_hrs      NUMBER,
        p_empname_logged   VARCHAR2
    ) RETURN VARCHAR2 IS
        p_create_msg VARCHAR2(4000);
    BEGIN
        p_create_msg := 'Dear Sir/Madam,' || CHR(13)||CHR(10) || CHR(13)||CHR(10) || CHR(13)||CHR(10);
        p_create_msg := p_create_msg || 'This is to inform you that Timesheet created by you for this month is invalid as the hours does not match the Applicable Working hours - ' || p_working_hrs ||'.'|| CHR(13)||CHR(10) || CHR(13)||CHR(10);
        p_create_msg := p_create_msg || 'Do the needful at the earliest.' || CHR(13)||CHR(10) || CHR(13)||CHR(10);
        p_create_msg := p_create_msg || 'Waiting for Timesheet to be corrected for the month ' || p_yymm ||'.' || CHR(13)||CHR(10) || CHR(13)||CHR(10) || CHR(13)||CHR(10);
        --p_create_msg := p_create_msg || 'Timesheet details are as follows' || CHR(13)||CHR(10) || CHR(13)||CHR(10) || CHR(13)||CHR(10);
        --p_create_msg := p_create_msg || 'Empno : ' || p_empno || ' ' || p_name || CHR(13)||CHR(10) || CHR(13)||CHR(10);
        --p_create_msg := p_create_msg || 'Assigned Costcode : ' || p_assign || CHR(13)||CHR(10) || CHR(13)||CHR(10) || CHR(13)||CHR(10);
        p_create_msg := p_create_msg || 'Please ignore this mail if on Long Term Deputation etc.' || CHR(13)||CHR(10) || CHR(13)||CHR(10) || CHR(13)||CHR(10) || CHR(13)||CHR(10) || CHR(13)||CHR(10);
        p_create_msg := p_create_msg || 'Thanks,' || CHR(13)||CHR(10);
        p_create_msg := p_create_msg || p_empname_logged || CHR(13)||CHR(10) || CHR(13)||CHR(10) || CHR(13)||CHR(10);
        p_create_msg := p_create_msg || 'This is an automated TCMPL Mail.';
        
        RETURN p_create_msg;
    END;    


    --CREATE MAIL BODY 
    --CALLED BY sendMailNotLockedTimesheet
    FUNCTION createnotlockedmailbody (
        p_yymm             VARCHAR2,
        p_empname_logged   VARCHAR2
    ) RETURN VARCHAR2 IS
        p_create_msg VARCHAR2(4000);
    BEGIN
        p_create_msg := 'Dear Sir/Madam,' || CHR(13)||CHR(10) || CHR(13)||CHR(10) || CHR(13)||CHR(10);
        p_create_msg := p_create_msg || 'This is to inform you that Timesheet has not been Locked by you for this month.' || CHR(13)||CHR(10) || CHR(13)||CHR(10);
        p_create_msg := p_create_msg || 'Do the needful at the earliest.' || CHR(13)||CHR(10) || CHR(13)||CHR(10);
        p_create_msg := p_create_msg || 'Waiting for Locking of Timesheet for the month ' || p_yymm ||'.' || CHR(13)||CHR(10) || CHR(13)||CHR(10) || CHR(13)||CHR(10);
        --p_create_msg := p_create_msg || 'Timesheet details are as follows' || CHR(13)||CHR(10) || CHR(13)||CHR(10) || CHR(13)||CHR(10);
        --p_create_msg := p_create_msg || 'Empno : ' || p_empno || ' ' || p_name || CHR(13)||CHR(10) || CHR(13)||CHR(10);
        --p_create_msg := p_create_msg || 'Assigned Costcode : ' || p_assign || CHR(13)||CHR(10) || CHR(13)||CHR(10) || CHR(13)||CHR(10);
        p_create_msg := p_create_msg || 'Please ignore this mail if on Long Term Deputation etc.' || CHR(13)||CHR(10) || CHR(13)||CHR(10) || CHR(13)||CHR(10) || CHR(13)||CHR(10) || CHR(13)||CHR(10);
        p_create_msg := p_create_msg || 'Thanks,' || CHR(13)||CHR(10);
        p_create_msg := p_create_msg || p_empname_logged || CHR(13)||CHR(10) || CHR(13)||CHR(10) || CHR(13)||CHR(10);
        p_create_msg := p_create_msg || 'This is an automated TCMPL Mail.';
        
        RETURN p_create_msg;
    END;


    --CREATE MAIL BODY 
    --CALLED BY sendMailNotPostedTimesheet    
    FUNCTION createnotpostedmailbody (
        p_yymm                  VARCHAR2,
        p_parent                VARCHAR2,
        p_name                  VARCHAR2,
        p_section               VARCHAR2,
        p_user_identity_name    VARCHAR2
    ) RETURN SYS_REFCURSOR IS            
        o_cursor SYS_REFCURSOR;        
    BEGIN
        IF p_section = 'TOP' THEN
            OPEN o_cursor FOR SELECT
                                  ' Dear Sir, '
                                  || CHR(13)
                                  || CHR(10)
                                  || CHR(13)
                                  || CHR(10) mailbody
                              FROM
                                  dual
                                  
                              UNION ALL
                              
                              SELECT
                                  'This is to inform you that timesheet(s) created by '
                                  || p_parent
                                  || ' '
                                  || p_name
                                  || ' is waiting for HOD''s approval for the month '
                                  || p_yymm
                                  || '.'
                                  || CHR(13)
                                  || CHR(10)
                                  || CHR(13)
                                  || CHR(10) mailbody
                              FROM
                                  dual
                              
                              UNION ALL
                              
                              SELECT
                                  'Please do the needful at the earliest.'
                                  || CHR(13)
                                  || CHR(10)
                                  || CHR(13)
                                  || CHR(10) mailbody
                              FROM
                                  dual;
        ELSIF p_section = 'UPPER MIDDLE' THEN
            OPEN o_cursor FOR SELECT
                                  'Secondly - List of Employees not Submitted / Locked / Approved timesheet(s).'
                                  || CHR(13)
                                  || CHR(10) mailbody
                              FROM
                                  dual
                              UNION ALL
                              SELECT
                                  'Ignore if these personnel are not supposed to fill timesheet.'
                                  || CHR(13)
                                  || CHR(10)
                                  || CHR(13)
                                  || CHR(10) mailbody
                              FROM
                                  dual;
        ELSIF p_section = 'LOWER MIDDLE' THEN                           
             OPEN o_cursor FOR SELECT
                                  a.empno
                                  || ' '
                                  || a.name
                                  || CHR(13)
                                  || CHR(10) mailbody
                              FROM
                                  emplmast a
                              WHERE
                                  nvl(a.status, 0) = 1
                                  AND a.emptype IN (
                                      SELECT
                                          emptype
                                      FROM
                                          emptypemast
                                      WHERE
                                          nvl(tm, 0) = 1
                                  )
                                  AND NOT EXISTS (
                                      SELECT
                                          b.*
                                      FROM
                                          time_mast b
                                      WHERE
                                          b.yymm = p_yymm
                                          AND b.posted = 1
                                          AND b.yymm = ngts_emp_access_roles.get_univ_pros_month
                                          AND b.empno = a.empno
                                  )
                                  AND assign = TRIM(p_parent)
                                  
                               UNION
                                  
                               SELECT
                                  a.empno
                                  || ' '
                                  || a.name
                                  || CHR(13)
                                  || CHR(10) mailbody
                              FROM
                                  emplmast a
                              WHERE
                                  nvl(a.status, 0) = 1
                                  AND a.emptype IN (
                                      SELECT
                                          emptype
                                      FROM
                                          emptypemast
                                      WHERE
                                          nvl(tm, 0) = 1
                                  )
                                  AND EXISTS (
                                      SELECT
                                          b.*
                                      FROM
                                          time_mast b
                                      WHERE
                                          b.yymm = p_yymm
                                          AND (b.locked = 0 OR b.approved = 0 OR b.posted = 0)
                                          AND b.yymm = ngts_emp_access_roles.get_univ_pros_month
                                          AND b.empno = a.empno
                                          AND b.assign = TRIM(p_parent)
                                  )                                 
                                  
                              ORDER BY
                                  1;
        ELSIF p_section = 'BOTTOM' THEN
            OPEN o_cursor FOR SELECT
                                  CHR(13)
                                  || CHR(10)
                                  || 'Thanks,'
                                  || CHR(13)
                                  || CHR(10)                                  
                                  || name
                                  || CHR(13)
                                  || CHR(10)
                                  || CHR(13)
                                  || CHR(10)
                                  || CHR(13)
                                  || CHR(10) mailbody
                              FROM
                                  emplmast
                              WHERE 
                                    empno = TRIM(ngts_check_auth_rights.get_empno(p_user_identity_name))
                              
                              UNION ALL
                              
                              SELECT
                                  'This is an automated TCMPL Mail.' mailbody
                              FROM
                                  dual;
        END IF;
        
        RETURN o_cursor;
    END;    
    
    --GET PM APPROVAL STATUS
    FUNCTION getPMApprovalStatus (
        p_yymm     VARCHAR2,
        p_empno    VARCHAR2,        
        p_assign   VARCHAR2
    ) RETURN NUMBER IS
        npmapproved NUMBER(1);
    BEGIN
        SELECT
            pmapproved
        INTO npmapproved
        FROM
            (
                SELECT
                    projno,
                    pmapproved
                FROM
                    (
                        SELECT
                            projno,
                            nvl(td.pmapproved, 0) pmapproved
                        FROM
                            time_daily td
                        WHERE
                            td.assign = TRIM(p_assign)                            
                            AND td.empno = TRIM(p_empno)
                            AND td.yymm = ngts_emp_access_roles.get_univ_pros_month
                            AND td.yymm = TRIM(p_yymm)
                            
                        UNION ALL
                        
                        SELECT
                            projno,
                            nvl(ot.pmapproved, 0) pmapproved
                        FROM
                            time_ot ot
                        WHERE
                            ot.assign = TRIM(p_assign)                            
                            AND ot.empno = TRIM(p_empno)
                            AND ot.yymm = ngts_emp_access_roles.get_univ_pros_month
                            AND ot.yymm = TRIM(p_yymm)
                    ) tm
                WHERE
                    EXISTS (
                        SELECT
                            *
                        FROM
                            projmast p
                        WHERE
                            p.active = 1
                            AND to_number(to_char(p.revcdate, 'YYYYMM')) >= to_number(TRIM(p_yymm))
                            AND nvl(p.timesheet_appr, 0) = 1
                            AND p.projno = tm.projno
                    )
                ORDER BY
                    pmapproved
            )
        WHERE
            ROWNUM = 1;

        RETURN npmapproved;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN -1;
    END getpmapprovalstatus;
    
END NGTS_BULK_TIMESHEET;

/
