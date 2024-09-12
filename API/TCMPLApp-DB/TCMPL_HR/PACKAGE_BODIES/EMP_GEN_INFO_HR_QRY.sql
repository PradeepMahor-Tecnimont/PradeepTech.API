--------------------------------------------------------
--  DDL for Package Body EMP_GEN_INFO_HR_QRY
--------------------------------------------------------

Create Or Replace Package Body "TCMPL_HR"."EMP_GEN_INFO_HR_QRY" As

    Function fn_emp_list(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_generic_search     Varchar2 Default Null,
        p_parent             Varchar2 Default Null,
        p_is_login_open      Number   Default Null,
        p_is_primary_open    Number   Default Null,
        p_is_secondary_open  Number   Default Null,
        p_is_nomination_open Number   Default Null,
        p_is_mediclaim_open  Number   Default Null,
        p_is_aadhaar_open    Number   Default Null,
        p_is_passport_open   Number   Default Null,
        p_is_gtli_open       Number   Default Null,
        p_ex_empno           Varchar2 Default Null,

        p_row_number         Number,
        p_page_length        Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If (p_ex_empno Is Not Null) Then
            Open c For

                Select
                    *
                From
                    (
                        Select
                            b.empno                               As empno,
                            a.name                                As emp_name,
                            a.parent                              As parent,
                            (
                                Select
                                    name
                                From
                                    ers_vu_costmast c
                                Where
                                    c.costcode = a.parent
                            )                                     As parent_name,
                            a.assign                              As assign,
                            (
                                Select
                                    name
                                From
                                    ers_vu_costmast c
                                Where
                                    c.costcode = a.assign
                            )                                     As assign_name,
                            to_char(b.modified_on, 'DD-Mon-YYYY') As modified_on,
                            b.login_lock_open                     As is_login_lock_open,    -- Number
                            b.prim_lock_open                      As is_prim_lock_open,     -- Number
                            b.secondary_lock                      As is_secondary_lock_open,     -- Number
                            b.nom_lock_open                       As is_nom_lock_open,      -- Number
                            b.fmly_lock_open                      As is_fmly_lock_open,     -- Number
                            b.adhaar_lock                         As is_adhaar_lock,        -- Number
                            b.gtli_lock                           As is_gtli_lock,          -- Number
                            b.pp_lock                             As is_pp_lock,            -- Number
                            1                                     As nomination_exists,
                            1                                     As pp_exists,
                            1                                     As aadhaar_exists,
                            1                                     As gtli_exists,

                            Row_Number() Over (Order By a.empno)  row_number,
                            Count(*) Over ()                      total_row
                        From
                            vpp_vu_emplmast a,
                            emp_lock_status b
                        Where
                            a.empno      = b.empno
                            And a.status = 0
                            And a.empno  = nvl(Trim(p_ex_empno), a.empno)
                    )
                Where
                    row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

            Return c;

        Else
            Open c For

                Select
                    *
                From
                    (
                        Select
                            b.empno                               As empno,
                            a.name                                As emp_name,
                            a.parent                              As parent,
                            (
                                Select
                                    name
                                From
                                    ers_vu_costmast c
                                Where
                                    c.costcode = a.parent
                            )                                     As parent_name,
                            a.assign                              As assign,
                            (
                                Select
                                    name
                                From
                                    ers_vu_costmast c
                                Where
                                    c.costcode = a.assign
                            )                                     As assign_name,
                            to_char(b.modified_on, 'DD-Mon-YYYY') As modified_on,
                            b.login_lock_open                     As is_login_lock_open,    -- Number
                            b.prim_lock_open                      As is_prim_lock_open,     -- Number
                            b.secondary_lock                      As is_secondary_lock_open,     -- Number
                            b.nom_lock_open                       As is_nom_lock_open,      -- Number
                            b.fmly_lock_open                      As is_fmly_lock_open,     -- Number
                            b.adhaar_lock                         As is_adhaar_lock,        -- Number
                            b.gtli_lock                           As is_gtli_lock,          -- Number
                            b.pp_lock                             As is_pp_lock,            -- Number
                            1                                     As nomination_exists,
                            1                                     As pp_exists,
                            1                                     As aadhaar_exists,
                            1                                     As gtli_exists,

                            Row_Number() Over (Order By a.empno)  row_number,
                            Count(*) Over ()                      total_row
                        From
                            vpp_vu_emplmast a,
                            emp_lock_status b
                        Where
                            a.empno               = b.empno
                            And a.status          = 1
                            And a.parent          = nvl(Trim(p_parent), a.parent)
                            And b.login_lock_open = nvl(p_is_login_open, b.login_lock_open)
                            And b.prim_lock_open  = nvl(p_is_primary_open, b.prim_lock_open)
                            And b.secondary_lock  = nvl(p_is_secondary_open, b.secondary_lock)
                            And b.nom_lock_open   = nvl(p_is_nomination_open, b.nom_lock_open)
                            And b.fmly_lock_open  = nvl(p_is_mediclaim_open, b.fmly_lock_open)
                            And b.adhaar_lock     = nvl(p_is_aadhaar_open, b.adhaar_lock)
                            And b.gtli_lock       = nvl(p_is_gtli_open, b.gtli_lock)
                            And b.pp_lock         = nvl(p_is_passport_open, b.pp_lock)
                            And
                            (
                                upper(a.empno) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                upper(a.name) Like '%' || upper(Trim(p_generic_search)) || '%'
                            )
                    )
                Where
                    row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
            Return c;

        End If;

    End fn_emp_list;

    Function fn_emp_nomination_status_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,
        p_parent         Varchar2 Default Null,
        p_submit_status  Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        b.empno                                               As empno,
                        a.name                                                As emp_name,
                        a.parent
                        || ' - ' ||
                        (
                            Select
                                name
                            From
                                ers_vu_costmast c
                            Where
                                c.costcode = a.parent
                        )                                                     As parent,
                        to_char(a.doj, 'DD-Mon-YYYY')                         As doj,
                        a.email                                               As email,
                        b.submitted                                           As submitted,
                        a.status                                              As p_roll_status,
                        to_char(b.modified_on, 'DD-Mon-YYYY')                 As hr_date,
                        b.modified_by || ' - ' || get_emp_name(b.modified_by) As modified_by,
                        Row_Number() Over (Order By a.empno)                  row_number,
                        Count(*) Over ()                                      total_row
                    From
                        vpp_vu_emplmast                          a, emp_nomination_status b
                    Where
                        a.empno         = b.empno
                        And a.parent    = nvl(Trim(p_parent), a.parent)
                        And b.submitted = nvl(Trim(p_submit_status), b.submitted)
                        And
                        (
                            upper(a.empno) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(a.name) Like '%' || upper(Trim(p_generic_search)) || '%'
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;

    End fn_emp_nomination_status_list;

    Function fn_emp_gtli_status_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,
        p_parent         Varchar2 Default Null,
        p_submit_status  Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        b.empno                                               As empno,
                        a.name                                                As emp_name,
                        a.parent
                        || ' - ' ||
                        (
                            Select
                                name
                            From
                                ers_vu_costmast c
                            Where
                                c.costcode = a.parent
                        )                                                     As parent,
                        to_char(a.doj, 'DD-Mon-YYYY')                         As doj,
                        a.email                                               As email,
                        b.hr_verified                                         As hr_verified,
                        a.status                                              As p_roll_status,
                        to_char(b.modified_on, 'DD-Mon-YYYY')                 As hr_date,
                        b.modified_by || ' - ' || get_emp_name(b.modified_by) As modified_by,
                        Row_Number() Over (Order By a.empno)                  row_number,
                        Count(*) Over ()                                      total_row
                    From
                        vpp_vu_emplmast                    a, emp_gtli_status b
                    Where
                        a.empno           = b.empno
                        And a.parent      = nvl(Trim(p_parent), a.parent)
                        And b.hr_verified = nvl(Trim(p_submit_status), b.hr_verified)
                        And
                        (
                            upper(a.empno) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(a.name) Like '%' || upper(Trim(p_generic_search)) || '%'
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;

    End fn_emp_gtli_status_list;

    Function fn_emp_nomination_status_xl(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        b.empno                                               As empno,
                        a.name                                                As emp_name,
                        a.parent
                        || ' - ' ||
                        (
                            Select
                                name
                            From
                                ers_vu_costmast c
                            Where
                                c.costcode = a.parent
                        )                                                     As parent,
                        to_char(a.doj, 'DD-Mon-YYYY')                         As doj,
                        a.email                                               As email,
                        b.submitted                                           As submitted,
                        a.status                                              As p_roll_status,
                        to_char(b.modified_on, 'DD-Mon-YYYY')                 As hr_date,
                        b.modified_by || ' - ' || get_emp_name(b.modified_by) As modified_by
                    From
                        vpp_vu_emplmast                          a, emp_nomination_status b
                    Where
                        a.empno = b.empno
                );
        Return c;

    End fn_emp_nomination_status_xl;

    Function fn_emp_gtli_status_xl(
        p_person_id Varchar2,
        p_meta_id   Varchar2

    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        b.empno                                               As empno,
                        a.name                                                As emp_name,
                        a.parent
                        || ' - ' ||
                        (
                            Select
                                name
                            From
                                ers_vu_costmast c
                            Where
                                c.costcode = a.parent
                        )                                                     As parent,
                        to_char(a.doj, 'DD-Mon-YYYY')                         As doj,
                        a.email                                               As email,
                        b.hr_verified                                         As hr_verified,
                        a.status                                              As p_roll_status,
                        to_char(b.modified_on, 'DD-Mon-YYYY')                 As hr_date,
                        b.modified_by || ' - ' || get_emp_name(b.modified_by) As modified_by
                    From
                        vpp_vu_emplmast                    a, emp_gtli_status b
                    Where
                        a.empno = b.empno
                );
        Return c;

    End fn_emp_gtli_status_xl;

End emp_gen_info_hr_qry;
/
Grant Execute On "TCMPL_HR"."EMP_GEN_INFO_HR_QRY" To "TCMPL_APP_CONFIG";
/