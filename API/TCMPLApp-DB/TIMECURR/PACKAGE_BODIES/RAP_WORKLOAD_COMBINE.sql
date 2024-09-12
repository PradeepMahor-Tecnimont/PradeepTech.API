Create Or Replace Package Body "TIMECURR"."RAP_WORKLOAD_COMBINE" As

    Procedure rpt_workload_new(p_yyyy       In  Varchar2,
                               p_costcode   In  Varchar2,
                               p_yymm       In  Varchar2,
                               p_simul      In  Varchar2,
                               p_yearmode   In  Varchar2,
                               p_reportmode In  Varchar2,
                               p_cols       Out Sys_Refcursor,
                               p_results    Out Sys_Refcursor) As
        pivot_clause   Varchar2(4000);
        noofmonths     Number;
        mfilter        Varchar2(1000);
        v_lastmonth    Varchar2(6);
        viewname       Varchar2(30);
        v_new_yymm     Varchar2(6);
        p_batch_key_id Varchar2(8);
        p_success      Varchar2(2);
        p_message      Varchar2(4000);
        p_insert_query Varchar2(10000);
    Begin
        noofmonths := 18;

        Select
            to_char(add_months(To_Date(p_yymm, 'yyyymm'), 1), 'yyyymm')
        Into
            v_new_yymm
        From
            dual;

        Select
            rap_reports_gen.get_lastmonth(v_new_yymm, noofmonths)
        Into
            v_lastmonth
        From
            dual;

        Case p_simul
            When 'A' Then
                mfilter := ' and proj_type in (''A'',''B'',''C'') ';
            When 'B' Then
                mfilter := ' and proj_type in (''B'',''C'') ';
            When 'C' Then
                mfilter := ' and proj_type in (''C'') ';
            Else
                mfilter := '';
        End Case;
 	     
        -- Results Data -------------------------------------------------------- 
        Select
            substr(sys_guid(), 0, 8)
        Into
            p_batch_key_id
        From
            dual;
        
        -- Populate GTT tbales ---------------------------------------------------

        If p_reportmode = 'COMBINED' Then
            rap_gtt.get_insert_query_4_gtt(p_yyyy, 'MOVEMAST', p_insert_query, p_success, p_message);
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

                Execute Immediate p_insert_query || ' where costcode  in (
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
                rap_gtt.get_insert_query_4_gtt(p_yyyy, 'EXPTPRJC', p_insert_query, p_success, p_message);
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
                                )   and yymm > :yymm ' Using p_costcode,
                    p_yymm;
                    rap_gtt.get_insert_query_4_gtt(p_yyyy, 'PRJCMAST', p_insert_query, p_success, p_message);
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
            rap_gtt.get_insert_query_4_gtt(p_yyyy, 'MOVEMAST', p_insert_query, p_success, p_message);
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
                rap_gtt.get_insert_query_4_gtt(p_yyyy, 'EXPTPRJC', p_insert_query, p_success, p_message);
                If p_success = 'OK' Then
                    Execute Immediate p_insert_query || ' where costcode = trim(:costcode) and yymm > :yymm ' Using p_costcode,
                    p_yymm;
                    rap_gtt.get_insert_query_4_gtt(p_yyyy, 'PRJCMAST', p_insert_query, p_success, p_message);
                    If p_success = 'OK' Then
                        Execute Immediate p_insert_query || ' where costcode = trim(:costcode) and yymm > :yymm ' Using p_costcode,
                        p_yymm;
                        Commit;
                    End If;
                End If;
            End If;
        End If;

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
        
        -- Cols --------------------------------------------------------			
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
        -- General Data --------------------------------------------------------
        Open p_cols For
            'select * from ( 
                  select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths))
                ) pivot (max(yymm) for yymm in (' || pivot_clause || '))'
            Using v_new_yymm, noofmonths;

        Open p_results For
            'select * from (  
              select yymm, name, last_value(working_hr) ignore nulls over (
                order by yymm rows between unbounded preceding and current row) working_hr from (  
              with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                 t_data as ( select yymm, working_hr * rap_costcode_combine.get_empcount(:p_costcode, :p_reportmode) working_hr from raphours where yymm > :p_yymm order by yymm )
              select a.yymm, ''a'' as Name, b.working_hr from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm )
            ) pivot (sum(working_hr) for yymm in (' || pivot_clause || '))                    
            union
            select * from (
              with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                 t_data as ( select yymm, sum(nvl(fut_recruit,0)) over(partition by costcode order by yymm) fut_recruit from rap_gtt_movemast_combined
                 where costcode = :p_costcode and yymm > :p_yymm order by yymm )
              select a.yymm, ''b'' as Name, b.fut_recruit * rap_reports.getWorkingHrs(a.yymm) fut_recruit from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
            ) pivot (sum(fut_recruit) for yymm in (' ||
            pivot_clause || '))
            union
            select * from (
              with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                 t_data as ( select yymm, nvl(int_dept,0) * rap_reports.getWorkingHrs(yymm) int_dept from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
              select a.yymm, ''c'' as Name, b.int_dept from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
            ) pivot (sum(int_dept) for yymm in (' || pivot_clause || '))
            union
            select * from (
              with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                 t_data as ( select yymm, nvl(movetotcm,0) * rap_reports.getWorkingHrs(yymm) movetotcm from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
              select a.yymm, ''d'' as Name, b.movetotcm from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
            ) pivot (sum(movetotcm) for yymm in (' ||
            pivot_clause || '))
            union
            select * from (
              with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                 t_data as ( select yymm, nvl(movetosite,0) * rap_reports.getWorkingHrs(yymm) movetosite from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
              select a.yymm, ''e'' as Name, b.movetosite from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
            ) pivot (sum(movetosite) for yymm in (' || pivot_clause || '))
            union
            select * from (
              with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                 t_data as ( select yymm, nvl(movetoothers,0) * rap_reports.getWorkingHrs(yymm) movetoothers from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
              select a.yymm, ''f'' as Name, b.movetoothers from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
            ) pivot (sum(movetoothers) for yymm in (' ||
            pivot_clause || '))
            union
            select * from (
              with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                 t_data as ( select yymm, nvl(ext_subcontract,0) * rap_reports.getWorkingHrs(yymm) ext_subcontract from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
              select a.yymm, ''g'' as Name, b.ext_subcontract from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
            ) pivot (sum(ext_subcontract) for yymm in (' || pivot_clause || ')) 
            union
            select * from (
              with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                   t_data as (select a.yymm yymm, nvl(a.hours,0) as hrs from rap_gtt_prjcmast a, projmast b
                                where a.projno = b.projno and b.active > 0 and a.costcode = :p_costcode and a.yymm > :p_yymm					
                              Union all
                              select p.yymm, nvl(p.hours,0) as hrs from rap_gtt_exptprjc p, exptjobs q
                               where p.projno = q.projno and q.activefuture <= 0 and q.active > 0 and p.costcode = :p_costcode and p.yymm > :p_yymm						
                              )
              select a.yymm, ''i'' as Name, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm                             
            ) pivot (sum(hrs) for yymm in (' ||
            pivot_clause || ')) 
            union
            select * from (
              with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                 t_data as 
                 (select x.yymm yymm, nvl(x.hours,0) as hrs from rap_gtt_exptprjc x, exptjobs y
                   where x.projno = y.projno and y.activefuture > 0 and y.active <= 0 and x.costcode = :p_costcode and x.yymm > :p_yymm ' ||
            mfilter || '		
                 )
                 select a.yymm, ''j'' as Name, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm                             
            ) pivot (sum(hrs) for yymm in (' || pivot_clause || ')) '
            Using v_new_yymm, noofmonths, p_costcode, p_reportmode, p_yymm,
            v_new_yymm, noofmonths, p_costcode, p_yymm,
            v_new_yymm, noofmonths, p_costcode, p_yymm,
            v_new_yymm, noofmonths, p_costcode, p_yymm,
            v_new_yymm, noofmonths, p_costcode, p_yymm,
            v_new_yymm, noofmonths, p_costcode, p_yymm,
            v_new_yymm, noofmonths, p_costcode, p_yymm,
            v_new_yymm, noofmonths, p_costcode, p_yymm, p_costcode, p_yymm,
            v_new_yymm, noofmonths, p_costcode, p_yymm;

    End rpt_workload_new;

End rap_workload_combine;
/
Grant Execute On "TIMECURR"."RAP_WORKLOAD_COMBINE" To "TCMPL_APP_CONFIG";