--------------------------------------------------------
--  DDL for Package Body NGTS_USERS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."NGTS_USERS" as

  procedure ngts_setpreferreddept(p_empno in varchar2, p_deptno in varchar2, p_msg out varchar2) as
      v_exists number := 0;
    begin
      select count(empno) into v_exists from ngts_prefer_dept 
        where empno = p_empno;
      if v_exists = 0 then
        insert into ngts_prefer_dept(empno, deptno)
          values(p_empno, p_deptno);
      else
        update ngts_prefer_dept
          set deptno = p_deptno
          where empno = p_empno;          
      end if;
      commit;
      p_msg := 'Preferred Dept Updated';
    exception
      when others then     
        p_msg := 'Err - ' || sqlcode || ' - ' || sqlerrm;
  end ngts_setpreferreddept;  

  procedure ngts_getyears(p_yearlist out sys_refcursor) as
      v_stmt varchar2(1000) := null;
    begin    
      v_stmt := 'select ts_yyyy yyyy, case when substr(ts_yyyy,1,4) = Extract(Year from Add_Months(Trunc(Add_Months(sysdate,-3),''YYYY''),3)) ';
      v_stmt := v_stmt || ' then 1 else 0 end isCurrent from ngts_year_mast ';           
      v_stmt := v_stmt || ' where ts_isactive = 1 order by ts_yyyy desc';
      open p_yearlist for v_stmt;
      -- Comment By Pradeep Mahor
     -- close p_yearlist;
  end ngts_getyears;

  procedure ngts_getempdetails(p_empno in varchar2, p_assign in varchar2, p_details out sys_refcursor) as
      v_stmt varchar2(1000) := null;
    begin
      v_stmt := ' select empno, initcap(name) name, parent, ngts_users.ngts_getdeptabbr(parent) parentabbr, ';
      v_stmt := v_stmt || ' ngts_users.ngts_getdeptabbr(''' || p_assign || ''') assignabbr from emplmast ';
      v_stmt := v_stmt || ' where empno = ''' || p_empno || ''' ';
      open p_details for v_stmt;      
      -- close p_details;
  end ngts_getempdetails;

  procedure ngts_getmydetails(p_email in varchar2, p_details out sys_refcursor) as
      v_stmt varchar2(1000) := null;
    begin
      v_stmt := ' select empno, initcap(name) name, parent, ngts_users.ngts_getdeptabbr(parent) parentabbr, ';
      v_stmt := v_stmt || ' assign, ngts_users.ngts_getdeptabbr(assign) assignabbr, desgcode, ';
      v_stmt := v_stmt || ' ngts_users.ngts_getdesgdesc(desgcode) desg, grade from emplmast ';
      v_stmt := v_stmt || ' where status = 1 and emptype in (''R'',''C'',''S'',''F'') ';
      v_stmt := v_stmt || ' and lower(email) = lower(''' || p_email || ''') ';
      open p_details for v_stmt;
    --  close p_details;
  end ngts_getmydetails;

  procedure ngts_getuserdetails(p_domain in varchar2, p_userid in varchar2, p_details out sys_refcursor) as
      v_stmt varchar2(1000) := null;
    begin
      v_stmt := ' select a.empno, initcap(a.name) name, a.parent, ngts_users.ngts_getdeptabbr(a.parent) parentabbr, ';
      v_stmt := v_stmt || ' a.assign, ngts_users.ngts_getdeptabbr(a.assign) assignabbr, a.desgcode, a.grade, ';
      v_stmt := v_stmt || ' ngts_users.ngts_getdesgdesc(a.desgcode) desg, b.domain, b.userid ';
      v_stmt := v_stmt || ' from emplmast a, selfservice.userids b  ';
      v_stmt := v_stmt || ' where upper(trim(a.empno)) = upper(trim(b.empno)) and a.status = 1  ';
      v_stmt := v_stmt || ' and upper(trim(b.domain)) = upper(trim(''' || p_domain || ''')) ';
      v_stmt := v_stmt || ' and upper(trim(b.userid)) = upper(trim(''' || p_userid || '''))  ';
      --Dbms_Output.Put_Line(v_stmt);
      open p_details for v_stmt;
     -- close p_details;
  end ngts_getuserdetails;

  function ngts_getdeptabbr(p_deptno in varchar2) return varchar2 as
      vAbbr varchar2(11) := '';
    begin
       select abbr into vAbbr from costmast where costcode = p_deptno;
       return vAbbr;
  end ngts_getdeptabbr;

  function ngts_getdesgdesc(p_desgcode in varchar2) return varchar2 as
      vDesgdesc varchar2(45) := '';
    begin
      select desg into vDesgdesc from desgmast where desgcode = p_desgcode;
      return vDesgdesc;
  end ngts_getdesgdesc;
  
  function ngts_getemail(p_userid in varchar2) return varchar2 as
      vEmail varchar2(50) := '';
    begin
      select a.email into vEmail from emplmast a, selfservice.userids b
        where upper(trim(a.empno)) = upper(trim(b.empno)) 
        and upper(trim(b.userid)) = upper(trim(p_userid));
     return vEmail;
  end ngts_getemail;
  
  ----Pradeep Mahor-------- 
/*

procedure ngts_getSubordinateEmpList(p_empno in varchar2,p_dept in varchar2, p_SubordinateEmpList out sys_refcursor) as      
      v_stmt varchar2(1000) := null;
      v_count number ;

    begin

        SELECT    count(*) into v_count
            FROM    ngts_user_dept_roles
            where roleid='R3' and deptno=p_dept and empno= p_empno;

        if( v_count > 0) then    
        -------For Proxy - HOD-------
        v_stmt := ' SELECT  DISTINCT  empno, name ,  email,    parent     ';
         v_stmt := v_stmt || ' FROM    emplmast ';
         v_stmt := v_stmt || ' where status=1 ';
         v_stmt := v_stmt || ' and parent=''' || p_dept|| ''' ';

        ELSE
        -------For HOD-------
          v_stmt := ' SELECT  DISTINCT  empno, name ,   email,    parent     ';
         v_stmt := v_stmt || ' FROM    emplmast ';
         v_stmt := v_stmt || ' where status=1 ';
              v_stmt := v_stmt || ' and emp_hod=''' ||p_empno|| '''and parent=''' || p_dept|| ''' ';
        end if;

      open p_SubordinateEmpList for v_stmt ;

  end ngts_getSubordinateEmpList; 
*/


    FUNCTION ngts_GetUserTimesheetDepts (
        p_yymm     IN   VARCHAR2,
        p_empno    IN   VARCHAR2,
        p_assign   IN   VARCHAR2
    ) RETURN SYS_REFCURSOR IS
        o_cursor SYS_REFCURSOR;
    BEGIN
        OPEN o_cursor FOR SELECT
                              a.assign   deptno,
                              b.name     name,
                              b.abbr     deptabbr
                          FROM
                              time_mast   a,
                              costmast    b
                          WHERE
                              a.assign = b.costcode                              
                              AND a.parent = TRIM(p_assign)
                              AND a.empno = TRIM(p_empno)
                              AND a.yymm = TRIM(p_yymm);

        RETURN o_cursor;
    END ngts_GetUserTimesheetDepts;
  
end ngts_users;

/
