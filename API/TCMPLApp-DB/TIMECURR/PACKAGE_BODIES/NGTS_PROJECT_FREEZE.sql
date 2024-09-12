--------------------------------------------------------
--  DDL for Package Body NGTS_PROJECT_FREEZE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."NGTS_PROJECT_FREEZE" AS

    --GET OPEN DATES DETAILS
    FUNCTION get_project_open_details (
        p_yymm   VARCHAR2,
        p_projno VARCHAR2
    ) RETURN SYS_REFCURSOR IS
        o_cursor SYS_REFCURSOR;
    BEGIN
        OPEN o_cursor FOR SELECT
                              a.datefrom       openFrom,
                              a.dateto         openTo,
                              b.reviewfrom     processingMonthReviewFrom,
                              b.reviewto       processingMonthReviewTo,
                              b.locked         processingMonthReviewLocked,
                              c.reviewfrom     lastReviewFrom,
                              c.reviewto       lastReviewTo,
                              c.locked         lastReviewLocked                              
                          FROM
                              tm_week_unlock a,
                              (
                                  SELECT
                                      reviewfrom,
                                      reviewto,
                                      locked,
                                      projno
                                  FROM
                                      (
                                          SELECT
                                              reviewfrom,
                                              reviewto,
                                              locked,
                                              projno        
                                          FROM
                                              ngts_project_review_period
                                          WHERE
                                              yymm = TRIM(p_yymm)
                                              AND projno = TRIM(p_projno)
                                          ORDER BY
                                              reviewfrom DESC
                                      )
                                  WHERE
                                      ROWNUM = 1
                              ) b,
                              (
                                  SELECT
                                      reviewfrom,
                                      reviewto,
                                      locked,
                                      projno
                                  FROM
                                      (
                                          SELECT
                                              reviewfrom,
                                              reviewto,
                                              locked,
                                              projno        
                                          FROM
                                              ngts_project_review_period
                                          WHERE                                 
                                              projno = TRIM(p_projno)
                                          ORDER BY
                                              reviewfrom DESC
                                      )
                                  WHERE
                                      ROWNUM = 1
                              ) c                              
                          WHERE
                      a.proj_no = b.projno (+)
                      AND a.proj_no = c.projno (+)    
                      AND a.proj_no = TRIM(p_projno);
        RETURN o_cursor;
    END get_project_open_details;  
    
    --INSERT OPEN DATES DETAILS
    FUNCTION insert_project_open_period (
        p_yymm           VARCHAR2,
        p_projno         VARCHAR2,
        p_open_from      DATE,
        p_open_to        DATE
    ) RETURN VARCHAR2 AS
    BEGIN
        INSERT INTO tm_week_unlock
            SELECT
                p_open_from,
                p_open_to,
                TRIM(p_projno)
            FROM
                dual
            WHERE
                to_char(p_open_from, 'YYYYMM') = trim(p_yymm)
                AND to_char(p_open_to, 'YYYYMM') = trim(p_yymm)
                AND trim(p_yymm) = ngts_emp_access_roles.get_univ_pros_month;

        IF SQL%found THEN  
            COMMIT;
            RETURN 'Done';
        ELSE
            ROLLBACK;
            RETURN 'Cannot save Project Open Dates!!';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Err - ' || sqlcode || ' - ' || sqlerrm;
    END insert_project_open_period;
    
    --UPDATE OPEN DATES DETAILS
    FUNCTION insert_update_proj_open_period (
        p_yymm                 VARCHAR2,
        p_projno               VARCHAR2,
        p_open_from            DATE,
        p_open_to              DATE,
        p_user_identity_name   VARCHAR2
    ) RETURN VARCHAR2 AS
        n_count         NUMBER;
        n_count_open    NUMBER;
        d_review_from   DATE;
        d_review_to     DATE;
        d_open_from     DATE;
        d_open_to       DATE;
    BEGIN
        IF ( trunc(p_open_from) > trunc(p_open_to) ) THEN
            --ERROR
            RETURN 'Open From Date cannot be later than Open To Date';
        END IF;

        BEGIN
            SELECT
                datefrom,
                dateto
            INTO
                d_open_from,
                d_open_to
            FROM
                tm_week_unlock
            WHERE
                proj_no = TRIM(p_projno);

        EXCEPTION
            WHEN no_data_found THEN
                RETURN insert_project_open_period(p_yymm, p_projno, p_open_from, p_open_to);
        END;

        IF ( trunc(p_open_to) < trunc(d_open_to) ) OR ( trunc(p_open_from) < trunc(d_open_from) ) THEN 
            --FROM / TO DATE CANNOT BE MADE EARLIER
            RETURN 'Cannot prepone Project Open Date(s)';
        END IF;

        IF ( trunc(p_open_from) = trunc(d_open_from) AND trunc(p_open_to) = trunc(d_open_to) ) OR ( trunc(p_open_from) = trunc(d_open_from
        ) ) THEN    
            --SAME DATES
            RETURN 'Cannot save same Project Open Dates';
        END IF;

        UPDATE tm_week_unlock
        SET
            datefrom = p_open_from,
            dateto = p_open_to
        WHERE
            to_char(p_open_from, 'YYYYMM') = TRIM(p_yymm)
            AND to_char(p_open_to, 'YYYYMM') = TRIM(p_yymm)
            AND TRIM(p_yymm) = ngts_emp_access_roles.get_univ_pros_month
            AND proj_no = TRIM(p_projno);

        IF SQL%found THEN
            BEGIN
                SELECT
                    reviewfrom,
                    reviewto
                INTO
                    d_review_from,
                    d_review_to
                FROM
                    (
                        SELECT
                            reviewfrom   reviewfrom,
                            reviewto     reviewto
                        FROM
                            ngts_project_review_period
                        WHERE
                            yymm = TRIM(p_yymm)
                            AND yymm = ngts_emp_access_roles.get_univ_pros_month
                            AND projno = TRIM(p_projno)
                        ORDER BY
                            reviewfrom DESC
                    )
                WHERE
                    ROWNUM = 1;

                IF trunc(p_open_from) <= trunc(d_review_to) THEN
                    --FROM DATE CANNOT BE MADE EARLIER
                    RETURN 'Cannot prepone Project Open Date(s)';
                END IF;
                IF p_open_from > d_open_from THEN
                    RETURN insert_project_review_details(p_yymm, p_projno, d_review_to + 1, p_open_from - 1, ngts_check_auth_rights
                    .get_empno(p_user_identity_name));
                END IF;

            EXCEPTION
                WHEN no_data_found THEN
                    IF p_open_from > d_open_from THEN
                        RETURN insert_project_review_details(p_yymm, p_projno, d_open_from, --to_date(trunc(to_date(p_open_from), 'MM')),                                                      
                         p_open_from - 1, ngts_check_auth_rights.get_empno(p_user_identity_name));

                    END IF;
            END;
        ELSE
            --ERROR
            RETURN 'No such record found to update';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Err - '
                   || sqlcode
                   || ' - '
                   || sqlerrm;
    END insert_update_proj_open_period;
    
    --DELETE OPEN DATES DETAILS
    FUNCTION delete_project_open_period (
        p_projno               VARCHAR2,
        p_user_identity_name   VARCHAR2
    ) RETURN VARCHAR2 AS
        n_count NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO n_count
        FROM
            ngts_project_review_period
        WHERE
            projno = TRIM(p_projno);

        IF n_count = 0 THEN
            DELETE FROM tm_week_unlock
            WHERE
                proj_no = TRIM(p_projno);

            IF SQL%found THEN
                INSERT INTO ngts_wf_log
                    SELECT
                        sysdate,
                        (
                            SELECT
                                tableid
                            FROM
                                ngts_wf_log_tables_mast
                            WHERE
                                tablename = 'TM_WEEK_UNLOCK'
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
                        TRIM(p_projno)
                    FROM
                        dual;

                COMMIT;
                RETURN 'Done';
            ELSE
                ROLLBACK;
                RETURN 'No such record to delete';
            END IF;

        ELSE
            RETURN 'Can''t delete Project Open Period';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Err - '
                   || sqlcode
                   || ' - '
                   || sqlerrm;
    END delete_project_open_period;
    
    --INSERT REVIEW DATE DETAILS
    FUNCTION insert_project_review_details (
        p_yymm                 VARCHAR2,
        p_projno               VARCHAR2,
        p_review_from          DATE,
        p_review_to            DATE,
        p_user_identity_name   VARCHAR2
    ) RETURN VARCHAR2 AS
    BEGIN
        INSERT INTO ngts_project_review_period
            SELECT
                TRIM(p_projno),
                TRIM(p_yymm),
                p_review_from,
                p_review_to,
                0,
                dbms_random.string('X', 8)
            FROM
                dual
            WHERE
                TRIM(p_yymm) = ngts_emp_access_roles.get_univ_pros_month;

        IF SQL%found THEN
            INSERT INTO ngts_wf_log
                SELECT
                    sysdate,
                    (
                        SELECT
                            tableid
                        FROM
                            ngts_wf_log_tables_mast
                        WHERE
                            tablename = 'NGTS_PROJECT_REVIEW_PERIOD'
                    ),
                    (
                        SELECT
                            processid
                        FROM
                            ngts_wf_log_process_mast
                        WHERE
                            processname = 'FREEZED'
                    ),
                    ngts_check_auth_rights.get_empno(p_user_identity_name),
                    (
                        SELECT
                            keyid
                        FROM
                            ngts_project_review_period
                        WHERE
                            locked = 0
                            AND yymm = TRIM(p_yymm)
                            AND yymm = ngts_emp_access_roles.get_univ_pros_month
                            AND projno = TRIM(p_projno)
                    )
                FROM
                    dual;

            COMMIT;
            RETURN 'Done';
        ELSE
            RETURN 'Insert failed!!';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Err - '
                   || sqlcode
                   || ' - '
                   || sqlerrm;
    END insert_project_review_details;       
    
    --UPDATE REVIEW LOCK STATUS
    FUNCTION update_project_review_status (
        p_yymm                 VARCHAR2,
        p_projno               VARCHAR2,
        p_user_identity_name   VARCHAR2
    ) RETURN VARCHAR2 AS
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
                        tablename = 'NGTS_PROJECT_REVIEW_PERIOD'
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
                (
                    SELECT
                        keyid
                    FROM
                        ngts_project_review_period
                    WHERE
                        locked = 0
                        AND yymm = TRIM(p_yymm)
                        AND yymm = ngts_emp_access_roles.get_univ_pros_month
                        AND projno = TRIM(p_projno)
                )
            FROM
                dual;

        UPDATE ngts_project_review_period
        SET
            locked = 1
        WHERE
            nvl(locked, 0) = 0
            AND yymm = TRIM(p_yymm)
            AND yymm = ngts_emp_access_roles.get_univ_pros_month
            AND projno = TRIM(p_projno);

        IF SQL%found THEN
            COMMIT;
            RETURN 'Done';
        ELSE
            ROLLBACK;
            RETURN 'No such record to lock';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Err - '
                   || sqlcode
                   || ' - '
                   || sqlerrm;
    END update_project_review_status;

END NGTS_PROJECT_FREEZE;

/
