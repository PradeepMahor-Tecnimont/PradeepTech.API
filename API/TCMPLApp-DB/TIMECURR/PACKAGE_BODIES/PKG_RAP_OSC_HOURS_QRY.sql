--------------------------------------------------------
--  DDL for Package Body PKG_RAP_OSC_HOURS_QRY
--------------------------------------------------------

Create Or Replace Package Body timecurr.PKG_RAP_OSC_HOURS_QRY As

    Function fn_yyyymm_hours_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_oscd_id     Varchar2,

        p_row_number  Number,
        p_page_length Number

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                        oscd_id,
                        osch_id,
                        yyyymm,
                        orig_est_hrs,
                        fn_check_enable_disable_month(p_person_id, p_meta_id, oscd_id, yyyymm, 'O') As orig_est_hrs_status,
                        cur_est_hrs,
                        fn_check_enable_disable_month(p_person_id, p_meta_id, oscd_id, yyyymm, 'C') As cur_est_hrs_status,
                        Row_Number() Over (Order By yyyymm)                                         row_number,
                        Count(*) Over ()                                                            total_row
                    From
                        rap_osc_hours
                    Where
                        oscd_id = Trim(p_oscd_id)
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;

    End fn_yyyymm_hours_list;

    Procedure sp_yyyymm_hours_detail(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_osch_id                 Varchar2,
        p_oscd_id             Out Varchar2,
        p_yyyymm              Out Varchar2,
        p_orig_est_hrs        Out Number,
        p_cur_est_hrs         Out Number,

        p_message_type        Out Varchar2,
        p_message_text        Out Varchar2
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
            roh.oscd_id,
            roh.yyyymm,
            roh.orig_est_hrs,
            roh.cur_est_hrs
        Into
            p_oscd_id,
            p_yyyymm,
            p_orig_est_hrs,
            p_cur_est_hrs
        From
            rap_osc_hours roh
        Where
            roh.osch_id = Trim(p_osch_id);

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_yyyymm_hours_detail;

    Function fn_yyyymm_hours_ses_amount(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_osch_id   Varchar2 Default Null,
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
            oscm_id = Trim(p_oscm_id)
            And to_char(ses_date, 'yyyymm') In (
                Select
                    yyyymm
                From
                    rap_osc_hours
                Where
                    osch_id = nvl(p_osch_id, osch_id)
            );

        Return v_ses_amount;

    End fn_yyyymm_hours_ses_amount;

    Function fn_check_enable_disable_month(
        p_person_id  Varchar2,
        p_meta_id    Varchar2,

        p_oscd_id    Varchar2,
        p_yyyymm     Varchar2,
        p_hours_type Varchar2

    ) Return Varchar2 As
        v_lock_orig_budget rap_osc_master.lock_orig_budget%Type;
        n_months           Number;
    Begin
        Select
            lock_orig_budget
        Into
            v_lock_orig_budget
        From
            (
                Select
                    lock_orig_budget
                From
                    rap_osc_master
                Where
                    oscm_id In (
                        Select
                            oscm_id
                        From
                            rap_osc_detail
                        Where
                            oscd_id = Trim(p_oscd_id)
                    )
                Order By lock_orig_budget
            )
        Where
            Rownum = 1;

        If v_lock_orig_budget = 1 Then

            If p_hours_type = 'O' Then
                Return 'LOCKED_DISABLED';
            Elsif p_hours_type = 'C' Then

                Select
                    To_Number(p_yyyymm) - To_Number(pros_month)
                Into
                    n_months
                From
                    tsconfig;

                If n_months >= 0 Then
                    Return 'LOCKED_ENABLED';
                Else
                    Return 'LOCKED_DISABLED';
                End If;
            End If;

        Elsif v_lock_orig_budget = 0 Then

            If p_hours_type = 'O' Then
                Return 'OPEN_ENABLED';
            Elsif p_hours_type = 'C' Then
                Return 'OPEN_DISABLED';
            End If;
        End If;

    End;

End pkg_rap_osc_hours_qry;
/
Grant Execute On "TIMECURR"."PKG_RAP_OSC_HOURS_QRY" To "TCMPL_APP_CONFIG";