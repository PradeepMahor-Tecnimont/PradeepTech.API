--------------------------------------------------------
--  DDL for Package Body NGTS_TIMESHEET
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."NGTS_TIMESHEET" as

  procedure ngts_getactivities(p_dept in varchar2, p_projno in varchar2, p_activitylist out sys_refcursor) as
      vExistProj number := 0;
      v_stmt varchar2(1000) := null;
    begin
      select count(activity) into vExistProj from projact_mast
        where costcode = p_dept and projno = p_projno;
      if vExistProj > 0 then
        v_stmt := 'select trim(activity) activity, ngts_timesheet.ngts_getactivityname(''' || p_dept || ''', activity) name ';
        v_stmt := v_stmt || ' from projact_mast ';
        v_stmt := v_stmt || ' where costcode = ''' || p_dept || ''' and projno = ''' || p_projno || ''' ';
        v_stmt := v_stmt || ' order by activity';
      else
        v_stmt := ' select trim(activity) activity, name from act_mast ';
        v_stmt := v_stmt || ' where active = 1 and costcode = ''' || p_dept ||''' ';
        v_stmt := v_stmt || ' order by activity ';
      end if;
      --Dbms_Output.Put_Line(v_stmt);
      open p_activitylist for v_stmt;      
  end ngts_getactivities;
  
  procedure ngts_getallactivities(p_dept in varchar2, p_activitylist out sys_refcursor) as      
      v_stmt varchar2(1000) := null;
    begin
      v_stmt := 'select projno,activity, name from ';
      v_stmt := v_stmt || ' (select projno, trim(activity) activity, ';
      v_stmt := v_stmt || ' ngts_timesheet.ngts_getactivityname(''' || p_dept || ''', activity) name ';
      v_stmt := v_stmt || ' from projact_mast ';
      v_stmt := v_stmt || ' where costcode = ''' || p_dept || ''' ';
      v_stmt := v_stmt || ' union all ';
      v_stmt := v_stmt || ' select null projno, trim(activity) activity, name from act_mast ';
      v_stmt := v_stmt || ' where active = 1 and costcode = ''' || p_dept || ''' ) ';
      v_stmt := v_stmt || ' order by projno, activity ';
      open p_activitylist for v_stmt;      
  end ngts_getallactivities;  
  
  procedure ngts_getprojfordept(p_dept in varchar2, p_yymm in varchar2, p_projlist out sys_refcursor) as
      v_stmt varchar2(1000) := null;
    begin
      --v_stmt := 'select distinct p.projno, ngts_timesheet.ngts_getprojname(p.projno) name ';      
      --v_stmt := v_stmt || ' from projact_mast p';
      --v_stmt := v_stmt || ' where p.costcode = ''' || p_dept || ''' and ngts_timesheet.ngts_getprojname(p.projno) is not null ';
      --v_stmt := v_stmt || ' order by p.projno '; 
      /*v_stmt := ' select projno, name, ngts_timesheet.ngts_getfreeze(substr(projno,1,5)) isweekly, ';
      v_stmt := v_stmt || ' ngts_timesheet.ngts_get240flag(projno) is240, ';
      v_stmt := v_stmt || ' ngts_timesheet.ngts_getreviewon(projno) reviewon, ';
      v_stmt := v_stmt || ' ngts_timesheet.ngts_getdefaultactivity(projno) defaultactivity, ';      
      v_stmt := v_stmt || ' ngts_timesheet.ngts_getprojapprl(substr(projno,1,5)) isProjApprl from projmast  ';  
      v_stmt := v_stmt || ' where substr(projno,6,2) in (select phase from deptphase where costcode =  ''' || p_dept || ''' )  ';  
      v_stmt := v_stmt || ' and to_char(revcdate,''yyyymm'') >= ''' || p_yymm || ''' and block_booking = 0  ';  
      v_stmt := v_stmt || ' order by projno  ';*/
      
      v_stmt := ' select projno, name, ngts_timesheet.ngts_getfreeze(substr(projno,1,5)) isweekly, '; 
      v_stmt := v_stmt || ' ngts_timesheet.ngts_get240flag(projno) is240, '; 
      v_stmt := v_stmt || ' ngts_timesheet.ngts_getreviewon(projno) reviewon, '; 
      v_stmt := v_stmt || ' ngts_timesheet.ngts_getdefaultactivity(projno) defaultactivity,      '; 
      v_stmt := v_stmt || ' ngts_timesheet.ngts_getprojapprl(substr(projno,1,5)) isProjApprl, '; 
      v_stmt := v_stmt || ' ngts_timesheet.ngts_fn_block(projno) isblocked, '; 
      v_stmt := v_stmt || ' ngts_timesheet.ngts_fn_weekdate(projno) weekdates, '; 
      v_stmt := v_stmt || ' ngts_timesheet.ngts_fn_reviewdate(projno,''' || p_yymm || ''') reviewdays '; 
      v_stmt := v_stmt || ' from projmast  ';   
      v_stmt := v_stmt || ' where substr(projno,6,2) in (select phase from deptphase where costcode = ''' || p_dept || ''' )  ';  
      v_stmt := v_stmt || ' and to_char(revcdate,''yyyymm'') >= ''' || p_yymm || ''' and block_booking = 0  '; 
      v_stmt := v_stmt || ' order by projno '; 
      --Dbms_Output.Put_Line(v_stmt);
      open p_projlist for v_stmt ;      
  end ngts_getprojfordept;
  
  procedure ngts_getweekdays(p_projno in varchar2, p_dayslist out sys_refcursor) as
      v_stmt varchar2(1000) := null;
    begin
      v_stmt := ' select listagg(days, '','') within group (order by days) as days from ';
      v_stmt := v_stmt || ' (select to_char(to_date(datefrom,''dd-mm-yy'') + (level - 1),''dd'') days ';
      v_stmt := v_stmt || ' from tm_week_unlock ';
      v_stmt := v_stmt || ' where proj_no = substr('''|| p_projno || ''',1,5) ';
      v_stmt := v_stmt || ' connect by level <= (to_date(dateto,''dd-mm-yy'') - to_date(datefrom,''dd-mm-yy''))+ 1) ';      
      open p_dayslist for v_stmt;      
  end ngts_getweekdays;
  
  procedure ngts_getholidays(p_yyyymm in varchar2, p_dayslist out sys_refcursor) as
      v_stmt varchar2(1000) := null;
    begin
    v_stmt := ' select listagg(days, '','') within group (order by days) as days from ';
    v_stmt := v_stmt || ' (select to_char(to_date(holiday,''dd-mm-yy'') + (level - 1),''dd'') days from holidays ';
    v_stmt := v_stmt || ' where yyyymm = '''|| p_yyyymm || ''' ';
    v_stmt := v_stmt || ' connect by level <= 1 order by holiday) ';
    open p_dayslist for v_stmt;    
  end ngts_getholidays;
  
  procedure ngts_block(p_projno in varchar2, p_blocklist out sys_refcursor) as
      vCount number := 0;
      v_stmt varchar2(1000) := null;      
    begin
      select count(projno) into vCount from ngts_fixed_project
        where projno = substr(p_projno,1,5);
      if vCount > 0 then
        v_stmt := ' select 0 block_status from dual ';
        v_stmt := v_stmt || ' union all ';
        v_stmt := v_stmt || ' select 1 block_status from dual ';
      else
        v_stmt := ' select block_booking block_status from job_proj_phase ';
        v_stmt := v_stmt || ' where projno||phase_select = ''' || p_projno || ''' ';
        v_stmt := v_stmt || '  union all';
        v_stmt := v_stmt || ' select block_ot block_status from job_proj_phase ';
        v_stmt := v_stmt || ' where projno||phase_select = ''' || p_projno || ''' ';
      end if;      
      open p_blocklist for v_stmt;      
  end ngts_block;
  
  procedure ngts_weekdate(p_projno in varchar2, p_weekdatelist out sys_refcursor) as
      v_stmt varchar2(1000) := null;
    begin
      v_stmt := ' select to_number(to_char(to_date(datefrom,''dd-mm-yy'') + (level - 1),''dd'')) days ';
      v_stmt := v_stmt || ' from tm_week_unlock ';
      --v_stmt := v_stmt || ' where projno = '''|| p_projno || ''' ';
      v_stmt := v_stmt || ' connect by level <= (to_date(dateto,''dd-mm-yy'') - to_date(datefrom,''dd-mm-yy''))+ 1 ';
      open p_weekdatelist for v_stmt;      
  end ngts_weekdate;   
  
  procedure ngts_reviewdate(p_projno in varchar2, p_reviewdatelist out sys_refcursor) as
      v_stmt varchar2(1000) := null;
    begin
      v_stmt := '  select to_number(to_char(to_date(reviewfrom,''dd-mm-yy'') + (level - 1),''dd'')) days ';
      v_stmt := v_stmt || ' from ngts_project_review_period ';
      v_stmt := v_stmt || ' where projno = substr('''|| p_projno || ''',1,5) ';
      v_stmt := v_stmt || ' connect by level <= (to_date(reviewto,''dd-mm-yy'') - to_date(reviewfrom,''dd-mm-yy''))+ 1 ';
      open p_reviewdatelist for v_stmt;      
  end ngts_reviewdate;
  
  procedure ngts_getallwpcode(p_wpcodelist out sys_refcursor) as
      v_stmt varchar2(1000) := null;
    begin    
      v_stmt := 'select wpcode, wpdesc from time_wpcode ';
      v_stmt := v_stmt || ' order by wpcode ';
      open p_wpcodelist for v_stmt;      
  end ngts_getallwpcode;    
  
  procedure ngts_savetimesheet(p_user_identity_name in varchar2,
                               p_timesheet in XMLTYPE, p_addrows in XMLTYPE, p_modrows in XMLTYPE, p_delrows in XMLTYPE, 
                               p_msg out varchar2) as
      vCnt_mast number := 0;
      vCnt_daily number := 0;
      vYYmm varchar2(6) := '';
      vEmpno varchar2(5) := '';
      vParent varchar2(4) := '';
      vAssign varchar2(4) := '';
      vCompany varchar2(4) := '';      
      vError Varchar2(4000);
    begin     
      -- validations 
      
      -- update time_mast
      if p_timesheet is not null then
        for i in 
            (select XMLTYPE.EXTRACT (value(a), 'TimesheetTable/yymm/text()').getstringval() AS ip_yymm,
                    XMLTYPE.EXTRACT (value(a), 'TimesheetTable/empno/text()').getstringval() AS ip_empno,
                    XMLTYPE.EXTRACT (value(a), 'TimesheetTable/parent/text()').getstringval() AS ip_parent,
                    XMLTYPE.EXTRACT (value(a), 'TimesheetTable/assign/text()').getstringval() AS ip_assign,
                    XMLTYPE.EXTRACT (value(a), 'TimesheetTable/tot_Nhr/text()').getNumberVal() AS ip_tot_nhr,
                    XMLTYPE.EXTRACT (value(a), 'TimesheetTable/tot_Ohr/text()').getNumberVal() AS ip_tot_ohr,
                    XMLTYPE.EXTRACT (value(a), 'TimesheetTable/company/text()').getstringval() AS ip_company,                    
                    XMLTYPE.EXTRACT (value(a), 'TimesheetTable/remark/text()').getstringval() AS ip_remark,
                    XMLTYPE.EXTRACT (value(a), 'TimesheetTable/desgcode/text()').getstringval() AS ip_desgcode,
                    XMLTYPE.EXTRACT (value(a), 'TimesheetTable/grade/text()').getstringval() AS ip_grade                    
                    from table (XMLSEQUENCE (p_timesheet.EXTRACT ('DocumentElement/TimesheetTable'))) a)        
        loop
          vYYmm := i.ip_yymm;
          vEmpno := i.ip_empno;
          vParent := i.ip_parent;
          vAssign := i.ip_assign;
          vCompany := i.ip_company;
          select count(*) into vCnt_mast from time_mast
            where yymm = i.ip_yymm and empno = i.ip_empno and parent = i.ip_parent and assign = i.ip_assign;
              -- and company = i.ip_company;
          if vCnt_mast = 0 then
            insert into time_mast(yymm, empno, parent, assign, tot_nhr, tot_ohr, company, remark, desgcode, grade, grp, locked, approved, posted, mastkeyid)
              values (i.ip_yymm, i.ip_empno, i.ip_parent, i.ip_assign, i.ip_tot_nhr, i.ip_tot_ohr, i.ip_company, 
                i.ip_remark, i.ip_desgcode, i.ip_grade, ngts_timesheet.ngts_getgrp(i.ip_assign), 0, 0, 0, dbms_random.string('X',8));
                
            INSERT INTO ngts_wf_log
                SELECT
                    sysdate,
                    (
                        SELECT
                            tableid
                        FROM
                            ngts_wf_log_tables_mast
                        WHERE
                            tablename = 'TIME_MAST'
                    ),
                    (
                        SELECT
                            processid
                        FROM
                            ngts_wf_log_process_mast
                        WHERE
                            processname = 'CREATED'
                    ),
                    ngts_check_auth_rights.get_empno(p_user_identity_name),
                    (
                        SELECT
                            mastkeyid
                        FROM
                            time_mast
                        WHERE
                            yymm = TRIM(vyymm)
                            AND empno = TRIM(vempno)
                            AND parent = TRIM(vparent)
                            AND assign = TRIM(vassign)
                    )
                FROM
                    dual;
                
          else
            update time_mast set tot_nhr = i.ip_tot_nhr, tot_ohr = i.ip_tot_ohr, remark = i.ip_remark, 
              desgcode = i.ip_desgcode, grade = i.ip_grade, grp = ngts_timesheet.ngts_getgrp(i.ip_assign)
              where yymm = i.ip_yymm and empno = i.ip_empno and parent = i.ip_parent and assign = i.ip_assign;
          end if;
        end loop;
      end if;
      -- Insert time_daily / time_ot
      if p_addrows is not null then        
        for j in 
            (select XMLTYPE.EXTRACT (value(b), 'AddRowsTable/yymm/text()').getstringval() AS jp_yymm,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/empno/text()').getstringval() AS jp_empno,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/assign/text()').getstringval() AS jp_assign,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/projno/text()').getstringval() AS jp_projno,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/wpcode/text()').getstringval() AS jp_wpcode,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/activity/text()').getstringval() AS jp_activity,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/reasoncode/text()').getstringval() AS jp_reasoncode,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/type/text()').getNumberVal() AS jp_type,                    
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d1/text()').getNumberVal() AS jp_d1,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d2/text()').getNumberVal() AS jp_d2,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d3/text()').getNumberVal() AS jp_d3,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d4/text()').getNumberVal() AS jp_d4,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d5/text()').getNumberVal() AS jp_d5,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d6/text()').getNumberVal() AS jp_d6,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d7/text()').getNumberVal() AS jp_d7,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d8/text()').getNumberVal() AS jp_d8,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d9/text()').getNumberVal() AS jp_d9,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d10/text()').getNumberVal() AS jp_d10,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d11/text()').getNumberVal() AS jp_d11,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d12/text()').getNumberVal() AS jp_d12,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d13/text()').getNumberVal() AS jp_d13,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d14/text()').getNumberVal() AS jp_d14,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d15/text()').getNumberVal() AS jp_d15,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d16/text()').getNumberVal() AS jp_d16,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d17/text()').getNumberVal() AS jp_d17,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d18/text()').getNumberVal() AS jp_d18,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d19/text()').getNumberVal() AS jp_d19,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d20/text()').getNumberVal() AS jp_d20,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d21/text()').getNumberVal() AS jp_d21,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d22/text()').getNumberVal() AS jp_d22,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d23/text()').getNumberVal() AS jp_d23,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d24/text()').getNumberVal() AS jp_d24,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d25/text()').getNumberVal() AS jp_d25,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d26/text()').getNumberVal() AS jp_d26,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d27/text()').getNumberVal() AS jp_d27,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d28/text()').getNumberVal() AS jp_d28,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d29/text()').getNumberVal() AS jp_d29,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d30/text()').getNumberVal() AS jp_d30,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/d31/text()').getNumberVal() AS jp_d31,
                    XMLTYPE.EXTRACT (value(b), 'AddRowsTable/total/text()').getNumberVal() AS jp_total                    
                    from table (XMLSEQUENCE (p_addrows.EXTRACT ('DocumentElement/AddRowsTable'))) b)
        loop
          -- Normal Timesheet
          if j.jp_type = 1 then
            BEGIN
                insert into time_daily(yymm, empno, parent, assign, projno, wpcode, activity,
                  d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, 
                  d11, d12, d13, d14, d15, d16, d17, d18, 
                  d19, d20, d21, d22, d23, d24, d25, d26,
                  d27, d28, d29, d30, d31, total, grp, company, dailykeyid, mastkeyid, reasoncode) 
                values (j.jp_yymm, j.jp_empno, vParent, j.jp_assign, j.jp_projno, j.jp_wpcode, j.jp_activity,                    
                  j.jp_d1, j.jp_d2, j.jp_d3, j.jp_d4, j.jp_d5, j.jp_d6, j.jp_d7, j.jp_d8, j.jp_d9, j.jp_d10,  
                  j.jp_d11, j.jp_d12, j.jp_d13, j.jp_d14, j.jp_d15, j.jp_d16, j.jp_d17, j.jp_d18,
                  j.jp_d19, j.jp_d20, j.jp_d21, j.jp_d22, j.jp_d23, j.jp_d24, j.jp_d25, j.jp_d26,
                  j.jp_d27, j.jp_d28, j.jp_d29, j.jp_d30, j.jp_d31, j.jp_total, ngts_timesheet.ngts_getgrp(j.jp_assign), vCompany, 
                  dbms_random.string('X',8), (select mastkeyid from time_mast where yymm = TRIM(vYYmm) And empno = TRIM(vEmpno) And parent = TRIM(vParent) And assign = TRIM(vAssign)), j.jp_reasoncode);
            EXCEPTION
                WHEN OTHERS THEN
                    vError := 'Err - ' || sqlcode || ' - ' || sqlerrm;  
                    
                    --p_msg := 'Err - ' || sqlcode || ' - ' || sqlerrm;  
                    RETURN;
            end;
          end if;          
          -- OT Timesheet
          if j.jp_type = 2 then
            insert into time_ot(yymm, empno, parent, assign, projno, wpcode, activity,
              d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, 
              d11, d12, d13, d14, d15, d16, d17, d18, 
              d19, d20, d21, d22, d23, d24, d25, d26,
              d27, d28, d29, d30, d31, total, grp, company, otkeyid, mastkeyid, reasoncode) 
            values (j.jp_yymm, j.jp_empno, vParent, j.jp_assign, j.jp_projno, j.jp_wpcode, j.jp_activity,                    
              j.jp_d1, j.jp_d2, j.jp_d3, j.jp_d4, j.jp_d5, j.jp_d6, j.jp_d7, j.jp_d8, j.jp_d9, j.jp_d10,  
              j.jp_d11, j.jp_d12, j.jp_d13, j.jp_d14, j.jp_d15, j.jp_d16, j.jp_d17, j.jp_d18,
              j.jp_d19, j.jp_d20, j.jp_d21, j.jp_d22, j.jp_d23, j.jp_d24, j.jp_d25, j.jp_d26,
              j.jp_d27, j.jp_d28, j.jp_d29, j.jp_d30, j.jp_d31, j.jp_total, ngts_timesheet.ngts_getgrp(j.jp_assign), vCompany, 
              dbms_random.string('X',8), (select mastkeyid from time_mast where yymm = vYYmm And empno = vEmpno And parent = vParent And assign = vAssign), j.jp_reasoncode);              
          end if;
        end loop;
      end if;
      
      -- Update time_daily / time_ot
      if p_modrows is not null then 
      for k in 
            (select XMLTYPE.EXTRACT (value(c), 'ModRowsTable/yymm/text()').getstringval() AS kp_yymm,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/empno/text()').getstringval() AS kp_empno,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/assign/text()').getstringval() AS kp_assign,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/projno/text()').getstringval() AS kp_projno,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/wpcode/text()').getstringval() AS kp_wpcode,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/activity/text()').getstringval() AS kp_activity,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/reasoncode/text()').getstringval() AS kp_reasoncode,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/type/text()').getNumberVal() AS kp_type,                    
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/id/text()').getstringval() AS kp_id,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d1/text()').getNumberVal() AS kp_d1,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d2/text()').getNumberVal() AS kp_d2,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d3/text()').getNumberVal() AS kp_d3,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d4/text()').getNumberVal() AS kp_d4,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d5/text()').getNumberVal() AS kp_d5,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d6/text()').getNumberVal() AS kp_d6,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d7/text()').getNumberVal() AS kp_d7,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d8/text()').getNumberVal() AS kp_d8,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d9/text()').getNumberVal() AS kp_d9,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d10/text()').getNumberVal() AS kp_d10,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d11/text()').getNumberVal() AS kp_d11,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d12/text()').getNumberVal() AS kp_d12,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d13/text()').getNumberVal() AS kp_d13,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d14/text()').getNumberVal() AS kp_d14,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d15/text()').getNumberVal() AS kp_d15,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d16/text()').getNumberVal() AS kp_d16,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d17/text()').getNumberVal() AS kp_d17,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d18/text()').getNumberVal() AS kp_d18,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d19/text()').getNumberVal() AS kp_d19,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d20/text()').getNumberVal() AS kp_d20,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d21/text()').getNumberVal() AS kp_d21,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d22/text()').getNumberVal() AS kp_d22,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d23/text()').getNumberVal() AS kp_d23,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d24/text()').getNumberVal() AS kp_d24,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d25/text()').getNumberVal() AS kp_d25,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d26/text()').getNumberVal() AS kp_d26,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d27/text()').getNumberVal() AS kp_d27,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d28/text()').getNumberVal() AS kp_d28,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d29/text()').getNumberVal() AS kp_d29,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d30/text()').getNumberVal() AS kp_d30,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/d31/text()').getNumberVal() AS kp_d31,
                    XMLTYPE.EXTRACT (value(c), 'ModRowsTable/total/text()').getNumberVal() AS kp_total
                    from table (XMLSEQUENCE (p_modrows.EXTRACT ('DocumentElement/ModRowsTable'))) c)
        loop
          -- Normal Timesheet
          if k.kp_type = 1 then            
                update time_daily set
                  d1 = k.kp_d1, d2 = k.kp_d2, d3 = k.kp_d3, d4 = k.kp_d4, d5 = k.kp_d5, d6 = k.kp_d6, 
                  d7 = k.kp_d7, d8 = k.kp_d8, d9 = k.kp_d9, d10 = k.kp_d10, d11 = k.kp_d11, d12 = k.kp_d12, 
                  d13 = k.kp_d13, d14 = k.kp_d14, d15 = k.kp_d15, d16 = k.kp_d16, d17 = k.kp_d17, d18 = k.kp_d18, 
                  d19 = k.kp_d19, d20 = k.kp_d20, d21 = k.kp_d21, d22 = k.kp_d22, d23 = k.kp_d23, d24 = k.kp_d24, 
                  d25 = k.kp_d25, d26 = k.kp_d26, d27 = k.kp_d27, d28 = k.kp_d28, d29 = k.kp_d29, d30 = k.kp_d30, 
                  d31 = k.kp_d31, total = k.kp_total, grp = ngts_timesheet.ngts_getgrp(k.kp_assign), company = vCompany        
                  where dailykeyid = trim(k.kp_id);
                  
                  /*trim(yymm) = trim(k.kp_yymm) and trim(empno) = trim(k.kp_empno) and trim(parent) = trim(vParent) 
                    and trim(assign) = trim(k.kp_assign) and trim(projno) = trim(k.kp_projno) and trim(wpcode) = trim(k.kp_wpcode) 
                    and trim(activity) = trim(k.kp_activity) and trim(reasoncode) = trim(k.kp_reasoncode);            */
              
                    --where yymm = k.kp_yymm and empno = k.kp_empno and parent = vParent and assign = k.kp_assign
                    --and projno = k.kp_projno and wpcode = k.kp_wpcode and activity = k.kp_activity;   
                    --null;
          end if;          
          -- OT Timesheet
          if k.kp_type = 2 then
                update time_ot set
                  d1 = k.kp_d1, d2 = k.kp_d2, d3 = k.kp_d3, d4 = k.kp_d4, d5 = k.kp_d5, d6 = k.kp_d6, 
                  d7 = k.kp_d7, d8 = k.kp_d8, d9 = k.kp_d9, d10 = k.kp_d10, d11 = k.kp_d11, d12 = k.kp_d12, 
                  d13 = k.kp_d13, d14 = k.kp_d14, d15 = k.kp_d15, d16 = k.kp_d16, d17 = k.kp_d17, d18 = k.kp_d18, 
                  d19 = k.kp_d19, d20 = k.kp_d20, d21 = k.kp_d21, d22 = k.kp_d22, d23 = k.kp_d23, d24 = k.kp_d24, 
                  d25 = k.kp_d25, d26 = k.kp_d26, d27 = k.kp_d27, d28 = k.kp_d28, d29 = k.kp_d29, d30 = k.kp_d30, 
                  d31 = k.kp_d31, total = k.kp_total, grp = ngts_timesheet.ngts_getgrp(k.kp_assign), company = vCompany     
                  where otkeyid = trim(k.kp_id);
                  
                  /*where trim(yymm) = trim(k.kp_yymm) and trim(empno) = trim(k.kp_empno) and trim(parent) = trim(vParent) 
                    and trim(assign) = trim(k.kp_assign) and trim(projno) = trim(k.kp_projno) and trim(wpcode) = trim(k.kp_wpcode) 
                    and trim(activity) = trim(k.kp_activity) and trim(reasoncode) = trim(k.kp_reasoncode);            */
                --null;
          end if;
        end loop;
      end if;
      
      -- Delete time_daily / time_ot
      if p_delrows is not null then        
        for m in 
            (select XMLTYPE.EXTRACT (value(d), 'DelRowsTable/yymm/text()').getstringval() AS mp_yymm,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/empno/text()').getstringval() AS mp_empno,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/assign/text()').getstringval() AS mp_assign,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/projno/text()').getstringval() AS mp_projno,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/wpcode/text()').getstringval() AS mp_wpcode,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/activity/text()').getstringval() AS mp_activity,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/reasoncode/text()').getstringval() AS mp_reasoncode,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/type/text()').getNumberVal() AS mp_type,                         
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/id/text()').getstringval() AS mp_id,                    
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d1/text()').getNumberVal() AS mp_d1,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d2/text()').getNumberVal() AS mp_d2,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d3/text()').getNumberVal() AS mp_d3,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d4/text()').getNumberVal() AS mp_d4,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d5/text()').getNumberVal() AS mp_d5,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d6/text()').getNumberVal() AS mp_d6,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d7/text()').getNumberVal() AS mp_d7,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d8/text()').getNumberVal() AS mp_d8,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d9/text()').getNumberVal() AS mp_d9,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d10/text()').getNumberVal() AS mp_d10,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d11/text()').getNumberVal() AS mp_d11,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d12/text()').getNumberVal() AS mp_d12,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d13/text()').getNumberVal() AS mp_d13,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d14/text()').getNumberVal() AS mp_d14,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d15/text()').getNumberVal() AS mp_d15,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d16/text()').getNumberVal() AS mp_d16,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d17/text()').getNumberVal() AS mp_d17,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d18/text()').getNumberVal() AS mp_d18,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d19/text()').getNumberVal() AS mp_d19,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d20/text()').getNumberVal() AS mp_d20,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d21/text()').getNumberVal() AS mp_d21,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d22/text()').getNumberVal() AS mp_d22,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d23/text()').getNumberVal() AS mp_d23,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d24/text()').getNumberVal() AS mp_d24,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d25/text()').getNumberVal() AS mp_d25,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d26/text()').getNumberVal() AS mp_d26,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d27/text()').getNumberVal() AS mp_d27,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d28/text()').getNumberVal() AS mp_d28,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d29/text()').getNumberVal() AS mp_d29,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d30/text()').getNumberVal() AS mp_d30,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/d31/text()').getNumberVal() AS mp_d31,
                    XMLTYPE.EXTRACT (value(d), 'DelRowsTable/total/text()').getNumberVal() AS mp_total
                    from table (XMLSEQUENCE (p_delrows.EXTRACT ('DocumentElement/DelRowsTable'))) d)
        loop
          -- Normal Timesheet
          if m.mp_type = 1 then
                delete time_daily
                where dailykeyid = trim(m.mp_id);
                /*where trim(yymm) = trim(m.mp_yymm) and trim(empno) = trim(m.mp_empno) and trim(parent) = trim(vParent) 
                    and trim(assign) = trim(m.mp_assign) and trim(projno) = trim(m.mp_projno) and trim(wpcode) = trim(m.mp_wpcode) 
                    and trim(activity) = trim(m.mp_activity) and trim(reasoncode) = trim(m.mp_reasoncode);            */
          end if;          
          -- OT Timesheet
          if m.mp_type = 2 then
                delete time_ot
                where otkeyid = trim(m.mp_id);
                /*where trim(yymm) = trim(m.mp_yymm) and trim(empno) = trim(m.mp_empno) and trim(parent) = trim(vParent) 
                    and trim(assign) = trim(m.mp_assign) and trim(projno) = trim(m.mp_projno) and trim(wpcode) = trim(m.mp_wpcode) 
                    and trim(activity) = trim(m.mp_activity) and trim(reasoncode) = trim(m.mp_reasoncode);            */
            --where yymm = m.mp_yymm and empno = m.mp_empno and parent = vParent and assign = m.mp_assign
            --and projno = m.mp_projno and wpcode = m.mp_wpcode and activity = m.mp_activity;
          end if;
        end loop;
      end if;      
      p_msg := 'Done';
    exception
      when others then     
        p_msg := 'Err - ' || sqlcode || ' - ' || sqlerrm;  
  end ngts_savetimesheet;
  
  procedure ngts_project_lastmonth(p_empno in varchar2, p_dept in varchar2, p_yyyymm in varchar2, 
                                   p_normal_list out sys_refcursor, p_ot_list out sys_refcursor) as
      v_stmt_normal varchar2(1000) := null;
      v_stmt_ot varchar2(1000) := null;
      v_prev_yymm varchar2(6) := null;
    begin    
      select to_char(add_months(last_day(to_date(p_yyyymm,'yyyymm')), -1),'yyyymm') into v_prev_yymm from dual;
      
      v_stmt_normal := 'select projno, wpcode, reasoncode, trim(activity) activity from time_daily ';
      v_stmt_normal := v_stmt_normal || ' where empno = ''' || p_empno || ''' and assign = ''' || p_dept || ''' ';
      v_stmt_normal := v_stmt_normal || ' and yymm = ''' || v_prev_yymm || ''' and ';
      v_stmt_normal := v_stmt_normal || ' ngts_timesheet.ngts_project_isactive(projno,''' || p_yyyymm || ''') = 1 ';
      v_stmt_normal := v_stmt_normal || ' order by projno ';
      open p_normal_list for v_stmt_normal;                                 
      
      v_stmt_ot := 'select projno, wpcode, reasoncode, trim(activity) activity from time_ot ';
      v_stmt_ot := v_stmt_ot || ' where empno = ''' || p_empno || ''' and assign = ''' || p_dept || ''' ';
      v_stmt_ot := v_stmt_ot || ' and yymm = ''' || v_prev_yymm || ''' and ';
      v_stmt_ot := v_stmt_ot || ' ngts_timesheet.ngts_project_isactive(projno,''' || p_yyyymm || ''') = 1 ';
      v_stmt_ot := v_stmt_ot || ' order by projno ';
      open p_ot_list for v_stmt_ot;                             
  end ngts_project_lastmonth;                                   
  
  procedure ngts_getconnectstr(p_yyyy in varchar2, p_details out sys_refcursor) as
      v_stmt varchar2(1000) := null;      
    begin
      v_stmt := 'select ts_datasource, ts_userid, ts_password from ngts_year_mast ';
      v_stmt := v_stmt || ' where ts_isactive = 1 and substr(ts_yyyy,1,4) = ''' || p_yyyy || ''' ';
      open p_details for v_stmt;
  end ngts_getconnectstr;
  
  procedure ngts_getyearfromid(p_keyid in varchar2, p_year out varchar2) as
      v_year varchar2(4) := null;
    begin
      select substr(yymm,1,4) into v_year from time_mast
      where mastkeyid = p_keyid;
      p_year := v_year;
  end ngts_getyearfromid;
  
  function ngts_project_isactive(p_projno in varchar2, p_yyyymm in varchar2) return number as
      v_count number := 0;
    begin
      select count(*) into v_count from projmast
      where to_date(revcdate,'dd/mm/yyyy') >= to_date(last_day(to_date(p_yyyymm,'yyyymm')),'dd/mm/yyyy')
      and projno = p_projno;
      return v_count;
  end ngts_project_isactive;  
  
  function ngts_fn_block(p_projno in varchar2) return varchar2 as
      vCount number := 0;
      v_block_days varchar2(10) := '';
    begin
      select count(projno) into vCount from ngts_fixed_project
        where projno = substr(p_projno,1,5);
      if vCount > 0 then
        select '[0,1]' into v_block_days from dual;
      else
        select '[' || listagg(block_status, ',') within group (order by block_status) || ']' into v_block_days from
        (select block_booking block_status from job_proj_phase
        where projno||phase_select = p_projno 
        union all
        select block_ot block_status from job_proj_phase
        where projno||phase_select = p_projno);
      end if;      
      return v_block_days;
  end ngts_fn_block;
  
  function ngts_fn_weekdate(p_projno in varchar2) return varchar2 as
      v_weekdate varchar2(500) := '';
    begin
      select '[' || listagg(days, ',') within group (order by days) || ']' into v_weekdate from 
      (select to_number(to_char(to_date(datefrom,'dd-mm-yyyy') + (level - 1),'dd')) days 
      from tm_week_unlock 
      where proj_no = substr(p_projno,1,5)
      connect by level <= (to_date(dateto,'dd-mm-yyyy') - to_date(datefrom,'dd-mm-yyyy'))+ 1);
      return v_weekdate;
  end ngts_fn_weekdate;
  
  function ngts_fn_reviewdate(p_projno in varchar2, p_yymm in varchar2) return varchar2 as
      v_reviewdate varchar2(500) := '';
    begin
      select '[' || listagg(to_number(to_char(dates,'dd')) , ',') within group (order by dates) || ']' into v_reviewdate
      from (select distinct (to_date(reviewto,'dd-mm-yy') - level + 1) AS dates
      from ngts_project_review_period  
      where projno = substr(p_projno,1,5) and locked = 0 and yymm = p_yymm
      connect by level <= (to_date(reviewto,'dd-mm-yy') - to_date(reviewfrom,'dd-mm-yy') + 1)) order by dates;      
      return v_reviewdate;
  end ngts_fn_reviewdate;  
  
  function ngts_getfreeze(p_projno in varchar2) return number as
      vExists number := 0;
      vRetval number := 0;
    begin
      select count(*) into vExists from tm_week_unlock
       where proj_no = p_projno;
      if vExists > 0 then
        vRetval := 1;      
      end if;
      return vRetval;
  end ngts_getfreeze;
  
  function ngts_getgrp(p_dept in varchar2) return varchar2 as
      vGrp varchar2(1) := '';
    begin
      select tma_grp into vGrp from costmast
        where costcode = p_dept;
      return vGrp;
  end ngts_getgrp;
  
  function ngts_getreviewon(p_projno in varchar2) return number as
     vReviewOn number := 0;
    begin
      select count(locked) into vReviewOn from ngts_project_review_period
        where projno = substr(p_projno,1,5) and locked = 0;
      return vReviewOn;
  end ngts_getreviewon;
  
  function ngts_getprojname(p_projno in varchar2) return varchar2 as
      vProjName varchar2(100) := '';
    begin
      select name into vProjName from projmast 
      where projno = p_projno;
      return vProjName;
  end ngts_getprojname;
    
  function ngts_getactivityname(p_dept in varchar2, p_actcode in varchar2) return varchar2 as
      vActivityName varchar2(80) := '';
    begin
      select name into vActivityName from act_mast
        where costcode = p_dept and activity = p_actcode;
      return vActivityName;
  end ngts_getactivityname;
  
  function ngts_get240flag(p_projno in varchar2) return number as
      vFlag number := 0;
    begin      
      select case when tcm_jobs = 1 and reimb_job = 1 then 1
        else 0 end into vFlag from projmast
        where projno = p_projno;
      return vFlag;
  end ngts_get240flag;
  
  function ngts_getdefaultactivity(p_projno in varchar2) return varchar2 as
      vCount number := 0;
      vDefaultCativity varchar2(7) := '';
    begin
      select count(projno) into vCount From ngts_fixed_project
        where projno = substr(p_projno,1,5);
      if vCount > 0 then
        vDefaultCativity := '**';
      end if;
      return vDefaultCativity;
  end ngts_getdefaultactivity;
  
  function ngts_getprojapprl(p_projno in varchar2) return number as
      vFlag number := 0;
    begin
      --select tcm_jobs into vFlag from jobmaster where projno = p_projno;
      select timesheet_appr into vFlag from jobmaster
        where projno = p_projno;
      return vFlag;
  end ngts_getprojapprl;
  /*function ngts_check_timedaily(p_yymm in varchar2, p_empno in varchar2, p_assign in varchar2, p_projno in varchar2, 
                                p_wpcode in varchar2, p_activity in varchar2, p_date_id in number, p_hour in decimal) return number as
      v_exists number := 0;
    begin                              
      select count(*) into v_exists from time_daily
        where yymm = p_yymm and empno = p_empno and assign = p_assign and projno = p_projno 
          and wpcode = p_wpcode and activity = p_activity ; 
  end ngts_check_timedaily;*/
  
  ----Pradeep Mahor (Get CostCode For ODD- TimeSheet) ------
 procedure ngts_getcostcode(p_dept in varchar2, p_costcodeList out sys_refcursor) as      
      v_stmt varchar2(1000) := null;
      v_count number ;
   
    begin
        
         v_stmt := ' SELECT  DISTINCT  costcode , name FROM     costmast  ';
          v_stmt := v_stmt || ' where active =1 and costcode != '''|| p_dept ||''' and costcode like ''02%'' order by name , costcode      ';
         
       
      open p_costcodeList for v_stmt ;
      
  end ngts_getcostcode; 
  
    --LOCK TIMESHEET
    FUNCTION ngts_lockTimesheet (
        p_yymm          VARCHAR2,
        p_empno         VARCHAR2, 
        p_parent        VARCHAR2,
        p_assign        VARCHAR2,
        p_user_identity_name   VARCHAR2
    ) RETURN VARCHAR2 IS
    BEGIN
        UPDATE time_mast
        SET
            locked = 1
        WHERE
            Nvl(locked, 0) = 0
            AND assign = TRIM(p_assign)
            AND parent = TRIM(p_parent)
            AND empno = TRIM(p_empno)
            AND yymm = ngts_emp_access_roles.get_univ_pros_month
            AND yymm = TRIM(p_yymm);    
            
        IF SQL%FOUND THEN
            INSERT INTO ngts_wf_log
                SELECT
                    sysdate,
                    (
                        SELECT
                            tableid
                        FROM
                            ngts_wf_log_tables_mast
                        WHERE
                            tablename = 'TIME_MAST'
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
                    (SELECT mastkeyid FROM time_mast WHERE yymm = TRIM(p_yymm) And empno = TRIM(p_empno) And parent = TRIM(p_parent) And assign = TRIM(p_assign))                
                FROM
                    dual;
                
            COMMIT;
            
            RETURN 'Done';
        ELSE
            RETURN 'Nothing to lock!!';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Err - ' || sqlcode || ' - ' || sqlerrm;
    END ngts_lockTimesheet;     
  
    --GET WORKING (APPLICABLE) HOURS IN VARCHAR2
    FUNCTION ngts_getWorkingHours (
        p_yymm    VARCHAR2,
        p_empno   VARCHAR2
    ) RETURN VARCHAR2 IS
        v_working_hrs VARCHAR2(8);
    BEGIN
        SELECT
            to_char(working_hrs)
        INTO v_working_hrs
        FROM
            wrkhours
        WHERE
            yymm = TRIM(p_yymm)
            AND office = 'BO';           

        RETURN v_working_hrs;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Err - ' || sqlcode || ' - ' || sqlerrm;
    END ngts_getWorkingHours;

end ngts_timesheet;

/
