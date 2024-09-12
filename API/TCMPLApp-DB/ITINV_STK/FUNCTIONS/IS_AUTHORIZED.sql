--------------------------------------------------------
--  DDL for Function IS_AUTHORIZED
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "ITINV_STK"."IS_AUTHORIZED" 
(
  param_user_name in varchar2 
, param_role in varchar2 
) return number as 

    vEmpNo varchar2(5);
    vCount Number;
    vRetVal number := -1;

    c_admin_role          constant  varchar2(20) := 'ADMIN_ROLE';
    c_stock_role          constant  varchar2(20) := 'STOCK_ROLE';
    c_BlueBeam_role       constant  varchar2(20) := 'BLUE_BEAM_ROLE';
    c_PhoneExtension      constant  varchar2(20) := 'PHONE_EXTENSION';
    c_Leave_Calendar      constant  varchar2(20) := 'LEAVE_CAL_ROLE';
    c_receptionist        constant  varchar2(20) := 'RECEPTIONIST_ROLE';
    
    rec_emp_user_master stk_user_master%rowtype;
begin
    Select emp_no into vEmpNo from stk_user_information where Upper(Trim(domain)) || Upper(trim(user_ID)) = Upper(Trim(Replace(param_user_name,'\')));
    
    Select Count(*) InTo vCount From Stk_User_Rights where empno = vEmpNo and Upper(Trim(Emp_Role)) = Upper(Trim(c_admin_role));
    If vCount > 0 Then
        return vCount;
    End If;
    if param_role = c_Leave_Calendar Then
    Select count(*) into vCount from stk_empmaster where parent in ('0106','0107','0119') and status=1 and EmpNo = vEmpNo;
      if vCount > 0 Then
          return 1;
      End if;
    end if;
    Select count(*) into vCount From Stk_User_Rights where empno = vEmpNo and Upper(Trim(Emp_Role)) = Upper(Trim(param_role));
    Return vCount;
    
    /*    
    If Upper(TRIM(param_role)) = Trim(c_admin_role) and nvl(rec_emp_user_master.admin_role,0) = 1 Then
        --select count(*) into vCount from stk_user_master 
          --where empno = vEmpNo and (admin_role = 1 );
        --if vCount = 1 Then
            vRetVal := 1;
        --End If;
        Return vRetVal;
    End If;
    
    If Upper(TRIM(param_role)) = Trim(c_stock_role) And nvl(rec_emp_user_master.stock_role,0) = 1 Then
        --select count(*) into vCount from stk_user_master 
          --where empno = vEmpNo and (admin_role = 1 or stock_role = 1 );
        --if vCount = 1 Then
            vRetVal := 1;
        --End If;
        Return vRetVal;
    End If;
    
    If Upper(TRIM(param_role)) = Trim(c_BlueBeam_role) And nvl(rec_emp_user_master.Blue_Beam_Role,0) = 1 Then
        --select count(*) into vCount from stk_user_master 
          --where empno = vEmpNo and (admin_role = 1 or Blue_Beam_role = 1 );
        --if vCount = 1 Then
            vRetVal := 1;
        --End If;
        Return vRetVal;
    End If;

    If Upper(TRIM(param_role)) = Trim(c_PhoneExtension) And nvl(rec_emp_user_master.PHONE_EXTENSION,0) = 1 Then
        --select count(*) into vCount from stk_user_master 
          --where empno = vEmpNo and (admin_role = 1 or Blue_Beam_role = 1 );
        --if vCount = 1 Then
            vRetVal := 1;
        --End If;
        Return vRetVal;
    End If;


    return vRetVal;

Exception
  When Others then return -1;
end is_authorized;
*/
Exception
  When Others then return -1;
End;

/
