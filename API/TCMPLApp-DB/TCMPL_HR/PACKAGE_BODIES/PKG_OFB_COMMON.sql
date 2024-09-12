Create Or Replace Package Body "TCMPL_HR"."PKG_OFB_COMMON" As

    Function fn_get_employee_name(
        p_empno Varchar2
    ) Return Varchar2 As
        v_emp_name Varchar2(100);
    Begin
        Select
            name
        Into
            v_emp_name
        From
            ofb_vu_emplmast
        Where
            empno = Trim(p_empno);
        Return v_emp_name;
    Exception
        When Others Then
            Return Null;
    End;

    Function fn_get_dept_name(
        p_costcode Varchar2
    ) Return Varchar2 As
        v_dept_name Varchar2(100);
    Begin
        Select
            name
        Into
            v_dept_name
        From
            ofb_vu_costmast
        Where
            costcode = Trim(p_costcode);
        Return v_dept_name;
    Exception
        When Others Then
            Return Null;
    End;

    Function fn_check_rollback_ofb(
        p_empno             Varchar2,
        p_ofb_creation_date Date
    ) Return Varchar2 As
        v_requested_on ofb_rollback.requested_on%Type;
    Begin
        Select
            requested_on
        Into
            v_requested_on
        From
            (
                Select
                    requested_on
                From
                    ofb_rollback
                Where
                    empno = Trim(p_empno)
                Order By requested_on Desc
            )
        Where
            Rownum = 1;

        If v_requested_on > p_ofb_creation_date Then
            Return ok;
        Else
            Return not_ok;
        End If;
    Exception
        When no_data_found Then
            Return not_ok;
        When Others Then
            Return ok;
    End;

    Function fn_get_emp_for_apprl_action(
        p_ofb_empno       Varchar2,
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
                        empno = p_ofb_empno
                );
        Else
            Select
                --action_id,
                --action_desc,
                Listagg (e.name, ', ') Within
                    Group (Order By
                        action_id)
            Into
                v_ret_val
            From
                ofb_vu_module_user_role_actions a,
                vu_emplmast                     e
            Where
                action_id In (

                    Select
                        apprl_action_id
                    From
                        ofb_apprl_template_details
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

    Function fn_get_action_desc(
        p_action_id Varchar2
    ) Return Varchar2 As
        v_ret_val Varchar2(200);
    Begin
        Select
            action_desc
        Into
            v_ret_val
        From
            tcmpl_app_config.sec_actions_master
        Where
            action_id = p_action_id;
        Return v_ret_val;
    Exception
        When Others Then
            Return Null;
    End;

End;