--------------------------------------------------------
--  DDL for Package Body PKG_RAP_OSC_DETAIL_QRY
--------------------------------------------------------

Create Or Replace Package Body timecurr.pkg_rap_osc_detail_qry As

    Function fn_po_detail_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_oscm_id        Varchar2,
        p_action_id      Varchar2 Default Null,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number   Default Null,
        p_page_length    Number Default Null

    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Char(5);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            Return Null;
        End If;

        If p_row_number Is Not Null Then
            If p_action_id = c_a233 Or p_action_id = c_a127 Then
                Open c For
                    Select
                        *
                    From
                        (
                            Select
                                rod.oscm_id                                                      As oscm_id,
                                rod.oscd_id                                                      As oscd_id,
                                rod.costcode                                                     As costcode,
                                c.name                                                           As costcode_desc,
                                fn_po_detail_orig_est_hours(p_person_id, p_meta_id, rod.oscd_id) As orig_est_hours_total,
                                fn_po_detail_cur_est_hours(p_person_id, p_meta_id, rod.oscd_id)  As cur_est_hours_total,
                                Case
                                    When rod.added_on Is Null Then
                                        0
                                    When To_Number(to_char(sysdate, 'MMYYYY')) > To_Number(to_char(added_on, 'MMYYYY')) Then
                                        0
                                    Else
                                        1
                                End                                                              As is_deletable,
                                Row_Number() Over (Order By rod.oscm_id Desc)                    row_number,
                                Count(*) Over ()                                                 total_row
                            From
                                rap_osc_detail               rod, costmast c
                            Where
                                rod.costcode    = c.costcode
                                And rod.oscm_id = Trim(p_oscm_id)
                                And (
                                    upper(rod.costcode) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                    upper(c.name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                )

                        )
                    Where
                        row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
            Elsif p_action_id = c_a128 Then
                Open c For
                    Select
                        *
                    From
                        (
                            Select
                                rod.oscm_id                                                      As oscm_id,
                                rod.oscd_id                                                      As oscd_id,
                                rod.costcode                                                     As costcode,
                                c.name                                                           As costcode_desc,
                                fn_po_detail_orig_est_hours(p_person_id, p_meta_id, rod.oscd_id) As orig_est_hours_total,
                                fn_po_detail_cur_est_hours(p_person_id, p_meta_id, rod.oscd_id)  As cur_est_hours_total,
                                Case
                                    When rod.added_on Is Null Then
                                        0
                                    When To_Number(to_char(sysdate, 'MMYYYY')) > To_Number(to_char(added_on, 'MMYYYY')) Then
                                        0
                                    Else
                                        1
                                End                                                              As is_deletable,
                                Row_Number() Over (Order By rod.oscm_id Desc)                    row_number,
                                Count(*) Over ()                                                 total_row
                            From
                                rap_osc_detail               rod, costmast c
                            Where
                                rod.costcode    = c.costcode
                                And rod.oscm_id = Trim(p_oscm_id)
                                And (
                                    upper(rod.costcode) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                    upper(c.name) Like '%' || upper(Trim(p_generic_search)) || '%'
                                )
                                And rod.costcode In (
                                    Select
                                        costcode
                                    From
                                        costmast
                                    Where
                                        hod = v_empno
                                    Union All
                                    Select
                                        costcode
                                    From
                                        rap_dyhod
                                    Where
                                        empno = v_empno
                                    Union All
                                    Select
                                        costcode
                                    From
                                        rap_hod
                                    Where
                                        empno = v_empno
                                    Union All
                                    Select
                                        costcode
                                    From
                                        rap_secretary
                                    Where
                                        empno = v_empno
                                )
                        )
                    Where
                        row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
            End If;
        Else
            If p_action_id = c_a233 Or p_action_id = c_a127 Then
                Open c For
                    Select
                        rod.costcode As costcode
                    From
                        rap_osc_detail rod
                    Where
                        rod.oscm_id = Trim(p_oscm_id);
            Elsif p_action_id = c_a128 Then
                Open c For
                    Select
                        rod.costcode As costcode
                    From
                        rap_osc_detail rod
                    Where
                        rod.oscm_id = Trim(p_oscm_id)
                        And rod.costcode In (
                            Select
                                costcode
                            From
                                costmast
                            Where
                                hod = v_empno
                            Union All
                            Select
                                costcode
                            From
                                rap_dyhod
                            Where
                                empno = v_empno
                            Union All
                            Select
                                costcode
                            From
                                rap_hod
                            Where
                                empno = v_empno
                            Union All
                            Select
                                costcode
                            From
                                rap_secretary
                            Where
                                empno = v_empno
                        );
            End If;
        End If;
        Return c;
    End fn_po_detail_list;

    Procedure sp_po_detail_details(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_oscd_id           Varchar2,
        p_oscm_id       Out Varchar2,
        p_costcode      Out Varchar2,
        p_costcode_desc Out Varchar2,

        p_message_type  Out Varchar2,
        p_message_text  Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            rod.oscm_id,
            rod.costcode,
            c.name
        Into
            p_oscm_id,
            p_costcode,
            p_costcode_desc
        From
            rap_osc_detail               rod, costmast c
        Where
            rod.costcode    = c.costcode
            And rod.oscd_id = Trim(p_oscd_id);

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_po_detail_details;

    Function fn_po_detail_orig_est_hours(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_oscd_id   Varchar2

    ) Return Number As
        v_orig_est_hrs Number;
    Begin
        Select
            Sum(orig_est_hrs)
        Into
            v_orig_est_hrs
        From
            rap_osc_hours
        Where
            oscd_id = Trim(p_oscd_id);

        Return v_orig_est_hrs;

    End fn_po_detail_orig_est_hours;

    Function fn_po_detail_cur_est_hours(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_oscd_id   Varchar2

    ) Return Number As
        v_cur_est_hrs Number;
    Begin
        Select
            Sum(cur_est_hrs)
        Into
            v_cur_est_hrs
        From
            rap_osc_hours
        Where
            oscd_id = Trim(p_oscd_id);

        Return v_cur_est_hrs;

    End fn_po_detail_cur_est_hours;

    Function fn_po_detail_ses_amount(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_oscm_id   Varchar2

    ) Return Number As
        v_ses_amount Number;
    Begin
        Select
            Sum(ses_amount)
        Into
            v_ses_amount
        From
            rap_osc_ses
        Where
            oscm_id = Trim(p_oscm_id);

        Return v_ses_amount;

    End fn_po_detail_ses_amount;

End pkg_rap_osc_detail_qry;
/
Grant Execute On "TIMECURR"."PKG_RAP_OSC_DETAIL_QRY" To "TCMPL_APP_CONFIG";