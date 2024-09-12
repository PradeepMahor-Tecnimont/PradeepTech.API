--------------------------------------------------------
--  DDL for Package Body RAP_REPORTS_B
--------------------------------------------------------

Create Or Replace Package Body "TIMECURR"."RAP_REPORTS_B" As


    --Get Total Hours Timetran
    Function get_total_hours_timetran(
        p_yymm       In Varchar2,
        p_costcode   In Varchar2,
        p_projno     In Varchar2,
        p_wpcode     In Varchar2,
        p_activity   In Varchar2,
        p_reasoncode In Varchar2,
        p_empno      In Varchar2
    ) Return Number Is

        n_total_hours Number(12, 2) := 0;
        v_activity    timetran.activity%Type;
        v_wpcode      timetran.wpcode%Type;
    Begin
        Select
            activity,
            wpcode
        Into
            v_activity,
            v_wpcode
        From
            (
                Select
                    activity,
                    wpcode
                From
                    rap_gtt_timetran
                Where
                    projno       = Trim(p_projno)
                    And empno    = Trim(p_empno)
                    And yymm     = Trim(p_yymm)
                    And costcode = Trim(p_costcode)
                Order By wpcode Desc,
                    activity Desc
            )
        Where
            Rownum = 1;

        If p_activity = v_activity And p_wpcode = v_wpcode Then
            Select
                Sum(nvl(hours, 0) + nvl(othours, 0)) totalhours
            Into
                n_total_hours
            From
                rap_gtt_timetran
            Where
                projno       = Trim(p_projno)
                And empno    = Trim(p_empno)
                And yymm     = Trim(p_yymm)
                And costcode = Trim(p_costcode);

            Return n_total_hours;
        Else
            Return Null;
        End If;

    Exception
        When Others Then
            Return 0;
    End;

    --STA6
    Procedure get_sta6(
        p_yymm               In  Varchar2,
        p_costcode           In  Varchar2,
        p_sta6               Out Sys_Refcursor,
        p_sta6_not_submitted Out Sys_Refcursor,
        p_sta6_odd           Out Sys_Refcursor,
        p_sta6_1             Out Sys_Refcursor,
        p_sta6_2             Out Sys_Refcursor
    ) As
    Begin
        Open p_sta6 For 'SELECT null srno,
                                t.wpcode,
                                t.activity,
                                rap_costcode_combine.get_costcode_code(e.empno) as code,
                                t.projno,
                                p.tcmno,
                                e.empno,
                                CASE t.empno
                                    WHEN LAG(t.empno, 1, 0) OVER(
                                        ORDER BY
                                            t.empno, t.projno, t.wpcode,
                                            t.activity, rap_costcode_combine.get_costcode_code(e.empno)
                                    ) THEN
                                        NULL
                                    ELSE
                                        t.empno
                                END AS calcEmpno,
                                CASE e.name
                                    WHEN LAG(e.name, 1, 0) OVER(
                                        ORDER BY
                                            t.empno, t.projno, t.wpcode,
                                            t.activity, rap_costcode_combine.get_costcode_code(e.empno)
                                    ) THEN
                                        NULL
                                    ELSE
                                        e.name
                                END AS calcName,
                                t.hours,
                                t.othours,
                                rap_reports_b.get_total_hours_timetran(t.yymm, t.costcode, t.projno, t.wpcode, t.activity, t.reasoncode, t.empno) calctotalhours,
                                nvl(t.hours,0)+nvl(t.othours,0) totalhours
                        FROM
                            rap_gtt_timetran t,
                            emplmast            e,
                            projmast            p
                        WHERE
                                t.costcode = TRIM(:p_costcode)
                            AND t.yymm = TRIM(:p_yymm)
                            AND t.empno = e.empno
                            AND t.projno = p.projno
                            AND e.emptype In (SELECT
                                                    emptype
                                                FROM
                                                    emptypemast
                                                WHERE
                                                    nvl(tm, 0) = 1)
                        ORDER BY
                            t.empno, t.projno, t.wpcode, t.activity, rap_costcode_combine.get_costcode_code(e.empno) '
            Using p_costcode, p_yymm;

        Open p_sta6_not_submitted For 'SELECT null srno,
                                              e.empno,
                                              e.name
                                       FROM
                                            emplmast e
                                       WHERE
                                                nvl(e.submit, 0) = 1
                                           AND nvl(e.status, 0) = 1
                                           AND e.assign = TRIM(:p_costcode)
                                           AND Not Exists (SELECT empno
                                                           FROM rap_gtt_timetran t
                                                           WHERE t.yymm = TRIM(:p_yymm)
                                                               AND t.empno = e.empno )
                                           AND e.emptype In (SELECT
                                                                emptype
                                                            FROM
                                                                emptypemast
                                                            WHERE
                                                                nvl(tm, 0) = 1 and nvl(is_active, 0) = 1)
                                       ORDER BY
                                            e.empno '
            Using p_costcode, p_yymm;

        Open p_sta6_odd For 'SELECT null srno,
                                    a.costcode,
                                    a.empno,
                                    b.name,
                                    Sum(nvl(a.hours, 0)) as hours,
                                    Sum(nvl(a.othours,0)) as othours
                             FROM
                                rap_gtt_timetran a,
                                emplmast            b
                             WHERE
                                    a.empno = b.empno
                                 AND a.parent = TRIM(:p_costcode)
                                 AND b.submit = 1
                                 AND b.status = 1
                                 AND a.costcode <> TRIM(:p_costcode)
                                 AND a.yymm = TRIM(:p_yymm)
                                 AND b.emptype In (SELECT
                                                        emptype
                                                    FROM
                                                        emptypemast
                                                    WHERE
                                                        nvl(tm, 0) = 1)
                            GROUP BY
                                a.empno, b.name, a.costcode
                            ORDER BY
                                a.empno '
            Using p_costcode, p_costcode, p_yymm;

        Open p_sta6_1 For 'SELECT null as srno,
                                  t.wpcode,
                                  t.activity,
                                  rap_costcode_combine.get_costcode_code(t.costcode) as code,
                                  t.projno,
                                  p.tcmno,
                                  e.empno,
                                  CASE t.empno
                                    WHEN LAG(t.empno, 1, 0) OVER(
                                        ORDER BY
                                            t.empno, t.projno, t.wpcode,
                                            t.activity, rap_costcode_combine.get_costcode_code(e.empno) 
                                    ) THEN
                                        NULL
                                    ELSE
                                        t.empno
                                  END AS calcEmpno,
                                  CASE e.name
                                     WHEN LAG(e.name, 1, 0) OVER(
                                         ORDER BY
                                             t.empno, t.projno, t.wpcode,
                                             t.activity, rap_costcode_combine.get_costcode_code(e.empno) 
                                      ) THEN
                                          NULL
                                      ELSE
                                          e.name
                                  END AS calcName,
                                  t.hours,
                                  t.othours,
                                  rap_reports_b.get_total_hours_timetran(t.yymm, t.costcode, t.projno, t.wpcode, t.activity, t.reasoncode, t.empno) calctotalhours,
                                  nvl(t.hours,0)+nvl(t.othours,0) totalhours
                          FROM
                               rap_gtt_timetran t,
                               emplmast            e,
                               projmast            p
                          WHERE
                                t.costcode = TRIM(:p_costcode)
                            AND t.yymm = TRIM(:p_yymm)
                            AND nvl(p.tcm_jobs, 0) = 1
                            AND t.empno = e.empno
                            AND t.projno = p.projno
                          ORDER BY
                            t.empno, t.projno, t.wpcode, t.activity, rap_costcode_combine.get_costcode_code(e.empno) '
            Using p_costcode, p_yymm;

        Open p_sta6_2 For 'SELECT null as srno,
                                  t.wpcode,
                                  t.activity,
                                  rap_costcode_combine.get_costcode_code(e.empno) as code,
                                  t.projno,
                                  p.tcmno,
                                  e.empno,
                                  CASE t.empno
                                    WHEN LAG(t.empno, 1, 0) OVER(
                                        ORDER BY
                                            t.empno, t.projno, t.wpcode,
                                            t.activity, rap_costcode_combine.get_costcode_code(e.empno) 
                                    ) THEN
                                        NULL
                                    ELSE
                                        t.empno
                                  END AS calcEmpno,
                                  CASE e.name
                                     WHEN LAG(e.name, 1, 0) OVER(
                                         ORDER BY
                                             t.empno, t.projno, t.wpcode,
                                             t.activity, rap_costcode_combine.get_costcode_code(e.empno) 
                                      ) THEN
                                          NULL
                                      ELSE
                                          e.name
                                  END AS calcName,
                                  t.hours,
                                  t.othours,
                                  rap_reports_b.get_total_hours_timetran(t.yymm, t.costcode, t.projno, t.wpcode, t.activity, t.reasoncode, t.empno) calctotalhours,
                                  nvl(t.hours,0)+nvl(t.othours,0) totalhours
                          FROM
                            rap_gtt_timetran t,
                            emplmast            e,
                            projmast            p
                          WHERE
                                t.costcode = TRIM(:p_costcode)
                            AND t.yymm = TRIM(:p_yymm)
                            AND nvl(p.tcm_jobs, 0) = 0
                            AND t.empno = e.empno
                            AND t.projno = p.projno
                        ORDER BY
                            t.empno, t.projno, t.wpcode, t.activity, rap_costcode_combine.get_costcode_code(e.empno) '
            Using p_costcode, p_yymm;

    End;

    --ACT01
    Procedure get_act01(
        p_yymm     In  Varchar2,
        p_yearmode In  Varchar2,
        p_costcode In  Varchar2,
        p_cols     Out Sys_Refcursor,
        p_act01    Out Sys_Refcursor
    ) As

        data_pivot_clause    Varchar2(4000);
        heading_pivot_clause Varchar2(4000);
        noofmonths           Number := 12;
        yymm_end             Varchar2(6);
    Begin
        Select
            Listagg('''' || heading || '''' || ' as ' || heading || '', ', ') Within
                Group (
                Order By
                    heading
                ),
            Listagg(yymm || ' as "' || heading || '"', ', ') Within
                Group (
                Order By
                    yymm
                )
        Into
            heading_pivot_clause,
            data_pivot_clause
        From
            (
                Select
                    yymm,
                    heading
                From
                    Table (rap_reports.rpt_month_cols(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode), noofmonths))
            );

        -- Heading
        Open p_cols For 'SELECT * FROM (
                                        SELECT
                                            heading,
                                            yymm
                                        FROM
                                            TABLE( rap_reports.rpt_month_cols(rap_reports_gen.get_yymm_begin(:p_yymm,
                                                                                                               :p_yearmode),
                                                                                                               :noofmonths) )
                        ) Pivot ( max(yymm) For heading in ('
            || heading_pivot_clause
            || '))'
            Using p_yymm, p_yearmode, noofmonths;

        -- Data
        Open p_act01 For 'Select * FROM ( SELECT t.projno,
                                                 CASE t.projno
                                                    WHEN LAG(t.projno, 1, 0) OVER(
                                                        ORDER BY
                                                            t.projno, t.activity
                                                    ) THEN
                                                        NULL
                                                    ELSE
                                                        t.projno
                                                 END AS calcProjno,
                                                 CASE p.tcmno
                                                    WHEN LAG(p.tcmno, 1, 0) OVER(
                                                        ORDER BY
                                                            t.projno, t.activity
                                                    ) THEN
                                                        NULL
                                                    ELSE
                                                        p.tcmno
                                                 END AS calcTcmno,
                                                 CASE p.name
                                                    WHEN LAG(p.name, 1, 0) OVER(
                                                        ORDER BY
                                                            t.projno, t.activity
                                                    ) THEN
                                                        NULL
                                                    ELSE
                                                        p.name
                                                 END AS calcName,
                                                 t.activity,
                                                 t.yymm,
                                                 Sum(nvl(t.hours,0)) + Sum(nvl(t.othours,0)) AS tothours
                                          FROM
                                            rap_gtt_timetran t,
                                            projmast            p
                                          WHERE
                                                p.projno = t.projno
                                            AND nvl(p.reimb_job, 0) = 1
                                            AND nvl(p.tcm_jobs, 0) = 1
                                            AND t.costcode = TRIM(:p_costcode)
                                            AND to_number(t.yymm) >= to_number(rap_reports_gen.get_yymm_begin(:p_yymm, :p_yearmode))
                                            AND to_number(t.yymm) <= to_number(rap_reports_gen.get_yymm_end(:p_yymm, :p_yearmode))
                                          GROUP BY
                                            t.projno, p.tcmno, p.name, t.activity, t.yymm
                                         )
                         Pivot
                         (
                             SUM(tothours)
                             For yymm In ('
            || data_pivot_clause
            || ')
                         )
                         ORDER BY projno, activity '
            Using p_costcode, p_yymm, p_yearmode, p_yymm, p_yearmode;

    End;

    --TM02
    Procedure get_tm02(
        p_yymm               In  Varchar2,
        p_yearmode           In  Varchar2,
        p_costcode           In  Varchar2,
        p_cols               Out Sys_Refcursor,
        p_tm02               Out Sys_Refcursor,
        p_tm02_emptype_hrs   Out Sys_Refcursor,
        p_tm02_1_emptype_hrs Out Sys_Refcursor
    ) As

        data_pivot_clause    Varchar2(4000);
        heading_pivot_clause Varchar2(4000);
        noofmonths           Number := 12;
        yymm_end             Varchar2(6);
    Begin
        Select
            Listagg('''' || heading || '''' || ' as ' || heading || '', ', ') Within
                Group (
                Order By
                    heading
                ),
            Listagg(yymm || ' as "' || heading || '"', ', ') Within
                Group (
                Order By
                    yymm
                )
        Into
            heading_pivot_clause,
            data_pivot_clause
        From
            (
                Select
                    yymm,
                    heading
                From
                    Table (rap_reports.rpt_month_cols(rap_reports_gen.get_yymm(p_yymm, 1), noofmonths))
            );

        -- Heading
        Open p_cols For 'SELECT * FROM (
                                        SELECT
                                            heading,
                                            yymm
                                        FROM
                                            TABLE( rap_reports.rpt_month_cols(rap_reports_gen.get_yymm(:p_yymm, 1),
                                                                                                         :noofmonths) )
                        ) Pivot ( max(yymm) For heading in ('
            || heading_pivot_clause
            || '))'
            Using p_yymm, noofmonths;

        -- Data
        Open p_tm02 For 'Select * FROM ( SELECT
                                                p.projno projno,
                                                p.newcostcode || '' '' || rap_reports_gen.get_costcode_desc(p.newcostcode) newcostcode_desc,
                                                p.tcmno,
                                                p.name,
                                                rap_reports_gen.get_job_type_tma_grp
                                                    (final_tma_order(p.projno,
                                                                     p.active,
                                                                     p.projtype,
                                                                     p.cdate,
                                                                     :p_yymm,
                                                                     to_date(rap_reports_gen.get_yymm_begin(:p_yymm,
                                                                                    :p_yearmode), ''yyyymm'')-1,
                                                                     p.revcdate)) AS tma_grp,
                                                rap_reports_gen.get_original_budget(p_projno => p.projno, p_costcode => :p_costcode) original,
                                                rap_reports_gen.get_revised_budget(p_projno => p.projno, p_costcode => :p_costcode) revised,
                                                rap_reports_gen.get_actual_month_hours(p_yymm => :p_yymm, p_projno => p.projno, p_costcode => :p_costcode) month,
                                                rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_costcode => :p_costcode) year,
                                                rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_costcode => :p_costcode) +
                                                    rap_reports_gen.get_opening_hours(p_yearmode => :p_yearmode, p_projno => p.projno, p_costcode => :p_costcode) total,
                                                - rap_reports_gen.get_actual_month_hours(p_yymm => :p_yymm, p_projno => p.projno, p_costcode => :p_costcode) +
                                                    rap_reports_b.get_cc_proj_month_hours(:p_yymm, p.projno, :p_costcode) devtn,
                                                rap_reports_gen.get_projected_hours_future(p_yymm => :p_yymm, p_projno => p.projno, p_costcode => :p_costcode, p_noofmonths => 12) afterHours,
                                                pc.yymm,
                                                nvl(pc.hours, 0) hours,
                                                rap_reports_b.row_colour(p.tcm_jobs,p.reimb_job,p.highend,p.typeofjob) as row_colour,
                                                nvl(p.tcm_jobs, 0) tcm_jobs
                                         FROM
                                            projmast p,
                                            rap_gtt_prjcmast pc
                                         WHERE
                                                p.projno = pc.projno(+)
                                             AND pc.costcode(+) = TRIM(:p_costcode)
                                             AND ( EXISTS (SELECT projno FROM rap_gtt_budgmast budgmast
                                                                WHERE budgmast.costcode = TRIM(:p_costcode)
                                                                    AND budgmast.projno = p.projno ) OR
                                                   EXISTS (SELECT projno FROM rap_gtt_prjcmast prjcmast
                                                                WHERE prjcmast.costcode = TRIM(:p_costcode)
                                                                    AND prjcmast.projno = p.projno AND to_number(yymm) > to_number(TRIM(:p_yymm))  ) OR
                                                   EXISTS (SELECT projno FROM rap_gtt_openmast openmast
                                                                WHERE openmast.costcode = TRIM(:p_costcode)
                                                                    AND openmast.projno = p.projno ) OR
                                                   EXISTS (SELECT projno FROM rap_gtt_timetran t
                                                                WHERE t.costcode = TRIM(:p_costcode)
                                                                   AND t.projno = p.projno
                                                                   AND to_number(t.yymm) >= to_number(rap_reports_gen.get_yymm_begin(:p_yymm, :p_yearmode))
                                                                   AND to_number(t.yymm) <= to_number(TRIM(:p_yymm)))
                                                )
                                             AND rap_reports_gen.get_projno_active_status(:p_yymm, :p_yearmode, p.active, p.cdate) = 1
                                       )
                         Pivot
                         (
                             SUM(hours)
                             For yymm In ('
            || data_pivot_clause
            || ')
                         )
                         ORDER BY tma_grp, newcostcode_desc, projno '
            Using p_yymm, p_yymm, p_yearmode, p_costcode, p_costcode, p_yymm, p_costcode, p_yymm, p_yearmode, p_costcode,
            p_yymm, p_yearmode,
            p_costcode, p_yearmode, p_costcode, p_yymm, p_costcode, p_yymm, p_costcode, p_yymm, p_costcode, p_costcode, p_costcode,
            p_costcode,
            p_yymm, p_costcode, p_costcode, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode;

        --Summary Emp Type & Hours
        Open p_tm02_emptype_hrs For
            Select
                etm.empdesc                              emptype,
                Sum(nvl(t.hours, 0) + nvl(t.othours, 0)) As tothrs
            From
                rap_gtt_timetran t,
                emplmast         e,
                emptypemast      etm
            Where
                e.empno        = t.empno
                And e.emptype  = etm.emptype
                And etm.tm     = 1
                And t.yymm     = Trim(p_yymm)
                And t.costcode = Trim(p_costcode)
            Group By
                etm.empdesc
            Order By
                1;

        --Summary Emp Type & Hours
        Open p_tm02_1_emptype_hrs For
            Select
                etm.empdesc                              emptype,
                Sum(nvl(t.hours, 0) + nvl(t.othours, 0)) As tothrs
            From
                rap_gtt_timetran t,
                emplmast         e,
                emptypemast      etm
            Where
                e.empno        = t.empno
                And Exists (
                    Select
                        *
                    From
                        projmast p
                    Where
                        p.projno               = t.projno
                        And nvl(p.tcm_jobs, 0) = 1
                )
                And e.emptype  = etm.emptype
                And etm.tm     = 1
                And t.yymm     = Trim(p_yymm)
                And t.costcode = Trim(p_costcode)
            Group By
                etm.empdesc
            Order By
                1;

    End;

    ----Project + Costcode Current Projected Month hours
    Function get_cc_proj_month_hours(
        p_yymm     In Varchar2,
        p_projno   In Varchar2,
        p_costcode In Varchar2
    ) Return Number Is
        n_proj_month_hours prjcmast.hours%Type;
    Begin
        Select
            Sum(nvl(hours, 0))
        Into
            n_proj_month_hours
        From
            rap_gtt_prjcmast
        Where
            costcode   = Trim(p_costcode)
            And yymm   = Trim(p_yymm)
            And projno = Trim(p_projno);

        Return n_proj_month_hours;
    Exception
        When Others Then
            Return 0;
    End;

    --Project Projected hours
    Function get_projected_hours_yearwise(
        p_yymm     In Varchar2,
        p_yearmode In Varchar2,
        p_projno   In Varchar2,
        p_noofyear In Number,
        p_costgrp  In Varchar2 Default Null
    ) Return Number Is
        n_proj_hours prjcmast.hours%Type;
    Begin
        If length(trim(p_projno)) = 5 Then
            If p_noofyear = 0 Then
                If p_costgrp = 'M' Or p_costgrp = 'N' Then  --Non Engineering / Non Depute
                    Select
                        Sum(nvl(p.hours, 0))
                    Into
                        n_proj_hours
                    From
                        rap_gtt_prjcmast p,
                        costmast         c
                    Where
                        p.costcode                 = c.costcode
                        And c.tma_grp != Case
                                             When p_costgrp = 'M' Then
                                                 'E'
                                             When p_costgrp = 'N' Then
                                                 'D'
                                         End
                        And c.comp In ('T', 'C')
                        And To_Number(p.yymm) >= To_Number(rap_reports_gen.get_yymm(p_yymm, 1))
                        And To_Number(p.yymm) <= To_Number(rap_reports_gen.get_yymm_end(p_yymm, p_yearmode))
                        And substr(p.projno, 1, 5) = Trim(p_projno);

                Elsif p_costgrp = 'E' Or p_costgrp = 'D' Then --Engineering / Depute
                    Select
                        Sum(nvl(p.hours, 0))
                    Into
                        n_proj_hours
                    From
                        rap_gtt_prjcmast p,
                        costmast         c
                    Where
                        p.costcode                 = c.costcode
                        And c.tma_grp              = Trim(p_costgrp)
                        And c.comp In ('T', 'C')
                        And To_Number(p.yymm) >= To_Number(rap_reports_gen.get_yymm(p_yymm, 1))
                        And To_Number(p.yymm) <= To_Number(rap_reports_gen.get_yymm_end(p_yymm, p_yearmode))
                        And substr(p.projno, 1, 5) = Trim(p_projno);

                Elsif p_costgrp = 'O' Then --Non Depute Minus E
                    Select
                        Sum(nvl(p.hours, 0))
                    Into
                        n_proj_hours
                    From
                        rap_gtt_prjcmast p,
                        costmast         c
                    Where
                        p.costcode                 = c.costcode
                        And c.tma_grp != 'D'
                        And c.tma_grp != 'E'
                        And c.comp In ('T', 'C')
                        And To_Number(p.yymm) >= To_Number(rap_reports_gen.get_yymm(p_yymm, 1))
                        And To_Number(p.yymm) <= To_Number(rap_reports_gen.get_yymm_end(p_yymm, p_yearmode))
                        And substr(p.projno, 1, 5) = Trim(p_projno);

                Else
                    Select
                        Sum(nvl(hours, 0))
                    Into
                        n_proj_hours
                    From
                        rap_gtt_prjcmast
                    Where
                        To_Number(yymm) >= To_Number(rap_reports_gen.get_yymm(p_yymm, 1))
                        And To_Number(yymm) <= To_Number(rap_reports_gen.get_yymm_end(p_yymm, p_yearmode))
                        And substr(projno, 1, 5) = Trim(p_projno);

                End If;

            Elsif p_noofyear = 1 Then
                If p_costgrp = 'M' Or p_costgrp = 'N' Then  --Non Engineering / Non Depute
                    Select
                        Sum(nvl(p.hours, 0))
                    Into
                        n_proj_hours
                    From
                        rap_gtt_prjcmast p,
                        costmast         c
                    Where
                        p.costcode                 = c.costcode
                        And c.tma_grp != Case
                                             When p_costgrp = 'M' Then
                                                 'E'
                                             When p_costgrp = 'N' Then
                                                 'D'
                                         End
                        And To_Number(p.yymm) >= To_Number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode)) + 100
                        And To_Number(p.yymm) <= To_Number(rap_reports_gen.get_yymm_end(p_yymm, p_yearmode)) + 100
                        And substr(p.projno, 1, 5) = Trim(p_projno);

                Elsif p_costgrp = 'E' Or p_costgrp = 'D' Then --Engineering / Depute
                    Select
                        Sum(nvl(p.hours, 0))
                    Into
                        n_proj_hours
                    From
                        rap_gtt_prjcmast p,
                        costmast         c
                    Where
                        p.costcode                 = c.costcode
                        And c.tma_grp              = Trim(p_costgrp)
                        And To_Number(p.yymm) >= To_Number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode)) + 100
                        And To_Number(p.yymm) <= To_Number(rap_reports_gen.get_yymm_end(p_yymm, p_yearmode)) + 100
                        And substr(p.projno, 1, 5) = Trim(p_projno);

                Elsif p_costgrp = 'O' Then --Non Depute
                    Select
                        Sum(nvl(p.hours, 0))
                    Into
                        n_proj_hours
                    From
                        rap_gtt_prjcmast p,
                        costmast         c
                    Where
                        p.costcode                 = c.costcode
                        And c.tma_grp != 'D'
                        And c.tma_grp != 'E'
                        And To_Number(p.yymm) >= To_Number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode)) + 100
                        And To_Number(p.yymm) <= To_Number(rap_reports_gen.get_yymm_end(p_yymm, p_yearmode)) + 100
                        And substr(p.projno, 1, 5) = Trim(p_projno);

                Else
                    Select
                        Sum(nvl(hours, 0))
                    Into
                        n_proj_hours
                    From
                        rap_gtt_prjcmast
                    Where
                        To_Number(yymm) >= To_Number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode)) + 100
                        And To_Number(yymm) <= To_Number(rap_reports_gen.get_yymm_end(p_yymm, p_yearmode)) + 100
                        And substr(projno, 1, 5) = Trim(p_projno);

                End If;
            Elsif p_noofyear = 2 Then
                If p_costgrp = 'M' Or p_costgrp = 'N' Then --Non Engineering / Non Depute
                    Select
                        Sum(nvl(p.hours, 0))
                    Into
                        n_proj_hours
                    From
                        rap_gtt_prjcmast p,
                        costmast         c
                    Where
                        p.costcode                 = c.costcode
                        And c.tma_grp != Case
                                             When p_costgrp = 'M' Then
                                                 'E'
                                             When p_costgrp = 'N' Then
                                                 'D'
                                         End
                        And To_Number(p.yymm) >= To_Number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode)) + 200
                        And substr(p.projno, 1, 5) = Trim(p_projno);

                Elsif p_costgrp = 'E' Or p_costgrp = 'D' Then --Engineering / Depute
                    Select
                        Sum(nvl(p.hours, 0))
                    Into
                        n_proj_hours
                    From
                        rap_gtt_prjcmast p,
                        costmast         c
                    Where
                        p.costcode                 = c.costcode
                        And c.tma_grp              = Trim(p_costgrp)
                        And To_Number(p.yymm) >= To_Number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode)) + 200
                        And substr(p.projno, 1, 5) = Trim(p_projno);

                Elsif p_costgrp = 'O' Then --Non Depute Minus E
                    Select
                        Sum(nvl(p.hours, 0))
                    Into
                        n_proj_hours
                    From
                        rap_gtt_prjcmast p,
                        costmast         c
                    Where
                        p.costcode                 = c.costcode
                        And c.tma_grp != 'D'
                        And c.tma_grp != 'E'
                        And To_Number(p.yymm) >= To_Number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode)) + 200
                        And substr(p.projno, 1, 5) = Trim(p_projno);

                Else
                    Select
                        Sum(nvl(hours, 0))
                    Into
                        n_proj_hours
                    From
                        rap_gtt_prjcmast
                    Where
                        To_Number(yymm) >= To_Number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode)) + 200
                        And substr(projno, 1, 5) = Trim(p_projno);

                End If;
            End If;
        Else
            If p_noofyear = 0 Then
                If p_costgrp = 'M' Or p_costgrp = 'N' Then  --Non Engineering / Non Depute
                    Select
                        Sum(nvl(p.hours, 0))
                    Into
                        n_proj_hours
                    From
                        rap_gtt_prjcmast p,
                        costmast         c
                    Where
                        p.costcode   = c.costcode
                        And c.tma_grp != Case
                                             When p_costgrp = 'M' Then
                                                 'E'
                                             When p_costgrp = 'N' Then
                                                 'D'
                                         End
                        And c.comp In ('T', 'C')
                        And To_Number(p.yymm) >= To_Number(rap_reports_gen.get_yymm(p_yymm, 1))
                        And To_Number(p.yymm) <= To_Number(rap_reports_gen.get_yymm_end(p_yymm, p_yearmode))
                        And p.projno = Trim(p_projno);

                Elsif p_costgrp = 'E' Or p_costgrp = 'D' Then --Engineering / Depute
                    Select
                        Sum(nvl(p.hours, 0))
                    Into
                        n_proj_hours
                    From
                        rap_gtt_prjcmast p,
                        costmast         c
                    Where
                        p.costcode    = c.costcode
                        And c.tma_grp = Trim(p_costgrp)
                        And c.comp In ('T', 'C')
                        And To_Number(p.yymm) >= To_Number(rap_reports_gen.get_yymm(p_yymm, 1))
                        And To_Number(p.yymm) <= To_Number(rap_reports_gen.get_yymm_end(p_yymm, p_yearmode))
                        And p.projno  = Trim(p_projno);

                Elsif p_costgrp = 'O' Then --Non Depute Minus E
                    Select
                        Sum(nvl(p.hours, 0))
                    Into
                        n_proj_hours
                    From
                        rap_gtt_prjcmast p,
                        costmast         c
                    Where
                        p.costcode   = c.costcode
                        And c.tma_grp != 'D'
                        And c.tma_grp != 'E'
                        And c.comp In ('T', 'C')
                        And To_Number(p.yymm) >= To_Number(rap_reports_gen.get_yymm(p_yymm, 1))
                        And To_Number(p.yymm) <= To_Number(rap_reports_gen.get_yymm_end(p_yymm, p_yearmode))
                        And p.projno = Trim(p_projno);

                Else
                    Select
                        Sum(nvl(hours, 0))
                    Into
                        n_proj_hours
                    From
                        rap_gtt_prjcmast
                    Where
                        To_Number(yymm) >= To_Number(rap_reports_gen.get_yymm(p_yymm, 1))
                        And To_Number(yymm) <= To_Number(rap_reports_gen.get_yymm_end(p_yymm, p_yearmode))
                        And projno = Trim(p_projno);

                End If;

            Elsif p_noofyear = 1 Then
                If p_costgrp = 'M' Or p_costgrp = 'N' Then  --Non Engineering / Non Depute
                    Select
                        Sum(nvl(p.hours, 0))
                    Into
                        n_proj_hours
                    From
                        rap_gtt_prjcmast p,
                        costmast         c
                    Where
                        p.costcode   = c.costcode
                        And c.tma_grp != Case
                                             When p_costgrp = 'M' Then
                                                 'E'
                                             When p_costgrp = 'N' Then
                                                 'D'
                                         End
                        And To_Number(p.yymm) >= To_Number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode)) + 100
                        And To_Number(p.yymm) <= To_Number(rap_reports_gen.get_yymm_end(p_yymm, p_yearmode)) + 100
                        And p.projno = Trim(p_projno);

                Elsif p_costgrp = 'E' Or p_costgrp = 'D' Then --Engineering / Depute
                    Select
                        Sum(nvl(p.hours, 0))
                    Into
                        n_proj_hours
                    From
                        rap_gtt_prjcmast p,
                        costmast         c
                    Where
                        p.costcode    = c.costcode
                        And c.tma_grp = Trim(p_costgrp)
                        And To_Number(p.yymm) >= To_Number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode)) + 100
                        And To_Number(p.yymm) <= To_Number(rap_reports_gen.get_yymm_end(p_yymm, p_yearmode)) + 100
                        And p.projno  = Trim(p_projno);

                Elsif p_costgrp = 'O' Then --Non Depute
                    Select
                        Sum(nvl(p.hours, 0))
                    Into
                        n_proj_hours
                    From
                        rap_gtt_prjcmast p,
                        costmast         c
                    Where
                        p.costcode   = c.costcode
                        And c.tma_grp != 'D'
                        And c.tma_grp != 'E'
                        And To_Number(p.yymm) >= To_Number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode)) + 100
                        And To_Number(p.yymm) <= To_Number(rap_reports_gen.get_yymm_end(p_yymm, p_yearmode)) + 100
                        And p.projno = Trim(p_projno);

                Else
                    Select
                        Sum(nvl(hours, 0))
                    Into
                        n_proj_hours
                    From
                        rap_gtt_prjcmast
                    Where
                        To_Number(yymm) >= To_Number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode)) + 100
                        And To_Number(yymm) <= To_Number(rap_reports_gen.get_yymm_end(p_yymm, p_yearmode)) + 100
                        And projno = Trim(p_projno);

                End If;
            Elsif p_noofyear = 2 Then
                If p_costgrp = 'M' Or p_costgrp = 'N' Then --Non Engineering / Non Depute
                    Select
                        Sum(nvl(p.hours, 0))
                    Into
                        n_proj_hours
                    From
                        rap_gtt_prjcmast p,
                        costmast         c
                    Where
                        p.costcode   = c.costcode
                        And c.tma_grp != Case
                                             When p_costgrp = 'M' Then
                                                 'E'
                                             When p_costgrp = 'N' Then
                                                 'D'
                                         End
                        And To_Number(p.yymm) >= To_Number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode)) + 200
                        And p.projno = Trim(p_projno);

                Elsif p_costgrp = 'E' Or p_costgrp = 'D' Then --Engineering / Depute
                    Select
                        Sum(nvl(p.hours, 0))
                    Into
                        n_proj_hours
                    From
                        rap_gtt_prjcmast p,
                        costmast         c
                    Where
                        p.costcode    = c.costcode
                        And c.tma_grp = Trim(p_costgrp)
                        And To_Number(p.yymm) >= To_Number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode)) + 200
                        And p.projno  = Trim(p_projno);

                Elsif p_costgrp = 'O' Then --Non Depute Minus E
                    Select
                        Sum(nvl(p.hours, 0))
                    Into
                        n_proj_hours
                    From
                        rap_gtt_prjcmast p,
                        costmast         c
                    Where
                        p.costcode   = c.costcode
                        And c.tma_grp != 'D'
                        And c.tma_grp != 'E'
                        And To_Number(p.yymm) >= To_Number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode)) + 200
                        And p.projno = Trim(p_projno);

                Else
                    Select
                        Sum(nvl(hours, 0))
                    Into
                        n_proj_hours
                    From
                        rap_gtt_prjcmast
                    Where
                        To_Number(yymm) >= To_Number(rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode)) + 200
                        And projno = Trim(p_projno);

                End If;
            End If;
        End If;

        Return n_proj_hours;
    Exception
        When Others Then
            Return 0;
    End;

    --Row colour
    Function row_colour(
        p_tcm_jobs  In Number,
        p_reimb_job In Number,
        p_highend   In Number,
        p_typeofjob In Varchar2
    ) Return Varchar2 Is
    Begin
        If nvl(p_tcm_jobs, 0) = 1 Then
            If nvl(p_reimb_job, 0) = 1 Then
                Return 'PINK';
            Else
                Return 'BLUE';
            End If;

        Else
            Return 'BLACK';
        End If;
    End;

    --TMA (TMA Report)
    Procedure get_tma(
        p_yymm     In  Varchar2,
        p_yearmode In  Varchar2,
        p_tma      Out Sys_Refcursor
    ) As
    Begin
        Open p_tma For 'SELECT rownum, a.* FROM (
                        SELECT
						p.projno projno,
                        p.newcostcode || '' '' || rap_reports_gen.get_costcode_desc(p.newcostcode) newcostcode_desc,
                        p.tcmno,
                        p.name,
                        p.abbr,
                        p.sdate,
						p.revcdate,
                        p.cdate,
                        rap_reports_gen.get_job_type_tma_grp
                            (final_tma_order(p.projno,
                                             p.active,
                                             p.projtype,
                                             p.cdate,
                                             :p_yymm,
                                             to_date(rap_reports_gen.get_yymm_begin(:p_yymm,
                                                            :p_yearmode), ''yyyymm'')-1,
                                             p.revcdate)) AS tma_grp,
                        rap_reports_gen.get_original_budget(p_projno => p.projno) original,
                        rap_reports_gen.get_revised_budget(p_projno => p.projno) revised,
                        rap_reports_gen.get_actual_month_hours(p_yymm => :p_yymm, p_projno => p.projno) month,
                        rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno) year,
                        rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno) +
                            rap_reports_gen.get_opening_hours(p_yearmode => :p_yearmode, p_projno => p.projno) total,
                        rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 0) etc_thisyear,
						rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 1) etc_nextyear,
						rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 2) etc_futureyears
                 FROM projmast p
                 WHERE
                     ( EXISTS (SELECT projno FROM rap_gtt_budgmast budgmast WHERE budgmast.projno = p.projno ) OR
                       EXISTS (SELECT projno FROM rap_gtt_prjcmast prjcmast WHERE prjcmast.projno = p.projno AND to_number(yymm) > to_number(TRIM(:p_yymm)) ) OR
                       EXISTS (SELECT projno FROM rap_gtt_openmast openmast WHERE openmast.projno = p.projno ) OR
                       EXISTS (SELECT projno FROM rap_gtt_timetran t WHERE t.projno = p.projno
                                    AND to_number(t.yymm) >= to_number(rap_reports_gen.get_yymm_begin(:p_yymm, :p_yearmode))
                                    AND to_number(t.yymm) <= to_number(TRIM(:p_yymm)))
                    )
                    AND rap_reports_gen.get_projno_active_status(:p_yymm, :p_yearmode, p.active, p.cdate) = 1
               ORDER BY
                    tma_grp, newcostcode_desc, projno ) a '
            Using p_yymm, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode, p_yymm, p_yearmode, p_yearmode, p_yymm, p_yearmode,
            p_yymm,
            p_yearmode, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode;

    End;

    --TMA (TMA Summary Report)
    Procedure get_tma_summ(
        p_yymm     In  Varchar2,
        p_yearmode In  Varchar2,
        p_tma      Out Sys_Refcursor
    ) As
    Begin
        Open p_tma For 'SELECT rownum, a.* FROM (
                        SELECT
						SUBSTR(p.projno,1,5) projno,
                        p.newcostcode || '' '' || rap_reports_gen.get_costcode_desc(p.newcostcode) newcostcode_desc,
                        p.tcmno,
                        p.name,
                        p.abbr,
                        p.sdate,
						p.revcdate,
                        p.cdate,
                        rap_reports_gen.get_job_type_tma_grp
                            (final_tma_order(SUBSTR(p.projno,1,5),
                                             p.active,
                                             p.projtype,
                                             p.cdate,
                                             :p_yymm,
                                             to_date(rap_reports_gen.get_yymm_begin(:p_yymm,
                                                            :p_yearmode), ''yyyymm'')-1,
                                             p.revcdate)) AS tma_grp,
                        SUM(rap_reports_gen.get_original_budget(p_projno => p.projno)) original,
                        SUM(rap_reports_gen.get_revised_budget(p_projno => p.projno)) revised,
                        SUM(rap_reports_gen.get_actual_month_hours(p_yymm => :p_yymm, p_projno => p.projno)) month,
                        SUM(rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno)) year,
                        SUM(rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno) +
                            rap_reports_gen.get_opening_hours(p_yearmode => :p_yearmode, p_projno => p.projno)) total,
                        SUM(rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 0)) etc_thisyear,
						SUM(rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 1)) etc_nextyear,
						SUM(rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 2)) etc_futureyears
                 FROM projmast p
                 WHERE
                     ( EXISTS (SELECT projno FROM rap_gtt_budgmast budgmast WHERE budgmast.projno = p.projno ) OR
                       EXISTS (SELECT projno FROM rap_gtt_prjcmast prjcmast WHERE prjcmast.projno = p.projno AND to_number(yymm) > to_number(TRIM(:p_yymm)) ) OR
                       EXISTS (SELECT projno FROM rap_gtt_openmast openmast WHERE openmast.projno = p.projno ) OR
                       EXISTS (SELECT projno FROM rap_gtt_timetran t WHERE t.projno = p.projno
                                    AND to_number(t.yymm) >= to_number(rap_reports_gen.get_yymm_begin(:p_yymm, :p_yearmode))
                                    AND to_number(t.yymm) <= to_number(TRIM(:p_yymm)))
                    )
                    AND rap_reports_gen.get_projno_active_status(:p_yymm, :p_yearmode, p.active, p.cdate) = 1
                GROUP BY
                    SUBSTR(p.projno,1,5),
                    p.newcostcode || '' '' || rap_reports_gen.get_costcode_desc(p.newcostcode),
                    p.tcmno,
                    p.name,
                    p.abbr,
                    p.sdate,
                    p.revcdate,
                    p.cdate,
                    rap_reports_gen.get_job_type_tma_grp
                        (final_tma_order(SUBSTR(p.projno,1,5),
                                         p.active,
                                         p.projtype,
                                         p.cdate,
                                         :p_yymm,
                                         to_date(rap_reports_gen.get_yymm_begin(:p_yymm,
                                                        :p_yearmode), ''yyyymm'')-1,
                                         p.revcdate))
                 ORDER BY
                    tma_grp, newcostcode_desc, projno ) a '
            Using p_yymm, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode, p_yymm, p_yearmode, p_yearmode, p_yymm, p_yearmode,
            p_yymm,
            p_yearmode, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode;

    End;

    --TMA (T) (TMA Report)
    Procedure get_tma_t(
        p_yymm     In  Varchar2,
        p_yearmode In  Varchar2,
        p_tma_t    Out Sys_Refcursor
    ) As
    Begin
        Open p_tma_t For 'SELECT rownum, a.* FROM
                        (SELECT
						p.projno projno,
                        p.newcostcode || '' '' || rap_reports_gen.get_costcode_desc(p.newcostcode) newcostcode_desc,
                        p.tcmno,
                        p.name,
                        p.abbr,
                        p.sdate,
						p.revcdate,
                        p.cdate,
                        rap_reports_gen.get_job_type_tma_grp
                            (final_tma_order(p.projno,
                                             p.active,
                                             p.projtype,
                                             p.cdate,
                                             :p_yymm,
                                             to_date(rap_reports_gen.get_yymm_begin(:p_yymm,
                                                            :p_yearmode), ''yyyymm'')-1,
                                             p.revcdate)) AS tma_grp,
                        rap_reports_gen.get_original_budget(p_projno => p.projno, p_costgrp => ''M'' ) original,
                        rap_reports_gen.get_revised_budget(p_projno => p.projno, p_costgrp => ''M'' ) revised,
						rap_reports_gen.get_actual_month_hours(p_yymm => :p_yymm, p_projno => p.projno, p_costgrp => ''M'' ) month,
						rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_costgrp => ''M'' ) year,
						rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_costgrp => ''M'' ) +
                            rap_reports_gen.get_opening_hours(p_yearmode => :p_yearmode, p_projno => p.projno, p_costgrp => ''M'' ) total,
						rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 0, p_costgrp => ''M'' ) etc_thisyear,
						rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 1, p_costgrp => ''M'' ) etc_nextyear,
						rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 2, p_costgrp => ''M'' ) etc_futureyears
                        FROM projmast p
                        WHERE co = ''T'' AND (
                            EXISTS (SELECT projno FROM rap_gtt_budgmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp != ''E'' AND a.projno = p.projno ) OR
                            EXISTS (SELECT projno FROM rap_gtt_prjcmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp != ''E'' AND a.projno = p.projno AND to_number(yymm) > to_number(TRIM(:p_yymm))  ) OR
                            EXISTS (SELECT projno FROM rap_gtt_openmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp != ''E'' AND a.projno = p.projno ) OR
                            EXISTS (SELECT projno FROM rap_gtt_timetran t WHERE t.projno = p.projno
                                        AND t.grp != ''E''
                                        AND to_number(t.yymm) >= to_number(rap_reports_gen.get_yymm_begin(:p_yymm, :p_yearmode))
                                        AND to_number(t.yymm) <= to_number(TRIM(:p_yymm))))
                            AND rap_reports_gen.get_projno_active_status(:p_yymm, :p_yearmode, p.active, p.cdate) = 1
                        ORDER BY
                            tma_grp, newcostcode_desc, projno ) a'
            Using p_yymm, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode, p_yymm, p_yearmode, p_yearmode, p_yymm, p_yearmode,
            p_yymm,
            p_yearmode, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode;

    End;

    --TMA (T) (TMA Summary Report)
    Procedure get_tma_t_summ(
        p_yymm     In  Varchar2,
        p_yearmode In  Varchar2,
        p_tma_t    Out Sys_Refcursor
    ) As
    Begin
        Open p_tma_t For 'SELECT rownum, a.* FROM
                        (SELECT
						SUBSTR(p.projno,1,5) projno,
                        p.newcostcode || '' '' || rap_reports_gen.get_costcode_desc(p.newcostcode) newcostcode_desc,
                        p.tcmno,
                        p.name,
                        p.abbr,
                        p.sdate,
						p.revcdate,
                        p.cdate,
                        rap_reports_gen.get_job_type_tma_grp
                            (final_tma_order(SUBSTR(p.projno,1,5),
                                             p.active,
                                             p.projtype,
                                             p.cdate,
                                             :p_yymm,
                                             to_date(rap_reports_gen.get_yymm_begin(:p_yymm,
                                                            :p_yearmode), ''yyyymm'')-1,
                                             p.revcdate)) AS tma_grp,
                        SUM(rap_reports_gen.get_original_budget(p_projno => p.projno, p_costgrp => ''M'' )) original,
                        SUM(rap_reports_gen.get_revised_budget(p_projno => p.projno, p_costgrp => ''M'' )) revised,
						SUM(rap_reports_gen.get_actual_month_hours(p_yymm => :p_yymm, p_projno => p.projno, p_costgrp => ''M'' )) month,
						SUM(rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_costgrp => ''M'' )) year,
						SUM(rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_costgrp => ''M'' ) +
                            rap_reports_gen.get_opening_hours(p_yearmode => :p_yearmode, p_projno => p.projno, p_costgrp => ''M'' )) total,
						SUM(rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 0, p_costgrp => ''M'' )) etc_thisyear,
						SUM(rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 1, p_costgrp => ''M'' )) etc_nextyear,
						SUM(rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 2, p_costgrp => ''M'' )) etc_futureyears
                        FROM projmast p
                        WHERE co = ''T'' AND (
                            EXISTS (SELECT projno FROM rap_gtt_budgmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp != ''E'' AND a.projno = p.projno ) OR
                            EXISTS (SELECT projno FROM rap_gtt_prjcmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp != ''E'' AND a.projno = p.projno AND to_number(yymm) > to_number(TRIM(:p_yymm))  ) OR
                            EXISTS (SELECT projno FROM rap_gtt_openmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp != ''E'' AND a.projno = p.projno ) OR
                            EXISTS (SELECT projno FROM rap_gtt_timetran t WHERE t.projno = p.projno
                                        AND t.grp != ''E''
                                        AND to_number(t.yymm) >= to_number(rap_reports_gen.get_yymm_begin(:p_yymm, :p_yearmode))
                                        AND to_number(t.yymm) <= to_number(TRIM(:p_yymm))))
                            AND rap_reports_gen.get_projno_active_status(:p_yymm, :p_yearmode, p.active, p.cdate) = 1
                        GROUP BY
                            SUBSTR(p.projno,1,5),
                            p.newcostcode || '' '' || rap_reports_gen.get_costcode_desc(p.newcostcode),
                            p.tcmno,
                            p.name,
                            p.abbr,
                            p.sdate,
                            p.revcdate,
                            p.cdate,
                            rap_reports_gen.get_job_type_tma_grp
                                (final_tma_order(SUBSTR(p.projno,1,5),
                                                 p.active,
                                                 p.projtype,
                                                 p.cdate,
                                                 :p_yymm,
                                                 to_date(rap_reports_gen.get_yymm_begin(:p_yymm,
                                                                :p_yearmode), ''yyyymm'')-1,
                                                 p.revcdate))
                        ORDER BY
                            tma_grp, newcostcode_desc, projno ) a'
            Using p_yymm, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode, p_yymm, p_yearmode, p_yearmode, p_yymm, p_yearmode,
            p_yymm,
            p_yearmode, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode;

    End;

    --TMA (E) & TMA-Depute (TMA Report)
    Procedure get_tma_e_d(
        p_yymm     In  Varchar2,
        p_yearmode In  Varchar2,
        p_costgrp  In  Varchar2,
        p_tma_e_d  Out Sys_Refcursor
    ) As
    Begin
        Open p_tma_e_d For 'SELECT rownum, a.* FROM (
                        SELECT
						p.projno projno,
                        p.newcostcode || '' '' || rap_reports_gen.get_costcode_desc(p.newcostcode) newcostcode_desc,
                        p.tcmno,
                        p.name,
                        p.abbr,
                        p.sdate,
						p.revcdate,
                        p.cdate,
                        rap_reports_gen.get_job_type_tma_grp
                            (final_tma_order(p.projno,
                                             p.active,
                                             p.projtype,
                                             p.cdate,
                                             :p_yymm,
                                             to_date(rap_reports_gen.get_yymm_begin(:p_yymm,
                                                            :p_yearmode), ''yyyymm'')-1,
                                             p.revcdate)) AS tma_grp,
                        rap_reports_gen.get_original_budget(p_projno => p.projno, p_costgrp => :p_costgrp ) original,
                        rap_reports_gen.get_revised_budget(p_projno => p.projno, p_costgrp => :p_costgrp ) revised,
						rap_reports_gen.get_actual_month_hours(p_yymm => :p_yymm, p_projno => p.projno, p_costgrp => :p_costgrp ) month,
						rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_costgrp => :p_costgrp ) year,
						rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_costgrp => :p_costgrp ) +
                            rap_reports_gen.get_opening_hours(p_yearmode => :p_yearmode, p_projno => p.projno, p_costgrp => :p_costgrp ) total,
						rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 0, p_costgrp => :p_costgrp ) etc_thisyear,
						rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 1, p_costgrp => :p_costgrp ) etc_nextyear,
						rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 2, p_costgrp => :p_costgrp ) etc_futureyears
                        FROM projmast p
                        WHERE co = ''T'' AND (
                            EXISTS (SELECT projno FROM rap_gtt_budgmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp = :p_costgrp AND a.projno = p.projno ) OR
                            EXISTS (SELECT projno FROM rap_gtt_prjcmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp = :p_costgrp AND a.projno = p.projno AND to_number(yymm) > to_number(TRIM(:p_yymm))  ) OR
                            EXISTS (SELECT projno FROM rap_gtt_openmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp = :p_costgrp AND a.projno = p.projno ) OR
                            EXISTS (SELECT projno FROM rap_gtt_timetran t WHERE t.projno = p.projno
                                        AND t.grp = :p_costgrp
                                        AND to_number(t.yymm) >= to_number(rap_reports_gen.get_yymm_begin(:p_yymm, :p_yearmode))
                                        AND to_number(t.yymm) <= to_number(TRIM(:p_yymm))))
                            AND rap_reports_gen.get_projno_active_status(:p_yymm, :p_yearmode, p.active, p.cdate) = 1
                        ORDER BY
                            tma_grp, newcostcode_desc, projno ) a '
            Using p_yymm, p_yymm, p_yearmode, p_costgrp, p_costgrp, p_yymm, p_costgrp, p_yymm, p_yearmode, p_costgrp, p_yymm,
            p_yearmode,
            p_costgrp, p_yearmode, p_costgrp, p_yymm, p_yearmode, p_costgrp, p_yymm, p_yearmode, p_costgrp, p_yymm, p_yearmode,
            p_costgrp,
            p_costgrp, p_costgrp, p_yymm, p_costgrp, p_costgrp, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode;

    End;

    --TMA (E) & TMA-Depute (TMA Summary Report)
    Procedure get_tma_e_d_summ(
        p_yymm     In  Varchar2,
        p_yearmode In  Varchar2,
        p_costgrp  In  Varchar2,
        p_tma_e_d  Out Sys_Refcursor
    ) As
    Begin
        Open p_tma_e_d For 'SELECT rownum, a.* FROM (
                        SELECT
						SUBSTR(p.projno,1,5) projno,
                        p.newcostcode || '' '' || rap_reports_gen.get_costcode_desc(p.newcostcode) newcostcode_desc,
                        p.tcmno,
                        p.name,
                        p.abbr,
                        p.sdate,
						p.revcdate,
                        p.cdate,
                        rap_reports_gen.get_job_type_tma_grp
                            (final_tma_order(SUBSTR(p.projno,1,5),
                                             p.active,
                                             p.projtype,
                                             p.cdate,
                                             :p_yymm,
                                             to_date(rap_reports_gen.get_yymm_begin(:p_yymm,
                                                            :p_yearmode), ''yyyymm'')-1,
                                             p.revcdate)) AS tma_grp,
                        SUM(rap_reports_gen.get_original_budget(p_projno => p.projno, p_costgrp => :p_costgrp )) original,
                        SUM(rap_reports_gen.get_revised_budget(p_projno => p.projno, p_costgrp => :p_costgrp )) revised,
						SUM(rap_reports_gen.get_actual_month_hours(p_yymm => :p_yymm, p_projno => p.projno, p_costgrp => :p_costgrp )) month,
						SUM(rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_costgrp => :p_costgrp )) year,
						SUM(rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_costgrp => :p_costgrp ) +
                            rap_reports_gen.get_opening_hours(p_yearmode => :p_yearmode, p_projno => p.projno, p_costgrp => :p_costgrp )) total,
						SUM(rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 0, p_costgrp => :p_costgrp )) etc_thisyear,
						SUM(rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 1, p_costgrp => :p_costgrp )) etc_nextyear,
						SUM(rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 2, p_costgrp => :p_costgrp )) etc_futureyears
                        FROM projmast p
                        WHERE co = ''T'' AND (
                            EXISTS (SELECT projno FROM rap_gtt_budgmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp = :p_costgrp AND a.projno = p.projno ) OR
                            EXISTS (SELECT projno FROM rap_gtt_prjcmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp = :p_costgrp AND a.projno = p.projno AND to_number(yymm) > to_number(TRIM(:p_yymm))  ) OR
                            EXISTS (SELECT projno FROM rap_gtt_openmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp = :p_costgrp AND a.projno = p.projno ) OR
                            EXISTS (SELECT projno FROM rap_gtt_timetran t WHERE t.projno = p.projno
                                        AND t.grp = :p_costgrp
                                        AND to_number(t.yymm) >= to_number(rap_reports_gen.get_yymm_begin(:p_yymm, :p_yearmode))
                                        AND to_number(t.yymm) <= to_number(TRIM(:p_yymm))))
                            AND rap_reports_gen.get_projno_active_status(:p_yymm, :p_yearmode, p.active, p.cdate) = 1
                        GROUP BY
                            SUBSTR(p.projno,1,5),
                            p.newcostcode || '' '' || rap_reports_gen.get_costcode_desc(p.newcostcode),
                            p.tcmno,
                            p.name,
                            p.abbr,
                            p.sdate,
                            p.revcdate,
                            p.cdate,
                            rap_reports_gen.get_job_type_tma_grp
                                (final_tma_order(SUBSTR(p.projno,1,5),
                                                 p.active,
                                                 p.projtype,
                                                 p.cdate,
                                                 :p_yymm,
                                                 to_date(rap_reports_gen.get_yymm_begin(:p_yymm,
                                                                :p_yearmode), ''yyyymm'')-1,
                                                 p.revcdate))
                        ORDER BY
                            tma_grp, newcostcode_desc, projno ) a '
            Using p_yymm, p_yymm, p_yearmode, p_costgrp, p_costgrp, p_yymm, p_costgrp, p_yymm, p_yearmode, p_costgrp, p_yymm,
            p_yearmode,
            p_costgrp, p_yearmode, p_costgrp, p_yymm, p_yearmode, p_costgrp, p_yymm, p_yearmode, p_costgrp, p_yymm, p_yearmode,
            p_costgrp,
            p_costgrp, p_costgrp, p_yymm, p_costgrp, p_costgrp, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode, p_yymm, p_yymm,
            p_yearmode;

    End;

    --TMA-NonDepute (TMA Report)
    Procedure get_tma_n(
        p_yymm     In  Varchar2,
        p_yearmode In  Varchar2,
        p_tma_n    Out Sys_Refcursor
    ) As
    Begin
        Open p_tma_n For 'SELECT rownum, a.* FROM
                        (SELECT
						p.projno projno,
                        p.newcostcode || '' '' || rap_reports_gen.get_costcode_desc(p.newcostcode) newcostcode_desc,
                        p.tcmno,
                        p.name,
                        p.abbr,
                        p.sdate,
						p.revcdate,
                        p.cdate,
                        rap_reports_gen.get_job_type_tma_grp
                            (final_tma_order(p.projno,
                                             p.active,
                                             p.projtype,
                                             p.cdate,
                                             :p_yymm,
                                             to_date(rap_reports_gen.get_yymm_begin(:p_yymm,
                                                            :p_yearmode), ''yyyymm'')-1,
                                             p.revcdate)) AS tma_grp,
                        rap_reports_gen.get_original_budget(p_projno => p.projno, p_costgrp => ''N'' ) original,
                        rap_reports_gen.get_revised_budget(p_projno => p.projno, p_costgrp => ''N'' ) revised,
						rap_reports_gen.get_actual_month_hours(p_yymm => :p_yymm, p_projno => p.projno, p_costgrp => ''N'' ) month,
						rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_costgrp => ''N'' ) year,
						rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_costgrp => ''N'' ) +
                            rap_reports_gen.get_opening_hours(p_yearmode => :p_yearmode, p_projno => p.projno, p_costgrp => ''N'' ) total,
						rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 0, p_costgrp => ''N'' ) etc_thisyear,
						rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 1, p_costgrp => ''N'' ) etc_nextyear,
						rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 2, p_costgrp => ''N'' ) etc_futureyears
                        FROM projmast p
                        WHERE co = ''T'' AND (
                            EXISTS (SELECT projno FROM rap_gtt_budgmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp != ''D'' AND a.projno = p.projno ) OR
                            EXISTS (SELECT projno FROM rap_gtt_prjcmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp != ''D'' AND a.projno = p.projno AND to_number(yymm) > to_number(TRIM(:p_yymm))  ) OR
                            EXISTS (SELECT projno FROM rap_gtt_openmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp != ''D'' AND a.projno = p.projno ) OR
                            EXISTS (SELECT projno FROM rap_gtt_timetran t WHERE t.projno = p.projno
                                        AND t.grp != ''D''
                                        AND to_number(t.yymm) >= to_number(rap_reports_gen.get_yymm_begin(:p_yymm, :p_yearmode))
                                        AND to_number(t.yymm) <= to_number(TRIM(:p_yymm))))
                            AND rap_reports_gen.get_projno_active_status(:p_yymm, :p_yearmode, p.active, p.cdate) = 1
                        ORDER BY
                            tma_grp, newcostcode_desc, projno ) a'
            Using p_yymm, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode, p_yymm, p_yearmode, p_yearmode, p_yymm, p_yearmode,
            p_yymm,
            p_yearmode, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode;

    End;

    --TMA-NonDepute (TMA Summary Report)
    Procedure get_tma_n_summ(
        p_yymm     In  Varchar2,
        p_yearmode In  Varchar2,
        p_tma_n    Out Sys_Refcursor
    ) As
    Begin
        Open p_tma_n For 'SELECT rownum, a.* FROM
                        (SELECT
						SUBSTR(p.projno,1,5) projno,
                        p.newcostcode || '' '' || rap_reports_gen.get_costcode_desc(p.newcostcode) newcostcode_desc,
                        p.tcmno,
                        p.name,
                        p.abbr,
                        p.sdate,
						p.revcdate,
                        p.cdate,
                        rap_reports_gen.get_job_type_tma_grp
                            (final_tma_order(SUBSTR(p.projno,1,5),
                                             p.active,
                                             p.projtype,
                                             p.cdate,
                                             :p_yymm,
                                             to_date(rap_reports_gen.get_yymm_begin(:p_yymm,
                                                            :p_yearmode), ''yyyymm'')-1,
                                             p.revcdate)) AS tma_grp,
                        SUM(rap_reports_gen.get_original_budget(p_projno => p.projno, p_costgrp => ''N'' )) original,
                        SUM(rap_reports_gen.get_revised_budget(p_projno => p.projno, p_costgrp => ''N'' )) revised,
						SUM(rap_reports_gen.get_actual_month_hours(p_yymm => :p_yymm, p_projno => p.projno, p_costgrp => ''N'' )) month,
						SUM(rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_costgrp => ''N'' )) year,
						SUM(rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_costgrp => ''N'' ) +
                            rap_reports_gen.get_opening_hours(p_yearmode => :p_yearmode, p_projno => p.projno, p_costgrp => ''N'' )) total,
						SUM(rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 0, p_costgrp => ''N'' )) etc_thisyear,
						SUM(rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 1, p_costgrp => ''N'' )) etc_nextyear,
						SUM(rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 2, p_costgrp => ''N'' )) etc_futureyears
                        FROM projmast p
                        WHERE co = ''T'' AND (
                            EXISTS (SELECT projno FROM rap_gtt_budgmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp != ''D'' AND a.projno = p.projno ) OR
                            EXISTS (SELECT projno FROM rap_gtt_prjcmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp != ''D'' AND a.projno = p.projno AND to_number(yymm) > to_number(TRIM(:p_yymm))  ) OR
                            EXISTS (SELECT projno FROM rap_gtt_openmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp != ''D'' AND a.projno = p.projno ) OR
                            EXISTS (SELECT projno FROM rap_gtt_timetran t WHERE t.projno = p.projno
                                        AND t.grp != ''D''
                                        AND to_number(t.yymm) >= to_number(rap_reports_gen.get_yymm_begin(:p_yymm, :p_yearmode))
                                        AND to_number(t.yymm) <= to_number(TRIM(:p_yymm))))
                            AND rap_reports_gen.get_projno_active_status(:p_yymm, :p_yearmode, p.active, p.cdate) = 1
                        GROUP BY
                            SUBSTR(p.projno,1,5),
                            p.newcostcode || '' '' || rap_reports_gen.get_costcode_desc(p.newcostcode),
                            p.tcmno,
                            p.name,
                            p.abbr,
                            p.sdate,
                            p.revcdate,
                            p.cdate,
                            rap_reports_gen.get_job_type_tma_grp
                                (final_tma_order(SUBSTR(p.projno,1,5),
                                                 p.active,
                                                 p.projtype,
                                                 p.cdate,
                                                 :p_yymm,
                                                 to_date(rap_reports_gen.get_yymm_begin(:p_yymm,
                                                                :p_yearmode), ''yyyymm'')-1,
                                                 p.revcdate))
                        ORDER BY
                            tma_grp, newcostcode_desc, projno ) a'
            Using p_yymm, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode, p_yymm, p_yearmode, p_yearmode, p_yymm, p_yearmode,
            p_yymm,
            p_yearmode, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode;

    End;

    --TMA-NonDepute Minus E (TMA Report)
    Procedure get_tma_o(
        p_yymm     In  Varchar2,
        p_yearmode In  Varchar2,
        p_tma_o    Out Sys_Refcursor
    ) As
    Begin
        Open p_tma_o For 'SELECT rownum, a.* FROM
                        (SELECT
						p.projno projno,
                        p.newcostcode || '' '' || rap_reports_gen.get_costcode_desc(p.newcostcode) newcostcode_desc,
                        p.tcmno,
                        p.name,
                        p.abbr,
                        p.sdate,
						p.revcdate,
                        p.cdate,
                        rap_reports_gen.get_job_type_tma_grp
                            (final_tma_order(p.projno,
                                             p.active,
                                             p.projtype,
                                             p.cdate,
                                             :p_yymm,
                                             to_date(rap_reports_gen.get_yymm_begin(:p_yymm,
                                                            :p_yearmode), ''yyyymm'')-1,
                                             p.revcdate)) AS tma_grp,
                        rap_reports_gen.get_original_budget(p_projno => p.projno, p_costgrp => ''O'' ) original,
                        rap_reports_gen.get_revised_budget(p_projno => p.projno, p_costgrp => ''O'' ) revised,
						rap_reports_gen.get_actual_month_hours(p_yymm => :p_yymm, p_projno => p.projno, p_costgrp => ''O'' ) month,
						rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_costgrp => ''O'' ) year,
						rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_costgrp => ''O'' ) +
                            rap_reports_gen.get_opening_hours(p_yearmode => :p_yearmode, p_projno => p.projno, p_costgrp => ''O'' ) total,
						rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 0, p_costgrp => ''O'' ) etc_thisyear,
						rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 1, p_costgrp => ''O'' ) etc_nextyear,
						rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 2, p_costgrp => ''O'' ) etc_futureyears
                        FROM projmast p
                        WHERE co = ''T'' AND (
                            EXISTS (SELECT projno FROM rap_gtt_budgmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp != ''D'' AND b.tma_grp != ''E'' AND a.projno = p.projno ) OR
                            EXISTS (SELECT projno FROM rap_gtt_prjcmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp != ''D'' AND b.tma_grp != ''E'' AND a.projno = p.projno AND to_number(yymm) > to_number(TRIM(:p_yymm))  ) OR
                            EXISTS (SELECT projno FROM rap_gtt_openmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp != ''D'' AND b.tma_grp != ''E'' AND a.projno = p.projno ) OR
                            EXISTS (SELECT projno FROM rap_gtt_timetran t WHERE t.projno = p.projno
                                        AND t.grp != ''D'' AND t.grp != ''E''
                                        AND to_number(t.yymm) >= to_number(rap_reports_gen.get_yymm_begin(:p_yymm, :p_yearmode))
                                        AND to_number(t.yymm) <= to_number(TRIM(:p_yymm))))
                            AND rap_reports_gen.get_projno_active_status(:p_yymm, :p_yearmode, p.active, p.cdate) = 1
                        ORDER BY
                            tma_grp, newcostcode_desc, projno ) a'
            Using p_yymm, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode, p_yymm, p_yearmode, p_yearmode, p_yymm, p_yearmode,
            p_yymm,
            p_yearmode, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode;

    End;

    --TMA-NonDepute Minus E (TMA Summary Report)
    Procedure get_tma_o_summ(
        p_yymm     In  Varchar2,
        p_yearmode In  Varchar2,
        p_tma_o    Out Sys_Refcursor
    ) As
    Begin
        Open p_tma_o For 'SELECT rownum, a.* FROM
                        (SELECT
						SUBSTR(p.projno,1,5) projno,
                        p.newcostcode || '' '' || rap_reports_gen.get_costcode_desc(p.newcostcode) newcostcode_desc,
                        p.tcmno,
                        p.name,
                        p.abbr,
                        p.sdate,
						p.revcdate,
                        p.cdate,
                        rap_reports_gen.get_job_type_tma_grp
                            (final_tma_order(SUBSTR(p.projno,1,5),
                                             p.active,
                                             p.projtype,
                                             p.cdate,
                                             :p_yymm,
                                             to_date(rap_reports_gen.get_yymm_begin(:p_yymm,
                                                            :p_yearmode), ''yyyymm'')-1,
                                             p.revcdate)) AS tma_grp,
                        SUM(rap_reports_gen.get_original_budget(p_projno => p.projno, p_costgrp => ''O'' )) original,
                        SUM(rap_reports_gen.get_revised_budget(p_projno => p.projno, p_costgrp => ''O'' )) revised,
						SUM(rap_reports_gen.get_actual_month_hours(p_yymm => :p_yymm, p_projno => p.projno, p_costgrp => ''O'' )) month,
						SUM(rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_costgrp => ''O'' )) year,
						SUM(rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_costgrp => ''O'' ) +
                            rap_reports_gen.get_opening_hours(p_yearmode => :p_yearmode, p_projno => p.projno, p_costgrp => ''O'' )) total,
						SUM(rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 0, p_costgrp => ''O'' )) etc_thisyear,
						SUM(rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 1, p_costgrp => ''O'' )) etc_nextyear,
						SUM(rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 2, p_costgrp => ''O'' )) etc_futureyears
                        FROM projmast p
                        WHERE co = ''T'' AND (
                            EXISTS (SELECT projno FROM rap_gtt_budgmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp != ''D'' AND b.tma_grp != ''E'' AND a.projno = p.projno ) OR
                            EXISTS (SELECT projno FROM rap_gtt_prjcmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp != ''D'' AND b.tma_grp != ''E'' AND a.projno = p.projno AND to_number(yymm) > to_number(TRIM(:p_yymm))  ) OR
                            EXISTS (SELECT projno FROM rap_gtt_openmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp != ''D'' AND b.tma_grp != ''E'' AND a.projno = p.projno ) OR
                            EXISTS (SELECT projno FROM rap_gtt_timetran t WHERE t.projno = p.projno
                                        AND t.grp != ''D'' AND t.grp != ''E''
                                        AND to_number(t.yymm) >= to_number(rap_reports_gen.get_yymm_begin(:p_yymm, :p_yearmode))
                                        AND to_number(t.yymm) <= to_number(TRIM(:p_yymm))))
                            AND rap_reports_gen.get_projno_active_status(:p_yymm, :p_yearmode, p.active, p.cdate) = 1
                        GROUP BY
                            SUBSTR(p.projno,1,5),
                            p.newcostcode || '' '' || rap_reports_gen.get_costcode_desc(p.newcostcode),
                            p.tcmno,
                            p.name,
                            p.abbr,
                            p.sdate,
                            p.revcdate,
                            p.cdate,
                            rap_reports_gen.get_job_type_tma_grp
                                (final_tma_order(SUBSTR(p.projno,1,5),
                                                 p.active,
                                                 p.projtype,
                                                 p.cdate,
                                                 :p_yymm,
                                                 to_date(rap_reports_gen.get_yymm_begin(:p_yymm,
                                                                :p_yearmode), ''yyyymm'')-1,
                                                 p.revcdate))
                        ORDER BY
                            tma_grp, newcostcode_desc, projno ) a'
            Using p_yymm, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode, p_yymm, p_yearmode, p_yearmode, p_yymm, p_yearmode,
            p_yymm,
            p_yearmode, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode;

    End;

    --TM13
    Procedure get_tm13(
        p_yymm              In  Varchar2,
        p_yearmode          In  Varchar2,
        p_data_pivot_clause Out Varchar2,
        p_cols              Out Sys_Refcursor,
        p_tm13              Out Sys_Refcursor
    ) As

        data_pivot_clause    Varchar2(4000);
        heading_pivot_clause Varchar2(4000);
        noofmonths           Number := 12;
        yymm_end             Varchar2(6);
    Begin
        Select
            Listagg('''' || heading || '''' || ' as ' || heading || '', ', ') Within
                Group (
                Order By
                    heading
                ),
            Listagg(yymm || ' as "' || heading || '"', ', ') Within
                Group (
                Order By
                    yymm
                )
        Into
            heading_pivot_clause,
            data_pivot_clause
        From
            (
                Select
                    yymm,
                    heading
                From
                    Table (rap_reports.rpt_month_cols(rap_reports_gen.get_yymm(p_yymm, 1), noofmonths))
            );

        -- Heading
        Open p_cols For 'SELECT * FROM (
                                        SELECT
                                            heading,
                                            yymm
                                        FROM
                                            TABLE( rap_reports.rpt_month_cols(rap_reports_gen.get_yymm(:p_yymm, 1),
                                                                                                         :noofmonths) )
                        ) Pivot ( max(yymm) For heading in ('
            || heading_pivot_clause
            || '))'
            Using p_yymm, noofmonths;

        -- Data
        Open p_tm13 For ' SELECT a.*, rap_reports_gen.get_revised_budget(p_projno => a.projno) revised,
                                      rap_reports_gen.get_actual_month_hours(p_yymm => :p_yymm, p_projno => A.projno) month,
                                      rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode,
                                                                                                    p_projno => A.projno) year,
                                      rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode,
                                                                                                       p_projno => A.projno)
                                          +  rap_reports_gen.get_opening_hours(p_yearmode => :p_yearmode, p_projno => A.projno) total,
                                      rap_reports_gen.get_projected_hours_future(p_yymm => :p_yymm, p_projno => A.projno,
                                                                                                          p_noofmonths => 12) afterHours
                          FROM (
                          SELECT * FROM ( SELECT
                                            p.projno projno,
                                            p.newcostcode || '' '' || rap_reports_gen.get_costcode_desc(p.newcostcode) newcostcode_desc,
                                            p.tcmno,
                                            p.name,
                                            rap_reports_gen.get_job_type_tma_grp
                                                (final_tma_order(p.projno,
                                                                 p.active,
                                                                 p.projtype,
                                                                 p.cdate,
                                                                 :p_yymm,
                                                                 to_date(rap_reports_gen.get_yymm_begin(:p_yymm,
                                                                                :p_yearmode), ''yyyymm'')-1,
                                                                 p.revcdate)) AS tma_grp,
                                            pc.yymm,
                                            nvl(pc.hours, 0) hours
                                     FROM projmast p, rap_gtt_prjcmast pc
                                     WHERE p.projno = pc.projno(+)
                                     AND ( EXISTS (SELECT projno FROM rap_gtt_budgmast budgmast WHERE budgmast.projno = p.projno ) OR
                                           EXISTS (SELECT projno FROM rap_gtt_prjcmast prjcmast WHERE prjcmast.projno = p.projno AND to_number(yymm) > to_number(TRIM(:p_yymm))  ) OR
                                           EXISTS (SELECT projno FROM rap_gtt_openmast openmast WHERE openmast.projno = p.projno ) OR
                                           EXISTS (SELECT projno FROM rap_gtt_timetran t WHERE t.projno = p.projno
                                                   AND to_number(t.yymm) >= to_number(rap_reports_gen.get_yymm_begin(:p_yymm, :p_yearmode))
                                                   AND to_number(t.yymm) <= to_number(TRIM(:p_yymm)))
                                        )
                                    AND rap_reports_gen.get_projno_active_status(:p_yymm, :p_yearmode, p.active, p.cdate) = 1
                                   )
                         Pivot
                         (
                             Sum(hours)
                             For yymm In ('
            || data_pivot_clause
            || ')
                         ) ) a
                         ORDER BY
                            tma_grp, newcostcode_desc, projno '
            Using p_yymm, p_yymm, p_yearmode, p_yymm, p_yearmode, p_yearmode, p_yymm, p_yymm, p_yymm, p_yearmode, p_yymm,
            p_yymm, p_yearmode,
            p_yymm, p_yymm, p_yearmode;

        p_data_pivot_clause := data_pivot_clause;
    End;

    --TM13  TMA Summary Report
    Procedure get_tm13_summ(
        p_yymm              In  Varchar2,
        p_yearmode          In  Varchar2,
        p_data_pivot_clause Out Varchar2,
        p_cols              Out Sys_Refcursor,
        p_tm13              Out Sys_Refcursor
    ) As

        data_pivot_clause    Varchar2(4000);
        heading_pivot_clause Varchar2(4000);
        noofmonths           Number := 12;
        yymm_end             Varchar2(6);
    Begin
        Select
            Listagg('''' || heading || '''' || ' as ' || heading || '', ', ') Within
                Group (
                Order By
                    heading
                ),
            Listagg(yymm || ' as "' || heading || '"', ', ') Within
                Group (
                Order By
                    yymm
                )
        Into
            heading_pivot_clause,
            data_pivot_clause
        From
            (
                Select
                    yymm,
                    heading
                From
                    Table (rap_reports.rpt_month_cols(rap_reports_gen.get_yymm(p_yymm, 1), noofmonths))
            );

        -- Heading
        Open p_cols For 'SELECT * FROM (
                                        SELECT
                                            heading,
                                            yymm
                                        FROM
                                            TABLE( rap_reports.rpt_month_cols(rap_reports_gen.get_yymm(:p_yymm, 1),
                                                                                                         :noofmonths) )
                        ) Pivot ( max(yymm) For heading in ('
            || heading_pivot_clause
            || '))'
            Using p_yymm, noofmonths;

        -- Data
        Open p_tm13 For ' SELECT a.*, rap_reports_gen.get_revised_budget(p_projno => a.projno) revised,
                                      rap_reports_gen.get_actual_month_hours(p_yymm => :p_yymm, p_projno => A.projno) month,
                                      rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode,
                                                                                                    p_projno => A.projno) year,
                                      rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode,
                                                                                                       p_projno => A.projno)
                                          +  rap_reports_gen.get_opening_hours(p_yearmode => :p_yearmode, p_projno => A.projno) total,
                                      rap_reports_gen.get_projected_hours_future(p_yymm => :p_yymm, p_projno => A.projno,
                                                                                                          p_noofmonths => 12) afterHours
                          FROM (
                          SELECT * FROM ( SELECT
                                            Substr(p.projno, 1, 5) projno,
                                            p.newcostcode || '' '' || rap_reports_gen.get_costcode_desc(p.newcostcode) newcostcode_desc,
                                            p.tcmno,
                                            p.name,
                                            rap_reports_gen.get_job_type_tma_grp
                                                (final_tma_order(Substr(p.projno, 1, 5),
                                                                 p.active,
                                                                 p.projtype,
                                                                 p.cdate,
                                                                 :p_yymm,
                                                                 to_date(rap_reports_gen.get_yymm_begin(:p_yymm,
                                                                                :p_yearmode), ''yyyymm'')-1,
                                                                 p.revcdate)) AS tma_grp,
                                            pc.yymm,
                                            SUM(nvl(pc.hours, 0)) hours
                                     FROM projmast p, rap_gtt_prjcmast pc
                                     WHERE p.projno = pc.projno(+)
                                         AND ( EXISTS (SELECT projno FROM rap_gtt_budgmast budgmast WHERE budgmast.projno = p.projno ) OR
                                               EXISTS (SELECT projno FROM rap_gtt_prjcmast prjcmast WHERE prjcmast.projno = p.projno AND to_number(yymm) > to_number(TRIM(:p_yymm))  ) OR
                                               EXISTS (SELECT projno FROM rap_gtt_openmast openmast WHERE openmast.projno = p.projno ) OR
                                               EXISTS (SELECT projno FROM rap_gtt_timetran t WHERE t.projno = p.projno
                                                       AND to_number(t.yymm) >= to_number(rap_reports_gen.get_yymm_begin(:p_yymm, :p_yearmode))
                                                       AND to_number(t.yymm) <= to_number(TRIM(:p_yymm)))
                                            )
                                        AND rap_reports_gen.get_projno_active_status(:p_yymm, :p_yearmode, p.active, p.cdate) = 1
                                     GROUP BY
                                        SUBSTR(p.projno, 1, 5),
                                        p.newcostcode || '' '' || rap_reports_gen.get_costcode_desc(p.newcostcode),
                                        p.tcmno,
                                        p.name,
                                        rap_reports_gen.get_job_type_tma_grp
                                            (final_tma_order(Substr(p.projno, 1, 5),
                                                             p.active,
                                                             p.projtype,
                                                             p.cdate,
                                                             :p_yymm,
                                                             to_date(rap_reports_gen.get_yymm_begin(:p_yymm,
                                                                            :p_yearmode), ''yyyymm'')-1,
                                                             p.revcdate)),
                                        pc.yymm
                                   )
                         Pivot
                         (
                             Sum(hours)
                             For yymm In ('
            || data_pivot_clause
            || ')
                         ) ) a
                         ORDER BY
                            tma_grp, newcostcode_desc, projno '
            Using p_yymm, p_yymm, p_yearmode, p_yymm, p_yearmode, p_yearmode, p_yymm, p_yymm, p_yymm, p_yearmode, p_yymm,
            p_yymm, p_yearmode,
            p_yymm, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode;

        p_data_pivot_clause := data_pivot_clause;
    End;

    --TM13E / TM13C / TM13P / TM13M / TM13D / TM13Z
    Procedure get_tm13_ecpmdz(
        p_yymm            In  Varchar2,
        p_yearmode        In  Varchar2,
        p_costgrp         In  Varchar2,
        data_pivot_clause In  Varchar2,
        p_tm13_ecpmdz     Out Sys_Refcursor
    ) As
        noofmonths Number := 12;
    Begin
        -- Data
        Open p_tm13_ecpmdz For ' SELECT d.*, rap_reports_gen.get_revised_budget(p_projno => d.projno, p_costgrp => ''TM13''||:p_costgrp ) revised,
									rap_reports_gen.get_actual_month_hours(p_yymm => :p_yymm, p_projno => d.projno, p_costgrp => ''TM13''||:p_costgrp ) month,
									rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => d.projno, p_costgrp => ''TM13''||:p_costgrp ) year,
									rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => d.projno, p_costgrp => ''TM13''||:p_costgrp ) +
										rap_reports_gen.get_opening_hours(p_yearmode => :p_yearmode, p_projno => d.projno, p_costgrp => ''TM13''||:p_costgrp ) total,
									rap_reports_gen.get_projected_hours_future(p_yymm => :p_yymm, p_projno => d.projno, p_costgrp => ''TM13''||:p_costgrp, p_noofmonths => 12) afterHours
                          FROM (
                          SELECT * FROM ( SELECT
                                            p.projno projno,
                                            p.newcostcode || '' '' || rap_reports_gen.get_costcode_desc(p.newcostcode) newcostcode_desc,
                                            p.tcmno,
                                            p.name,
                                            rap_reports_gen.get_job_type_tma_grp
                                                (final_tma_order(p.projno,
                                                                 p.active,
                                                                 p.projtype,
                                                                 p.cdate,
                                                                 :p_yymm,
                                                                 to_date(rap_reports_gen.get_yymm_begin(:p_yymm,
                                                                                :p_yearmode), ''yyyymm'')-1,
                                                                 p.revcdate)) AS tma_grp,
                                            pc.yymm,
                                            nvl(pc.hours, 0) hours
                                     FROM projmast p, rap_gtt_prjcmast pc
                                     WHERE p.projno = pc.projno(+)
                                     AND (
											EXISTS (SELECT projno FROM rap_gtt_budgmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp = :p_costgrp AND a.projno = p.projno ) OR
											EXISTS (SELECT projno FROM rap_gtt_prjcmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp = :p_costgrp AND a.projno = p.projno AND to_number(yymm) > to_number(TRIM(:p_yymm))  ) OR
											EXISTS (SELECT projno FROM rap_gtt_openmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp = :p_costgrp AND a.projno = p.projno ) OR
											EXISTS (SELECT projno FROM rap_gtt_timetran t, costmast b WHERE t.projno = p.projno
														AND t.costcode = b.costcode AND b.tma_grp = :p_costgrp
														AND to_number(t.yymm) >= to_number(rap_reports_gen.get_yymm_begin(:p_yymm, :p_yearmode))
														AND to_number(t.yymm) <= to_number(TRIM(:p_yymm)))
                                        )
                                     AND rap_reports_gen.get_projno_active_status(:p_yymm, :p_yearmode, p.active, p.cdate) = 1
                                   )
                         Pivot
                         (
                             Sum(hours)
                             For yymm In ('
            || data_pivot_clause
            || ')
                         ) ) d
                         ORDER BY
                            tma_grp, newcostcode_desc, projno '
            Using p_costgrp, p_yymm, p_costgrp, p_yymm, p_yearmode, p_costgrp, p_yymm, p_yearmode, p_costgrp, p_yearmode,
            p_costgrp, p_yymm,
            p_costgrp, p_yymm, p_yymm, p_yearmode, p_costgrp, p_costgrp, p_yymm, p_costgrp, p_costgrp, p_yymm, p_yearmode,
            p_yymm, p_yymm,
            p_yearmode;

    End;

    --TM13E / TM13C / TM13P / TM13M / TM13D / TM13Z Summary
    Procedure get_tm13_ecpmdz_summ(
        p_yymm            In  Varchar2,
        p_yearmode        In  Varchar2,
        p_costgrp         In  Varchar2,
        data_pivot_clause In  Varchar2,
        p_tm13_ecpmdz     Out Sys_Refcursor
    ) As
        noofmonths Number := 12;
    Begin
        -- Data
        Open p_tm13_ecpmdz For ' SELECT d.*, rap_reports_gen.get_revised_budget(p_projno => d.projno, p_costgrp => ''TM13''||:p_costgrp ) revised,
                            rap_reports_gen.get_actual_month_hours(p_yymm => :p_yymm, p_projno => d.projno, p_costgrp => ''TM13''||:p_costgrp ) month,
                            rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => d.projno, p_costgrp => ''TM13''||:p_costgrp ) year,
                            rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => d.projno, p_costgrp => ''TM13''||:p_costgrp ) +
                                rap_reports_gen.get_opening_hours(p_yearmode => :p_yearmode, p_projno => d.projno, p_costgrp => ''TM13''||:p_costgrp ) total,
                            rap_reports_gen.get_projected_hours_future(p_yymm => :p_yymm, p_projno => d.projno, p_costgrp => ''TM13''||:p_costgrp, p_noofmonths => 12) afterHours
                  FROM (
                        SELECT * FROM
                           ( SELECT
                                    Substr(p.projno, 1, 5) projno,
                                    p.newcostcode || '' '' || rap_reports_gen.get_costcode_desc(p.newcostcode) newcostcode_desc,
                                    p.tcmno,
                                    p.name,
                                    rap_reports_gen.get_job_type_tma_grp
                                        (final_tma_order(Substr(p.projno, 1, 5),
                                                         p.active,
                                                         p.projtype,
                                                         p.cdate,
                                                         :p_yymm,
                                                         to_date(rap_reports_gen.get_yymm_begin(:p_yymm,
                                                                        :p_yearmode), ''yyyymm'')-1,
                                                         p.revcdate)) AS tma_grp,
                                    pc.yymm,
                                    SUM(nvl(pc.hours, 0)) hours
                             FROM projmast p, rap_gtt_prjcmast pc
                             WHERE p.projno = pc.projno(+)
                                 AND (
                                        EXISTS (SELECT projno FROM rap_gtt_budgmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp = :p_costgrp AND a.projno = p.projno ) OR
                                        EXISTS (SELECT projno FROM rap_gtt_prjcmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp = :p_costgrp AND a.projno = p.projno AND to_number(yymm) > to_number(TRIM(:p_yymm))  ) OR
                                        EXISTS (SELECT projno FROM rap_gtt_openmast a, costmast b WHERE a.costcode = b.costcode AND b.tma_grp = :p_costgrp AND a.projno = p.projno ) OR
                                        EXISTS (SELECT projno FROM rap_gtt_timetran t, costmast b WHERE t.projno = p.projno
                                                    AND t.costcode = b.costcode AND b.tma_grp = :p_costgrp
                                                    AND to_number(t.yymm) >= to_number(rap_reports_gen.get_yymm_begin(:p_yymm, :p_yearmode))
                                                    AND to_number(t.yymm) <= to_number(TRIM(:p_yymm)))
                                     )
                                AND rap_reports_gen.get_projno_active_status(:p_yymm, :p_yearmode, p.active, p.cdate) = 1
                             GROUP BY
                                SUBSTR(p.projno, 1, 5),
                                p.newcostcode || '' '' || rap_reports_gen.get_costcode_desc(p.newcostcode),
                                p.tcmno,
                                p.name,
                                rap_reports_gen.get_job_type_tma_grp
                                    (final_tma_order(Substr(p.projno, 1, 5),
                                                     p.active,
                                                     p.projtype,
                                                     p.cdate,
                                                     :p_yymm,
                                                     to_date(rap_reports_gen.get_yymm_begin(:p_yymm,
                                                                    :p_yearmode), ''yyyymm'')-1,
                                                     p.revcdate)),
                                pc.yymm
                           )
                     Pivot
                     (
                         Sum(hours)
                         For yymm In ('
            || data_pivot_clause
            || ')
                     ) ) d
                 ORDER BY
                    tma_grp, newcostcode_desc, projno '
            Using p_costgrp, p_yymm, p_costgrp, p_yymm, p_yearmode, p_costgrp, p_yymm, p_yearmode, p_costgrp, p_yearmode,
            p_costgrp, p_yymm,
            p_costgrp, p_yymm, p_yymm, p_yearmode, p_costgrp, p_costgrp, p_yymm, p_costgrp, p_costgrp, p_yymm, p_yearmode,
            p_yymm, p_yymm,
            p_yearmode, p_yymm, p_yymm, p_yearmode;

    End;

    --TMA Summary (TMA Report & TMA Summary Report)
    Procedure get_tma_summary(
        p_yymm        In  Varchar2,
        p_yearmode    In  Varchar2,
        p_tma_summary Out Sys_Refcursor
    ) As
    Begin
        Open p_tma_summary For 'SELECT
                            MAX(p.newcostcode || '' '' || rap_reports_gen.get_costcode_desc(p.newcostcode)) newcostcode_desc,
                            MAX(SUBSTR(p.newcostcode, 1, 3) || '' '' || rap_reports_gen.get_tma_sub_grp(SUBSTR(p.newcostcode, 1, 3))) tma_sub_grp,
                            p.newcostcode || '' '' || rap_reports_gen.get_job_type_tma_grp
                                                    (final_tma_order(p.projno,
                                                                     p.active,
                                                                     p.projtype,
                                                                     p.cdate,
                                                                     :p_yymm,
                                                                     to_date(rap_reports_gen.get_yymm_begin(:p_yymm,
                                                                                    :p_yearmode), ''yyyymm'')-1,
                                                                     p.revcdate)) AS tma_grp,
                            SUM(rap_reports_gen.get_original_budget(p_projno => p.projno)) original,
                            SUM(rap_reports_gen.get_revised_budget(p_projno => p.projno)) revised,
                            SUM(rap_reports_gen.get_actual_month_hours(p_yymm => :p_yymm, p_projno => p.projno)) month,
                            SUM(rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno)) year,
                            SUM(rap_reports_gen.get_actual_year_hours(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno) +
                                rap_reports_gen.get_opening_hours(p_yearmode => :p_yearmode, p_projno => p.projno)) total,
                            SUM(rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 0)) etc_thisyear,
                            SUM(rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 1)) etc_nextyear,
                            SUM(rap_reports_b.get_projected_hours_yearwise(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_noofyear => 2)) etc_futureyears
                     FROM projmast p
                     WHERE
                         ( EXISTS (SELECT projno FROM rap_gtt_budgmast budgmast WHERE budgmast.projno = p.projno ) OR
                           EXISTS (SELECT projno FROM rap_gtt_prjcmast prjcmast WHERE prjcmast.projno = p.projno AND to_number(yymm) > to_number(TRIM(:p_yymm)) ) OR
                           EXISTS (SELECT projno FROM rap_gtt_openmast openmast WHERE openmast.projno = p.projno ) OR
                           EXISTS (SELECT projno FROM rap_gtt_timetran t WHERE t.projno = p.projno
                                        AND to_number(t.yymm) >= to_number(rap_reports_gen.get_yymm_begin(:p_yymm, :p_yearmode))
                                        AND to_number(t.yymm) <= to_number(TRIM(:p_yymm)))
                        )
                        AND rap_reports_gen.get_projno_active_status(:p_yymm, :p_yearmode, p.active, p.cdate) = 1
                     GROUP BY p.newcostcode || '' '' || rap_reports_gen.get_job_type_tma_grp
                                                       (final_tma_order(p.projno,
                                                                        p.active,
                                                                        p.projtype,
                                                                        p.cdate,
                                                                        :p_yymm,
                                                                        to_date(rap_reports_gen.get_yymm_begin(:p_yymm,
                                                                                    :p_yearmode), ''yyyymm'')-1,
                                                                        p.revcdate))
                     ORDER BY tma_grp, newcostcode_desc '
            Using p_yymm, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode, p_yymm, p_yearmode, p_yearmode, p_yymm, p_yearmode,
            p_yymm,
            p_yearmode, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode;

    End;

    --Generate Duplicate TM02
    Procedure rpt_dupl_tm02(
        p_activeyear       In  Varchar2,
        p_yymm             In  Varchar2,
        p_yearmode         In  Varchar2,
        p_costcode         In  Varchar2,
        p_cols             Out Sys_Refcursor,
        p_tm02             Out Sys_Refcursor,
        p_tm02_emptype_hrs Out Sys_Refcursor
    ) As

        data_pivot_clause    Varchar2(4000);
        heading_pivot_clause Varchar2(4000);
        noofmonths           Number := 12;
        yymm_end             Varchar2(6);
        n_month_hours        jobwise.nhrs%Type;
        p_insert_query       Varchar2(10000);
        p_success            Varchar2(2);
        p_message            Varchar2(1000);
    Begin
        Select
            Listagg('''' || heading || '''' || ' as ' || heading || '', ', ') Within
                Group (
                Order By
                    heading
                ),
            Listagg(yymm || ' as "' || heading || '"', ', ') Within
                Group (
                Order By
                    yymm
                )
        Into
            heading_pivot_clause,
            data_pivot_clause
        From
            (
                Select
                    yymm,
                    heading
                From
                    Table (rap_reports.rpt_month_cols(rap_reports_gen.get_yymm(p_yymm, 1), noofmonths))
            );

        -- Heading
        Open p_cols For 'SELECT * FROM (
                                        SELECT
                                            heading,
                                            yymm
                                        FROM
                                            TABLE( rap_reports.rpt_month_cols(rap_reports_gen.get_yymm(:p_yymm, 1),
                                                                                                         :noofmonths) )
                        ) Pivot ( max(yymm) For heading in ('
            || heading_pivot_clause
            || '))'
            Using p_yymm, noofmonths;

        --Load GTT
        rap_gtt.get_insert_query_4_gtt(p_activeyear, 'BUDGMAST', p_insert_query, p_success, p_message);
        Execute Immediate p_insert_query || ' where costcode = trim(:costcode)'
            Using p_costcode;
        rap_gtt.get_insert_query_4_gtt(p_activeyear, 'OPENMAST', p_insert_query, p_success, p_message);
        Execute Immediate p_insert_query || ' where costcode = trim(:costcode)'
            Using p_costcode;
        rap_gtt.get_insert_query_4_gtt(p_activeyear, 'PRJCMAST', p_insert_query, p_success, p_message);
        Execute Immediate p_insert_query || ' where costcode = trim(:costcode)'
            Using p_costcode;
        Commit;
        --Load GTT

        -- Data
        Open p_tm02 For 'Select * FROM ( SELECT
                                                p.projno projno,
                                                p.name,
                                                rap_reports_gen.get_job_type_tma_grp
                                                    (final_tma_order(p.projno,
                                                                     p.active,
                                                                     p.projtype,
                                                                     p.cdate,
                                                                     :p_yymm,
                                                                     to_date(rap_reports_gen.get_yymm_begin(:p_yymm,
                                                                                    :p_yearmode), ''yyyymm'')-1,
                                                                     p.revcdate)) AS tma_grp,
                                                rap_reports_gen.get_original_budget(p_projno => p.projno, p_costcode => :p_costcode) original,
                                                rap_reports_gen.get_revised_budget(p_projno => p.projno, p_costcode => :p_costcode) revised,
                                                rap_reports_gen.get_actual_month_hours_b_post(p_yymm => :p_yymm, p_projno => p.projno, p_costcode => :p_costcode) month,
                                                rap_reports_gen.get_actual_year_hours_b_post(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_costcode => :p_costcode) year,
                                                rap_reports_gen.get_actual_year_hours_b_post(p_yymm => :p_yymm, p_yearmode => :p_yearmode, p_projno => p.projno, p_costcode => :p_costcode) +
                                                    rap_reports_gen.get_opening_hours(p_yearmode => :p_yearmode, p_projno => p.projno, p_costcode => :p_costcode) total,
                                                rap_reports_gen.get_actual_month_hours_b_post(p_yymm => :p_yymm, p_projno => p.projno, p_costcode => :p_costcode) -
                                                    rap_reports_b.get_cc_proj_month_hours(:p_yymm, p.projno, :p_costcode) devtn,
                                                rap_reports_gen.get_projected_hours_future(p_yymm => :p_yymm, p_projno => p.projno, p_costcode => :p_costcode, p_noofmonths => 12) afterHours,
                                                pc.yymm,
                                                nvl(pc.hours, 0) hours,
                                                rap_reports_b.row_colour(p.tcm_jobs,p.reimb_job,p.highend,p.typeofjob) as row_colour,
                                                nvl(p.tcm_jobs, 0) tcm_jobs
                                         FROM
                                             projmast p,
                                             rap_gtt_prjcmast pc
                                         WHERE p.projno = pc.projno(+)
                                             AND pc.costcode(+) = TRIM(:p_costcode)
                                             AND ( EXISTS (SELECT projno
                                                                FROM rap_gtt_budgmast budgmast
                                                                WHERE budgmast.costcode = TRIM(:p_costcode)
                                                                    AND budgmast.projno = p.projno ) OR
                                                   EXISTS (SELECT projno
                                                                FROM rap_gtt_prjcmast prjcmast
                                                                WHERE prjcmast.costcode = TRIM(:p_costcode)
                                                                    AND prjcmast.projno = p.projno
                                                                    AND to_number(yymm) > to_number(TRIM(:p_yymm))  ) OR
                                                   EXISTS (SELECT projno
                                                                FROM rap_gtt_openmast openmast
                                                                WHERE openmast.costcode = TRIM(:p_costcode)
                                                                    AND openmast.projno = p.projno ) OR
                                                   EXISTS (SELECT projno
                                                                FROM jobwise t
                                                                WHERE t.assign = TRIM(:p_costcode)
                                                                   AND t.projno = p.projno
                                                                   AND to_number(t.yymm) >= to_number(rap_reports_gen.get_yymm_begin(:p_yymm, :p_yearmode))
                                                                   AND to_number(t.yymm) <= to_number(TRIM(:p_yymm)))
                                                )
                                            AND rap_reports_gen.get_projno_active_status(:p_yymm, :p_yearmode, p.active, p.cdate) = 1
                                           )
                         Pivot
                         (
                             SUM(hours)
                             For yymm In ('
            || data_pivot_clause
            || ')
                         )
                         ORDER BY tma_grp, projno '
            Using p_yymm, p_yymm, p_yearmode, p_costcode, p_costcode, p_yymm, p_costcode, p_yymm, p_yearmode, p_costcode,
            p_yymm, p_yearmode,
            p_costcode, p_yearmode, p_costcode, p_yymm, p_costcode, p_yymm, p_costcode, p_yymm, p_costcode, p_costcode, p_costcode,
            p_costcode,
            p_yymm, p_costcode, p_costcode, p_yymm, p_yearmode, p_yymm, p_yymm, p_yearmode;

        --Summary Emp Type & Hours

        Open p_tm02_emptype_hrs For
            Select
                Case e.emptype
                    When 'R' Then
                        'TCMPL Personnel'
                    When 'C' Then
                        'Consultants'
                    When 'S' Then
                        'SubContract'
                    When 'F' Then
                        'FTC'
                    Else
                        'Not Defined'
                End                                  emptype,
                Sum(nvl(t.nhrs, 0) + nvl(t.ohrs, 0)) As tothrs
            From
                jobwise  t,
                emplmast e
            Where
                e.empno      = t.empno
                And t.yymm   = Trim(p_yymm)
                And t.assign = Trim(p_costcode)
            Group By
                Case e.emptype
                    When 'R' Then
                        'TCMPL Personnel'
                    When 'C' Then
                        'Consultants'
                    When 'S' Then
                        'SubContract'
                    When 'F' Then
                        'FTC'
                    Else
                        'Not Defined'
                End;

    End;

    -- Generate Cha1Sta6TM02
    Procedure rpt_cha1sta6tm02(
        p_activeyear         In  Varchar2,
        p_yymm               In  Varchar2,
        p_yearmode           In  Varchar2,
        p_costcode           In  Varchar2,
        p_reportmode         In  Varchar2,
        p_sta6               Out Sys_Refcursor,
        p_sta6_not_submitted Out Sys_Refcursor,
        p_sta6_odd           Out Sys_Refcursor,
        p_sta6_1             Out Sys_Refcursor,
        p_sta6_2             Out Sys_Refcursor,
        p_cols_tm02          Out Sys_Refcursor,
        p_tm02               Out Sys_Refcursor,
        p_tm02_emptype_hrs   Out Sys_Refcursor,
        p_tm02_1_emptype_hrs Out Sys_Refcursor,
        p_cols_act01         Out Sys_Refcursor,
        p_act01              Out Sys_Refcursor
    ) As
        p_insert_query Varchar2(10000);
        p_success      Varchar2(2);
        p_message      Varchar2(1000);
    Begin
        --Load GTT
        If p_reportmode = 'COMBINED' Then
            rap_gtt.get_insert_query_4_gtt(p_activeyear, 'BUDGMAST', p_insert_query, p_success, p_message);
            If p_success = 'OK' Then
                Execute Immediate p_insert_query || ' where costcode In ( Select cgc.costcode From rap_costcode_group cg, rap_costcode_group_costcodes cgc Where cg.group_id = cgc.group_id And cg.costcode = trim(:costcode) )'
                    Using p_costcode;
                rap_gtt.get_insert_query_4_gtt(p_activeyear, 'OPENMAST', p_insert_query, p_success, p_message);
                If p_success = 'OK' Then
                    Execute Immediate p_insert_query || ' where costcode In ( Select cgc.costcode From rap_costcode_group cg, rap_costcode_group_costcodes cgc Where cg.group_id = cgc.group_id And cg.costcode = trim(:costcode) )'
                        Using p_costcode;
                    rap_gtt.get_insert_query_4_gtt(p_activeyear, 'TIMETRAN', p_insert_query, p_success, p_message);
                    If p_success = 'OK' Then
                        Execute Immediate p_insert_query || ' where costcode In ( Select cgc.costcode From rap_costcode_group cg, rap_costcode_group_costcodes cgc Where cg.group_id = cgc.group_id And cg.costcode = trim(:costcode) ) '
                            Using p_costcode;
                        rap_gtt.get_insert_query_4_gtt(p_activeyear, 'PRJCMAST', p_insert_query, p_success, p_message);
                        If p_success = 'OK' Then
                            Execute Immediate p_insert_query || ' where costcode In ( Select cgc.costcode From rap_costcode_group cg, rap_costcode_group_costcodes cgc Where cg.group_id = cgc.group_id And cg.costcode = trim(:costcode) )'
                                Using p_costcode;
                            Commit;

                            --update to group costcode         
                            Update rap_gtt_budgmast Set costcode = Trim(p_costcode) Where costcode != Trim(p_costcode);
                            Update rap_gtt_openmast Set costcode = Trim(p_costcode) Where costcode != Trim(p_costcode);
                            Update rap_gtt_timetran Set costcode = Trim(p_costcode) Where costcode != Trim(p_costcode);                        
                            Update rap_gtt_prjcmast Set costcode = Trim(p_costcode) Where costcode != Trim(p_costcode);

                            --Load GTT
                            get_sta6(p_yymm, p_costcode, p_sta6, p_sta6_not_submitted, p_sta6_odd,
                                     p_sta6_1, p_sta6_2);                                                                                            
                            get_tm02(p_yymm, p_yearmode, p_costcode, p_cols_tm02, p_tm02,
                                     p_tm02_emptype_hrs, p_tm02_1_emptype_hrs);
                            get_act01(p_yymm, p_yearmode, p_costcode, p_cols_act01, p_act01);
                        End If;
    
                    End If;
    
                End If;
    
            End If;
        Else        
            rap_gtt.get_insert_query_4_gtt(p_activeyear, 'BUDGMAST', p_insert_query, p_success, p_message);
            If p_success = 'OK' Then
                Execute Immediate p_insert_query || ' where costcode = trim(:costcode)'
                    Using p_costcode;
                rap_gtt.get_insert_query_4_gtt(p_activeyear, 'OPENMAST', p_insert_query, p_success, p_message);
                If p_success = 'OK' Then
                    Execute Immediate p_insert_query || ' where costcode = trim(:costcode)'
                        Using p_costcode;
                    rap_gtt.get_insert_query_4_gtt(p_activeyear, 'TIMETRAN', p_insert_query, p_success, p_message);
                    If p_success = 'OK' Then
                        Execute Immediate p_insert_query || ' where costcode = trim(:costcode) or parent = trim(:costcode)'
                            Using p_costcode, p_costcode;
                        rap_gtt.get_insert_query_4_gtt(p_activeyear, 'PRJCMAST', p_insert_query, p_success, p_message);
                        If p_success = 'OK' Then
                            Execute Immediate p_insert_query || ' where costcode = trim(:costcode)'
                                Using p_costcode;
                            Commit;
                            --Load GTT
                            get_sta6(p_yymm, p_costcode, p_sta6, p_sta6_not_submitted, p_sta6_odd,
                                     p_sta6_1, p_sta6_2);
                            get_tm02(p_yymm, p_yearmode, p_costcode, p_cols_tm02, p_tm02,
                                     p_tm02_emptype_hrs, p_tm02_1_emptype_hrs);
                            get_act01(p_yymm, p_yearmode, p_costcode, p_cols_act01, p_act01);
                        End If;
    
                    End If;
    
                End If;
    
            End If;
            
        End If;
    End rpt_cha1sta6tm02;

    --GET COST CODES FOR CHA1STA6TM02 ALL DEPTS DOWNLOAD BY PROCO
    Procedure get_rpt_costcodes(
        p_result Out Sys_Refcursor
    ) As
    Begin
        Open p_result For
            Select
                costcode
            From
                costmast
            Where
                activity = 1
                And costcode Like '02%'
            Order By
                costcode;

    End get_rpt_costcodes;

    -- Generate TMA Report & TMA Summary Report
    Procedure rpt_tma(
        p_activeyear  In  Varchar2,
        p_yymm        In  Varchar2,
        p_yearmode    In  Varchar2,
        p_report_type In  Varchar2,
        p_tma         Out Sys_Refcursor,
        p_tma_t       Out Sys_Refcursor,
        p_tma_e       Out Sys_Refcursor,
        p_tma_d       Out Sys_Refcursor,
        p_tma_n       Out Sys_Refcursor,
        p_tma_o       Out Sys_Refcursor,
        p_cols        Out Sys_Refcursor,
        p_tm13        Out Sys_Refcursor,
        p_tm13_e      Out Sys_Refcursor,
        p_tm13_c      Out Sys_Refcursor,
        p_tm13_p      Out Sys_Refcursor,
        p_tm13_m      Out Sys_Refcursor,
        p_tm13_d      Out Sys_Refcursor,
        p_tm13_z      Out Sys_Refcursor,
        p_tma_summary Out Sys_Refcursor
    ) As

        p_data_pivot_clause Varchar2(4000);
        p_insert_query      Varchar2(10000);
        p_success           Varchar2(2);
        p_message           Varchar2(1000);
    Begin
        --Load GTT
        rap_gtt.get_insert_query_4_gtt(p_activeyear, 'BUDGMAST', p_insert_query, p_success, p_message);
        If p_success = 'OK' Then
            Execute Immediate p_insert_query;
            rap_gtt.get_insert_query_4_gtt(p_activeyear, 'OPENMAST', p_insert_query, p_success, p_message);
            If p_success = 'OK' Then
                Execute Immediate p_insert_query;
                rap_gtt.get_insert_query_4_gtt(p_activeyear, 'TIMETRAN', p_insert_query, p_success, p_message);
                If p_success = 'OK' Then
                    Execute Immediate p_insert_query; -- || ' where yymm <= trim(:yymm)' Using p_yymm;
                    rap_gtt.get_insert_query_4_gtt(p_activeyear, 'PRJCMAST', p_insert_query, p_success, p_message);
                    If p_success = 'OK' Then
                        Execute Immediate p_insert_query;
                        Commit;
                        --Load GTT
                        If p_report_type = 'D' Then
                            get_tma(p_yymm, p_yearmode, p_tma);
                            get_tma_t(p_yymm, p_yearmode, p_tma_t);
                            get_tma_e_d(p_yymm, p_yearmode, 'E', p_tma_e);
                            get_tma_e_d(p_yymm, p_yearmode, 'D', p_tma_d);
                            get_tma_n(p_yymm, p_yearmode, p_tma_n);
                            get_tma_o(p_yymm, p_yearmode, p_tma_o);
                            get_tm13(p_yymm, p_yearmode, p_data_pivot_clause, p_cols, p_tm13);
                            get_tm13_ecpmdz(p_yymm, p_yearmode, 'E', p_data_pivot_clause, p_tm13_e);
                            get_tm13_ecpmdz(p_yymm, p_yearmode, 'C', p_data_pivot_clause, p_tm13_c);
                            get_tm13_ecpmdz(p_yymm, p_yearmode, 'P', p_data_pivot_clause, p_tm13_p);
                            get_tm13_ecpmdz(p_yymm, p_yearmode, 'M', p_data_pivot_clause, p_tm13_m);
                            get_tm13_ecpmdz(p_yymm, p_yearmode, 'D', p_data_pivot_clause, p_tm13_d);
                            get_tm13_ecpmdz(p_yymm, p_yearmode, 'Z', p_data_pivot_clause, p_tm13_z);
                        Elsif p_report_type = 'S' Then
                            get_tma_summ(p_yymm, p_yearmode, p_tma);
                            get_tma_t_summ(p_yymm, p_yearmode, p_tma_t);
                            get_tma_e_d_summ(p_yymm, p_yearmode, 'E', p_tma_e);
                            get_tma_e_d_summ(p_yymm, p_yearmode, 'D', p_tma_d);
                            get_tma_n_summ(p_yymm, p_yearmode, p_tma_n);
                            get_tma_o_summ(p_yymm, p_yearmode, p_tma_o);
                            get_tm13_summ(p_yymm, p_yearmode, p_data_pivot_clause, p_cols, p_tm13);
                            get_tm13_ecpmdz_summ(p_yymm, p_yearmode, 'E', p_data_pivot_clause, p_tm13_e);
                            get_tm13_ecpmdz_summ(p_yymm, p_yearmode, 'C', p_data_pivot_clause, p_tm13_c);
                            get_tm13_ecpmdz_summ(p_yymm, p_yearmode, 'P', p_data_pivot_clause, p_tm13_p);
                            get_tm13_ecpmdz_summ(p_yymm, p_yearmode, 'M', p_data_pivot_clause, p_tm13_m);
                            get_tm13_ecpmdz_summ(p_yymm, p_yearmode, 'D', p_data_pivot_clause, p_tm13_d);
                            get_tm13_ecpmdz_summ(p_yymm, p_yearmode, 'Z', p_data_pivot_clause, p_tm13_z);
                        End If;

                        get_tma_summary(p_yymm, p_yearmode, p_tma_summary);
                    End If;

                End If;

            End If;

        End If;

    End rpt_tma;

    --load gtt for timetran
    Procedure load_gtt_timetran(
        p_activeyear In  Varchar2,
        p_yymm       In  Varchar2,
        p_costcode   In  Varchar2,
        p_success    Out Varchar2,
        p_message    Out Varchar2
    ) As
        p_insert_query Varchar2(10000);
    Begin
        rap_gtt.get_insert_query_4_gtt(p_activeyear, 'TIMETRAN', p_insert_query, p_success, p_message);
        If p_success = 'OK' Then
            Execute Immediate p_insert_query || ' where yymm = trim(:yymm) and costcode = trim(:costcode)'
                Using p_yymm, p_costcode;
        End If;

    End load_gtt_timetran;


End rap_reports_b;