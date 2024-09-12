--------------------------------------------------------
--  DDL for Package Body LESSON
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."LESSON" as

  procedure summary_result (p_cur out sys_refcursor) as
    begin
      open p_cur for 
        select distinct a.dept||' - '||b.abbr dept,lesson.get_org_total(a.dept) org_total,
          lesson.get_org_pending(a.dept) org_pending,
          lesson.get_org_rejected(a.dept) org_rejected,
          lesson.get_org_accepted(a.dept) org_accepted,
          lesson.get_cord_pending(a.dept) cord_pending,
          lesson.get_cord_recorded(a.dept) cord_recorded,
          lesson.get_hod_pending(a.dept) hod_pending,
          lesson.get_hod_rejected(a.dept) hod_rejeceted,
          lesson.get_hod_accepted(a.dept) hod_accepted,
          lesson.get_sp_pending(a.dept) sp_pending,
          lesson.get_sp_hosted(a.dept) sp_hosted,
          lesson.get_status_open(a.dept) status_open,
          lesson.get_status_close(a.dept) status_close from
          (select orgdept dept from ll_originator union
          select owndept dept from ll_recorded where llarchived <> 1) a,ss_costmast b
          where a.dept = b.costcode order by dept;
    end summary_result;

  function get_org_total(param_costcode varchar2) return number as
    vCount_org_total Number;
    begin
      select count(orgreqnum) into vCount_org_total from ll_originator 
        where orgdept = trim(param_costcode);   
      return vCount_org_total;    
    Exception
      When Others Then      
        return 0;    
    end get_org_total;

  function get_org_pending(param_costcode varchar2) return number as
    vCount_org_pending Number;
    begin
      select count(orgreqnum) into vCount_org_pending from ll_originator 
        where orgdept = trim(param_costcode) and (orgstatus is null or orgstatus = 0);   
      return vCount_org_pending;    
    Exception
      When Others Then      
        return 0; 
    end get_org_pending;

  function get_org_rejected(param_costcode varchar2) return number as
    vCount_org_rejected Number;
    begin
     select count(orgreqnum) into vCount_org_rejected from ll_originator 
        where orgdept = trim(param_costcode) and orgstatus = 2;   
      return vCount_org_rejected;    
    Exception
      When Others Then      
        return 0; 
    end get_org_rejected;

  function get_org_accepted(param_costcode varchar2) return number as
    vCount_org_accepted Number;
    begin
      select count(orgreqnum) into vCount_org_accepted from ll_originator 
        where orgdept = trim(param_costcode) and orgstatus = 1;   
      return vCount_org_accepted;    
    Exception
      When Others Then      
        return 0;
    end get_org_accepted;

  function get_cord_pending(param_costcode varchar2) return Number as
    vCount_cord_pending Number;
    begin
      select count(orgreqnum) into vCount_cord_pending from ll_originator
        where orgreqnum not in (select orgreqnum from ll_recorded)
        and orgdept = trim(param_costcode);   
      return vCount_cord_pending;    
    Exception
      When Others Then      
        return 0;
    end get_cord_pending;

  function get_cord_recorded(param_costcode varchar2) return number as
    vCount_cord_recorded Number;
    begin
      select count(llnum) into vCount_cord_recorded from ll_recorded
        where owndept = trim(param_costcode) and llarchived <> 1;   
      return vCount_cord_recorded;    
    Exception
      When Others Then      
        return 0;
    end get_cord_recorded;

  function get_hod_pending(param_costcode varchar2) return number as
    vCount_hod_pending Number;
    begin
      select count(llnum) into vCount_hod_pending from ll_recorded
        where owndept = trim(param_costcode) and llstatus = 'R' and llarchived <> 1;   
      return vCount_hod_pending;    
    Exception
      When Others Then      
        return 0;
    end get_hod_pending;

  function get_hod_rejected(param_costcode varchar2) return number as
    vCount_hod_rejected Number;
    begin
      select count(llnum) into vCount_hod_rejected from ll_recorded
        where owndept = trim(param_costcode) and llstatus = 'X' and llarchived <> 1;   
      return vCount_hod_rejected;    
    Exception
      When Others Then      
        return 0;
    end get_hod_rejected;

  function get_hod_accepted(param_costcode varchar2) return number as
    vCount_hod_accepted Number;
    begin
      select count(llnum) into vCount_hod_accepted from ll_recorded
        where owndept = trim(param_costcode) and llstatus in ('C','O') 
        and llarchived <> 1;   
      return vCount_hod_accepted;    
    Exception
      When Others Then      
        return 0;
    end get_hod_accepted;

  function get_sp_pending(param_costcode varchar2) return number as
    vCount_sp_pending Number;
    begin
      select count(llnum) into vCount_sp_pending from ll_recorded
        where owndept = trim(param_costcode) and tosharepoint = 1
        and llstatus in ('C','O') and llarchived <> 1;   
      return vCount_sp_pending;    
    Exception
      When Others Then      
        return 0;
    end get_sp_pending;

  function get_sp_hosted(param_costcode varchar2) return number as
    vCount_sp_hosted Number;
    begin
      select count(llnum) into vCount_sp_hosted from ll_recorded
        where owndept = trim(param_costcode) and tosharepoint = 0
        and llarchived <> 1;   
      return vCount_sp_hosted;    
    Exception
      When Others Then      
        return 0;
    end get_sp_hosted;

  function get_status_open(param_costcode varchar2) return number as
    vCount_status_open Number;
    begin
      select count(llnum) into vCount_status_open from ll_recorded
        where owndept = trim(param_costcode) and llstatus = 'C' 
        and openflag = 1 and llarchived <> 1;   
      return vCount_status_open;    
    Exception
      When Others Then      
        return 0;
    end get_status_open;

  function get_status_close(param_costcode varchar2) return number as
    vCount_status_close Number;
    begin
      select count(llnum) into vCount_status_close from ll_recorded
        where owndept = trim(param_costcode) and llstatus = 'C' 
        and hod_closeflag = 1 and llarchived <> 1;   
      return vCount_status_close;    
    Exception
      When Others Then      
        return 0;
    end get_status_close;

end lesson;


/
