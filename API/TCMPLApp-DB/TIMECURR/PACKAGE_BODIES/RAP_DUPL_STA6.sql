--------------------------------------------------------
--  DDL for Package Body RAP_DUPL_STA6
--------------------------------------------------------

create or replace Package Body "TIMECURR"."RAP_DUPL_STA6" As
   
   -- Generate Dupl sta6
    Procedure rpt_dupl_sta6 (        
        p_yymm               In Varchar2,
        p_costcode           In Varchar2,
        p_sta6               Out Sys_Refcursor,
        p_sta6_not_submitted Out Sys_Refcursor,
        p_sta6_odd           Out Sys_Refcursor,
        p_sta6_1             Out Sys_Refcursor,
        p_sta6_2             Out Sys_Refcursor
    ) As
        p_insert_query Varchar2(10000);
        p_success      Varchar2(2);
        p_message      Varchar2(1000);
    Begin       
        get_sta6(p_yymm, p_costcode, p_sta6, p_sta6_not_submitted, p_sta6_odd,
                p_sta6_1, p_sta6_2);
    End rpt_dupl_sta6;

    --STA6    
    Procedure get_sta6 (
        p_yymm               In Varchar2,
        p_costcode           In Varchar2,
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
                                null as reasoncode,
                                t.projno,
                                p.tcmno,
                                e.empno,
                                CASE t.empno
                                    WHEN LAG(t.empno, 1, 0) OVER(
                                        ORDER BY
                                            t.empno, t.projno, t.wpcode,
                                            t.activity
                                    ) THEN
                                        NULL
                                    ELSE
                                        t.empno
                                END AS calcEmpno,                                
                                CASE e.name
                                    WHEN LAG(e.name, 1, 0) OVER(
                                        ORDER BY
                                            t.empno, t.projno, t.wpcode,
                                            t.activity
                                    ) THEN
                                        NULL
                                    ELSE
                                        e.name
                                END AS calcName,
                                t.hours,
                                t.othours,
                                rap_dupl_sta6.get_total_hours(t.yymm, t.assign, t.projno, t.wpcode, t.activity, t.empno) calctotalhours,
                                nvl(t.hours,0)+nvl(t.othours,0) totalhours  
                        FROM 
                            jobwise_dupl_sta6   t, 
                            emplmast            e, 
                            projmast            p
                        WHERE 
                                t.assign = TRIM(:p_costcode)
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
                            t.empno, t.projno, t.wpcode, t.activity'
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
                                                           FROM jobwise_dupl_sta6 t 
                                                           WHERE t.yymm = TRIM(:p_yymm) 
                                                               AND t.empno = e.empno ) 
                                           AND e.emptype In (SELECT
                                                                emptype
                                                            FROM
                                                                emptypemast
                                                            WHERE
                                                                nvl(tm, 0) = 1)  
                                       ORDER BY 
                                            e.empno '
            Using p_costcode, p_yymm;

        Open p_sta6_odd For 'SELECT null srno, 
                                    a.assign,                                           
                                    a.empno,
                                    b.name,                                             
                                    Sum(nvl(a.hours, 0)) as hours, 
                                    Sum(nvl(a.othours,0)) as othours
                             FROM 
                                jobwise_dupl_sta6 a, 
                                emplmast            b 
                             WHERE 
                                    a.empno = b.empno 
                                 AND a.parent = TRIM(:p_costcode) 
                                 AND b.submit = 1 
                                 AND b.status = 1 
                                 AND a.assign <> TRIM(:p_costcode) 
                                 AND a.yymm = TRIM(:p_yymm)  
                                 AND b.emptype In (SELECT
                                                        emptype
                                                    FROM
                                                        emptypemast
                                                    WHERE
                                                        nvl(tm, 0) = 1)  
                            GROUP BY 
                                a.empno, b.name, a.assign 
                            ORDER BY 
                                a.empno '
            Using p_costcode, p_costcode, p_yymm;

        Open p_sta6_1 For 'SELECT null as srno,
                                  t.wpcode,
                                  t.activity,
                                  null as reasoncode,
                                  t.projno,
                                  p.tcmno,
                                  e.empno,
                                  CASE t.empno
                                    WHEN LAG(t.empno, 1, 0) OVER(
                                        ORDER BY
                                            t.empno, t.projno, t.wpcode,
                                            t.activity
                                    ) THEN
                                        NULL
                                    ELSE
                                        t.empno
                                  END AS calcEmpno,                                 
                                  CASE e.name
                                     WHEN LAG(e.name, 1, 0) OVER(
                                         ORDER BY
                                             t.empno, t.projno, t.wpcode,
                                             t.activity
                                      ) THEN
                                          NULL
                                      ELSE
                                          e.name
                                  END AS calcName,                              
                                  t.hours,
                                  t.othours,
                                  rap_dupl_sta6.get_total_hours(t.yymm, t.assign, t.projno, t.wpcode, t.activity, t.empno) calctotalhours,
                                  nvl(t.hours,0)+nvl(t.othours,0) totalhours  
                          FROM 
                               jobwise_dupl_sta6   t, 
                               emplmast            e, 
                               projmast            p 
                          WHERE 
                                t.assign = TRIM(:p_costcode)
                            AND t.yymm = TRIM(:p_yymm)
                            AND nvl(p.tcm_jobs, 0) = 1
                            AND t.empno = e.empno
                            AND t.projno = p.projno
                          ORDER BY 
                            t.empno, t.projno, t.wpcode, t.activity '
            Using p_costcode, p_yymm;

        Open p_sta6_2 For 'SELECT null as srno,
                                  t.wpcode,
                                  t.activity,
                                  null as reasoncode,
                                  t.projno,
                                  p.tcmno,
                                  e.empno,
                                  CASE t.empno
                                    WHEN LAG(t.empno, 1, 0) OVER(
                                        ORDER BY
                                            t.empno, t.projno, t.wpcode,
                                            t.activity
                                    ) THEN
                                        NULL
                                    ELSE
                                        t.empno
                                  END AS calcEmpno,                                  
                                  CASE e.name
                                     WHEN LAG(e.name, 1, 0) OVER(
                                         ORDER BY
                                             t.empno, t.projno, t.wpcode,
                                             t.activity
                                      ) THEN
                                          NULL
                                      ELSE
                                          e.name
                                  END AS calcName, 
                                  t.hours,
                                  t.othours,
                                  rap_dupl_sta6.get_total_hours(t.yymm, t.assign, t.projno, t.wpcode, t.activity, t.empno) calctotalhours,
                                  nvl(t.hours,0)+nvl(t.othours,0) totalhours  
                          FROM 
                            jobwise_dupl_sta6   t, 
                            emplmast            e, 
                            projmast            p 
                          WHERE 
                                t.assign = TRIM(:p_costcode)
                            AND t.yymm = TRIM(:p_yymm)
                            AND nvl(p.tcm_jobs, 0) = 0
                            AND t.empno = e.empno
                            AND t.projno = p.projno
                        ORDER BY 
                            t.empno, t.projno, t.wpcode, t.activity '
            Using p_costcode, p_yymm;

    End;    

    Function get_total_hours (
        p_yymm       In Varchar2,
        p_costcode   In Varchar2,
        p_projno     In Varchar2,
        p_wpcode     In Varchar2,
        p_activity   In Varchar2,
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
                    jobwise_dupl_sta6
                Where
                        projno = Trim(p_projno)
                    And empno = Trim(p_empno)
                    And yymm = Trim(p_yymm)
                    And assign = Trim(p_costcode)
                Order By
                    wpcode Desc,
                    activity Desc
            )
        Where
            Rownum = 1;

        If
            p_activity = v_activity
            And p_wpcode = v_wpcode
        Then
            Select
                Sum(nvl(hours, 0) + nvl(othours, 0)) totalhours
            Into n_total_hours
            From
                jobwise_dupl_sta6
            Where
                    projno = Trim(p_projno)
                And empno = Trim(p_empno)
                And yymm = Trim(p_yymm)
                And assign = Trim(p_costcode);

            Return n_total_hours;
        Else
            Return Null;
        End If;

    Exception
        When Others Then
            Return 0;
    End;

End rap_dupl_sta6;