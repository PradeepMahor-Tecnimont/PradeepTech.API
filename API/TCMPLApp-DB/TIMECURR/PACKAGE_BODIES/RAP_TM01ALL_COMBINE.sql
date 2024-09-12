Create Or Replace Package Body "TIMECURR"."RAP_TM01ALL_COMBINE" As

    Procedure rpt_tm01all_projectlist(p_yymm       In  Varchar2,
                                      p_simul      In  Varchar2,
                                      p_reportmode In  Varchar2,
                                      p_code       In  Varchar2 Default Null,
                                      p_results    Out Sys_Refcursor) As
        v_stat Varchar2(2000);
    Begin
        If p_reportmode = 'COMBINED' Then
            v_stat := 'Select projno, tcmno, name, active,To_Char(sdate,''dd-Mon-yy'') sdate, To_Char(cdate,''dd-Mon-yy'') cdate ';
            v_stat := v_stat || ' From projmast Where active > 0 And projno In  ';
            v_stat := v_stat || '(Select distinct projno from prjcmast where yymm >= :p_yymm And active > 0 ';
            v_stat := v_stat || ' And costcode In ( Select cgc.costcode From rap_costcode_group cg, rap_costcode_group_costcodes cgc Where cg.group_id = cgc.group_id ) )';
            v_stat := v_stat || 'Union All ';
            v_stat := v_stat || 'Select projno, tcmno, name, 1 active, '''' sdate, '''' cdate From exptjobs ';
            v_stat := v_stat || 'Where(active > 0 or activefuture > 0)  ';

            Case p_simul
                When 'A' Then
                    v_stat := v_stat || ' and proj_type in (''A'',''B'',''C'') ';
                When 'B' Then
                    v_stat := v_stat || ' and proj_type in (''B'',''C'') ';
                When 'C' Then
                    v_stat := v_stat || ' and proj_type in (''C'') ';
                Else
                    v_stat := v_stat || '';
            End Case;

            v_stat := v_stat || ' and projno in (select distinct projno from exptprjc where yymm >= :p_yymm ';
            v_stat := v_stat || ' And costcode In  ( Select cgc.costcode From rap_costcode_group cg, rap_costcode_group_costcodes cgc Where cg.group_id = cgc.group_id ) )';

            v_stat := v_stat || ' order by projno';
            Open p_results For v_stat
                Using p_yymm, p_yymm;

        Else
            v_stat := 'Select projno, tcmno, name, active,To_Char(sdate,''dd-Mon-yy'') sdate, To_Char(cdate,''dd-Mon-yy'') cdate ';
            v_stat := v_stat || ' From projmast Where active > 0 And projno In  ';
            v_stat := v_stat || '(Select distinct projno from prjcmast where yymm >= :p_yymm And active > 0 ';
            v_stat := v_stat || ' And costcode In ( Select cgc.costcode From rap_costcode_group cg, rap_costcode_group_costcodes cgc Where cg.group_id = cgc.group_id And Nvl(cgc.code,''-'') = Nvl(:p_code,''-'') ))';
            v_stat := v_stat || 'Union All ';
            v_stat := v_stat || 'Select projno, tcmno, name, 1 active, '''' sdate, '''' cdate From exptjobs ';
            v_stat := v_stat || 'Where(active > 0 or activefuture > 0)  ';

            Case p_simul
                When 'A' Then
                    v_stat := v_stat || ' and proj_type in (''A'',''B'',''C'') ';
                When 'B' Then
                    v_stat := v_stat || ' and proj_type in (''B'',''C'') ';
                When 'C' Then
                    v_stat := v_stat || ' and proj_type in (''C'') ';
                Else
                    v_stat := v_stat || '';
            End Case;

            v_stat := v_stat || ' and projno in (select distinct projno from exptprjc where yymm >= :p_yymm ';
            v_stat := v_stat || ' And costcode In ( Select cgc.costcode From rap_costcode_group cg, rap_costcode_group_costcodes cgc Where cg.group_id = cgc.group_id And Nvl(cgc.code,''-'') = Nvl(:p_code,''-'') ))';

            v_stat := v_stat || ' order by projno';
            Open p_results For v_stat
                Using p_yymm, p_code, p_yymm, p_code;

        End If;

    End rpt_tm01all_projectlist;

    Procedure rpt_tm01all(p_activeyear In  Varchar2,
                          p_yymm       In  Varchar2,
                          p_simul      In  Varchar2,
                          p_yearmode   In  Varchar2,
                          p_projno     In  Varchar2,
                          p_reportmode In  Varchar2,
                          p_code       In  Varchar2 Default Null,
                          p_cols       Out Sys_Refcursor,
                          p_results    Out Sys_Refcursor) As

        Cursor cur_combine Is
            Select
                group_id, costcode
            From
                rap_costcode_group;
        pivot_clause   Varchar2(4000);
        noofmonths     Number;
        strstart       Varchar2(6);
        mfilter        Varchar2(1000);
        v_new_yymm     Varchar2(6);
        p_insert_query Varchar2(10000);
        p_success      Varchar2(2);
        p_message      Varchar2(1000);
    Begin
        noofmonths := 48;
        strstart   := p_yymm;

        If p_reportmode = 'COMBINED' Then
            rap_gtt.get_insert_query_4_gtt(p_activeyear, 'BUDGMAST', p_insert_query, p_success, p_message);
            If p_success = 'OK' Then
                Execute Immediate p_insert_query || ' where projno = :projno And costcode In ( Select cgc.costcode From rap_costcode_group cg, rap_costcode_group_costcodes cgc Where cg.group_id = cgc.group_id )'
                    Using p_projno;

                rap_gtt.get_insert_query_4_gtt(p_activeyear, 'OPENMAST', p_insert_query, p_success, p_message);
                If p_success = 'OK' Then
                    Execute Immediate p_insert_query || ' where projno = :projno And costcode In ( Select cgc.costcode From rap_costcode_group cg, rap_costcode_group_costcodes cgc Where cg.group_id = cgc.group_id )'
                        Using p_projno;

                    rap_gtt.get_insert_query_4_gtt(p_activeyear, 'TIMETRAN', p_insert_query, p_success, p_message);
                    If p_success = 'OK' Then
                        Execute Immediate p_insert_query || ' where projno = :projno And costcode In ( Select cgc.costcode From rap_costcode_group cg, rap_costcode_group_costcodes cgc Where cg.group_id = cgc.group_id )'
                            Using p_projno;

                        rap_gtt.get_insert_query_4_gtt(p_activeyear, 'PRJCMAST', p_insert_query, p_success, p_message);
                        If p_success = 'OK' Then
                            Execute Immediate p_insert_query || ' where projno = :projno And costcode In ( Select cgc.costcode From rap_costcode_group cg, rap_costcode_group_costcodes cgc Where cg.group_id = cgc.group_id )'
                                Using p_projno;

                            rap_gtt.get_insert_query_4_gtt(p_activeyear, 'EXPTPRJC', p_insert_query, p_success, p_message);
                            If p_success = 'OK' Then
                                Execute Immediate p_insert_query || ' where projno = :projno And costcode In ( Select cgc.costcode From rap_costcode_group cg, rap_costcode_group_costcodes cgc Where cg.group_id = cgc.group_id )'
                                    Using p_projno;

                                Commit;

                                --update to group costcode         

                                For c1 In cur_combine
                                Loop
                                    Update
                                        rap_gtt_budgmast
                                    Set
                                        costcode = (
                                            Select
                                                costcode
                                            From
                                                rap_costcode_group
                                            Where
                                                group_id = Trim(c1.group_id)
                                        )
                                    Where
                                        costcode = (
                                            Select
                                                costcode
                                            From
                                                rap_costcode_group_costcodes
                                            Where
                                                group_id = Trim(c1.group_id)
                                                And p_code Is Not Null
                                        );

                                    Update
                                        rap_gtt_openmast
                                    Set
                                        costcode = (
                                            Select
                                                costcode
                                            From
                                                rap_costcode_group
                                            Where
                                                group_id = Trim(c1.group_id)
                                        )
                                    Where
                                        costcode = (
                                            Select
                                                costcode
                                            From
                                                rap_costcode_group_costcodes
                                            Where
                                                group_id = Trim(c1.group_id)
                                                And p_code Is Not Null
                                        );

                                    Update
                                        rap_gtt_timetran
                                    Set
                                        costcode = (
                                            Select
                                                costcode
                                            From
                                                rap_costcode_group
                                            Where
                                                group_id = Trim(c1.group_id)
                                        )
                                    Where
                                        costcode = (
                                            Select
                                                costcode
                                            From
                                                rap_costcode_group_costcodes
                                            Where
                                                group_id = Trim(c1.group_id)
                                                And p_code Is Not Null
                                        );

                                    Update
                                        rap_gtt_prjcmast
                                    Set
                                        costcode = (
                                            Select
                                                costcode
                                            From
                                                rap_costcode_group
                                            Where
                                                group_id = Trim(c1.group_id)
                                        )
                                    Where
                                        costcode = (
                                            Select
                                                costcode
                                            From
                                                rap_costcode_group_costcodes
                                            Where
                                                group_id = Trim(c1.group_id)
                                                And p_code Is Not Null
                                        );

                                    Update
                                        rap_gtt_exptprjc
                                    Set
                                        costcode = (
                                            Select
                                                costcode
                                            From
                                                rap_costcode_group
                                            Where
                                                group_id = Trim(c1.group_id)
                                        )
                                    Where
                                        costcode = (
                                            Select
                                                costcode
                                            From
                                                rap_costcode_group_costcodes
                                            Where
                                                group_id = Trim(c1.group_id)
                                                And p_code Is Not Null
                                        );

                                End Loop;
                            End If;
                        End If;
                    End If;
                End If;
            End If;
        Else
            rap_gtt.get_insert_query_4_gtt(p_activeyear, 'BUDGMAST', p_insert_query, p_success, p_message);
            If p_success = 'OK' Then
                Execute Immediate p_insert_query || ' where projno = :projno And costcode In ( Select cgc.costcode From rap_costcode_group cg, rap_costcode_group_costcodes cgc Where cg.group_id = cgc.group_id And Nvl(cgc.code,''-'') = Nvl(:code,''-'') )'
                    Using p_projno, p_code;

                rap_gtt.get_insert_query_4_gtt(p_activeyear, 'OPENMAST', p_insert_query, p_success, p_message);
                If p_success = 'OK' Then
                    Execute Immediate p_insert_query || ' where projno = :projno And costcode In ( Select cgc.costcode From rap_costcode_group cg, rap_costcode_group_costcodes cgc Where cg.group_id = cgc.group_id And Nvl(cgc.code,''-'') = Nvl(:code,''-'') )'
                        Using p_projno, p_code;

                    rap_gtt.get_insert_query_4_gtt(p_activeyear, 'TIMETRAN', p_insert_query, p_success, p_message);
                    If p_success = 'OK' Then
                        Execute Immediate p_insert_query || ' where projno = :projno And costcode In ( Select cgc.costcode From rap_costcode_group cg, rap_costcode_group_costcodes cgc Where cg.group_id = cgc.group_id And Nvl(cgc.code,''-'') = Nvl(:code,''-'') )'
                            Using p_projno, p_code;

                        rap_gtt.get_insert_query_4_gtt(p_activeyear, 'PRJCMAST', p_insert_query, p_success, p_message);
                        If p_success = 'OK' Then
                            Execute Immediate p_insert_query || ' where projno = :projno And costcode In ( Select cgc.costcode From rap_costcode_group cg, rap_costcode_group_costcodes cgc Where cg.group_id = cgc.group_id And Nvl(cgc.code,''-'') = Nvl(:code,''-'') )'
                                Using p_projno, p_code;

                            rap_gtt.get_insert_query_4_gtt(p_activeyear, 'EXPTPRJC', p_insert_query, p_success, p_message);
                            If p_success = 'OK' Then
                                Execute Immediate p_insert_query || ' where projno = :projno And costcode In ( Select cgc.costcode From rap_costcode_group cg, rap_costcode_group_costcodes cgc Where cg.group_id = cgc.group_id And Nvl(cgc.code,''-'') = Nvl(:code,''-'') )'
                                    Using p_projno, p_code;

                                Commit;
                            End If;
                        End If;
                    End If;
                End If;
            End If;
        End If;

        Select
            to_char(add_months(To_Date(p_yymm, 'yyyymm'), 1), 'yyyymm')
        Into
            v_new_yymm
        From
            dual;

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

        Open p_cols For
            'Select * from (
              Select yymm From table(rap_reports.rpt_month_cols(:v_new_yymmp_yymm, :noofmonths))
            ) Pivot (max(yymm) For yymm in (' || pivot_clause || '))'
            Using v_new_yymm, noofmonths;
        -- Results Data --------------------------------------------------------
        Open p_results For
            'Select p.costcode, p.name, nvl(q.revised,0) revised, nvl(r.curryear,0) curryear, nvl(s.opening,0) opening, t.* from
        (Select distinct costcode, name, tm01_grp from costmast where cost_type = ''D'' and (
            costcode in (select distinct costcode from rap_gtt_budgmast where projno = :p_projno) or
            costcode in (select distinct costcode from rap_gtt_openmast where projno = :p_projno) or
            costcode in (select distinct costcode from rap_gtt_prjcmast where projno = :p_projno and yymm > :p_yymm) or
            costcode in (select distinct costcode from rap_gtt_exptprjc where projno = :p_projno and yymm > :p_yymm) or
            costcode in (select distinct costcode from rap_gtt_timetran where projno = :p_projno and yymm >= :strStart and yymm <= :p_yymm))) p,
        (Select costcode, nvl(original,0) original, nvl(revised,0) revised from rap_gtt_budgmast where projno = :p_projno) q,
        (Select costcode, sum(nvl(hours,0)) + sum(nvl(othours,0)) as curryear from rap_gtt_timetran
            Where projno = :p_projno And yymm >= :strStart And yymm <= :p_yymm
            Group By costcode Order By costcode) r,
        (Select costcode, case ''' || p_yearmode || ''' when ''J'' then nvl(open01,0) else nvl(open04,0) end as opening
          from rap_gtt_openmast where projno = :p_projno order by costcode) s,
        (Select * from (
          with t_yymm as ( Select yymm from table(rap_reports.rpt_month_cols(:p_yymm, 48)) ),
             t_data as ( Select * from (Select costcode, yymm, hours from rap_gtt_prjcmast where projno = :p_projno and yymm >= :v_new_yymm
                                        Union  
                                        Select costcode, yymm, hours from rap_gtt_exptprjc where projno = :p_projno and yymm >= :v_new_yymm)
                         Order By costcode, yymm )
          Select b.costcode, a.yymm, nvl(b.hours,0) hours from t_yymm a, t_data b where a.yymm = b.yymm(+) and costcode is not null
              Order by b.costcode, a.yymm
        )  pivot ( sum(hours) for yymm in (' || pivot_clause ||
            ')) Order by costcode) t
        Where p.costcode = q.costcode(+) and p.costcode = r.costcode(+) and p.costcode = s.costcode(+) and p.costcode = t.costcode(+)
        Order By p.costcode'
            Using p_projno, p_projno,
            p_projno, p_yymm,
            p_projno, p_yymm,
            p_projno, strstart, p_yymm,
            p_projno,
            p_projno, strstart, p_yymm,
            p_projno,
            v_new_yymm,
            p_projno, v_new_yymm,
            p_projno, v_new_yymm;
    End rpt_tm01all;

End rap_tm01all_combine;
/
Grant Execute On "TIMECURR"."RAP_TM01ALL_COMBINE" To "TCMPL_APP_CONFIG";