Create Or Replace Package Body "TIMECURR"."RAP_CHA1E_COMBINE" As

    Procedure rpt_cha1_expt(p_timesheet_yyyy In  Varchar2,
                            p_yymm           In  Varchar2,
                            p_costcode       In  Varchar2,
                            p_reportmode     In  Varchar2,
                            p_cols           Out Sys_Refcursor,
                            p_gen            Out Sys_Refcursor,
                            p_gen_other      Out Sys_Refcursor,
                            p_alldata        Out Sys_Refcursor,
                            p_ot             Out Sys_Refcursor,
                            p_project        Out Sys_Refcursor,
                            p_future         Out Sys_Refcursor,
                            p_subcont        Out Sys_Refcursor) As
        pivot_clause     Varchar2(4000);
        aggregate_clause Varchar2(4000);
        noofmonths       Number;
        p_batch_key_id   Varchar2(8);
        p_insert_query   Varchar2(10000);
        p_success        Varchar2(2);
        p_message        Varchar2(4000);
        v_new_yymm       Varchar2(6);
        v_costcode       rap_costcode_group_costcodes.costcode%Type;
    Begin
        noofmonths := 18;
        Select
            to_char(add_months(To_Date(p_yymm, 'yyyymm'), 1), 'yyyymm')
        Into
            v_new_yymm
        From
            dual;

        Select
            substr(sys_guid(), 0, 8)
        Into
            p_batch_key_id
        From
            dual;

        If p_reportmode = 'COMBINED' Then
            Begin
                Select
                    cgc.costcode
                Into
                    v_costcode
                From
                    rap_costcode_group           cg,
                    rap_costcode_group_costcodes cgc
                Where
                    cg.group_id     = cgc.group_id
                    And cgc.costcode != Trim(p_costcode)
                    And cg.costcode = Trim(p_costcode);
            Exception
                When no_data_found Then
                    v_costcode := p_costcode;
            End;
        Else
            v_costcode := p_costcode;
        End If;
            
        -- Populate GTT tbales ---------------------------------------------------
        If p_reportmode = 'COMBINED' Then
            rap_gtt.get_insert_query_4_gtt(p_timesheet_yyyy, 'MOVEMAST', p_insert_query, p_success, p_message);
            If p_success = 'OK' Then
                For i In 1..noofmonths
                Loop
                    Insert Into rap_gtt_movemast
                    Select
                        p_costcode, to_char(add_months(To_Date(p_yymm, 'yyyymm'), i), 'yyyymm'), 0, 0, 0, 0, 0, 0, 0, 0, p_batch_key_id
                    From
                        dual
                    Where
                        (p_costcode, to_char(add_months(To_Date(p_yymm, 'yyyymm'), i), 'yyyymm')) Not In
                        (
                            Select
                                costcode, yymm
                            From
                                movemast

                            Where
                                costcode In (
                                    Select
                                        cgc.costcode
                                    From
                                        rap_costcode_group           cg,
                                        rap_costcode_group_costcodes cgc
                                    Where
                                        cg.group_id     = cgc.group_id
                                        And cg.costcode = Trim(p_costcode)
                                )
                        );
                End Loop;

                Execute Immediate p_insert_query || '  where costcode  in (
                                    Select
                                        cgc.costcode
                                    From
                                        rap_costcode_group           cg,
                                        rap_costcode_group_costcodes cgc
                                    Where
                                        cg.group_id     = cgc.group_id
                                        And cg.costcode = Trim(:costcode)
                                ) and yymm > :yymm ' Using p_batch_key_id,
                p_costcode, p_yymm;

                rap_gtt.get_insert_query_4_gtt(p_timesheet_yyyy, 'EXPTPRJC', p_insert_query, p_success, p_message);
                If p_success = 'OK' Then
                    Execute Immediate p_insert_query || ' where costcode  in (
                                    Select
                                        cgc.costcode
                                    From
                                        rap_costcode_group           cg,
                                        rap_costcode_group_costcodes cgc
                                    Where
                                        cg.group_id     = cgc.group_id
                                        And cg.costcode = Trim(:costcode)
                                ) and yymm > :yymm ' Using p_costcode,
                    p_yymm;

                    rap_gtt.get_insert_query_4_gtt(p_timesheet_yyyy, 'PRJCMAST', p_insert_query, p_success, p_message);
                    If p_success = 'OK' Then
                        Execute Immediate p_insert_query || '  where costcode  in (
                                    Select
                                        cgc.costcode
                                    From
                                        rap_costcode_group           cg,
                                        rap_costcode_group_costcodes cgc
                                    Where
                                        cg.group_id     = cgc.group_id
                                        And cg.costcode = Trim(:costcode)
                                )  and yymm > :yymm ' Using p_costcode,
                        p_yymm;
                    
                        --update to group costcode         
                        Update
                            rap_gtt_movemast
                        Set
                            costcode = Trim(p_costcode)
                        Where
                            costcode != Trim(p_costcode);

                        Update
                            rap_gtt_exptprjc
                        Set
                            costcode = Trim(p_costcode)
                        Where
                            costcode != Trim(p_costcode);

                        Update
                            rap_gtt_prjcmast
                        Set
                            costcode = Trim(p_costcode)
                        Where
                            costcode != Trim(p_costcode);

                        Commit;
                    End If;
                End If;
            End If;
        Else
            rap_gtt.get_insert_query_4_gtt(p_timesheet_yyyy, 'MOVEMAST', p_insert_query, p_success, p_message);
            If p_success = 'OK' Then
                For i In 1..noofmonths
                Loop
                    Insert Into rap_gtt_movemast
                    Select
                        p_costcode, to_char(add_months(To_Date(p_yymm, 'yyyymm'), i), 'yyyymm'), 0, 0, 0, 0, 0, 0, 0, 0, p_batch_key_id
                    From
                        dual
                    Where
                        (p_costcode, to_char(add_months(To_Date(p_yymm, 'yyyymm'), i), 'yyyymm')) Not In
                        (
                            Select
                                costcode, yymm
                            From
                                movemast
                        );
                End Loop;
                Execute Immediate p_insert_query || ' where costcode = trim(:costcode) and yymm > :yymm ' Using p_batch_key_id,
                p_costcode, p_yymm;
                rap_gtt.get_insert_query_4_gtt(p_timesheet_yyyy, 'EXPTPRJC', p_insert_query, p_success, p_message);
                If p_success = 'OK' Then
                    Execute Immediate p_insert_query || ' where costcode = trim(:costcode) and yymm > :yymm ' Using p_costcode,
                    p_yymm;
                    rap_gtt.get_insert_query_4_gtt(p_timesheet_yyyy, 'PRJCMAST', p_insert_query, p_success, p_message);
                    If p_success = 'OK' Then
                        Execute Immediate p_insert_query || ' where costcode = trim(:costcode) and yymm > :yymm ' Using p_costcode,
                        p_yymm;
                        Commit;
                    End If;
                End If;
            End If;
        End If; 
                  
        -- Populate GTT tables end ---------------------------------------------------   
        
        Insert Into rap_gtt_movemast_combined
        Select
            costcode,
            yymm,
            Sum(nvl(movement, 0)),
            Sum(nvl(movetotcm, 0)),
            Sum(nvl(movetosite, 0)),
            Sum(nvl(movetoothers, 0)),
            Sum(nvl(ext_subcontract, 0)),
            Sum(nvl(fut_recruit, 0)),
            Sum(nvl(int_dept, 0)),
            Sum(nvl(hrs_subcont, 0)),
            batch_key_id
        From
            rap_gtt_movemast
        Where
            batch_key_id = p_batch_key_id
        Group By
            costcode, yymm, batch_key_id;
        Commit;
        
        Select
            Listagg(yymm || ' as "' || heading || '"', ', ') Within
                Group (Order By
                    yymm)
        Into
            pivot_clause
        From
            (
                Select
                    yymm, heading
                From
                    Table(rap_reports.rpt_month_cols(v_new_yymm, noofmonths))
            );

        Select
            Listagg(' sum(' || heading || ') as "' || heading || '"', ', ') Within
                Group (Order By
                    yymm)
        Into
            aggregate_clause
        From
            (
                Select
                    yymm, heading
                From
                    Table(rap_reports.rpt_month_cols(v_new_yymm, noofmonths))
            );

        Open p_gen For
            'Select a.costcode, a.abbr, sum(nvl(a.noofemps,0)) AS noofemps,
                     sum(decode(nvl(a.changed_nemps,0),0,nvl(a.noofemps,0),nvl(a.changed_nemps,0))) as changed_nemps,
                     initcap(b.name) name, to_char(sysdate, ''dd-Mon-yyyy'') pdate,
                     sum(nvl(a.noofcons,0)) as noofcons from costmast a, emplmast b
                   where a.hod = b.empno and costcode = :p_costcode group by a.costcode, a.abbr, b.name'
            Using p_costcode;

        Open p_gen_other For
            'Select a.costcode, a.abbr, sum(nvl(a.noofemps,0)) AS noofemps,
                     sum(decode(nvl(a.changed_nemps,0),0,nvl(a.noofemps,0),nvl(a.changed_nemps,0))) as changed_nemps,
                     initcap(b.name) name, to_char(sysdate, ''dd-Mon-yyyy'') pdate,
                     sum(nvl(a.noofcons,0)) as noofcons from costmast a, emplmast b
                   where a.hod = b.empno and costcode = :p_costcode group by a.costcode, a.abbr, b.name'
            Using v_costcode;
            
        -- Column names --------------------------------------------------------
        Open p_cols For
            'select * from (
                      select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths))
                    ) pivot (max(yymm) for yymm in (' || pivot_clause || '))'
            Using v_new_yymm, noofmonths;

        -- All Data  --------------------------------------------------
        Open p_alldata For
            'select * from (
                      select yymm, name, last_value(working_hr) ignore nulls over (
                        order by yymm rows between unbounded preceding and current row) working_hr from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                         t_data as ( select yymm, working_hr  from raphours where yymm > :p_yymm order by yymm )
                      select a.yymm, ''a'' as Name, b.working_hr from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm )
                    ) pivot (sum(working_hr) for yymm in (' || pivot_clause || '))
                    union
                    select * from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                         t_data as ( select yymm,  sum(nvl(fut_recruit,0)) over(partition by costcode order by yymm) fut_recruit from rap_gtt_movemast_combined
                         where costcode = :p_costcode and yymm > :p_yymm order by yymm )
                      select a.yymm, ''b'' as Name, b.fut_recruit from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(fut_recruit) for yymm in (' ||
            pivot_clause || '))
                    union
                    select * from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                         t_data as ( select yymm, nvl(int_dept,0) int_dept from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
                      select a.yymm, ''c'' as Name, b.int_dept from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(int_dept) for yymm in (' || pivot_clause || '))
                    union
                    select * from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                         t_data as ( select yymm, nvl(movetotcm,0) movetotcm from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
                      select a.yymm, ''d'' as Name, b.movetotcm from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(movetotcm) for yymm in (' ||
            pivot_clause || '))
                    union
                    select * from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                         t_data as ( select yymm, nvl(movetosite,0) movetosite from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
                      select a.yymm, ''e'' as Name, b.movetosite from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(movetosite) for yymm in (' || pivot_clause || '))
                    union
                    select * from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                         t_data as ( select yymm, nvl(movetoothers,0) movetoothers from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
                      select a.yymm, ''f'' as Name, b.movetoothers from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(movetoothers) for yymm in (' ||
            pivot_clause || '))
                    union
                    select * from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                         t_data as ( select yymm, nvl(ext_subcontract,0) ext_subcontract from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
                      select a.yymm, ''g'' as Name, b.ext_subcontract from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(ext_subcontract) for yymm in (' || pivot_clause ||
            ')) '
            Using v_new_yymm, noofmonths, p_yymm,
            v_new_yymm, noofmonths, p_costcode, p_yymm,
            v_new_yymm, noofmonths, p_costcode, p_yymm,
            v_new_yymm, noofmonths, p_costcode, p_yymm,
            v_new_yymm, noofmonths, p_costcode, p_yymm,
            v_new_yymm, noofmonths, p_costcode, p_yymm,
            v_new_yymm, noofmonths, p_costcode, p_yymm;

        -- Overtime ------------------------------------------------------------
        Open p_ot For             
            'select * from (
                    with t_yymm as (
                      select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths))
                    ),
                    t_data as (
                      select yymm, ot from otmast Where ((costcode = :p_costcode And :p_reportmode = ''SINGLE'') OR
                                (costcode In (
                                    Select
                                        cgc.costcode
                                    From
                                        rap_costcode_group           cg,
                                        rap_costcode_group_costcodes cgc
                                    Where
                                        cg.group_id     = cgc.group_id
                                        And cg.costcode = Trim(:p_costcode) And :p_reportmode = ''COMBINED''
                                ))) 
                            and yymm > :p_yymm order by yymm
                    )
                    select a.yymm, b.ot from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                  ) pivot (sum(ot) for yymm in (' || pivot_clause || '))'
            Using v_new_yymm, noofmonths, p_costcode, p_reportmode, p_costcode, p_reportmode, p_yymm; 

        -- Projects ------------------------------------------------------------
        Open p_project For
            'select * from
                    (select newcostcode||''-''||rap_reports_gen.get_costcode_desc(newcostcode) newcostcode,
                    projno,
                    rap_reports_gen.get_proj_name(projno) name, rap_reports_gen.get_proj_cdate(projno) cdate,
                    rap_reports_gen.get_proj_tcmno(projno) tcmno, ' || aggregate_clause || ', rap_reports_gen.get_proj_active(projno) active from (
                    with t_yymm as (
                      select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths))
                    ),
                    t_data as (
                      select a.projno, a.yymm, nvl(a.hours,0) as hrs from rap_gtt_prjcmast a, projmast b where a.projno = b.projno
                        and b.active > 0 and a.costcode = :p_costcode and a.yymm > :p_yymm order by a.yymm
                    )
                    select (select x.newcostcode from projmast x where x.projno = b.projno) newcostcode,
                    b.projno, a.yymm, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(hrs) for yymm in (' ||
            pivot_clause || '))
                    group by newcostcode, projno 
                    order by newcostcode, projno)
                    where (newcostcode <> ''-'') '
            Using v_new_yymm, noofmonths, p_costcode, p_yymm;

        -- Future ------------------------------------------------------------
        Open p_future For
            'select * from
                    (select newcostcode||''-''||rap_reports_gen.get_costcode_desc(newcostcode) newcostcode,
                    projno, rap_reports_gen.get_exp_proj_name(projno) name, rap_reports_gen.get_exp_proj_activefuture(projno) activefuture,
                    rap_reports_gen.get_exp_proj_tcmno(projno) tcmno, ' || aggregate_clause || ', rap_reports_gen.get_exp_proj_active(projno) active from (
                    with t_yymm as (
                      select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths))
                    ),
                    t_data as (
                      select projno, yymm, nvl(hours,0) as hrs from rap_gtt_exptprjc where costcode = :p_costcode and yymm > :p_yymm order by yymm
                    )
                    select (select x.newcostcode from exptjobs x where x.projno = b.projno and (x.active = 1 or x.activefuture = 1)) newcostcode,
                    b.projno, a.yymm, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(hrs) for yymm in (' ||
            pivot_clause || '))
                    group by newcostcode, projno 
                    order by newcostcode, projno)
                    where (newcostcode <> ''-'') order by newcostcode, active desc, projno'
            Using v_new_yymm, noofmonths, p_costcode, p_yymm;

        -- Subcontract ------------------------------------------------------------
        Open p_subcont For
            'select * from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                         t_data as ( select yymm, nvl(hrs_subcont,0) hrs_subcont from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
                      select a.yymm, b.hrs_subcont from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(hrs_subcont) for yymm in (' || pivot_clause || '))'
            Using v_new_yymm, noofmonths, p_costcode, p_yymm;

    End rpt_cha1_expt;

End rap_cha1e_combine;
/

Grant Execute On "TIMECURR"."RAP_CHA1E_COMBINE" To "TCMPL_APP_CONFIG";