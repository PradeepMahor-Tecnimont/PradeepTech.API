--------------------------------------------------------
--  DDL for Package Body RAP_REPORTS_C
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."RAP_REPORTS_C" as
  
  procedure rpt_cha1e_cc(p_yyyy in varchar2, p_yymm in varchar2, p_costcode in varchar2, p_simul in varchar2, p_report_mode in varchar2, p_cols out sys_refcursor,
                         p_gen out sys_refcursor, p_gen_other out sys_refcursor, p_alldata out sys_refcursor, p_ot out sys_refcursor,
                         p_project out sys_refcursor, p_future out sys_refcursor, p_subcont out sys_refcursor) as
    pivot_clause varchar2(4000);
    mfilter varchar2(1000);
    noofmonths number;
    p_batch_key_id varchar2(8);
    p_insert_query Varchar2(10000);
    p_success Varchar2(2);
    p_message Varchar2(4000);
    v_new_yymm Varchar2(6);
    aggregate_clause varchar2(4000);
    v_costcode       rap_costcode_group_costcodes.costcode%Type;
  begin
    noofmonths := 18;

    select to_char(add_months(to_date(p_yymm,'yyyymm'),1),'yyyymm') into v_new_yymm from dual;

    case p_simul
      when 'A' then
        mfilter := ' and proj_type in (''A'',''B'',''C'') ';
      when 'B' then
        mfilter := ' and proj_type in (''B'',''C'') ';
      when 'C' then
        mfilter := ' and proj_type in (''C'') ';
      else
        mfilter := '';
    end case;

    If p_report_mode = 'COMBINED' Then
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


    select substr(SYS_GUID(),0,8) into p_batch_key_id from dual;
    -- Populate GTT tbales ---------------------------------------------------
    rap_gtt.get_insert_query_4_gtt(p_yyyy, 'MOVEMAST', p_insert_query, p_success, p_message);
    if p_success = 'OK' then
      For i in 1..noofmonths Loop
        If p_report_mode = 'SINGLE' THEN
            Insert Into rap_gtt_movemast
                Select p_costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm'),0,0,0,0,0,0,0,0,p_batch_key_id From dual
                    Where (p_costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm')) not in
                (select costcode, yymm from movemast) ;
        ElsIf p_report_mode = 'COMBINED' THEN
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
        End If;
      End Loop;
      If p_report_mode = 'SINGLE' THEN
        execute immediate p_insert_query || ' where costcode = trim(:costcode) and yymm > :yymm ' using p_batch_key_id, p_costcode, p_yymm;
      ElsIf p_report_mode = 'COMBINED' THEN
        execute immediate p_insert_query || ' where costcode in ( Select cgc.costcode
                                                                    From
                                                                        rap_costcode_group           cg,
                                                                        rap_costcode_group_costcodes cgc
                                                                    Where
                                                                        cg.group_id     = cgc.group_id
                                                                        And cg.costcode = Trim(:costcode)
                                                                ) and yymm > :yymm ' using p_batch_key_id, p_costcode, p_yymm;
      End If;
      rap_gtt.get_insert_query_4_gtt(p_yyyy, 'EXPTPRJC', p_insert_query, p_success, p_message);
      if p_success = 'OK' then
          If p_report_mode = 'SINGLE' THEN
            execute immediate p_insert_query || ' where costcode = trim(:costcode) and yymm > :yymm ' using p_costcode, p_yymm;
          ElsIf p_report_mode = 'COMBINED' THEN
            execute immediate p_insert_query || ' where costcode in ( Select cgc.costcode
                                                                    From
                                                                        rap_costcode_group           cg,
                                                                        rap_costcode_group_costcodes cgc
                                                                    Where
                                                                        cg.group_id     = cgc.group_id
                                                                        And cg.costcode = Trim(:costcode)
                                                                ) and yymm > :yymm ' using p_costcode, p_yymm;
          End If;
          rap_gtt.get_insert_query_4_gtt(p_yyyy, 'PRJCMAST', p_insert_query, p_success, p_message);
          if p_success = 'OK' then
            If p_report_mode = 'SINGLE' THEN
                execute immediate p_insert_query || ' where costcode = trim(:costcode) and yymm > :yymm ' using p_costcode, p_yymm;
            ElsIf p_report_mode = 'COMBINED' THEN
                execute immediate p_insert_query || ' where costcode in ( Select cgc.costcode
                                                                    From
                                                                        rap_costcode_group           cg,
                                                                        rap_costcode_group_costcodes cgc
                                                                    Where
                                                                        cg.group_id     = cgc.group_id
                                                                        And cg.costcode = Trim(:costcode)
                                                                )  and yymm > :yymm ' using p_costcode, p_yymm;
            End If;
            
            If p_report_mode = 'COMBINED' THEN
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
            
            commit;

            select listagg( yymm || ' as "' || heading || '"', ', ') within group (order by yymm) into pivot_clause
                from (select yymm, heading from table(rap_reports.rpt_month_cols(v_new_yymm, noofmonths)));

            select listagg( ' sum(' ||  heading || ') as "' || heading || '"', ', ') within group (order by yymm) into aggregate_clause
               from (select yymm, heading from table(rap_reports.rpt_month_cols(v_new_yymm, noofmonths)));

            -- General Data --------------------------------------------------------
              open p_gen for
              'Select a.costcode, a.abbr, sum(nvl(a.noofemps,0)) AS noofemps,
                 sum(decode(nvl(a.changed_nemps,0),0,nvl(a.noofemps,0),nvl(a.changed_nemps,0))) as changed_nemps,
                 initcap(b.name) name, to_char(sysdate, ''dd-Mon-yyyy'') pdate,
                 sum(nvl(a.noofcons,0)) as noofcons from costmast a, emplmast b
               where a.hod = b.empno and costcode = :p_costcode group by a.costcode, a.abbr, b.name'
            using p_costcode;
            
            open p_gen_other for
              'Select a.costcode, a.abbr, sum(nvl(a.noofemps,0)) AS noofemps,
                 sum(decode(nvl(a.changed_nemps,0),0,nvl(a.noofemps,0),nvl(a.changed_nemps,0))) as changed_nemps,
                 initcap(b.name) name, to_char(sysdate, ''dd-Mon-yyyy'') pdate,
                 sum(nvl(a.noofcons,0)) as noofcons from costmast a, emplmast b
               where a.hod = b.empno and costcode = :p_costcode group by a.costcode, a.abbr, b.name'
            using v_costcode;
            
            -- Column names --------------------------------------------------------
            open p_cols for
              'select * from (
                select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths))
              ) pivot (max(yymm) for yymm in ('|| pivot_clause ||'))'
            using v_new_yymm, noofmonths;
            -- All Data  --------------------------------------------------
            open p_alldata for
                  'select * from (
                      select yymm, name, last_value(working_hr) ignore nulls over (
                        order by yymm rows between unbounded preceding and current row) working_hr from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                         t_data as ( select yymm, working_hr  from raphours where yymm > :p_yymm order by yymm )
                      select a.yymm, ''a'' as Name, b.working_hr from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm )
                    ) pivot (sum(working_hr) for yymm in ('|| pivot_clause ||'))
                    union
                    select * from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                         t_data as ( select yymm,  sum(nvl(fut_recruit,0)) over(partition by costcode order by yymm) fut_recruit from rap_gtt_movemast_combined
                         where costcode = :p_costcode and yymm > :p_yymm order by yymm )
                      select a.yymm, ''b'' as Name, b.fut_recruit from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(fut_recruit) for yymm in ('|| pivot_clause ||'))
                    union
                    select * from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                         t_data as ( select yymm, nvl(int_dept,0) int_dept from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
                      select a.yymm, ''c'' as Name, b.int_dept from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(int_dept) for yymm in ('|| pivot_clause ||'))
                    union
                    select * from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                         t_data as ( select yymm, nvl(movetotcm,0) movetotcm from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
                      select a.yymm, ''d'' as Name, b.movetotcm from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(movetotcm) for yymm in ('|| pivot_clause ||'))
                    union
                    select * from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                         t_data as ( select yymm, nvl(movetosite,0) movetosite from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
                      select a.yymm, ''e'' as Name, b.movetosite from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(movetosite) for yymm in ('|| pivot_clause ||'))
                    union
                    select * from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                         t_data as ( select yymm, nvl(movetoothers,0) movetoothers from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
                      select a.yymm, ''f'' as Name, b.movetoothers from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(movetoothers) for yymm in ('|| pivot_clause ||'))
                    union
                    select * from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                         t_data as ( select yymm, nvl(ext_subcontract,0) ext_subcontract from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
                      select a.yymm, ''g'' as Name, b.ext_subcontract from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(ext_subcontract) for yymm in ('|| pivot_clause ||')) '
                  using v_new_yymm, noofmonths, p_yymm,
                        v_new_yymm, noofmonths, p_costcode, p_yymm,
                        v_new_yymm, noofmonths, p_costcode, p_yymm,
                        v_new_yymm, noofmonths, p_costcode, p_yymm,
                        v_new_yymm, noofmonths, p_costcode, p_yymm,
                        v_new_yymm, noofmonths, p_costcode, p_yymm,
                        v_new_yymm, noofmonths, p_costcode, p_yymm;
            -- Overtime ------------------------------------------------------------
            open p_ot for
              'select * from (
                with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths))  ),
                t_data as ( select yymm, ot from otmast where ((costcode = :p_costcode And :p_reportmode = ''SINGLE'') OR
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
                        and yymm > :p_yymm )
                select a.yymm, b.ot from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
              ) pivot (sum(ot) for yymm in ('|| pivot_clause ||'))'
            Using v_new_yymm, noofmonths, p_costcode, p_report_mode, p_costcode, p_report_mode, p_yymm;
            -- Projects ------------------------------------------------------------
              open p_project for
                'select * from
                (select newcostcode||''-''||rap_reports_gen.get_costcode_desc(newcostcode) newcostcode,
                projno, rap_reports_gen.get_proj_name(projno) name, rap_reports_gen.get_proj_cdate(projno) cdate,
                rap_reports_gen.get_proj_tcmno(projno) tcmno,  '|| aggregate_clause ||', rap_reports_gen.get_proj_active(projno) active from (
                with t_yymm as (
                  select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths))
                ),
                t_data as (
                  select a.projno, a.yymm, nvl(a.hours,0) as hrs from rap_gtt_prjcmast a, projmast b where a.projno = b.projno
                        and b.active > 0 and a.costcode = :p_costcode and a.yymm > :p_yymm order by a.yymm
                )
                select (select x.newcostcode from projmast x where x.projno = b.projno and active > 0) newcostcode,
                b.projno, a.yymm, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                ) pivot (sum(hrs) for yymm in ('|| pivot_clause ||' ))
                group by newcostcode, projno order by newcostcode, projno)
                where (newcostcode <> ''-'') '
              using v_new_yymm, noofmonths, p_costcode, p_yymm ;
            -- Future ------------------------------------------------------------
             open p_future for
                'select * from
                (select newcostcode||''-''||rap_reports_gen.get_costcode_desc(newcostcode) newcostcode,
                projno, rap_reports_gen.get_exp_proj_name(projno) name, rap_reports_gen.get_exp_proj_activefuture(projno) activefuture,
                rap_reports_gen.get_exp_proj_tcmno(projno) tcmno, '|| aggregate_clause ||' , rap_reports_gen.get_exp_proj_active(projno) active from (
                with t_yymm as (
                  select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths))
                ),
                t_data as (
                  select projno, yymm, nvl(hours,0) as hrs from rap_gtt_exptprjc where yymm > :p_yymm
                   and costcode = :p_costcode order by yymm
                )
                select (select newcostcode from exptjobs where projno = b.projno and (active > 0 or activefuture > 0 ) '|| mfilter || ' ) newcostcode,
                b.projno, a.yymm, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                ) pivot (sum(hrs) for yymm in ( '|| pivot_clause ||' ))
                group by newcostcode, projno order by newcostcode, projno)
                where newcostcode <> ''-'' order by newcostcode, active desc, projno '
              using v_new_yymm, noofmonths, p_yymm, p_costcode;
            -- Subcontract ------------------------------------------------------------
              open p_subcont for
              'select * from (
                  with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                     t_data as ( select yymm, nvl(hrs_subcont,0) hrs_subcont from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
                  select a.yymm, b.hrs_subcont from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                ) pivot (sum(hrs_subcont) for yymm in ('|| pivot_clause ||'))'
              using v_new_yymm, noofmonths, p_costcode, p_yymm;
          end if;
      end if;
    end if;
  end rpt_cha1e_cc;

  procedure rpt_cha1e_category(p_yyyy in varchar2, p_yymm in varchar2, p_category in varchar2, p_simul in varchar2, p_mnths in varchar2,
                               p_cols out sys_refcursor, p_gen out sys_refcursor, p_alldata out sys_refcursor,
                               p_ot out sys_refcursor, p_project out sys_refcursor, p_future out sys_refcursor, p_subcont out sys_refcursor) as
    pivot_clause varchar2(4000);
    str_costcode varchar2(2000);
    mfilter varchar2(1000);
    p_batch_key_id varchar2(8);
    p_insert_query Varchar2(10000);
    p_success Varchar2(2);
    p_message Varchar2(4000);
    v_new_yymm Varchar2(6);
    aggregate_clause varchar2(4000);
  begin
    select to_char(add_months(to_date(p_yymm,'yyyymm'),1),'yyyymm') into v_new_yymm from dual;

    case p_category
      --Engg combined
      when 'E' then
        str_costcode := ' costcode in (select costcode from costmast where tma_grp = ''E''
                          and activity = 1 and group_chart = 1
                          and costcode In (Select costcode From deptphase Where IsPrimary = 1))';
      --Engg Mumbai
      when 'EM' then
        str_costcode := ' costcode in (select costcode from costmast where tma_grp = ''E''
                          and activity = 1 and group_chart = 1
                          and costcode In (Select costcode From deptphase Where costcode like ''02%'' And IsPrimary = 1)) ';
      --Engg Delhi
      when 'ED' then
        str_costcode := ' costcode in (select costcode from costmast where tma_grp = ''E''
                          and activity = 1 and group_chart = 1
                          and costcode In (Select costcode From deptphase Where costcode like ''0D%'' And IsPrimary = 1)) ';
      --Non Engg combined
      when 'N' then
        str_costcode := ' costcode in (select costcode from costmast where tma_grp in (''P'',''M'',''C'')
                          and activity = 1 and group_chart = 1
                          and costcode In (Select costcode From deptphase Where IsPrimary = 1))';
      --Non Engg Mumbai
      when 'NM' then
        str_costcode := ' costcode in (select costcode from costmast where tma_grp in (''P'',''M'',''C'')
                          and activity = 1 and group_chart = 1
                          and costcode In (Select costcode From deptphase Where costcode like ''02%'' And IsPrimary = 1))';
      --Non Engg Delhi
      when 'ND' then
        str_costcode := ' costcode in (select costcode from costmast where tma_grp in (''P'',''M'',''C'')
                          and activity = 1 and group_chart = 1
                          and costcode In (Select costcode From deptphase Where costcode like ''0D%'' And IsPrimary = 1))';
      --Engg & Non Engg combined
      when 'B' then
        str_costcode := ' costcode in (select costcode from costmast where (tma_grp = ''E''
                          or tma_grp = ''P'' or tma_grp = ''C'' or tma_grp = ''M'')
                          and activity = 1 and group_chart = 1
                          and costcode In (Select costcode From deptphase Where IsPrimary = 1))';
      --Engg & Non Engg Mumbai
      when 'BM' then
        str_costcode := ' costcode in (select costcode from costmast where (tma_grp = ''E''
                          or tma_grp = ''P'' or tma_grp = ''C'' or tma_grp = ''M'')
                          and activity = 1 and group_chart = 1
                          and costcode In (Select costcode From deptphase Where costcode like ''02%'' And IsPrimary = 1))';
     --Engg & Non Engg Delhi
      when 'BD' then
        str_costcode := ' costcode in (select costcode from costmast where (tma_grp = ''E''
                          or tma_grp = ''P'' or tma_grp = ''C'' or tma_grp = ''M'')
                          and activity = 1 and group_chart = 1
                          and costcode In (Select costcode From deptphase Where costcode like ''0D%'' And IsPrimary = 1))';
      --Procuremnt combined
      When 'PROCUREMENT' Then
        str_costcode := ' costcode In (Select
                                            c.costcode
                                       From
                                            costmast c,
                                            deptphase d,
                                            rap_costcode_group rcg,
                                            rap_costcode_group_costcodes rcgc
                                       Where
                                            c.costcode = d.costcode
                                            And c.costcode = rcgc.costcode
                                            And rcg.group_id = rcgc.group_id
                                            And c.tma_grp = ''P''
                                            And d.IsPrimary = 1
                                            And c.activity = 1
                                            And c.group_chart = 1
                                            And rcg.group_name = ''PROCUREMENT''
                                       ) ';
      --Procuremnt Mumbai
      When 'PROCUREMENT_MUMBAI' Then
        str_costcode := ' costcode In (Select
                                            c.costcode
                                       From
                                            costmast c,
                                            deptphase d,
                                            rap_costcode_group rcg,
                                            rap_costcode_group_costcodes rcgc
                                       Where
                                            c.costcode = d.costcode
                                            And c.costcode = rcgc.costcode
                                            And rcg.group_id = rcgc.group_id
                                            And c.tma_grp = ''P''
                                            And d.IsPrimary = 1
                                            And c.activity = 1
                                            And c.group_chart = 1
                                            And rcg.group_name = ''PROCUREMENT''
                                            And rcgc.code Is Null
                                       ) ';
    --Procuremnt Delhi
    When 'PROCUREMENT_DELHI' Then
        str_costcode := ' costcode In (Select
                                            c.costcode
                                       From
                                            costmast c,
                                            deptphase d,
                                            rap_costcode_group rcg,
                                            rap_costcode_group_costcodes rcgc
                                       Where
                                            c.costcode = d.costcode
                                            And c.costcode = rcgc.costcode
                                            And rcg.group_id = rcgc.group_id
                                            And c.tma_grp = ''P''
                                            And d.IsPrimary = 1
                                            And c.activity = 1
                                            And c.group_chart = 1
                                            And rcg.group_name = ''PROCUREMENT''
                                            And rcgc.code = ''D''
                                       ) ';
      --Proco combined
      When 'PROCO' Then
        str_costcode := ' costcode In (Select
                                            c.costcode
                                       From
                                            costmast c,
                                            deptphase d,
                                            rap_costcode_group rcg,
                                            rap_costcode_group_costcodes rcgc
                                       Where
                                            c.costcode = d.costcode
                                            And c.costcode = rcgc.costcode
                                            And rcg.group_id = rcgc.group_id
                                            And c.tma_grp In (''M'',''C'')
                                            And d.IsPrimary = 1
                                            And c.activity = 1
                                            And c.group_chart = 1
                                            And rcg.group_name = ''PROCO''
                                       ) ';
      --Proco Mumbai
      When 'PROCO_MUMBAI' Then
        str_costcode := ' costcode In (Select
                                            c.costcode
                                       From
                                            costmast c,
                                            deptphase d,
                                            rap_costcode_group rcg,
                                            rap_costcode_group_costcodes rcgc
                                       Where
                                            c.costcode = d.costcode
                                            And c.costcode = rcgc.costcode
                                            And rcg.group_id = rcgc.group_id
                                            And c.tma_grp In (''M'',''C'')
                                            And d.IsPrimary = 1
                                            And c.activity = 1
                                            And c.group_chart = 1
                                            And rcg.group_name = ''PROCO''
                                            And rcgc.code Is Null
                                       ) ';
        --Proco Delhi
        When 'PROCO_DELHI' Then
            str_costcode := ' costcode In (Select
                                                c.costcode
                                           From
                                                costmast c,
                                                deptphase d,
                                                rap_costcode_group rcg,
                                                rap_costcode_group_costcodes rcgc
                                           Where
                                                c.costcode = d.costcode
                                                And c.costcode = rcgc.costcode
                                                And rcg.group_id = rcgc.group_id
                                                And c.tma_grp In (''M'',''C'')
                                                And d.IsPrimary = 1
                                                And c.activity = 1
                                                And c.group_chart = 1
                                                And rcg.group_name = ''PROCO''
                                                And rcgc.code = ''D''
                                           ) ';
    end case;

    case p_simul
      when 'A' then
        mfilter := ' and proj_type in (''A'',''B'',''C'') ';
      when 'B' then
        mfilter := ' and proj_type in (''B'',''C'') ';
      when 'C' then
        mfilter := ' and proj_type in (''C'') ';
      else
        mfilter := '';
    end case;

    select substr(SYS_GUID(),0,8) into p_batch_key_id from dual;
    -- Populate GTT tbales ---------------------------------------------------
    rap_gtt.get_insert_query_4_gtt(p_yyyy, 'MOVEMAST', p_insert_query, p_success, p_message);
    if p_success = 'OK' then
      For i in 1..to_number(p_mnths) Loop
         case p_category
            when 'E' then
                Insert Into rap_gtt_movemast
                    Select costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm'),0,0,0,0,0,0,0,0,p_batch_key_id From costmast
                        Where tma_grp = 'E' and activity = 1 and group_chart = 1
                            and costcode In (Select costcode From deptphase Where IsPrimary = 1)
                        and (costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm')) not in
                    (select costcode, yymm from movemast) ;
            when 'EM' then
                Insert Into rap_gtt_movemast
                    Select costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm'),0,0,0,0,0,0,0,0,p_batch_key_id From costmast
                        Where tma_grp = 'E' and activity = 1 and group_chart = 1
                            and costcode In (Select costcode From deptphase Where costcode like '02%' And IsPrimary = 1)
                        and (costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm')) not in
                    (select costcode, yymm from movemast) ;
            when 'ED' then
                Insert Into rap_gtt_movemast
                    Select costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm'),0,0,0,0,0,0,0,0,p_batch_key_id From costmast
                        Where tma_grp = 'E' and activity = 1 and group_chart = 1
                            and costcode In (Select costcode From deptphase Where costcode like '0D%' And IsPrimary = 1)
                        and (costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm')) not in
                    (select costcode, yymm from movemast) ;


            when 'N' then
                Insert Into rap_gtt_movemast
                    Select costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm'),0,0,0,0,0,0,0,0,p_batch_key_id From costmast
                        Where tma_grp In ('P','M','C') and activity = 1 and group_chart = 1
                        and costcode In (Select costcode From deptphase Where IsPrimary = 1)
                        and (costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm')) not in
                    (select costcode, yymm from movemast) ;

            when 'NM' then
                Insert Into rap_gtt_movemast
                    Select costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm'),0,0,0,0,0,0,0,0,p_batch_key_id From costmast
                        Where tma_grp In ('P','M','C') and activity = 1 and group_chart = 1
                        and costcode In (Select costcode From deptphase Where costcode like '02%' And IsPrimary = 1)
                        and (costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm')) not in
                    (select costcode, yymm from movemast) ;

            when 'ND' then
                Insert Into rap_gtt_movemast
                    Select costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm'),0,0,0,0,0,0,0,0,p_batch_key_id From costmast
                        Where tma_grp In ('P','M','C') and activity = 1 and group_chart = 1
                        and costcode In (Select costcode From deptphase Where costcode like '0D%' And IsPrimary = 1)
                        and (costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm')) not in
                    (select costcode, yymm from movemast) ;

            when 'B' then
                Insert Into rap_gtt_movemast
                    Select costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm'),0,0,0,0,0,0,0,0,p_batch_key_id From costmast
                        Where tma_grp In ('E','P','M','C') and activity = 1 and group_chart = 1
                        and costcode In (Select costcode From deptphase Where IsPrimary = 1)
                        and (costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm')) not in
                    (select costcode, yymm from movemast) ;

            when 'BM' then
                Insert Into rap_gtt_movemast
                    Select costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm'),0,0,0,0,0,0,0,0,p_batch_key_id From costmast
                        Where tma_grp In ('E','P','M','C') and activity = 1 and group_chart = 1
                        and costcode In (Select costcode From deptphase Where costcode like '02%' And IsPrimary = 1)
                        and (costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm')) not in
                    (select costcode, yymm from movemast) ;

            when 'BD' then
                Insert Into rap_gtt_movemast
                    Select costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm'),0,0,0,0,0,0,0,0,p_batch_key_id From costmast
                        Where tma_grp In ('E','P','M','C') and activity = 1 and group_chart = 1
                        and costcode In (Select costcode From deptphase Where costcode like '0D%' And IsPrimary = 1)
                        and (costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm')) not in
                    (select costcode, yymm from movemast) ;

            When 'PROCUREMENT' Then
                Insert Into rap_gtt_movemast
                    Select c.costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm'),0,0,0,0,0,0,0,0,p_batch_key_id
					From
						costmast c,
						deptphase d,
						rap_costcode_group rcg,
						rap_costcode_group_costcodes rcgc
				    Where
						c.costcode = d.costcode
						And c.costcode = rcgc.costcode
						And rcg.group_id = rcgc.group_id
						And c.tma_grp = 'P'
						And d.IsPrimary = 1
						And c.activity = 1
						And c.group_chart = 1
						And rcg.group_name = 'PROCUREMENT'
                        And (c.costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm')) Not In
							(Select m.costcode, m.yymm From movemast m) ;

            When 'PROCUREMENT_MUMBAI' Then
                Insert Into rap_gtt_movemast
                    Select c.costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm'),0,0,0,0,0,0,0,0,p_batch_key_id
					From
						costmast c,
						deptphase d,
						rap_costcode_group rcg,
						rap_costcode_group_costcodes rcgc
				    Where
						c.costcode = d.costcode
						And c.costcode = rcgc.costcode
						And rcg.group_id = rcgc.group_id
						And c.tma_grp = 'P'
						And d.IsPrimary = 1
						And c.activity = 1
						And c.group_chart = 1
						And rcg.group_name = 'PROCUREMENT'
                        And rcgc.code Is Null
                        And (c.costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm')) Not In
							(Select m.costcode, m.yymm From movemast m) ;

            When 'PROCUREMENT_DELHI' Then
                Insert Into rap_gtt_movemast
                    Select c.costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm'),0,0,0,0,0,0,0,0,p_batch_key_id
					From
						costmast c,
						deptphase d,
						rap_costcode_group rcg,
						rap_costcode_group_costcodes rcgc
				    Where
						c.costcode = d.costcode
						And c.costcode = rcgc.costcode
						And rcg.group_id = rcgc.group_id
						And c.tma_grp = 'P'
						And d.IsPrimary = 1
						And c.activity = 1
						And c.group_chart = 1
						And rcg.group_name = 'PROCUREMENT'
                        And rcgc.code = 'D'
                        And (c.costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm')) Not In
							(Select m.costcode, m.yymm From movemast m) ;

            When 'PROCO' Then
                Insert Into rap_gtt_movemast
                    Select c.costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm'),0,0,0,0,0,0,0,0,p_batch_key_id
					From
						costmast c,
						deptphase d,
						rap_costcode_group rcg,
						rap_costcode_group_costcodes rcgc
				    Where
						c.costcode = d.costcode
						And c.costcode = rcgc.costcode
						And rcg.group_id = rcgc.group_id
						And c.tma_grp In ('M','C')
						And d.IsPrimary = 1
						And c.activity = 1
						And c.group_chart = 1
						And rcg.group_name = 'PROCO'
                        And (c.costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm')) Not In
							(Select m.costcode, m.yymm From movemast m) ;

            When 'PROCO_MUMBAI' Then
                Insert Into rap_gtt_movemast
                    Select c.costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm'),0,0,0,0,0,0,0,0,p_batch_key_id
					From
						costmast c,
						deptphase d,
						rap_costcode_group rcg,
						rap_costcode_group_costcodes rcgc
				    Where
						c.costcode = d.costcode
						And c.costcode = rcgc.costcode
						And rcg.group_id = rcgc.group_id
						And c.tma_grp In ('M','C')
						And d.IsPrimary = 1
						And c.activity = 1
						And c.group_chart = 1
						And rcg.group_name = 'PROCO'
                        And rcgc.code Is Null
                        And (c.costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm')) Not In
							(Select m.costcode, m.yymm From movemast m) ;

            When 'PROCO_DELHI' Then
                Insert Into rap_gtt_movemast
                    Select c.costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm'),0,0,0,0,0,0,0,0,p_batch_key_id
					From
						costmast c,
						deptphase d,
						rap_costcode_group rcg,
						rap_costcode_group_costcodes rcgc
				    Where
						c.costcode = d.costcode
						And c.costcode = rcgc.costcode
						And rcg.group_id = rcgc.group_id
						And c.tma_grp In ('M','C')
						And d.IsPrimary = 1
						And c.activity = 1
						And c.group_chart = 1
						And rcg.group_name = 'PROCO'
                        And rcgc.code = 'D'
                        And (c.costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm')) Not In
							(Select m.costcode, m.yymm From movemast m) ;

         end case;
      End Loop;
      execute immediate p_insert_query || ' where '|| str_costcode || ' and yymm > :yymm ' using p_batch_key_id, p_yymm;
      rap_gtt.get_insert_query_4_gtt(p_yyyy, 'EXPTPRJC', p_insert_query, p_success, p_message);

      if p_success = 'OK' then
          execute immediate p_insert_query || ' where '|| str_costcode || ' and yymm > :yymm ' using p_yymm;
          rap_gtt.get_insert_query_4_gtt(p_yyyy, 'PRJCMAST', p_insert_query, p_success, p_message);
          if p_success = 'OK' then
            execute immediate p_insert_query || ' where '|| str_costcode || ' and yymm > :yymm ' using p_yymm;
            commit;

            select listagg( yymm || ' as "' || heading || '"', ', ') within group (order by yymm) into pivot_clause
            from (select yymm, heading from table(rap_reports.rpt_month_cols(v_new_yymm, p_mnths)));

            select listagg( ' sum(' ||  heading || ') as "' || heading || '"', ', ') within group (order by yymm) into aggregate_clause
                          from (select yymm, heading from table(rap_reports.rpt_month_cols(v_new_yymm, p_mnths)));
            -- General Data --------------------------------------------------------
            open p_gen for
              'Select sum(nvl(noofemps,0)) AS noofemps, sum(decode(nvl(changed_nemps,0),0,nvl(noofemps,0),nvl(changed_nemps,0))) as changed_nemps,
                 sum(nvl(noofcons,0)) as noofcons,  to_char(sysdate, ''dd-Mon-yyyy'') pdate from costmast
               where ' || str_costcode;
            -- Column names --------------------------------------------------------
            open p_cols for
              'select * from (
                select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :p_mnths))
              ) pivot (max(yymm) for yymm in ('|| pivot_clause ||'))'
            using v_new_yymm, p_mnths;
            -- All Data  --------------------------------------------------
            open p_alldata for
                  'select * from (
                      select yymm, name, last_value(working_hr) ignore nulls over (
                        order by yymm rows between unbounded preceding and current row) working_hr from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :p_mnths)) ),
                         t_data as ( select yymm, working_hr  from raphours where yymm > :p_yymm order by yymm )
                      select a.yymm, ''a'' as Name, b.working_hr from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm )
                    ) pivot (sum(working_hr) for yymm in ('|| pivot_clause ||'))
                    union
                    select * from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :p_mnths)) ),
                         t_data as ( select yymm,  sum(nvl(fut_recruit,0)) over(partition by costcode order by yymm) fut_recruit from rap_gtt_movemast
                         where ' || str_costcode || ' and yymm > :p_yymm order by yymm )
                      select a.yymm, ''b'' as Name, b.fut_recruit from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(fut_recruit) for yymm in ('|| pivot_clause ||'))
                    union
                    select * from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :p_mnths)) ),
                         t_data as ( select yymm, nvl(int_dept,0) int_dept from rap_gtt_movemast where ' || str_costcode || ' and yymm > :p_yymm order by yymm )
                      select a.yymm, ''c'' as Name, b.int_dept from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(int_dept) for yymm in ('|| pivot_clause ||'))
                    union
                    select * from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :p_mnths)) ),
                         t_data as ( select yymm, nvl(movetotcm,0) movetotcm from rap_gtt_movemast where ' || str_costcode || ' and yymm > :p_yymm order by yymm )
                      select a.yymm, ''d'' as Name, b.movetotcm from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(movetotcm) for yymm in ('|| pivot_clause ||'))
                    union
                    select * from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :p_mnths)) ),
                         t_data as ( select yymm, nvl(movetosite,0) movetosite from rap_gtt_movemast where ' || str_costcode || ' and yymm > :p_yymm order by yymm )
                      select a.yymm, ''e'' as Name, b.movetosite from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(movetosite) for yymm in ('|| pivot_clause ||'))
                    union
                    select * from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :p_mnths)) ),
                         t_data as ( select yymm, nvl(movetoothers,0) movetoothers from rap_gtt_movemast where ' || str_costcode || ' and yymm > :p_yymm order by yymm )
                      select a.yymm, ''f'' as Name, b.movetoothers from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(movetoothers) for yymm in ('|| pivot_clause ||'))
                    union
                    select * from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :p_mnths)) ),
                         t_data as ( select yymm, nvl(ext_subcontract,0) ext_subcontract from rap_gtt_movemast where ' || str_costcode || ' and yymm > :p_yymm order by yymm )
                      select a.yymm, ''g'' as Name, b.ext_subcontract from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(ext_subcontract) for yymm in ('|| pivot_clause ||')) '
                  using v_new_yymm, p_mnths, p_yymm,
                        v_new_yymm, p_mnths, p_yymm,
                        v_new_yymm, p_mnths, p_yymm,
                        v_new_yymm, p_mnths, p_yymm,
                        v_new_yymm, p_mnths, p_yymm,
                        v_new_yymm, p_mnths, p_yymm,
                        v_new_yymm, p_mnths, p_yymm;

            -- Overtime ------------------------------------------------------------
            open p_ot for
              'select * from (
                with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :p_mnths))  ),
                t_data as ( select yymm, ot from otmast where '|| str_costcode || ' and yymm >= :p_yymm )
                select a.yymm, b.ot from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
              ) pivot (sum(ot) for yymm in ('|| pivot_clause ||'))'
            using v_new_yymm, p_mnths, p_yymm;
            -- Projects ------------------------------------------------------------
              open p_project for
               'select * from
                (select newcostcode||''-''||rap_reports_gen.get_costcode_desc(newcostcode) newcostcode,
                projno, rap_reports_gen.get_proj_name(projno) name, rap_reports_gen.get_proj_cdate(projno) cdate,
                rap_reports_gen.get_proj_tcmno(projno) tcmno, '|| aggregate_clause ||', rap_reports_gen.get_proj_active(projno) active from (
                with t_yymm as (
                  select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :p_mnths))
                ),
                t_data as (
                  select a.projno, a.yymm, nvl(a.hours,0) as hrs from rap_gtt_prjcmast a, projmast b where a.projno = b.projno
                     and b.active > 0 and a.'|| str_costcode || ' and a.yymm > :p_yymm order by a.yymm
                )
                select (select newcostcode from projmast where projno = b.projno and active > 0) newcostcode,
                b.projno, a.yymm, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                ) pivot (sum(hrs) for yymm in ( '|| pivot_clause ||' ))
                group by newcostcode, projno order by newcostcode, projno)
                where newcostcode <> ''-''  '
              using v_new_yymm, p_mnths, p_yymm;
            -- Future ------------------------------------------------------------
              open p_future for
                'select * from
                (select newcostcode||''-''||rap_reports_gen.get_costcode_desc(newcostcode) newcostcode,
                projno, rap_reports_gen.get_exp_proj_name(projno) name, rap_reports_gen.get_exp_proj_activefuture(projno) activefuture,
                rap_reports_gen.get_exp_proj_tcmno(projno) tcmno, '|| aggregate_clause ||' , rap_reports_gen.get_exp_proj_active(projno) active from (
                with t_yymm as (
                  select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :p_mnths))
                ),
                t_data as (
                  select projno, yymm, nvl(hours,0) as hrs from rap_gtt_exptprjc where yymm > :p_yymm
                   and '|| str_costcode || ' order by yymm
                )
                select (select newcostcode from exptjobs where projno = b.projno and (active > 0 or activefuture > 0 ) '|| mfilter || ' ) newcostcode,
                b.projno, a.yymm, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                ) pivot (sum(hrs) for yymm in ( '|| pivot_clause ||' ))
                group by newcostcode, projno order by newcostcode, projno)
                where newcostcode <> ''-''  order by newcostcode, active desc, projno '
              using v_new_yymm, p_mnths, p_yymm;
              -- Subcontract ------------------------------------------------------------
              open p_subcont for
              'select * from (
                  with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :p_mnths)) ),
                     t_data as ( select yymm, nvl(hrs_subcont,0) hrs_subcont from rap_gtt_movemast where '|| str_costcode || ' and yymm > :p_yymm order by yymm )
                  select a.yymm, b.hrs_subcont from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                ) pivot (sum(hrs_subcont) for yymm in ('|| pivot_clause ||'))'
              using v_new_yymm, p_mnths, p_yymm;

          end if;
      end if;
    end if;
  end rpt_cha1e_category;

  procedure rpt_breakup(p_yymm in varchar2, p_category in varchar2, p_yearmode in varchar2, p_cols_mnth out sys_refcursor,
                        p_cols_period out sys_refcursor, p_mnthresults out sys_refcursor, p_periodresults out sys_refcursor) as
      pivot_clause_m varchar2(4000);
      pivot_clause_p varchar2(4000);
      str_costcode varchar2(1000);
      startYYMM varchar2(6);
    begin
      select rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode) into startYYMM from dual;
      case p_category
        when 'E' then
          select listagg( tmagrp || ' as "' || tmagrp || '"', ', ') within group (order by tmagrp) into pivot_clause_m
            from (select distinct tmagrp from rap_vu_rpt_breakup where yymm = p_yymm and costcode in (select costcode
              from costmast where tma_grp = 'E' and activity = 1 and group_chart = 1 and costcode in (select costcode
              from ts_costcode_group_costcode where costcode_group_id in ('CG001')) ));
          select listagg( tmagrp || ' as "' || tmagrp || '"', ', ') within group (order by tmagrp) into pivot_clause_p
            from (select distinct tmagrp from rap_vu_rpt_breakup where yymm >= startYYMM and yymm <= p_yymm and costcode in
              (select costcode from costmast where tma_grp = 'E' and activity = 1 and group_chart = 1 and costcode in
              (select costcode from ts_costcode_group_costcode where costcode_group_id in ('CG001')) ));
          str_costcode := ' and costcode in (select costcode from costmast where tma_grp = ''E''
                            and activity = 1 and group_chart = 1 and costcode in (select costcode
                            from ts_costcode_group_costcode where costcode_group_id in (''CG001'')) )';
        when 'N' then
          select listagg( tmagrp || ' as "' || tmagrp || '"', ', ') within group (order by tmagrp) into pivot_clause_m
            from (select distinct tmagrp from rap_vu_rpt_breakup where yymm = p_yymm and costcode in (select costcode
              from costmast where tma_grp in ('P','M','C') and activity = 1 and group_chart = 1 and costcode in (select costcode
              from ts_costcode_group_costcode where costcode_group_id in ('CG001'))));
          select listagg( tmagrp || ' as "' || tmagrp || '"', ', ') within group (order by tmagrp) into pivot_clause_p
            from (select distinct tmagrp from rap_vu_rpt_breakup where yymm >= startYYMM and yymm <= p_yymm
              and costcode in (select costcode from costmast where tma_grp in ('P','M','C') and activity = 1
              and group_chart = 1 and costcode in (select costcode from ts_costcode_group_costcode where costcode_group_id in ('CG001')) ));
          str_costcode := ' and costcode in (select costcode from costmast where tma_grp in (''P'',''M'',''C'')
                            and activity = 1 and group_chart = 1 and costcode in (select costcode
                            from ts_costcode_group_costcode where costcode_group_id in (''CG001'')) ) ';
        when 'B' then
          select listagg( tmagrp || ' as "' || tmagrp || '"', ', ') within group (order by tmagrp) into pivot_clause_m
            from (select distinct tmagrp from rap_vu_rpt_breakup where yymm = p_yymm and costcode in (select costcode
              from costmast where (tma_grp = 'E' or tma_grp = 'P' or tma_grp = 'C' or tma_grp = 'M')
                and activity = 1 and group_chart = 1 and costcode in (select costcode
                from ts_costcode_group_costcode where costcode_group_id in ('CG001'))));
          select listagg( tmagrp || ' as "' || tmagrp || '"', ', ') within group (order by tmagrp) into pivot_clause_p
            from (select distinct tmagrp from rap_vu_rpt_breakup where yymm >= startYYMM and yymm <= p_yymm
              and costcode in (select costcode from costmast where (tma_grp = 'E' or tma_grp = 'P' or tma_grp = 'C'
                or tma_grp = 'M') and activity = 1 and group_chart = 1 and costcode in (select costcode
                from ts_costcode_group_costcode where costcode_group_id in ('CG001'))));
          str_costcode := ' and costcode in (select costcode from costmast where (tma_grp = ''E''
                            or tma_grp = ''P'' or tma_grp = ''C'' or tma_grp = ''M'')
                            and activity = 1 and group_chart = 1 and costcode in (select costcode
                            from ts_costcode_group_costcode where costcode_group_id in (''CG001'')) )';
     end case;
     /*select listagg( tmagrp || ' as "' || tmagrp || '"', ', ') within group (order by tmagrp) into pivot_clause_m
       from (select distinct tmagrp from rap_vu_rpt_breakup where yymm = p_yymm
       );
     select listagg( tmagrp || ' as "' || tmagrp || '"', ', ') within group (order by tmagrp) into pivot_clause_p
       from (select distinct tmagrp from rap_vu_rpt_breakup where yymm >= startYYMM and yymm <= p_yymm);*/
     -- Column names for Month--------------------------------------------------------
     open p_cols_mnth for
       'select * from (
         select distinct tmagrp from rap_vu_rpt_breakup where yymm = :p_yymm '|| str_costcode || '
       ) pivot (max(tmagrp) for tmagrp in ('|| pivot_clause_m ||'))'
     using p_yymm;
     -- Column names for Month--------------------------------------------------------
     open p_cols_period for
       'select * from (
         select distinct tmagrp from rap_vu_rpt_breakup where yymm >= :startYYMM and yymm <= :p_yymm '|| str_costcode || '
       ) pivot (max(tmagrp) for tmagrp in ('|| pivot_clause_p ||'))'
     using startYYMM, p_yymm;
     -- Monthly Results names --------------------------------------------------------
     open p_mnthresults for
        'select * from (
           with t_data as ( select costcode, rap_reports_gen.get_costcode_desc(costcode) name, tmagrp,
                              nvl(sum(tothours),0) tothours from rap_vu_rpt_breakup
                              where yymm = :p_yymm '|| str_costcode || ' group by costcode, tmagrp)
          select tmagrp, costcode, name, tothours from t_data order by tmagrp
        ) pivot (sum(tothours) for tmagrp in ('|| pivot_clause_m ||'))
        order by costcode'
        using p_yymm;

     -- Period Results names --------------------------------------------------------
     open p_periodresults for
     'select * from (
           with t_data as ( select costcode, rap_reports_gen.get_costcode_desc(costcode) name, tmagrp,
                              nvl(sum(tothours),0) tothours from rap_vu_rpt_breakup
                              where yymm >= :startYYMM and yymm <= :p_yymm '|| str_costcode || ' group by costcode, tmagrp)
          select tmagrp, costcode, name, tothours from t_data order by tmagrp
        ) pivot (sum(tothours) for tmagrp in ('|| pivot_clause_p ||'))
        order by costcode'
        using startYYMM, p_yymm;
  end rpt_breakup;

  procedure move_months(p_projno in varchar2, p_mnths in number, p_msg out varchar2) as
    begin
      update exptprjc
        set yymm = to_char(add_months(to_date(yymm, 'yyyymm'), p_mnths), 'yyyymm')
        where projno = p_projno;
      p_msg := 'Done';
      exception
        when others then
          p_msg := 'error ';
  end move_months;

  procedure rpt_plantengg(p_costcode in varchar2, p_yymm in varchar2, p_cols out sys_refcursor, p_results out sys_refcursor) as
      pivot_clause varchar2(4000);
      noofmonths number;
      v_previous_yymm Varchar2(6);
    begin
      noofmonths := 15;
      select to_char(add_months(to_date(p_yymm,'yyyymm'),-14),'yyyymm') into v_previous_yymm from dual;

      -- Cols --------------------------------------------------------
      select listagg( yymm || ' as "' || heading || '"', ', ') within group (order by yymm) into pivot_clause
      from (select yymm, heading from table(rap_reports.rpt_month_cols(v_previous_yymm, noofmonths)));
       -- General Data --------------------------------------------------------
      open p_cols for
      'select * from (
          select yymm from table(rap_reports.rpt_month_cols(:v_previous_yymm, :noofmonths))
        ) pivot (max(yymm) for yymm in ('|| pivot_clause ||'))'
      using v_previous_yymm, noofmonths;
      -- Results Data --------------------------------------------------------
      open p_results for
          'select costcode, a, b, c, d, e, f, g, h, i , j, k, l, m, n, o from(
          select * from (select ''s1'' srno, yymm, costcode || '' ''|| name costcode, hours from plantengg
            where yymm >= :v_previous_yymm and yymm <= :p_yymm and costcode = :p_costcode
            ) pivot (sum(nvl(hours,0)) for yymm in ('|| pivot_clause ||'))
            union
            select * from (select ''s2'' srno, yymm, costcode || '' ''|| name costcode, overtime from plantengg
             where yymm >= :v_previous_yymm and yymm <= :p_yymm and costcode = :p_costcode
            ) pivot (sum(nvl(overtime,0)) for yymm in ('|| pivot_clause ||'))
            union
            select * from (select ''s3'' srno,  yymm, costcode || '' ''|| name costcode, total from plantengg
             where yymm >= :v_previous_yymm and yymm <= :p_yymm and costcode = :p_costcode
            ) pivot (sum(nvl(total,0)) for yymm in ('|| pivot_clause ||')) )'
        using v_previous_yymm, p_yymm, p_costcode, v_previous_yymm, p_yymm, p_costcode, v_previous_yymm, p_yymm, p_costcode;
  end rpt_plantengg;


end rap_reports_c;

/
