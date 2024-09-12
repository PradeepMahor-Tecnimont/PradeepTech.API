--------------------------------------------------------
--  DDL for Package Body USER_PROFILE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "USER_PROFILE" as

  function get_profile(param_empno varchar2) return number as
    vCount Number;
  begin
    --W A R N I N G
    --X X X X
    --Do not change the sequence of the Select Statements.
    
    if param_empno = '02320' then
    --  return c_type_uhrd;
    null;
    end if;
    
    --HR
    Select count(EmpNo) InTo vCount from SS_UserMast where Empno = trim(param_empno) and active = 1 and type=1;
    If vCount > 0 Then
      return c_type_uhrd;
    End If;
    
    --HOD
    Select Count(Empno) InTo vCount from SS_EmplMast where mngr = trim(Param_empno) and status = 1;
    If vCount > 0 Then
      return c_type_uhod;
    End If;
    
    --IT USB Manager
    Select Count(Empno) InTo vCount from SS_USERMAST where EMPNO = trim(Param_empno) and active = 1 and type=2;
    If vCount > 0 Then
      return c_Type_IT_USB_Mgr;
    End If;
    
    
    --LEAD
    --Select Count(EmpNo) InTo vCount from SS_Lead_Approver where Parent In 
    --  (Select Parent From SS_Emplmast Where EmpNo = trim(param_empno) And Status=1) And EmpNo = trim(param_empno) ;
    --If vCount > 0 Then
    --  return c_type_ulead;
    --End If;
    
    --Approver Secretary
    --Select Count(EmpNo) InTo vCount from SS_Delegate where Empno = trim(Param_empno);
    --If vCount > 0 Then
    --  return c_type_usec_appr;
    --End If;
    
    --Secretary
    --Select Count(EmpNo) InTo vCount from SS_User_Dept_Rights where Empno = trim(Param_empno);
    --If vCount > 0 Then
    --  return c_type_usec;
    --End If;
    
    --Others
    Return c_type_uothers;
  Exception
    When Others Then
      --Others
      Return c_type_uothers;
  end get_profile;


function get_profile_desc( param_profile number) return varchar as
begin
  case 
    when param_profile = c_type_uhod then
      return 'HOD';
    when param_profile = c_type_uhrd then
      return 'HR';
    when param_profile = c_type_ulead then
      return 'LEAD';
    when param_profile = c_type_uothers then
      return 'Others';
    when param_profile = c_type_usec then
      return 'Secretary';
    when param_profile = c_type_usec_appr then
      return 'Approver Secretary';
    else
      return null;
  end case;
end;

function get_user_tcp_ip(param_empno varchar2) return varchar2 as
  UserType Number;
  vRetVal varchar2(30);
begin
  UserType := get_profile(param_empno);
  vRetVal := 'Test';
  if UserType = c_type_uhrd then
    Select Tcp_Ip InTo vRetVal from SS_UserMast where Empno = trim(Param_empno) and active = 1;
    --vRetVal := 'Test';
  else
    vRetVal := 'Raj';
  end if;
  return vRetVal;
exception
  when others then return null;
end;

  function type_HOD return number as
  begin
    return c_type_uhod;
  end type_HOD;

  function type_HRD return number as
  begin
    
    return c_type_uhrd;
  end type_HRD;

  function type_SEC return number as
  begin
    
    return c_type_usec;
  end type_SEC;

  function type_Lead return number as
  begin
    
    return c_type_ulead;
  end type_Lead;

  function type_Others return number as
  begin
    
    return c_type_uothers;
  end type_Others;

  function type_NotLoggedIn return number as
  begin
    
    return c_type_notloggedin;
  end type_NotLoggedIn;

  function type_Sec_Appr return Number as
  begin
    
    return c_type_usec_appr;
  end type_Sec_Appr;

end user_profile;

/
