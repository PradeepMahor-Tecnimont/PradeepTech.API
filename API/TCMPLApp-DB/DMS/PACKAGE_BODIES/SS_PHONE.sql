--------------------------------------------------------
--  DDL for Package Body SS_PHONE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SS_PHONE" as

function get_ext_emp(param_ext varchar2,param_call_date date) return varchar2 as
    v_asset_id varchar2(60);
    v_desk_id varchar2(7);
    v_flag varchar2(1);
    c_deleted constant varchar2(1) := 'D';
    c_inserted constant varchar2(1) := 'I';
    v_empno varchar2(5);
  begin
    select asset_id into v_asset_id from (
        select trim(PHONE_BAR_CODE) asset_id, rownum rn from 
          ss_phone_ext_log where trim(PHONE_EXT) = trim(param_ext) 
          and trunc(log_date) <= trunc(param_call_date) order by log_date 
      ) where rn = 1;
    
    select deskid, flag into v_desk_id, v_flag from (
        select deskid, FLAG   , rownum as rn from dm_deskallocation_log
            where trim(assetid) = trim(v_asset_id) and trunc(log_date) <= trunc(param_call_date)
            order by log_date desc, flag  desc 
      ) a where a.rn = 1;
    if v_flag = c_deleted then
        return null;
    end if;
    select empno, flag into v_empno, v_flag from (
        Select empno , flag , rownum rn from dm_usermaster_log where trim(deskid) = trim(v_desk_id)
          and trunc(log_date) <= trunc(param_call_date) order by log_date desc, flag desc)
      where rn = 1;
    if v_flag = c_deleted then
        return null;
    end if;
    return v_empno;      
  end get_ext_emp;

end ss_phone;

/
