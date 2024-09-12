Create Or Replace Package Body "TCMPL_HR"."PKG_RELATIVES_AS_COLLEAGUES_QRY" As

    Function fn_emp_relatives_as_colleagues_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_empno          Varchar2 Default Null,
        p_generic_search Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
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
                        a.empno                                               As empno,
                        get_emp_name(a.empno)                                 As emp_name,
                        a.colleague_name                                      As colleague_name,
                        a.colleague_dept                                      As colleague_dept,
                        a.colleague_relation                                  As colleague_relation_val,
                        pkg_relatives_as_colleagues_qry.frc_get_relatives_relation(
                            a.colleague_relation
                        )                                                     As colleague_relation_text,
                        a.colleague_location                                  As colleague_location,
                        a.colleague_empno                                     As colleague_empno,
                        a.modified_on                                         As modified_on,
                        a.modified_by || ' - ' || get_emp_name(a.modified_by) As modified_by,
                        Row_Number() Over(Order By a.colleague_name)          row_number,
                        Count(*) Over()                                       total_row
                    From
                        emp_relatives_as_colleagues a
                    Where
                        a.empno = nvl(p_empno, v_empno)
                        And (a.empno Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            a.colleague_name Like '%' || upper(Trim(p_generic_search)) || '%')
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_emp_relatives_as_colleagues_list;

    Procedure sp_emp_relatives_as_colleagues_details(
        p_person_id                   Varchar2,
        p_meta_id                     Varchar2,

        p_colleague_name          Out Varchar2,
        p_colleague_dept          Out Varchar2,
        p_colleague_relation_val  Out Varchar2,
        p_colleague_relation_text Out Varchar2,
        p_colleague_location      Out Varchar2,
        p_colleague_empno         Out Varchar2,
        p_modified_on             Out Date,
        p_modified_by             Out Varchar2,

        p_message_type            Out Varchar2,
        p_message_text            Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            colleague_name,
            colleague_dept,
            colleague_relation,
            frc_get_relatives_relation(colleague_relation),
            colleague_location,
            colleague_empno,
            modified_on,
            modified_by || ' - ' || get_emp_name(modified_by)
        Into
            p_colleague_name,
            p_colleague_dept,
            p_colleague_relation_val,
            p_colleague_relation_text,
            p_colleague_location,
            p_colleague_empno,
            p_modified_on,
            p_modified_by
        From
            emp_relatives_as_colleagues
        Where
            empno              = v_empno
            And colleague_name = upper(Trim(p_colleague_name));

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When no_data_found Then
            p_message_type := not_ok;
            p_message_text := 'No matching Employment of relatives exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_emp_relatives_as_colleagues_details;

    Function fn_emp_relatives_as_colleagues_xl_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                a.empno                                               As empno,
                get_emp_name(a.empno)                                 As emp_name,
                a.colleague_name                                      As colleague_name,
                a.colleague_dept                                      As colleague_dept,
                a.colleague_relation                                  As colleague_relation_val,
                pkg_relatives_as_colleagues_qry.frc_get_relatives_relation(
                    a.colleague_relation
                )                                                     As colleague_relation_text,
                a.colleague_location                                  As colleague_location,
                a.colleague_empno                                     As colleague_empno,
                a.modified_on                                         As modified_on,
                a.modified_by || ' - ' || get_emp_name(a.modified_by) As modified_by,
                Row_Number() Over(Order By
                        a.colleague_name)                             row_number,
                Count(*) Over()                                       total_row
            From
                emp_relatives_as_colleagues a
            Where
                (a.empno Like '%' || upper(Trim(p_generic_search)) || '%' Or
                    a.colleague_name Like '%' || upper(Trim(p_generic_search)) || '%')
            Order By
                a.empno;

        Return c;
    End fn_emp_relatives_as_colleagues_xl_list;

    Function frc_get_relatives_relation(
        p_key_id In Varchar2
    ) Return Varchar2 As
        v_relation_desc emp_relatives_relations.relation_desc%Type;
    Begin
        Select
            relation_desc
        Into
            v_relation_desc
        From
            emp_relatives_relations
        Where
            key_id = p_key_id;

        Return v_relation_desc;
    Exception
        When Others Then
            Return Null;
    End frc_get_relatives_relation;

    Procedure sp_emp_relatives_widget(
        p_person_id                Varchar2,
        p_meta_id                  Varchar2,

        p_emp_relatives_rating Out Varchar2,

        p_message_type         Out Varchar2,
        p_message_text         Out Varchar2
    ) As
        v_empno          Varchar2(5);
        v_count_accepted Number;
        v_count_total    Number;
    Begin
        v_empno                := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(empno)
        Into
            v_count_accepted
        From
            emp_relatives_decl_status
        Where
            decl_status = 1;

        Select
            Count(empno)
        Into
            v_count_total
        From
            emp_relatives_decl_status;

        p_emp_relatives_rating := v_count_accepted || '/' || v_count_total;
        p_message_type         := ok;
        p_message_text         := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_emp_relatives_rating := '0';
            p_message_type         := not_ok;
            p_message_text         := 'Error in rating !!!';
    End;

    Function fn_emp_relatives_as_colleagues_list_widget(
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
                        rds.empno                                                                            As empno,
                        get_emp_name(rds.empno)                                                              As emp_name,
                        e.parent || ' ' || c.name                                                            As parent,
                        e.assign || ' ' || c1.name                                                           As assign,
                        e.emptype,
                        pkg_emp_loa_addendum_acceptance_qry.fn_get_emp_relatives_loa_status(rds.decl_status) As decl_status_text,
                        rds.decl_date                                                                        As decl_date,
                        fn_get_count_emp_relatives(rds.empno)                                                As count_relatives_as_colleagues,
                        Row_Number() Over(Order By rds.empno)                                                row_number,
                        Count(*) Over()                                                                      total_row
                    From
                        emp_relatives_decl_status rds,
                        vu_emplmast               e,
                        vu_costmast               c,
                        vu_costmast               c1
                    Where
                        rds.empno       = e.empno
                        And c.costcode  = e.parent
                        And c1.costcode = e.assign
                        And rds.empno Like '%' || upper(Trim(p_generic_search)) || '%'
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_emp_relatives_as_colleagues_list_widget;

    Procedure sp_emp_relatives_decl_status_details(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_empno            Out Varchar2,
        p_decl_status_text Out Varchar2,
        p_decl_status      Out Number,

        p_message_type     Out Varchar2,
        p_message_text     Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            empno,
            Case decl_status
                When 1 Then
                    'Confirmed'
                When 3 Then
                    'OK'
                Else
                    ''
            End As decl_status_text,
            decl_status
        Into
            p_empno,
            p_decl_status_text,
            p_decl_status
        From
            emp_relatives_decl_status
        Where
            empno = v_empno;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When no_data_found Then
            p_message_type := not_ok;
            p_message_text := 'No matching Employment of relatives exists !!!';

        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_emp_relatives_decl_status_details;

    Function fn_get_count_emp_relatives(
        p_empno Varchar2)
        Return Number As
        v_count Number;
    Begin
        Select
            Count(empno)
        Into
            v_count
        From
            emp_relatives_as_colleagues
        Where
            empno = Trim(p_empno);
        Return v_count;
    End;

    Function fn_emp_relative_list_all(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For

            Select
                empno                  data_value_field,
                empno || ' - ' || name data_text_field
            From
                vu_emplmast
            Where
                status = 1
                And empno != v_empno
            Order By
                empno;
        Return c;
    End;
    
End pkg_relatives_as_colleagues_qry;