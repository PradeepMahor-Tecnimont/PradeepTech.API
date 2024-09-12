--------------------------------------------------------
--  DDL for Package Body PKG_DESKBOOKING
--------------------------------------------------------

Create Or Replace Editionable Package Body desk_book.pkg_deskbooking As
    c_area_deskbook_general Constant Varchar2(4) := 'A005';

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
        v_shift_details    selfservice.ss_shiftmast%rowtype;
        v_desk_date_lock   db_desk_date_locking%rowtype;
        row_locked         Exception;
        Pragma exception_init(row_locked, -54);
        v_key_id           Varchar2(8);
    Begin

        Begin
            Select
                *
            Into
                v_shift_details
            From
                selfservice.ss_shiftmast
            Where
                shiftcode = p_shiftcode;
        Exception
            When Others Then
                p_message_type := not_ok;
                p_message_text := 'Shift not found. Cannot proceed.';
                Return;
        End;
        --
        v_shift_start_time := v_shift_details.timein_hh * 60
                              + v_shift_details.timein_mn
                              + 1;
        v_shift_end_time   := (v_shift_details.timeout_hh * 60)
                              + v_shift_details.timeout_mn;
        --

        --Check desk booking exists for the day

        Select
            Count(*)
        Into
            v_count
        From
            db_desk_bookings
        Where
            attendance_date = p_attendance_date
            And deskid      = p_deskid
            And end_time > v_shift_start_time;

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
                    area_catg_code In (c_area_deskbook_general)
            )
            And Trim(deskid) = Trim(p_deskid);
        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Invalid desk.';
            Return;
        End If;

        --Check attendance date
        --
        v_next_work_date   := selfservice.iot_swp_common.fn_get_next_work_date(sysdate + 1);
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

        --Check if same resource is being booked by others..
        Begin
            Select
                *
            Into
                v_desk_date_lock
            From
                db_desk_date_locking
            Where
                Trim(deskid)               = Trim(p_deskid)
                And trunc(attendance_date) = trunc(p_attendance_date)
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
            And (v_shift_start_time Between start_time And end_time
                Or v_shift_end_time Between start_time And end_time);
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
        
        -- Booking Logs --

        Insert Into db_desk_bookings_log (
            key_id,
            empno,
            deskid,
            attendance_date,
            start_time,
            end_time,
            modified_on,
            modified_by,
            action_type,
            office,
            shiftcode
        )(
            Select
                key_id,
                empno,
                deskid,
                attendance_date,
                start_time,
                end_time,
                modified_on,
                modified_by,
                'INSERT',
                office,
                shiftcode
            From
                db_desk_bookings
            Where
                key_id = v_key_id
        );
        
        -- End Booking Logs --

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

    Procedure prc_change_book_desk(
        p_for_empno        Varchar2,
        p_by_empno         Varchar2,
        p_office           Varchar2,
        p_shiftcode        Varchar2,
        p_deskid           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_next_work_date   Date;
        v_count            Number;
        v_shift_start_time Number(4);
        v_shift_end_time   Number(4);
        v_shift_details    selfservice.ss_shiftmast%rowtype;
        v_desk_date_lock   db_desk_date_locking%rowtype;
        row_locked         Exception;
        Pragma exception_init(row_locked, -54);
        v_key_id           Varchar2(8);
        v_sysdate          Date;
        rec_emp_desk_book  db_desk_bookings%rowtype;
    Begin
        --Check desk booking exists for the day
        v_sysdate          := trunc(sysdate);
        Select
            Count(*)
        Into
            v_count
        From
            db_desk_bookings
        Where
            attendance_date = v_sysdate
            And deskid      = p_deskid
            And empno <> p_for_empno;
        If v_count > 0 Then
            p_message_type := not_ok;
            p_message_text := 'Desk already booked for today.';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            db_desk_bookings
        Where
            attendance_date = v_sysdate
            And empno       = p_for_empno;
        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'No desk booking for today exists. Cannot change.';
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
                    area_catg_code In (c_area_deskbook_general)
            )
            And Trim(deskid) = Trim(p_deskid);
        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Invalid desk.';
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
            selfservice.ss_shiftmast
        Where
            shiftcode = p_shiftcode;

        --
        v_shift_start_time := v_shift_details.timein_hh * 60
                              + v_shift_details.timein_mn
                              + 1;
        v_shift_end_time   := (v_shift_details.timeout_hh * 60)
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
                And attendance_date = v_sysdate
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
            attendance_date = v_sysdate
            And deskid      = p_deskid
            And (v_shift_start_time Between start_time And end_time
                Or v_shift_end_time Between start_time And end_time)
            And empno <> p_for_empno;
        If v_count > 0 Then
            p_message_type := not_ok;
            p_message_text := 'Selected has been already booked by other user.';
            Rollback;
            Return;
        End If;

        Select
            *
        Into
            rec_emp_desk_book
        From
            db_desk_bookings
        Where
            empno               = p_for_empno
            And attendance_date = trunc(sysdate);

        Update
            db_desk_bookings
        Set
            deskid = p_deskid,
            shiftcode = p_shiftcode,
            office = p_office,
            start_time = v_shift_start_time,
            end_time = v_shift_end_time,
            modified_on = sysdate,
            modified_by = p_by_empno
        Where
            key_id = rec_emp_desk_book.key_id;

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
        rec_config_week           selfservice.swp_config_weeks%rowtype;
        rec_smart_attendance_plan selfservice.swp_smart_attendance_plan%rowtype;
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
        Type typ_tab_dates Is
            Table Of Date;
        tab_date         typ_tab_dates;
    Begin
        -- R E T U R N --
        /*
        If commonmasters.pkg_environment.is_production = ok Then
            Return;
        End If;
        */
        -- R E T U R N --

        Delete
            From db_desk_date_locking
        Where
            attendance_date < trunc(sysdate - 1);
        v_next_work_date := selfservice.iot_swp_common.fn_get_next_work_date(sysdate + 1);
        Select
            d_date
        Bulk Collect
        Into
            tab_date
        From
            selfservice.ss_days_details
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
                        area_catg_code In (c_area_deskbook_general)
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

        Insert Into db_desk_bookings_log (
            key_id,
            empno,
            deskid,
            attendance_date,
            start_time,
            end_time,
            modified_on,
            modified_by,
            action_type,
            office,
            shiftcode
        )(
            Select
                key_id,
                empno,
                deskid,
                attendance_date,
                start_time,
                end_time,
                modified_on,
                modified_by,
                'DELETE',
                office,
                shiftcode
            From
                db_desk_bookings
            Where
                key_id = p_key_id
        );

        Delete
            From db_desk_bookings
        Where
            key_id = p_key_id;

        If (Sql%rowcount > 0) Then

            Commit;
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

    Procedure sp_change(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_office           Varchar2,
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
        rec_config_week           selfservice.swp_config_weeks%rowtype;
        rec_smart_attendance_plan selfservice.swp_smart_attendance_plan%rowtype;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        prc_change_book_desk(
            p_for_empno    => v_empno,
            p_by_empno     => v_empno,
            p_office       => p_office,
            p_shiftcode    => p_shift,
            p_deskid       => p_deskid,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

    End;

    Procedure sp_get_last_booked_record(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,
        p_empno               Varchar2 Default Null,
        p_key_id          Out Varchar2,
        p_deskid          Out Varchar2,
        p_attendance_date Out Varchar2,
        p_start_time      Out Varchar2,
        p_end_time        Out Varchar2,
        p_modified_on     Out Varchar2,
        p_modified_by     Out Varchar2,
        p_shiftcode       Out Varchar2,
        p_office          Out Varchar2,
        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As
        v_count Number;
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If p_empno Is Not Null Then
            v_empno := p_empno;
        End If;
        Select
            key_id,
            deskid,
            attendance_date,
            start_time,
            end_time,
            modified_on,
            modified_by,
            shiftcode,
            office
        Into
            p_key_id,
            p_deskid,
            p_attendance_date,
            p_start_time,
            p_end_time,
            p_modified_on,
            p_modified_by,
            p_shiftcode,
            p_office
        From
            (
                Select
                    key_id,
                    empno,
                    deskid,
                    attendance_date,
                    start_time,
                    end_time,
                    modified_on,
                    modified_by,
                    shiftcode,
                    office
                From
                    db_desk_bookings
                Where
                    empno = v_empno
                Order By modified_on Desc,
                    attendance_date
            )
        Where
            Rownum = 1;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When no_data_found Then
            p_message_type := not_ok;
            p_message_text := 'Err - Data not found.';

        When Others Then

            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_pre_book_from_dms(
        p_date Date
    ) As
    Begin

        Insert Into db_desk_bookings (
            key_id,
            empno,
            deskid,
            attendance_date,
            start_time,
            end_time,
            modified_on,
            modified_by,
            shiftcode,
            office
        )

        Select
            dbms_random.string('X', 8),
            empno,
            deskid,
            p_date,
            (b.timein_hh * 60) + timein_mn + 1,
            (b.timeout_hh * 60) + timeout_mn,
            sysdate,
            'SYSTM',
            b.shiftcode,
            'MOC4'
        From
            emp_desks_before_flexi_booking      a
            Cross Join selfservice.ss_shiftmast b
        Where
            b.shiftcode = 'GS'
            And a.empno Is Not Null;
        Commit;
    End;

    Procedure sp_del_absent_emp_booking As
        v_current_time Number(4);
        v_10am         Number(2) := 600;
        v_11am         Number(2) := 660;
    Begin
        v_current_time := (To_Number(to_char(sysdate, 'HH24')) * 60) + To_Number(to_char(sysdate, 'MI'));

        If (v_current_time Not Between v_10am And v_11am) Then
            Return;
        End If;

        Delete
            From db_desk_bookings
        Where
            start_time < v_current_time
            And attendance_date = trunc(sysdate)
            And
            empno Not In
            (
                Select
                    empno
                From
                    selfservice.ss_punch
                Where
                    pdate = trunc(sysdate)
            );
    End;

End;
/

Grant Execute On desk_book.pkg_deskbooking To tcmpl_app_config;