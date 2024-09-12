--------------------------------------------------------
--  DDL for Package Body IOT_LEAVE
--------------------------------------------------------

Create Or Replace Package Body "SELFSERVICE"."IOT_LEAVE" As

    ok         Constant Varchar2(2)  := 'OK';
    not_ok     Constant Varchar2(2)  := 'KO';

    c_pending  Constant Varchar2(30) := 'Pending';
    c_approved Constant Varchar2(30) := 'Approved';
    c_none     Constant Varchar2(30) := 'NONE';

    Function fn_sl_applied_last_12_months(
        p_empno Varchar2,
        p_date  Date
    ) Return Number As
        v_leaveperiod Number;
    Begin
        Select
            Sum(leaveperiod / 8)
        Into
            v_leaveperiod
        From
            ss_leaveapp
        Where
            empno                 = p_empno
            And bdate >= add_months(p_date, -12)
            And leavetype         = 'SL'
            And nvl(hrd_apprl, 0) = 0
            And nvl(hod_apprl, 0) <> -1
            And nvl(lead_apprl, 0) <> -1;
        Return v_leaveperiod;
    Exception
        When Others Then
            Return 0;
    End;

    Function fn_sl_in_last_12_months(
        p_empno Varchar2,
        p_date  Date
    ) Return Number As
        v_ret_val Number;
        v_empno   Varchar2(5);
    Begin
        v_ret_val := 0;
        Select
            Sum(leaveperiod * -1) / 8
        Into
            v_ret_val
        From
            ss_leaveledg
        Where
            empno         = p_empno
            And leavetype = 'SL'
            And adj_type In ('LA')
            And db_cr     = 'D'
            And bdate >= add_months(p_date, -12);
        Return v_ret_val;
    Exception
        When Others Then
            Return v_ret_val;
    End;

    Function fn_sl_applied_in_yyyy(
        p_empno Varchar2,
        p_date  Date
    ) Return Number As
        v_ret_val           Number;
        v_empno             Varchar2(5);
        v_tot_sl            Number;
        v_sl_sum            Number;
        v_first_day_of_yyyy Date;
        v_last_day_of_yyyy  Date;

    Begin

        v_first_day_of_yyyy := trunc(p_date, 'YYYY');
        v_last_day_of_yyyy  := (v_first_day_of_yyyy + Interval '1' Year) - 1;
        v_ret_val           := 0;

        Select
            Sum(leaveperiod) / 8
        Into
            v_sl_sum
        From
            ss_leaveapp
        Where
            empno                                  = p_empno
            And leavetype                          = 'SL'
            And nvl(hrd_apprl, 0)                  = 0
            And nvl(hod_apprl, 0) <> -1
            And nvl(lead_apprl, 0) <> -1
            And to_char(bdate, 'YYYY')             = to_char(v_first_day_of_yyyy, 'YYYY')
            And to_char(nvl(edate, bdate), 'YYYY') = to_char(v_first_day_of_yyyy, 'YYYY');

        v_tot_sl            := v_sl_sum;

        Select
            Sum(nvl(leaves, 0))
        Into
            v_sl_sum
        From
            (
                Select
                    Sum((edate + 1 - (v_first_day_of_yyyy)) - holidaysbetween(v_first_day_of_yyyy, edate)) As leaves
                From
                    ss_leaveapp
                Where
                    empno                 = p_empno
                    And leavetype         = 'SL'
                    And nvl(hrd_apprl, 0) = 0
                    And nvl(hod_apprl, 0) <> -1
                    And nvl(lead_apprl, 0) <> -1
                    And bdate < v_first_day_of_yyyy
                    And edate Between v_first_day_of_yyyy And v_last_day_of_yyyy

                Union All

                Select
                    Sum(((v_last_day_of_yyyy + 1) - bdate) - holidaysbetween(bdate, v_last_day_of_yyyy)) As leaves
                From
                    ss_leaveapp
                Where
                    empno                 = p_empno
                    And leavetype         = 'SL'
                    And nvl(hrd_apprl, 0) = 0
                    And nvl(hod_apprl, 0) <> -1
                    And nvl(lead_apprl, 0) <> -1
                    And edate > v_last_day_of_yyyy
                    And bdate Between v_first_day_of_yyyy And v_last_day_of_yyyy
            );
        v_tot_sl            := nvl(v_tot_sl, 0) + nvl(v_sl_sum, 0);

        Return v_tot_sl;
    Exception
        When Others Then
            Return v_ret_val;
    End;

    Function fn_sl_in_yyyy(
        p_empno Varchar2,
        p_date  Date
    ) Return Number As
        v_ret_val           Number;
        v_empno             Varchar2(5);
        v_tot_sl            Number;
        v_sl_sum            Number;
        v_first_day_of_yyyy Date;
        v_last_day_of_yyyy  Date;

    Begin

        v_first_day_of_yyyy := trunc(p_date, 'YYYY');
        v_last_day_of_yyyy  := (v_first_day_of_yyyy + Interval '1' Year) - 1;
        v_ret_val           := 0;

        Select
            Sum(leaveperiod * -1) / 8
        Into
            v_sl_sum
        From
            ss_leaveledg
        Where
            empno                                  = p_empno
            And leavetype                          = 'SL'
            And adj_type In ('LA')
            And db_cr                              = 'D'
            And to_char(bdate, 'YYYY')             = to_char(v_first_day_of_yyyy, 'YYYY')
            And to_char(nvl(edate, bdate), 'YYYY') = to_char(v_first_day_of_yyyy, 'YYYY');

        v_tot_sl            := v_sl_sum;

        Select
            Sum(nvl(leaves, 0))
        Into
            v_sl_sum
        From
            (
                Select
                    Sum((edate + 1 - (v_first_day_of_yyyy)) - holidaysbetween(v_first_day_of_yyyy, edate)) As leaves
                From
                    ss_leaveledg
                Where
                    empno         = p_empno
                    And leavetype = 'SL'
                    And adj_type In ('LA')
                    And db_cr     = 'D'
                    And bdate < v_first_day_of_yyyy
                    And edate Between v_first_day_of_yyyy And v_last_day_of_yyyy
                Union All

                Select
                    Sum(((v_last_day_of_yyyy + 1) - bdate) - holidaysbetween(bdate, v_last_day_of_yyyy)) As leaves
                From
                    ss_leaveledg
                Where
                    empno         = p_empno
                    And leavetype = 'SL'
                    And adj_type In ('LA')
                    And db_cr     = 'D'
                    And edate > v_last_day_of_yyyy
                    And bdate Between v_first_day_of_yyyy And v_last_day_of_yyyy
            );
        v_tot_sl            := nvl(v_tot_sl, 0) + nvl(v_sl_sum, 0);

        Return v_tot_sl;
    Exception
        When Others Then
            Return v_ret_val;
    End;

    Procedure sp_process_disapproved_app(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_application_id Varchar2
    ) As
        v_medical_cert_file Varchar2(100);
        v_msg_type          Varchar2(15);
        v_msg_text          Varchar2(1000);
    Begin
        Insert Into ss_leaveapp_rejected (
            app_no,
            empno,
            app_date,
            rep_to,
            projno,
            caretaker,
            leaveperiod,
            leavetype,
            bdate,
            edate,
            reason,
            mcert,
            work_ldate,
            resm_date,
            contact_add,
            contact_phn,
            contact_std,
            last_hrs,
            last_mn,
            resm_hrs,
            resm_mn,
            dataentryby,
            office,
            hod_apprl,
            hod_apprl_dt,
            hod_code,
            hrd_apprl,
            hrd_apprl_dt,
            hrd_code,
            discrepancy,
            user_tcp_ip,
            hod_tcp_ip,
            hrd_tcp_ip,
            hodreason,
            hrdreason,
            hd_date,
            hd_part,
            lead_apprl,
            lead_apprl_dt,
            lead_code,
            lead_tcp_ip,
            lead_apprl_empno,
            lead_reason,
            rejected_on,
            is_covid_sick_leave,
            med_cert_file_name
        )
        Select
            app_no,
            empno,
            app_date,
            rep_to,
            projno,
            caretaker,
            leaveperiod,
            leavetype,
            bdate,
            edate,
            reason,
            mcert,
            work_ldate,
            resm_date,
            contact_add,
            contact_phn,
            contact_std,
            last_hrs,
            last_mn,
            resm_hrs,
            resm_mn,
            dataentryby,
            office,
            hod_apprl,
            hod_apprl_dt,
            hod_code,
            hrd_apprl,
            hrd_apprl_dt,
            hrd_code,
            discrepancy,
            user_tcp_ip,
            hod_tcp_ip,
            hrd_tcp_ip,
            hodreason,
            hrdreason,
            hd_date,
            hd_part,
            lead_apprl,
            lead_apprl_dt,
            lead_code,
            lead_tcp_ip,
            lead_apprl_empno,
            lead_reason,
            sysdate,
            is_covid_sick_leave,
            med_cert_file_name
        From
            ss_leaveapp
        Where
            Trim(app_no) = p_application_id;
        Commit;
        sp_delete_leave_app(
            p_person_id              => p_person_id,
            p_meta_id                => p_meta_id,

            p_application_id         => Trim(p_application_id),

            p_medical_cert_file_name => v_medical_cert_file,
            p_message_type           => v_msg_type,
            p_message_text           => v_msg_text
        );

        ss_mail.send_mail_leave_reject_async(
            p_app_id => p_application_id
        );

    End;

    Procedure get_leave_balance_all(
        p_empno            Varchar2,
        p_pdate            Date Default Null,
        p_open_close_flag  Number,

        p_cl           Out Varchar2,
        p_sl           Out Varchar2,
        p_pl           Out Varchar2,
        p_ex           Out Varchar2,
        p_co           Out Varchar2,
        p_oh           Out Varchar2,
        p_lv           Out Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As

        v_cl  Number;
        v_sl  Number;
        v_pl  Number;
        v_ex  Number;
        v_co  Number;
        v_oh  Number;
        v_lv  Number;
        v_tot Number;
    Begin
        get_leave_balance(
            param_empno       => p_empno,
            param_date        => p_pdate,
            param_open_close  => p_open_close_flag,
            param_leave_type  => 'LV',
            param_leave_count => v_lv
        );

        openbal(
            v_empno       => p_empno,
            v_opbaldtfrom => p_pdate,
            v_openbal     => p_open_close_flag,
            v_cl          => v_cl,
            v_pl          => v_pl,
            v_sl          => v_sl,
            v_ex          => v_ex,
            v_co          => v_co,
            v_oh          => v_oh,
            v_tot         => v_tot
        );

        p_cl := to_days(v_cl);
        p_pl := to_days(v_pl);
        p_sl := to_days(v_sl);
        p_ex := to_days(v_ex);
        p_co := to_days(v_co);
        p_oh := to_days(v_oh);
        p_lv := to_days(v_lv);

        p_cl := nvl(trim(p_cl), '0.0');
        p_pl := nvl(trim(p_pl), '0.0');
        p_sl := nvl(trim(p_sl), '0.0');
        p_ex := nvl(trim(p_ex), '0.0');
        p_co := nvl(trim(p_co), '0.0');
        p_oh := nvl(trim(p_oh), '0.0');
        p_lv := nvl(trim(p_lv), '0.0');

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure get_leave_details_from_app(
        p_application_id         Varchar2,

        p_empno              Out Varchar2,
        p_emp_name           Out Varchar2,
        p_leave_type         Out Varchar2,
        p_application_date   Out Varchar2,
        p_start_date         Out Varchar2,
        p_end_date           Out Varchar2,

        p_leave_period       Out Number,
        p_last_reporting     Out Varchar2,
        p_resuming           Out Varchar2,

        p_projno             Out Varchar2,
        p_care_taker         Out Varchar2,
        p_reason             Out Varchar2,
        p_med_cert_available Out Varchar2,
        p_contact_address    Out Varchar2,
        p_contact_std        Out Varchar2,
        p_contact_phone      Out Varchar2,
        p_office             Out Varchar2,
        p_lead_name          Out Varchar2,
        p_discrepancy        Out Varchar2,
        p_med_cert_file_nm   Out Varchar2,

        p_lead_approval      Out Varchar2,
        p_hod_approval       Out Varchar2,
        p_hr_approval        Out Varchar2,

        p_lead_reason        Out Varchar2,
        p_hod_reason         Out Varchar2,
        p_hr_reason          Out Varchar2,

        p_flag_can_del       Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    ) As
        v_leave_app ss_vu_leaveapp%rowtype;
    Begin
        Select
            *
        Into
            v_leave_app
        From
            ss_vu_leaveapp
        Where
            Trim(app_no) = Trim(p_application_id);

        p_empno              := v_leave_app.empno;
        p_emp_name           := get_emp_name(v_leave_app.empno);
        p_leave_type         := v_leave_app.leavetype;
        p_application_date   := to_char(v_leave_app.app_date, 'dd-Mon-yyyy');
        p_start_date         := to_char(v_leave_app.bdate, 'dd-Mon-yyyy');
        p_end_date           := to_char(v_leave_app.edate, 'dd-Mon-yyyy');

        p_leave_period       := to_days(v_leave_app.leaveperiod);
        p_last_reporting     := to_char(v_leave_app.work_ldate, 'dd-Mon-yyyy');
        p_resuming           := to_char(v_leave_app.resm_date, 'dd-Mon-yyyy');

        p_projno             := v_leave_app.projno;
        p_care_taker         := v_leave_app.caretaker;
        p_reason             := v_leave_app.reason;
        p_med_cert_available := v_leave_app.mcert;
        p_contact_address    := v_leave_app.contact_add;
        p_contact_std        := v_leave_app.contact_std;
        p_contact_phone      := v_leave_app.contact_phn;
        p_office             := v_leave_app.office;
        p_lead_name          := get_emp_name(v_leave_app.lead_code);
        p_discrepancy        := v_leave_app.discrepancy;
        p_med_cert_file_nm   := v_leave_app.med_cert_file_name;

        If nvl(v_leave_app.lead_apprl, 0) != 0 Or nvl(v_leave_app.hod_apprl, 0) != 0 Or nvl(v_leave_app.hrd_apprl, 0) != 0
        Then
            p_flag_can_del := 'KO';
        Else
            p_flag_can_del := 'OK';
        End If;

        p_lead_approval      := ss.approval_text(v_leave_app.lead_apprl);
        p_hod_approval       := Case
                                    When v_leave_app.lead_apprl = ss.disapproved Then
                                        '-'
                                    Else
                                        ss.approval_text(v_leave_app.hod_apprl)
                                End;
        p_hr_approval        := Case
                                    When v_leave_app.hod_apprl = ss.disapproved Then
                                        '-'
                                    Else
                                        ss.approval_text(v_leave_app.hrd_apprl)
                                End;
        p_lead_reason        := v_leave_app.lead_reason;
        p_hod_reason         := v_leave_app.hodreason;
        p_hr_reason          := v_leave_app.hrdreason;

        p_message_text       := 'OK';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure get_leave_details_from_adj(
        p_application_id       Varchar2,

        p_emp_name         Out Varchar2,
        p_leave_type       Out Varchar2,
        p_application_date Out Varchar2,
        p_start_date       Out Varchar2,
        p_end_date         Out Varchar2,

        p_leave_period     Out Number,
        p_med_cert_file_nm Out Varchar2,

        p_reason           Out Varchar2,

        p_lead_approval    Out Varchar2,
        p_hod_approval     Out Varchar2,
        p_hr_approval      Out Varchar2,

        p_message_type     Out Varchar2,
        p_message_text     Out Varchar2
    ) As
        v_leave_adj ss_leave_adj%rowtype;
    Begin
        Select
            *
        Into
            v_leave_adj
        From
            ss_leave_adj
        Where
            adj_no = p_application_id;
        p_emp_name         := get_emp_name(v_leave_adj.empno);
        p_leave_type       := v_leave_adj.leavetype;
        p_application_date := to_char(v_leave_adj.adj_dt, 'dd-Mon-yyyy');
        p_start_date       := to_char(v_leave_adj.bdate, 'dd-Mon-yyyy');
        p_end_date         := to_char(v_leave_adj.edate, 'dd-Mon-yyyy');
        p_med_cert_file_nm := v_leave_adj.med_cert_file_name;

        p_leave_period     := to_days(v_leave_adj.leaveperiod);
        p_reason           := v_leave_adj.description;
        p_message_text     := 'OK';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_validate_new_leave(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_leave_type         Varchar2,
        p_start_date         Date,
        p_end_date           Date,
        p_half_day_on        Number,

        p_leave_period   Out Number,
        p_last_reporting Out Varchar2,
        p_resuming       Out Varchar2,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2

    ) As
        v_empno        Varchar2(5);
        v_message_type Varchar2(2);
        v_count        Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee by person id';
            Return;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno = v_empno;
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        leave.validate_leave(
            param_empno          => v_empno,
            param_leave_type     => p_leave_type,
            param_bdate          => trunc(p_start_date),
            param_edate          => trunc(p_end_date),
            param_half_day_on    => p_half_day_on,
            param_app_no         => Null,
            param_leave_period   => p_leave_period,
            param_last_reporting => p_last_reporting,
            param_resuming       => p_resuming,
            param_msg_type       => v_message_type,
            param_msg            => p_message_text
        );
        If v_message_type = ss.failure Then
            p_message_type := 'KO';
        Else
            p_message_type := 'OK';
        End If;
    Exception
        When Others Then
            p_message_type := ss.failure;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_validate_new_leave;

    Procedure sp_validate_pl_revision(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_application_id     Varchar2,
        p_leave_type         Varchar2,
        p_start_date         Date,
        p_end_date           Date,
        p_half_day_on        Number,

        p_leave_period   Out Number,
        p_last_reporting Out Varchar2,
        p_resuming       Out Varchar2,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2

    ) As
        v_empno        Varchar2(5);
        v_message_type Varchar2(2);
        v_count        Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee by metaid';
            Return;
        End If;

        leave.validate_leave(
            param_empno          => v_empno,
            param_leave_type     => p_leave_type,
            param_bdate          => trunc(p_start_date),
            param_edate          => trunc(p_end_date),
            param_half_day_on    => p_half_day_on,
            param_app_no         => p_application_id,
            param_leave_period   => p_leave_period,
            param_last_reporting => p_last_reporting,
            param_resuming       => p_resuming,
            param_msg_type       => v_message_type,
            param_msg            => p_message_text
        );
        If v_message_type = ss.failure Then
            p_message_type := 'KO';
        Else
            p_message_type := 'OK';
        End If;
    Exception
        When Others Then
            p_message_type := ss.failure;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_validate_pl_revision;

    Procedure sp_add_leave_application(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_leave_type             Varchar2,
        p_start_date             Date,
        p_end_date               Date,
        p_half_day_on            Number,
        p_projno                 Varchar2,
        p_care_taker             Varchar2,
        p_reason                 Varchar2,
        p_med_cert_available     Varchar2 Default Null,
        p_contact_address        Varchar2 Default Null,
        p_contact_std            Varchar2 Default Null,
        p_contact_phone          Varchar2 Default Null,
        p_office                 Varchar2,
        p_lead_empno             Varchar2,
        p_discrepancy            Varchar2 Default Null,
        p_med_cert_file_nm       Varchar2 Default Null,

        p_new_application_id Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    ) As

        v_empno        Varchar2(5);
        v_message_type Varchar2(2);
        v_count        Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee by person id';
            Return;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno = v_empno;
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        leave.add_leave_app(
            param_empno            => v_empno,
            param_leave_type       => p_leave_type,
            param_bdate            => p_start_date,
            param_edate            => p_end_date,
            param_half_day_on      => p_half_day_on,
            param_projno           => p_projno,
            param_caretaker        => p_care_taker,
            param_reason           => p_reason,
            param_cert             => p_med_cert_available,
            param_contact_add      => p_contact_address,
            param_contact_std      => p_contact_std,
            param_contact_phn      => p_contact_phone,
            param_office           => p_office,
            param_dataentryby      => v_empno,
            param_lead_empno       => p_lead_empno,
            param_discrepancy      => p_discrepancy,
            param_med_cert_file_nm => p_med_cert_file_nm,
            param_tcp_ip           => Null,
            param_nu_app_no        => p_new_application_id,
            param_msg_type         => v_message_type,
            param_msg              => p_message_text
        );

        If v_message_type = ss.failure Then
            p_message_type := 'KO';
        Else
            p_message_type := 'OK';
        End If;

    End;

    Procedure sp_pl_revision_save(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_application_id         Varchar2,
        p_start_date             Date,
        p_end_date               Date,
        p_half_day_on            Number,
        p_lead_empno             Varchar2,
        p_new_application_id Out Varchar2,
        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    ) As

        v_empno        Varchar2(5);
        v_message_type Varchar2(2);
        v_count        Number;
    Begin
        --v_message_type := '1234';
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee by person id';
            Return;
        End If;

        leave.save_pl_revision(
            param_empno       => v_empno,
            param_app_no      => p_application_id,
            param_bdate       => p_start_date,
            param_edate       => p_end_date,
            param_half_day_on => p_half_day_on,
            param_dataentryby => v_empno,
            param_lead_empno  => p_lead_empno,
            param_discrepancy => Null,
            param_tcp_ip      => Null,
            param_nu_app_no   => p_new_application_id,
            param_msg_type    => v_message_type,
            param_msg         => p_message_text
        );

        If v_message_type = ss.failure Then
            p_message_type := 'KO';
        Else
            p_message_type := 'OK';
        End If;

    End;

    Procedure sp_leave_details(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_application_id         Varchar2,

        p_empno              Out Varchar2,
        p_emp_name           Out Varchar2,
        p_leave_type         Out Varchar2,
        p_application_date   Out Varchar2,
        p_start_date         Out Varchar2,
        p_end_date           Out Varchar2,

        p_leave_period       Out Number,
        p_last_reporting     Out Varchar2,
        p_resuming           Out Varchar2,

        p_projno             Out Varchar2,
        p_care_taker         Out Varchar2,
        p_reason             Out Varchar2,
        p_med_cert_available Out Varchar2,
        p_contact_address    Out Varchar2,
        p_contact_std        Out Varchar2,
        p_contact_phone      Out Varchar2,
        p_office             Out Varchar2,
        p_lead_name          Out Varchar2,
        p_discrepancy        Out Varchar2,
        p_med_cert_file_nm   Out Varchar2,

        p_lead_approval      Out Varchar2,
        p_hod_approval       Out Varchar2,
        p_hr_approval        Out Varchar2,

        p_lead_reason        Out Varchar2,
        p_hod_reason         Out Varchar2,
        p_hr_reason          Out Varchar2,

        p_flag_is_adj        Out Varchar2,
        p_flag_can_del       Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    ) As
        v_count Number;
    Begin

        Select
            Count(*)
        Into
            v_count
        From
            ss_vu_leaveapp
        Where
            Trim(app_no) = Trim(p_application_id);
        If v_count = 1 Then
            get_leave_details_from_app(
                p_application_id     => p_application_id,

                p_empno              => p_empno,
                p_emp_name           => p_emp_name,
                p_leave_type         => p_leave_type,
                p_application_date   => p_application_date,
                p_start_date         => p_start_date,
                p_end_date           => p_end_date,

                p_leave_period       => p_leave_period,
                p_last_reporting     => p_last_reporting,
                p_resuming           => p_resuming,

                p_projno             => p_projno,
                p_care_taker         => p_care_taker,
                p_reason             => p_reason,
                p_med_cert_available => p_med_cert_available,
                p_contact_address    => p_contact_address,
                p_contact_std        => p_contact_std,
                p_contact_phone      => p_contact_phone,
                p_office             => p_office,
                p_lead_name          => p_lead_name,
                p_discrepancy        => p_discrepancy,
                p_med_cert_file_nm   => p_med_cert_file_nm,

                p_lead_approval      => p_lead_approval,
                p_hod_approval       => p_hod_approval,
                p_hr_approval        => p_hr_approval,

                p_lead_reason        => p_lead_reason,
                p_hod_reason         => p_hod_reason,
                p_hr_reason          => p_hr_reason,

                p_flag_can_del       => p_flag_can_del,

                p_message_type       => p_message_type,
                p_message_text       => p_message_text
            );
            p_flag_is_adj := 'KO';
        Else
            get_leave_details_from_adj(
                p_application_id   => p_application_id,

                p_emp_name         => p_emp_name,
                p_leave_type       => p_leave_type,
                p_application_date => p_application_date,
                p_start_date       => p_start_date,
                p_end_date         => p_end_date,

                p_leave_period     => p_leave_period,
                p_med_cert_file_nm => p_med_cert_file_nm,

                p_reason           => p_reason,

                p_lead_approval    => p_lead_approval,
                p_hod_approval     => p_hod_approval,
                p_hr_approval      => p_hr_approval,

                p_message_type     => p_message_type,
                p_message_text     => p_message_text
            );
            p_flag_is_adj  := 'OK';
            p_flag_can_del := 'KO';
        End If;
    Exception
    When no_data_found then
            p_message_type := not_ok;
            p_message_text := 'Err - No data exists.';
    
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_lead_sl_leave_details(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_application_id         Varchar2,

        p_empno              Out Varchar2,
        p_emp_name           Out Varchar2,
        p_leave_type         Out Varchar2,
        p_application_date   Out Varchar2,
        p_start_date         Out Varchar2,
        p_end_date           Out Varchar2,

        p_leave_period       Out Number,
        p_last_reporting     Out Varchar2,
        p_resuming           Out Varchar2,

        p_projno             Out Varchar2,
        p_care_taker         Out Varchar2,
        p_reason             Out Varchar2,
        p_med_cert_available Out Varchar2,
        p_contact_address    Out Varchar2,
        p_contact_std        Out Varchar2,
        p_contact_phone      Out Varchar2,
        p_office             Out Varchar2,
        p_lead_name          Out Varchar2,
        p_discrepancy        Out Varchar2,
        p_med_cert_file_nm   Out Varchar2,

        p_lead_approval      Out Varchar2,
        p_hod_approval       Out Varchar2,
        p_hr_approval        Out Varchar2,

        p_lead_reason        Out Varchar2,
        p_hod_reason         Out Varchar2,
        p_hr_reason          Out Varchar2,

        p_sl_availed         Out Number,
        p_sl_applied         Out Number,

        p_flag_is_adj        Out Varchar2,
        p_flag_can_del       Out Varchar2,

        p_flag_can_approve   Out Varchar2,
        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2
    ) As
    Begin
        iot_leave.sp_leave_details(
            p_person_id          => p_person_id,
            p_meta_id            => p_meta_id,
            p_application_id     => p_application_id,
            p_empno              => p_empno,
            p_emp_name           => p_emp_name,
            p_leave_type         => p_leave_type,
            p_application_date   => p_application_date,
            p_start_date         => p_start_date,
            p_end_date           => p_end_date,
            p_leave_period       => p_leave_period,
            p_last_reporting     => p_last_reporting,
            p_resuming           => p_resuming,
            p_projno             => p_projno,
            p_care_taker         => p_care_taker,
            p_reason             => p_reason,
            p_med_cert_available => p_med_cert_available,
            p_contact_address    => p_contact_address,
            p_contact_std        => p_contact_std,
            p_contact_phone      => p_contact_phone,
            p_office             => p_office,
            p_lead_name          => p_lead_name,
            p_discrepancy        => p_discrepancy,
            p_med_cert_file_nm   => p_med_cert_file_nm,
            p_lead_approval      => p_lead_approval,
            p_hod_approval       => p_hod_approval,
            p_hr_approval        => p_hr_approval,
            p_lead_reason        => p_lead_reason,
            p_hod_reason         => p_hod_reason,
            p_hr_reason          => p_hr_reason,
            p_flag_is_adj        => p_flag_is_adj,
            p_flag_can_del       => p_flag_can_del,
            p_message_type       => p_message_type,
            p_message_text       => p_message_text);
        /*
                p_sl_availed := fn_sl_in_last_12_months(p_empno, p_start_date);
                p_sl_applied := fn_sl_applied_last_12_months(p_empno, p_start_date);
        */
        p_sl_availed := fn_sl_in_yyyy(p_empno, nvl(p_end_date, p_start_date));
        p_sl_applied := fn_sl_applied_in_yyyy(p_empno, nvl(p_end_date, p_start_date));

        If nvl(p_lead_approval, c_pending) = c_pending Then
            p_flag_can_approve := ok;
        Else
            p_flag_can_approve := not_ok;
        End If;

    End;

    Procedure sp_hod_sl_leave_details(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_application_id         Varchar2,

        p_empno              Out Varchar2,
        p_emp_name           Out Varchar2,
        p_leave_type         Out Varchar2,
        p_application_date   Out Varchar2,
        p_start_date         Out Varchar2,
        p_end_date           Out Varchar2,

        p_leave_period       Out Number,
        p_last_reporting     Out Varchar2,
        p_resuming           Out Varchar2,

        p_projno             Out Varchar2,
        p_care_taker         Out Varchar2,
        p_reason             Out Varchar2,
        p_med_cert_available Out Varchar2,
        p_contact_address    Out Varchar2,
        p_contact_std        Out Varchar2,
        p_contact_phone      Out Varchar2,
        p_office             Out Varchar2,
        p_lead_name          Out Varchar2,
        p_discrepancy        Out Varchar2,
        p_med_cert_file_nm   Out Varchar2,

        p_lead_approval      Out Varchar2,
        p_hod_approval       Out Varchar2,
        p_hr_approval        Out Varchar2,

        p_lead_reason        Out Varchar2,
        p_hod_reason         Out Varchar2,
        p_hr_reason          Out Varchar2,
        p_sl_availed         Out Number,
        p_sl_applied         Out Number,

        p_flag_is_adj        Out Varchar2,
        p_flag_can_del       Out Varchar2,

        p_flag_can_approve   Out Varchar2,
        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2
    ) As
    Begin
        iot_leave.sp_leave_details(
            p_person_id          => p_person_id,
            p_meta_id            => p_meta_id,
            p_application_id     => p_application_id,
            p_empno              => p_empno,
            p_emp_name           => p_emp_name,
            p_leave_type         => p_leave_type,
            p_application_date   => p_application_date,
            p_start_date         => p_start_date,
            p_end_date           => p_end_date,
            p_leave_period       => p_leave_period,
            p_last_reporting     => p_last_reporting,
            p_resuming           => p_resuming,
            p_projno             => p_projno,
            p_care_taker         => p_care_taker,
            p_reason             => p_reason,
            p_med_cert_available => p_med_cert_available,
            p_contact_address    => p_contact_address,
            p_contact_std        => p_contact_std,
            p_contact_phone      => p_contact_phone,
            p_office             => p_office,
            p_lead_name          => p_lead_name,
            p_discrepancy        => p_discrepancy,
            p_med_cert_file_nm   => p_med_cert_file_nm,
            p_lead_approval      => p_lead_approval,
            p_hod_approval       => p_hod_approval,
            p_hr_approval        => p_hr_approval,
            p_lead_reason        => p_lead_reason,
            p_hod_reason         => p_hod_reason,
            p_hr_reason          => p_hr_reason,
            p_flag_is_adj        => p_flag_is_adj,
            p_flag_can_del       => p_flag_can_del,
            p_message_type       => p_message_type,
            p_message_text       => p_message_text
        );
        /*
                p_sl_availed := fn_sl_in_yyyy(p_empno, p_end_date);
                p_sl_applied := fn_sl_applied_last_12_months(p_empno, p_start_date);
        */
        p_sl_availed := fn_sl_in_yyyy(p_empno, nvl(p_end_date, p_start_date));
        p_sl_applied := fn_sl_applied_in_yyyy(p_empno, nvl(p_end_date, p_start_date));

        If nvl(p_hod_approval, c_pending) = c_pending And nvl(p_lead_approval, c_pending) In (c_none, c_approved) Then
            p_flag_can_approve := ok;
        Else
            p_flag_can_approve := not_ok;
        End If;
    End;

    Procedure sp_onbehalf_sl_leave_details(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_application_id         Varchar2,

        p_empno              Out Varchar2,
        p_emp_name           Out Varchar2,
        p_leave_type         Out Varchar2,
        p_application_date   Out Varchar2,
        p_start_date         Out Varchar2,
        p_end_date           Out Varchar2,

        p_leave_period       Out Number,
        p_last_reporting     Out Varchar2,
        p_resuming           Out Varchar2,

        p_projno             Out Varchar2,
        p_care_taker         Out Varchar2,
        p_reason             Out Varchar2,
        p_med_cert_available Out Varchar2,
        p_contact_address    Out Varchar2,
        p_contact_std        Out Varchar2,
        p_contact_phone      Out Varchar2,
        p_office             Out Varchar2,
        p_lead_name          Out Varchar2,
        p_discrepancy        Out Varchar2,
        p_med_cert_file_nm   Out Varchar2,

        p_lead_approval      Out Varchar2,
        p_hod_approval       Out Varchar2,
        p_hr_approval        Out Varchar2,

        p_lead_reason        Out Varchar2,
        p_hod_reason         Out Varchar2,
        p_hr_reason          Out Varchar2,
        p_sl_availed         Out Number,
        p_sl_applied         Out Number,

        p_flag_is_adj        Out Varchar2,
        p_flag_can_del       Out Varchar2,

        p_flag_can_approve   Out Varchar2,
        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2
    ) As
    Begin
        iot_leave.sp_leave_details(
            p_person_id          => p_person_id,
            p_meta_id            => p_meta_id,
            p_application_id     => p_application_id,
            p_empno              => p_empno,
            p_emp_name           => p_emp_name,
            p_leave_type         => p_leave_type,
            p_application_date   => p_application_date,
            p_start_date         => p_start_date,
            p_end_date           => p_end_date,
            p_leave_period       => p_leave_period,
            p_last_reporting     => p_last_reporting,
            p_resuming           => p_resuming,
            p_projno             => p_projno,
            p_care_taker         => p_care_taker,
            p_reason             => p_reason,
            p_med_cert_available => p_med_cert_available,
            p_contact_address    => p_contact_address,
            p_contact_std        => p_contact_std,
            p_contact_phone      => p_contact_phone,
            p_office             => p_office,
            p_lead_name          => p_lead_name,
            p_discrepancy        => p_discrepancy,
            p_med_cert_file_nm   => p_med_cert_file_nm,
            p_lead_approval      => p_lead_approval,
            p_hod_approval       => p_hod_approval,
            p_hr_approval        => p_hr_approval,
            p_lead_reason        => p_lead_reason,
            p_hod_reason         => p_hod_reason,
            p_hr_reason          => p_hr_reason,
            p_flag_is_adj        => p_flag_is_adj,
            p_flag_can_del       => p_flag_can_del,
            p_message_type       => p_message_type,
            p_message_text       => p_message_text);
        /*
                p_sl_availed := fn_sl_in_last_12_months(p_empno, p_start_date);
                p_sl_applied := fn_sl_applied_last_12_months(p_empno, p_start_date);
        */

        p_sl_availed := fn_sl_in_yyyy(p_empno, nvl(p_end_date, p_start_date));
        p_sl_applied := fn_sl_applied_in_yyyy(p_empno, nvl(p_end_date, p_start_date));

        If nvl(p_hod_approval, c_pending) = c_pending And nvl(p_lead_approval, c_pending) In (c_none, c_approved) Then
            p_flag_can_approve := ok;
        Else
            p_flag_can_approve := not_ok;
        End If;
    End;

    Procedure sp_hr_sl_leave_details(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_application_id         Varchar2,

        p_empno              Out Varchar2,
        p_emp_name           Out Varchar2,
        p_leave_type         Out Varchar2,
        p_application_date   Out Varchar2,
        p_start_date         Out Varchar2,
        p_end_date           Out Varchar2,

        p_leave_period       Out Number,
        p_last_reporting     Out Varchar2,
        p_resuming           Out Varchar2,

        p_projno             Out Varchar2,
        p_care_taker         Out Varchar2,
        p_reason             Out Varchar2,
        p_med_cert_available Out Varchar2,
        p_contact_address    Out Varchar2,
        p_contact_std        Out Varchar2,
        p_contact_phone      Out Varchar2,
        p_office             Out Varchar2,
        p_lead_name          Out Varchar2,
        p_discrepancy        Out Varchar2,
        p_med_cert_file_nm   Out Varchar2,

        p_lead_approval      Out Varchar2,
        p_hod_approval       Out Varchar2,
        p_hr_approval        Out Varchar2,

        p_lead_reason        Out Varchar2,
        p_hod_reason         Out Varchar2,
        p_hr_reason          Out Varchar2,
        p_sl_availed         Out Number,
        p_sl_applied         Out Number,

        p_flag_is_adj        Out Varchar2,
        p_flag_can_del       Out Varchar2,

        p_flag_can_approve   Out Varchar2,
        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2
    ) As
    Begin
        iot_leave.sp_leave_details(
            p_person_id          => p_person_id,
            p_meta_id            => p_meta_id,
            p_application_id     => p_application_id,
            p_empno              => p_empno,
            p_emp_name           => p_emp_name,
            p_leave_type         => p_leave_type,
            p_application_date   => p_application_date,
            p_start_date         => p_start_date,
            p_end_date           => p_end_date,
            p_leave_period       => p_leave_period,
            p_last_reporting     => p_last_reporting,
            p_resuming           => p_resuming,
            p_projno             => p_projno,
            p_care_taker         => p_care_taker,
            p_reason             => p_reason,
            p_med_cert_available => p_med_cert_available,
            p_contact_address    => p_contact_address,
            p_contact_std        => p_contact_std,
            p_contact_phone      => p_contact_phone,
            p_office             => p_office,
            p_lead_name          => p_lead_name,
            p_discrepancy        => p_discrepancy,
            p_med_cert_file_nm   => p_med_cert_file_nm,
            p_lead_approval      => p_lead_approval,
            p_hod_approval       => p_hod_approval,
            p_hr_approval        => p_hr_approval,
            p_lead_reason        => p_lead_reason,
            p_hod_reason         => p_hod_reason,
            p_hr_reason          => p_hr_reason,
            p_flag_is_adj        => p_flag_is_adj,
            p_flag_can_del       => p_flag_can_del,
            p_message_type       => p_message_type,
            p_message_text       => p_message_text
        );
        /*
                p_sl_availed := fn_sl_in_last_12_months(p_empno, p_start_date);
                p_sl_applied := fn_sl_applied_last_12_months(p_empno, p_start_date);
        */
        p_sl_availed := fn_sl_in_yyyy(p_empno, nvl(p_end_date, p_start_date));
        p_sl_applied := fn_sl_applied_in_yyyy(p_empno, nvl(p_end_date, p_start_date));

        If nvl(p_hr_approval, c_pending) = c_pending And nvl(p_hod_approval, c_pending) = c_approved Then
            p_flag_can_approve := ok;
        Else
            p_flag_can_approve := not_ok;
        End If;
    End;

    Procedure sp_delete_leave_app(
        p_person_id                  Varchar2,
        p_meta_id                    Varchar2,

        p_application_id             Varchar2,

        p_medical_cert_file_name Out Varchar2,
        p_message_type           Out Varchar2,
        p_message_text           Out Varchar2
    ) As
        v_count      Number;
        v_empno      Varchar2(5);
        rec_leaveapp ss_leaveapp%rowtype;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ss_leaveapp
        Where
            Trim(app_no) = Trim(p_application_id);
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid application id';
            Return;
        End If;
        Select
            med_cert_file_name
        Into
            p_medical_cert_file_name
        From
            ss_leaveapp
        Where
            Trim(app_no) = Trim(p_application_id);

        deleteleave(trim(p_application_id));

        p_message_type := 'OK';
        p_message_text := 'Application deleted successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_delete_leave_app_force(
        p_person_id                  Varchar2,
        p_meta_id                    Varchar2,

        p_application_id             Varchar2,

        p_medical_cert_file_name Out Varchar2,
        p_message_type           Out Varchar2,
        p_message_text           Out Varchar2
    ) As
        v_count      Number;
        v_empno      Varchar2(5);
        rec_leaveapp ss_leaveapp%rowtype;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ss_vu_leaveapp
        Where
            Trim(app_no) = Trim(p_application_id);
        If v_count = 1 Then
            Select
                med_cert_file_name
            Into
                p_medical_cert_file_name
            From
                ss_vu_leaveapp
            Where
                Trim(app_no) = Trim(p_application_id);
        End If;
        If v_count = 0 Then
            Select
                Count(*)
            Into
                v_count
            From
                ss_leave_adj
            Where
                adj_no = Trim(p_application_id);
            If v_count = 1 Then
                Select
                    med_cert_file_name
                Into
                    p_medical_cert_file_name
                From
                    ss_leave_adj
                Where
                    Trim(adj_no) = Trim(p_application_id);
            End If;
        End If;

        deleteleave(
            appnum      => p_application_id,
            p_force_del => 'OK'
        );

        p_message_type := 'OK';
        p_message_text := 'Application deleted successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_delete_leave_app_force;

    Procedure sp_leave_balances(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2 Default Null,
        p_start_date       Date     Default Null,
        p_end_date         Date     Default Null,

        p_open_cl      Out Varchar2,
        p_open_sl      Out Varchar2,
        p_open_pl      Out Varchar2,
        p_open_ex      Out Varchar2,
        p_open_co      Out Varchar2,
        p_open_oh      Out Varchar2,
        p_open_lv      Out Varchar2,

        p_close_cl     Out Varchar2,
        p_close_sl     Out Varchar2,
        p_close_pl     Out Varchar2,
        p_close_ex     Out Varchar2,
        p_close_co     Out Varchar2,
        p_close_oh     Out Varchar2,
        p_close_lv     Out Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_message_type Varchar2(2);
        v_count        Number;
    Begin
        If p_empno Is Null Then
            v_empno := get_empno_from_meta_id(p_meta_id);
            If v_empno = 'ERRRR' Then
                p_message_type := 'KO';
                p_message_text := 'Invalid employee by person id';
                Return;
            End If;
        Else
            v_empno := p_empno;
        End If;
        /*
        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno = p_empno;
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        */
        get_leave_balance_all(
            p_empno           => v_empno,
            p_pdate           => p_start_date,
            p_open_close_flag => ss.opening_bal,

            p_cl              => p_open_cl,
            p_sl              => p_open_sl,
            p_pl              => p_open_pl,
            p_ex              => p_open_ex,
            p_co              => p_open_co,
            p_oh              => p_open_oh,
            p_lv              => p_open_lv,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

        If p_message_type = 'KO' Then
            Return;
        End If;

        get_leave_balance_all(
            p_empno           => v_empno,
            p_pdate           => p_end_date,
            p_open_close_flag => ss.closing_bal,

            p_cl              => p_close_cl,
            p_sl              => p_close_sl,
            p_pl              => p_close_pl,
            p_ex              => p_close_ex,
            p_co              => p_close_co,
            p_oh              => p_close_oh,
            p_lv              => p_close_lv,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_leave_approval(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_leave_approvals  typ_tab_string,
        p_approver_profile Number,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_app_no            Varchar2(70);
        v_approval          Number;
        v_remarks           Varchar2(70);
        v_count             Number;
        v_rec_count         Number;
        sqlpart1            Varchar2(60) := 'Update SS_leaveapp ';
        sqlpart2            Varchar2(500);
        strsql              Varchar2(600);
        v_odappstat_rec     ss_odappstat%rowtype;
        v_approver_empno    Varchar2(5);
        v_user_tcp_ip       Varchar2(30);
        v_msg_type          Varchar2(20);
        v_msg_text          Varchar2(1000);
        v_medical_cert_file Varchar2(200);
    Begin

        v_approver_empno := get_empno_from_meta_id(p_meta_id);
        If v_approver_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        sqlpart2         := ' set ApproverProfile_APPRL = :Approval, ApproverProfile_Code = :Approver_EmpNo, ApproverProfile_APPRL_DT = Sysdate,
                    ApproverProfile_TCP_IP = :User_TCP_IP , ApproverProfileREASON = :Reason where App_No = :paramAppNo';
        If p_approver_profile = user_profile.type_hod Or p_approver_profile = user_profile.type_sec Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'HOD');
        Elsif p_approver_profile = user_profile.type_hrd Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'HRD');
        Elsif p_approver_profile = user_profile.type_lead Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'LEAD');
        End If;

        For i In 1..p_leave_approvals.count
        Loop

            With
                csv As (
                    Select
                        p_leave_approvals(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '[^~!~]+', 1, 1))            app_no,
                To_Number(Trim(regexp_substr(str, '[^~!~]+', 1, 2))) approval,
                Trim(regexp_substr(str, '[^~!~]+', 1, 3))            remarks
            Into
                v_app_no, v_approval, v_remarks
            From
                csv;

            /*
            p_message_type := 'OK';
            p_message_text := 'Debug 1 - ' || p_leave_approvals(i);
            Return;
            */
            strsql := sqlpart1 || ' ' || sqlpart2;
            strsql := replace(strsql, 'LEADREASON', 'LEAD_REASON');
            Execute Immediate strsql
                Using v_approval, v_approver_empno, v_user_tcp_ip, v_remarks, trim(v_app_no);
            Commit;
            If p_approver_profile = user_profile.type_hrd And v_approval = ss.approved Then
                leave.post_leave_apprl(v_app_no, v_msg_type, v_msg_text);
                /*
                If v_msg_type = ss.success Then
                    generate_auto_punch_4od(v_app_no);
                End If;
                */
            Elsif v_approval = ss.disapproved Then

                sp_process_disapproved_app(
                    p_person_id      => p_person_id,
                    p_meta_id        => p_meta_id,

                    p_application_id => Trim(v_app_no)
                );

            End If;

        End Loop;

        Commit;
        p_message_type   := 'OK';
        p_message_text   := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_leave_approval_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_leave_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_leave_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_leave_approvals  => p_leave_approvals,
            p_approver_profile => user_profile.type_lead,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End;

    Procedure sp_leave_approval_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_leave_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_leave_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_leave_approvals  => p_leave_approvals,
            p_approver_profile => user_profile.type_hod,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End sp_leave_approval_hod;

    Procedure sp_leave_approval_hr(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_leave_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_leave_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_leave_approvals  => p_leave_approvals,
            p_approver_profile => user_profile.type_hrd,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End sp_leave_approval_hr;

    Procedure sp_do_approval_4_ex_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_jan_2022       Date         := To_Date('1-Jan-2022', 'dd-Mon-yyyy');
        Cursor cur_pending_leave Is
            Select
                app_no,
                app_date,
                bdate,
                la.empno,
                lead_apprl_empno,
                lead_apprl,
                e.status
            From
                ss_leaveapp la,
                ss_emplmast e
            Where
                nvl(lead_apprl, 0) In (0)
                And la.lead_apprl_empno = e.empno
                And e.status            = 0
                And bdate >= v_jan_2022;
        v_sys_apprl      Varchar2(5)  := 'Sys';
        v_apprl_remarks  Varchar2(30) := 'Auto apprl as lead resigned';
        v_approver_empno Varchar2(5);
    Begin
        v_approver_empno := get_empno_from_meta_id(p_meta_id);
        If v_approver_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        For row_pending_leave In cur_pending_leave
        Loop
            Update
                ss_leaveapp
            Set
                lead_apprl = 1, lead_code = 'Sys', lead_apprl_dt = sysdate, lead_reason = v_apprl_remarks,
                hod_apprl = 1, hod_code = 'Sys', hod_apprl_dt = sysdate, hodreason = v_apprl_remarks
            Where
                app_no = row_pending_leave.app_no;
        End Loop;
        p_message_type   := 'OK';
        p_message_text   := 'Procedure execute successfully';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_do_approval_4_ex_lead;

    Procedure prc_undo_leave_from_reject_table(
        p_application_id Varchar2
    ) As
    Begin
        Insert Into ss_leaveapp(

            app_no,
            empno,
            app_date,
            rep_to,
            projno,
            caretaker,
            leaveperiod,
            leavetype,
            bdate,
            edate,
            reason,
            mcert,
            work_ldate,
            resm_date,
            contact_add,
            contact_phn,
            contact_std,
            last_hrs,
            last_mn,
            resm_hrs,
            resm_mn,
            dataentryby,
            office,
            hod_apprl,
            hod_apprl_dt,
            hod_code,
            hrd_apprl,
            hrd_apprl_dt,
            hrd_code,
            discrepancy,
            user_tcp_ip,
            hod_tcp_ip,
            hrd_tcp_ip,
            hodreason,
            hrdreason,
            hd_date,
            hd_part,
            lead_apprl,
            lead_apprl_dt,
            lead_code,
            lead_tcp_ip,
            lead_apprl_empno,
            lead_reason,
            med_cert_file_name,
            is_covid_sick_leave)

        Select
            app_no,
            empno,
            app_date,
            rep_to,
            projno,
            caretaker,
            leaveperiod,
            leavetype,
            bdate,
            edate,
            reason,
            mcert,
            work_ldate,
            resm_date,
            contact_add,
            contact_phn,
            contact_std,
            last_hrs,
            last_mn,
            resm_hrs,
            resm_mn,
            dataentryby,
            office,
            hod_apprl,
            hod_apprl_dt,
            hod_code,
            0    hrd_apprl,
            Null hrd_apprl_dt,
            hrd_code,
            discrepancy,
            user_tcp_ip,
            hod_tcp_ip,
            hrd_tcp_ip,
            hodreason,
            Null hrdreason,
            hd_date,
            hd_part,
            lead_apprl,
            lead_apprl_dt,
            lead_code,
            lead_tcp_ip,
            lead_apprl_empno,
            lead_reason,
            med_cert_file_name,
            is_covid_sick_leave
        From
            ss_leaveapp_rejected
        Where
            Trim(app_no) = Trim(p_application_id);

    End;

    --Rollback Leave approvals by HR
    Procedure sp_rollback_approval_hr(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_application_id   Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ss_leaveapp
        Where
            Trim(app_no)  = Trim(p_application_id)
            And hrd_apprl = 1;
        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- Application not found.';
            Return;
        End If;
        Delete
            From ss_leaveledg
        Where
            Trim(app_no) = Trim(p_application_id);
        Update
            ss_leaveapp
        Set
            hrd_apprl = 0
        Where
            Trim(app_no) = Trim(p_application_id);
        p_message_type := ok;
        p_message_text := 'Successfull rolled backup HR approval.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_rollback_approval_hr;

    --Rollback Leave rejection by HR
    Procedure sp_rollback_rejection_hr(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_application_id   Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ss_leaveapp_rejected
        Where
            Trim(app_no) = Trim(p_application_id);
        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- Application not found.';
            Return;
        End If;
        Update
            ss_leaveapp_rejected
        Set
            hrd_apprl = 0
        Where
            Trim(app_no) = Trim(p_application_id);

        If Sql%rowcount = 1 Then
            prc_undo_leave_from_reject_table(p_application_id);
            Delete
                From ss_leaveapp_rejected
            Where
                Trim(app_no) = Trim(p_application_id);
        End If;

        p_message_type := ok;
        p_message_text := 'Successfull roll backup HR leave rejection.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_rollback_rejection_hr;

    Procedure sp_rollback_approval_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_application_id   Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2

    ) As
        v_approver_empno Varchar2(5);
        v_count          Number;
    Begin
        v_approver_empno := get_empno_from_meta_id(p_meta_id);
        If v_approver_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_leaveapp
        Where
            Trim(app_no)          = Trim(p_application_id)
            And lead_apprl        = 1
            And nvl(hod_apprl, 0) = 0
            And nvl(hrd_apprl, 0) = 0;

        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Cannot rollback approval. Leave not approved or next level approval already done.';
            Return;
        End If;

        Update
            ss_leaveapp
        Set
            lead_apprl = 0
        Where
            Trim(app_no) = Trim(p_application_id);
        If Sql%rowcount = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Leave approval rollback failed.';
            Return;
        Else
            p_message_type := ok;
            p_message_text := 'Successfull roll back approval.';

        End If;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_rollback_rejection_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_application_id   Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ss_leaveapp_rejected
        Where
            Trim(app_no)   = Trim(p_application_id)
            And lead_apprl = ss.disapproved;
        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- Application not found.';
            Return;
        End If;
        Update
            ss_leaveapp_rejected
        Set
            lead_apprl = 0
        Where
            Trim(app_no) = Trim(p_application_id);

        If Sql%rowcount = 1 Then
            prc_undo_leave_from_reject_table(p_application_id);
            Delete
                From ss_leaveapp_rejected
            Where
                Trim(app_no) = Trim(p_application_id);
        End If;

        p_message_type := ok;
        p_message_text := 'Successfull roll backup HR leave rejection.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_rollback_rejection_lead;

    Procedure sp_rollback_approval_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_application_id   Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2

    ) As
        v_approver_empno Varchar2(5);
        v_count          Number;
    Begin
        v_approver_empno := get_empno_from_meta_id(p_meta_id);
        If v_approver_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_leaveapp
        Where
            Trim(app_no)          = Trim(p_application_id)
            And nvl(hod_apprl, 0) = 1
            And nvl(hrd_apprl, 0) = 0;

        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Cannot rollback HoD Leave approval. Leave not yet approved or next level approval already done.';
            Return;
        End If;

        Update
            ss_leaveapp
        Set
            hod_apprl = 0
        Where
            Trim(app_no) = Trim(p_application_id);
        If Sql%rowcount = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Leave approval rollback failed.';
            Return;
        Else
            p_message_type := ok;
            p_message_text := 'Successfull roll back approval.';

        End If;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_rollback_rejection_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_application_id   Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ss_leaveapp_rejected
        Where
            Trim(app_no)  = Trim(p_application_id)
            And hod_apprl = ss.disapproved;
        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- Application not found.';
            Return;
        End If;
        Update
            ss_leaveapp_rejected
        Set
            hod_apprl = 0
        Where
            Trim(app_no) = Trim(p_application_id);

        If Sql%rowcount = 1 Then
            prc_undo_leave_from_reject_table(p_application_id);
            Delete
                From ss_leaveapp_rejected
            Where
                Trim(app_no) = Trim(p_application_id);
        End If;

        p_message_type := ok;
        p_message_text := 'Successfull roll backup HR leave rejection.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_rollback_rejection_hod;

End iot_leave;
/

Grant Execute On "SELFSERVICE"."IOT_LEAVE" To "TCMPL_APP_CONFIG";
Grant Execute On "SELFSERVICE"."IOT_LEAVE" To "IOT_TCMPL";