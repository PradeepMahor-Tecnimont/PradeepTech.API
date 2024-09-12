--------------------------------------------------------
--  DDL for Package Body IOT_ONDUTY
--------------------------------------------------------

Create Or Replace Package Body "SELFSERVICE"."IOT_ONDUTY" As
    c_onduty     Constant Varchar2(2) := 'OD';
    c_deputation Constant Varchar2(2) := 'DP';

    Procedure sp_delete_onduty_app(
        p_application_id Varchar2,
        p_tab_from       Varchar2,
        p_force_del      Varchar2
    ) As
        v_count      Number;
        v_self_empno Varchar2(5);

        v_tab_from   Varchar2(2);
    Begin

        del_od_app(
            p_app_no    => p_application_id,
            p_tab_from  => p_tab_from,
            p_force_del => p_force_del
        );

    Exception
        When Others Then
            Null;
    End;

    Procedure sp_process_disapproved_app(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_application_id Varchar2,
        p_tab_from       Varchar2
    ) As
        v_msg_type        Varchar2(15);
        v_msg_text        Varchar2(1000);
        v_onduty_rejected ss_ondutyapp_rejected%rowtype;
        v_depu_rejected   ss_depu_rejected%rowtype;
        v_onduty          ss_ondutyapp%rowtype;
        v_depu            ss_depu%rowtype;
    Begin

        If p_tab_from = c_onduty Then

            Insert Into ss_ondutyapp_rejected (
                empno,
                hh,
                mm,
                pdate,
                dd,
                mon,
                yyyy,
                type,
                app_no,
                description,
                hod_apprl,
                hod_apprl_dt,
                hod_code,
                hrd_apprl,
                hrd_apprl_dt,
                hrd_code,
                app_date,
                hh1,
                mm1,
                reason,
                user_tcp_ip,
                hod_tcp_ip,
                hrd_tcp_ip,
                hodreason,
                hrdreason,
                odtype,
                lead_apprl,
                lead_code,
                lead_apprl_dt,
                lead_tcp_ip,
                lead_reason,
                lead_apprl_empno,
                rejected_on
            )
            Select
                empno,
                hh,
                mm,
                pdate,
                dd,
                mon,
                yyyy,
                type,
                app_no,
                description,
                hod_apprl,
                hod_apprl_dt,
                hod_code,
                hrd_apprl,
                hrd_apprl_dt,
                hrd_code,
                app_date,
                hh1,
                mm1,
                reason,
                user_tcp_ip,
                hod_tcp_ip,
                hrd_tcp_ip,
                hodreason,
                hrdreason,
                odtype,
                lead_apprl,
                lead_code,
                lead_apprl_dt,
                lead_tcp_ip,
                lead_reason,
                lead_apprl_empno,
                sysdate
            From
                ss_ondutyapp
            Where
                app_no = p_application_id;

        Elsif p_tab_from = c_deputation Then
            Insert Into ss_depu_rejected (
                empno,
                app_no,
                bdate,
                edate,
                description,
                type,
                hod_apprl,
                hod_apprl_dt,
                hod_code,
                hrd_apprl,
                hrd_apprl_dt,
                hrd_code,
                app_date,
                reason,
                user_tcp_ip,
                hod_tcp_ip,
                hrd_tcp_ip,
                hodreason,
                hrdreason,
                chg_no,
                chg_date,
                lead_apprl,
                lead_apprl_dt,
                lead_code,
                lead_tcp_ip,
                lead_reason,
                lead_apprl_empno,
                chg_by,
                site_code,
                rejected_on
            )
            Select
                empno,
                app_no,
                bdate,
                edate,
                description,
                type,
                hod_apprl,
                hod_apprl_dt,
                hod_code,
                hrd_apprl,
                hrd_apprl_dt,
                hrd_code,
                app_date,
                reason,
                user_tcp_ip,
                hod_tcp_ip,
                hrd_tcp_ip,
                hodreason,
                hrdreason,
                chg_no,
                chg_date,
                lead_apprl,
                lead_apprl_dt,
                lead_code,
                lead_tcp_ip,
                lead_reason,
                lead_apprl_empno,
                chg_by,
                site_code,
                sysdate
            From
                ss_depu
            Where
                app_no = p_application_id;

        Else
            Return;
        End If;
        sp_delete_onduty_app(
            p_application_id => p_application_id,
            p_tab_from       => p_tab_from,
            p_force_del      => not_ok
        );

        Begin
            If p_tab_from = c_onduty Then
                Select
                    *
                Into
                    v_onduty_rejected
                From
                    ss_ondutyapp_rejected
                Where
                    app_no = p_application_id;
            Elsif p_tab_from = c_deputation Then
                Select
                    *
                Into
                    v_depu_rejected
                From
                    ss_depu_rejected
                Where
                    app_no = p_application_id;
            Else
                Return;
            End If;
            ---
            ss_mail.send_mail_onduty_rejected(
                p_onduty_rec => v_onduty_rejected,
                p_depu_rec   => v_depu_rejected
            );
        Exception
            When Others Then
                Return;
        End;

    End;

    Procedure sp_onduty_details(
        p_application_id      Varchar2,

        p_emp_name        Out Varchar2,

        p_onduty_type     Out Varchar2,
        p_onduty_sub_type Out Varchar2,
        p_start_date      Out Varchar2,
        p_end_date        Out Varchar2,

        p_hh1             Out Varchar2,
        p_mi1             Out Varchar2,
        p_hh2             Out Varchar2,
        p_mi2             Out Varchar2,

        p_reason          Out Varchar2,
        p_lead_name       Out Varchar2,
        p_lead_approval   Out Varchar2,
        p_hod_approval    Out Varchar2,
        p_hr_approval     Out Varchar2,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As

        v_onduty_app ss_vu_ondutyapp%rowtype;
        v_depu       ss_vu_depu%rowtype;
        v_empno      Varchar2(5);
        v_count      Number;

    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ss_vu_ondutyapp
        Where
            Trim(app_no) = Trim(p_application_id);
        If v_count = 1 Then
            Select
                *
            Into
                v_onduty_app
            From
                ss_vu_ondutyapp
            Where
                Trim(app_no) = Trim(p_application_id);
        Else
            Select
                Count(*)
            Into
                v_count
            From
                ss_vu_depu
            Where
                Trim(app_no) = Trim(p_application_id);

            If v_count = 1 Then
                Select
                    *
                Into
                    v_depu
                From
                    ss_vu_depu
                Where
                    Trim(app_no) = Trim(p_application_id);
            End If;
        End If;
        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Err - Invalid application id';
            Return;
        End If;
        If v_onduty_app.empno Is Not Null Then
            Select
                description
            Into
                p_onduty_type
            From
                ss_ondutymast
            Where
                type = v_onduty_app.type;
            p_onduty_type   := v_onduty_app.type || ' - ' || p_onduty_type;
            If nvl(v_onduty_app.odtype, 0) <> 0 Then
                Select
                    description
                Into
                    p_onduty_sub_type
                From
                    ss_onduty_sub_type
                Where
                    od_sub_type = v_onduty_app.odtype;
                p_onduty_sub_type := v_onduty_app.odtype || ' - ' || p_onduty_sub_type;
            End If;

            p_emp_name      := get_emp_name(v_onduty_app.empno);
            p_start_date    := v_onduty_app.pdate;
            p_hh1           := lpad(v_onduty_app.hh, 2, '0');
            p_mi1           := lpad(v_onduty_app.mm, 2, '0');
            p_hh2           := lpad(v_onduty_app.hh1, 2, '0');
            p_mi2           := lpad(v_onduty_app.mm1, 2, '0');
            p_reason        := v_onduty_app.reason;

            p_lead_name     := get_emp_name(v_onduty_app.lead_apprl_empno);
            p_lead_approval := v_onduty_app.lead_apprldesc;
            p_hod_approval  := v_onduty_app.hod_apprldesc;
            p_hr_approval   := v_onduty_app.hrd_apprldesc;

        Elsif v_depu.empno Is Not Null Then

            Select
                description
            Into
                p_onduty_type
            From
                ss_ondutymast
            Where
                type = v_depu.type;
            p_onduty_type   := v_depu.type || ' - ' || p_onduty_type;

            p_emp_name      := get_emp_name(v_depu.empno);

            p_onduty_type   := v_depu.type || ' - ' || p_onduty_type;
            p_start_date    := v_depu.bdate;
            p_end_date      := v_depu.edate;
            p_reason        := v_depu.reason;

            Select
                description
            Into
                p_onduty_type
            From
                ss_ondutymast
            Where
                type = v_depu.type;
            p_onduty_type   := v_depu.type || ' - ' || p_onduty_type;

            p_emp_name      := get_emp_name(v_depu.empno);
            p_lead_name     := get_emp_name(v_depu.lead_apprl_empno);

            p_lead_approval := v_depu.lead_apprldesc;
            p_hod_approval  := v_depu.hod_apprldesc;
            p_hr_approval   := v_depu.hrd_apprldesc;

        End If;

        p_message_type := ok;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_add_punch_entry(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_hh1              Varchar2,
        p_mi1              Varchar2,
        p_hh2              Varchar2 Default Null,
        p_mi2              Varchar2 Default Null,
        p_date             Date,
        p_type             Varchar2,
        p_sub_type         Varchar2 Default Null,
        p_lead_approver    Varchar2,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_entry_by_empno Varchar2(5);
        v_count          Number;
        v_lead_approval  Number := 0;
        v_hod_approval   Number := 0;
        v_desc           Varchar2(60);
    Begin
        v_entry_by_empno := get_empno_from_meta_id(p_meta_id);
        If v_entry_by_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        od.add_onduty_type_1(
            p_empno         => p_empno,
            p_od_type       => p_type,
            p_od_sub_type   => nvl(Trim(p_sub_type), 0),
            p_pdate         => to_char(p_date, 'yyyymmdd'),
            p_hh            => To_Number(Trim(p_hh1)),
            p_mi            => To_Number(Trim(p_mi1)),
            p_hh1           => To_Number(Trim(p_hh2)),
            p_mi1           => To_Number(Trim(p_mi2)),
            p_lead_approver => p_lead_approver,
            p_reason        => p_reason,
            p_entry_by      => v_entry_by_empno,
            p_user_ip       => Null,
            p_success       => p_message_type,
            p_message       => p_message_text
        );

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_punch_entry;

    Procedure sp_add_depu_tour(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_start_date       Date,
        p_end_date         Date,
        p_type             Varchar2,
        p_lead_approver    Varchar2,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_entry_by_empno Varchar2(5);
        v_count          Number;

    Begin
        v_entry_by_empno := get_empno_from_meta_id(p_meta_id);
        If v_entry_by_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        od.add_onduty_type_2(
            p_empno         => p_empno,
            p_od_type       => p_type,
            p_b_yyyymmdd    => to_char(p_start_date, 'yyyymmdd'),
            p_e_yyyymmdd    => to_char(p_end_date, 'yyyymmdd'),
            p_entry_by      => v_entry_by_empno,
            p_lead_approver => p_lead_approver,
            p_user_ip       => Null,
            p_reason        => p_reason,
            p_success       => p_message_type,
            p_message       => p_message_text
        );
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_depu_tour;

    Procedure sp_extend_depu(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,
        p_end_date         Date,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_entry_by_empno Varchar2(5);
        v_count          Number;
        rec_depu         ss_depu%rowtype;
    Begin
        Select
            *
        Into
            rec_depu
        From
            ss_depu
        Where
            Trim(app_no) = Trim(p_application_id);
        If rec_depu.edate > p_end_date Then
            p_message_type := not_ok;
            p_message_text := 'Extension end date should be greater than existing end date.';
            Return;
        End If;
        sp_add_depu_tour(
            p_person_id     => p_person_id,
            p_meta_id       => p_meta_id,

            p_empno         => rec_depu.empno,
            p_start_date    => rec_depu.edate + 1,
            p_end_date      => p_end_date,
            p_type          => rec_depu.type,
            p_lead_approver => 'None',
            p_reason        => p_reason,

            p_message_type  => p_message_type,
            p_message_text  => p_message_text
        );
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;
    
    --
    Procedure sp_delete_od_app_4_self(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count    Number;
        v_empno    Varchar2(5);
        v_tab_from Varchar2(2);
    Begin
        v_count        := 0;
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_ondutyapp
        Where
            Trim(app_no) = Trim(p_application_id)
            And empno    = v_empno;
        If v_count = 1 Then
            v_tab_from := 'OD';
        Else
            Select
                Count(*)
            Into
                v_count
            From
                ss_depu
            Where
                Trim(app_no) = Trim(p_application_id)
                And empno    = v_empno;
            If v_count = 1 Then
                v_tab_from := 'DP';
            End If;
        End If;
        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Err - Invalid application id';
            Return;
        End If;
        sp_delete_onduty_app(
            p_application_id => p_application_id,
            p_tab_from       => v_tab_from,
            p_force_del      => not_ok
        );
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_od_app_4_self;

    Procedure sp_delete_od_app_force(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,
        p_empno            Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count      Number;
        v_self_empno Varchar2(5);

        v_tab_from   Varchar2(2);
    Begin
        v_count        := 0;
        v_self_empno   := get_empno_from_meta_id(p_meta_id);
        If v_self_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_vu_ondutyapp
        Where
            Trim(app_no) = Trim(p_application_id)
            And empno    = p_empno;
        If v_count = 1 Then
            v_tab_from := c_onduty;
        Else
            Select
                Count(*)
            Into
                v_count
            From
                ss_vu_depu
            Where
                Trim(app_no) = Trim(p_application_id)
                And empno    = p_empno;
            If v_count = 1 Then
                v_tab_from := c_deputation;
            End If;
        End If;
        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Err - Invalid application id';
            Return;
        End If;
        sp_delete_onduty_app(
            p_application_id => p_application_id,
            p_tab_from       => v_tab_from,
            p_force_del      => ok
        );
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_od_app_force;

    Procedure sp_onduty_application_details(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_application_id      Varchar2,

        p_emp_name        Out Varchar2,

        p_onduty_type     Out Varchar2,
        p_onduty_sub_type Out Varchar2,
        p_start_date      Out Varchar2,
        p_end_date        Out Varchar2,

        p_hh1             Out Varchar2,
        p_mi1             Out Varchar2,
        p_hh2             Out Varchar2,
        p_mi2             Out Varchar2,

        p_reason          Out Varchar2,

        p_lead_name       Out Varchar2,
        p_lead_approval   Out Varchar2,
        p_hod_approval    Out Varchar2,
        p_hr_approval     Out Varchar2,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As
        v_count    Number;
        v_empno    Varchar2(5);
        v_tab_from Varchar2(2);
    Begin
        v_count := 0;
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        sp_onduty_details(
            p_application_id  => p_application_id,

            p_emp_name        => p_emp_name,

            p_onduty_type     => p_onduty_type,
            p_onduty_sub_type => p_onduty_sub_type,
            p_start_date      => p_start_date,
            p_end_date        => p_end_date,

            p_hh1             => p_hh1,
            p_mi1             => p_mi1,
            p_hh2             => p_hh2,
            p_mi2             => p_mi2,

            p_reason          => p_reason,

            p_lead_name       => p_lead_name,
            p_lead_approval   => p_lead_approval,
            p_hod_approval    => p_hod_approval,
            p_hr_approval     => p_hr_approval,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text

        );
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_onduty_approval(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,
        p_approver_profile Number,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_app_no         Varchar2(70);
        v_approval       Number;
        v_remarks        Varchar2(70);
        v_count          Number;
        v_rec_count      Number;
        sqlpartod        Varchar2(60) := 'Update SS_OnDutyApp ';
        sqlpartdp        Varchar2(60) := 'Update SS_Depu ';
        sqlpart2         Varchar2(500);
        strsql           Varchar2(600);
        v_odappstat_rec  ss_odappstat%rowtype;
        v_approver_empno Varchar2(5);
        v_user_tcp_ip    Varchar2(30);
        v_msg_type       Varchar2(10);
        v_msg_text       Varchar2(1000);
    Begin

        v_approver_empno := get_empno_from_meta_id(p_meta_id);
        If v_approver_empno = 'ERRRR' Then
            p_message_type := not_ok;
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

        For i In 1..p_onduty_approvals.count
        Loop

            With
                csv As (
                    Select
                        p_onduty_approvals(i) str
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

            Select
                *
            Into
                v_odappstat_rec
            From
                ss_odappstat
            Where
                Trim(app_no) = Trim(v_app_no);

            If (v_odappstat_rec.fromtab) = c_deputation Then
                strsql := sqlpartdp || ' ' || sqlpart2;
            Elsif (v_odappstat_rec.fromtab) = c_onduty Then
                strsql := sqlpartod || ' ' || sqlpart2;
            End If;
            /*
            p_message_type := ok;
            p_message_text := 'Debug 1 - ' || p_onduty_approvals(i);
            Return;
            */
            strsql := replace(strsql, 'LEADREASON', 'LEAD_REASON');
            Execute Immediate strsql
                Using v_approval, v_approver_empno, v_user_tcp_ip, v_remarks, trim(v_app_no);
            Commit;
            If v_odappstat_rec.fromtab = c_onduty And p_approver_profile = user_profile.type_hrd And v_approval = ss.approved
            Then
                Delete
                    From ss_onduty
                Where
                    Trim(app_no) = Trim(v_app_no);
                Insert Into ss_onduty value
                (
                    Select
                        empno,
                        hh,
                        mm,
                        pdate,
                        0,
                        dd,
                        mon,
                        yyyy,
                        type,
                        app_no,
                        description,
                        getodhh(app_no, 1),
                        getodmm(app_no, 1),
                        app_date,
                        reason,
                        odtype
                    From
                        ss_ondutyapp
                    Where
                        Trim(app_no)                   = Trim(v_app_no)
                        And nvl(hrd_apprl, ss.pending) = ss.approved
                );

                Insert Into ss_onduty value
                (
                    Select
                        empno,
                        hh1,
                        mm1,
                        pdate,
                        0,
                        dd,
                        mon,
                        yyyy,
                        type,
                        app_no,
                        description,
                        getodhh(app_no, 2),
                        getodmm(app_no, 2),
                        app_date,
                        reason,
                        odtype
                    From
                        ss_ondutyapp
                    Where
                        Trim(app_no)                   = Trim(v_app_no)
                        And (type                      = 'OD'
                            Or type                    = 'IO')
                        And nvl(hrd_apprl, ss.pending) = ss.approved
                );

                If p_approver_profile = user_profile.type_hrd And v_approval = ss.approved Then
                    generate_auto_punch_4od(v_app_no);
                End If;
            Elsif v_approval = ss.disapproved Then

                sp_process_disapproved_app(
                    p_person_id      => p_person_id,
                    p_meta_id        => p_meta_id,

                    p_application_id => Trim(v_app_no),
                    p_tab_from       => v_odappstat_rec.fromtab
                );

            End If;

        End Loop;

        Commit;
        p_message_type   := ok;
        p_message_text   := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_onduty_approval_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_onduty_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_onduty_approvals => p_onduty_approvals,
            p_approver_profile => user_profile.type_lead,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End;

    Procedure sp_onduty_approval_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_onduty_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_onduty_approvals => p_onduty_approvals,
            p_approver_profile => user_profile.type_hod,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End;

    Procedure sp_onduty_approval_hr(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_onduty_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_onduty_approvals => p_onduty_approvals,
            p_approver_profile => user_profile.type_hrd,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End;

    Procedure sp_check_emp_onduty_swp(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_entry_by_empno Varchar2(5);
        v_count          Number;

    Begin
        p_message_type   := not_ok;
        p_message_text   := 'Employee not in swp onduty ';
        v_entry_by_empno := get_empno_from_meta_id(p_meta_id);
        If v_entry_by_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ss_emp_for_onduty_swp
        Where
            empno = p_empno;

        If v_count > 0 Then
            p_message_type := ok;
            p_message_text := 'Employee is in swp onduty ';
            Return;
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_check_emp_onduty_swp;

    Procedure sp_do_approval_4_ex_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_jan_2022       Date         := To_Date('1-Jan-2022', 'dd-Mon-yyyy');
        Cursor cur_pending_onduty Is

            Select
                app_no,
                app_date,
                pdate,
                od.empno,
                lead_apprl_empno,
                lead_apprl,
                e.status
            From
                ss_ondutyapp od,
                ss_emplmast  e
            Where
                od.lead_apprl_empno    = e.empno
                And pdate >= v_jan_2022
                And nvl(lead_apprl, 0) = 0
                And e.status           = 0;

        Cursor cur_pending_depu Is
            Select
                app_no,
                app_date,
                bdate,
                depu.empno,
                lead_apprl_empno,
                lead_apprl,
                e.status
            From
                ss_depu     depu,
                ss_emplmast e
            Where
                depu.lead_apprl_empno  = e.empno
                And bdate >= v_jan_2022
                And nvl(lead_apprl, 0) = 0
                And e.status           = 0
                And depu.type In ('TR', 'DP');

        v_sys_apprl      Varchar2(5)  := 'Sys';
        v_apprl_remarks  Varchar2(30) := 'Auto apprl as lead resigned';
        v_approver_empno Varchar2(5);
    Begin
        v_approver_empno := get_empno_from_meta_id(p_meta_id);
        If v_approver_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        For row_pending_onduty In cur_pending_onduty
        Loop
            Update
                ss_ondutyapp
            Set
                lead_apprl = 1, lead_code = 'Sys', lead_apprl_dt = sysdate, lead_reason = v_apprl_remarks,
                hod_apprl = 1, hod_code = 'Sys', hod_apprl_dt = sysdate, hodreason = v_apprl_remarks
            Where
                app_no = row_pending_onduty.app_no;
        End Loop;

        For row_pending_depu In cur_pending_depu
        Loop
            Update
                ss_depu
            Set
                lead_apprl = 1, lead_code = 'Sys', lead_apprl_dt = sysdate, lead_reason = v_apprl_remarks,
                hod_apprl = 1, hod_code = 'Sys', hod_apprl_dt = sysdate, hodreason = v_apprl_remarks
            Where
                app_no = row_pending_depu.app_no;
        End Loop;

        p_message_type   := ok;
        p_message_text   := 'Procedure execute successfully';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_do_approval_4_ex_lead;

End iot_onduty;
/

Grant Execute On "SELFSERVICE"."IOT_ONDUTY" To "TCMPL_APP_CONFIG";