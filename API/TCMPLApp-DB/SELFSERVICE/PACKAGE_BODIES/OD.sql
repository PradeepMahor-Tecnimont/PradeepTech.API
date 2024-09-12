--------------------------------------------------------
--  DDL for Package Body OD
--------------------------------------------------------

Create Or Replace Package Body selfservice.od As

    Procedure add_to_depu(
        p_empno          Varchar2,
        p_depu_type      Varchar2,
        p_bdate          Date,
        p_edate          Date,
        p_entry_by_empno Varchar2,
        p_lead_approver  Varchar2,
        p_user_ip        Varchar2,
        p_reason         Varchar2,
        p_success Out    Varchar2,
        p_message Out    Varchar2
    );

    Procedure set_variables_4_entry_by(
        p_entry_by_empno      Varchar2,
        p_entry_by_hr         Varchar2,
        p_entry_by_hr_4_self  Varchar2,
        p_lead_empno   In Out Varchar2,
        p_lead_apprl   Out    Varchar2,
        p_hod_empno    Out    Varchar2,
        p_hod_apprl    Out    Varchar2,
        p_hod_ip       Out    Varchar2,
        p_hrd_empno    Out    Varchar2,
        p_hrd_apprl    Out    Varchar2,
        p_hrd_ip       In Out Varchar2,
        p_hod_apprl_dt Out    Date,
        p_hrd_apprl_dt Out    Date
    ) As
        v_hr_ip    Varchar2(20);
        v_hr_empno Varchar2(5);
    Begin
        v_hr_ip        := p_hrd_ip;
        p_hod_apprl    := 0;
        p_hrd_apprl    := 0;
        p_lead_apprl   := 0;
        p_hrd_ip       := Null;
        --
        If lower(p_lead_empno) = 'none' Then
            p_lead_apprl := ss.apprl_none;
        End If;
        If nvl(p_entry_by_hr, 'KO') != 'OK' Or nvl(p_entry_by_hr_4_self, 'KO') = 'OK' Then
            Return;
        End If;
        --

        p_lead_empno   := 'None';
        p_lead_apprl   := ss.apprl_none;
        --
        p_hod_empno    := p_entry_by_empno;
        p_hrd_empno    := p_entry_by_empno;
        --
        p_hod_apprl    := ss.approved;
        p_hrd_apprl    := ss.approved;
        --p_lead_apprl   := 0;
        p_hod_ip       := v_hr_ip;
        p_hrd_ip       := v_hr_ip;
        --
        p_hod_apprl_dt := sysdate;
        p_hrd_apprl_dt := sysdate;
    End;

    Procedure prc_add_onduty_type_1(
        p_empno            Varchar2,
        p_od_type          Varchar2,
        p_od_sub_type      Varchar2,
        p_pdate            Varchar2,
        p_hh               Number,
        p_mi               Number,
        p_hh1              Number,
        p_mi1              Number,
        p_lead_approver    Varchar2,
        p_reason           Varchar2,
        p_entry_by         Varchar2,
        p_entry_by_profile Number Default Null,
        p_user_ip          Varchar2,
        p_success Out      Varchar2,
        p_message Out      Varchar2
    ) As

        v_pdate                 Date;
        v_count                 Number;
        v_empno                 Varchar2(5);
        v_entry_by              Varchar2(5);
        v_od_catg               Number;
        v_onduty_row            ss_vu_ondutyapp%rowtype;
        v_rec_no                Number;
        v_app_no                Varchar2(60);
        v_now                   Date;
        v_is_office_ip          Varchar2(10);
        v_entry_by_user_profile Number;
        v_is_entry_by_hr        Varchar2(2);
        v_is_entry_by_hr_4_self Varchar2(2);
        v_lead_approver         Varchar2(5);
        v_lead_approval         Number;
        v_hod_empno             Varchar2(5);
        v_hod_ip                Varchar2(30);
        v_hod_apprl             Number;
        v_hod_apprl_dt          Date;
        v_hrd_empno             Varchar2(5);
        v_hrd_ip                Varchar2(30);
        v_hrd_apprl             Number;
        v_hrd_apprl_dt          Date;
        v_appl_desc             Varchar2(60);
        v_dd                    Varchar2(2);
        v_mon                   Varchar2(2);
        v_yyyy                  Varchar2(4);
    Begin
        v_pdate                 := To_Date(p_pdate, 'yyyymmdd');
        v_dd                    := to_char(v_pdate, 'dd');
        v_mon                   := to_char(v_pdate, 'MM');
        v_yyyy                  := to_char(v_pdate, 'YYYY');
        --Check Employee Exists
        v_empno                 := substr('0000' || trim(p_empno), -5);
        v_entry_by              := substr('0000' || trim(p_entry_by), -5);
        v_lead_approver :=
            Case lower(p_lead_approver)
                When 'none' Then
                    'None'
                Else
                    lpad(p_lead_approver, 5, '0')
            End;

        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno = v_empno;

        If v_count = 0 Then
            p_success := 'KO';
            p_message := 'Employee not found in Database.' || v_empno || ' - ' || p_empno;
            Return;
        End If;

        If v_lead_approver != 'None' Then
            Select
                Count(*)
            Into
                v_count
            From
                ss_emplmast
            Where
                empno = v_lead_approver;

            If v_count = 0 Then
                p_success := 'KO';
                p_message := 'Lead approver not found in Database.';
                Return;
            End If;

        End If;

        p_message               := 'Debug - A1';
        Select
            tabletag
        Into
            v_od_catg
        From
            ss_ondutymast
        Where
            type = p_od_type;

        If v_od_catg != 2 Then
            p_success := 'KO';
            p_message := 'Invalid OnDuty Type.';
            Return;
        End If;

        If p_od_type In ('LE', 'SL') Then
        
            Select
                Count(*)
            Into
                v_count
            From
                ss_otdetail
            Where
                empno    = p_empno
                And yyyy = to_char(v_pdate, 'yyyy')
                And mon   = to_char(v_pdate, 'mm')
                And day   = to_number(to_char(v_pdate, 'dd'));
            If v_count > 0 Then
                p_success := not_ok;
                p_message := 'Your are not allowed to submit late come / short leave application, as you have already summited Extra hour claim the said period.';
                Return;
            End If;

