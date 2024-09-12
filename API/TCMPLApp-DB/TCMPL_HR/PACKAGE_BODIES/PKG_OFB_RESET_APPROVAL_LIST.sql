Create Or Replace Package Body "TCMPL_HR"."PKG_OFB_RESET_APPROVAL_LIST" As

    c_module_id Constant Char(3) := 'M02';
    c_hod       Constant Char(3) := 'HOD';
    c_a190      Constant Char(4) := 'A190';

    Procedure sp_check_4_hod(
        p_person_id        Varchar2 Default Null,
        p_meta_id          Varchar2 Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
        v_count Number;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(ovc.hod)
        Into
            v_count
        From
            ofb_vu_costmast ovc
        Where
            ovc.hod = Trim(v_empno);

        p_message_type := ok;
        If v_count > 0 Then
            p_message_text := c_hod;
        Else
            p_message_text := Null;
        End If;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_check_4_hod;

    Function fn_ofb_reset_approval_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
        v_generic_search     Varchar2(4000);
        v_message_type       Char(2);
        v_message_text       Varchar2(4000);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If Trim(p_generic_search) Is Null Then
            v_generic_search := '%';
        Else
            v_generic_search := '%' || upper(trim(p_generic_search)) || '%';
        End If;

        sp_check_4_hod(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,

            p_message_type => v_message_type,
            p_message_text => v_message_text
        );
        If v_message_type = not_ok Then
            Return Null;
        End If;

        If v_message_type = ok And v_message_text Is Null Then
            Open c For
                Select
                    *
                From
                    (
                        With
                            approved_max_ofb As (
                                Select
                                    oeea1.empno, Max(oeea1.sort_order) sort_order
                                From
                                    ofb_emp_exit_approvals oeea1
                                Where
                                    nvl(oeea1.is_approved, not_ok) = ok
                                Group By oeea1.empno
                            )
                        Select
                            oeea.empno,
                            ove.name                                                               emp_name,
                            ove.parent                                                             parent,
                            ovc.name                                                               parent_name,
                            ove.grade,
                            oeea.action_id,
                            oee.relieving_date,
                            to_char(oee.relieving_date, 'DD-Mon-YYYY')                             relieving_date_string,
                            oee.remarks                                                            initiator_remarks,
                            pkg_ofb_common.fn_check_rollback_ofb(oeea.empno, oee.created_on) is_rollback_initiated,
                            oeea.is_approved,
                            Case nvl(oeea.is_approved, not_ok)
                                When ok Then
                                    'Approved'
                                Else
                                    'Pending'
                            End                                                                    approval_status,
                            Row_Number() Over (Order By oee.relieving_date Desc, oeea.empno)       row_number,
                            Count(*) Over ()                                                       total_row
                        From
                            ofb_emp_exit_approvals oeea,
                            ofb_vu_emplmast        ove,
                            ofb_vu_costmast        ovc,
                            ofb_emp_exits          oee,
                            approved_max_ofb       amo
                        Where
                            oeea.apprl_action_id In (
                                Select
                                    ovmura.action_id
                                From
                                    ofb_vu_module_user_role_actions ovmura
                                Where
                                    ovmura.empno         = Trim(v_empno)
                                    And ovmura.module_id = c_module_id
                            )
                            And ove.empno                     = oeea.empno
                            And ove.parent                    = ovc.costcode
                            And oee.empno                     = oeea.empno
                            And nvl(oeea.is_approved, not_ok) = ok
                            And oeea.empno                    = amo.empno
                            And oeea.sort_order               = amo.sort_order
                            And oee.end_by_date >= sysdate
                            And (
                                upper(oeea.empno) Like v_generic_search Or
                                upper(ove.name) Like v_generic_search Or
                                upper(ove.parent) Like v_generic_search Or
                                upper(ovc.name) Like v_generic_search
                            )
                    )
                Where
                    row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
                Order By
                    relieving_date Desc,
                    empno;
        Elsif v_message_type = ok And v_message_text = c_hod Then
            Open c For
                Select
                    *
                From
                    (
                        With
                            approved_max_ofb As (
                                Select
                                    oeea1.empno, Max(oeea1.sort_order) sort_order
                                From
                                    ofb_emp_exit_approvals oeea1
                                Where
                                    nvl(oeea1.is_approved, not_ok) = ok
                                Group By oeea1.empno
                            )
                        Select
                            oeea.empno,
                            ove.name                                                               emp_name,
                            ove.parent                                                             parent,
                            ovc.name                                                               parent_name,
                            ove.grade,
                            oeea.action_id,
                            oee.relieving_date,
                            to_char(oee.relieving_date, 'DD-Mon-YYYY')                             relieving_date_string,
                            oee.remarks                                                            initiator_remarks,
                            pkg_ofb_common.fn_check_rollback_ofb(oeea.empno, oee.created_on) is_rollback_initiated,
                            oeea.is_approved,
                            Case nvl(oeea.is_approved, not_ok)
                                When ok Then
                                    'Approved'
                                Else
                                    'Pending'
                            End                                                                    approval_status,
                            Row_Number() Over (Order By oee.relieving_date Desc, oeea.empno)       row_number,
                            Count(*) Over ()                                                       total_row
                        From
                            ofb_emp_exit_approvals oeea,
                            ofb_vu_emplmast        ove,
                            ofb_vu_costmast        ovc,
                            ofb_emp_exits          oee,
                            approved_max_ofb       amo
                        Where
                            (
                                (oeea.apprl_action_id In (
                                        Select
                                            ovmura.action_id
                                        From
                                            ofb_vu_module_user_role_actions ovmura
                                        Where
                                            ovmura.empno         = Trim(v_empno)
                                            And ovmura.module_id = c_module_id
                                    )
                                    And ovc.hod               = Trim(v_empno))
                                Or
                                oeea.apprl_action_id In (
                                    Select
                                        ovmura1.action_id
                                    From
                                        ofb_vu_module_user_role_actions ovmura1
                                    Where
                                        ovmura1.empno         = Trim(v_empno)
                                        And ovmura1.action_id = c_a190
                                        And ovmura1.module_id = c_module_id
                                )
                            )
                            And ove.empno                     = oeea.empno
                            And ove.parent                    = ovc.costcode
                            And oee.empno                     = oeea.empno
                            And nvl(oeea.is_approved, not_ok) = ok
                            And oeea.empno                    = amo.empno
                            And oeea.sort_order               = amo.sort_order
                            And oee.end_by_date >= sysdate
                            And (
                                upper(oeea.empno) Like v_generic_search Or
                                upper(ove.name) Like v_generic_search Or
                                upper(ove.parent) Like v_generic_search Or
                                upper(ovc.name) Like v_generic_search
                            )
                    )
                Where
                    row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
                Order By
                    relieving_date Desc,
                    empno;
        End If;
        Return c;
    End fn_ofb_reset_approval_list;
End;