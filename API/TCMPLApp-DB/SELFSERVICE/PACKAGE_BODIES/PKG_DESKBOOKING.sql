Create Or Replace Package Body selfservice.pkg_deskbooking As
    c_area_deskbook_restricted Constant Varchar2(4) := 'A006';
    c_area_deskbook_general    Constant Varchar2(4) := 'A005';

    Procedure prc_book_desk(
        p_for_empno        Varchar2,
        p_by_empno         Varchar2,
        p_office           Varchar2,
        p_attendance_date  Date,
        p_shiftcode        Varchar2,
        p_deskid           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_next_work_date   Date;
        v_count            Number;
        v_shift_start_time Number(4);
        v_shift_end_time   Number(4);
        v_shift_details    ss_shiftmast%rowtype;
        v_desk_date_lock   db_desk_date_locking%rowtype;
        row_locked         Exception;
        Pragma exception_init(row_locked, -54);
        v_key_id           Varchar2(8);
    Begin
        --Check desk booking exists for the day

        Select
            Count(*)
        Into
            v_count
        From
            db_desk_bookings
        Where
            attendance_date = p_attendance_date
            And deskid      = p_deskid;
        If v_count > 0 Then
            p_message_type := not_ok;
            p_message_text := 'Desk already booked for the date.';
            Return;
        End If;

        --Check employee booking exists for the day
        Select
            Count(*)
        Into
            v_count
        From
            db_desk_bookings
        Where
            attendance_date = p_attendance_date
            And empno       = p_for_empno;
        If v_count > 0 Then
            p_message_type := not_ok;
            p_message_text := 'Booking for the date already exists.';
            Return;
        End If;
        --Check desk id
        Select
            Count(*)
        Into
            v_count
        From
            dms.dm_deskmaster
        Where
            work_area In (
                Select
                    area_key_id
                From
                    dms.dm_desk_areas
                Where
                    area_catg_code In (c_area_deskbook_restricted, c_area_deskbook_general)
            );
        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Invalid desk.';
            Return;
        End If;

        --Check attendance date
        --
        v_next_work_date   := iot_swp_common.fn_get_next_work_date(sysdate + 1);
        If p_attendance_date Not Between trunc(sysdate) And v_next_work_date Then
            p_message_type := not_ok;
            p_message_text := 'Invalid attendance date.';
            Return;
        End If;
        
        --Check Office + Shift
        --
        Select
            Count(*)
        Into
            v_count
        From
            dms.dm_offices       o,
            db_map_office_shifts s
        Where
            o.office_code                  = s.office_id
            And smart_desk_booking_enabled = ok
            And o.office_code              = p_office
            And s.shiftcode                = p_shiftcode;

        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Invalid Office+Shift.';
            Return;
        End If;

        Select
            *
        Into
            v_shift_details
        From
            ss_shiftmast
        Where
            shiftcode = p_shiftcode;

        --
        v_shift_start_time := v_shift_details.timein_hh * 60
                              + v_shift_details.timein_mn
                              + 1;
        v_shift_end_time   := v_shift_details.timeout_hh * 60
                              + v_shift_details.timeout_mn;
        --
        
        --Check if same resource is being booked by others..
        Begin
            Select
                *
            Into
                v_desk_date_lock
            From
                db_desk_date_locking
            Where
                deskid              = p_deskid
                And attendance_date = p_attendance_date
            For Update Nowait;
        Exception
            When no_data_found Then
                p_message_type := not_ok;
                p_message_text := 'Booking not yet opened for selected options.';
                Return;

            When row_locked Then
                p_message_type := not_ok;
                p_message_text := 'Selected desk is being booked by other users.';
                Return;
            When Others Then
                p_message_type := not_ok;
                p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
                Return;
        End;

        --Check Overlapping of Desk Booking
        --
        Select
            Count(*)
        Into
            v_count
        From
            db_desk_bookings
        Where
            attendance_date = p_attendance_date
            And deskid      = p_deskid
            And (v_shift_start_time Between start_time And end_time Or
                v_shift_end_time Between start_time And end_time);
        If v_count > 0 Then
            p_message_type := not_ok;
            p_message_text := 'Selected has been already booked by other user.';
            Rollback;
            Return;
        End If;
        v_key_id           := dbms_random.string('X', 8);
        Insert Into db_desk_bookings (
            key_id,
            empno,
            deskid,
            attendance_date,
            shiftcode,
            office,
            start_time,
            end_time,
            modified_on,
            modified_by
        )
        Values (
            v_key_id,
            p_for_empno,
            p_deskid,
            p_attendance_date,
            p_shiftcode,
            p_office,
            v_shift_start_time,
            v_shift_end_time,
            sysdate,
            p_by_empno
        );

        Commit;
        p_message_type     := ok;
        p_message_text     := 'Procedure executed successfully.';
    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            Return;
    End;

    Procedure sp_create(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_office           Varchar2,
        p_attendance_date  Date,
        p_shift            Varchar2,
        p_deskid           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        strsql                    Varchar2(600);
        v_count                   Number;
        v_empno                   Varchar2(5);
        v_attendance_date         Date;
        v_desk                    Varchar2(20);
        rec_config_week           swp_config_weeks%rowtype;
        rec_smart_attendance_plan swp_smart_attendance_plan%rowtype;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        prc_book_desk(
            p_for_empno       => v_empno,
            p_by_empno        => v_empno,
            p_office          => p_office,
            p_attendance_date => trunc(p_attendance_date),
            p_shiftcode       => p_shift,
            p_deskid          => p_deskid,
            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

    End;

    Procedure sp_generate_desk_dates_lock As
        v_next_work_date Date;
        Type typ_tab_dates Is Table Of Date;
        tab_date         typ_tab_dates;
    Begin

        Delete
            From db_desk_date_locking
        Where
            attendance_date < trunc(sysdate - 1);
        v_next_work_date := iot_swp_common.fn_get_next_work_date(sysdate + 1);
        Select
            d_date Bulk Collect
        Into
            tab_date
        From
            ss_days_details
        Where
            d_date Between trunc(sysdate) And v_next_work_date;
        For i In 1..tab_date.count
        Loop

            Insert Into db_desk_date_locking
            Select
                deskid,
                tab_date(i)
            From
                dms.dm_deskmaster
            Where
                work_area In (
                    Select
                        area_key_id
                    From
                        dms.dm_desk_areas
                    Where
                        area_catg_code In ('A006', 'A005')
                )
                And deskid Not In (
                    Select
                        deskid
                    From
                        db_desk_date_locking
                    Where
                        attendance_date = tab_date(i)
                );
        End Loop;
    End;

    Procedure sp_delete(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_key_id           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Delete
            From db_desk_bookings
        Where
            key_id    = p_key_id
            And empno = v_empno
            And trunc(attendance_date) > trunc(sysdate);

        If (Sql%rowcount > 0) Then
            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Procedure not executed.';
        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

End;