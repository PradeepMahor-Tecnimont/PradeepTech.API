--------------------------------------------------------
--  DDL for Package Body WFH_ATTENDANCE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."WFH_ATTENDANCE" As

    Function check_office_punch_exists (
        param_empno Varchar2
    ) Return Varchar2 As
        v_count Number;
    Begin
        Select
            Count(*)
        Into v_count
        From
            ss_punch
        Where
            empno = param_empno
            And Trunc(pdate) = Trunc(Sysdate);

        If v_count = 0 Then
            Return 'KO';
        Else
            Return 'OK';
        End If;
    Exception
        When Others Then
            Return 'KO';
    End;

    Function is_valid_ip (
        param_ip Varchar2
    ) Return Varchar2 Is

        v_ip_to_include      Char(11);
        v_ip_to_exclude      Char(15);
        v_include_count      Number;
        v_exclude_count      Number;
        v_ip_to_skip_count   Number;
    Begin
        --Check IP is RDP Allowed -- IP
        Select
            Count(*)
        Into v_include_count
        From
            ss_tcmpl_ip_4_wfh_rdp
        Where
            Trim(ip_addr) = Trim(param_ip);

        If v_include_count > 0 Then
            Return 'OK';
        --Else
            --Return 'KO';
        End If;

        --
        --
        v_ip_to_exclude := Trim(Trailing '.' From Substr(param_ip, 1, Instr(param_ip, '.', -1)));

        --v_ip_to_exclude   := param_ip;

        Select
            Count(*)
        Into v_exclude_count
        From
            ss_tcmpl_ip_mast
        Where
            ip_prefix = v_ip_to_exclude;

        Select
            Count(*)
        Into v_ip_to_skip_count
        From
            ss_tcmpl_ip_skip
        Where
            Trim(ip) = Trim(param_ip);

        If v_ip_to_skip_count > 0 Or v_exclude_count > 0 Then
            Return 'KO';
        Else
            Return 'OK';
        End If;

    Exception
        When Others Then
            Return 'KO';
    End;

    Function get_first_punch (
        param_empno Varchar2,
        param_pdate Date
    ) Return Varchar2 As
        v_ret_val   Varchar2(5);
        v_hrs       Varchar2(2);
        v_mn        Varchar2(2);
    Begin
        Select
            hrs,
            mn
        Into
            v_hrs,
            v_mn
        From
            (
                Select
                    Lpad(hh, 2, '0') hrs,
                    Lpad(mm, 2, '0') mn
                From
                    ss_vu_manual_punch
                Where
                    empno = param_empno
                    And pdate = param_pdate
                Order By
                    hh,
                    mm
            )
        Where
            Rownum = 1;

        Return v_hrs || ':' || v_mn;
    Exception
        When Others Then
            Return '';
    End;

    Function get_last_punch (
        param_empno Varchar2,
        param_pdate Date
    ) Return Varchar2 As

        v_ret_val   Varchar2(5);
        v_hrs       Varchar2(2);
        v_mn        Varchar2(2);
        v_count     Number;
    Begin
        Select
            Count(*)
        Into v_count
        From
            ss_vu_manual_punch
        Where
            empno = param_empno
            And pdate = param_pdate;

        If v_count < 2 Then
            Return '';
        End If;
        Select
            hrs,
            mn
        Into
            v_hrs,
            v_mn
        From
            (
                Select
                    Lpad(hh, 2, '0') hrs,
                    Lpad(mm, 2, '0') mn
                From
                    ss_vu_manual_punch
                Where
                    empno = param_empno
                    And pdate = param_pdate
                Order By
                    hh Desc,
                    mm Desc
            )
        Where
            Rownum = 1;

        Return v_hrs || ':' || v_mn;
    Exception
        When Others Then
            Return '';
    End;

    Procedure add_punch (
        param_empno     Varchar2,
        param_ip        Varchar2,
        param_success   Out             Varchar2,
        param_message   Out             Varchar2
    ) As

        v_ip_to_include         Char(11);
        v_ip_to_exclude         Char(15);
        v_count                 Number;
        v_first_punch_time      Date;
        v_last_punch_time       Date;
        v_diff                  Number;
        v_now_date              Date;
        v_punch_entry_msg       Varchar2(100);
        v_include_count         Number;
        v_exclude_count         Number;
        v_is_ip_valid           Varchar2(10);
        v_office_punch_exists   Varchar2(2);
    Begin
        v_office_punch_exists   := check_office_punch_exists(param_empno);
        If v_office_punch_exists = 'OK' Then
            param_success   := 'KO';
            param_message   := 'Err - Office Punch exist. Cannot insert WFH - Punch.';
            return;
        End If;

        v_is_ip_valid           := is_valid_ip(param_ip);
        v_now_date              := Sysdate;
        /*
        If Trunc(v_now_date) >= To_Date('8-Oct-2020', 'dd-Mon-yyyy') Then
            param_success   := 'KO';
            param_message   := 'Err -  This utility has been disabled.';
            return;
        End If;


        v_ip_to_exclude   := param_ip;
        v_ip_to_include   := Trim(Trailing '.' From Substr(param_ip, 1, Instr(param_ip, '.', -1)));

        Select
            Count(*)
        Into v_include_count
        From
            ss_tcmpl_ip_mast
        Where
            ip_prefix = v_ip_to_include;

        Select
            Count(*)
        Into v_exclude_count
        From
            ss_tcmpl_ip_skip
        Where
            ip = v_ip_to_exclude;

        If v_include_count = 0 Or v_exclude_count > 0 Then
            param_success   := 'KO';
            param_message   := 'This utility is applicable from selected PC''s in TCMPL Mumbai Office';
            return;
        End If;
        */
        If v_is_ip_valid = 'KO' Then
            param_success   := 'KO';
            param_message   := 'This utility is not applicable from your PC in TCMPL Mumbai Office';
            return;
        End If;

        Select
            Count(*)
        Into v_count
        From
            ss_punch_wfh
        Where
            empno = param_empno
            And pdate = Trunc(v_now_date);

        If v_count = 0 Then
            v_punch_entry_msg   := 'IN entry has been successfully recorded.';
            v_now_date          := v_now_date; -- ( 5 / 1440 );
        Else
            v_punch_entry_msg   := 'OUT entry has been successfully recorded.';
            v_now_date          := v_now_date;-- + ( 5 / 1440 );
        End If;

        Begin
            Select
                Min(pdate_time),
                Max(pdate_time),
                Count(*)
            Into
                v_first_punch_time,
                v_last_punch_time,
                v_count
            From
                ss_punch_wfh
            Where
                empno = param_empno
                And pdate = Trunc(v_now_date);

        Exception
            When Others Then
                v_count := 0;
        End;

        v_diff                  := ( v_now_date - v_last_punch_time ) * 1440;
        If v_diff < 5 Then
            param_success   := 'KO';
            param_message   := 'Your last entry "' || To_Char(v_last_punch_time, 'dd-Mon-yyyy HH24:mi') || '". Please try this utility after '
            || To_Char(v_last_punch_time, 'dd-Mon-yyyy HH24:mi');

            return;
        End If;

        If v_count > 1 Then
            Delete From ss_punch_wfh
            Where
                empno = param_empno
                And pdate = Trunc(v_now_date)
                And pdate_time <> v_first_punch_time;

            Commit;
        End If;

        Insert Into ss_punch_wfh (
            empno,
            hh,
            mm,
            pdate,
            falseflag,
            dd,
            mon,
            yyyy,
            mach,
            ss,
            pdate_time
        ) Values (
            param_empno,
            To_Char(v_now_date, 'HH24'),
            To_Char(v_now_date, 'MI'),
            Trunc(v_now_date),
            1,
            To_Char(v_now_date, 'dd'),
            To_Char(v_now_date, 'MM'),
            To_Char(v_now_date, 'YYYY'),
            param_ip,
            To_Char(v_now_date, 'SS'),
            v_now_date
        );

        param_success           := 'OK';
        param_message           := v_punch_entry_msg;
    Exception
        When dup_val_on_index Then
            param_success   := 'KO';
            param_message   := 'Err - Entry already recorded. Please try after 5 min';
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End add_punch;

    Procedure get_emp_attendance (
        param_empno      Varchar2,
        param_name       Out              Varchar2,
        param_pdate      Out              Varchar2,
        param_in_time    Out              Varchar2,
        param_out_time   Out              Varchar2,
        param_success2   Out              Varchar2,
        param_message2   Out              Varchar2
    ) As

        v_first_punch   Varchar2(5);
        v_last_punch    Varchar2(5);
        v_now_date      Date := Sysdate;
        v_name          Varchar2(60);
    Begin
        param_pdate      := To_Char(v_now_date, 'dd-Mon-yyyy');
        Select
            name
        Into v_name
        From
            ss_emplmast
        Where
            empno = param_empno;

        param_name       := v_name;
        param_success2   := 'OK';
        Begin
            Select
                To_Char(Min(pdate_time), 'hh24:mi'),
                To_Char(Max(pdate_time), 'hh24:mi')
            Into
                param_in_time,
                param_out_time
            From
                ss_punch_wfh
            Where
                empno = param_empno
                And pdate = Trunc(v_now_date);

        Exception
            When Others Then
                param_in_time    := '-';
                param_out_time   := '-';
                param_message2   := 'to register OUT punch.';
                return;
        End;

        If Trim(param_in_time) Is Null Then
            param_in_time    := '';
            param_out_time   := '';
            param_message2   := 'to register IN punch.';
            return;
        End If;

        If param_in_time = param_out_time Then
            param_out_time := '';
        End If;
        param_message2   := 'to register OUT punch.';
    Exception
        When Others Then
            param_success2   := 'KO';
            param_message2   := 'Err - Data could not be retrieved.';
    End;

    Procedure rem_wfh_n_keep_card_swipe (
        param_empno Varchar2,
        param_pdate Date
    ) As
    Begin
        Delete From ss_punch_wfh
        Where
            empno = param_empno
            And Trunc(pdate) = Trunc(param_pdate);

        Commit;
    End;


End wfh_attendance;


/
