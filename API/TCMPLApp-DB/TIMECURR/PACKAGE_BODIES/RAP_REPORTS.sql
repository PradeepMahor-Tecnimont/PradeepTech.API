--------------------------------------------------------
--  DDL for Package Body RAP_REPORTS
--------------------------------------------------------

  create or replace PACKAGE BODY "TIMECURR"."RAP_REPORTS" as

 /* Month Columns */
  function rpt_month_cols(p_yymm in varchar2, p_month in number) return t_tab_yymm as
      v_results t_tab_yymm;
    begin
     /*select t_rec_yymm(to_char(add_months(to_date(p_yymm,'yyyymm') ,n-1),'yyyymm'), chr(64 + n)) bulk collect into v_results from
        (select rownum n from (select 1 just_a_column from dual connect by level <= p_month)); */
      select t_rec_yymm(to_char(add_months(to_date(p_yymm,'yyyymm'), n-1),'yyyymm'), alpha) bulk collect into v_results from
      (with alpha as (select chr(level+65-1) letter from dual connect by level <= 26 ),
        xls1 as (select a.letter||b.letter alpha from alpha a,alpha b),
        letters as (select xls1.alpha from xls1 union select letter from alpha),
        output as ( select row_number() over (order by length(alpha),alpha) n, alpha from letters l )
        select * from output where rownum <= p_month);
      return v_results;
  end rpt_month_cols;

  function getWorkingHrs(p_yymm in varchar2) return number as
      v_workinghrs number(7,2);
    begin
      select nvl(working_hr,0) into v_workinghrs from raphours
        where yymm = p_yymm;
    return v_workinghrs;
  end getWorkingHrs;

  function getCummFutRecruit(p_costcode in varchar2, p_yymm_start in varchar2, p_yymm_end in varchar2) return number as
     v_futrecruit number(7,2);
    begin
      select sum(nvl(fut_recruit,0)) into v_futrecruit from movemast
        where yymm >= p_yymm_start and yymm <= p_yymm_end and costcode = p_costcode;
    return v_futrecruit;
  end getCummFutRecruit;

  procedure cha1_costcodes(p_results out sys_refcursor) as
    begin
      open p_results for
      'select costcode from costmast where (tma_grp = ''E''
        or tma_grp = ''P'' or tma_grp = ''C'' or tma_grp = ''M'')
        and activity = 1 and group_chart = 1 ';
        --and activity = 1 and group_chart = 1 and costcode like ''02%'' ';
  end cha1_costcodes;

  procedure get_cha1_process_list(p_yyyy in varchar2, p_user in varchar2, p_results out sys_refcursor) as
    begin
      open p_results for
        'select * from ngts_cha1_process where yyyy = :p_yyyy and user = :p_user order by sdate'
      using p_yyyy, p_user;
  end get_cha1_process_list;

  procedure update_cha1_process(p_keyid in varchar2, p_user in varchar2, p_yyyy in varchar2, p_yymm in varchar2, p_msg out varchar2) as
      vCount number := 0;
    begin
      select count(*) into vCount from rap_cha1_process where keyid = p_keyid and userid = p_user;
      if vCount = 0 then
        insert into rap_cha1_process(keyid, userid, email, yyyy, yymm, iscomplete, sdate)
         values (p_keyid, p_user, ngts_users.ngts_getemail(p_user), p_yyyy, p_yymm, 0, sysdate);
      else
        update rap_cha1_process
          set iscomplete = 1, edate = sysdate
          where keyid = p_keyid and userid = p_user and yymm = p_yymm;
      end if;
      p_msg := 'Done';
     exception
        when others then
          p_msg := 'error ';
  end update_cha1_process;


  /* CHA1 Expected */
  procedure rpt_cha1_expt(p_timesheet_yyyy in varchar2, p_yymm in varchar2, p_costcode in varchar2, p_cols out sys_refcursor,
                          p_gen out sys_refcursor, p_alldata out sys_refcursor, p_ot out sys_refcursor,
                          p_project out sys_refcursor, p_future out sys_refcursor, p_subcont out sys_refcursor) as
      pivot_clause varchar2(4000);
      aggregate_clause varchar2(4000);
      noofmonths number;
      p_batch_key_id varchar2(8);
      p_insert_query Varchar2(10000);
      p_success Varchar2(2);
      p_message Varchar2(4000);
      v_new_yymm Varchar2(6);
    begin
      noofmonths := 18;
      select to_char(add_months(to_date(p_yymm,'yyyymm'),1),'yyyymm') into v_new_yymm from dual;

      select substr(SYS_GUID(),0,8) into p_batch_key_id from dual;
      -- Populate GTT tbales ---------------------------------------------------
      rap_gtt.get_insert_query_4_gtt(p_timesheet_yyyy, 'MOVEMAST', p_insert_query, p_success, p_message);
      if p_success = 'OK' then
          For i in 1..noofmonths Loop
                Insert Into rap_gtt_movemast
                    Select p_costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm'),0,0,0,0,0,0,0,0,p_batch_key_id From dual
                        Where (p_costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm')) not in
                    (select costcode, yymm from movemast) ;
          End Loop;
          execute immediate p_insert_query || ' where costcode = trim(:costcode) and yymm > :yymm ' using p_batch_key_id, p_costcode, p_yymm;
          rap_gtt.get_insert_query_4_gtt(p_timesheet_yyyy, 'EXPTPRJC', p_insert_query, p_success, p_message);
          if p_success = 'OK' then
              execute immediate p_insert_query || ' where costcode = trim(:costcode) and yymm > :yymm ' using p_costcode, p_yymm;
              rap_gtt.get_insert_query_4_gtt(p_timesheet_yyyy, 'PRJCMAST', p_insert_query, p_success, p_message);
              if p_success = 'OK' then
                  execute immediate p_insert_query || ' where costcode = trim(:costcode) and yymm > :yymm ' using p_costcode, p_yymm;
                  commit;

                  select listagg( yymm || ' as "' || heading || '"', ', ') within group (order by yymm) into pivot_clause
                  from (select yymm, heading from table(rap_reports.rpt_month_cols(v_new_yymm, noofmonths)));

                  select listagg( ' sum(' ||  heading || ') as "' || heading || '"', ', ') within group (order by yymm) into aggregate_clause
                  from (select yymm, heading from table(rap_reports.rpt_month_cols(v_new_yymm, noofmonths)));

                  -- General Data --------------------------------------------------------
                  /*open p_gen for
                  'select a.costcode, a.abbr, a.noofemps, a.changed_nemps, initcap(b.name) name,
                    to_char(sysdate, ''dd-Mon-yyyy'') pdate, a.noofcons from costmast a, emplmast b
                    where a.hod = b.empno and costcode = :p_costcode'
                using p_costcode, */
                open p_gen for
                  'Select a.costcode, a.abbr, sum(nvl(a.noofemps,0)) AS noofemps,
                     sum(decode(nvl(a.changed_nemps,0),0,nvl(a.noofemps,0),nvl(a.changed_nemps,0))) as changed_nemps,
                     initcap(b.name) name, to_char(sysdate, ''dd-Mon-yyyy'') pdate,
                     sum(nvl(a.noofcons,0)) as noofcons from costmast a, emplmast b
                   where a.hod = b.empno and costcode = :p_costcode group by a.costcode, a.abbr, b.name'
                 using p_costcode;
                  -- Column names --------------------------------------------------------
                  open p_cols for
                    'select * from (
                      select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths))
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
                         t_data as ( select yymm,  sum(nvl(fut_recruit,0)) over(partition by costcode order by yymm) fut_recruit from rap_gtt_movemast
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
                    with t_yymm as (
                      select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths))
                    ),
                    t_data as (
                      select yymm, ot from otmast where costcode = :p_costcode and yymm > :p_yymm order by yymm
                    )
                    select a.yymm, b.ot from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                  ) pivot (sum(ot) for yymm in ('|| pivot_clause ||'))'
                  using v_new_yymm, noofmonths, p_costcode, p_yymm;

                  -- Projects ------------------------------------------------------------
                  open p_project for
                    'select * from
                    (select newcostcode||''-''||rap_reports_gen.get_costcode_desc(newcostcode) newcostcode,
                    projno,
                    rap_reports_gen.get_proj_name(projno) name, rap_reports_gen.get_proj_cdate(projno) cdate,
                    rap_reports_gen.get_proj_tcmno(projno) tcmno, '|| aggregate_clause ||', rap_reports_gen.get_proj_active(projno) active from (
                    with t_yymm as (
                      select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths))
                    ),
                    t_data as (
                      select a.projno, a.yymm, nvl(a.hours,0) as hrs from rap_gtt_prjcmast a, projmast b where a.projno = b.projno
                        and b.active > 0 and a.costcode = :p_costcode and a.yymm > :p_yymm order by a.yymm
                    )
                    select (select x.newcostcode from projmast x where x.projno = b.projno) newcostcode,
                    b.projno, a.yymm, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(hrs) for yymm in ('|| pivot_clause ||'))
                    group by newcostcode, projno order by newcostcode, projno)
                    where (newcostcode <> ''-'') '
                  using v_new_yymm, noofmonths, p_costcode, p_yymm;

                  -- Future ------------------------------------------------------------
                  open p_future for
                    'select * from
                    (select newcostcode||''-''||rap_reports_gen.get_costcode_desc(newcostcode) newcostcode,
                    projno, rap_reports_gen.get_exp_proj_name(projno) name, rap_reports_gen.get_exp_proj_activefuture(projno) activefuture,
                    rap_reports_gen.get_exp_proj_tcmno(projno) tcmno, '|| aggregate_clause || ', rap_reports_gen.get_exp_proj_active(projno) active from (
                    with t_yymm as (
                      select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths))
                    ),
                    t_data as (
                      select projno, yymm, nvl(hours,0) as hrs from rap_gtt_exptprjc where costcode = :p_costcode and yymm > :p_yymm order by yymm
                    )
                    select (select x.newcostcode from exptjobs x where x.projno = b.projno and (x.active = 1 or x.activefuture = 1)) newcostcode,
                    b.projno, a.yymm, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(hrs) for yymm in ('|| pivot_clause ||'))
                    group by newcostcode, projno order by newcostcode, projno)
                    where (newcostcode <> ''-'') order by newcostcode, active desc, projno'
                  using v_new_yymm, noofmonths, p_costcode, p_yymm;

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
  end rpt_cha1_expt;

  /* CHA1 Expected Simulation */
   procedure rpt_cha1_expt_simul(p_yymm in varchar2, p_costcode in varchar2, p_simul in varchar2, p_cols out sys_refcursor,
                                p_gen out sys_refcursor, p_alldata out sys_refcursor, p_ot out sys_refcursor,
                                p_project out sys_refcursor, p_future out sys_refcursor, p_subcont out sys_refcursor) as
      pivot_clause varchar2(4000);
      aggregate_clause varchar2(4000);
      noofmonths number;
	  mfilter varchar2(1000);
      p_yyyy Varchar2(7);
      p_batch_key_id varchar2(8);
      p_insert_query Varchar2(10000);
      p_success Varchar2(2);
      p_message Varchar2(4000);
      v_new_yymm Varchar2(6); -- added 25-03-22
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

      select extract (year from add_months (to_date(p_yymm,'yyyymm'), -3))
         || '-'
         || substr(extract (year from add_months (to_date(p_yymm,'yyyymm'), 9)), 3, 2) into p_yyyy
      from dual;           
      
      select substr(SYS_GUID(),0,8) into p_batch_key_id from dual;
      -- Populate GTT tbales ---------------------------------------------------
      rap_gtt.get_insert_query_4_gtt(p_yyyy, 'MOVEMAST', p_insert_query, p_success, p_message);
      if p_success = 'OK' then
          For i in 1..noofmonths Loop
                Insert Into rap_gtt_movemast
                    Select p_costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm'),0,0,0,0,0,0,0,0,p_batch_key_id From dual
                        Where (p_costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm')) not in
                    (select costcode, yymm from movemast) ;
          End Loop;

          execute immediate p_insert_query || ' where costcode = trim(:costcode) and yymm > :yymm ' using p_batch_key_id, p_costcode, p_yymm;
          rap_gtt.get_insert_query_4_gtt(p_yyyy, 'EXPTPRJC', p_insert_query, p_success, p_message);
          if p_success = 'OK' then
              execute immediate p_insert_query || ' where costcode = trim(:costcode) and yymm > :yymm ' using p_costcode, p_yymm;
              rap_gtt.get_insert_query_4_gtt(p_yyyy, 'PRJCMAST', p_insert_query, p_success, p_message);
              if p_success = 'OK' then
                  execute immediate p_insert_query || ' where costcode = trim(:costcode) and yymm > :yymm ' using p_costcode, p_yymm;
                  commit;
                  select listagg( yymm || ' as "' || heading || '"', ', ') within group (order by yymm) into pivot_clause
                  from (select yymm, heading from table(rap_reports.rpt_month_cols(v_new_yymm, noofmonths)));

                  select listagg( ' sum(' ||  heading || ') as "' || heading || '"', ', ') within group (order by yymm) into aggregate_clause
                  from (select yymm, heading from table(rap_reports.rpt_month_cols(v_new_yymm, noofmonths)));
                  -- General Data --------------------------------------------------------
                  /*open p_gen for
                  'select a.costcode, a.abbr, a.noofemps, a.changed_nemps, initcap(b.name) name,
                    to_char(sysdate, ''dd-Mon-yyyy'') pdate, a.noofcons from costmast a, emplmast b
                    where a.hod = b.empno and costcode = :p_costcode'
                  using p_costcode;*/
                  open p_gen for
                  'Select a.costcode, a.abbr, sum(nvl(a.noofemps,0)) AS noofemps,
                     sum(decode(nvl(a.changed_nemps,0),0,nvl(a.noofemps,0),nvl(a.changed_nemps,0))) as changed_nemps,
                     initcap(b.name) name, to_char(sysdate, ''dd-Mon-yyyy'') pdate,
                     sum(nvl(a.noofcons,0)) as noofcons from costmast a, emplmast b
                   where a.hod = b.empno and costcode = :p_costcode group by a.costcode, a.abbr, b.name'
                 using p_costcode;
                  -- Column names --------------------------------------------------------
                  open p_cols for
                    'select * from (
                      select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths))
                    ) pivot (max(yymm) for yymm in ('|| pivot_clause ||'))'
                  using v_new_yymm, noofmonths;
                  -- All Data  --------------------------------------------------
                  open p_alldata for
                  'select * from (
                     select yymm, name, last_value(working_hr) ignore nulls over (
                        order by yymm rows between unbounded preceding and current row) working_hr from (
                          with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                             t_data as ( select yymm, nvl(working_hr,0) working_hr from raphours where yymm > :p_yymm order by yymm )
                          select a.yymm, ''a'' as Name, b.working_hr from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm)
                    ) pivot (sum(working_hr) for yymm in ('|| pivot_clause ||'))
                    union
                    select * from (
                      with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                         t_data as ( select yymm, sum(nvl(fut_recruit,0)) over(partition by costcode order by yymm) fut_recruit
                         from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
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
                    with t_yymm as (
                      select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths))
                    ),
                    t_data as (
                      select yymm, ot from otmast where costcode = :p_costcode and yymm > :p_yymm order by yymm
                    )
                    select a.yymm, b.ot from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                  ) pivot (sum(ot) for yymm in ('|| pivot_clause ||'))'
                  using v_new_yymm, noofmonths, p_costcode, p_yymm;
                  -- Projects ------------------------------------------------------------
                 open p_project for
                    'select * from
                    (select newcostcode||''-''||rap_reports_gen.get_costcode_desc(newcostcode) newcostcode,
                    projno, rap_reports_gen.get_proj_name(projno) name, rap_reports_gen.get_proj_cdate(projno) cdate,
                    rap_reports_gen.get_proj_tcmno(projno) tcmno, '|| aggregate_clause ||', rap_reports_gen.get_proj_active(projno) active from (
                    with t_yymm as (
                      select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths))
                    ),
                    t_data as (
                      select a.projno, a.yymm, nvl(a.hours,0) as hrs from rap_gtt_prjcmast a, projmast b where a.projno = b.projno
                        and b.active > 0 and a.costcode = :p_costcode and a.yymm > :p_yymm order by a.yymm
                    )
                    select (select x.newcostcode from projmast x where x.projno = b.projno) newcostcode,
                    b.projno, a.yymm, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(hrs) for yymm in ('|| pivot_clause ||'))
                    group by newcostcode, projno order by newcostcode, projno)
                    where newcostcode <> ''-'' '
                  using v_new_yymm, noofmonths, p_costcode, p_yymm;
                  -- Future ------------------------------------------------------------
                  open p_future for
                    'select * from
                    (select newcostcode||''-''||rap_reports_gen.get_costcode_desc(newcostcode) newcostcode,
                    projno, rap_reports_gen.get_exp_proj_name(projno) name, rap_reports_gen.get_exp_proj_activefuture(projno) activefuture,
                    rap_reports_gen.get_exp_proj_tcmno(projno) tcmno, '|| aggregate_clause ||', rap_reports_gen.get_exp_proj_active(projno) active from (
                    with t_yymm as (
                      select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths))
                    ),
                    t_data as (
                      select projno, yymm, nvl(hours,0) as hrs from rap_gtt_exptprjc where costcode = :p_costcode
                        and yymm > :p_yymm order by yymm
                    )
                    select (select x.newcostcode from exptjobs x where x.projno = b.projno and (x.active = 1 or x.activefuture = 1) ' || mfilter || ') newcostcode,
                    b.projno, a.yymm, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                    ) pivot (sum(hrs) for yymm in ('|| pivot_clause ||'))
                    group by newcostcode, projno order by newcostcode, projno)
                    where newcostcode <> ''-'' order by newcostcode, active desc, projno'
                  using v_new_yymm, noofmonths, p_costcode, p_yymm;
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


  end rpt_cha1_expt_simul;


  /* TM11 TM01 */
  procedure rpt_tm11_tm01(p_projno in varchar2, p_yymm in varchar2, p_yearmode in varchar2,
                          p_yyyy in varchar2, p_cols out sys_refcursor, p_gen out sys_refcursor,
                          p_part1 out sys_refcursor, p_part2 out sys_refcursor,
                          p_part3 out sys_refcursor, p_part4 out sys_refcursor,
                          p_part5 out sys_refcursor, p_part6 out sys_refcursor, p_tm11data out sys_refcursor) as
      pivot_clause varchar2(4000);
      noofmonths number;
      strPrcMnth varchar2(6);
      strYrStart varchar2(6);
      strEndMnth varchar2(6);
      v_new_yymm Varchar2(6);
      p_insert_query Varchar2(10000);
	  p_success Varchar2(2);
      p_message Varchar2(4000);
    begin
      strPrcMnth := p_yymm;
      select to_char(add_months(to_date(p_yymm,'yyyymm'),1),'yyyymm') into v_new_yymm from dual;
      select rap_reports_gen.get_actual_start_month(v_new_yymm, p_yymm, p_yearmode) into strYrStart from dual;

      select to_char(add_months(to_date(v_new_yymm,'yyyymm'), 12),'yyyymm') into strEndMnth from dual;
      noofmonths := 12;
      select listagg( yymm || ' as "' || heading || '"', ', ') within group (order by yymm) into pivot_clause
      from (select yymm, heading from table(rap_reports.rpt_month_cols(v_new_yymm, noofmonths)));
      -- General Data --------------------------------------------------------
      open p_cols for
      'select * from (
          select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths))
        ) pivot (max(yymm) for yymm in ('|| pivot_clause ||'))'
      using v_new_yymm, noofmonths;

      -- General Data --------------------------------------------------------
      open p_gen for
      'select distinct substr(a.projno, 1, 5) projno, a.name, a.active, a.cdate, a.Tcmno,
       b.name Prjdymngrname, c.name Prjmngrname, to_char(sysdate,''dd-Mon-yyyy'') processdate
       from projmast a, emplmast b, emplmast c
       where a.prjmngr = b.empno and a.prjdymngr = c.empno(+) and substr(a.proj_no, 1, 5) = substr(:p_projno, 1, 5)'
      using p_projno;

      rap_gtt.get_insert_query_4_gtt(p_yyyy, 'OPENMAST', p_insert_query, p_success, p_message);
      if p_success = 'OK' then
          execute immediate p_insert_query;
          rap_gtt.get_insert_query_4_gtt(p_yyyy, 'BUDGMAST', p_insert_query, p_success, p_message);
          if p_success = 'OK' then
              execute immediate p_insert_query;
              rap_gtt.get_insert_query_4_gtt(p_yyyy, 'PRJCMAST', p_insert_query, p_success, p_message);
              if p_success = 'OK' then
                  execute immediate p_insert_query;
                  rap_gtt.get_insert_query_4_gtt(p_yyyy, 'TIMETRAN', p_insert_query, p_success, p_message);
                  if p_success = 'OK' then
                      execute immediate p_insert_query;
                      commit;
                      -- Part1 Data --------------------------------------------------------
                      open p_part1 for
                      'select t_1.costcode, t_1.name, t_1.phase, t_2.original, t_2.revised, t_4.currmnth, t_5.curryear,
                        (nvl(t_5.curryear,0) + nvl(t_3.opening,0)) opening, t_6.*, t_7.next_total, t_8.next_total_1 from
                        (select distinct costcode, name, phase from costmast where cost_type = ''D'' and (
                            costcode in (select distinct costcode from rap_gtt_budgmast
                            where projno in (select projno from ProjMast where proj_no = substr(:p_projno,1,5))) or
                            costcode in (select distinct costcode from rap_gtt_openmast
                            where projno in (select projno from ProjMast where proj_no = substr(:p_projno,1,5))) or
                            costcode in (select distinct costcode from rap_gtt_prjcmast
                            where projno in (select projno from ProjMast where proj_no = substr(:p_projno,1,5)) and yymm > :strPrcMnth) or
                            costcode in (select distinct costcode from rap_gtt_timetran
                            where projno in (select projno from ProjMast where proj_no = substr(:p_projno,1,5)) and
                            yymm >= :strYrStart and yymm <= :strPrcMnth)) order by phase,costcode) t_1,
                       (select costcode, sum(nvl(original,0))as original, sum(nvl(revised,0))as revised
                            from rap_gtt_budgmast where projno in (select projno from projmast where proj_no = :p_projno)
                            group by costcode order by costcode) t_2,
                       (select costcode, case ''' || p_yearmode || ''' when ''J'' then sum(nvl(open01,0)) else sum(nvl(open04,0)) end as opening
                            from rap_gtt_openmast where projno in (select projno from projmast where proj_no = substr(:p_projno,1,5))
                            group by costcode order by costcode) t_3,
                       (select costcode,sum(nvl(hours,0)) + sum(nvl(othours,0)) as currmnth from rap_gtt_timetran where
                            projno in (select projno from projmast where proj_no = substr(:p_projno,1,5)) and yymm = :strPrcMnth
                            group by costcode order by costcode) t_4,
                       (select costcode,sum(nvl(hours,0)) + sum(nvl(othours,0)) as curryear from rap_gtt_timetran
                        where projno in (select projno from projmast where proj_no = substr(:p_projno,1,5))
                        and yymm >= :strYrStart and yymm <= :strPrcMnth
                        group by costcode order by costcode) t_5,
                       (select * from (
                            with t_yymm as (
                              select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, 12))
                            ),
                            t_data as (
                              select yymm,costcode,sum(nvl(hours,0)) as hours from rap_gtt_prjcmast
                                where projno in (select projno from projmast where proj_no = substr(:p_projno,1,5))
                                and yymm >= :v_new_yymm and yymm <= :strEndMnth
                                group by costcode,yymm order by costcode,yymm
                            )
                            select a.yymm,b.costcode, b.hours from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                          ) pivot (sum(hours) for yymm in ('|| pivot_clause ||'))
                          order by costcode) t_6,
                          (select costcode, sum(nvl(hours,0)) as next_total from rap_gtt_prjcmast
                            where projno in (select projno from projmast where proj_no = substr(:p_projno,1,5))  and yymm >= :v_new_yymm
                            and yymm <= to_char(add_months(to_date(:strPrcMnth, ''yyyymm''), 12), ''yyyymm'')
                            group by costcode order by costcode) t_7,
                          (select costcode, sum(nvl(hours,0)) as next_total_1 from rap_gtt_prjcmast
                            where projno in (select projno from projmast where proj_no = substr(:p_projno,1,5))
                            and yymm > to_char(add_months(to_date(:strPrcMnth, ''yyyymm''), 12), ''yyyymm'')
                            group by costcode order by costcode) t_8
                        where t_1.costcode = t_2.costcode(+) and t_1.costcode = t_3.costcode(+) and t_1.costcode = t_4.costcode(+)
                            and t_1.costcode = t_5.costcode(+) and t_1.costcode = t_6.costcode(+) and t_1.costcode = t_7.costcode(+)
                            and t_1.costcode = t_8.costcode(+)'
                      using p_projno, p_projno, p_projno, strPrcMnth, p_projno, strYrStart, strPrcMnth,
                        p_projno,
                        p_projno,
                        p_projno, strPrcMnth,
                        p_projno, strYrStart, strPrcMnth,
                        v_new_yymm, p_projno, v_new_yymm, strEndMnth,
                        p_projno, v_new_yymm, strPrcMnth,
                        p_projno, strPrcMnth;
                      -- Part2 Data --------------------------------------------------------
                      open p_part2 for
                        'select case p.emptype when ''R'' then ''TCMPL Personnel'' when ''C'' then ''Consultants''
                            when ''S'' then ''SubContract'' when ''F'' then ''FTC'' when ''O'' then ''SubContract - Out of Office''
                            else '''' end emptype, q.totmnhrs, p.totyrhrs  from (
                        select b.emptype, sum(nvl(a.hours,0)) + sum(nvl(a.othours,0)) as totyrhrs
                        from rap_gtt_timetran a, emplmast b where b.empno = a.empno
                        and a.yymm >= :strYrStart and yymm <= :strPrcMnth and substr(a.projno,1,5) = substr(:p_projno,1, 5)
                        group by b.emptype) p left outer join (
                        select b.emptype, sum(nvl(a.hours,0)) + sum(nvl(a.othours,0)) as totmnhrs
                        from rap_gtt_timetran a, emplmast b where b.empno = a.empno and a.yymm = :strPrcMnth
                        and substr(a.projno,1,5) = substr(:p_projno,1, 5)
                        group by b.emptype) q on p.emptype = q.emptype'
                      using strYrStart, strPrcMnth, p_projno, strPrcMnth, p_projno ;
                      -- Part3 Data --------------------------------------------------------
                    /*  open p_part3 for
                      'select case a.emptype when ''R'' then ''TCMPL Personnel'' when ''C'' then ''Consultants''
                            when ''S'' then ''SubContract'' when ''F'' then ''FTC'' when ''O'' then ''SubContract - Out of Office''  else ''Not Defined'' end emptype,
                            case a.location when ''E'' then ''Employees'' when ''H'' then ''Head Office''
                            when ''I'' then ''Sites - India'' when ''A'' then ''Sites - Foreign'' else ''Not Defined'' end location,
                            sum(a.monhrs) monhrs, sum(a.YrHrs) yrhrs from
                        ((select e.emptype, e.location, sum(nvl(t.hours,0)) + sum(nvl(t.othours,0)) as Monhrs,
                        0 as YrHrs from rap_gtt_timetran t, emplmast e where e.empno = t.empno and t.yymm = :strPrcMnth
                        and substr(t.projno,1,5) = substr(:p_projno,1, 5) group by e.emptype, e.location)
                        Union
                        (select e.emptype, e.location,0 as MonHrs, sum(nvl(t.hours,0)) + sum(nvl(t.othours,0)) as Yrhrs
                        from rap_gtt_timetran t, emplmast e where e.empno = t.empno and t.yymm >= :strYrStart and yymm <= :strPrcMnth
                        and substr(t.projno,1,5) = substr(:p_projno,1, 5) group by e.emptype, e.location)) a
                        group by a.emptype,a.location order  by a.emptype,a.location'
                      using strPrcMnth, p_projno, strYrStart, strPrcMnth, p_projno;*/
                      -- Part4 Data --------------------------------------------------------
                      open p_part4 for
                      'select nvl(a.description,'' '') description,b.empdesc emptype, a.projno,sum(a.monhrs) monhrs,sum(a.yrhrs) yrhrs
                        from ((select e1.emptype, e1.subcontract, t1.projno, s1.description,
                        sum(nvl(t1.hours, 0)) + sum(nvl(t1.othours, 0))
                        as monhrs, 0 as yrhrs from rap_gtt_timetran t1, emplmast e1, subcontractmast s1
                        where e1.empno(+) = t1.empno and s1.subcontract(+) = e1.subcontract
                        and t1.yymm = :strPrcMnth and substr(t1.projno,1,5) = substr(:p_projno,1, 5)
                        group by e1.emptype,e1.subcontract,t1.projno,s1.description)
                        union
                        (select e2.emptype, e2.subcontract, t2.projno, s2.description,
                        0 as monhrs, sum(nvl(t2.hours,0)) + sum(nvl(t2.othours,0)) as yrhrs
                        from rap_gtt_timetran t2, emplmast e2, subcontractmast s2 where e2.empno(+) = t2.empno
                        and t2.yymm >= :strYrStart and yymm <= :strPrcMnth
                        and substr(t2.projno,1,5) = substr(:p_projno,1, 5)
                        and s2.subcontract(+) = e2.subcontract
                        group by e2.emptype, e2.subcontract, t2.projno, s2.description) ) a , EMPTYPEMAST B
                        WHERE A.EMPTYPE = B.emptype
                        group by a.projno, b.empdesc, a.subcontract, a.description
                        order by a.projno, b.empdesc, a.subcontract, a.description'
                    using strPrcMnth, p_projno, strYrStart, strPrcMnth, p_projno;
                    -- Part5 Data --------------------------------------------------------
                    open p_part5 for
                      'select t_1.costcode, t_1.name, t_1.phase, t_2.original, t_2.revised,
                        t_4.currmnth_o, t_4.currmnth_r, (nvl(t_4.currmnth_o,0) + nvl(t_4.currmnth_r,0)) currmnth_all,
                        t_5.curryear_o, t_5.curryear_r, (nvl(t_5.curryear_o,0) + nvl(t_5.curryear_r,0)) curryear_all,
                        t_3.currtot_o, t_3.currtot_r, (nvl(t_3.currtot_o,0) + nvl(t_3.currtot_r,0)) currtot_all,
                        t_6.*, t_7.next_total, t_8.next_total_1 from
                        (select distinct costcode, name, phase from costmast where cost_type = ''D'' and (
                            costcode in (select distinct costcode from rap_gtt_budgmast
                            where projno in (select projno from ProjMast where proj_no = substr(:p_projno,1,5))) or
                            costcode in (select distinct costcode from rap_gtt_openmast
                            where projno in (select projno from ProjMast where proj_no = substr(:p_projno,1,5))) or
                            costcode in (select distinct costcode from rap_gtt_prjcmast
                            where projno in (select projno from ProjMast where proj_no = substr(:p_projno,1,5)) and yymm > :strPrcMnth) or
                            costcode in (select distinct costcode from rap_gtt_timetran
                            where projno in (select projno from ProjMast where proj_no = substr(:p_projno,1,5)) and
                            yymm >= :strYrStart and yymm <= :strPrcMnth)) order by phase,costcode) t_1,
                       (select costcode, sum(nvl(original,0))as original, sum(nvl(revised,0))as revised
                            from rap_gtt_budgmast where projno in (select projno from projmast where proj_no = :p_projno)
                            group by costcode order by costcode) t_2,
                       (select costcode, o as currtot_o, r as currtot_r from
                           (select a3.costcode, case b3.emptype when ''O'' then ''O'' else ''R'' end emptype,
                            sum(nvl(a3.hours,0)) + sum(nvl(a3.othours,0)) hours
                                from timetran_combine a3, emplmast b3 where a3.empno = b3.empno and
                                a3.projno in (select projno from projmast where proj_no = substr(:p_projno,1,6))
                                and yymm <= :strPrcMnth
                                group by a3.costcode, case b3.emptype when ''O'' then ''O'' else ''R'' end)
                                pivot (sum(hours) for emptype in (''O'' as "O", ''R'' as "R"))
                                order by costcode) t_3,
                       (select costcode, o as currmnth_o, r as currmnth_r from
                            (select a4.costcode, case b4.emptype when ''O'' then ''O'' else ''R'' end emptype,
                               sum(nvl(a4.hours,0)) + sum(nvl(a4.othours,0)) hours
                                from timetran_combine a4, emplmast b4 where a4.empno = b4.empno and
                                a4.projno in (select projno from projmast where proj_no = substr(:p_projno,1,5)) and a4.yymm = :strPrcMnth
                                group by a4.costcode, case b4.emptype when ''O'' then ''O'' else ''R'' end)
                                pivot (sum(hours) for emptype in (''O'' as "O", ''R'' as "R"))
                                order by costcode) t_4,
                       (select costcode, o as curryear_o, r as curryear_r from
                           (select a5.costcode, case b5.emptype when ''O'' then ''O'' else ''R'' end emptype,
                            sum(nvl(a5.hours,0)) + sum(nvl(a5.othours,0)) hours
                                from timetran_combine a5, emplmast b5 where a5.empno = b5.empno and
                                a5.projno in (select projno from projmast where proj_no = substr(:p_projno,1,5))
                                and yymm >= :strYrStart and yymm <= :strPrcMnth
                                group by a5.costcode, case b5.emptype when ''O'' then ''O'' else ''R'' end)
                                pivot (sum(hours) for emptype in (''O'' as "O", ''R'' as "R"))
                                order by costcode) t_5,
                       (select * from (
                            with t_yymm as (
                              select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, 12))
                            ),
                            t_data as (
                              select yymm,costcode,sum(nvl(hours,0)) as hours from rap_gtt_prjcmast
                                where projno in (select projno from projmast where proj_no = substr(:p_projno,1,5))
                                and yymm >= :v_new_yymm and yymm <= :strEndMnth
                                group by costcode,yymm order by costcode,yymm
                            )
                            select a.yymm,b.costcode, b.hours from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                          ) pivot (sum(hours) for yymm in ('|| pivot_clause ||'))
                          order by costcode) t_6,
                          (select costcode, sum(nvl(hours,0)) as next_total from rap_gtt_prjcmast
                            where projno in (select projno from projmast where proj_no = substr(:p_projno,1,5))  and yymm >= :v_new_yymm
                            and yymm <= to_char(add_months(to_date(:strPrcMnth, ''yyyymm''), 12), ''yyyymm'')
                            group by costcode order by costcode) t_7,
                          (select costcode, sum(nvl(hours,0)) as next_total_1 from rap_gtt_prjcmast
                            where projno in (select projno from projmast where proj_no = substr(:p_projno,1,5))
                            and yymm > to_char(add_months(to_date(:strPrcMnth, ''yyyymm''), 12), ''yyyymm'')
                            group by costcode order by costcode) t_8
                        where t_1.costcode = t_2.costcode(+) and t_1.costcode = t_3.costcode(+) and t_1.costcode = t_4.costcode(+)
                            and t_1.costcode = t_5.costcode(+) and t_1.costcode = t_6.costcode(+) and t_1.costcode = t_7.costcode(+)
                            and t_1.costcode = t_8.costcode(+)'
                      using p_projno, p_projno, p_projno, strPrcMnth, p_projno, strYrStart, strPrcMnth,
                        p_projno,
                        p_projno, strPrcMnth,
                        p_projno, strPrcMnth,
                        p_projno, strYrStart, strPrcMnth,
                        v_new_yymm, p_projno, v_new_yymm, strEndMnth,
                        p_projno, v_new_yymm, strPrcMnth,
                        p_projno, strPrcMnth;
                    -- Part6 Data --------------------------------------------------------
                      open p_part6 for
                      'select nvl(a.description,'' '') description,b.empdesc emptype, a.projno,
                        a.costcode, sum(a.monhrs) monhrs,sum(a.yrhrs) yrhrs
                        from ((select e1.emptype, e1.subcontract, t1.projno, t1.costcode, s1.description,
                        sum(nvl(t1.hours, 0)) + sum(nvl(t1.othours, 0))
                        as monhrs, 0 as yrhrs from rap_gtt_timetran t1, emplmast e1, subcontractmast s1
                        where e1.empno(+) = t1.empno and s1.subcontract(+) = e1.subcontract
                        and t1.yymm = :strPrcMnth and substr(t1.projno,1,5) = substr(:p_projno,1, 5)
                        group by e1.emptype,e1.subcontract,t1.projno,t1.costcode,s1.description)
                        union
                        (select e2.emptype, e2.subcontract, t2.projno, t2.costcode, s2.description,
                        0 as monhrs, sum(nvl(t2.hours,0)) + sum(nvl(t2.othours,0)) as yrhrs
                        from rap_gtt_timetran t2, emplmast e2, subcontractmast s2 where e2.empno(+) = t2.empno
                        and t2.yymm >= :strYrStart and yymm <= :strPrcMnth
                        and substr(t2.projno,1,5) = substr(:p_projno,1, 5)
                        and s2.subcontract(+) = e2.subcontract
                        group by e2.emptype, e2.subcontract,t2.projno,t2.costcode,s2.description) ) a , EMPTYPEMAST B
                        WHERE A.EMPTYPE = B.emptype
                        group by a.projno, a.costcode, b.empdesc, a.subcontract, a.description
                        order by a.projno, a.costcode, b.empdesc, a.subcontract, a.description'
                    using strPrcMnth, p_projno, strYrStart, strPrcMnth, p_projno;
                    -- tm11data Data --------------------------------------------------------
                    open p_tm11data for
                    'select wpcode, trim(a.activity) || '' '' || (select tlpcode from act_mast
                      where costcode = a.costcode and trim(activity) = trim(a.activity)) Particol, a.projno, b.emptype,
                      a.costcode, a.empno, b.name, sum(nvl(a.hours, 0)) as hours, sum(nvl(a.othours, 0)) as othours
                      from rap_gtt_timetran a, emplmast b
                      where a.empno = b.empno and a.projno in (select projno from projmast
                      where proj_no = :p_projno) and a.yymm = :p_yymm
                      group by a.yymm, a.empno, b.name, a.costcode, a.projno, a.wpcode, a.activity, b.emptype
                      order by a.yymm, a.empno, b.name, a.costcode, a.projno, a.wpcode, a.activity'
                    using p_projno, p_yymm;
                  end if;
              end if;
         end if;
     end if;
  end rpt_tm11_tm01;

  procedure rpt_tm11_tm01_06Sep2022(p_projno in varchar2, p_yymm in varchar2, p_yearmode in varchar2, p_yyyy in varchar2,
                          p_cols out sys_refcursor, p_gen out sys_refcursor, p_part1 out sys_refcursor, p_part2 out sys_refcursor,
                          p_part3 out sys_refcursor, p_part4 out sys_refcursor, p_tm11data out sys_refcursor) as
      pivot_clause varchar2(4000);
      noofmonths number;
      strPrcMnth varchar2(6);
      strYrStart varchar2(6);
      strEndMnth varchar2(6);
      v_new_yymm Varchar2(6);
      p_insert_query Varchar2(10000);
	  p_success Varchar2(2);
      p_message Varchar2(4000);
    begin
      strPrcMnth := p_yymm;
      select to_char(add_months(to_date(p_yymm,'yyyymm'),1),'yyyymm') into v_new_yymm from dual;
      select rap_reports_gen.get_actual_start_month(v_new_yymm, p_yymm, p_yearmode) into strYrStart from dual;

      select to_char(add_months(to_date(v_new_yymm,'yyyymm'), 12),'yyyymm') into strEndMnth from dual;
      noofmonths := 12;
      select listagg( yymm || ' as "' || heading || '"', ', ') within group (order by yymm) into pivot_clause
      from (select yymm, heading from table(rap_reports.rpt_month_cols(v_new_yymm, noofmonths)));
      -- General Data --------------------------------------------------------
      open p_cols for
      'select * from (
          select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths))
        ) pivot (max(yymm) for yymm in ('|| pivot_clause ||'))'
      using v_new_yymm, noofmonths;

      -- General Data --------------------------------------------------------
      open p_gen for
      'select distinct substr(a.projno, 1, 5) projno, a.name, a.active, a.cdate, a.Tcmno,
       b.name Prjdymngrname, c.name Prjmngrname, to_char(sysdate,''dd-Mon-yyyy'') processdate
       from projmast a, emplmast b, emplmast c
       where a.prjmngr = b.empno and a.prjdymngr = c.empno(+) and substr(a.proj_no, 1, 5) = substr(:p_projno, 1, 5)'
      using p_projno;

      rap_gtt.get_insert_query_4_gtt(p_yyyy, 'OPENMAST', p_insert_query, p_success, p_message);
      if p_success = 'OK' then
          execute immediate p_insert_query;
          rap_gtt.get_insert_query_4_gtt(p_yyyy, 'BUDGMAST', p_insert_query, p_success, p_message);
          if p_success = 'OK' then
              execute immediate p_insert_query;
              rap_gtt.get_insert_query_4_gtt(p_yyyy, 'PRJCMAST', p_insert_query, p_success, p_message);
              if p_success = 'OK' then
                  execute immediate p_insert_query;
                  rap_gtt.get_insert_query_4_gtt(p_yyyy, 'TIMETRAN', p_insert_query, p_success, p_message);
                  if p_success = 'OK' then
                      execute immediate p_insert_query;
                      commit;
                      -- Part1 Data --------------------------------------------------------
                      open p_part1 for
                      'select t_1.costcode, t_1.name, t_1.phase, t_2.original, t_2.revised, t_4.currmnth, t_5.curryear,
                        (nvl(t_5.curryear,0) + nvl(t_3.opening,0)) opening, t_6.*, t_7.next_total, t_8.next_total_1 from
                        (select distinct costcode, name, phase from costmast where cost_type = ''D'' and (
                            costcode in (select distinct costcode from rap_gtt_budgmast
                            where projno in (select projno from ProjMast where proj_no = substr(:p_projno,1,5))) or
                            costcode in (select distinct costcode from rap_gtt_openmast
                            where projno in (select projno from ProjMast where proj_no = substr(:p_projno,1,5))) or
                            costcode in (select distinct costcode from rap_gtt_prjcmast
                            where projno in (select projno from ProjMast where proj_no = substr(:p_projno,1,5)) and yymm > :strPrcMnth) or
                            costcode in (select distinct costcode from rap_gtt_timetran
                            where projno in (select projno from ProjMast where proj_no = substr(:p_projno,1,5)) and
                            yymm >= :strYrStart and yymm <= :strPrcMnth)) order by phase,costcode) t_1,
                       (select costcode, sum(nvl(original,0))as original, sum(nvl(revised,0))as revised
                            from rap_gtt_budgmast where projno in (select projno from projmast where proj_no = :p_projno)
                            group by costcode order by costcode) t_2,
                       (select costcode, case ''' || p_yearmode || ''' when ''J'' then sum(nvl(open01,0)) else sum(nvl(open04,0)) end as opening
                            from rap_gtt_openmast where projno in (select projno from projmast where proj_no = substr(:p_projno,1,5))
                            group by costcode order by costcode) t_3,
                       (select costcode,sum(nvl(hours,0)) + sum(nvl(othours,0)) as currmnth from rap_gtt_timetran where
                            projno in (select projno from projmast where proj_no = substr(:p_projno,1,5)) and yymm = :strPrcMnth
                            group by costcode order by costcode) t_4,
                       (select costcode,sum(nvl(hours,0)) + sum(nvl(othours,0)) as curryear from rap_gtt_timetran
                        where projno in (select projno from projmast where proj_no = substr(:p_projno,1,5))
                        and yymm >= :strYrStart and yymm <= :strPrcMnth
                        group by costcode order by costcode) t_5,
                       (select * from (
                            with t_yymm as (
                              select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, 12))
                            ),
                            t_data as (
                              select yymm,costcode,sum(nvl(hours,0)) as hours from rap_gtt_prjcmast
                                where projno in (select projno from projmast where proj_no = substr(:p_projno,1,5))
                                and yymm >= :v_new_yymm and yymm <= :strEndMnth
                                group by costcode,yymm order by costcode,yymm
                            )
                            select a.yymm,b.costcode, b.hours from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                          ) pivot (sum(hours) for yymm in ('|| pivot_clause ||'))
                          order by costcode) t_6,
                          (select costcode, sum(nvl(hours,0)) as next_total from rap_gtt_prjcmast
                            where projno in (select projno from projmast where proj_no = substr(:p_projno,1,5))  and yymm >= :v_new_yymm
                            and yymm <= to_char(add_months(to_date(:strPrcMnth, ''yyyymm''), 12), ''yyyymm'')
                            group by costcode order by costcode) t_7,
                          (select costcode, sum(nvl(hours,0)) as next_total_1 from rap_gtt_prjcmast
                            where projno in (select projno from projmast where proj_no = substr(:p_projno,1,5))
                            and yymm > to_char(add_months(to_date(:strPrcMnth, ''yyyymm''), 12), ''yyyymm'')
                            group by costcode order by costcode) t_8
                        where t_1.costcode = t_2.costcode(+) and t_1.costcode = t_3.costcode(+) and t_1.costcode = t_4.costcode(+)
                            and t_1.costcode = t_5.costcode(+) and t_1.costcode = t_6.costcode(+) and t_1.costcode = t_7.costcode(+)
                            and t_1.costcode = t_8.costcode(+)'
                      using p_projno, p_projno, p_projno, strPrcMnth, p_projno, strYrStart, strPrcMnth,
                        p_projno,
                        p_projno,
                        p_projno, strPrcMnth,
                        p_projno, strYrStart, strPrcMnth,
                        v_new_yymm, p_projno, v_new_yymm, strEndMnth,
                        p_projno, v_new_yymm, strPrcMnth,
                        p_projno, strPrcMnth;
                      -- Part2 Data --------------------------------------------------------
                      open p_part2 for
                        'select case p.emptype when ''R'' then ''TCMPL Personnel'' when ''C'' then ''Consultants''
                            when ''S'' then ''SubContract'' when ''F'' then ''FTC'' when ''O'' then ''SubContract - Out of Office''
                            else '''' end emptype, q.totmnhrs, p.totyrhrs  from (
                        select b.emptype, sum(nvl(a.hours,0)) + sum(nvl(a.othours,0)) as totyrhrs
                        from rap_gtt_timetran a, emplmast b where b.empno = a.empno
                        and a.yymm >= :strYrStart and yymm <= :strPrcMnth and substr(a.projno,1,5) = substr(:p_projno,1, 5)
                        group by b.emptype) p left outer join (
                        select b.emptype, sum(nvl(a.hours,0)) + sum(nvl(a.othours,0)) as totmnhrs
                        from rap_gtt_timetran a, emplmast b where b.empno = a.empno and a.yymm = :strPrcMnth
                        and substr(a.projno,1,5) = substr(:p_projno,1, 5)
                        group by b.emptype) q on p.emptype = q.emptype'
                      using strYrStart, strPrcMnth, p_projno, strPrcMnth, p_projno ;
                      -- Part3 Data --------------------------------------------------------
                      open p_part3 for
                      'select case a.emptype when ''R'' then ''TCMPL Personnel'' when ''C'' then ''Consultants''
                            when ''S'' then ''SubContract'' when ''F'' then ''FTC'' when ''O'' then ''SubContract - Out of Office''  else ''Not Defined'' end emptype,
                            case a.location when ''E'' then ''Employees'' when ''H'' then ''Head Office''
                            when ''I'' then ''Sites - India'' when ''A'' then ''Sites - Foreign'' else ''Not Defined'' end location,
                            sum(a.monhrs) monhrs, sum(a.YrHrs) yrhrs from
                        ((select e.emptype, e.location, sum(nvl(t.hours,0)) + sum(nvl(t.othours,0)) as Monhrs,
                        0 as YrHrs from rap_gtt_timetran t, emplmast e where e.empno = t.empno and t.yymm = :strPrcMnth
                        and substr(t.projno,1,5) = substr(:p_projno,1, 5) group by e.emptype, e.location)
                        Union
                        (select e.emptype, e.location,0 as MonHrs, sum(nvl(t.hours,0)) + sum(nvl(t.othours,0)) as Yrhrs
                        from rap_gtt_timetran t, emplmast e where e.empno = t.empno and t.yymm >= :strYrStart and yymm <= :strPrcMnth
                        and substr(t.projno,1,5) = substr(:p_projno,1, 5) group by e.emptype, e.location)) a
                        group by a.emptype,a.location order  by a.emptype,a.location'
                      using strPrcMnth, p_projno, strYrStart, strPrcMnth, p_projno;
                      -- Part4 Data --------------------------------------------------------
                      open p_part4 for
                      'select nvl(a.description,'' '') description,b.empdesc emptype, a.projno,sum(a.monhrs) monhrs,sum(a.yrhrs) yrhrs
                        from ((select e1.emptype, e1.subcontract, t1.projno, s1.description,
                        sum(nvl(t1.hours, 0)) + sum(nvl(t1.othours, 0))
                        as monhrs, 0 as yrhrs from rap_gtt_timetran t1, emplmast e1, subcontractmast s1
                        where e1.empno(+) = t1.empno and s1.subcontract(+) = e1.subcontract
                        and t1.yymm = :strPrcMnth and substr(t1.projno,1,5) = substr(:p_projno,1, 5)
                        group by e1.emptype,e1.subcontract,t1.projno,s1.description)
                        union
                        (select e2.emptype, e2.subcontract, t2.projno, s2.description,
                        0 as monhrs, sum(nvl(t2.hours,0)) + sum(nvl(t2.othours,0)) as yrhrs
                        from rap_gtt_timetran t2, emplmast e2, subcontractmast s2 where e2.empno(+) = t2.empno
                        and t2.yymm >= :strYrStart and yymm <= :strPrcMnth
                        and substr(t2.projno,1,5) = substr(:p_projno,1, 5)
                        and s2.subcontract(+) = e2.subcontract
                        group by e2.emptype, e2.subcontract, t2.projno, s2.description) ) a , EMPTYPEMAST B
                        WHERE A.EMPTYPE = B.emptype
                        group by a.projno, b.empdesc, a.subcontract, a.description
                        order by a.projno, b.empdesc, a.subcontract, a.description'
                    using strPrcMnth, p_projno, strYrStart, strPrcMnth, p_projno;
                    -- tm11data Data --------------------------------------------------------
                    open p_tm11data for
                    'select wpcode, trim(a.activity) || '' '' || (select tlpcode from act_mast
                      where costcode = a.costcode and trim(activity) = trim(a.activity)) Particol, a.projno,
                      a.costcode, a.empno, b.name, sum(nvl(a.hours, 0)) as hours, sum(nvl(a.othours, 0)) as othours
                      from rap_gtt_timetran a, emplmast b
                      where a.empno = b.empno and a.projno in (select projno from projmast
                      where proj_no = :p_projno) and a.yymm = :p_yymm
                      group by a.yymm, a.empno, b.name, a.costcode, a.projno, a.wpcode, a.activity, a.projno
                      order by a.yymm, a.empno, b.name, a.costcode, a.projno, a.wpcode, a.activity'
                    using p_projno, p_yymm;
                  end if;
              end if;
         end if;
     end if;
  end rpt_tm11_tm01_06Sep2022;

  /* PRJ CC TCM  */
  procedure rpt_prj_cc_tcm(p_yymm in varchar2, p_yearmode in varchar2,
                           p_cols out sys_refcursor, p_results out sys_refcursor) as
      pivot_clause varchar2(4000);
      noofmonths number;
      strPrcMnth varchar2(6);
      strYrStart varchar2(6);
    begin
      strPrcMnth := p_yymm;
      --strYrStart := p_yymm;
      select rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode) into strYrStart from dual;
      noofmonths := 12;
      select listagg( yymm || ' as "' || heading || '"', ', ') within group (order by yymm) into pivot_clause
      from (select yymm, heading from table(rap_reports.rpt_month_cols(strYrStart, noofmonths)));
      -- General Data --------------------------------------------------------
      open p_cols for
      'select * from (
          select yymm from table(rap_reports.rpt_month_cols(:strYrStart, :noofmonths))
        ) pivot (max(yymm) for yymm in ('|| pivot_clause ||'))'
      using strYrStart, noofmonths;
      -- Results Data --------------------------------------------------------
      open p_results for
      'select * from (
        with t_yymm as (
          select yymm from table(rap_reports.rpt_month_cols(:strYrStart, 12))
        ),
        t_data as (
          select costcode,projno,tcmno,name,sapcc,yymm,tothours from prj_cc_tcm
            where yymm >= :strYrStart and yymm <= :strPrcMnth
            order by projno,costcode,yymm
        )
        select a.yymm,b.costcode,b.projno,b.tcmno,b.name,b.sapcc,nvl(b.tothours,0) tothours from t_yymm a, t_data b
        where a.yymm = b.yymm(+) order by yymm
      ) pivot (sum(tothours) for yymm in ('|| pivot_clause ||'))
      where costcode is not null
      order by projno, sapcc'
      using strYrStart,  strYrStart, strPrcMnth ;
  end rpt_prj_cc_tcm;

  /* Workload */
  procedure rpt_workload(p_costcode in varchar2, p_yymm in varchar2, p_simul in varchar2, p_empcnt in number,
                         p_cols out sys_refcursor, p_results out sys_refcursor) as
      pivot_clause varchar2(4000);
      noofmonths number;
      mfilter varchar2(1000);
      rfilter varchar2(1000);
    begin
      noofmonths := 18;
      case p_simul
        when 'A' then
          mfilter := ' and b.proj_type in (''A'',''B'',''C'') ';
          rfilter := ' and b.proj_type not in (''A'',''B'',''C'') ';
        when 'B' then
          mfilter := ' and b.proj_type in (''B'',''C'') ';
          rfilter := ' and b.proj_type not in (''B'',''C'') ';
        when 'C' then
          mfilter := ' and b.proj_type in (''C'') ';
          rfilter := ' and b.proj_type not in (''C'') ';
        else
          mfilter := '';
          rfilter := '';
      end case;
 	 -- Cols --------------------------------------------------------
      select listagg( yymm || ' as "' || heading || '"', ', ') within group (order by yymm) into pivot_clause
      from (select yymm, heading from table(rap_reports.rpt_month_cols(p_yymm, noofmonths)));
      -- General Data --------------------------------------------------------
      open p_cols for
      'select * from (
          select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths))
        ) pivot (max(yymm) for yymm in ('|| pivot_clause ||'))'
      using p_yymm, noofmonths;
      -- Results Data --------------------------------------------------------
      open p_results for
      'select * from (
          select yymm, ''A'' as Name, (rap_reports.getWorkingHrs(yymm) * :p_empcnt ) hrs
             from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths)) order by yymm
        ) pivot (sum(nvl(hrs,0)) for yymm in ('|| pivot_clause ||'))
        union
        select * from (
          with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths)) ),
             t_data as ( select yymm, (nvl(movetosite,0) * rap_reports.getWorkingHrs(yymm)) +
                           (nvl(movetoothers,0) * rap_reports.getWorkingHrs(yymm))  hrs from movemast where costcode = :p_costcode
                            and yymm >= :p_yymm order by yymm )
          select a.yymm, ''B'' as Name, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
        ) pivot (sum(nvl(hrs,0)) for yymm in ('|| pivot_clause ||'))
        union
        select * from (
          with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths)) ),
             t_data as ( select yymm, (nvl(movetotcm,0) * rap_reports.getWorkingHrs(yymm)) +
                           (nvl(int_dept,0) * rap_reports.getWorkingHrs(yymm)) hrs from movemast where costcode = :p_costcode
                            and yymm >= :p_yymm order by yymm )
          select a.yymm, ''C'' as Name, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
        ) pivot (sum(nvl(hrs,0)) for yymm in ('|| pivot_clause ||'))
        union
        select * from (
          with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths)) ),
             t_data as ( select yymm, (nvl(ext_subcontract,0) * rap_reports.getWorkingHrs(yymm)) +
                           (nvl(rap_reports.getCummFutRecruit(:p_costcode,:p_yymm, yymm),0) * rap_reports.getWorkingHrs(yymm)) hrs
                          from movemast where costcode = :p_costcode and yymm >= :p_yymm order by yymm )
          select a.yymm, ''D'' as Name, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
        ) pivot (sum(nvl(hrs,0)) for yymm in ('|| pivot_clause ||'))
        union
        select * from (
          with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths)) ),
             t_data as ( select yymm, sum(hrs) hrs from
                          (select a.yymm, sum(nvl(a.hours,0)) as hrs from prjcmast a, projmast b
                             where a.costcode = :p_costcode and a.projno = b.projno and b.active > 0
                             and a.yymm >= :p_yymm group by a.yymm
                           union
                           select a.yymm, sum(nvl(a.hours,0)) as hrs from exptprjc a, exptjobs b
                             where a.costcode = :p_costcode and a.projno = b.projno and b.activefuture > 0 and b.active <= 0
                             '|| mfilter ||' and a.yymm >= :p_yymm  group by a.yymm) group by yymm order by yymm )
          select a.yymm, ''F'' as Name, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
        ) pivot (sum(nvl(hrs,0)) for yymm in ('|| pivot_clause ||'))
        union
        select * from (
          with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths)) ),
             t_data as ( select a.yymm, sum(nvl(a.hours,0)) as hrs from exptprjc a, exptjobs b
                           where a.costcode = :p_costcode and a.projno = b.projno and b.active > 0 and b.activefuture <= 0
                           '|| mfilter ||' and a.yymm >= :p_yymm  group by a.yymm order by a.yymm )
          select a.yymm, ''G'' as Name, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
        ) pivot (sum(nvl(hrs,0)) for yymm in ('|| pivot_clause ||'))'
       using p_empcnt, p_yymm, noofmonths,
        p_yymm, noofmonths, p_costcode, p_yymm,
        p_yymm, noofmonths, p_costcode, p_yymm,
        p_yymm, noofmonths, p_costcode,p_yymm, p_costcode, p_yymm,
        p_yymm, noofmonths, p_costcode, p_yymm, p_costcode, p_yymm,
        p_yymm, noofmonths, p_costcode, p_yymm;
  end rpt_workload;

 procedure rpt_workload_new_old(p_costcode in varchar2, p_yymm in varchar2, p_simul in varchar2, p_yearmode in varchar2,
                             p_cols out sys_refcursor, p_results out sys_refcursor) as
      pivot_clause varchar2(4000);
      noofmonths number;
      mfilter varchar2(1000);
      v_lastmonth varchar2(6);
      viewname varchar2(30);
      v_new_yymm Varchar2(6);
    begin
      noofmonths := 18;
      select to_char(add_months(to_date(p_yymm,'yyyymm'),1),'yyyymm') into v_new_yymm from dual;
      select rap_reports_gen.get_lastmonth(v_new_yymm, noofmonths) into v_lastmonth from dual;
      case p_yearmode
        when 'J' then
          viewname := ' rap_vu_rpt_workload_01 ';
        else
          viewname := ' rap_vu_rpt_workload_04 ';
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
 	 -- Cols --------------------------------------------------------
      select listagg( yymm || ' as "' || heading || '"', ', ') within group (order by yymm) into pivot_clause
      from (select yymm, heading from table(rap_reports.rpt_month_cols(v_new_yymm, noofmonths)));
      -- General Data --------------------------------------------------------
      open p_cols for
      'select * from (
          select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths))
        ) pivot (max(yymm) for yymm in ('|| pivot_clause ||'))'
      using v_new_yymm, noofmonths;
      -- Results Data --------------------------------------------------------
      open p_results for
      'select * from
        (with t_yymm as (select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths))),
        t_data as (select yymm, name, sum(hrs) hrs from '|| viewname ||'
        where yymm > :p_yymm and yymm <= :v_lastmonth and costcode = :p_costcode
        and name not in (''b'') and proj_type is null group by yymm, name
        union
        select yymm, name, sum(hrs) hrs from (select yymm, null projno, costcode, ''b'' name, null proj_type,
        sum(nvl(fut_recruit,0) * rap_reports.getWorkingHrs(yymm))
        over(partition by costcode order by yymm) hrs from rap_tab_movemast
        where yymm > :p_yymm and yymm <= :v_lastmonth and costcode = :p_costcode) group by yymm, name
        union
        select yymm, name, sum(hrs) hrs from '|| viewname ||'
        where yymm > :p_yymm and yymm <= :v_lastmonth and costcode = :p_costcode
        and name = ''i'' '|| mfilter ||'
        group by yymm, name order by yymm, name)
        select a.yymm, b.Name, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+)
        and b.name is not null order by yymm
        ) pivot (sum(nvl(hrs,0)) for yymm in ('|| pivot_clause ||'))
        order by name'
        using v_new_yymm, noofmonths, p_yymm, v_lastmonth, p_costcode, p_yymm, v_lastmonth, p_costcode,
              p_yymm, v_lastmonth, p_costcode;
  end rpt_workload_new_old;

     procedure rpt_workload_new(p_costcode in varchar2, p_yymm in varchar2, p_simul in varchar2, p_yearmode in varchar2,
                             p_cols out sys_refcursor, p_results out sys_refcursor) as
        pivot_clause varchar2(4000);
        noofmonths number;
        mfilter varchar2(1000);
        v_lastmonth varchar2(6);
        viewname varchar2(30);
        v_new_yymm Varchar2(6);
        p_batch_key_id varchar2(8);
        p_yyyy Varchar2(7);
        p_success Varchar2(2);
        p_message Varchar2(4000);
        p_insert_query Varchar2(10000);
    begin
        noofmonths := 18;

        select extract (year from add_months (to_date(p_yymm,'yyyymm'), -3))
            || '-'
            || substr(extract (year from add_months (to_date(p_yymm,'yyyymm'), 9)), 3, 2) into p_yyyy
            from dual;

        select to_char(add_months(to_date(p_yymm,'yyyymm'),1),'yyyymm') into v_new_yymm from dual;

        select rap_reports_gen.get_lastmonth(v_new_yymm, noofmonths) into v_lastmonth from dual;
      /*case p_yearmode
        when 'J' then
          viewname := ' rap_vu_rpt_workload_01 ';
        else
          viewname := ' rap_vu_rpt_workload_04 ';
      end case;*/

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

        -- Results Data --------------------------------------------------------
        select substr(SYS_GUID(),0,8) into p_batch_key_id from dual;
        -- Populate GTT tbales ---------------------------------------------------
        rap_gtt.get_insert_query_4_gtt(p_yyyy, 'MOVEMAST', p_insert_query, p_success, p_message);
        if p_success = 'OK' then
            For i in 1..noofmonths Loop
                Insert Into rap_gtt_movemast
                    Select p_costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm'),0,0,0,0,0,0,0,0,p_batch_key_id From dual
                        Where (p_costcode, to_char(add_months (to_date(p_yymm,'yyyymm'),i),'yyyymm')) not in
                    (select costcode, yymm from movemast) ;
            End Loop;

            execute immediate p_insert_query || ' where costcode = trim(:costcode) and yymm > :yymm ' using p_batch_key_id, p_costcode, p_yymm;
            rap_gtt.get_insert_query_4_gtt(p_yyyy, 'EXPTPRJC', p_insert_query, p_success, p_message);
            if p_success = 'OK' then
                execute immediate p_insert_query || ' where costcode = trim(:costcode) and yymm > :yymm ' using p_costcode, p_yymm;
                rap_gtt.get_insert_query_4_gtt(p_yyyy, 'PRJCMAST', p_insert_query, p_success, p_message);
                if p_success = 'OK' then
                    execute immediate p_insert_query || ' where costcode = trim(:costcode) and yymm > :yymm ' using p_costcode, p_yymm;
                    commit;

                    -- Cols --------------------------------------------------------
                    select listagg( yymm || ' as "' || heading || '"', ', ') within group (order by yymm) into pivot_clause
                        from (select yymm, heading from table(rap_reports.rpt_month_cols(v_new_yymm, noofmonths)));
                    -- General Data --------------------------------------------------------
                    open p_cols for
                        'select * from (
                              select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths))
                            ) pivot (max(yymm) for yymm in ('|| pivot_clause ||'))'
                            using v_new_yymm, noofmonths;

                    open p_results for
                        'select * from (
                          select yymm, name, last_value(working_hr) ignore nulls over (
                            order by yymm rows between unbounded preceding and current row) working_hr from (
                          with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                             t_data as ( select yymm, working_hr * rap_reports_gen.get_empcount(:p_costcode) working_hr from raphours where yymm > :p_yymm order by yymm )
                          select a.yymm, ''a'' as Name, b.working_hr from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm )
                        ) pivot (sum(working_hr) for yymm in ('|| pivot_clause ||'))
                        union
                        select * from (
                          with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                             t_data as ( select yymm, sum(nvl(fut_recruit,0)) over(partition by costcode order by yymm) fut_recruit from rap_gtt_movemast
                             where costcode = :p_costcode and yymm > :p_yymm order by yymm )
                          select a.yymm, ''b'' as Name, b.fut_recruit * rap_reports.getWorkingHrs(a.yymm) fut_recruit from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                        ) pivot (sum(fut_recruit) for yymm in ('|| pivot_clause ||'))
                        union
                        select * from (
                          with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                             t_data as ( select yymm, nvl(int_dept,0) * rap_reports.getWorkingHrs(yymm) int_dept from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
                          select a.yymm, ''c'' as Name, b.int_dept from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                        ) pivot (sum(int_dept) for yymm in ('|| pivot_clause ||'))
                        union
                        select * from (
                          with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                             t_data as ( select yymm, nvl(movetotcm,0) * rap_reports.getWorkingHrs(yymm) movetotcm from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
                          select a.yymm, ''d'' as Name, b.movetotcm from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                        ) pivot (sum(movetotcm) for yymm in ('|| pivot_clause ||'))
                        union
                        select * from (
                          with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                             t_data as ( select yymm, nvl(movetosite,0) * rap_reports.getWorkingHrs(yymm) movetosite from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
                          select a.yymm, ''e'' as Name, b.movetosite from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                        ) pivot (sum(movetosite) for yymm in ('|| pivot_clause ||'))
                        union
                        select * from (
                          with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                             t_data as ( select yymm, nvl(movetoothers,0) * rap_reports.getWorkingHrs(yymm) movetoothers from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
                          select a.yymm, ''f'' as Name, b.movetoothers from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                        ) pivot (sum(movetoothers) for yymm in ('|| pivot_clause ||'))
                        union
                        select * from (
                          with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                             t_data as ( select yymm, nvl(ext_subcontract,0) * rap_reports.getWorkingHrs(yymm) ext_subcontract from rap_gtt_movemast where costcode = :p_costcode and yymm > :p_yymm order by yymm )
                          select a.yymm, ''g'' as Name, b.ext_subcontract from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                        ) pivot (sum(ext_subcontract) for yymm in ('|| pivot_clause ||'))
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
                        ) pivot (sum(hrs) for yymm in ('|| pivot_clause ||'))
                        union
                        select * from (
                          with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:v_new_yymm, :noofmonths)) ),
                             t_data as
                             (select x.yymm yymm, nvl(x.hours,0) as hrs from rap_gtt_exptprjc x, exptjobs y
                               where x.projno = y.projno and y.activefuture > 0 and y.active <= 0 and x.costcode = :p_costcode and x.yymm > :p_yymm '|| mfilter ||'
                             )
                             select a.yymm, ''j'' as Name, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+) order by yymm
                        ) pivot (sum(hrs) for yymm in ('|| pivot_clause ||')) '
                        using v_new_yymm, noofmonths, p_costcode, p_yymm,
                            v_new_yymm, noofmonths, p_costcode, p_yymm,
                            v_new_yymm, noofmonths, p_costcode, p_yymm,
                            v_new_yymm, noofmonths, p_costcode, p_yymm,
                            v_new_yymm, noofmonths, p_costcode, p_yymm,
                            v_new_yymm, noofmonths, p_costcode, p_yymm,
                            v_new_yymm, noofmonths, p_costcode, p_yymm,
                            v_new_yymm, noofmonths, p_costcode, p_yymm, p_costcode, p_yymm,
                            v_new_yymm, noofmonths, p_costcode, p_yymm;
                end if;
            end if;
        end if;
    end rpt_workload_new;

  procedure rpt_tm01All_ProjectList(p_yymm in varchar2, p_simul in varchar2, p_results out sys_refcursor) as
      v_stat varchar2(2000);
    begin
      v_stat := 'select projno,tcmno,name,active,to_char(sdate,''dd-Mon-yy'') sdate,to_char(cdate,''dd-Mon-yy'') cdate ';
      v_stat := v_stat || ' from projmast where active > 0 and projno in  ';
      v_stat := v_stat || '(select distinct projno from prjcmast where yymm >= :p_yymm and active > 0)   ';
      v_stat := v_stat || 'union all ';
      v_stat := v_stat || 'select projno,tcmno,name, 1 active, '''' sdate, '''' cdate from exptjobs ';
      v_stat := v_stat || 'where(active > 0 or activefuture > 0)  ';

      case p_simul
        when 'A' then
          v_stat := v_stat || ' and proj_type in (''A'',''B'',''C'') ';
        when 'B' then
          v_stat := v_stat || ' and proj_type in (''B'',''C'') ';
        when 'C' then
          v_stat := v_stat || ' and proj_type in (''C'') ';
        else
          v_stat := v_stat || '';
      end case;

      v_stat := v_stat || ' and projno in (select distinct projno from exptprjc where yymm >= :p_yymm )';
      v_stat := v_stat || ' order by projno';
      open p_results for v_stat
      using p_yymm, p_yymm;
  end rpt_tm01All_ProjectList;

  procedure rpt_tm01all(p_projno in varchar2, p_yymm in varchar2, p_simul in varchar2, p_yearmode in varchar2,
                        p_cols out sys_refcursor, p_results out sys_refcursor) as
      pivot_clause varchar2(4000);
      noofmonths number;
      strStart varchar2(6);
      mfilter varchar2(1000);
      --rfilter varchar2(1000);
      v_new_yymm Varchar2(6);
    begin
      noofmonths := 48;
      strStart := p_yymm;

      select to_char(add_months(to_date(p_yymm,'yyyymm'),1),'yyyymm') into v_new_yymm from dual;

 	  -- Cols --------------------------------------------------------
      select listagg( yymm || ' as "' || heading || '"', ', ') within group (order by yymm) into pivot_clause
      from (select yymm, heading from table(rap_reports.rpt_month_cols(v_new_yymm, noofmonths)));

      open p_cols for
      'select * from (
          select yymm from table(rap_reports.rpt_month_cols(:v_new_yymmp_yymm, :noofmonths))
        ) pivot (max(yymm) for yymm in ('|| pivot_clause ||'))'
      using v_new_yymm, noofmonths;
      -- Results Data --------------------------------------------------------
      open p_results for
      'select p.costcode, p.name, nvl(q.revised,0) revised, nvl(r.curryear,0) curryear, nvl(s.opening,0) opening, t.* from
        (select distinct costcode, name, tm01_grp from costmast where cost_type = ''D'' and (
        costcode in (select distinct costcode from budgmast where projno = :p_projno) or
        costcode in (select distinct costcode from openmast where projno = :p_projno) or
        costcode in (select distinct costcode from prjcmast where projno = :p_projno and yymm > :p_yymm) or
        costcode in (select distinct costcode from exptprjc where projno = :p_projno and yymm > :p_yymm) or
        costcode in (select distinct costcode from timetran where projno = :p_projno and yymm >= :strStart and yymm <= :p_yymm))) p,
        (select costcode, nvl(original,0) original, nvl(revised,0) revised from budgmast where projno = :p_projno) q,
        (select costcode, sum(nvl(hours,0)) + sum(nvl(othours,0)) as curryear from timetran
        where projno = :p_projno and yymm >= :strStart and yymm <= :p_yymm
        group by costcode order by costcode) r,
        (select costcode, case ''' || p_yearmode || ''' when ''J'' then nvl(open01,0) else nvl(open04,0) end as opening
          from openmast where projno = :p_projno order by costcode) s,
        (select * from (
          with t_yymm as ( select yymm from table(rap_reports.rpt_month_cols(:p_yymm, 48)) ),
             t_data as ( select * from (select costcode, yymm, hours from prjcmast where projno = :p_projno and yymm >= :v_new_yymm
                         union  select costcode, yymm, hours from exptprjc where projno = :p_projno and yymm >= :v_new_yymm)
                          order by costcode, yymm )
          select b.costcode, a.yymm, nvl(b.hours,0) hours from t_yymm a, t_data b where a.yymm = b.yymm(+) and costcode is not null
              order by b.costcode, a.yymm
        )  pivot ( sum(hours) for yymm in ('|| pivot_clause ||')) order by costcode) t
        where p.costcode = q.costcode(+) and p.costcode = r.costcode(+) and p.costcode = s.costcode(+) and p.costcode = t.costcode(+)
        order by p.costcode'
        using p_projno, p_projno,
              p_projno, p_yymm,
              p_projno, p_yymm,
              p_projno, strStart, p_yymm,
              p_projno,
              p_projno, strStart, p_yymm,
              p_projno,
              p_yymm,
              p_projno, v_new_yymm,
              p_projno, v_new_yymm;
  end rpt_tm01all;

  procedure rpt_tm01All_Project(p_projno in varchar2, p_results out sys_refcursor) as

    begin
      open p_results for
      'select projno, nvl(tcmno, '' '') tcmno, name, nvl(to_char(sdate, ''dd-Mon-yy''),'' '') sdate,
       nvl(to_char(edate, ''dd-Mon-yy''), '' '') edate,
       floor(months_between(edate, sdate)) mnths from
       (select a.projno, a.tcmno, a.name, a.active, a.sdate,
       case when length(b.myymm) > 0 then to_date(''28-'' || substr(b.myymm, 5, 2) || ''-'' ||
       substr(b.myymm, 1, 4),''dd-mm-yy'') else to_date(''28-'' || to_char(a.sdate, ''mm'') || ''-'' ||
       to_char(a.sdate, ''yy''),''dd-mm-yy'') end edate from projmast a,
       (select projno, max(yymm) myymm from prjcmast where projno = :p_projno group by projno) b
       where a.projno = b.projno and a.active > 0
       union all
       select projno, tcmno, name, active, null sdate, null edate from exptjobs
       where projno = :p_projno and (active > 0 or activefuture > 0)) order by projno'
    using p_projno, p_projno;
  end rpt_tm01All_Project;

  procedure rpt_resourceavlsch(p_timesheet_yyyy in varchar2, p_costcode in varchar2, p_yymm in varchar2, p_yearmode in varchar2,
                               p_cols out sys_refcursor, p_results out sys_refcursor) as
      pivot_clause varchar2(4000);
      noofmonths number;
      --v_lastmonth varchar2(6);
      viewname varchar2(30);
      p_batch_key_id varchar2(8);
      p_insert_query Varchar2(10000);
      p_success Varchar2(2);
      p_message Varchar2(4000);
      --p_timesheet_yyyy Varchar2(7) := '2019-20';
    begin
      noofmonths := 18;
      select substr(SYS_GUID(),0,8) into p_batch_key_id from dual;
      -- Populate GTT tbales ---------------------------------------------------
      rap_gtt.get_insert_query_4_gtt(p_timesheet_yyyy, 'MOVEMAST', p_insert_query, p_success, p_message);

      if p_success = 'OK' then
          execute immediate p_insert_query using p_batch_key_id;
          -- Cols ----------------------------------------------------------------
          select listagg( yymm || ' as "' || heading || '"', ', ') within group (order by yymm) into pivot_clause
            from (select yymm, heading from table(rap_reports.rpt_month_cols(p_yymm, noofmonths)));
          -- General Data --------------------------------------------------------
          open p_cols for
          'select * from (
              select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths))
            ) pivot (max(yymm) for yymm in ('|| pivot_clause ||'))'
          using p_yymm, noofmonths;
          -- Results Data --------------------------------------------------------
          open p_results for
          'select * from
            (with t_yymm as (select yymm from table(rap_reports.rpt_month_cols(:p_yymm, :noofmonths))),
            t_data as (select yymm, costcode, ''a'' name, rap_reports_gen.get_empcount(costcode) +
            nvl(rap_reports.getCummFutRecruit(costcode, rap_reports_gen.get_yymm_begin(yymm, :p_yearmode ), yymm),0) +
            nvl(int_dept,0) hrs from rap_gtt_movemast where costcode = :p_costcode and yymm >= :p_yymm
            union
            select yymm, costcode, ''b'' name, nvl(movetotcm,0) hrs from rap_gtt_movemast
              where costcode = :p_costcode and yymm >= :p_yymm
            union
            select yymm, costcode, ''d'' name, nvl(ext_subcontract,0) hrs from rap_gtt_movemast
              where costcode = :p_costcode and yymm >= :p_yymm)
            select a.yymm, b.name, b.hrs from t_yymm a, t_data b where a.yymm = b.yymm(+)
              and b.name is not null order by yymm
            ) pivot (sum(nvl(hrs,0)) for yymm in ('|| pivot_clause ||'))
            order by name'
           using p_yymm, noofmonths, p_yearmode, p_costcode, p_yymm, p_costcode, p_yymm, p_costcode, p_yymm;
      end if;
  end rpt_resourceavlsch;

    Procedure get_report_status(p_reportid   In  Varchar2,
                                p_user       In  Varchar2,
                                p_yyyy       In  Varchar2,
                                p_yearmode   In  Varchar2,
                                p_yymm       In  Varchar2,
                                p_category   In  Varchar2 Default Null,
                                p_reporttype In  Varchar2 Default Null,
                                p_msg        Out Varchar2) As
        v_iscomplete Varchar2(15);
    Begin
        Select
            Case iscomplete
                When 1 Then
                    'Download'
                When 0 Then
                    'Processing...'
                Else
                    'Process'
            End
        Into
            v_iscomplete
        From
            (
                Select
                    iscomplete
                From
                    rap_rpt_process
                Where
                    reportid                 = p_reportid
                    And userid               = p_user
                    And yyyy                 = p_yyyy
                    And yymm                 = p_yymm
                    And yearmode             = p_yearmode
                    And nvl(category, '-')   = nvl(p_category, '-')
                    And nvl(reporttype, '-') = nvl(p_reporttype, '-')
                Order By sdate Desc
            )
        Where
            Rownum = 1;
        p_msg := v_iscomplete;
    Exception
        When Others Then
            p_msg := 'Process';
    End get_report_status;

    Procedure get_report_keyid(p_reportid   In  Varchar2,
                               p_user       In  Varchar2,
                               p_yyyy       In  Varchar2,
                               p_yearmode   In  Varchar2,
                               p_yymm       In  Varchar2,
                               p_category   In  Varchar2 Default Null,
                               p_reporttype In  Varchar2 Default Null,
                               p_keyid      Out Varchar2) As
        v_keyid rap_rpt_process.keyid%Type;
    Begin
        Select
            keyid
        Into
            v_keyid
        From
            (
                Select
                    keyid
                From
                    rap_rpt_process
                Where
                    reportid                 = p_reportid
                    And userid               = p_user
                    And yyyy                 = p_yyyy
                    And yymm                 = p_yymm
                    And yearmode             = p_yearmode
                    And nvl(category, '-')   = nvl(p_category, '-')
                    And nvl(reporttype, '-') = nvl(p_reporttype, '-')
                    And iscomplete           = 1
                Order By sdate Desc
            )
        Where
            Rownum = 1;
        p_keyid := v_keyid;
    Exception
        When Others Then
            p_keyid := ' ';
    End get_report_keyid;

    Procedure get_list_4_worker_process(p_result Out Sys_Refcursor) Is
    Begin
        Open p_result For
            Select
                *
            From
                rap_rpt_process
            Where
                IsComplete = 0
            Order By sdate;

    End get_list_4_worker_process;

     procedure rpt_reimbpo(p_yymm in varchar2, p_hrs out sys_refcursor, p_hrs_o out sys_refcursor,
                         p_hrs_exo out sys_refcursor) as
      begin
      -- All data --------------------------------------------------------
      open p_hrs for
      'select projno, tcmno, name, sapcc, ccdesc, purchaseorder, tcm_cc, tcm_phase, tothours, rate, e_ep_type
        from prj_cc_po_rt_hrs where yymm = :p_yymm order by projno, sapcc'
      using p_yymm;

      -- Subcontract (O) --------------------------------------------------------
      open p_hrs_o for
      'select projno, tcmno, name, sapcc, ccdesc, purchaseorder, tcm_cc, tcm_phase, tothours, rate, e_ep_type
        from prj_cc_po_rt_hrs_o where yymm = :p_yymm order by projno, sapcc'
      using p_yymm;

      -- Excluding Subcontract (O) --------------------------------------------------------
      open p_hrs_exo for
      'select projno, tcmno, name, sapcc, ccdesc, purchaseorder, tcm_cc, tcm_phase, tothours, rate, e_ep_type
        from prj_cc_po_rt_hrs_exo where yymm = :p_yymm order by projno, sapcc'
      using p_yymm;

    end rpt_reimbpo;
   procedure projects_TCMJobsGrp(p_yymm in varchar2, p_results out sys_refcursor) as
     begin
      open p_results for
      'Select Distinct projno
       From timetran
       Where yymm = :p_yymm
            And Substr(projno,1,5) in (SELECT proj_no from projmast where tcm_jobs = 1)
       Order by projno'
       using p_yymm;
    end projects_TCMJobsGrp;

end rap_reports;

/
