--------------------------------------------------------
--  File created - Saturday-October-23-2021   
--------------------------------------------------------
---------------------------
--New PACKAGE
--IOT_DESK_DETAILS
---------------------------
CREATE OR REPLACE PACKAGE "IOT_DESK_DETAILS" As

    Procedure employee_desk_details(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_desk_id         Out Varchar2,
        p_comp_name       Out Varchar2,
        p_computer        Out Varchar2,
        p_pc_model        Out Varchar2,
        p_monitor1        Out Varchar2,
        p_monitor1_model  Out Varchar2,
        p_monitor2        Out Varchar2,
        p_monitor2_model  Out Varchar2,
        p_telephone       Out Varchar2,
        p_telephone_model Out Varchar2,
        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    );

End iot_desk_details;
/
---------------------------
--Changed PACKAGE BODY
--IOT_EXTRAHOURS
---------------------------
CREATE OR REPLACE PACKAGE BODY "IOT_EXTRAHOURS" As

    Procedure sp_create_claim(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,
        p_yyyymm                Varchar2,
        p_lead_approver         Varchar2,
        p_selected_compoff_days typ_tab_string,
        p_weekend_totals        typ_tab_string,
        p_sum_compoff_hrs       Number,
        p_sum_weekday_extra_hrs Number,
        p_sum_holiday_extra_hrs Number,
        p_message_type Out      Varchar2,
        p_message_text Out      Varchar2
    ) As
        v_app_no                Varchar2(13);
        v_empno                 Varchar2(5);
        e_employee_not_found    Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_yyyymm_date           Date;
        v_app_mm                Varchar2(2);
        v_app_yyyy              Varchar2(4);
        v_lead_apprl            Number;
        v_lead_apprd_ot         Number;
        v_lead_apprd_hhot       Number;
        v_lead_apprd_co         Number;
        v_lead_apprl_empno      Varchar2(5);
        v_day_date              Date;
        v_co_day                Number;
        v_pos                   Number;
        v_prev_pos              Number;
        v_week_claim_co         Number;
        v_week_claim_othh       Number;
        v_week_claim_otwrk      Number;
        v_week_applicable_otwrk Number;
        v_week_applicable_othh  Number;

    Begin
        v_empno            := get_empno_from_person_id(p_person_id);

        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return;
        End If;
        v_yyyymm_date      := to_date(p_yyyymm, 'yyyymm');
        v_app_mm           := substr(p_yyyymm, 5, 2);
        v_app_yyyy         := substr(p_yyyymm, 1, 4);
        v_app_no           := v_empno || '_' || v_app_mm || '_' || v_app_yyyy;
        If nvl(p_sum_compoff_hrs, 0) = 0 And nvl(p_sum_weekday_extra_hrs, 0) = 0 And nvl(p_sum_holiday_extra_hrs, 0) = 0 Then
            p_message_type := 'KO';
            p_message_text := 'CompOff/Extrahours not claimed. Cannot create claim.';
            Return;
        End If;
        v_lead_apprl_empno := upper(trim(p_lead_approver));
        If v_lead_apprl_empno = 'NONE' Then
            v_lead_apprl      := 4;
            v_lead_apprd_ot   := 0;
            v_lead_apprd_hhot := 0;
            v_lead_apprd_co   := 0;
        End If;
        Insert Into ss_otmaster (
            app_no,
            app_date,
            empno,
            mon,
            yyyy,
            month,
            ot,
            hhot,
            co,
            lead_apprl_empno,
            lead_apprl,
            lead_apprd_ot,
            lead_apprd_hhot,
            lead_apprd_co,
            hod_apprl,
            hrd_apprl
        )
        Values(
            v_app_no,
            sysdate,
            v_empno,
            v_app_mm,
            v_app_yyyy,
            to_char(v_yyyymm_date, 'Mon'),
            p_sum_weekday_extra_hrs,
            p_sum_holiday_extra_hrs,
            p_sum_compoff_hrs,
            v_lead_apprl_empno,
            v_lead_apprl,
            v_lead_apprd_ot,
            v_lead_apprd_hhot,
            v_lead_apprd_co,
            0,
            0
        );

        Insert Into ss_otdetail(
            empno,
            mon,
            yyyy,
            day,
            d_details,
            w_details,
            of_mon,
            app_no,
            wk_of_year,
            day_yyyy
        )
        Select
            v_empno,
            v_app_mm,
            v_app_yyyy,
            dd,
            to_char(punch_date, 'dd-Mon-yyyy') || ';' ||
            ddd || ';' ||
            shift_code || ';' ||
            first_punch || ';' ||
            last_punch || ';' ||
            to_hrs(wrk_hrs) || ';' ||
            to_hrs(delta_hrs) || ';' ||
            to_hrs(extra_hrs) || ';' ||
            remarks || ';' ||
            get_holiday(trunc(punch_date)) || ';' d_details,
            Case
                When is_sunday = 2 Then
                    wk_sum_work_hrs || ';' || wk_bfwd_delta_hrs || ';' || wk_cfwd_delta_hrs || ';' || wk_penalty_leave_hrs ||
                    ';' || wk_sum_delta_hrs || ';'
                Else
                    ''
            End                                   w_details,
            to_char(punch_date, 'mm'),
            v_app_no,
            wk_of_year,
            to_char(punch_date, 'yyyy')
        From
            Table(iot_punch_details.fn_punch_details_4_self(
                    p_person_id => p_person_id,
                    p_meta_id   => Null,
                    p_empno     => v_empno,
                    p_yyyymm    => p_yyyymm,
                    p_for_ot    => 'OK')
            );
        --p_message_type     := 'OK';
        --Return;
        For i In 1..p_selected_compoff_days.count

        Loop
            With
                csv As (
                    Select
                        p_selected_compoff_days(i) str
                    From
                        dual
                )
            Select
                to_date(regexp_substr(str, '[^,]+', 1, 1), 'dd-Mon-yyyy') c1,
                to_number(regexp_substr(str, '[^,]+', 1, 2))              c2
            Into
                v_day_date, v_pos
            From
                csv;
            Update
                ss_otdetail
            Set
                co_bool = 1
            Where
                app_no       = v_app_no
                And day_yyyy = to_char(v_day_date, 'yyyy')
                And of_mon   = to_char(v_day_date, 'mm')
                And day      = to_number(to_char(v_day_date, 'dd'));

        End Loop;
        /*
                p_message_type     := 'OK';
                Return;
        */
        For i In 1..p_weekend_totals.count
        Loop
            With
                csv As (
                    Select
                        p_weekend_totals(i) str
                    From
                        dual
                )
            Select
                to_date(regexp_substr(str, '[^,]+', 1, 1), 'dd-Mon-yyyy') c1,
                to_number(regexp_substr(str, '[^,]+', 1, 2))              c2,
                to_number(regexp_substr(str, '[^,]+', 1, 3))              c3,
                to_number(regexp_substr(str, '[^,]+', 1, 4))              c4,
                to_number(regexp_substr(str, '[^,]+', 1, 5))              c5,
                to_number(regexp_substr(str, '[^,]+', 1, 6))              c6
            Into
                v_day_date,
                v_week_claim_co,
                v_week_applicable_othh,
                v_week_claim_othh,
                v_week_applicable_otwrk,
                v_week_claim_otwrk
            From
                csv;
            Update
                ss_otdetail
            Set
                w_co = v_week_claim_co,
                w_ot_max = v_week_applicable_otwrk,
                w_ot_claim = v_week_claim_otwrk,
                w_hhot_max = v_week_applicable_othh,
                w_hhot_claim = v_week_claim_othh
            Where
                app_no       = v_app_no
                And day_yyyy = to_char(v_day_date, 'yyyy')
                And of_mon   = to_char(v_day_date, 'mm')
                And day      = to_number(to_char(v_day_date, 'dd'));
        End Loop;

        p_message_type     := 'OK';
    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_create_claim;

    Procedure sp_delete_claim(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_claim_no         Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin

        v_empno        := get_empno_from_person_id(p_person_id);

        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return;
        End If;
        Delete
            From ss_otdetail
        Where
            app_no = p_claim_no;
        Delete
            From ss_otmaster
        Where
            app_no = p_claim_no;
        Commit;
        p_message_type := 'OK';
        p_message_text := 'Claim deleted successfully.';
    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_claim;

    Procedure sp_extra_hrs_adjst_details(
        p_application_id         Varchar2,
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_emp_name           Out Varchar2,
        p_claim_no           Out Varchar2,

        p_claimed_ot         Out Varchar2,
        p_claimed_hhot       Out Varchar2,
        p_claimed_co         Out Varchar2,

        p_lead_approved_ot   Out Varchar2,
        p_lead_approved_hhot Out Varchar2,
        p_lead_approved_co   Out Varchar2,

        p_hod_approved_ot    Out Varchar2,
        p_hod_approved_hhot  Out Varchar2,
        p_hod_approved_co    Out Varchar2,

        p_hr_approved_ot     Out Varchar2,
        p_hr_approved_hhot   Out Varchar2,
        p_hr_approved_co     Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2
    ) As

        v_onduty_app ss_ondutyapp%rowtype;
        v_depu       ss_depu%rowtype;
        v_empno      Varchar2(5);
        v_count      Number;

    Begin

        Select
            Count(*)
        Into
            v_count
        From
            ss_otmaster
        Where
            Trim(app_no) = Trim(p_application_id);

        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Err - Invalid application id';
            Return;
        End If;

        Select
            e.empno || ' - ' || e.name,
            a.app_no,
            nvl(a.ot / 60, 0),
            nvl(a.hhot / 60, 0),
            nvl(a.co / 60, 0),
            nvl(a.lead_apprd_ot / 60, 0),
            nvl(a.lead_apprd_hhot, 0),
            nvl(a.lead_apprd_co, 0),
            nvl(a.hod_apprd_ot, 0),
            nvl(a.hod_apprd_hhot, 0),
            nvl(a.hod_apprd_co, 0),
            Case
                When nvl(a.hrd_apprd_ot, 0) = 0 Then
                    Null
                Else
                    a.hrd_apprd_ot
            End,
            Case
                When nvl(a.hrd_apprd_hhot, 0) = 0 Then
                    Null
                Else
                    a.hrd_apprd_hhot
            End,
            Case
                When nvl(a.hrd_apprd_co, 0) = 0 Then
                    Null
                Else
                    a.hrd_apprd_co
            End
        Into
            p_emp_name,
            p_claim_no,
            p_claimed_ot,
            p_claimed_hhot,
            p_claimed_co,
            p_lead_approved_ot,
            p_lead_approved_hhot,
            p_lead_approved_co,
            p_hod_approved_ot,
            p_hod_approved_hhot,
            p_hod_approved_co,
            p_hr_approved_ot,
            p_hr_approved_hhot,
            p_hr_approved_co
        From
            ss_otmaster a,
            ss_emplmast e
        Where
            a.empno      = e.empno
            And a.app_no = p_application_id;

        p_message_type := 'OK';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_extra_hrs_adjst_details;

    Procedure sp_claim_approval(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_approvals  typ_tab_string,
        p_approver_profile Number,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_app_no         Varchar2(70);
        v_approval       Number;
        v_remarks        Varchar2(70);
        v_count          Number;
        v_rec_count      Number;
        sqlpart1         Varchar2(60) := 'Update SS_OTMaster ';
        sqlpart2         Varchar2(500);
        sqlpart3         Varchar2(500);
        strsql           Varchar2(1000);
        v_otmaster_rec   ss_otmaster%rowtype;
        v_approver_empno Varchar2(5);
        v_user_tcp_ip    Varchar2(30);
        v_msg_type       Number;
        v_msg_text       Varchar2(1000);
    Begin

        v_approver_empno := get_empno_from_person_id(p_person_id);
        If v_approver_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        sqlpart3         := ' ';
        sqlpart2         := ' set ApproverProfile_APPRL = :Approval, ApproverProfile_Code = :Approver_EmpNo, ApproverProfile_APPRL_DT = Sysdate,
                    ApproverProfile_TCP_IP = :User_TCP_IP , ApproverProfile_Remarks = :Remarks ';
        If p_approver_profile = user_profile.type_hod Or p_approver_profile = user_profile.type_sec Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'HOD');

            sqlpart3 := sqlpart3 || ', HOD_Apprd_OT = Lead_Apprd_OT, ';
            sqlpart3 := sqlpart3 || 'HOD_Apprd_HHOT = Lead_Apprd_HHOT, ';
            sqlpart3 := sqlpart3 || 'HOD_Apprd_CO = Lead_Apprd_CO ';
        Elsif p_approver_profile = user_profile.type_hrd Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'HRD');

            sqlpart3 := sqlpart3 || ', HRD_Apprd_OT = HOD_Apprd_OT, ';
            sqlpart3 := sqlpart3 || 'HRD_Apprd_HHOT = HOD_Apprd_HHOT, ';
            sqlpart3 := sqlpart3 || 'HRD_Apprd_CO = HOD_Apprd_CO ';
        Elsif p_approver_profile = user_profile.type_lead Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'LEAD');

            sqlpart3 := sqlpart3 || ', Lead_Apprd_OT = OT, ';
            sqlpart3 := sqlpart3 || 'Lead_Apprd_HHOT = HHOT, ';
            sqlpart3 := sqlpart3 || 'Lead_Apprd_CO = CO ';
        End If;

        For i In 1..p_claim_approvals.count
        Loop

            With
                csv As (
                    Select
                        p_claim_approvals(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '[^~!~]+', 1, 1))            app_no,
                to_number(Trim(regexp_substr(str, '[^~!~]+', 1, 2))) approval
            Into
                v_app_no, v_approval
            From
                csv;

            /*
            p_message_type := 'OK';
            p_message_text := 'Debug 1 - ' || p_leave_approvals(i);
            Return;
            */
            strsql := sqlpart1 || ' ' || sqlpart2;

            If v_approval = ss.approved Then
                strsql := strsql || ' ' || sqlpart3;
            End If;
            strsql := strsql || '  Where App_No = :p_app_no';
            /*
            p_message_type := 'OK';
            p_message_text := 'Debug - ' || v_approval || ' - ' || strsql;
            Return;
            */
            Execute Immediate strsql
                Using v_approval, v_approver_empno, v_user_tcp_ip, v_remarks, trim(v_app_no);

            If p_approver_profile = user_profile.type_hrd And v_approval = ss.approved Then
                Select
                    *
                Into
                    v_otmaster_rec
                From
                    ss_otmaster
                Where
                    app_no = v_app_no;

                If nvl(v_otmaster_rec.hrd_apprd_co, 0) > 0 Then
                    Insert Into ss_leaveledg(
                        app_no,
                        app_date,
                        leavetype,
                        description,
                        empno,
                        leaveperiod,
                        db_cr,
                        bdate,
                        adj_type
                    )
                    Values(
                        v_app_no,
                        sysdate,
                        'CO',
                        'Compensatory Off Credit',
                        v_otmaster_rec.empno,
                        v_otmaster_rec.hrd_apprd_co / 60,
                        'C',
                        to_date(v_otmaster_rec.yyyy || v_otmaster_rec.mon, 'yyyymm'),
                        'CO'

                    );

                End If;
            End If;

        End Loop;

        Commit;
        p_message_type   := 'OK';
        p_message_text   := 'Procedure executed successfully.';
    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_claim_approval;

    Procedure sp_claim_approval_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin

        sp_claim_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_claim_approvals  => p_claim_approvals,
            p_approver_profile => user_profile.type_lead,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End sp_claim_approval_lead;

    Procedure sp_claim_approval_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_claim_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_claim_approvals  => p_claim_approvals,
            p_approver_profile => user_profile.type_hod,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End sp_claim_approval_hod;

    Procedure sp_claim_approval_hr(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_claim_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_claim_approvals  => p_claim_approvals,
            p_approver_profile => user_profile.type_hod,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End sp_claim_approval_hr;

    Procedure sp_claim_adjustment(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_no         Varchar2,
        p_approved_ot      Number,
        p_approved_hhot    Number,
        p_approved_co      Number,
        p_approver_profile Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_app_no         Varchar2(70);
        v_approval       Number;
        v_remarks        Varchar2(70);
        v_count          Number;
        v_rec_count      Number;
        sqlpart1         Varchar2(60) := 'Update SS_OTMaster ';
        sqlpart2         Varchar2(500);
        sqlpart3         Varchar2(500);
        strsql           Varchar2(1000);
        v_otmaster_rec   ss_otmaster%rowtype;
        v_approver_empno Varchar2(5);
        v_user_tcp_ip    Varchar2(30);
        v_msg_type       Number;
        v_msg_text       Varchar2(1000);
    Begin
        v_approver_empno := get_empno_from_person_id(p_person_id);
        If v_approver_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        v_app_no         := trim(p_claim_no);
        v_approval       := ss.approved;
        sqlpart2         := ' set ApproverProfile_APPRL = :Approval, ApproverProfile_Code = :Approver_EmpNo, ApproverProfile_APPRL_DT = Sysdate,
                    ApproverProfile_TCP_IP = :User_TCP_IP , ApproverProfile_Remarks = :Remarks ';
        sqlpart3         := ', ';
        sqlpart3         := sqlpart3 || ' ApproverProfile_Apprd_OT = :Apprd_OT, ';
        sqlpart3         := sqlpart3 || ' ApproverProfile_Apprd_HHOT = :Apprd_HHOT, ';
        sqlpart3         := sqlpart3 || ' ApproverProfile_Apprd_CO = :Apprd_CO ';

        strsql           := sqlpart1 || sqlpart2 || sqlpart3 || '  Where trim(App_No) = trim(:p_app_no)';

        If p_approver_profile = user_profile.type_hod Or p_approver_profile = user_profile.type_sec Then
            strsql := replace(strsql, 'ApproverProfile', 'HOD');

        Elsif p_approver_profile = user_profile.type_hrd Then
            strsql := replace(strsql, 'ApproverProfile', 'HRD');

        Elsif p_approver_profile = user_profile.type_lead Then
            strsql := replace(strsql, 'ApproverProfile', 'LEAD');

        End If;
        /*
        p_message_type   := 'OK';
        p_message_text   := strsql;
        return;
        */
        Execute Immediate strsql
            Using v_approval, v_approver_empno, v_user_tcp_ip, v_remarks, p_approved_ot, p_approved_hhot, p_approved_co, trim(
            v_app_no);
        If p_approver_profile = user_profile.type_hrd And v_approval = ss.approved Then
            Select
                *
            Into
                v_otmaster_rec
            From
                ss_otmaster
            Where
                app_no = v_app_no;

            If nvl(v_otmaster_rec.hrd_apprd_co, 0) > 0 Then
                Insert Into ss_leaveledg(
                    app_no,
                    app_date,
                    leavetype,
                    description,
                    empno,
                    leaveperiod,
                    db_cr,
                    bdate,
                    adj_type
                )
                Values(
                    v_app_no,
                    sysdate,
                    'CO',
                    'Compensatory Off Credit',
                    v_otmaster_rec.empno,
                    v_otmaster_rec.hrd_apprd_co / 60,
                    'C',
                    to_date(v_otmaster_rec.yyyy || v_otmaster_rec.mon, 'yyyymm'),
                    'CO'

                );

            End If;
        End If;

        Commit;
        p_message_type   := 'OK';
        p_message_text   := 'Procedure executed successfully.';
    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_claim_adjustment_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_no         Varchar2,
        p_approved_ot      Number,
        p_approved_hhot    Number,
        p_approved_co      Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_claim_adjustment(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_claim_no         => p_claim_no,
            p_approved_ot      => p_approved_ot,
            p_approved_hhot    => p_approved_hhot,
            p_approved_co      => p_approved_co,
            p_approver_profile => user_profile.type_lead,

            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End;

    Procedure sp_claim_adjustment_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_no         Varchar2,
        p_approved_ot      Number,
        p_approved_hhot    Number,
        p_approved_co      Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_claim_adjustment(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_claim_no         => p_claim_no,
            p_approved_ot      => p_approved_ot,
            p_approved_hhot    => p_approved_hhot,
            p_approved_co      => p_approved_co,
            p_approver_profile => user_profile.type_hod,

            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End;

    Procedure sp_claim_adjustment_hr(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_no         Varchar2,
        p_approved_ot      Number,
        p_approved_hhot    Number,
        p_approved_co      Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_claim_adjustment(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_claim_no         => p_claim_no,
            p_approved_ot      => p_approved_ot,
            p_approved_hhot    => p_approved_hhot,
            p_approved_co      => p_approved_co,
            p_approver_profile => user_profile.type_hrd,

            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End;

End iot_extrahours;
/
---------------------------
--New PACKAGE BODY
--IOT_DESK_DETAILS
---------------------------
CREATE OR REPLACE PACKAGE BODY "IOT_DESK_DETAILS" As
    Procedure employee_desk_details(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_desk_id         Out Varchar2,
        p_comp_name       Out Varchar2,
        p_computer        Out Varchar2,
        p_pc_model        Out Varchar2,
        p_monitor1        Out Varchar2,
        p_monitor1_model  Out Varchar2,
        p_monitor2        Out Varchar2,
        p_monitor2_model  Out Varchar2,
        p_telephone       Out Varchar2,
        p_telephone_model Out Varchar2,
        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno        := get_empno_from_person_id(p_person_id);

        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return;
        End If;
        Select
            a.deskid,
            --a.office,
            a.compname,
            a.computer,
            a.pcmodel,
            a.monitor1,
            a.monmodel1,
            a.monitor2,
            a.monmodel2,
            a.telephone,
            a.telmodel
        Into
            p_desk_id,
            p_comp_name,
            p_computer,
            p_pc_model,
            p_monitor1,
            p_monitor2,
            p_monitor1_model,
            p_monitor2_model,
            p_telephone,
            p_telephone_model
        From
            dms.desmas_allocation_all a
        Where
            a.empno1 = v_empno;
        p_message_type := 'OK';
    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;
End;
/
