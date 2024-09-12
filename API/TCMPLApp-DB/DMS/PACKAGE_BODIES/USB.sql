--------------------------------------------------------
--  DDL for Package Body USB
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "USB" as

procedure add_request(param_empno varchar2, param_reason varchar2, 
                      param_end_date varchar2, param_comp_name varchar2,
                      param_success out varchar2, param_message out varchar2) as
    v_count number;
    v_end_date date;
  begin
    -- TODO: Implementation required for procedure USB.add_request
    select count(*) into v_count from SS_USB_REQUEST where empno=trim(param_empno)
      and nvl(APPRL,ss.pending) = ss.pending;
    If v_count > 0 Then
        param_success := 'FAILURE';
        param_message := 'Error - Requests still pending for approval. Cannot create request.';
        return;
    End If;
    begin
        v_end_date := to_date(param_end_date,'dd/mm/yyyy');
    exception
        when others then
            param_success := 'FAILURE';
            param_message := 'Error - incorrect "End Date" specified.' || param_end_date;
            return;
    End;
    Insert into ss_usb_request field( key_id, empno,reason, entry_date, access_end_date,comp_name, REQ_ACCESS_EDATE ) 
      values (dbms_random.string('X',8), param_empno,param_reason, sysdate, v_end_date, param_comp_name,v_end_date );
    commit;
    param_success := 'SUCCESS';
  Exception
    when others then
        param_success := 'FAILURE';
        param_message := 'Error - ' || sqlcode || ' - ' || sqlerrm;
  end add_request;

procedure del_request(param_empno varchar2, param_key varchar2, param_success out varchar2, param_message out varchar2) as
  begin
    -- TODO: Implementation required for procedure USB.del_request
    Delete from ss_usb_request where empno=param_empno and key_id = param_key and nvl(apprl,ss.pending) = ss.pending;
    If sql%rowcount > 0 Then
      commit;
      param_success := 'SUCCESS';
    Else
      param_success := 'FAILURE';
      param_message := 'Error - Could not delete specified record.';
    End If;
  Exception
    when others then
        param_success := 'FAILURE';
        param_message := 'Error - ' || sqlcode || ' - ' || sqlerrm;
  end del_request;

