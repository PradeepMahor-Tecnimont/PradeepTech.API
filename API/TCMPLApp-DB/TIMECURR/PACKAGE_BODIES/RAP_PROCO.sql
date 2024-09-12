--------------------------------------------------------
--  DDL for Package Body RAP_PROCO
--------------------------------------------------------

  create or replace PACKAGE BODY "TIMECURR"."RAP_PROCO" AS

    PROCEDURE repost (
        p_yymm    IN   VARCHAR2,
        p_result  OUT  VARCHAR2
    ) AS
    BEGIN
        IF trim(p_yymm) != trim(ngts_emp_access_roles.get_univ_pros_month) THEN
            p_result := 'Error...Invalid parameter !!!';
        ELSE
            update_time_mast(p_yymm, 0, 1);

            --DELETE EXISTING DATA IF ANY
            DELETE FROM timetran
            WHERE
                yymm = TRIM(p_yymm);

            DELETE FROM ng_rap_ts_not_submitted
            WHERE
                yymm = TRIM(p_yymm);

            --INSERT POSTED TIMESHEETS 
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
                parent
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
                    parent
                FROM
                    postingdata
                WHERE
                        yymm = TRIM(p_yymm)
                    AND (yymm, empno, parent, assign) IN (
                        SELECT
                            yymm, empno, parent, assign
                        FROM
                            time_mast
                        WHERE
                                nvl(approved, 0) = 1
                            AND yymm = TRIM(p_yymm)
                    )
                GROUP BY
                    yymm,
                    empno,
                    assign,
                    projno,
                    company,
                    wpcode,
                    activity,
                    grp,
                    parent;

            --INSERT EMPLOYESS WHO HAVE NOT FILLED / POSTED THEIR TIMESHEETS
            INSERT INTO ng_rap_ts_not_submitted
                SELECT
                    p_yymm,
                    e.empno,
                    e.assign,
                    e.parent
                FROM
                    emplmast e
                WHERE
                        nvl(e.submit, 0) = 1
                    AND nvl(e.status, 0) = 1
                    AND NOT EXISTS (
                        SELECT
                            t.empno
                        FROM
                            timetran t
                        WHERE
                                t.yymm = TRIM(p_yymm)
                            AND t.empno = e.empno
                    )
                    AND e.emptype IN (
                        SELECT
                            emptype
                        FROM
                            emptypemast
                        WHERE
                            nvl(tm, 0) = 1
                    );

            update_time_mast(p_yymm, 1, 0);

            COMMIT;

            p_result := 'Done';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            p_result := 'Error...';
    END repost;

    PROCEDURE update_time_mast (
        p_yymm   IN  VARCHAR2,
        p_set    IN  NUMBER,
        p_where  IN  NUMBER
    ) AS
    BEGIN
        UPDATE time_mast
        SET
            posted = p_set
        WHERE
                nvl(posted, 0) = p_where
            AND yymm = TRIM(p_yymm)
            AND nvl(approved, 0) = 1
            AND (yymm, empno, parent, assign) IN (
                SELECT
                    yymm, empno, parent, assign
                FROM
                    postingdata
                WHERE
                    yymm = TRIM(p_yymm)
            );

    END;

END rap_proco;