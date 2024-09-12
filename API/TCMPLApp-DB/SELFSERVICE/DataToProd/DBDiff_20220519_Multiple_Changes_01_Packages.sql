--------------------------------------------------------
--  File created - Thursday-May-19-2022   
--------------------------------------------------------
---------------------------
--New PACKAGE
--IOT_SWP_EMP_TO_OFFICE_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_EMP_TO_OFFICE_QRY" as

   function fn_Emp_Coming_To_Office_list(
      p_person_id      varchar2,
      p_meta_id        varchar2,

      p_generic_search varchar2 default null,
      p_start_date     date     default null,      
      
      p_row_number     number,
      p_page_length    number
   ) return sys_refcursor;

end IOT_SWP_EMP_TO_OFFICE_QRY;
/
---------------------------
--Changed PACKAGE
--IOT_ONDUTY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_ONDUTY" As

    Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;

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
    );

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
    );

    Procedure sp_extend_depu(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,
        p_end_date         Date,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_delete_od_app_4_self(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_delete_od_app_force(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,

        p_empno            Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

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
    );

    Procedure sp_onduty_approval_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_onduty_approval_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_onduty_approval_hr(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

procedure sp_check_emp_onduty_swp(
        p_person_id        varchar2,
        p_meta_id          varchar2,

        p_empno            varchar2,

        p_message_type out varchar2,
        p_message_text out varchar2
    );

End iot_onduty;
/
---------------------------
--Changed PACKAGE BODY
--IOT_ONDUTY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_ONDUTY" As

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
            p_message_type := 'KO';
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

        p_message_type := 'OK';

    Exception
        When Others Then
            p_message_type := 'KO';
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
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        od.add_onduty_type_1(
            p_empno         => p_empno,
            p_od_type       => p_type,
            p_od_sub_type   => nvl(Trim(p_sub_type), 0),
            p_pdate         => to_char(p_date, 'yyyymmdd'),
            p_hh            => to_number(Trim(p_hh1)),
            p_mi            => to_number(Trim(p_mi1)),
            p_hh1           => to_number(Trim(p_hh2)),
            p_mi1           => to_number(Trim(p_mi2)),
            p_lead_approver => p_lead_approver,
            p_reason        => p_reason,
            p_entry_by      => v_entry_by_empno,
            p_user_ip       => Null,
            p_success       => p_message_type,
            p_message       => p_message_text
        );

    Exception
        When Others Then
            p_message_type := 'KO';
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
            p_message_type := 'KO';
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
            p_message_type := 'KO';
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
            p_message_type := 'KO';
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
            p_message_type := 'KO';
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
            p_message_type := 'KO';
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
            p_message_type := 'KO';
            p_message_text := 'Err - Invalid application id';
            Return;
        End If;
        del_od_app(p_app_no   => p_application_id,
                   p_tab_from => v_tab_from);
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
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
            p_message_type := 'KO';
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
            v_tab_from := 'OD';
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
                v_tab_from := 'DP';
            End If;
        End If;
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Err - Invalid application id';
            Return;
        End If;
        del_od_app(
            p_app_no    => p_application_id,
            p_tab_from  => v_tab_from,
            p_force_del => 'OK'
        );
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
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
            p_message_type := 'KO';
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
            p_message_type := 'KO';
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
        c_onduty         Constant Varchar2(2) := 'OD';
        c_deputation     Constant Varchar2(2) := 'DP';
        v_count          Number;
        v_rec_count      Number;
        sqlpartod        Varchar2(60)         := 'Update SS_OnDutyApp ';
        sqlpartdp        Varchar2(60)         := 'Update SS_Depu ';
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
                to_number(Trim(regexp_substr(str, '[^~!~]+', 1, 2))) approval,
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
            p_message_type := 'OK';
            p_message_text := 'Debug 1 - ' || p_onduty_approvals(i);
            Return;
            */
            strsql := replace(strsql, 'LEADREASON', 'LEAD_REASON');
            Execute Immediate strsql
                Using v_approval, v_approver_empno, v_user_tcp_ip, v_remarks, trim(v_app_no);

            If v_odappstat_rec.fromtab = c_onduty And p_approver_profile = user_profile.type_hrd And v_approval = ss.approved
            Then
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

                sp_delete_od_app_force(
                    p_person_id      => p_person_id,
                    p_meta_id        => p_meta_id,

                    p_application_id => Trim(v_app_no),
                    p_empno          => v_odappstat_rec.empno,
                    p_message_type   => v_msg_type,
                    p_message_text   => v_msg_text
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


procedure sp_check_emp_onduty_swp(
        p_person_id        varchar2,
        p_meta_id          varchar2,

        p_empno            varchar2,

        p_message_type out varchar2,
        p_message_text out varchar2
    ) as
   v_entry_by_empno varchar2(5);
   v_count          number;

begin
   v_entry_by_empno := get_empno_from_meta_id(p_meta_id);
   if v_entry_by_empno = 'ERRRR' then
      p_message_type := 'KO';
      p_message_text := 'Invalid employee number';
      return;
   end if;

   select count(*) into v_count
     from ss_emp_for_onduty_swp
    where EMPNO = P_Empno;

   if v_count > 0 then
      p_message_type := 'OK';
      p_message_text := 'Employee is in swp onduty ';
      return;
   end if;

    exception
   when others then
      p_message_type := 'KO';
      p_message_text := 'Err - '
                        || sqlcode
                        || ' - '
                        || sqlerrm;
end sp_check_emp_onduty_swp;

End iot_onduty;
/
---------------------------
--New PACKAGE BODY
--IOT_SWP_EMP_TO_OFFICE_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_EMP_TO_OFFICE_QRY" as

   function fn_Emp_Coming_To_Office_list(
      p_person_id      varchar2,
      p_meta_id        varchar2,

      p_generic_search varchar2 default null,
      p_start_date     date     default null,

      p_row_number     number,
      p_page_length    number
   ) return sys_refcursor as
      P_PLAN_START_DATE    date;
      P_PLAN_END_DATE      date;
      P_CURR_START_DATE    date;
      P_CURR_END_DATE      date;
      P_PLANNING_EXISTS    varchar2(200);
      P_PWS_OPEN           varchar2(200);
      P_SWS_OPEN           varchar2(200);
      P_OWS_OPEN           varchar2(200);
      P_MESSAGE_TYPE       varchar2(200);
      P_MESSAGE_TEXT       varchar2(200);
      v_empno              varchar2(5);
      e_employee_not_found exception;
      pragma exception_init(e_employee_not_found, -20001);
      c                    sys_refcursor;
   begin

      v_empno := get_empno_from_meta_id(p_meta_id);
      if v_empno = 'ERRRR' then
         raise e_employee_not_found;
         return null;
      end if;

      IOT_SWP_COMMON.GET_PLANNING_WEEK_DETAILS(
         P_PERSON_ID       => P_PERSON_ID,
         P_META_ID         => P_META_ID,
         P_PLAN_START_DATE => P_PLAN_START_DATE,
         P_PLAN_END_DATE   => P_PLAN_END_DATE,
         P_CURR_START_DATE => P_CURR_START_DATE,
         P_CURR_END_DATE   => P_CURR_END_DATE,
         P_PLANNING_EXISTS => P_PLANNING_EXISTS,
         P_PWS_OPEN        => P_PWS_OPEN,
         P_SWS_OPEN        => P_SWS_OPEN,
         P_OWS_OPEN        => P_OWS_OPEN,
         P_MESSAGE_TYPE    => P_MESSAGE_TYPE,
         P_MESSAGE_TEXT    => P_MESSAGE_TEXT
      );

      if (P_MESSAGE_TYPE = 'KO') then
         return null;
      end if;

      open c for
           select * from (
           select Key_id , Empno , Employee_Name ,to_char(START_DATE, 'dd-Mon-yyyy') As Start_Date ,
                  Start_Date For_Order, Desk_Id , Modified_by , Modified_on_date ,
                  row_number() over (order by Empno desc) As row_number,
                  count(*) over () As total_row 
           from (
                    select A.Key_Id as Key_id,
                          A.Empno as Empno,
                          get_emp_name(A.Empno) as Employee_Name, 
                          A.Start_Date  as Start_Date,
                          '' as Desk_Id,
                          '' as Modified_by,
                          '' as Modified_on_date 
                     from Swp_Primary_Workspace A
                    where A.Primary_Workspace != 1
                      and A.Start_Date >= P_PLAN_START_DATE

                  union    
                      select '' as Key_id,
                          A.Empno as Empno,
                          get_emp_name(A.Empno) as Employee_Name, 
                          A.Start_Date  as Start_Date,
                          a.DESKID as Desk_Id,
                          case
                             when A.MODIFIED_BY = 'Sys' then
                                'System'
                             else
                                A.MODIFIED_BY
                                || ' - '
                                || get_emp_name(A.MODIFIED_BY)
                          end as Modified_by,
                          to_char(A.MODIFIED_ON, 'dd-Mon-yyyy') as Modified_on_date 
                     from SWP_TEMP_DESK_ALLOCATION A
                    where  A.Start_Date >= P_PLAN_START_DATE                    
                )
         )
          where row_number between (nvl(p_row_number, 0) + 1) and (nvl(p_row_number, 0) + p_page_length)
           order by For_Order ;

      return c;

   end;

end IOT_SWP_EMP_TO_OFFICE_QRY;
/