null;
        End If;

        p_message               := 'Debug - A2';
        --
        --  * * * * * * * * * * * 
        v_now                   := sysdate;
        Begin
            Select
                *
            Into
                v_onduty_row
            From
                (
                    Select
                        *
                    From
                        ss_vu_ondutyapp
                    Where
                        empno                         = v_empno
                        And app_date In (
                            Select
                                Max(app_date)
                            From
                                ss_vu_ondutyapp
                            Where
                                empno = v_empno
                        )
                        And to_char(app_date, 'yyyy') = to_char(sysdate, 'yyyy')
                    Order By app_no Desc
                )
            Where
                Rownum = 1;

            v_rec_no := To_Number(substr(v_onduty_row.app_no, instr(v_onduty_row.app_no, '/', -1) + 1));
        --p_message := 'Debug - A3';

        Exception
            When Others Then
                v_rec_no := 0;
        End;

        v_rec_no                := v_rec_no + 1;
        v_app_no                := 'OD/' || v_empno || '/' || to_char(v_now, 'yyyymmdd') || '/' || lpad(v_rec_no, 4, '0');

        Select
            Count(*)
        Into
            v_count
        From
            ss_vu_ondutyapp
        Where
            app_no = v_app_no;

        If v_count <> 0 Then
            p_success := 'KO';
            p_message := 'There was an unexpected error. Please contact SELFSERVICE-ADMINISTRATOR';
            Return;
        End If;

        p_message               := 'Debug - A3';
        v_entry_by_user_profile := p_entry_by_profile;
        If v_entry_by_user_profile = user_profile.type_hrd Then
            v_is_entry_by_hr := 'OK';
            If v_entry_by = v_empno Then
                v_is_entry_by_hr_4_self := 'OK';
            End If;
            v_hrd_ip         := p_user_ip;
        Else
            v_is_entry_by_hr := 'KO';
        End If;
        --p_message := 'Debug - A4';

        v_appl_desc             := 'Appl for Punch Entry of ' ||
                                   to_char(v_pdate, 'dd-Mon-yyyy') ||
                                   ' Time ' || lpad(p_hh, 2, '00') || ':' || lpad(p_mi, 2, '00');
        If p_hh1 Is Not Null Then
            v_appl_desc := v_appl_desc || ' - ' || lpad(p_hh1, 2, '00') || ':' || lpad(p_mi1, 2, '00');
        End If;
        v_appl_desc             := replace(trim(v_appl_desc), ' - 0:0');
        set_variables_4_entry_by(
            p_entry_by_empno     => v_entry_by,
            p_entry_by_hr        => v_is_entry_by_hr,
            p_entry_by_hr_4_self => v_is_entry_by_hr_4_self,
            p_lead_empno         => v_lead_approver,
            p_lead_apprl         => v_lead_approval,
            p_hod_empno          => v_hod_empno,
            p_hod_apprl          => v_hod_apprl,
            p_hod_ip             => v_hod_ip,
            p_hrd_empno          => v_hrd_empno,
            p_hrd_apprl          => v_hrd_apprl,
            p_hrd_ip             => v_hrd_ip,
            p_hod_apprl_dt       => v_hod_apprl_dt,
            p_hrd_apprl_dt       => v_hrd_apprl_dt
        );
        --p_message := 'Debug - A5 - ' || v_empno || ' - ' || v_pdate || ' - ' || p_hh || ' - ' || p_mi || ' - ' || p_hh1 || ' - ' || p_mi1 || ' - ODSubType - ' || p_od_sub_type ;

        --If p_od_type = 'LE' And v_is_entry_by_hr = 'KO' Then
        If p_od_type = 'LE' Then
            v_lead_approver := 'None';
            v_lead_approval := 4;
            v_hod_apprl     := 1;
            v_hod_apprl_dt  := v_now;
            v_hod_empno     := v_entry_by;
            v_hod_ip        := p_user_ip;
        End If;

        Insert Into ss_ondutyapp (
            empno,
            app_no,
            app_date,
            hh,
            mm,
            hh1,
            mm1,
            pdate,
            dd,
            mon,
            yyyy,
            type,
            description,
            odtype,
            reason,
            user_tcp_ip,
            hod_apprl,
            hod_apprl_dt,
            hod_tcp_ip,
            hod_code,
            lead_apprl_empno,
            lead_apprl,
            hrd_apprl,
            hrd_tcp_ip,
            hrd_code,
            hrd_apprl_dt
        )
        Values (
            v_empno,
            v_app_no,
            v_now,
            p_hh,
            p_mi,
            p_hh1,
            p_mi1,
            v_pdate,
            v_dd,
            v_mon,
            v_yyyy,
            p_od_type,
            v_appl_desc,
            nvl(p_od_sub_type, 0),
            p_reason,
            p_user_ip,
            v_hod_apprl,
            v_hod_apprl_dt,
            v_hod_ip,
            v_hod_empno,
            v_lead_approver,
            v_lead_approval,
            v_hrd_apprl,
            v_hrd_ip,
            v_hrd_empno,
            v_hrd_apprl_dt
        );

        p_success               := 'OK';
        p_message               := 'Your application has been saved successfull. Applicaiton Number :- ' || v_app_no;
        Commit;
        If v_entry_by_user_profile != user_profile.type_hrd Then
            Return;
        End If;
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
                app_no = v_app_no
        );
        --p_message := 'Debug - A7';

        If p_od_type Not In ('IO', 'OD') Then
            Return;
        End If;
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
                app_no = v_app_no
        );

        p_message               := 'Debug - A8';
        generate_auto_punch_4od(v_app_no);
        --p_message := 'Debug - A9';
        p_success               := 'OK';
        p_message               := 'Your application has been saved successfull. Applicaiton Number :- ' || v_app_no;
    Exception
        When dup_val_on_index Then
            p_success := 'KO';
            p_message := 'Duplicate values found cannot proceed.' || ' - ' || p_message;
        When Others Then
            p_success := 'KO';
            p_message := 'ERR :- ' || sqlcode || ' - ' || sqlerrm || ' - ' || p_message;
        --p_message := p_message || 

    End prc_add_onduty_type_1;

    Procedure nu_app_send_mail(
        param_app_no      Varchar2,
        param_success Out Number,
        param_message Out Varchar2
    ) As

        v_count      Number;
        v_lead_code  Varchar2(5);
        v_lead_apprl Number;
        v_empno      Varchar2(5);
        v_email_id   Varchar2(60);
        vsubject     Varchar2(100);
        vbody        Varchar2(5000);
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ss_ondutyapp
        Where
            Trim(app_no) = Trim(param_app_no);

        If v_count <> 1 Then
            Return;
        End If;
        Select
            lead_code,
            lead_apprl,
            empno
        Into
            v_lead_code,
            v_lead_apprl,
            v_empno
        From
            ss_ondutyapp
        Where
            Trim(app_no) = Trim(param_app_no);

        If trim(nvl(v_lead_code, ss.lead_none)) = trim(ss.lead_none) Then
            Select
                email
            Into
                v_email_id
            From
                ss_emplmast
            Where
                empno = (
                    Select
                        mngr
                    From
                        ss_emplmast
                    Where
                        empno = v_empno
                );

        Else
            Select
                email
            Into
                v_email_id
            From
                ss_emplmast
            Where
                empno = v_lead_code;

        End If;

        If v_email_id Is Null Then
            param_success := ss.failure;
            param_message := 'Email Id of the approver found blank. Cannot send email.';
            Return;
        End If;
        --v_email_id := 'd.bhavsar@ticb.com';

        vsubject := 'Application of ' || v_empno;
        vbody    := 'There is ' || vsubject || '. Kindly click the following URL to do the needful.';
        vbody    := vbody || '!nuLine!' || ss.application_url || '/SS_OD.asp?App_No=' || param_app_no;

        vbody    := vbody || '!nuLine!' || '!nuLine!' || '!nuLine!' || '!nuLine!' || 'Note : This is a system generated message.';

        ss_mail.send_mail(
            v_email_id,
            vsubject,
            vbody,
            param_success,
            param_message
        );
    End nu_app_send_mail;

    Procedure approve_od(
        param_array_app_no     Varchar2,
        param_array_rem        Varchar2,
        param_array_od_type    Varchar2,
        param_array_apprl_type Varchar2,
        param_approver_profile Number,
        param_approver_code    Varchar2,
        param_approver_ip      Varchar2,
        param_success Out      Varchar2,
        param_message Out      Varchar2
    ) As

        onduty      Constant Number := 2;
        deputation  Constant Number := 3;
        v_count     Number;
        Type type_app Is
            Table Of Varchar2(30) Index By Binary_Integer;
        Type type_rem Is
            Table Of Varchar2(31) Index By Binary_Integer;
        Type type_od Is
            Table Of Varchar2(3) Index By Binary_Integer;
        Type type_apprl Is
            Table Of Varchar2(3) Index By Binary_Integer;
        tab_app     type_app;
        tab_rem     type_rem;
        tab_od      type_od;
        tab_apprl   type_apprl;
        v_rec_count Number;
        sqlpartod   Varchar2(60)    := 'Update SS_OnDutyApp ';
        sqlpartdp   Varchar2(60)    := 'Update SS_Depu ';
        sqlpart2    Varchar2(500);
        strsql      Varchar2(600);
    Begin
        sqlpart2      := ' set ApproverProfile_APPRL = :Approval, ApproverProfile_Code = :Approver_EmpNo, ApproverProfile_APPRL_DT = Sysdate,
                    ApproverProfile_TCP_IP = :User_TCP_IP , ApproverProfileREASON = :Reason where App_No = :paramAppNo';
        If param_approver_profile = user_profile.type_hod Or param_approver_profile = user_profile.type_sec Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'HOD');
        Elsif param_approver_profile = user_profile.type_hrd Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'HRD');
        Elsif param_approver_profile = user_profile.type_lead Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'LEAD');
        End If;

        With
            tab As (
                Select
                    param_array_app_no As txt_app
                From
                    dual
            )
        Select
            regexp_substr(txt_app, '[^,]+', 1, level)
        Bulk Collect
        Into
            tab_app
        From
            tab
        Connect By
            level <= length(regexp_replace(txt_app, '[^,]*'));

        v_rec_count   := Sql%rowcount;
        With
            tab As (
                Select
                    '  ' || param_array_rem As txt_rem
                From
                    dual
            )
        Select
            regexp_substr(txt_rem, '[^,]+', 1, level)
        Bulk Collect
        Into
            tab_rem
        From
            tab
        Connect By
            level <= length(regexp_replace(txt_rem, '[^,]*')) + 1;

        With
            tab As (
                Select
                    param_array_od_type As txt_od
                From
                    dual
            )
        Select
            regexp_substr(txt_od, '[^,]+', 1, level)
        Bulk Collect
        Into
            tab_od
        From
            tab
        Connect By
            level <= length(regexp_replace(txt_od, '[^,]*')) + 1;

        With
            tab As (
                Select
                    param_array_apprl_type As txt_apprl
                From
                    dual
            )
        Select
            regexp_substr(txt_apprl, '[^,]+', 1, level)
        Bulk Collect
        Into
            tab_apprl
        From
            tab
        Connect By
            level <= length(regexp_replace(txt_apprl, '[^,]*')) + 1;

        For indx In 1..tab_app.count
        Loop
            If To_Number(tab_od(indx)) = deputation Then
                strsql := sqlpartdp || ' ' || sqlpart2;
            Elsif To_Number(tab_od(indx)) = onduty Then
                strsql := sqlpartod || ' ' || sqlpart2;
            End If;

            Execute Immediate strsql
                Using trim(tab_apprl(indx)), param_approver_code, param_approver_ip, trim(tab_rem(indx)), trim(tab_app(indx));

            If tab_od(indx) = onduty Then
                --IF 1=2 Then
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
                        Trim(app_no)                   = Trim(tab_app(indx))
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
                        Trim(app_no)                   = Trim(tab_app(indx))
                        And (type                      = 'OD'
                            Or type                    = 'IO')
                        And nvl(hrd_apprl, ss.pending) = ss.approved
                );

                If param_approver_profile = user_profile.type_hrd And To_Number(tab_apprl(indx)) = ss.approved Then
                    generate_auto_punch_4od(trim(tab_app(indx)));
                End If;

            End If;

        End Loop;

        Commit;
        param_success := 'SUCCESS';
    Exception
        When Others Then
            param_success := 'FAILURE';
            param_message := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure add_onduty_type_2(
        p_empno         Varchar2,
        p_od_type       Varchar2,
        p_b_yyyymmdd    Varchar2,
        p_e_yyyymmdd    Varchar2,
        p_entry_by      Varchar2,
        p_lead_approver Varchar2,
        p_user_ip       Varchar2,
        p_reason        Varchar2,
        p_success Out   Varchar2,
        p_message Out   Varchar2
    ) As

        v_count         Number;
        v_empno         Varchar2(5);
        v_entry_by      Varchar2(5);
        v_lead_approver Varchar2(5);
        v_od_catg       Number;
        v_bdate         Date;
        v_edate         Date;
    Begin
        --Check Employee Exists
        v_empno    := substr('0000' || p_empno, -5);
        v_entry_by := substr('0000' || p_entry_by, -5);
        v_lead_approver :=
            Case lower(p_lead_approver)
                When 'none' Then
                    'None'
                Else
                    lpad(p_lead_approver, 5, '0')
            End;

        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno = v_empno;

        If v_count = 0 Then
            p_success := 'KO';
            p_message := 'Employee not found in Database.' || v_empno || ' - ' || p_empno;
            Return;
        End If;

        v_bdate    := To_Date(p_b_yyyymmdd, 'yyyymmdd');
        v_edate    := To_Date(p_e_yyyymmdd, 'yyyymmdd');
        If v_edate < v_bdate Then
            p_success := 'KO';
            p_message := 'Incorrect date range specified';
            Return;
        End If;

        If v_lead_approver != 'None' Then
            Select
                Count(*)
            Into
                v_count
            From
                ss_emplmast
            Where
                empno = v_lead_approver;

            If v_count = 0 Then
                p_success := 'KO';
                p_message := 'Lead approver not found in Database.';
                Return;
            End If;

        End If;

        Select
            tabletag
        Into
            v_od_catg
        From
            ss_ondutymast
        Where
            type = p_od_type;

        If v_od_catg In (-1, 3) Then
            add_to_depu(
                p_empno          => v_empno,
                p_depu_type      => p_od_type,
                p_bdate          => v_bdate,
                p_edate          => v_edate,
                p_entry_by_empno => v_entry_by,
                p_lead_approver  => v_lead_approver,
                p_user_ip        => p_user_ip,
                p_reason         => p_reason,
                p_success        => p_success,
                p_message        => p_message
            );
        Else
            p_success := 'KO';
            p_message := 'Invalid OnDuty Type.';
            Return;
        End If;

    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure add_to_depu(
        p_empno          Varchar2,
        p_depu_type      Varchar2,
        p_bdate          Date,
        p_edate          Date,
        p_entry_by_empno Varchar2,
        p_lead_approver  Varchar2,
        p_user_ip        Varchar2,
        p_reason         Varchar2,
        p_success Out    Varchar2,
        p_message Out    Varchar2
    ) As

        v_count                 Number;
        v_depu_row              ss_depu%rowtype;
        v_rec_no                Number;
        v_app_no                Varchar2(60);
        v_now                   Date;
        v_is_office_ip          Varchar2(10);
        v_entry_by_user_profile Number;
        v_is_entry_by_hr        Varchar2(2);
        v_is_entry_by_hr_4_self Varchar2(2);
        v_lead_approver         Varchar2(5);
        v_lead_approval         Number;
        v_hod_empno             Varchar2(5);
        v_hod_ip                Varchar2(30);
        v_hod_apprl             Number;
        v_hod_apprl_dt          Date;
        v_hrd_empno             Varchar2(5);
        v_hrd_ip                Varchar2(30);
        v_hrd_apprl             Number;
        v_hrd_apprl_dt          Date;
        v_appl_desc             Varchar2(60);
        v_curr_app_no           Varchar2(60);
    Begin
        v_now                   := sysdate;
        v_lead_approver         := p_lead_approver;
        v_hrd_ip                := p_user_ip;

        Begin
            /*
                Select
                    *
                Into
                    v_depu_row
                From
                    (
                        Select
                            *
                        From
                            ss_depu
                        Where
                            empno                         = p_empno
                            And app_date In (
                                Select
                                    Max(app_date)
                                From
                                    ss_depu
                                Where
                                    empno = p_empno
                            )
                            And to_char(app_date, 'yyyy') = to_char(v_now, 'yyyy')
                        Order By app_no Desc
                    )
                Where
                    Rownum = 1;
*/
            Select
                app_no
            Into
                v_curr_app_no
            From
                (
                    Select
                        app_no, app_date
                    From
                        (
                            Select
                                app_no, app_date
                            From
                                ss_depu
                            Union
                            Select
                                app_no, app_date
                            From
                                ss_depu_rejected
                        )
                    Where
                        app_date Between trunc(sysdate, 'YEAR')
                        And last_day(add_months(trunc(sysdate, 'YEAR'), 11))
                    Order By app_date Desc, app_no Desc
                )
            Where
                Rownum = 1;
            --v_rec_no := to_number(substr(v_depu_row.app_no, instr(v_depu_row.app_no, '/', -1) + 1));
            v_rec_no := To_Number(substr(v_curr_app_no, instr(v_curr_app_no, '/', -1) + 1));

        Exception
            When Others Then
                p_message := sqlcode || ' - ' || sqlerrm;
                v_rec_no  := 0;
        End;

        v_rec_no                := v_rec_no + 1;
        /*
        If p_depu_type = 'WF' Then
            v_is_office_ip := self_attendance.valid_office_ip(p_user_ip);
            If v_is_office_ip = 'KO' Then
                p_success   := 'KO';
                p_message   := 'This utility is applicable from selected PC''s in TCMPL Mumbai Office';
                return;
            End If;

        End If;
        */
        v_entry_by_user_profile := user_profile.get_profile(p_entry_by_empno);
        If v_entry_by_user_profile = user_profile.type_hrd Then
            v_is_entry_by_hr := 'OK';
            If p_entry_by_empno = p_empno Then
                v_is_entry_by_hr_4_self := 'OK';
            End If;
        End If;

        If p_depu_type = 'HT' Then
     --Home Town
            v_appl_desc := 'Punch HomeTown';
        Elsif p_depu_type = 'DP' Then
     --Deputation
            v_appl_desc := 'Punch Deputation';
        Elsif p_depu_type = 'TR' Then
     --ON Tour
            v_appl_desc := 'Punch Tour';
        Elsif p_depu_type = 'VS' Then
     --Visa Problem
            v_appl_desc := 'Punch Visa Problem';
        Elsif p_depu_type = 'RW' Then
     --Visa Problem
            v_appl_desc := 'Punch Remote Work';
        End If;

        v_appl_desc             := v_appl_desc || ' from ' || to_char(p_bdate, 'dd-Mon-yyyy') || ' To ' || to_char(p_edate,
        'dd-Mon-yyyy');

        set_variables_4_entry_by(
            p_entry_by_empno     => p_entry_by_empno,
            p_entry_by_hr        => v_is_entry_by_hr,
            p_entry_by_hr_4_self => v_is_entry_by_hr_4_self,
            p_lead_empno         => v_lead_approver,
            p_lead_apprl         => v_lead_approval,
            p_hod_empno          => v_hod_empno,
            p_hod_apprl          => v_hod_apprl,
            p_hod_ip             => v_hod_ip,
            p_hrd_empno          => v_hrd_empno,
            p_hrd_apprl          => v_hrd_apprl,
            p_hrd_ip             => v_hrd_ip,
            p_hod_apprl_dt       => v_hod_apprl_dt,
            p_hrd_apprl_dt       => v_hrd_apprl_dt
        );

        v_app_no                := 'DP/' || p_empno || '/' || to_char(v_now, 'yyyymmdd') || '/' || lpad(v_rec_no, 4, '0');

        Insert Into ss_depu (
            empno,
            app_no,
            app_date,
            bdate,
            edate,
            description,
            type,
            reason,
            user_tcp_ip,
            hod_apprl,
            hod_apprl_dt,
            hod_code,
            hod_tcp_ip,
            hrd_apprl,
            hrd_apprl_dt,
            hrd_code,
            hrd_tcp_ip,
            lead_apprl,
            lead_apprl_empno
        )
        Values (
            p_empno,
            v_app_no,
            v_now,
            p_bdate,
            p_edate,
            v_appl_desc,
            p_depu_type,
            p_reason,
            p_user_ip,
            v_hod_apprl,
            v_hod_apprl_dt,
            v_hod_empno,
            v_hod_ip,
            v_hrd_apprl,
            v_hrd_apprl_dt,
            v_hrd_empno,
            v_hrd_ip,
            v_lead_approval,
            v_lead_approver
        );

        p_success               := 'OK';
        p_message               := 'Your application has been saved successfull. Applicaiton Number :- ' || v_app_no;
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure old_add_onduty_type_1(
        p_empno         Varchar2,
        p_od_type       Varchar2,
        p_od_sub_type   Varchar2,
        p_pdate         Varchar2,
        p_hh            Number,
        p_mi            Number,
        p_hh1           Number,
        p_mi1           Number,
        p_lead_approver Varchar2,
        p_reason        Varchar2,
        p_entry_by      Varchar2,
        p_user_ip       Varchar2,
        p_success Out   Varchar2,
        p_message Out   Varchar2
    ) As

        v_pdate                 Date;
        v_count                 Number;
        v_empno                 Varchar2(5);
        v_entry_by              Varchar2(5);
        v_od_catg               Number;
        v_onduty_row            ss_vu_ondutyapp%rowtype;
        v_rec_no                Number;
        v_app_no                Varchar2(60);
        v_now                   Date;
        v_is_office_ip          Varchar2(10);
        v_entry_by_user_profile Number;
        v_is_entry_by_hr        Varchar2(2);
        v_is_entry_by_hr_4_self Varchar2(2);
        v_lead_approver         Varchar2(5);
        v_lead_approval         Number;
        v_hod_empno             Varchar2(5);
        v_hod_ip                Varchar2(30);
        v_hod_apprl             Number;
        v_hod_apprl_dt          Date;
        v_hrd_empno             Varchar2(5);
        v_hrd_ip                Varchar2(30);
        v_hrd_apprl             Number;
        v_hrd_apprl_dt          Date;
        v_appl_desc             Varchar2(60);
        v_dd                    Varchar2(2);
        v_mon                   Varchar2(2);
        v_yyyy                  Varchar2(4);
    Begin
        v_pdate                 := To_Date(p_pdate, 'yyyymmdd');
        v_dd                    := to_char(v_pdate, 'dd');
        v_mon                   := to_char(v_pdate, 'MM');
        v_yyyy                  := to_char(v_pdate, 'YYYY');
        --Check Employee Exists
        v_empno                 := substr('0000' || trim(p_empno), -5);
        v_entry_by              := substr('0000' || trim(p_entry_by), -5);
        v_lead_approver :=
            Case lower(p_lead_approver)
                When 'none' Then
                    'None'
                Else
                    lpad(p_lead_approver, 5, '0')
            End;

        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno = v_empno;

        If v_count = 0 Then
            p_success := 'KO';
            p_message := 'Employee not found in Database.' || v_empno || ' - ' || p_empno;
            Return;
        End If;

        If v_lead_approver != 'None' Then
            Select
                Count(*)
            Into
                v_count
            From
                ss_emplmast
            Where
                empno = v_lead_approver;

            If v_count = 0 Then
                p_success := 'KO';
                p_message := 'Lead approver not found in Database.';
                Return;
            End If;

        End If;

        p_message               := 'Debug - A1';
        Select
            tabletag
        Into
            v_od_catg
        From
            ss_ondutymast
        Where
            type = p_od_type;

        If v_od_catg != 2 Then
            p_success := 'KO';
            p_message := 'Invalid OnDuty Type.';
            Return;
        End If;

        p_message               := 'Debug - A2';
        --
        --  * * * * * * * * * * * 
        v_now                   := sysdate;
        Begin
            Select
                *
            Into
                v_onduty_row
            From
                (
                    Select
                        *
                    From
                        ss_vu_ondutyapp
                    Where
                        empno                         = v_empno
                        And app_date In (
                            Select
                                Max(app_date)
                            From
                                ss_vu_ondutyapp
                            Where
                                empno = v_empno
                        )
                        And to_char(app_date, 'yyyy') = to_char(sysdate, 'yyyy')
                    Order By app_no Desc
                )
            Where
                Rownum = 1;

            v_rec_no := To_Number(substr(v_onduty_row.app_no, instr(v_onduty_row.app_no, '/', -1) + 1));
        --p_message := 'Debug - A3';

        Exception
            When Others Then
                v_rec_no := 0;
        End;

        v_rec_no                := v_rec_no + 1;
        v_app_no                := 'OD/' || v_empno || '/' || to_char(v_now, 'yyyymmdd') || '/' || lpad(v_rec_no, 4, '0');

        Select
            Count(*)
        Into
            v_count
        From
            ss_vu_ondutyapp
        Where
            app_no = v_app_no;

        If v_count <> 0 Then
            p_success := 'KO';
            p_message := 'There was an unexpected error. Please contact SELFSERVICE-ADMINISTRATOR';
            Return;
        End If;

        p_message               := 'Debug - A3';
        v_entry_by_user_profile := user_profile.get_profile(v_entry_by);
        If v_entry_by_user_profile = user_profile.type_hrd Then
            v_is_entry_by_hr := 'OK';
            If v_entry_by = v_empno Then
                v_is_entry_by_hr_4_self := 'OK';
            End If;
            v_hrd_ip         := p_user_ip;
        Else
            v_is_entry_by_hr := 'KO';
        End If;
        --p_message := 'Debug - A4';

        v_appl_desc             := 'Appl for Punch Entry of ' ||
                                   to_char(v_pdate, 'dd-Mon-yyyy') ||
                                   ' Time ' || lpad(p_hh, 2, '00') || ':' || lpad(p_mi, 2, '00');
        If p_hh1 Is Not Null Then
            v_appl_desc := v_appl_desc || ' - ' || lpad(p_hh1, 2, '00') || ':' || lpad(p_mi1, 2, '00');
        End If;
        v_appl_desc             := replace(trim(v_appl_desc), ' - 0:0');
        set_variables_4_entry_by(
            p_entry_by_empno     => v_entry_by,
            p_entry_by_hr        => v_is_entry_by_hr,
            p_entry_by_hr_4_self => v_is_entry_by_hr_4_self,
            p_lead_empno         => v_lead_approver,
            p_lead_apprl         => v_lead_approval,
            p_hod_empno          => v_hod_empno,
            p_hod_apprl          => v_hod_apprl,
            p_hod_ip             => v_hod_ip,
            p_hrd_empno          => v_hrd_empno,
            p_hrd_apprl          => v_hrd_apprl,
            p_hrd_ip             => v_hrd_ip,
            p_hod_apprl_dt       => v_hod_apprl_dt,
            p_hrd_apprl_dt       => v_hrd_apprl_dt
        );
        --p_message := 'Debug - A5 - ' || v_empno || ' - ' || v_pdate || ' - ' || p_hh || ' - ' || p_mi || ' - ' || p_hh1 || ' - ' || p_mi1 || ' - ODSubType - ' || p_od_sub_type ;

        --If p_od_type = 'LE' And v_is_entry_by_hr = 'KO' Then
        If p_od_type = 'LE' Then
            v_lead_approver := 'None';
            v_lead_approval := 4;
            v_hod_apprl     := 1;
            v_hod_apprl_dt  := v_now;
            v_hod_empno     := v_entry_by;
            v_hod_ip        := p_user_ip;
        End If;

        Insert Into ss_ondutyapp (
            empno,
            app_no,
            app_date,
            hh,
            mm,
            hh1,
            mm1,
            pdate,
            dd,
            mon,
            yyyy,
            type,
            description,
            odtype,
            reason,
            user_tcp_ip,
            hod_apprl,
            hod_apprl_dt,
            hod_tcp_ip,
            hod_code,
            lead_apprl_empno,
            lead_apprl,
            hrd_apprl,
            hrd_tcp_ip,
            hrd_code,
            hrd_apprl_dt
        )
        Values (
            v_empno,
            v_app_no,
            v_now,
            p_hh,
            p_mi,
            p_hh1,
            p_mi1,
            v_pdate,
            v_dd,
            v_mon,
            v_yyyy,
            p_od_type,
            v_appl_desc,
            nvl(p_od_sub_type, 0),
            p_reason,
            p_user_ip,
            v_hod_apprl,
            v_hod_apprl_dt,
            v_hod_ip,
            v_hod_empno,
            v_lead_approver,
            v_lead_approval,
            v_hrd_apprl,
            v_hrd_ip,
            v_hrd_empno,
            v_hrd_apprl_dt
        );

        p_success               := 'OK';
        p_message               := 'Your application has been saved successfull. Applicaiton Number :- ' || v_app_no;
        Commit;
        If v_entry_by_user_profile != user_profile.type_hrd Then
            Return;
        End If;
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
                app_no = v_app_no
        );
        --p_message := 'Debug - A7';

        If p_od_type Not In ('IO', 'OD') Then
            Return;
        End If;
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
                app_no = v_app_no
        );

        p_message               := 'Debug - A8';
        generate_auto_punch_4od(v_app_no);
        --p_message := 'Debug - A9';
        p_success               := 'OK';
        p_message               := 'Your application has been saved successfull. Applicaiton Number :- ' || v_app_no;
    Exception
        When dup_val_on_index Then
            p_success := 'KO';
            p_message := 'Duplicate values found cannot proceed.' || ' - ' || p_message;
        When Others Then
            p_success := 'KO';
            p_message := 'ERR :- ' || sqlcode || ' - ' || sqlerrm || ' - ' || p_message;
        --p_message := p_message || 

    End;

    Procedure add_onduty_type_1(
        p_empno         Varchar2,
        p_od_type       Varchar2,
        p_od_sub_type   Varchar2,
        p_pdate         Varchar2,
        p_hh            Number,
        p_mi            Number,
        p_hh1           Number,
        p_mi1           Number,
        p_lead_approver Varchar2,
        p_reason        Varchar2,
        p_entry_by      Varchar2,
        p_user_ip       Varchar2,
        p_success Out   Varchar2,
        p_message Out   Varchar2
    ) As

        v_pdate                 Date;
        v_count                 Number;
        v_empno                 Varchar2(5);
        v_entry_by              Varchar2(5);
        v_od_catg               Number;
        v_onduty_row            ss_vu_ondutyapp%rowtype;
        v_rec_no                Number;
        v_app_no                Varchar2(60);
        v_now                   Date;
        v_is_office_ip          Varchar2(10);
        v_entry_by_user_profile Number;
        v_is_entry_by_hr        Varchar2(2);
        v_is_entry_by_hr_4_self Varchar2(2);
        v_lead_approver         Varchar2(5);
        v_lead_approval         Number;
        v_hod_empno             Varchar2(5);
        v_hod_ip                Varchar2(30);
        v_hod_apprl             Number;
        v_hod_apprl_dt          Date;
        v_hrd_empno             Varchar2(5);
        v_hrd_ip                Varchar2(30);
        v_hrd_apprl             Number;
        v_hrd_apprl_dt          Date;
        v_appl_desc             Varchar2(60);
        v_dd                    Varchar2(2);
        v_mon                   Varchar2(2);
        v_yyyy                  Varchar2(4);
    Begin
        v_entry_by              := substr('0000' || trim(p_entry_by), -5);
        v_entry_by_user_profile := user_profile.get_profile(v_entry_by);

        prc_add_onduty_type_1(
            p_empno            => p_empno,
            p_od_type          => p_od_type,
            p_od_sub_type      => p_od_sub_type,
            p_pdate            => p_pdate,
            p_hh               => p_hh,
            p_mi               => p_mi,
            p_hh1              => p_hh1,
            p_mi1              => p_mi1,
            p_lead_approver    => p_lead_approver,
            p_reason           => p_reason,
            p_entry_by         => p_entry_by,
            p_entry_by_profile => v_entry_by_user_profile,
            p_user_ip          => p_user_ip,
            p_success          => p_success,
            p_message          => p_message
        );

    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'ERR :- ' || sqlcode || ' - ' || sqlerrm || ' - ' || p_message;
    End add_onduty_type_1;

    Procedure transfer_od_2_wfh(
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As

        Cursor cur_od Is
            Select
                empno,
                'RW'                             od_type,
                to_char(pdate, 'yyyymmdd')       bdate,
                to_char(pdate, 'yyyymmdd')       edate,
                empno                            entry_by,
                lead_apprl_empno,
                user_tcp_ip,
                reason,
                app_no,
                to_char(app_date, 'dd-Mon-yyyy') app_date1,
                to_char(pdate, 'dd-Mon-yyyy')    pdate1
            From
                ss_ondutyapp
            Where
                nvl(hod_apprl, 0)     = 1
                And nvl(hrd_apprl, 0) = 0
                And yyyy In (
                    '2021', '2022'
                )
                And type              = 'OD';

        Type typ_tab_od Is
            Table Of cur_od%rowtype;
        tab_od   typ_tab_od;
        v_app_no Varchar2(30);
        v_is_err Varchar2(10) := 'KO';
    Begin
        Open cur_od;
        Loop
            Fetch cur_od Bulk Collect Into tab_od Limit 50;
            For i In 1..tab_od.count
            Loop
                p_success := Null;
                p_message := Null;
                od.add_onduty_type_2(
                    p_empno         => tab_od(i).empno,
                    p_od_type       => tab_od(i).od_type,
                    p_b_yyyymmdd    => tab_od(i).bdate,
                    p_e_yyyymmdd    => tab_od(i).edate,
                    p_entry_by      => tab_od(i).entry_by,
                    p_lead_approver => tab_od(i).lead_apprl_empno,
                    p_user_ip       => tab_od(i).user_tcp_ip,
                    p_reason        => tab_od(i).reason,
                    p_success       => p_success,
                    p_message       => p_message
                );

                If p_success = 'OK' Then
                    Delete
                        From ss_ondutyapp
                    Where
                        Trim(app_no) = Trim(tab_od(i).app_no);

                Else
                    v_is_err := 'OK';
                End If;

            End Loop;

            Exit When cur_od%notfound;
        End Loop;

        Commit;
        Update
            ss_depu
        Set
            lead_code = 'Sys',
            lead_apprl_dt = sysdate,
            lead_apprl = 1
        Where
            type                = 'RW'
            And trunc(app_date) = trunc(sysdate)
            And lead_apprl <> 4;

        Update
            ss_depu
        Set
            hod_apprl = 1,
            hod_code = 'Sys',
            hod_apprl_dt = sysdate,
            hrd_apprl = 1,
            hrd_code = 'Sys',
            hrd_apprl_dt = sysdate
        Where
            type                = 'RW'
            And trunc(app_date) = trunc(sysdate);

        Commit;
        If v_is_err = 'OK' Then
            p_success := 'KO';
            p_message := 'Err - Some OnDuty applicaitons were not transfered to WFH.';
        Else
            p_success := 'OK';
            p_message := 'OnDuty applications successfully transferd to WFH.';
        End If;

    Exception
        When Others Then
            Rollback;
            p_success := 'OK';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;
    Procedure gen_first_day_missed_punch(
        p_date Date
    ) As
        Cursor c_new_joined_emp Is
            Select
                empno
            From
                ss_emplmast
            Where
                status  = 1
                And doj = p_date
                And emptype In ('R', 'S', 'C', 'F');
        Type typ_new_joined_emp Is Table Of c_new_joined_emp%rowtype;
        tab_new_joined_emp      typ_new_joined_emp;

        v_success               Varchar2(10);
        v_message               Varchar2(1000);
        v_count                 Number;
        v_entry_by_user_profile Number;
    Begin

        v_entry_by_user_profile := user_profile.type_hrd;
        Open c_new_joined_emp;
        Loop
            Fetch c_new_joined_emp Bulk Collect Into tab_new_joined_emp Limit 50;
            For i In 1..tab_new_joined_emp.count
            Loop
                Select
                    Count(*)
                Into
                    v_count
                From
                    ss_punch
                Where
                    empno     = tab_new_joined_emp(i).empno
                    And pdate = p_date;
                If v_count > 0 Then
                    Begin

                        prc_add_onduty_type_1(
                            p_empno            => tab_new_joined_emp(i).empno,
                            p_od_type          => 'MP',
                            p_od_sub_type      => 0,
                            p_pdate            => to_char(p_date, 'yyyymmdd'),
                            p_hh               => 8,
                            p_mi               => 30,
                            p_hh1              => Null,
                            p_mi1              => Null,
                            p_lead_approver    => 'None',
                            p_reason           => 'New joining',
                            p_entry_by         => 'SYSTM',
                            p_entry_by_profile => v_entry_by_user_profile,
                            p_user_ip          => Null,
                            p_success          => v_success,
                            p_message          => v_message
                        );

                    Exception
                        When Others Then
                            v_success := not_ok;
                            v_message := 'Error - ' || sqlcode || ' - ' || sqlerrm;
                    End;
                    If v_success = ok Then
                        tcmpl_app_config.task_scheduler.sp_log_success(
                            p_proc_name     => 'SELFSERVICE.OD.GEN_FIRST_DAY_MISSED_PUNCH',
                            p_business_name => 'Generate missed punch on date of joining',
                            p_message       => tab_new_joined_emp(i).empno || '-' || v_message
                        );
                    Else
                        tcmpl_app_config.task_scheduler.sp_log_failure(
                            p_proc_name     => 'SELFSERVICE.OD.GEN_FIRST_DAY_MISSED_PUNCH',
                            p_business_name => 'Generate missed punch on date of joining',
                            p_message       => tab_new_joined_emp(i).empno || '-' || v_message
                        );
                    End If;
                End If;
            End Loop;
            Exit When c_new_joined_emp%notfound;
        End Loop;
    End;
End od;
/