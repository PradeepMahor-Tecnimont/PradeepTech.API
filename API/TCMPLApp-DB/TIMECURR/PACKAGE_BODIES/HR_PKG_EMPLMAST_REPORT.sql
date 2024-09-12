--------------------------------------------------------
--  DDL for Package Body HR_PKG_EMPLMAST_REPORT
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."HR_PKG_EMPLMAST_REPORT" as
   
   function get_subcontract_emp_parentwise(p_yymm in varchar2) return CLOB as
       v_stmt      varchar2(4000);
       v_clause    varchar2(4000);
       v_columns   varchar2(4000);
       c           Sys_Refcursor;
     begin
       /*select '"'''||listagg(parent,'''","''') within group ( order by parent )||'''",'||'"TOTAL"' into v_columns
        from (select parent from (select distinct td.parent
        from hr_emplmast_main hem, hr_emplmast_organization heo, subcontractmast sm, time_daily td
        where hem.empno = heo.empno and heo.subcontract = sm.subcontract and heo.empno = td.empno
        and hem.emptype = 'S' and td.yymm = p_yymm UNION
        select costcode parent from hr_costmast_main hcm where hcm.costcode in ('0107','0181')) order by parent);  */
       select '"'''||listagg(parent,'''","''') within group ( order by parent )||'''",'||'"TOTAL"' into v_columns
         from (select parent from (select distinct td.parent
         from hr_emplmast_main hem, hr_emplmast_organization heo, subcontractmast sm, time_daily td
         where hem.empno = heo.empno and heo.subcontract = sm.subcontract and heo.empno = td.empno
         and hem.emptype in ('S','O') and td.yymm = p_yymm UNION
       select distinct hem1.parent from hr_emplmast_main hem1, hr_emplmast_organization heo1
         where hem1.empno = heo1.empno
         and hem1.empno not in (select distinct empno from time_daily where yymm = p_yymm)
         and hem1.emptype in ('S','O') and hem1.status = 1 and to_char(hem1.doj, 'yyyymm') <= p_yymm UNION
       select distinct hem2.parent from hr_emplmast_main hem2, hr_emplmast_organization heo2
         where hem2.empno = heo2.empno
         and hem2.empno not in (select distinct empno from time_daily where yymm = p_yymm)
         and hem2.emptype in ('S', 'O')
         and hem2.status = 0 and to_char(heo2.dol, 'yyyymm') = p_yymm) order by parent);

       /*select ''''||listagg(parent,''',''') within group ( order by parent )||''','||''''||'xxx'||''' as "TOTAL"' into v_clause
        from (select parent from (select distinct td.parent
        from hr_emplmast_main hem, hr_emplmast_organization heo, subcontractmast sm, time_daily td
        where hem.empno = heo.empno and heo.subcontract = sm.subcontract and heo.empno = td.empno
        and hem.emptype = 'S' and td.yymm = p_yymm UNION
        select costcode parent from hr_costmast_main hcm where hcm.costcode in ('0107','0181')) order by parent);*/

       select ''''||listagg(parent,''',''') within group ( order by parent )||''','||''''||'xxx'||''' as "TOTAL"' into v_clause
        from (select parent from (select distinct td.parent
         from hr_emplmast_main hem, hr_emplmast_organization heo, subcontractmast sm, time_daily td
         where hem.empno = heo.empno and heo.subcontract = sm.subcontract and heo.empno = td.empno
         and hem.emptype in ('S','O') and td.yymm = p_yymm UNION
       select distinct hem1.parent from hr_emplmast_main hem1, hr_emplmast_organization heo1
         where hem1.empno = heo1.empno
         and hem1.empno not in (select distinct empno from time_daily where yymm = p_yymm)
         and hem1.emptype in ('S','O') and hem1.status = 1 and to_char(hem1.doj, 'yyyymm') <= p_yymm UNION
       select distinct hem2.parent from hr_emplmast_main hem2, hr_emplmast_organization heo2
         where hem2.empno = heo2.empno
         and hem2.empno not in (select distinct empno from time_daily where yymm = p_yymm)
         and hem2.emptype in ('S', 'O')
         and hem2.status = 0 and to_char(heo2.dol, 'yyyymm') = p_yymm) order by parent);

        /*v_stmt := 'select case gr_subcontract when 1 then ''Total'' else subcontract end subcontract,  ';
        v_stmt := v_stmt || ' hr_pkg_common.get_subcontract_name(subcontract) "SUBCONTRACT NAME", ';
        v_stmt := v_stmt || v_columns ;
        v_stmt := v_stmt || ' from (select case grouping(td.parent) when 1 then ''xxx'' else td.parent end parent,  ';
        v_stmt := v_stmt || ' heo.subcontract,grouping(heo.subcontract) gr_subcontract, count(heo.empno) emp  ';
        v_stmt := v_stmt || ' from hr_emplmast_main hem, hr_emplmast_organization heo, subcontractmast sm, time_daily td   ';
        v_stmt := v_stmt || ' where hem.empno = heo.empno and heo.subcontract = sm.subcontract and heo.empno = td.empno  ';
        v_stmt := v_stmt || ' and hem.emptype = ''S'' and td.yymm = ''' || p_yymm || ''' ';
        v_stmt := v_stmt || ' group by cube(td.parent, heo.subcontract ))  ';
        v_stmt := v_stmt || ' pivot  (  ';
        v_stmt := v_stmt || '   sum(emp) for parent in ('|| v_clause ||')  ';
        v_stmt := v_stmt || ' )  ';
        v_stmt := v_stmt || ' order by gr_subcontract, subcontract ';*/

        v_stmt := ' select case gr_subcontract when 1 then ''Total'' else subcontract end subcontract, ';
        v_stmt := v_stmt || ' hr_pkg_common.get_subcontract_name(subcontract) "SUBCONTRACT NAME", ';
        v_stmt := v_stmt || v_columns ;
        v_stmt := v_stmt || ' from (select case grouping(ut.parent) when 1 then ''xxx'' else ut.parent end parent,  ';
        v_stmt := v_stmt || ' ut.subcontract,grouping(ut.subcontract) gr_subcontract, count(ut.empno) emp from ( ';
        v_stmt := v_stmt || ' select distinct td.parent, heo.subcontract, td.empno ';
        v_stmt := v_stmt || '         from hr_emplmast_main hem, hr_emplmast_organization heo, subcontractmast sm, time_daily td ';
        v_stmt := v_stmt || '         where hem.empno = heo.empno and heo.subcontract = sm.subcontract and heo.empno = td.empno ';
        v_stmt := v_stmt || '         and hem.emptype in (''S'',''O'') and td.yymm = ''' || p_yymm || ''' UNION ';
        v_stmt := v_stmt || ' select distinct hem1.parent, heo1.subcontract, hem1.empno ';
        v_stmt := v_stmt || '     from hr_emplmast_main hem1, hr_emplmast_organization heo1  ';
        v_stmt := v_stmt || '     where hem1.empno = heo1.empno ';
        v_stmt := v_stmt || '     and hem1.empno not in (select distinct empno from time_daily where yymm = ''' || p_yymm || ''' ) ';
        v_stmt := v_stmt || '     and hem1.emptype in (''S'',''O'') ';
        v_stmt := v_stmt || '     and hem1.status = 1 and to_char(hem1.doj, ''yyyymm'') <= ''' || p_yymm || ''' UNION ';
        v_stmt := v_stmt || ' select distinct hem2.parent, heo2.subcontract, hem2.empno ';
        v_stmt := v_stmt || '     from hr_emplmast_main hem2, hr_emplmast_organization heo2 ';
        v_stmt := v_stmt || '     where hem2.empno = heo2.empno ';
        v_stmt := v_stmt || '     and hem2.empno not in (select distinct empno from time_daily where yymm = ''' || p_yymm || ''') ';
        v_stmt := v_stmt || '     and hem2.emptype in (''S'',''O'') ';
        v_stmt := v_stmt || '     and hem2.status = 0 and to_char(heo2.dol, ''yyyymm'') = ''' || p_yymm || ''' ';
        v_stmt := v_stmt || ' ) ut ';
        v_stmt := v_stmt || ' group by cube(ut.parent, ut.subcontract ))  ';
        v_stmt := v_stmt || ' pivot  (  ';
        v_stmt := v_stmt || '   sum(emp) for parent in ('|| v_clause ||')  ';
        v_stmt := v_stmt || '  )  ';
        v_stmt := v_stmt || ' order by gr_subcontract, subcontract ';

        --dbms_output.put_line(v_stmt);
        open c for v_stmt;

        apex_json.initialize_clob_output ( p_indent => 2 );
        apex_json.open_object;
        apex_json.write('Pivot', c);
        apex_json.close_object;
        return apex_json.get_clob_output;
        apex_json.free_output;
        --return c;

   end; --get_subcontract_emp_parentwise

   procedure get_subcontract_emp_parent_os(p_yymm in varchar2, p_result out sys_refcursor) as
       v_stmt   varchar2(1000);
     begin
       open p_result for v_stmt;
   end get_subcontract_emp_parent_os;

   procedure get_outsource_emp(
        p_yymm in varchar2,
        p_result out sys_refcursor) as
       v_stmt   varchar2(1000);
     begin
       v_stmt := 'select hr_pkg_common.get_subcontract_4_empno(empno)  subcontract, empno, ';
       v_stmt := v_stmt || ' hr_pkg_common.get_employee_name(empno) name, projno, d1, d2, d3, d4, d5,  ';
       v_stmt := v_stmt || ' d6, d7, d8, d9, d10, d11, d12, d13, d14, d15, d16, d17, d18, d19, d20,  ';
       v_stmt := v_stmt || ' d21, d22, d23, d24, d25, d26, d27, d28, d29, d30, d31, total, assign,  ';
       v_stmt := v_stmt || ' wpcode, yymm, activity, grp, parent ';
       v_stmt := v_stmt || ' from time_daily  ';
       v_stmt := v_stmt || ' where empno like ''W%'' and yymm = ' || p_yymm;
       open p_result for v_stmt;
   end get_outsource_emp;

   procedure get_subcontract_emp(
        p_result out sys_refcursor) as
       v_stmt   varchar2(1000);
     begin
       v_stmt := 'select hem.empno, decode(hea.payroll,1,''TRUE'',''FALSE'') payroll, hem.name, hem.parent, hem.assign, ';
       v_stmt := v_stmt || ' to_char(hem.dob,''dd-Mon-yy'') dob, to_char(hem.doj,''dd-Mon-yy'') doj, ';
       v_stmt := v_stmt || ' hr_pkg_common.get_designation(hem.desgcode) desg, hem.emptype, hem.grade, heo.subcontract, ';
       v_stmt := v_stmt || ' hr_pkg_common.get_subcontract_name(heo.subcontract) subcontractname ';
       v_stmt := v_stmt || ' from hr_emplmast_main hem, hr_emplmast_organization heo, hr_emplmast_applications hea ';
       v_stmt := v_stmt || ' where hem.empno = heo.empno and hem.empno = hea.empno and hea.payroll = 1 ';
       v_stmt := v_stmt || ' and emptype = ''S'' ';
       open p_result for v_stmt;
   end get_subcontract_emp;

   procedure get_contract_emp(p_result out sys_refcursor) as
       v_stmt   varchar2(1000);
     begin
       v_stmt := 'select hem.empno, decode(hea.payroll,1,''TRUE'',''FALSE'') payroll, hem.name, hem.parent, hem.assign, ';
       v_stmt := v_stmt || ' to_char(hem.dob,''dd-Mon-yy'') dob, to_char(hem.doj,''dd-Mon-yy'') doj, ';
       v_stmt := v_stmt || ' hr_pkg_common.get_designation(hem.desgcode) desg, hem.emptype, hem.grade, heo.subcontract, ';
       v_stmt := v_stmt || ' hr_pkg_common.get_subcontract_name(heo.subcontract) subcontractname ';
       v_stmt := v_stmt || ' from hr_emplmast_main hem, hr_emplmast_organization heo, hr_emplmast_applications hea ';
       v_stmt := v_stmt || ' where hem.empno = heo.empno and hem.empno = hea.empno and hea.payroll = 1 ';
       v_stmt := v_stmt || ' and emptype = ''C'' ';
       open p_result for v_stmt;
   end get_contract_emp;

   procedure get_monthly_consolidated(p_yymm in varchar2, p_final out sys_refcursor, p_final_all Out Sys_Refcursor, p_left_all Out Sys_Refcursor,
                p_mptotal out sys_refcursor, p_mptotal_delhi out sys_refcursor, p_mptotal187 out sys_refcursor,
                p_grade out sys_refcursor, p_grade_delhi out sys_refcursor, p_grade187 out sys_refcursor,
                p_age out sys_refcursor, p_age_delhi out sys_refcursor, p_age187 out sys_refcursor,
                p_experience out sys_refcursor, p_experience_delhi out sys_refcursor, p_experience187 out sys_refcursor,
                p_sex out sys_refcursor, p_sex_delhi out sys_refcursor, p_sex187 out sys_refcursor,
                p_manpower out sys_refcursor, p_manpower_delhi out sys_refcursor) as
       v_last_date              date;
       v_previous_last_date     date;
       v_filter_date            date;
       v_pre_month_last_date    date;
       v_this_month_first_date  date;
       v_start_period           date;
       v_mm_yyyy                varchar2(7);
     begin
       v_mm_yyyy := substr(p_yymm, 5, 2)||'-'||substr(p_yymm, 1, 4);
       select last_day(to_date('01-'||v_mm_yyyy, 'dd-mm-yyyy')) into v_last_date from dual;
       select last_day(to_date('01-'||v_mm_yyyy, 'dd-mm-yyyy')) - 1 into v_previous_last_date from dual;
       select to_date('01-'||v_mm_yyyy, 'dd-mm-yyyy') - 1 into v_pre_month_last_date from dual;
       select to_date('01-'||v_mm_yyyy, 'dd-mm-yyyy') into v_this_month_first_date from dual;

       if p_yymm <= '202312' then
          v_filter_date := v_last_date;
          v_start_period := v_this_month_first_date;
       else
          v_filter_date := v_previous_last_date;
          v_start_period := v_pre_month_last_date;
       end if;

       open p_final for
       'select rownum srno, t.* from
               (select em.empno, initcap(em.name) name, em.emptype status, em.parent, cm.name||''(''||cm.abbr||'')'' costname, em.assign,
                case when em.company = ''TICB'' then ''TCMPL'' else em.company end company,
                em.grade, hr_pkg_common.get_designation(em.desgcode) designation, em.dob, em.doj, em.doc, em.sex,
                round(months_between(to_date(:v_last_date),to_date(em.dob)) / 12) age,
                hr_pkg_common.get_age_group(round(months_between(to_date(:v_last_date), to_date(em.dob)) / 12)) age_group, eo.expbefore, eo.diploma_year, 
                eo.gradyear, eo.postgraduation_year, round(eo.expbefore + months_between(to_date(:v_last_date), to_date(em.doj)) / 12) exp,
                hr_pkg_common.get_experience_group(round(eo.expbefore + months_between(to_date(:v_last_date) ,to_date(em.doj)) / 12)) exp_group,
                hr_pkg_common.get_graduation(eo.graduation) graduation, hr_pkg_common.get_qualification(eo.empno) qualification,
                hr_pkg_common.get_engg_nonengg_status(em.parent) discipline, eo.qual_group,
                tcmpl_hr.pkg_common.fn_get_office_location_desc(tcmpl_hr.pkg_common.fn_get_emp_office_location(eo.empno)) officelocation
                from hr_emplmast_main em, hr_emplmast_organization eo, hr_costmast_main cm
                where em.empno = eo.empno and em.parent = cm.costcode and em.emptype in (''R'', ''C'', ''F'') and em.status = 1
                and em.empno not in (''04132'') and em.parent not in (''0187'') and to_char(em.doj,''yyyymm'') <= :p_yymm
                and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where to_char(oee.relieving_date,''yyyymm'') <= :p_yymm and oee.relieving_date <= :v_filter_date)
                order by em.parent, em.empno) t'
               using v_last_date, v_last_date, v_last_date, v_last_date, p_yymm, p_yymm, v_filter_date;

       Open p_final_all For
            ' select rownum srno, t.* from
              (select * from
               (select em.empno, initcap(em.name) name, em.emptype status, em.parent, cm.name||''(''||cm.abbr||'')'' costname, em.assign,
                case when em.company = ''TICB'' then ''TCMPL'' else em.company end company,
                em.grade, hr_pkg_common.get_designation(em.desgcode) designation, em.dob, em.doj, em.doc, em.sex,
                round(months_between(to_date(:v_last_date),to_date(em.dob)) / 12) age,
                hr_pkg_common.get_age_group(round(months_between(to_date(:v_last_date), to_date(em.dob)) / 12)) age_group, eo.expbefore, eo.diploma_year, 
                eo.gradyear, eo.postgraduation_year, round(eo.expbefore + months_between(to_date(:v_last_date), to_date(em.doj)) / 12) exp,
                hr_pkg_common.get_experience_group(round(eo.expbefore + months_between(to_date(:v_last_date) ,to_date(em.doj)) / 12)) exp_group,
                hr_pkg_common.get_graduation(eo.graduation) graduation, hr_pkg_common.get_qualification(eo.empno) qualification,
                hr_pkg_common.get_engg_nonengg_status(em.parent) discipline, eo.qual_group,
                hr_pkg_common.get_relieving_date(em.empno) relievedate, '''' resigned,
                tcmpl_hr.pkg_common.fn_get_office_location_desc(tcmpl_hr.pkg_common.fn_get_emp_office_location(eo.empno)) officelocation
                from hr_emplmast_main em, hr_emplmast_organization eo, hr_costmast_main cm
                where em.empno = eo.empno and em.parent = cm.costcode and em.emptype in (''R'', ''C'', ''F'') and em.status = 1
                and em.empno not in (''04132'') and em.parent not in (''0187'') and to_char(em.doj,''yyyymm'') <= :p_yymm
                and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where to_char(oee.relieving_date,''yyyymm'') <= :p_yymm and oee.relieving_date <= :v_filter_date)
                UNION
                select em.empno, initcap(em.name) name, em.emptype status, em.parent, cm.name||''(''||cm.abbr||'')'' costname, em.assign,
                case when em.company = ''TICB'' then ''TCMPL'' else em.company end company,
                em.grade, hr_pkg_common.get_designation(em.desgcode) designation, em.dob, em.doj, em.doc, em.sex,
                round(months_between(to_date(:v_last_date),to_date(em.dob)) / 12) age,
                hr_pkg_common.get_age_group(round(months_between(to_date(:v_last_date), to_date(em.dob)) / 12)) age_group, eo.expbefore, eo.diploma_year, 
                eo.gradyear,  eo.postgraduation_year, round(eo.expbefore + months_between(to_date(:v_last_date), to_date(em.doj)) / 12) exp,
                hr_pkg_common.get_experience_group(round(eo.expbefore + months_between(to_date(:v_last_date) ,to_date(em.doj)) / 12)) exp_group,
                hr_pkg_common.get_graduation(eo.graduation) graduation, hr_pkg_common.get_qualification(eo.empno) qualification,
                hr_pkg_common.get_engg_nonengg_status(em.parent) discipline, eo.qual_group,
                hr_pkg_common.get_relieving_date(em.empno) relievedate, ''Yes'' resigned,
                tcmpl_hr.pkg_common.fn_get_office_location_desc(tcmpl_hr.pkg_common.fn_get_emp_office_location(eo.empno)) officelocation
                from hr_emplmast_main em, hr_emplmast_organization eo, hr_costmast_main cm
                where em.empno = eo.empno and em.parent = cm.costcode and em.emptype in (''R'', ''C'', ''F'')
                and em.empno not in (''04132'') and em.parent not in (''0187'') and to_char(em.doj,''yyyymm'') <= :p_yymm
                and em.empno in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where oee.relieving_date >= :v_start_period and oee.relieving_date <= :v_filter_date)
              )
              order by resigned, relievedate, parent, empno) t'
            Using v_last_date, v_last_date, v_last_date, v_last_date, p_yymm, p_yymm, v_filter_date,
                  v_last_date, v_last_date, v_last_date, v_last_date, p_yymm, v_start_period, v_filter_date;

       Open p_left_all for
        'select rownum srno, t.* from
              (select * from
               (select em.emptype, em.parent, em.category, em.grade, em.empno, em.name, em.personid,
                em.empno empno1, em.name name1, em.parent parent1, hr_pkg_common.get_costcenter_abbr(em.parent) parentname,
                em.grade grade1, hr_pkg_common.get_designation(em.desgcode) designation, em.dob, em.doj, em.doc,
                em.sex, hr_pkg_common.get_graduation(eo.graduation) graduation, hr_pkg_common.get_qualification(eo.empno) qualification,
                hr_pkg_common.get_engg_nonengg_status(em.parent) discipline, hr_pkg_common.get_relieving_date(em.empno) relievedate, '''' resigned,
                tcmpl_hr.pkg_common.fn_get_office_location_desc(tcmpl_hr.pkg_common.fn_get_emp_office_location(eo.empno)) officelocation
                from hr_emplmast_main em, hr_emplmast_organization eo, hr_costmast_main cm
                where em.empno = eo.empno and em.parent = cm.costcode and em.emptype in (''R'', ''C'', ''F'') and em.status = 1
                and em.empno not in (''04132'') and em.parent not in (''0187'') and to_char(em.doj,''yyyymm'') <= :p_yymm
                and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where to_char(oee.relieving_date,''yyyymm'') <= :p_yymm and oee.relieving_date <= :v_filter_date)
                UNION
                select em.emptype, em.parent, em.category, em.grade, em.empno, em.name, em.personid,
                em.empno empno1, em.name name1, em.parent parent1, hr_pkg_common.get_costcenter_abbr(em.parent) parentname,
                em.grade grade1, hr_pkg_common.get_designation(em.desgcode) designation, em.dob, em.doj, em.doc,
                em.sex, hr_pkg_common.get_graduation(eo.graduation) graduation, hr_pkg_common.get_qualification(eo.empno) qualification,
                hr_pkg_common.get_engg_nonengg_status(em.parent) discipline, hr_pkg_common.get_relieving_date(em.empno) relievedate, ''Yes'' resigned,
                tcmpl_hr.pkg_common.fn_get_office_location_desc(tcmpl_hr.pkg_common.fn_get_emp_office_location(eo.empno)) officelocation
                from hr_emplmast_main em, hr_emplmast_organization eo, hr_costmast_main cm
                where em.empno = eo.empno and em.parent = cm.costcode and em.emptype in (''R'', ''C'', ''F'')
                and em.empno not in (''04132'') and em.parent not in (''0187'') and to_char(em.doj,''yyyymm'') <= :p_yymm
                and em.empno in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where oee.relieving_date >= :v_start_period and oee.relieving_date <= :v_filter_date)
              )
              order by resigned, relievedate, parent, empno) t'
            Using p_yymm, p_yymm, v_filter_date,
                  p_yymm, v_start_period, v_filter_date;

       ---- MPortal ----
       open p_mptotal for
       'select rownum srno, a.* from (
        select * from (
           select em.parent, cm.name||'' (''||cm.abbr||'')'' costname, em.emptype
            from hr_costmast_main cm, hr_emplmast_main em, hr_emplmast_organization eo
            where em.empno = eo.empno and em.parent = cm.costcode and
              em.emptype in (''R'', ''C'', ''F'') and em.status = 1 and em.parent not in (''0187'')
              and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
              and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where oee.relieving_date <= :v_filter_date)
              and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG003'',''CG004''))
        )
        pivot (
           count(emptype)
           for emptype in (''R'' as regular, ''F'' as fixed, ''C'' as contract)
        ) order by parent) a'
        using p_yymm, v_filter_date;

       open p_mptotal_delhi for
       'select rownum srno, a.* from (
        select * from (
           select em.parent, cm.name||'' (''||cm.abbr||'')'' costname, em.emptype
            from hr_costmast_main cm, hr_emplmast_main em, hr_emplmast_organization eo
            where em.empno = eo.empno and em.parent = cm.costcode and
              em.emptype in (''R'', ''C'', ''F'') and em.status = 1 and em.parent not in (''0187'')
              and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
              and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where oee.relieving_date <= :v_filter_date)
              and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG005'',''CG006''))
        )
        pivot (
           count(emptype)
           for emptype in (''R'' as regular, ''F'' as fixed, ''C'' as contract)
        ) order by parent) a'
        using p_yymm, v_filter_date;

       open p_mptotal187 for
       'select rownum srno1, a.* from (
        select * from (
           select em.parent parent1, cm.name||'' (''||cm.abbr||'')'' costname1, em.emptype
            from hr_costmast_main cm, hr_emplmast_main em, hr_emplmast_organization eo
            where em.empno = eo.empno and em.parent = cm.costcode and
              em.emptype in (''R'', ''C'', ''F'') and em.status = 1 and em.parent in (''0187'')
              and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
        )
        pivot (
           count(emptype)
           for emptype in (''R'' as regular1, ''F'' as fixed1, ''C'' as contract1)
        ) order by parent1) a'
        using p_yymm;

       ---- Grade ----
       open p_grade for
       'select rownum srno, a.* from (
        select * from (
           select em.parent, cm.name||'' (''||cm.abbr||'')'' costname,
            case when em.emptype = ''C'' then ''C''
                when em.emptype = ''F'' then ''F''
                else em.grade end grade
            from hr_costmast_main cm, hr_emplmast_main em, hr_emplmast_organization eo
            where em.empno = eo.empno and em.parent = cm.costcode and
              em.emptype in (''R'', ''C'', ''F'') and em.status = 1 and em.parent not in (''0187'')
              and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
              and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where oee.relieving_date <= :v_filter_date)
              and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG003'',''CG004''))
        )
        pivot (
           count(grade)
           for grade in (''X1'' as x1, ''X2'' as x2, ''A1'' as a1, ''A2'' as a2,
             ''A3'' as a3, ''B1'' b1, ''B2'' as b2, ''B3'' as b3, ''C1'' as c1,
             ''C2'' as c2, ''T1'' as t1, ''T2'' as t2, ''F'' as fixed, ''C'' as contract)
        ) order by parent) a'
        using p_yymm, v_filter_date;

        open p_grade_delhi for
       'select rownum srno, a.* from (
        select * from (
           select em.parent, cm.name||'' (''||cm.abbr||'')'' costname,
            case when em.emptype = ''C'' then ''C''
                when em.emptype = ''F'' then ''F''
                else em.grade end grade
            from hr_costmast_main cm, hr_emplmast_main em, hr_emplmast_organization eo
            where em.empno = eo.empno and em.parent = cm.costcode and
              em.emptype in (''R'', ''C'', ''F'') and em.status = 1 and em.parent not in (''0187'')
              and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
              and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where oee.relieving_date <= :v_filter_date)
              and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG005'',''CG006''))
        )
        pivot (
           count(grade)
           for grade in (''X1'' as x1, ''X2'' as x2, ''A1'' as a1, ''A2'' as a2,
             ''A3'' as a3, ''B1'' b1, ''B2'' as b2, ''B3'' as b3, ''C1'' as c1,
             ''C2'' as c2, ''T1'' as t1, ''T2'' as t2, ''F'' as fixed, ''C'' as contract)
        ) order by parent) a'
        using p_yymm, v_filter_date;

       open p_grade187 for
       'select rownum srno_a, a.* from (
        select * from (
           select em.parent parent_a, cm.name||'' (''||cm.abbr||'')'' costname_a,
            case when em.emptype = ''C'' then ''C''
                when em.emptype = ''F'' then ''F''
                else em.grade end grade
            from hr_costmast_main cm, hr_emplmast_main em, hr_emplmast_organization eo
            where em.empno = eo.empno and em.parent = cm.costcode and
              em.emptype in (''R'', ''C'', ''F'') and em.status = 1 and em.parent in (''0187'')
              and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
        )
        pivot (
           count(grade)
           for grade in (''X1'' as x1_a, ''X2'' as x2_a, ''A1'' as a1_a, ''A2'' as a2_a,
             ''A3'' as a3_a, ''B1'' b1_a, ''B2'' as b2_a, ''B3'' as b3_a, ''C1'' as c1_a,
             ''C2'' as c2_a, ''T1'' as t1_a, ''T2'' as t2_a, ''F'' as fixed_a, ''C'' as contract_a)
        ) order by parent_a) a'
        using p_yymm;

       ---- Age ----
       open p_age for
       'select rownum srno, a.* from (
        select * from (
           select em.parent, cm.name||'' (''||cm.abbr||'')'' costname,
           hr_pkg_common.get_age_group(round(months_between(to_date(:v_last_date),to_date(em.dob)) / 12)) age_group
           from hr_emplmast_main em, hr_costmast_main cm
           where em.parent = cm.costcode and em.emptype in (''R'', ''C'', ''F'') and em.status = 1 and em.parent not in (''0187'')
             and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
             and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where oee.relieving_date <= :v_filter_date)
             and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG003'',''CG004''))
        )
        pivot (
           count(age_group)
           for age_group in (''0-25'' as a, ''26-35'' as b, ''36-45'' as c, ''46-55'' as d, ''Above 55'' as e)
        ) order by parent) a'
       using v_last_date, p_yymm, v_filter_date;

       open p_age_delhi for
       'select rownum srno, a.* from (
        select * from (
           select em.parent, cm.name||'' (''||cm.abbr||'')'' costname,
           hr_pkg_common.get_age_group(round(months_between(to_date(:v_last_date),to_date(em.dob)) / 12)) age_group
           from hr_emplmast_main em, hr_costmast_main cm
           where em.parent = cm.costcode and em.emptype in (''R'', ''C'', ''F'') and em.status = 1 and em.parent not in (''0187'')
             and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
             and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where oee.relieving_date <= :v_filter_date)
             and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG005'',''CG006''))
        )
        pivot (
           count(age_group)
           for age_group in (''0-25'' as a, ''26-35'' as b, ''36-45'' as c, ''46-55'' as d, ''Above 55'' as e)
        ) order by parent) a'
       using v_last_date, p_yymm, v_filter_date;

       open p_age187 for
       'select rownum srno1, a.* from (
        select * from (
           select em.parent parent1, cm.name||'' (''||cm.abbr||'')'' costname1,
           hr_pkg_common.get_age_group(round(months_between(to_date(:v_last_date), to_date(em.dob)) / 12)) age_group
           from hr_emplmast_main em, hr_costmast_main cm
           where em.parent = cm.costcode and em.emptype in (''R'', ''C'', ''F'') and em.status = 1 and em.parent in (''0187'')
             and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm)
        pivot (
           count(age_group)
           for age_group in (''0-25'' as a1, ''26-35'' as b1, ''36-45'' as c1, ''46-55'' as d1, ''Above 55'' as e1)
        ) order by parent1) a'
       using v_last_date, p_yymm;

       ---- Experience ----
       open p_experience for
       'select rownum srno, a.* from (
        select * from (
           select em.parent, cm.name||'' (''||cm.abbr||'')'' costname,
            hr_pkg_common.get_experience_group(round(eo.expbefore + months_between(to_date(:v_last_date), to_date(em.doj)) / 12)) exp_group
            from hr_emplmast_main em, hr_emplmast_organization eo, hr_costmast_main cm
            where em.parent = cm.costcode and em.empno = eo.empno and em.emptype in (''R'', ''C'', ''F'')
              and em.status = 1 and em.parent not in (''0187'') and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
              and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where oee.relieving_date <= :v_filter_date)
              and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG003'',''CG004''))
        )
        pivot (
           count(exp_group)
           for exp_group in (''00-03'' as a, ''04-07'' as b, ''08-10'' as c, ''11-15'' as d, ''16-20'' as e, ''21-25'' as f, ''26 Above'' as g)
        ) order by parent) a'
       using v_last_date, p_yymm, v_filter_date;

       open p_experience_delhi for
       'select rownum srno, a.* from (
        select * from (
           select em.parent, cm.name||'' (''||cm.abbr||'')'' costname,
            hr_pkg_common.get_experience_group(round(eo.expbefore + months_between(to_date(:v_last_date), to_date(em.doj)) / 12)) exp_group
            from hr_emplmast_main em, hr_emplmast_organization eo, hr_costmast_main cm
            where em.parent = cm.costcode and em.empno = eo.empno and em.emptype in (''R'', ''C'', ''F'')
              and em.status = 1 and em.parent not in (''0187'') and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
              and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where oee.relieving_date <= :v_filter_date)
              and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG005'',''CG006''))
        )
        pivot (
           count(exp_group)
           for exp_group in (''00-03'' as a, ''04-07'' as b, ''08-10'' as c, ''11-15'' as d, ''16-20'' as e, ''21-25'' as f, ''26 Above'' as g)
        ) order by parent) a'
       using v_last_date, p_yymm, v_filter_date;

       open p_experience187 for
       'select rownum srno1, a.* from (
        select * from (
           select em.parent parent1, cm.name||'' (''||cm.abbr||'')'' costname1,
            hr_pkg_common.get_experience_group(round(eo.expbefore + months_between(to_date(:v_last_date), to_date(em.doj)) / 12)) exp_group
            from hr_emplmast_main em, hr_emplmast_organization eo, hr_costmast_main cm
            where em.parent = cm.costcode and em.empno = eo.empno and em.emptype in (''R'', ''C'', ''F'')
              and em.status = 1 and em.parent in (''0187'') and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
        )
        pivot (
           count(exp_group)
           for exp_group in (''00-03'' as a1, ''04-07'' as b1, ''08-10'' as c1, ''11-15'' as d1, ''16-20'' as e1, ''21-25'' as f1, ''26 Above'' as g1)
        ) order by parent1) a'
       using v_last_date, p_yymm;

       ---- Sex ----
       open p_sex for
       'select rownum srno, a.* from (
        select * from (
           select em.parent, cm.name||'' (''||cm.abbr||'')'' costname, em.sex
            from hr_costmast_main cm, hr_emplmast_main em, hr_emplmast_organization eo
            where em.empno = eo.empno and em.parent = cm.costcode and
              em.emptype in (''R'', ''C'', ''F'') and em.status = 1 and em.parent not in (''0187'')
              and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
              and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where oee.relieving_date <= :v_filter_date)
              and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG003'',''CG004''))
        )
        pivot (
           count(sex)
           for sex in (''F'' as female, ''M'' as male)
        ) order by parent) a'
        using p_yymm, v_filter_date;

        open p_sex_delhi for
       'select rownum srno, a.* from (
        select * from (
           select em.parent, cm.name||'' (''||cm.abbr||'')'' costname, em.sex
            from hr_costmast_main cm, hr_emplmast_main em, hr_emplmast_organization eo
            where em.empno = eo.empno and em.parent = cm.costcode and
              em.emptype in (''R'', ''C'', ''F'') and em.status = 1 and em.parent not in (''0187'')
              and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
              and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where oee.relieving_date <= :v_filter_date)
              and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG005'',''CG006''))
        )
        pivot (
           count(sex)
           for sex in (''F'' as female, ''M'' as male)
        ) order by parent) a'
        using p_yymm, v_filter_date;

        open p_sex187 for
       'select rownum srno1, a.* from (
        select * from (
           select em.parent parent1, cm.name||'' (''||cm.abbr||'')'' costname1, em.sex
            from hr_costmast_main cm, hr_emplmast_main em, hr_emplmast_organization eo
            where em.empno = eo.empno and em.parent = cm.costcode and
              em.emptype in (''R'', ''C'', ''F'') and em.status = 1 and em.parent in (''0187'')
              and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
        )
        pivot (
           count(sex)
           for sex in (''F'' as female1, ''M'' as male1)
        ) order by parent1) a'
        using p_yymm;

        --- Manpower wise ---
        open p_manpower for
        'select groupname, parent, max(costname) costname, sum(regular) regular, sum(fixed) fixed, sum(contract) contract from (
            select * from (
               select hr_pkg_common.get_manpower_group(parent) groupname, em.parent, cm.name||'' (''||cm.abbr||'')'' costname, em.emptype
                from hr_costmast_main cm, hr_emplmast_main em, hr_emplmast_organization eo
                where em.empno = eo.empno and em.parent = cm.costcode and
                  em.emptype in (''R'', ''C'', ''F'') and em.status = 1 and em.parent not in (''0187'')
                  and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
                  and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where oee.relieving_date <= :v_filter_date)
                  and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG003'', ''CG004''))
            )
            pivot (
               count(emptype)
               for emptype in (''R'' as regular, ''F'' as fixed, ''C'' as contract)
            ) order by parent
        ) a
        group by rollup (groupname, parent)'
        using p_yymm, v_filter_date;

        open p_manpower_delhi for
        'select groupname, parent, max(costname) costname, sum(regular) regular, sum(fixed) fixed, sum(contract) contract from (
            select * from (
               select hr_pkg_common.get_manpower_group(parent) groupname, em.parent, cm.name||'' (''||cm.abbr||'')'' costname, em.emptype
                from hr_costmast_main cm, hr_emplmast_main em, hr_emplmast_organization eo
                where em.empno = eo.empno and em.parent = cm.costcode and
                  em.emptype in (''R'', ''C'', ''F'') and em.status = 1 and em.parent not in (''0187'')
                  and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
                  and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where oee.relieving_date <= :v_filter_date)
                  and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG005'', ''CG006''))
            )
            pivot (
               count(emptype)
               for emptype in (''R'' as regular, ''F'' as fixed, ''C'' as contract)
            ) order by parent
        ) a
        group by rollup (groupname, parent)'
        using p_yymm, v_filter_date;
   end get_monthly_consolidated;

   procedure get_monthly_consolidated_engg(p_yymm in varchar2, p_final out sys_refcursor, p_final_all Out Sys_Refcursor, p_left_all Out Sys_Refcursor,
                p_mptotal out sys_refcursor, p_mptotal_delhi out sys_refcursor, p_mptotal187 out sys_refcursor,
                p_grade out sys_refcursor, p_grade_delhi out sys_refcursor, p_grade187 out sys_refcursor,
                p_age out sys_refcursor, p_age_delhi out sys_refcursor, p_age187 out sys_refcursor,
                p_experience out sys_refcursor, p_experience_delhi out sys_refcursor, p_experience187 out sys_refcursor,
                p_sex out sys_refcursor, p_sex_delhi out sys_refcursor, p_sex187 out sys_refcursor,
                p_manpower out sys_refcursor, p_manpower_delhi out sys_refcursor) as
       v_last_date          date;
       v_previous_last_date date;
       v_filter_date        date;
       v_pre_month_last_date    date;
       v_this_month_first_date  date;
       v_start_period           date;
       v_mm_yyyy            varchar2(7);
     begin
       v_mm_yyyy := substr(p_yymm, 5, 2)||'-'||substr(p_yymm, 1, 4);
       select last_day(to_date('01-'||v_mm_yyyy, 'dd-mm-yyyy')) into v_last_date from dual;
       select last_day(to_date('01-'||v_mm_yyyy, 'dd-mm-yyyy')) - 1 into v_previous_last_date from dual;
       select to_date('01-'||v_mm_yyyy, 'dd-mm-yyyy') - 1 into v_pre_month_last_date from dual;
       select to_date('01-'||v_mm_yyyy, 'dd-mm-yyyy') into v_this_month_first_date from dual;

       if p_yymm <= '202312' then
          v_filter_date := v_last_date;
          v_start_period := v_this_month_first_date;
       else
          v_filter_date := v_previous_last_date;
          v_start_period := v_pre_month_last_date;
       end if;

       /*if p_yymm <= '202312' then
          v_filter_date := v_last_date;
       else
          v_filter_date := v_previous_last_date;
       end if;*/

       open p_final for
       'select rownum srno, t.* from
              (select em.empno, initcap(em.name) name, em.emptype status, em.parent, cm.name||''(''||cm.abbr||'')'' costname, em.assign,
                case when em.company = ''TICB'' then ''TCMPL'' else em.company end company,
                em.grade, hr_pkg_common.get_designation(em.desgcode) designation, em.dob, em.doj, em.doc, em.sex,
                round(months_between(to_date(:v_last_date),to_date(em.dob)) / 12) age,
                hr_pkg_common.get_age_group(round(months_between(to_date(:v_last_date), to_date(em.dob)) / 12)) age_group, eo.expbefore, eo.diploma_year, 
                eo.gradyear, eo.postgraduation_year, round(eo.expbefore + months_between(to_date(:v_last_date), to_date(em.doj)) / 12) exp,
                hr_pkg_common.get_experience_group(round(eo.expbefore + months_between(to_date(:v_last_date) ,to_date(em.doj)) / 12)) exp_group,
                hr_pkg_common.get_graduation(eo.graduation) graduation, hr_pkg_common.get_qualification(eo.empno) qualification,
                hr_pkg_common.get_engg_nonengg_status(em.parent) discipline, eo.qual_group,
                tcmpl_hr.pkg_common.fn_get_office_location_desc(tcmpl_hr.pkg_common.fn_get_emp_office_location(eo.empno)) officelocation
                from hr_emplmast_main em, hr_emplmast_organization eo, hr_costmast_main cm
                where em.empno = eo.empno and em.parent = cm.costcode and em.emptype in (''R'', ''C'', ''F'') and em.status = 1
                and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG003'', ''CG005''))
                and em.empno not in (''04132'')
                and to_char(em.doj,''yyyymm'') <= :p_yymm and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee
                where to_char(oee.relieving_date,''yyyymm'') <= :p_yymm and oee.relieving_date <= :v_filter_date)
                order by em.parent, em.empno) t'
               using v_last_date, v_last_date, v_last_date, v_last_date, p_yymm, p_yymm, v_filter_date;

      Open p_final_all For
        'select rownum srno, t.* from
          (select * from
           (select em.empno, initcap(em.name) name, em.emptype status, em.parent, cm.name||''(''||cm.abbr||'')'' costname, em.assign,
            case when em.company = ''TICB'' then ''TCMPL'' else em.company end company,
            em.grade, hr_pkg_common.get_designation(em.desgcode) designation, em.dob, em.doj, em.doc, em.sex,
            round(months_between(to_date(:v_last_date),to_date(em.dob)) / 12) age,
            hr_pkg_common.get_age_group(round(months_between(to_date(:v_last_date), to_date(em.dob)) / 12)) age_group, eo.expbefore, eo.diploma_year, 
            eo.gradyear, eo.postgraduation_year, round(eo.expbefore + months_between(to_date(:v_last_date), to_date(em.doj)) / 12) exp,
            hr_pkg_common.get_experience_group(round(eo.expbefore + months_between(to_date(:v_last_date) ,to_date(em.doj)) / 12)) exp_group,
            hr_pkg_common.get_graduation(eo.graduation) graduation, hr_pkg_common.get_qualification(eo.empno) qualification,
            hr_pkg_common.get_engg_nonengg_status(em.parent) discipline, eo.qual_group,
            hr_pkg_common.get_relieving_date(em.empno) relievedate, '''' resigned,
            tcmpl_hr.pkg_common.fn_get_office_location_desc(tcmpl_hr.pkg_common.fn_get_emp_office_location(eo.empno)) officelocation
            from hr_emplmast_main em, hr_emplmast_organization eo, hr_costmast_main cm
            where em.empno = eo.empno and em.parent = cm.costcode and em.emptype in (''R'', ''C'', ''F'') and em.status = 1
            and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG003'', ''CG005''))
            and em.empno not in (''04132'')
            and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where to_char(oee.relieving_date,''yyyymm'') <= :p_yymm and oee.relieving_date <= :v_filter_date)
            and to_char(em.doj,''yyyymm'') <= :p_yymm
            UNION
            select em.empno, initcap(em.name) name, em.emptype status, em.parent, cm.name||''(''||cm.abbr||'')'' costname, em.assign,
            case when em.company = ''TICB'' then ''TCMPL'' else em.company end company,
            em.grade, hr_pkg_common.get_designation(em.desgcode) designation, em.dob, em.doj, em.doc, em.sex,
            round(months_between(to_date(:v_last_date),to_date(em.dob)) / 12) age,
            hr_pkg_common.get_age_group(round(months_between(to_date(:v_last_date), to_date(em.dob)) / 12)) age_group, eo.expbefore, eo.diploma_year, 
            eo.gradyear, eo.postgraduation_year, round(eo.expbefore + months_between(to_date(:v_last_date), to_date(em.doj)) / 12) exp,
            hr_pkg_common.get_experience_group(round(eo.expbefore + months_between(to_date(:v_last_date) ,to_date(em.doj)) / 12)) exp_group,
            hr_pkg_common.get_graduation(eo.graduation) graduation, hr_pkg_common.get_qualification(eo.empno) qualification,
            hr_pkg_common.get_engg_nonengg_status(em.parent) discipline, eo.qual_group,
            hr_pkg_common.get_relieving_date(em.empno) relievedate, ''Yes'' resigned,
            tcmpl_hr.pkg_common.fn_get_office_location_desc(tcmpl_hr.pkg_common.fn_get_emp_office_location(eo.empno)) officelocation
            from hr_emplmast_main em, hr_emplmast_organization eo, hr_costmast_main cm
            where em.empno = eo.empno and em.parent = cm.costcode and em.emptype in (''R'', ''C'', ''F'')
            and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG003'', ''CG005''))
            and em.empno not in (''04132'')
            and em.empno in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where oee.relieving_date >= :v_start_period and oee.relieving_date <= :v_filter_date)
            and to_char(em.doj,''yyyymm'') <= :p_yymm
        )
        order by resigned, relievedate, parent, empno) t'
        Using v_last_date, v_last_date, v_last_date, v_last_date, p_yymm, v_filter_date, p_yymm,
          v_last_date, v_last_date, v_last_date, v_last_date, v_start_period, v_filter_date, p_yymm;

       Open p_left_all for
            'select rownum srno, t.* from
              (select * from
               (select em.emptype, em.parent, em.category, em.grade, em.empno, em.name, em.personid,
                em.empno empno1, em.name name1, em.parent parent1, hr_pkg_common.get_costcenter_abbr(em.parent) parentname,
                em.grade grade1, hr_pkg_common.get_designation(em.desgcode) designation, em.dob, em.doj, em.doc,
                em.sex, hr_pkg_common.get_graduation(eo.graduation) graduation, hr_pkg_common.get_qualification(eo.empno) qualification,
                hr_pkg_common.get_engg_nonengg_status(em.parent) discipline, hr_pkg_common.get_relieving_date(em.empno) relievedate, '''' resigned,
                tcmpl_hr.pkg_common.fn_get_office_location_desc(tcmpl_hr.pkg_common.fn_get_emp_office_location(eo.empno)) officelocation
                from hr_emplmast_main em, hr_emplmast_organization eo, hr_costmast_main cm
                where em.empno = eo.empno and em.parent = cm.costcode and em.emptype in (''R'', ''C'', ''F'') and em.status = 1
                and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG003'', ''CG005''))
                and em.empno not in (''04132'')
                and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where to_char(oee.relieving_date,''yyyymm'') <= :p_yymm and oee.relieving_date <= :v_filter_date)
                and to_char(em.doj,''yyyymm'') <= :p_yymm
                UNION
                select em.emptype, em.parent, em.category, em.grade, em.empno, em.name name, em.personid,
                em.empno empno1, em.name name1, em.parent parent1, hr_pkg_common.get_costcenter_abbr(em.parent) parentname,
                em.grade grade1, hr_pkg_common.get_designation(em.desgcode) designation, em.dob, em.doj, em.doc,
                em.sex, hr_pkg_common.get_graduation(eo.graduation) graduation, hr_pkg_common.get_qualification(eo.empno) qualification,
                hr_pkg_common.get_engg_nonengg_status(em.parent) discipline, hr_pkg_common.get_relieving_date(em.empno) relievedate,
                ''Yes'' resigned, tcmpl_hr.pkg_common.fn_get_office_location_desc(tcmpl_hr.pkg_common.fn_get_emp_office_location(eo.empno)) officelocation
                from hr_emplmast_main em, hr_emplmast_organization eo, hr_costmast_main cm
                where em.empno = eo.empno and em.parent = cm.costcode and em.emptype in (''R'', ''C'', ''F'')
                and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG003'', ''CG005''))
                and em.empno not in (''04132'')
                and em.empno in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where oee.relieving_date >= :v_start_period and oee.relieving_date <= :v_filter_date)
                and to_char(em.doj,''yyyymm'') <= :p_yymm
            )
            order by resigned, relievedate, parent, empno) t'
         Using p_yymm, v_filter_date, p_yymm, v_start_period, v_filter_date, p_yymm;

       --- MPortal ---
       open p_mptotal for
       'select rownum srno, a.* from (
        select * from (
           select em.parent, cm.name||'' (''||cm.abbr||'')'' costname, em.emptype
            from hr_costmast_main cm, hr_emplmast_main em, hr_emplmast_organization eo
            where em.empno = eo.empno and em.parent = cm.costcode and
              em.emptype in (''R'', ''C'', ''F'') and em.status = 1 and em.parent not in (''0187'')
              and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
              and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where oee.relieving_date <= :v_filter_date)
              and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG003''))
        )
        pivot (
           count(emptype)
           for emptype in (''R'' as regular, ''F'' as fixed, ''C'' as contract)
        ) order by parent) a'
        using p_yymm, v_filter_date;

       open p_mptotal_delhi for
       'select rownum srno, a.* from (
        select * from (
           select em.parent, cm.name||'' (''||cm.abbr||'')'' costname, em.emptype
            from hr_costmast_main cm, hr_emplmast_main em, hr_emplmast_organization eo
            where em.empno = eo.empno and em.parent = cm.costcode and
              em.emptype in (''R'', ''C'', ''F'') and em.status = 1 and em.parent not in (''0187'')
              and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
              and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where oee.relieving_date <= :v_filter_date)
              and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG005''))
        )
        pivot (
           count(emptype)
           for emptype in (''R'' as regular, ''F'' as fixed, ''C'' as contract)
        ) order by parent) a'
        using p_yymm, v_filter_date;

       open p_mptotal187 for
       'select rownum srno1, a.* from (
        select * from (
           select em.parent parent1, cm.name||'' (''||cm.abbr||'')'' costname1, em.emptype
            from hr_costmast_main cm, hr_emplmast_main em, hr_emplmast_organization eo
            where em.empno = eo.empno and em.parent = cm.costcode and
              em.emptype in (''R'', ''C'', ''F'') and em.status = 1 and em.parent in (''0187'')
              and hr_pkg_common.get_tma_grp_4_costcode(em.parent) = ''E''
              and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
        )
        pivot (
           count(emptype)
           for emptype in (''R'' as regular1, ''F'' as fixed1, ''C'' as contract1)
        ) order by parent1) a'
        using p_yymm;

       --- Grade ---
       open p_grade for
       'select rownum srno, a.* from (
        select * from (
           select em.parent, cm.name||'' (''||cm.abbr||'')'' costname,
            case when em.emptype = ''C'' then ''C''
                when em.emptype = ''F'' then ''F''
                else em.grade end grade
            from hr_costmast_main cm, hr_emplmast_main em, hr_emplmast_organization eo
            where em.empno = eo.empno and em.parent = cm.costcode and
              em.emptype in (''R'', ''C'', ''F'') and em.status = 1 and em.parent not in (''0187'')
              and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
              and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where oee.relieving_date <= :v_filter_date)
              and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG003''))
        )
        pivot (
           count(grade)
           for grade in (''X1'' as x1, ''X2'' as x2, ''A1'' as a1, ''A2'' as a2,
             ''A3'' as a3, ''B1'' b1, ''B2'' as b2, ''B3'' as b3, ''C1'' as c1,
             ''C2'' as c2, ''T1'' as t1, ''T2'' as t2, ''F'' as fixed, ''C'' as contract)
        ) order by parent) a'
        using p_yymm, v_filter_date;

       open p_grade_delhi for
       'select rownum srno, a.* from (
        select * from (
           select em.parent, cm.name||'' (''||cm.abbr||'')'' costname,
            case when em.emptype = ''C'' then ''C''
                when em.emptype = ''F'' then ''F''
                else em.grade end grade
            from hr_costmast_main cm, hr_emplmast_main em, hr_emplmast_organization eo
            where em.empno = eo.empno and em.parent = cm.costcode and
              em.emptype in (''R'', ''C'', ''F'') and em.status = 1 and em.parent not in (''0187'')
              and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
              and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where oee.relieving_date <= :v_filter_date)
              and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG005''))
        )
        pivot (
           count(grade)
           for grade in (''X1'' as x1, ''X2'' as x2, ''A1'' as a1, ''A2'' as a2,
             ''A3'' as a3, ''B1'' b1, ''B2'' as b2, ''B3'' as b3, ''C1'' as c1,
             ''C2'' as c2, ''T1'' as t1, ''T2'' as t2, ''F'' as fixed, ''C'' as contract)
        ) order by parent) a'
        using p_yymm, v_filter_date;

       open p_grade187 for
       'select rownum srno_a, a.* from (
        select * from (
           select em.parent parent_a, cm.name||'' (''||cm.abbr||'')'' costname_a,
            case when em.emptype = ''C'' then ''C''
                when em.emptype = ''F'' then ''F''
                else em.grade end grade
            from hr_costmast_main cm, hr_emplmast_main em, hr_emplmast_organization eo
            where em.empno = eo.empno and em.parent = cm.costcode and
              em.emptype in (''R'', ''C'', ''F'') and em.status = 1 and em.parent in (''0187'')
              and hr_pkg_common.get_tma_grp_4_costcode(em.parent) = ''E''
              and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
        )
        pivot (
           count(grade)
           for grade in (''X1'' as x1_a, ''X2'' as x2_a, ''A1'' as a1_a, ''A2'' as a2_a,
             ''A3'' as a3_a, ''B1'' b1_a, ''B2'' as b2_a, ''B3'' as b3_a, ''C1'' as c1_a,
             ''C2'' as c2_a, ''T1'' as t1_a, ''T2'' as t2_a, ''F'' as fixed_a, ''C'' as contract_a)
        ) order by parent_a) a'
        using p_yymm;

       --- Age ---
       open p_age for
       'select rownum srno, a.* from (
        select * from (
           select em.parent, cm.name||'' (''||cm.abbr||'')'' costname,
           hr_pkg_common.get_age_group(round(months_between(to_date(:v_last_date),to_date(em.dob)) / 12)) age_group
           from hr_emplmast_main em, hr_costmast_main cm
           where em.parent = cm.costcode and em.emptype in (''R'', ''C'', ''F'') and em.status = 1 and em.parent not in (''0187'')
           and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
           and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where oee.relieving_date <= :v_filter_date)
           and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG003''))
        )
        pivot (
           count(age_group)
           for age_group in (''0-25'' as a, ''26-35'' as b, ''36-45'' as c, ''46-55'' as d, ''Above 55'' as e)
        ) order by parent) a'
       using v_last_date, p_yymm, v_filter_date;

       open p_age_delhi for
       'select rownum srno, a.* from (
        select * from (
           select em.parent, cm.name||'' (''||cm.abbr||'')'' costname,
           hr_pkg_common.get_age_group(round(months_between(to_date(:v_last_date),to_date(em.dob)) / 12)) age_group
           from hr_emplmast_main em, hr_costmast_main cm
           where em.parent = cm.costcode and em.emptype in (''R'', ''C'', ''F'') and em.status = 1 and em.parent not in (''0187'')
           and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
           and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where oee.relieving_date <= :v_filter_date)
           and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG005''))
        )
        pivot (
           count(age_group)
           for age_group in (''0-25'' as a, ''26-35'' as b, ''36-45'' as c, ''46-55'' as d, ''Above 55'' as e)
        ) order by parent) a'
       using v_last_date, p_yymm, v_filter_date;

       open p_age187 for
       'select rownum srno1, a.* from (
        select * from (
           select em.parent parent1, cm.name||'' (''||cm.abbr||'')'' costname1,
           hr_pkg_common.get_age_group(round(months_between(to_date(:v_last_date), to_date(em.dob)) / 12)) age_group
           from hr_emplmast_main em, hr_costmast_main cm
           where em.parent = cm.costcode and em.emptype in (''R'', ''C'', ''F'') and em.status = 1 and em.parent in (''0187'')
           and hr_pkg_common.get_tma_grp_4_costcode(em.parent) = ''E''
           and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm )
        pivot (
           count(age_group)
           for age_group in (''0-25'' as a1, ''26-35'' as b1, ''36-45'' as c1, ''46-55'' as d1, ''Above 55'' as e1)
        ) order by parent1) a'
       using v_last_date, p_yymm;

       --- Experience ---
       open p_experience for
       'select rownum srno, a.* from (
        select * from (
           select em.parent, cm.name||'' (''||cm.abbr||'')'' costname,
            hr_pkg_common.get_experience_group(round(eo.expbefore + months_between(to_date(:v_last_date), to_date(em.doj)) / 12)) exp_group
            from hr_emplmast_main em, hr_emplmast_organization eo, hr_costmast_main cm
            where em.parent = cm.costcode and em.empno = eo.empno and em.emptype in (''R'', ''C'', ''F'')
              and em.status = 1 and em.parent not in (''0187'')
              and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
              and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where oee.relieving_date <= :v_filter_date)
			  and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG003''))
        )
        pivot (
           count(exp_group)
           for exp_group in (''00-03'' as a, ''04-07'' as b, ''08-10'' as c, ''11-15'' as d, ''16-20'' as e, ''21-25'' as f, ''26 Above'' as g)
        ) order by parent) a'
       using v_last_date, p_yymm, v_filter_date;

	   open p_experience_delhi for
       'select rownum srno, a.* from (
        select * from (
           select em.parent, cm.name||'' (''||cm.abbr||'')'' costname,
            hr_pkg_common.get_experience_group(round(eo.expbefore + months_between(to_date(:v_last_date), to_date(em.doj)) / 12)) exp_group
            from hr_emplmast_main em, hr_emplmast_organization eo, hr_costmast_main cm
            where em.parent = cm.costcode and em.empno = eo.empno and em.emptype in (''R'', ''C'', ''F'')
              and em.status = 1 and em.parent not in (''0187'')
              and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
              and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where oee.relieving_date <= :v_filter_date)
			  and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG005''))
        )
        pivot (
           count(exp_group)
           for exp_group in (''00-03'' as a, ''04-07'' as b, ''08-10'' as c, ''11-15'' as d, ''16-20'' as e, ''21-25'' as f, ''26 Above'' as g)
        ) order by parent) a'
       using v_last_date, p_yymm, v_filter_date;

       open p_experience187 for
       'select rownum srno1, a.* from (
        select * from (
           select em.parent parent1, cm.name||'' (''||cm.abbr||'')'' costname1,
            hr_pkg_common.get_experience_group(round(eo.expbefore + months_between(to_date(:v_last_date), to_date(em.doj)) / 12)) exp_group
            from hr_emplmast_main em, hr_emplmast_organization eo, hr_costmast_main cm
            where em.parent = cm.costcode and em.empno = eo.empno and em.emptype in (''R'', ''C'', ''F'')
              and em.status = 1 and em.parent in (''0187'')
              and hr_pkg_common.get_tma_grp_4_costcode(em.parent) = ''E''
              and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
        )
        pivot (
           count(exp_group)
           for exp_group in (''00-03'' as a1, ''04-07'' as b1, ''08-10'' as c1, ''11-15'' as d1, ''16-20'' as e1, ''21-25'' as f1, ''26 Above'' as g1)
        ) order by parent1) a'
       using v_last_date, p_yymm;

	   --- Sex ---
       open p_sex for
       'select rownum srno, a.* from (
        select * from (
           select em.parent, cm.name||'' (''||cm.abbr||'')'' costname, em.sex
            from hr_costmast_main cm, hr_emplmast_main em, hr_emplmast_organization eo
            where em.empno = eo.empno and em.parent = cm.costcode and
              em.emptype in (''R'', ''C'', ''F'') and em.status = 1 and em.parent not in (''0187'')
              and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
              and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where oee.relieving_date <= :v_filter_date)
			  and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG003''))
        )
        pivot (
           count(sex)
           for sex in (''F'' as female, ''M'' as male)
        ) order by parent) a'
        using p_yymm, v_filter_date;

		open p_sex_delhi for
       'select rownum srno, a.* from (
        select * from (
           select em.parent, cm.name||'' (''||cm.abbr||'')'' costname, em.sex
            from hr_costmast_main cm, hr_emplmast_main em, hr_emplmast_organization eo
            where em.empno = eo.empno and em.parent = cm.costcode and
              em.emptype in (''R'', ''C'', ''F'') and em.status = 1 and em.parent not in (''0187'')
              and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
              and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where oee.relieving_date <= :v_filter_date)
			  and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG005''))
        )
        pivot (
           count(sex)
           for sex in (''F'' as female, ''M'' as male)
        ) order by parent) a'
        using p_yymm, v_filter_date;

        open p_sex187 for
       'select rownum srno1, a.* from (
        select * from (
           select em.parent parent1, cm.name||'' (''||cm.abbr||'')'' costname1, em.sex
            from hr_costmast_main cm, hr_emplmast_main em, hr_emplmast_organization eo
            where em.empno = eo.empno and em.parent = cm.costcode and
              em.emptype in (''R'', ''C'', ''F'') and em.status = 1 and em.parent in (''0187'')
              and hr_pkg_common.get_tma_grp_4_costcode(em.parent) = ''E''
              and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
        )
        pivot (
           count(sex)
           for sex in (''F'' as female1, ''M'' as male1)
        ) order by parent1) a'
        using p_yymm;

        --- Manpower wise ---
        open p_manpower for
        'select groupname, parent, max(costname) costname, sum(regular) regular, sum(fixed) fixed, sum(contract) contract from (
            select * from (
               select hr_pkg_common.get_manpower_group(parent) groupname, em.parent, cm.name||'' (''||cm.abbr||'')'' costname, em.emptype
                from hr_costmast_main cm, hr_emplmast_main em, hr_emplmast_organization eo
                where em.empno = eo.empno and em.parent = cm.costcode and
                  em.emptype in (''R'', ''C'', ''F'') and em.status = 1 and em.parent not in (''0187'')
                  and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
                  and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where oee.relieving_date <= :v_filter_date)
                  and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG003''))
            )
            pivot (
               count(emptype)
               for emptype in (''R'' as regular, ''F'' as fixed, ''C'' as contract)
            ) order by parent
        ) a
        group by rollup (groupname, parent)'
        using p_yymm, v_filter_date;

        open p_manpower_delhi for
        'select groupname, parent, max(costname) costname, sum(regular) regular, sum(fixed) fixed, sum(contract) contract from (
            select * from (
               select hr_pkg_common.get_manpower_group(parent) groupname, em.parent, cm.name||'' (''||cm.abbr||'')'' costname, em.emptype
                from hr_costmast_main cm, hr_emplmast_main em, hr_emplmast_organization eo
                where em.empno = eo.empno and em.parent = cm.costcode and
                  em.emptype in (''R'', ''C'', ''F'') and em.status = 1 and em.parent not in (''0187'')
                  and em.empno not in (''04132'') and to_char(em.doj,''yyyymm'') <= :p_yymm
                  and em.empno not in (select oee.empno from tcmpl_hr.ofb_emp_exits oee where oee.relieving_date <= :v_filter_date)
                  and em.parent in (select costcode from ts_costcode_group_costcode where costcode_group_id in (''CG005''))
            )
            pivot (
               count(emptype)
               for emptype in (''R'' as regular, ''F'' as fixed, ''C'' as contract)
            ) order by parent
        ) a
        group by rollup (groupname, parent)'
        using p_yymm, v_filter_date;

   end get_monthly_consolidated_engg;

   procedure get_monthly_outsource_employee(p_yymm in varchar2, p_employee out sys_refcursor,
                                            p_employee_abstract out sys_refcursor) as
    begin
        open p_employee for
           'select
                timecurr.hr_pkg_common.get_subcontract_4_empno(td.empno)  subcontract,
                td.empno,
                timecurr.hr_pkg_common.get_employee_name(td.empno) name,
                td.projno,
                td.d1,
                td.d2,
                td.d3,
                td.d4,
                td.d5,
                td.d6,
                td.d7,
                td.d8,
                td.d9,
                td.d10,
                td.d11,
                td.d12,
                td.d13,
                td.d14,
                td.d15,
                td.d16,
                td.d17,
                td.d18,
                td.d19,
                td.d20,
                td.d21,
                td.d22,
                td.d23,
                td.d24,
                td.d25,
                td.d26,
                td.d27,
                td.d28,
                td.d29,
                td.d30,
                td.d31,
                td.total,
                td.assign,
                td.wpcode,
                td.yymm,
                td.activity,
                td.grp,
                td.parent,
                heo.place
            from
                timecurr.time_daily  td,
                timecurr.hr_emplmast_organization heo
            where
                td.empno = heo.empno and
                td.empno like ''W%'' and
                td.yymm = :p_yymm' using p_yymm;

        open p_employee_abstract for
            'select
                max(a.empno) subcontractcode,
                b.name subcontractor,
                sum(a.hours) hours
            from
                ts_osc_Mhrs_master a,
                emplmast b
            where
                a.empno = b.empno and
                yymm = :p_yymm
            group by
                b.name
            order by
                b.name' using p_yymm;

   end get_monthly_outsource_employee;
    
end hr_pkg_emplmast_report;

/
