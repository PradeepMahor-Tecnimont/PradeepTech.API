--------------------------------------------------------
--  DDL for Package Body PKG_RAP_OSC_MASTER_QRY
--------------------------------------------------------

Create Or Replace Package Body timecurr.pkg_rap_osc_master_qry As

    Function fn_po_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_action_id      Varchar2 Default Null,
        p_generic_search Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number

    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Char(5);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            Return Null;
        End If;

        If p_action_id = c_a233 Or p_action_id = c_a127 Then
            Open c For
                Select
                    *
                From
                    (
                        Select
                            rom.oscm_id                                     As oscm_id,
                            to_char(rom.oscm_date, 'dd-Mon-yyyy')           As oscm_date,
                            rom.projno5                                     As projno5,
                            rap_reports_gen.get_proj_name(rom.projno5)      As projno5_desc,
                            rom.oscm_vendor                                 As oscm_vendor,
                            s.description                                   As oscm_vendor_desc,
                            rom.oscm_type                                   As oscm_type,
                            rom.po_number                                   As po_number,
                            to_char(rom.po_date, 'dd-Mon-yyyy')             As po_date,
                            rom.po_amt                                      As po_amt,
                            rom.cur_po_amt                                  As cur_po_amt,
                            Case rom.lock_orig_budget
                                When 0 Then
                                    'Open'
                                Else
                                    'Locked'
                            End                                             As lock_orig_budget_desc,
                            Row_Number() Over (Order By rom.oscm_date Desc) row_number,
                            Count(*) Over ()                                total_row
                        From
                            rap_osc_master                      rom, subcontractmast s
                        Where
                            Trim(rom.oscm_vendor) = Trim(s.subcontract)
                            And (
                                upper(rom.projno5) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                upper(rap_reports_gen.get_proj_name(rom.projno5)) Like '%' || upper(Trim(p_generic_search)) ||
                                '%' Or
                                upper(rom.oscm_vendor) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                upper(s.description) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                upper(rom.oscm_type) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                upper(rom.po_number) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                upper(to_char(rom.po_date, 'dd-Mon-yyyy')) Like '%' || upper(Trim(p_generic_search)) || '%'
                                Or
                                upper(rom.po_amt) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                upper(Case rom.lock_orig_budget
                                          When 0 Then
                                              'Open'
                                          Else
                                              'Locked'
                                      End) Like '%' || upper(Trim(p_generic_search)) || '%'
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
                            rom.oscm_id                                     As oscm_id,
                            to_char(rom.oscm_date, 'dd-Mon-yyyy')           As oscm_date,
                            rom.projno5                                     As projno5,
                            rap_reports_gen.get_proj_name(rom.projno5)      As projno5_desc,
                            rom.oscm_vendor                                 As oscm_vendor,
                            s.description                                   As oscm_vendor_desc,
                            rom.oscm_type                                   As oscm_type,
                            rom.po_number                                   As po_number,
                            to_char(rom.po_date, 'dd-Mon-yyyy')             As po_date,
                            rom.po_amt                                      As po_amt,
                            rom.cur_po_amt                                  As cur_po_amt,
                            Case rom.lock_orig_budget
                                When 0 Then
                                    'Open'
                                Else
                                    'Locked'
                            End                                             As lock_orig_budget_desc,
                            Row_Number() Over (Order By rom.oscm_date Desc) row_number,
                            Count(*) Over ()                                total_row
                        From
                            rap_osc_master                      rom, subcontractmast s
                        Where
                            Trim(rom.oscm_vendor) = Trim(s.subcontract)
                            And (
                                upper(rom.projno5) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                upper(rap_reports_gen.get_proj_name(rom.projno5)) Like '%' || upper(Trim(p_generic_search)) ||
                                '%' Or
                                upper(rom.oscm_vendor) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                upper(s.description) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                upper(rom.oscm_type) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                upper(rom.po_number) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                upper(to_char(rom.po_date, 'dd-Mon-yyyy')) Like '%' || upper(Trim(p_generic_search)) || '%'
                                Or
                                upper(rom.po_amt) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                                upper(Case rom.lock_orig_budget
                                          When 0 Then
                                              'Open'
                                          Else
                                              'Locked'
                                      End) Like '%' || upper(Trim(p_generic_search)) || '%'
                            )
                            And rom.oscm_id In (
                                Select
                                    oscm_id
                                From
                                    rap_osc_detail
                                Where
                                    costcode In (
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

                    )
                Where
                    row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        End If;
        Return c;
    End fn_po_list;

    Procedure sp_po_details(
        p_person_id                 Varchar2,
        p_meta_id                   Varchar2,

        p_oscm_id                   Varchar2,
        p_oscm_date             Out Date,
        p_projno5               Out Varchar2,
        p_projno5_desc          Out Varchar2,
        p_oscm_vendor           Out Varchar2,
        p_oscm_vendor_desc      Out Varchar2,
        p_oscm_type             Out Varchar2,
        p_po_number             Out Varchar2,
        p_po_date               Out Date,
        p_po_amt                Out Number,
        p_cur_po_amt            Out Number,
        p_lock_orig_budget      Out Number,
        p_lock_orig_budget_desc Out Varchar2,
        p_orig_est_hours_total  Out Number,
        p_cur_est_hours_total   Out Number,
        p_ses_amount_total      Out Number,
        p_revcdate              Out Date,
        p_oscsw_id              Out Varchar2,
        p_scope_work_desc       Out Varchar2,
        p_actual_hours_booked_total Out Number,
        
        p_message_type          Out Varchar2,
        p_message_text          Out Varchar2
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
            rom.oscm_date,
            rom.projno5,
            rap_reports_gen.get_proj_name(rom.projno5),
            fn_get_proj_revcdate(p_person_id, p_meta_id, rom.projno5),
            rom.oscm_vendor,
            s.description,
            rom.oscm_type,
            rom.po_number,
            rom.po_date,
            rom.po_amt,
            rom.cur_po_amt,
            rom.lock_orig_budget,
            Case rom.lock_orig_budget
                When 0 Then
                    'Open'
                Else
                    'Locked'
            End,
            fn_po_orig_est_hours(p_person_id, p_meta_id, p_oscm_id),
            fn_po_cur_est_hours(p_person_id, p_meta_id, p_oscm_id),
            fn_po_ses_amount(p_person_id, p_meta_id, p_oscm_id),
            rom.oscsw_id,
            fn_get_scope_of_work(p_person_id, p_meta_id, rom.oscsw_id),
            pkg_rap_osc_actual_hrs_booked_qry.fn_actual_hrs_booked_sum(
                p_person_id => p_person_id,
                p_meta_id   => p_meta_id,
                p_oscm_id   => rom.oscm_id
                )
        Into
            p_oscm_date,
            p_projno5,
            p_projno5_desc,
            p_revcdate,
            p_oscm_vendor,
            p_oscm_vendor_desc,
            p_oscm_type,
            p_po_number,
            p_po_date,
            p_po_amt,
            p_cur_po_amt,
            p_lock_orig_budget,
            p_lock_orig_budget_desc,
            p_orig_est_hours_total,
            p_cur_est_hours_total,
            p_ses_amount_total,
            p_oscsw_id,
            p_scope_work_desc,
            p_actual_hours_booked_total
        From
            rap_osc_master                      rom, subcontractmast s
        Where
            rom.oscm_vendor = s.subcontract
            And
            oscm_id         = p_oscm_id;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_po_details;

    Function fn_po_orig_est_hours(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_oscm_id   Varchar2

    ) Return Number As
        v_orig_est_hrs Number;
    Begin
        Select
            Sum(orig_est_hrs)
        Into
            v_orig_est_hrs
        From
            rap_osc_master                     rom, rap_osc_detail rod, rap_osc_hours roh
        Where
            rom.oscm_id     = rod.oscm_id
            And rod.oscd_id = roh.oscd_id
            And rom.oscm_id = Trim(p_oscm_id);

        Return v_orig_est_hrs;

    End fn_po_orig_est_hours;

    Function fn_po_cur_est_hours(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_oscm_id   Varchar2

    ) Return Number As
        v_cur_est_hrs Number;
    Begin
        Select
            Sum(cur_est_hrs)
        Into
            v_cur_est_hrs
        From
            rap_osc_master                     rom, rap_osc_detail rod, rap_osc_hours roh
        Where
            rom.oscm_id     = rod.oscm_id
            And rod.oscd_id = roh.oscd_id
            And rom.oscm_id = Trim(p_oscm_id);

        Return v_cur_est_hrs;

    End fn_po_cur_est_hours;

    Function fn_po_ses_amount(
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

    End fn_po_ses_amount;

    Function fn_get_proj_revcdate(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_projno5   Varchar2

    ) Return Date As
        v_revcdate Date;
    Begin
        Select
            Max(revcdate)
        Into
            v_revcdate
        From
            projmast
        Where
            substr(projno, 1, 5) = Trim(p_projno5);

        Return v_revcdate;
    Exception
        When Others Then
            Return Null;

    End fn_get_proj_revcdate;

    Function fn_get_scope_of_work(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_oscsw_id  Varchar2

    ) Return Varchar2 As
        v_scope_work_desc rap_osc_scope_work_mst.scope_work_desc%type;
    Begin
        Select
            scope_work_desc
        Into
            v_scope_work_desc
        From
            rap_osc_scope_work_mst
        Where
            oscsw_id = Trim(p_oscsw_id);

        Return v_scope_work_desc;

    End fn_get_scope_of_work;

End pkg_rap_osc_master_qry;
/
Grant Execute On "TIMECURR"."PKG_RAP_OSC_MASTER_QRY" To "TCMPL_APP_CONFIG";