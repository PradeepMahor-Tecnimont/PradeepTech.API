Create Or Replace Package Body "TCMPL_HR"."PKG_DG_COMMON" As
    
    Function fn_get_emp_for_apprl_action(
        p_dg_empno       Varchar2,
        p_apprl_action_id Varchar2
    ) Return Varchar2 As
        v_ret_val          Varchar2(2000);
        c_hod_apprl_action Constant Varchar2(4) := 'A174';
    Begin
        If p_apprl_action_id = c_hod_apprl_action Then
            Select
                pkg_common.fn_get_employee_name(hod)
            Into
                v_ret_val
            From
                vu_costmast
            Where
                costcode = (
                    Select
                        parent
                    From
                        vu_emplmast
                    Where
                        empno = p_dg_empno
                );
        Else
            Select                
                Listagg (e.name, ', ') Within
                    Group (Order By
                        action_id)
            Into
                v_ret_val
            From
                dg_vu_module_user_role_actions a,
                vu_emplmast                     e
            Where
                action_id In (
                    Select
                        apprl_action_id
                    From
                        dg_apprl_template_details
                )
                And action_id = p_apprl_action_id
                And a.empno   = e.empno
            Group By
                action_id, action_desc;
        End If;
        Return v_ret_val;
    Exception
        When Others Then
            Return Null;
    End;
    
End;