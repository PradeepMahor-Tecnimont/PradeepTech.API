--------------------------------------------------------
--  DDL for Package Body SS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SS" AS

  Function SS_False Return Number AS
  BEGIN
    /* TODO implementation required */
    RETURN n_false;
  END SS_False;

  Function SS_True Return Number as
  Begin
    Return n_true;
  End;
  
  Function ot_Approved return number as
  begin
    return n_ot_approved;
  end;
  
  
  Function ot_Rejected return number as
  begin
    return n_ot_Rejected ;
  end;
  
  Function ot_Re_Apply return number as
  Begin
    return n_ot_re_apply ;
  End;
  
  Function ot_pending return number as
  Begin
    return n_ot_pending;
  End;
  
  Function ot_Lead_None return varchar2 as
  Begin
    Return c_ot_Lead_None;
  End;
  
Function ot_apprl_none return number as
Begin
  return n_ot_apprl_none;
end;
  

 Function Approved return number as
  begin
    return n_ot_approved;
  end;
  
  
  Function Rejected return number as
  begin
    return n_ot_Rejected ;
  end;
  
  Function Re_Apply return number as
  Begin
    return n_ot_re_apply ;
  End;
  
  Function pending return number as
  Begin
    return n_ot_pending;
  End;
  
  Function Lead_None return varchar2 as
  Begin
    Return c_ot_Lead_None;
  End;
  
Function apprl_none return number as
Begin
  return n_ot_apprl_none;
end;


  function success return number as
  begin
    return n_success;
  end;
  
  function failure return number as
  begin
    return n_failure;
  end;

  function warning return number as
  begin
    return n_warning;
  end;

  FUNCTION rep_srv_nm RETURN VARCHAR2 AS
  BEGIN
    RETURN c_rep_srv_nm;
  END rep_srv_nm;
  
  FUNCTION rep_srv_url RETURN VARCHAR2 AS
  BEGIN
    RETURN c_rep_srv_url;
  END rep_srv_url;
  
  FUNCTION rep_env_id RETURN VARCHAR2 AS
  BEGIN
    RETURN c_rep_env_id;
  END rep_env_id;

  FUNCTION webutil_upload_dir RETURN VARCHAR2 AS
  BEGIN
    RETURN c_webutil_upload_dir;
  END webutil_upload_dir;


  function opening_bal return number as
  begin
      return n_opening_bal;
  end;
  
  function closing_bal return number as
  begin
      return n_closing_bal;
  end;

  function application_url return varchar2  is
  Begin
      return c_appl_url;
  End;

  function approval_text(param_status number) return varchar2 is
      v_status number;
      v_ret_val varchar2(30);
  begin
    v_status := nvl(param_status,ss.pending);
    case 
      when v_status = ss.pending then v_ret_val := 'Pending';
      when v_status = ss.approved then v_ret_val := 'Approved';
      when v_status = ss.rejected then v_ret_val := 'Rejected';
      else
      v_status := '';
    end case;
    return v_ret_val;
  end;

END SS;

/