procedure approve_request(param_key varchar2, param_approver varchar2, param_end_date varchar2, 
                          param_remarks varchar2, param_success out varchar2, param_message out varchar2) as
    v_end_date date;
  begin
    -- TODO: Implementation required for procedure USB.approve_request
    begin
        v_end_date := to_date(param_end_date,'dd/mm/yyyy');
    exception
        when others then
            param_success := 'FAILURE';
            param_message := 'Error - incorrect "End Date" specified.' || param_end_date;
            return;
    End;
    update ss_usb_request set 
        apprl = ss.approved, apprl_by = param_approver, apprl_dt = sysdate,
        ACCESS_END_DATE = v_end_date, apprl_remarks = param_remarks
      where key_id = param_key;
    commit;
    param_success := 'SUCCESS';
  Exception
    when others then
        param_success := 'FAILURE';
        param_message := 'Error - ' || sqlcode || ' - ' || sqlerrm;
  end approve_request;


  function employee_approver(param_empno varchar2) return varchar2 as
      v_approver varchar2(5);
  begin
    begin
      select approver into v_approver from (
        SELECT EMPNO, mngr_col approver,LEVEL approver_level FROM (
          SELECT EMPNO,NAME,PARENT, EMPNO EMPNO_1, 
          CASE WHEN EMPNO = MNGR THEN NULL ELSE MNGR END
          MNGR_COL FROM SS_EMPLMAST WHERE STATUS=1 ) 
        START WITH EMPNO = param_empno
        CONNECT BY PRIOR MNGR_COL = EMPNO ) 
      where approver_level = 2 and approver <> (c_exclude_mngr) ;
    exception
        when others then null;
    end;
    If v_approver is null Then
        begin
          select mngr into v_approver 
            from ss_emplmast where empno=param_empno
            and mngr not in (c_exclude_mngr);
        exception
          when others then null;
        end;
    end If;
    return v_approver;
  end;

  procedure reject_request(param_key varchar2, param_approver varchar2, param_remarks varchar2, 
                            param_success out varchar2, param_message out varchar2) as
  begin
    update ss_usb_request set 
        apprl = SS.REJECTED, apprl_by = param_approver, apprl_dt = sysdate,
        apprl_remarks = param_remarks
      where key_id = param_key;
    commit;
    param_success := 'SUCCESS';
  Exception
    when others then
        param_success := 'FAILURE';
        param_message := 'Error - ' || sqlcode || ' - ' || sqlerrm;
  end;
                            
  procedure IT_approve(param_key varchar2, param_approver varchar2, 
                            param_success out varchar2, param_message out varchar2) as
  begin
    update ss_usb_request set 
        it_apprl = ss.approved, it_apprl_by = param_approver, it_apprl_date = sysdate
      where key_id = trim(param_key);
    commit;
    param_success := 'SUCCESS';
        --param_message := 'Error - ' || param_key || ' - ' || param_approver;
  Exception
    when others then
        param_success := 'FAILURE';
        param_message := 'Error - ' || sqlcode || ' - ' || sqlerrm;
  end;
 
  procedure IT_reject(param_key varchar2, param_approver varchar2, 
                            param_success out varchar2, param_message out varchar2) as
  begin
    update ss_usb_request set 
        it_apprl = ss.rejected, it_apprl_by = param_approver, it_apprl_date = sysdate
      where key_id = param_key;
    commit;
    param_success := 'SUCCESS';
  Exception
    when others then
        param_success := 'FAILURE';
        param_message := 'Error - ' || sqlcode || ' - ' || sqlerrm;
  end;
 
  procedure IT_terminate_by_date(param_key varchar2, param_approver varchar2, 
                            param_success out varchar2, param_message out varchar2) as
  begin
    update ss_usb_request set 
        it_apprl = usb.termination_by_date, it_apprl_by = param_approver, it_apprl_date = sysdate
      where key_id = param_key;
    commit;
    param_success := 'SUCCESS';
  Exception
    when others then
        param_success := 'FAILURE';
        param_message := 'Error - ' || sqlcode || ' - ' || sqlerrm;
  end;

  procedure IT_terminate_by_force(param_key varchar2, param_approver varchar2, 
                            param_success out varchar2, param_message out varchar2) as
  begin
    update ss_usb_request set 
        it_apprl = USB.TERMINATION_BY_FORCE, it_apprl_by = param_approver, it_apprl_date = sysdate
      where key_id = param_key;
    commit;
    param_success := 'SUCCESS';
  Exception
    when others then
        param_success := 'FAILURE';
        param_message := 'Error - ' || sqlcode || ' - ' || sqlerrm;
  end;



  procedure it_mis_match_rectify(param_key varchar2, param_approver varchar2, 
                            param_success out varchar2, param_message out varchar2) as
    v_count number;
    v_empno varchar2(5);
  begin
    Select empno into v_empno from ss_usb_request where key_id = param_key;
    select count(*) into v_count from ss_usb_request 
      where key_id = trim(param_key) and trim(comp_name) <> usb.get_comp_name(v_empno);
    If v_count > 0 Then
        update ss_usb_request set comp_name  = trim(usb.get_comp_name(v_empno)),
          it_apprl_by = param_approver, it_apprl_date = sysdate
          where key_id = param_key;
        commit;
    End If;
    select count(*) into v_count from ss_usb_request where key_id = param_key
      and trunc(nvl(access_end_date, sysdate+1)) <= trunc(sysdate);
    If v_count > 0 Then
        update ss_usb_request set it_apprl  = usb.termination_by_date,
          it_apprl_by = param_approver, it_apprl_date = sysdate
          where key_id = param_key;
        commit;
    End If;
    param_success := 'SUCCESS';
  Exception
      when Others then
        param_success := 'FAILURE';
        param_message := 'Error - ' || sqlcode || ' - ' || sqlerrm;
  end;
  


  procedure IT_mach_replaced(param_key varchar2, param_approver varchar2, 
                            param_success out varchar2, param_message out varchar2) as
  begin
  /*
    update ss_usb_request set 
        it_apprl = USB.TERMINATION_BY_FORCE, it_apprl_by = param_approver, it_apprl_date = sysdate
      where key_id = param_key;
    commit;
    */
    param_success := 'SUCCESS';
  Exception
    when others then
        param_success := 'FAILURE';
        param_message := 'Error - ' || sqlcode || ' - ' || sqlerrm;
  end;


  function approved return number is
  begin
    return n_approved;
  end;
  
  function rejected return number is
  begin
    return n_rejected;
  end;
  function pending return number is
  begin
    return n_pending;
  end;
  
  function termination_by_force return number is
  begin
    return n_termination_by_force;
  end;
  
  function termination_by_date return number is
  begin
    return n_termination_by_date;
  end;
  

  function approval_text(param_status number) return varchar2 is
      v_status number;
      v_ret_val varchar2(30);
  begin
    v_status := nvl(param_status,ss.pending);
    case 
      when v_status = usb.pending then v_ret_val := 'Pending';
      when v_status = usb.approved then v_ret_val := 'Approved';
      when v_status = usb.rejected then v_ret_val := 'Rejected';
      when v_status = usb.termination_by_force then v_ret_val := 'Forceful Termination';
      when v_status = usb.termination_by_date then v_ret_val := 'Termination by Request';
      else
      v_status := '';
    end case;
    return v_ret_val;
  end;

  function get_comp_name(param_empno varchar2) return varchar2 is
      v_comp_name varchar2(60);
  begin
    If param_empno = 'ALLSS' Then
      Return 'PC9584';
    End If;
    select a.COMPNAME into v_comp_name from desmas_Allocation_all a where a.empno1 = trim(param_empno) or a.empno2 = trim(param_empno);
    return v_comp_name;
  exception 
      when others then return 'ERRRRR';
  end;
end usb;

/
