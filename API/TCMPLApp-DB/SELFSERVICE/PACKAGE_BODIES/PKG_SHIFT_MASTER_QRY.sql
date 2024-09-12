Create Or Replace Package Body selfservice.pkg_shift_master_qry As

    Function fn_shift_list(
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
                        shiftcode                                 As shiftcode,
                        shiftdesc                                 As shiftdesc,
                        timein_hh                                 As timein_hh,
                        timein_mn                                 As timein_mn,
                        timeout_hh                                As timeout_hh,
                        timeout_mn                                As timeout_mn,
                        Case shift4allowance
                            When 1 Then
                                'Yes'
                            When 0 Then
                                'No'
                            Else
                                '-'
                        End                                       As shift4allowance_text,
                        shift4allowance                           As shift4allowance,
                        lunch_mn                                  As lunch_mn,
                        ot_applicable                             As ot_applicable,
                        Case ot_applicable
                            When 1 Then
                                'Yes'
                            When 0 Then
                                'No'
                            Else
                                '-'
                        End                                       As ot_applicable_text,
                        Row_Number() Over(Order By shiftcode Asc) row_number,
                        Count(*) Over()                           total_row
                    From
                        ss_shiftmast
                    Where
                        upper(shiftcode) Like '%' || upper(Trim(p_generic_search)) || '%'
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_shift_list;

    Function fn_shift_xl(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                shiftcode       As shiftcode,
                shiftdesc       As shiftdesc,
                timein_hh       As timein_hh,
                timein_mn       As timein_mn,
                timeout_hh      As timeout_hh,
                timeout_mn      As timeout_mn,
                Case shift4allowance
                    When 1 Then
                        'Yes'
                    When 0 Then
                        'No'
                    Else
                        '-'
                End             As shift4allowance_text,
                shift4allowance As shift4allowance,
                lunch_mn        As lunch_mn,
                ot_applicable   As ot_applicable,
                Case ot_applicable
                    When 1 Then
                        'Yes'
                    When 0 Then
                        'No'
                    Else
                        '-'
                End             As ot_applicable_text
            From
                ss_shiftmast
            Order By
                shiftcode;

        Return c;
    End fn_shift_xl;

End pkg_shift_master_qry;