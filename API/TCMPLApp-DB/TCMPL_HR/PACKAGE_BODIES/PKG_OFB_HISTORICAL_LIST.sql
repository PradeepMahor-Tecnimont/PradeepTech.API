Create Or Replace Package Body "TCMPL_HR"."PKG_OFB_HISTORICAL_LIST" As

    c_module_id Constant Char(3) := 'M02';

    Function fn_ofb_historical_all_list(
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

        Open c For
            Select
                *
            From
                (
                    Select
                        oee.empno,
                        ove.name                                                        emp_name,
                        ove.parent                                                      parent,
                        ovc.name                                                        parent_name,
                        ove.grade,
                        --oeea.action_id,
                        oee.relieving_date,
                        to_char(oee.relieving_date, 'DD-Mon-YYYY')                      relieving_date_string,
                        oee.remarks                                                     initiator_remarks,
                        --oeea.remarks                                                           remarks,
                        pkg_ofb_common.fn_check_rollback_ofb(oee.empno, oee.created_on) is_rollback_initiated,
                        oee.is_approval_complete,
                        Case nvl(pkg_ofb_approval.fn_is_approval_complete(oee.empno), not_ok)
                            When ok Then
                                'Approved'
                            When 'OO' Then
                                'OnHold'
                            Else
                                'Pending'
                        End                                                             approval_status,
                        --oeea.sort_order,
                        Row_Number() Over (Order By oee.relieving_date Desc, oee.empno) row_number,
                        Count(*) Over ()                                                total_row
                    From
                        ofb_emp_exits   oee,
                        ofb_vu_emplmast ove,
                        ofb_vu_costmast ovc
                    Where
                        oee.empno      = ove.empno
                        And ove.parent = ovc.costcode
                        And (
                            upper(oee.empno) Like v_generic_search Or
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
        Return c;
    End;

    Function fn_ofb_historical_pending_list(
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

        Open c For
            Select
                *
            From
                (
                    Select
                        oee.empno,
                        ove.name                                                        emp_name,
                        ove.parent                                                      parent,
                        ovc.name                                                        parent_name,
                        ove.grade,
                        --oeea.action_id,
                        oee.relieving_date,
                        to_char(oee.relieving_date, 'DD-Mon-YYYY')                      relieving_date_string,
                        oee.remarks                                                     initiator_remarks,
                        --oeea.remarks                                                           remarks,
                        pkg_ofb_common.fn_check_rollback_ofb(oee.empno, oee.created_on) is_rollback_initiated,
                        oee.is_approval_complete,
                        Case nvl(pkg_ofb_approval.fn_is_approval_complete(oee.empno), not_ok)
                            When ok Then
                                'Approved'
                            When 'OO' Then
                                'OnHold'
                            Else
                                'Pending'
                        End                                                             approval_status,
                        --oeea.sort_order,
                        Row_Number() Over (Order By oee.relieving_date Desc, oee.empno) row_number,
                        Count(*) Over ()                                                total_row
                    From
                        ofb_emp_exits   oee,
                        ofb_vu_emplmast ove,
                        ofb_vu_costmast ovc
                    Where
                        oee.empno                                                            = ove.empno
                        And ove.parent                                                       = ovc.costcode
                        And nvl(pkg_ofb_approval.fn_is_approval_complete(oee.empno), not_ok) = not_ok
                        And (
                            upper(oee.empno) Like v_generic_search Or
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
        Return c;
    End;

    Function fn_ofb_historical_approved_list(
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

        Open c For
            Select
                *
            From
                (
                    Select
                        oee.empno,
                        ove.name                                                        emp_name,
                        ove.parent                                                      parent,
                        ovc.name                                                        parent_name,
                        ove.grade,
                        --oeea.action_id,
                        oee.relieving_date,
                        to_char(oee.relieving_date, 'DD-Mon-YYYY')                      relieving_date_string,
                        oee.remarks                                                     initiator_remarks,
                        --oeea.remarks                                                           remarks,
                        pkg_ofb_common.fn_check_rollback_ofb(oee.empno, oee.created_on) is_rollback_initiated,
                        oee.is_approval_complete,
                        Case nvl(pkg_ofb_approval.fn_is_approval_complete(oee.empno), not_ok)
                            When ok Then
                                'Approved'
                            When 'OO' Then
                                'OnHold'
                            Else
                                'Pending'
                        End                                                             approval_status,
                        --oeea.sort_order,
                        Row_Number() Over (Order By oee.relieving_date Desc, oee.empno) row_number,
                        Count(*) Over ()                                                total_row
                    From
                        ofb_emp_exits   oee,
                        ofb_vu_emplmast ove,
                        ofb_vu_costmast ovc
                    Where
                        oee.empno                                                            = ove.empno
                        And ove.parent                                                       = ovc.costcode
                        And nvl(pkg_ofb_approval.fn_is_approval_complete(oee.empno), not_ok) = ok
                        And (
                            upper(oee.empno) Like v_generic_search Or
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
        Return c;
    End;

    Function fn_ofb_all_list_xl(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_start_year     Varchar2,
        p_end_year       Varchar2,
        p_generic_search Varchar2 Default Null
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
        v_generic_search     Varchar2(4000);
        v_start_year         Date;
        v_end_year           Date;
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

        Select
            To_Date('01-01-' || p_start_year, 'dd-mm-YYYY') start_year,
            To_Date('31-12-' || p_end_year, 'dd-mm-YYYY')
        Into
            v_start_year,
            v_end_year
        From
            dual;

        Open c For
            Select
                *
            From
                (
                    Select
                        oee.empno,
                        ove.name                                                        employee_name,
                        ove.emptype,
                        ove.parent                                                      parent,
                        ovc.name                                                        department_name,
                        ove.grade,
                        --oeea.action_id,
                        oee.relieving_date,
                        to_char(oee.relieving_date, 'DD-Mon-YYYY')                      relieving_date_string,
                        oee.remarks                                                     initiator_remarks,                        
                        --oeea.remarks                                                           remarks,
                        pkg_ofb_common.fn_check_rollback_ofb(oee.empno, oee.created_on) is_rollback_initiated,
                        oee.is_approval_complete,
                        Case nvl(pkg_ofb_approval.fn_is_approval_complete(oee.empno), not_ok)
                            When ok Then
                                'Approved'
                            When 'OO' Then
                                'OnHold'
                            Else
                                'Pending'
                        End                                                             approval_status
                    From
                        ofb_emp_exits   oee,
                        ofb_vu_emplmast ove,
                        ofb_vu_costmast ovc
                    Where
                        oee.empno      = ove.empno
                        And ove.parent = ovc.costcode
                        And (oee.relieving_date >= v_start_year And oee.relieving_date <= v_end_year)
                        And (
                            upper(oee.empno) Like v_generic_search Or
                            upper(ove.name) Like v_generic_search Or
                            upper(ove.parent) Like v_generic_search Or
                            upper(ovc.name) Like v_generic_search
                        )
                )

            Order By
                relieving_date Desc,
                empno;
        Return c;
    End;

    Function fn_ofb_pending_list_xl(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
        v_generic_search     Varchar2(4000);
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

        Open c For
            Select
                *
            From
                (
                    Select
                        oee.empno,
                        ove.name                                                        employee_name,
                        ove.emptype,
                        ove.parent                                                      parent,
                        ovc.name                                                        department_name,
                        ove.grade,
                        --oeea.action_id,
                        oee.relieving_date,
                        to_char(oee.relieving_date, 'DD-Mon-YYYY')                      relieving_date_string,
                        oee.remarks                                                     initiator_remarks,
                        --oeea.remarks                                                           remarks,
                        pkg_ofb_common.fn_check_rollback_ofb(oee.empno, oee.created_on) is_rollback_initiated,
                        oee.is_approval_complete,
                        Case nvl(pkg_ofb_approval.fn_is_approval_complete(oee.empno), not_ok)
                            When ok Then
                                'Approved'
                            When 'OO' Then
                                'OnHold'
                            Else
                                'Pending'
                        End                                                             approval_status
                    From
                        ofb_emp_exits   oee,
                        ofb_vu_emplmast ove,
                        ofb_vu_costmast ovc
                    Where
                        oee.empno                                                            = ove.empno
                        And ove.parent                                                       = ovc.costcode
                        And nvl(pkg_ofb_approval.fn_is_approval_complete(oee.empno), not_ok) = not_ok
                        And (
                            upper(oee.empno) Like v_generic_search Or
                            upper(ove.name) Like v_generic_search Or
                            upper(ove.parent) Like v_generic_search Or
                            upper(ovc.name) Like v_generic_search
                        )
                )

            Order By
                relieving_date Desc,
                empno;
        Return c;
    End;

    Function fn_ofb_classified_all_list_xl(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_start_year     Varchar2,
        p_end_year       Varchar2,
        p_generic_search Varchar2 Default Null
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
        v_generic_search     Varchar2(4000);
        v_start_year         Date;
        v_end_year           Date;
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

        Select
            To_Date('01-01-' || p_start_year, 'dd-mm-YYYY') start_year,
            To_Date('31-12-' || p_end_year, 'dd-mm-YYYY')
        Into
            v_start_year,
            v_end_year
        From
            dual;

        Open c For
            Select
                *
            From
                (
                    Select
                        oee.empno,
                        ove.name                                                        employee_name,
                        ove.emptype,
                        ove.parent                                                      parent,
                        ovc.name                                                        department_name,
                        oee.mobile_primary                                              primary_mobile,
                        oee.alternate_number                                            alternate_mobile,
                        oee.email_id                                                    email,
                        oee.address,
                        ove.grade,
                        --oeea.action_id,
                        oee.relieving_date,
                        to_char(oee.relieving_date, 'DD-Mon-YYYY')                      relieving_date_string,
                        oee.remarks                                                     initiator_remarks,                        
                        --oeea.remarks                                                           remarks,
                        pkg_ofb_common.fn_check_rollback_ofb(oee.empno, oee.created_on) is_rollback_initiated,
                        oee.is_approval_complete,
                        Case nvl(pkg_ofb_approval.fn_is_approval_complete(oee.empno), not_ok)
                            When ok Then
                                'Approved'
                            When 'OO' Then
                                'OnHold'
                            Else
                                'Pending'
                        End                                                             approval_status
                    From
                        ofb_emp_exits   oee,
                        ofb_vu_emplmast ove,
                        ofb_vu_costmast ovc
                    Where
                        oee.empno      = ove.empno
                        And ove.parent = ovc.costcode
                        And (oee.relieving_date >= v_start_year And oee.relieving_date <= v_end_year)
                        And (
                            upper(oee.empno) Like v_generic_search Or
                            upper(ove.name) Like v_generic_search Or
                            upper(ove.parent) Like v_generic_search Or
                            upper(ovc.name) Like v_generic_search
                        )
                )

            Order By
                relieving_date Desc,
                empno;
        Return c;
    End;

End;