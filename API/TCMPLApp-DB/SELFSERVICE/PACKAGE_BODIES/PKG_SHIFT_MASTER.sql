--------------------------------------------------------
--  DDL for Package Body PKG_SHIFT_MASTER
--------------------------------------------------------

Create Or Replace Package Body selfservice.pkg_shift_master As

    Procedure sp_add_shift(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_shiftcode        Varchar2,
        p_shiftdesc        Varchar2,
        p_timein_hh        Number,
        p_timein_mn        Number,
        p_timeout_hh       Number,
        p_timeout_mn       Number,
        p_shift4allowance  Number Default Null,
        p_lunch_mn         Number Default Null,
        p_ot_applicable    Number Default Null,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_message_type Number := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            ss_shiftmast
        Where
            shiftcode = upper(p_shiftcode);

        If v_exists = 0 Then
            Insert Into ss_shiftmast (
                shiftcode,
                shiftdesc,
                timein_hh,
                timein_mn,
                timeout_hh,
                timeout_mn,
                shift4allowance,
                lunch_mn,
                ot_applicable
            )
            Values (
                p_shiftcode,
                p_shiftdesc,
                p_timein_hh,
                p_timein_mn,
                p_timeout_hh,
                p_timeout_mn,
                p_shift4allowance,
                p_lunch_mn,
                p_ot_applicable
            );

            Commit;
            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Item type ready exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_shift;

    Procedure sp_shift_details_update(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_shiftcode        Varchar2,
        p_shiftdesc        Varchar2,
        p_timein_hh        Number,
        p_timein_mn        Number,
        p_timeout_hh       Number,
        p_timeout_mn       Number,
        p_shift4allowance  Number Default Null,
        p_lunch_mn         Number Default Null,
        p_ot_applicable    Number Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_by_empno    Varchar2(5);
        v_count_shift Number;
        v_exists      Number;
    Begin
        v_by_empno     := get_empno_from_meta_id(p_meta_id);
        If v_by_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count_shift
        From
            ss_shiftmast
        Where
            shiftcode = p_shiftcode;

        If v_count_shift = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Shiftcode not found.';
            Return;
        End If;

        Update
            ss_shiftmast
        Set
            shiftdesc = p_shiftdesc,
            timein_hh = p_timein_hh,
            timein_mn = p_timein_mn,
            timeout_hh = p_timeout_hh,
            timeout_mn = p_timeout_mn,
            shift4allowance = p_shift4allowance,
            lunch_mn = p_lunch_mn,
            ot_applicable = p_ot_applicable
        Where
            shiftcode = p_shiftcode;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_shift_config_details_update(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_shiftcode            Varchar2,
        p_ch_fd_start_mi       Number,
        p_ch_fd_end_mi         Number,
        p_ch_fh_start_mi       Number,
        p_ch_fh_end_mi         Number,
        p_ch_sh_start_mi       Number,
        p_ch_sh_end_mi         Number,
        p_full_day_work_mi     Number,
        p_half_day_work_mi     Number,
        p_full_week_work_mi    Number,
        p_work_hrs_start_mi    Number,
        p_work_hrs_end_mi      Number,
        p_first_punch_after_mi Number,
        p_last_punch_before_mi Number,

        p_message_type Out     Varchar2,
        p_message_text Out     Varchar2
    ) As
        v_by_empno          Varchar2(5);
        v_count_shiftconfig Number;
        v_exists            Number;
    Begin
        v_by_empno     := get_empno_from_meta_id(p_meta_id);
        If v_by_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count_shiftconfig
        From
            ss_shift_flexi_config
        Where
            shiftcode = p_shiftcode;

        If p_ch_fd_start_mi > p_ch_fd_end_mi Then
            p_message_type := not_ok;
            p_message_text := 'Full day start time is grater then end time';
            Return;
        End If;

        If p_ch_fh_start_mi > p_ch_fh_end_mi Then
            p_message_type := not_ok;
            p_message_text := 'First Half start time is grater then end time';
            Return;
        End If;

        If p_ch_sh_start_mi > p_ch_sh_end_mi Then
            p_message_type := not_ok;
            p_message_text := 'Second Half start time is grater then end time';
            Return;
        End If;

        If p_work_hrs_start_mi > p_work_hrs_end_mi Then
            p_message_type := not_ok;
            p_message_text := 'Working hours start time is grater then end time';
            Return;
        End If;

        If v_count_shiftconfig = 0 Then

            Insert Into ss_shift_flexi_config (
                shiftcode,
                ch_fd_start_mi,
                ch_fd_end_mi,
                ch_fh_start_mi,
                ch_fh_end_mi,
                ch_sh_start_mi,
                ch_sh_end_mi,
                full_day_work_mi,
                half_day_work_mi,
                full_week_work_mi,
                work_hrs_start_mi,
                work_hrs_end_mi,
                first_punch_after_mi,
                last_punch_before_mi
            )
            Values (
                p_shiftcode,
                p_ch_fd_start_mi,
                p_ch_fd_end_mi,
                p_ch_fh_start_mi,
                p_ch_fh_end_mi,
                p_ch_sh_start_mi,
                p_ch_sh_end_mi,
                p_full_day_work_mi,
                p_half_day_work_mi,
                p_full_week_work_mi,
                p_work_hrs_start_mi,
                p_work_hrs_end_mi,
                p_first_punch_after_mi,
                p_last_punch_before_mi
            );
        Else

            Update
                ss_shift_flexi_config
            Set
                ch_fd_start_mi = p_ch_fd_start_mi,
                ch_fd_end_mi = p_ch_fd_end_mi,
                ch_fh_start_mi = p_ch_fh_start_mi,
                ch_fh_end_mi = p_ch_fh_end_mi,
                ch_sh_start_mi = p_ch_sh_start_mi,
                ch_sh_end_mi = p_ch_sh_end_mi,
                full_day_work_mi = p_full_day_work_mi,
                half_day_work_mi = p_half_day_work_mi,
                full_week_work_mi = p_full_week_work_mi,
                work_hrs_start_mi = p_work_hrs_start_mi,
                work_hrs_end_mi = p_work_hrs_end_mi,
                first_punch_after_mi = p_first_punch_after_mi,
                last_punch_before_mi = p_last_punch_before_mi
            Where
                shiftcode = p_shiftcode;
        End If;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_delete_shift(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_shiftcode        Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
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

        Delete
            From ss_shiftmast
        Where
            shiftcode = Trim(p_shiftcode);

        Commit;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_delete_shift;

    Procedure sp_shift_details(
        p_person_id                Varchar2,
        p_meta_id                  Varchar2,
        p_shiftcode                Varchar2,
        p_shiftdesc            Out Varchar2,
        p_timein_hh            Out Number,
        p_timein_mn            Out Number,
        p_timeout_hh           Out Number,
        p_timeout_mn           Out Number,
        p_shift4allowance      Out Number,
        p_shift4allowance_text Out Varchar2,
        p_lunch_mn             Out Number,
        p_ot_applicable        Out Number,
        p_ot_applicable_text   Out Varchar2,
        p_message_type         Out Varchar2,
        p_message_text         Out Varchar2
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
            shiftdesc       As shiftdesc,
            timein_hh       As timein_hh,
            timein_mn       As timein_mn,
            timeout_hh      As timeout_hh,
            timeout_mn      As timeout_mn,
            Case shift4allowance
                When 1 Then
                    'Yes'
                When 0 Then
                    'No'
                Else
                    '-'
            End             As shift4allowance_text,
            shift4allowance As shift4allowance,
            lunch_mn        As lunch_mn,
            ot_applicable   As ot_applicable,
            Case ot_applicable
                When 1 Then
                    'Yes'
                When 0 Then
                    'No'
                Else
                    '-'
            End             As ot_applicable_text
        Into
            p_shiftdesc,
            p_timein_hh,
            p_timein_mn,
            p_timeout_hh,
            p_timeout_mn,
            p_shift4allowance_text,
            p_shift4allowance,
            p_lunch_mn,
            p_ot_applicable,
            p_ot_applicable_text
        From
            ss_shiftmast
        Where
            shiftcode = p_shiftcode;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_shift_details;

    Procedure sp_shift_config_details(
        p_person_id                Varchar2,
        p_meta_id                  Varchar2,
        p_shiftcode                Varchar2,
        p_shift_desc           Out Varchar2,
        p_ch_fd_start_mi       Out Number,
        p_ch_fd_end_mi         Out Number,
        p_ch_fh_start_mi       Out Number,
        p_ch_fh_end_mi         Out Number,
        p_ch_sh_start_mi       Out Number,
        p_ch_sh_end_mi         Out Number,
        p_full_day_work_mi     Out Number,
        p_half_day_work_mi     Out Number,
        p_full_week_work_mi    Out Number,
        p_work_hrs_start_mi    Out Number,
        p_work_hrs_end_mi      Out Number,
        p_first_punch_after_mi Out Number,
        p_last_punch_before_mi Out Number,
        p_message_type         Out Varchar2,
        p_message_text         Out Varchar2
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

        select 
            shiftdesc 
        Into 
            p_shift_desc 
        From 
            ss_shiftmast 
        where 
            shiftcode = p_shiftcode;
        Select
            ch_fd_start_mi       As ch_fd_start_mi,
            ch_fd_end_mi         As ch_fd_end_mi,
            ch_fh_start_mi       As ch_fh_start_mi,
            ch_fh_end_mi         As ch_fh_end_mi,
            ch_sh_start_mi       As ch_sh_start_mi,
            ch_sh_end_mi         As ch_sh_end_mi,
            full_day_work_mi     As full_day_work_mi,
            half_day_work_mi     As half_day_work_mi,
            full_week_work_mi    As full_week_work_mi,
            work_hrs_start_mi    As work_hrs_start_mi,
            work_hrs_end_mi      As work_hrs_end_mi,
            first_punch_after_mi As first_punch_after_mi,
            last_punch_before_mi As last_punch_before_mi
        Into
            p_ch_fd_start_mi,
            p_ch_fd_end_mi,
            p_ch_fh_start_mi,
            p_ch_fh_end_mi,
            p_ch_sh_start_mi,
            p_ch_sh_end_mi,
            p_full_day_work_mi,
            p_half_day_work_mi,
            p_full_week_work_mi,
            p_work_hrs_start_mi,
            p_work_hrs_end_mi,
            p_first_punch_after_mi,
            p_last_punch_before_mi
        From
            ss_shift_flexi_config
        Where
            shiftcode = p_shiftcode;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_shift_config_details;
    
    Procedure sp_shift_lunch_details(
        p_person_id                Varchar2,
        p_meta_id                  Varchar2,
        
        p_shiftcode                Varchar2,
        
        p_shift_desc           Out Varchar2,
        p_lunch_start_mi       Out Number,
        p_lunch_end_mi         Out Number,
        
        p_message_type         Out Varchar2,
        p_message_text         Out Varchar2
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

        select 
            shiftdesc 
        Into 
            p_shift_desc 
        From 
            ss_shiftmast 
        where 
            shiftcode = p_shiftcode;
        Select
            lunch_start_mi,
            lunch_end_mi
        Into
            p_lunch_start_mi,
            p_lunch_end_mi
        From
            ss_shift_lunch_config
        Where
            shiftcode = p_shiftcode;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_shift_lunch_details;
    
    Procedure sp_shift_lunch_details_update(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_shiftcode            Varchar2,
        p_lunch_start_mi       Number,
        p_lunch_end_mi         Number,

        p_message_type Out     Varchar2,
        p_message_text Out     Varchar2
    ) As
        v_by_empno          Varchar2(5);
        v_count             Number;
        v_exists            Number;
    Begin
        v_by_empno     := get_empno_from_meta_id(p_meta_id);
        If v_by_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ss_shift_lunch_config
        Where
            shiftcode = p_shiftcode;

        If p_lunch_start_mi > p_lunch_end_mi or p_lunch_end_mi < p_lunch_start_mi Then
            p_message_type := not_ok;
            p_message_text := 'Lunch start time or end time is invalid';
            Return;
        End If;

        If v_count = 0 Then

            Insert Into ss_shift_lunch_config (
                shiftcode,
                lunch_start_mi,
                lunch_end_mi
            )
            Values (
                p_shiftcode,
                p_lunch_start_mi,
                p_lunch_end_mi
            );
        Else

            Update
                ss_shift_lunch_config
            Set
                lunch_start_mi = p_lunch_start_mi,
                lunch_end_mi = p_lunch_end_mi
            Where
                shiftcode = p_shiftcode;
        End If;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;
    
    Procedure sp_shift_half_day_details(
        p_person_id                Varchar2,
        p_meta_id                  Varchar2,
        
        p_shiftcode                Varchar2,
        
        p_shift_desc           Out Varchar2,
        p_hd_fh_start_mi       Out Number,
        p_hd_fh_end_mi         Out Number,
        p_hd_sh_start_mi       Out Number,
        p_hd_sh_end_mi         Out Number,
        
        p_message_type         Out Varchar2,
        p_message_text         Out Varchar2
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

        select 
            shiftdesc 
        Into 
            p_shift_desc 
        From 
            ss_shiftmast 
        where 
            shiftcode = p_shiftcode;
        Select
            hd_fh_start_mi,
            hd_fh_end_mi,
            hd_sh_start_mi,
            hd_sh_end_mi
        Into
            p_hd_fh_start_mi,
            p_hd_fh_end_mi,
            p_hd_sh_start_mi,
            p_hd_sh_end_mi
        From
            ss_shift_half_day_config
        Where
            shiftcode = p_shiftcode;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_shift_half_day_details;
    
    Procedure sp_shift_half_day_details_update(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_shiftcode            Varchar2,
        p_hd_fh_start_mi       Number,
        p_hd_fh_end_mi         Number,
        p_hd_sh_start_mi       Number,
        p_hd_sh_end_mi         Number,

        p_message_type Out     Varchar2,
        p_message_text Out     Varchar2
    ) As
        v_by_empno          Varchar2(5);
        v_count             Number;
        v_exists            Number;
    Begin
        v_by_empno     := get_empno_from_meta_id(p_meta_id);
        If v_by_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ss_shift_half_day_config
        Where
            shiftcode = p_shiftcode;

        If p_hd_fh_start_mi > p_hd_fh_end_mi or p_hd_fh_end_mi < p_hd_fh_start_mi Then
            p_message_type := not_ok;
            p_message_text := 'Half day first half start time or end time is invalid';
            Return;
        End If;

        If p_hd_sh_start_mi > p_hd_sh_end_mi or p_hd_sh_end_mi < p_hd_sh_start_mi Then
            p_message_type := not_ok;
            p_message_text := 'Half day second half start time or end time is invalid';
            Return;
        End If;

        If v_count = 0 Then

            Insert Into ss_shift_half_day_config (
                shiftcode,
                hd_fh_start_mi,
                hd_fh_end_mi,
                hd_sh_start_mi,
                hd_sh_end_mi
            )
            Values (
                p_shiftcode,
                p_hd_fh_start_mi,
                p_hd_fh_end_mi,
                p_hd_sh_start_mi,
                p_hd_sh_end_mi
            );
        Else

            Update
                ss_shift_half_day_config
            Set
                hd_fh_start_mi = p_hd_fh_start_mi,
                hd_fh_end_mi   = p_hd_fh_end_mi,
                hd_sh_start_mi = p_hd_sh_start_mi,
                hd_sh_end_mi   = p_hd_sh_end_mi
            Where
                shiftcode = p_shiftcode;
        End If;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;
End pkg_shift_master;