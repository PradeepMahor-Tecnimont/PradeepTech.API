--------------------------------------------------------
--  DDL for Package Body DESK
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "DESK" AS
  
   function getCabin(pDesk In Varchar2) return Varchar2 as
      vCabin Varchar2(1) := '';
    begin
      select cabin into vCabin from dm_deskmaster 
        where deskid = pDesk;
        return vCabin;
      EXCEPTION
        when Others then
          Return '';
   end getCabin;
  
  
  FUNCTION GetDesk(pEmpNo In Varchar2) RETURN Varchar2  AS
    vCount Number;
    vDeskID Varchar2(30);
  BEGIN
    vDeskID := '';
    Select count(*) INTO vCount From SS_DESKASSIGNMENT Where EmpNo = pEmpNo and flag_apprd = 1;
    If vCount >= 1 Then
      Select DeskID Into vDeskID From 
      ( Select DeskID From SS_DESKASSIGNMENT Where EmpNo = pEmpNo and flag_apprd = 1 Order By trans_date Desc )
      Where rownum = 1;
    Else
      Select count(*) INTO vCount From SS_DESKASSIGNMENT_20091127 Where EmpNo = pEmpNo ;
      If vCount > 0 Then
        Select DeskID INTO vDeskID From SS_DESKASSIGNMENT_20091127 Where EmpNo = pEmpNo ;
      End If;
    End If;
    Return vDeskID;
    EXCEPTION
      when Others then
      Return '';
  END GetDesk;

  FUNCTION GetComp(pEmpNo In Varchar2) RETURN Varchar2  AS
    vCount Number;
    vCompName Varchar2(30);
  BEGIN
    vCompName := '';
    Select count(*) INTO vCount From SS_DESKASSIGNMENT Where EmpNo = pEmpNo and flag_apprd = 1;
    If vCount >= 1 Then
      Select CompName Into vCompName From 
      ( Select CompName From SS_DESKASSIGNMENT Where EmpNo = pEmpNo and flag_apprd = 1 Order By trans_date Desc )
      Where rownum = 1;
    Else
      Select count(*) INTO vCount From SS_DESKASSIGNMENT_20091127 Where EmpNo = pEmpNo ;
      If vCount > 0 Then
        Select CompName INTO vCompName From SS_DESKASSIGNMENT_20091127 Where EmpNo = pEmpNo ;
      End If;
    End If;
    Return vCompName;
    EXCEPTION
      when Others then
      Return '';
  END GetComp;
  
  FUNCTION GetDMUid(param_Flag in Number) RETURN Varchar2 AS    
    BEGIN
      if param_Flag = 1 then
        c_dm_sessionid := DBMS_SESSION.UNIQUE_SESSION_ID;
        c_dm_uniqueid := DBMS_RANDOM.string('X',11);      
        return c_dm_uniqueid;
      else 
        if c_dm_sessionid = DBMS_SESSION.UNIQUE_SESSION_ID then
            return c_dm_uniqueid;
        end if;        
      end if;
      return '';
  END GetDMUid;
  
  FUNCTION GetEmployees(param_Desk in varchar2) RETURN Varchar2 AS
      vEmpoyees Varchar2(50);
      cursor c1 is select empno from dm_usermaster 
        where upper(trim(deskid)) = upper(trim(param_Desk));
      string_v varchar2(50);
    BEGIN      
      open c1;
      loop
        fetch c1 into string_v;
          if c1%notfound then exit; end if;
          vEmpoyees := vEmpoyees||','||string_v;
      end loop;
      close c1;
      vEmpoyees := substr(vEmpoyees,2);
      return vEmpoyees;
  END GetEmployees;
  
  
  /*function get_empinfo(p_empno in varchar2,p_type in varchar2) return emp_info as
      v_empinfo varchar2;
    begin
      v_empinfo := '';
      case p_type
        when 'N' then 
          select initcap(name) into v_empinfo from ss_emplmast where empno = p_empno;
        when 'U' then
          select userid into v_empinfo from userids where empno = p_empno;
        when 'G' then
          select grade into v_empinfo from ss_emplmat where empno = p_empno;
        when 'D' then
          select b.desg into v_empinfo from ss_empmast a, ss_desgmast b
            where a.descode = b.desgcode;
        when 'S' then
          select selfservice.getshift1(p_empno,sysdate) into v_empinfo from dual;
        else
          v_empinfo := '';
      end case;
      return v_empinfo;      
  end get_deskemp_info;
  
  
  procedure get_deskemp_details(p_deskid in varchar2, p_results out sys_refcursor) as
      v_stat varchar2(1000);
    begin
      v_stat := ' select max(case when rownum=1 then empno end) empno1, ';
      v_stat := v_stat || ' max(case when rownum=1 then empname end) name1, ';
      v_stat := v_stat || ' max(case when rownum=1 then userid end) userid1, ';
      v_stat := v_stat || ' max(case when rownum=1 then costcode end) costcode1, ';
      v_stat := v_stat || ' max(case when rownum=1 then grade end) grade1, ';
      v_stat := v_stat || ' max(case when rownum=1 then desg end) desg1, ';
      v_stat := v_stat || ' max(case when rownum=1 then shift end) shift1, ';
      v_stat := v_stat || ' max(case when rownum=1 then email end) email1, ';
      v_stat := v_stat || ' max(case when rownum=2 then empno end) empno2, ';
      v_stat := v_stat || ' max(case when rownum=2 then empname end) name2, ';
      v_stat := v_stat || ' max(case when rownum=2 then userid end) userid2, ';
      v_stat := v_stat || ' max(case when rownum=2 then costcode end) costcode2, ';
      v_stat := v_stat || ' max(case when rownum=2 then grade end) grade2, ';
      v_stat := v_stat || ' max(case when rownum=2 then desg end) desg2, ';
      v_stat := v_stat || ' max(case when rownum=2 then shift end) shift2, ';
      v_stat := v_stat || ' max(case when rownum=2 then email end) email2 ';
      v_stat := v_stat || ' from (select rownum,a.deskid,a.empno,initcap(b.name) empname,a.costcode,b.grade,c.desg, '; 
      v_stat := v_stat || ' d.userid,b.email,selfservice.getshift1(a.empno,sysdate) shift ';
      v_stat := v_stat || ' from dm_usermaster a,ss_emplmast b,ss_desgmast c,userids d  ';
      v_stat := v_stat || ' where a.empno = b.empno and b.desgcode = c.desgcode ';
      v_stat := v_stat || ' and a.empno = d.empno ';
      v_stat := v_stat || ' and a.deskid = ''' || p_deskid || ''' order by a.empno) ';      
      v_stat := v_stat || ' group by deskid ';
      open p_results for v_stat;
  end get_deskemp_details;*/
END DESK;

/
