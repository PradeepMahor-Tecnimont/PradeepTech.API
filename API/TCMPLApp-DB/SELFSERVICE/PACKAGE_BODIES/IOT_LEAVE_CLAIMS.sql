--------------------------------------------------------
--  DDL for Package Body IOT_LEAVE_CLAIMS
--------------------------------------------------------

Create Or Replace Package Body "SELFSERVICE"."IOT_LEAVE_CLAIMS" As

    Procedure sp_add_leave_claim(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_leave_type       Varchar2,
        p_leave_period     Number,
        p_start_date       Date,
        p_end_date         Date,
        p_half_day_on      Number,
        p_description      Varchar2,
        p_med_cert_file_nm Varchar2 Default Null,
        p_adjustment_type  Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2

    ) As

        v_empno               Varchar2(5);
        v_app_date            Date;
        v_message_type        Varchar2(2);
        v_count               Number;
        v_adj_date            Date;
        v_adj_seq_no          Number;
        v_hd_date             Date;
        v_entry_by_empno      Varchar2(5);
        v_hd_presnt_part      Number;
        v_adj_no              Varchar2(60);
        e_employee_not_found  Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_leave_type          Varchar2(2);
        v_is_covid_sick_leave Number(1);
    Begin
        v_leave_type     := p_leave_type;
        If v_leave_type = 'SC' Then
            v_leave_type          := 'SL';
            v_is_covid_sick_leave := 1;
        End If;
        v_entry_by_empno := get_empno_from_meta_id(p_meta_id);
        v_app_date       := sysdate;
        If v_entry_by_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return;
        End If;

        v_empno          := p_empno;
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

        v_adj_seq_no     := leave_adj_seq.nextval;
        v_adj_no         := p_adjustment_type || '/' || v_empno || '/' || to_char(sysdate, 'ddmmyyyy') || '/' || v_adj_seq_no;
        If nvl(p_half_day_on, half_day_on_none) = hd_bdate_presnt_part_2 Then
            v_hd_date        := p_start_date;
            v_hd_presnt_part := 2;
        Elsif nvl(p_half_day_on, half_day_on_none) = hd_edate_presnt_part_1 Then
            v_hd_date        := p_end_date;
            v_hd_presnt_part := 1;
        End If;

        --
        --Check Leave is overlapping

        Select
            Count(*)
        Into
            v_count
        From
            (
                Select
                    empno
                From
                    ss_leaveapp
                Where
                    empno = p_empno
                    And (bdate Between p_start_date And p_end_date
                        Or edate Between p_start_date And p_end_date)
                Union
                Select
                    empno
                From
                    ss_leave_adj
                Where
                    empno     = p_empno
                    And (bdate Between p_start_date And p_end_date
                        Or edate Between p_start_date And p_end_date)
                    And db_cr = 'D'

            );

        --Check Leave is overlapping
        If v_count > 0 Then
            p_message_type := 'KO';
            p_message_text := 'Leave already availed on same day.';
            Return;
        End If;
        --Check Leave is overlapping
        --

        Insert Into ss_leave_adj (
            empno,
            adj_dt,
            adj_no,
            leavetype,
            dataentryby,
            db_cr,
            adj_type,
            bdate,
            edate,
            leaveperiod,
            description,
            tcp_ip,
            hd_date,
            hd_part,
            entry_date,
            med_cert_file_name,
            is_covid_sick_leave
        )
        Values(
            v_empno,
            sysdate,
            v_adj_no,
            v_leave_type,
            v_entry_by_empno,
            'D',
            p_adjustment_type,
            p_start_date,
            p_end_date,
            p_leave_period * 8,
            p_description,
            Null,
            v_hd_date,
            v_hd_presnt_part,
            v_app_date,
            p_med_cert_file_nm,
            v_is_covid_sick_leave
        );
        Insert Into ss_leaveledg(
            app_no,
            app_date,
            leavetype,
            description,
            empno,
            leaveperiod,
            db_cr,
            tabletag,
            bdate,
            edate,
            adj_type,
            hd_date,
            hd_part,
            is_covid_sick_leave
        )
        Values(
            v_adj_no,
            v_app_date,
            v_leave_type,
            p_description,
            v_empno,
            p_leave_period * 8 * -1,
            'D',
            0,
            p_start_date,
            p_end_date,
            p_adjustment_type,
            v_hd_date,
            v_hd_presnt_part,
            v_is_covid_sick_leave
        );
        Commit;
        p_message_type   := 'OK';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || '-' || sqlerrm;
    End;
    /*
        Procedure sp_delete_leave_claim(
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
                ss_leave_adj
            Where
                empno            = v_empno
                And Trim(app_no) = Trim(p_application_id);
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
    */

    Procedure sp_import(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_leave_claims           typ_tab_string,

        p_leave_claim_errors Out typ_tab_string,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2
    ) As
        v_empno           Varchar2(5);
        v_leave_type      Varchar2(2);
        v_no_of_days      Number;
        v_start_date      Date;
        v_end_date        Date;
        v_remarks         Varchar2(30);
        v_adjustment_type Varchar2(2);

        v_valid_claim_num Number;
        tab_valid_claims  typ_tab_claims;
        v_rec_claim       rec_claim;
        v_err_num         Number;
        is_error_in_row   Boolean;
        v_half_day_on     Number;
        v_msg_text        Varchar2(200);
        v_msg_type        Varchar2(10);
        v_count           Number;
        v_reason          Varchar2(30);
    Begin
        v_err_num := 0;
        For i In 1..p_leave_claims.count
        Loop
            is_error_in_row := false;
            With
                csv As (
                    Select
                        p_leave_claims(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '[^~!~]+', 1, 1))                      empno,
                Trim(regexp_substr(str, '[^~!~]+', 1, 2))                      leave_type,
                Trim(regexp_substr(str, '[^~!~]+', 1, 3))                      no_of_days,
                To_Date(Trim(regexp_substr(str, '[^~!~]+', 1, 4)), 'yyyymmdd') start_date,
                To_Date(Trim(regexp_substr(str, '[^~!~]+', 1, 5)), 'yyyymmdd') end_date,
                Trim(regexp_substr(str, '[^~!~]+', 1, 6))                      reason,
                Trim(regexp_substr(str, '[^~!~]+', 1, 7))                      adjustment_type
            Into
                v_empno,
                v_leave_type,
                v_no_of_days,
                v_start_date,
                v_end_date,
                v_reason,
                v_adjustment_type
            From
                csv;
            v_end_date      := nvl(v_end_date, v_start_date);
            v_empno         := lpad(v_empno, 5, '0');
            Select
                Count(*)
            Into
                v_count
            From
                ss_emplmast
            Where
                empno = v_empno
                And (dol Is Null Or dol > sysdate - 365);
            If v_count = 0 Then
                v_err_num       := v_err_num + 1;
                p_leave_claim_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'Empno' || '~!~' ||     --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'Employee not found';   --Message
                is_error_in_row := true;
            End If;
            Select
                Count(*)
            Into
                v_count
            From
                ss_leavetype
            Where
                leavetype     = v_leave_type
                And is_active = 1;
            If v_leave_type In ('SL', 'SC') And v_no_of_days >= 2 Then
                v_err_num       := v_err_num + 1;
                p_leave_claim_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'LeaveType' || '~!~' || --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'MEDICAL Certificate required'; --Message
                is_error_in_row := true;
            End If;
            If v_count = 0 Then
                v_err_num       := v_err_num + 1;
                p_leave_claim_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'LeaveType' || '~!~' || --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'Incorrect leave type'; --Message
                is_error_in_row := true;
            End If;
            If Mod(v_no_of_days, 0.5) <> 0 Then
                v_err_num       := v_err_num + 1;
                p_leave_claim_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'NoOfDays' || '~!~' ||  --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'NoOfDays should be in multiples of 0.5'; --Message
                is_error_in_row := true;
            End If;
            If v_start_date Is Null Or v_end_date Is Null Or v_end_date < v_start_date Then
                v_err_num       := v_err_num + 1;
                p_leave_claim_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'StartDate' || '~!~' || --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'Invalid date range';   --Message
                is_error_in_row := true;
            End If;
            --
            --Check Leave is overlapping
            Select
                Count(*)
            Into
                v_count
            From
                (
                    Select
                        empno
                    From
                        ss_leaveapp
                    Where
                        empno = v_empno
                        And (bdate Between v_start_date And v_end_date
                            Or edate Between v_start_date And v_end_date)
                    Union
                    Select
                        empno
                    From
                        ss_leave_adj
                    Where
                        empno = v_empno
                        And (bdate Between v_start_date And v_end_date
                            Or edate Between v_start_date And v_end_date)
                    And db_cr = 'D'

                );

            --Check Leave is overlapping
            If v_count > 0 Then
                v_err_num       := v_err_num + 1;
                p_leave_claim_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'Reason' || '~!~' ||   --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'Leave already availed on same date.'; --Message
                is_error_in_row := true;
            End If;

            If v_reason Is Null Then
                v_err_num       := v_err_num + 1;
                p_leave_claim_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'Reason' || '~!~' ||   --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'Reason are required'; --Message
                is_error_in_row := true;
            End If;

            If v_adjustment_type Is Null Then
                v_err_num       := v_err_num + 1;
                p_leave_claim_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'AdjustmentType' || '~!~' ||   --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'Adjustment type are required'; --Message
                is_error_in_row := true;
            End If;

            If is_error_in_row = false Then
                If Mod(v_no_of_days, 1) > 0 Then
                    v_half_day_on := hd_bdate_presnt_part_2;
                Else
                    v_half_day_on := half_day_on_none;
                End If;
                v_valid_claim_num                                   := nvl(v_valid_claim_num, 0) + 1;
                 
                --v_rec_claim.empno := v_empno;

                tab_valid_claims(v_valid_claim_num).empno           := v_empno;
                tab_valid_claims(v_valid_claim_num).leave_type      := v_leave_type;
                tab_valid_claims(v_valid_claim_num).leave_period    := v_no_of_days;
                tab_valid_claims(v_valid_claim_num).start_date      := v_start_date;
                tab_valid_claims(v_valid_claim_num).end_date        := v_end_date;
                tab_valid_claims(v_valid_claim_num).half_day_on     := v_half_day_on;
                tab_valid_claims(v_valid_claim_num).reason          := v_reason;
                tab_valid_claims(v_valid_claim_num).adjustment_type := v_adjustment_type;
            End If;
        End Loop;
        If v_err_num != 0 Then
            p_message_type := 'OO';
            p_message_text := 'Not all records were imported.';
            Return;
        End If;

        For i In 1..v_valid_claim_num
        Loop
            sp_add_leave_claim(
                p_person_id        => p_person_id,
                p_meta_id          => p_meta_id,

                p_empno            => tab_valid_claims(i).empno,
                p_leave_type       => tab_valid_claims(i).leave_type,
                p_leave_period     => tab_valid_claims(i).leave_period,
                p_start_date       => tab_valid_claims(i).start_date,
                p_end_date         => tab_valid_claims(i).end_date,
                p_half_day_on      => tab_valid_claims(i).half_day_on,
                p_description      => tab_valid_claims(i).reason,
                p_med_cert_file_nm => Null,
                p_adjustment_type  => tab_valid_claims(i).adjustment_type,

                p_message_type     => v_msg_type,
                p_message_text     => v_msg_text

            );

            If v_msg_type <> 'OK' Then
                v_err_num := v_err_num + 1;
                p_leave_claim_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'Empno' || '~!~' ||     --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    v_msg_text;             --Message
            End If;
        End Loop;
        If v_err_num != 0 Then
            p_message_type := 'OO';
            p_message_text := 'Not all records were imported.';

        Else
            p_message_type := 'OK';
            p_message_text := 'File imported successfully.';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := sqlcode || ' - ' || sqlerrm;
    End;

End iot_leave_claims;
/

Grant Execute On "SELFSERVICE"."IOT_LEAVE_CLAIMS" To "TCMPL_APP_CONFIG";