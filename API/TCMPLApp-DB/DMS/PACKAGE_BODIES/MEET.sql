--------------------------------------------------------
--  DDL for Package Body MEET
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "MEET" as
  function get_meet_app_no (param_empno varchar) return varchar2 is
    v_count number;
    v_app_no varchar2(30);
  Begin
    v_count := trunc(dbms_random.value(99,1000));
    v_app_no := param_empno || to_char(sysdate,'yyyymmdd') || to_char(v_count);
    return v_app_no;
  end;
  
procedure add_meet( param_host_name varchar2, param_guest_name varchar2, param_guest_co varchar2,
                      param_meet_date varchar2, param_meet_hh number, param_meet_mn number,
                      param_meet_off varchar2, param_remarks varchar2, param_modified_by varchar2,
                      param_success out number, param_msg out varchar2) as
    v_app_no varchar2(16);
    v_meet_date date;
    v_subject varchar2(1000);
    v_body varchar2(2000);
  begin
    if param_modified_by is null or
              param_host_name is null or
              param_guest_name is null or
              param_guest_co is null or
              param_meet_date is null or
              param_meet_hh is null or
              param_meet_mn is null or
              param_meet_off is null or
              param_remarks is null then
        param_success := ss.failure;
        param_msg := 'Blank values found. Cannot proceed.';
        return;
    end if;
    
    v_meet_date := to_date(param_meet_date || ' : ' || substr('00' || to_char(param_meet_hh),-2,2) || substr('00' || param_meet_mn,-2,2) ,'dd/mm/yyyy : hh24mi');
    If v_meet_date < sysdate then
        param_success := ss.failure;
        param_msg := 'Meeting request Cannot be before' || to_char(sysdate,'dd-Mon-yyyy hh:mi AM');
        return;
    end if;
    v_app_no := get_meet_app_no(param_modified_by);
    insert into ss_guest_register (app_no, host_name, guest_co, guest_name, meet_off, meet_date, remarks, modified_by,modified_on )
      values (v_app_no, Upper(param_host_name), Upper(param_guest_co), Upper(param_guest_name), param_meet_off, v_meet_date, param_remarks,
              param_modified_by, sysdate);
    commit;
    If (trunc(v_meet_date) = trunc(sysdate)) Then
      
        v_subject := 'New Guest app for ' || To_Char(v_meet_date,'dd-Mon-yyyy hh24:mi') || ' by ' || param_Host_Name;
        
        v_body := 'Host :- ' || param_host_name || '!nuLine!';
        v_body := v_body || 'Guest :- ' || param_guest_name || '!nuLine!';
        v_body := v_body || 'Meeting Date :- ' || v_meet_date || '!nuLine!';
        v_body := v_body || 'Meeting Office :- ' || param_meet_off || '!nuLine!';
        SS_MAIL.SEND_MAIL('w.farooqui@ticb.com',v_subject,v_body,param_success ,param_msg );
    End if;
    
    param_success := ss.success;
    param_msg := 'Meeting request successfully created.';
  exception
    when others then
      param_success := ss.failure;
      param_msg := 'Err - ' || sqlcode || ' - ' || sqlerrm;
  end add_meet;

  procedure Del_Meet(paramAppNo varchar2) as
  begin
    delete from ss_guest_register where Trim(APP_NO) = Trim(paramAppNo);
    commit;
  end;

end meet;

/
