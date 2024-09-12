--------------------------------------------------------
--  DDL for Package Body PKG_CABINBOOKING
--------------------------------------------------------

Create Or Replace Editionable Package Body desk_book.pkg_cabinbooking As
    c_emptype Constant Char(1) := 'G';
    Procedure prc_book_desk(
        p_for_empno        Varchar2,
        p_by_empno         Varchar2,
        p_guestno          Varchar2,
        p_attendance_date  Date,
        p_emptype          Varchar2,
        p_guest_name       Varchar2,
        p_deskid           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_next_work_date Date;
        v_count          Number;
        v_desk_date_lock db_desk_date_locking%rowtype;
        row_locked       Exception;
        Pragma exception_init(row_locked, -54);
        v_key_id         Varchar2(8);
        v_office         Varchar2(4);
    Begin
    
        --Check desk booking exists for the day
        Select
            Count(*)
        Into
            v_count
        From
            db_cabin_bookings
        Where
            attendance_date = p_attendance_date
            And deskid = p_deskid;
        If v_count > 0 Then
            p_message_type := not_ok;
            p_message_text := 'Desk already booked for the date.';
            Return;
        End If;

        -- check Guest booking exists for the day based on emptype

        If p_emptype = c_emptype Then
            -- check Guest booking exists for the day
            Select
                Count(*)
            Into
                v_count
            From
                db_cabin_bookings
            Where
                attendance_date = p_attendance_date
                And guestname = upper(p_guest_name);
            If v_count > 0 Then
                p_message_type := not_ok;
                p_message_text := 'Guest Booking for the date already exists.';
                Return;
            End If;
        Else
            --Check employee booking exists for the day
            Select
                Count(*)
            Into
                v_count
            From
                db_cabin_bookings
            Where
                attendance_date = p_attendance_date
                And empno = p_for_empno;
            If v_count > 0 Then
                p_message_type := not_ok;
                p_message_text := 'Booking for the date already exists.';
                Return;
            End If;
        End If;
        
        --Check desk id
        Select
            Count(*)
        Into
            v_count
        From
            dms.dm_deskmaster
        Where
            Trim(deskid) = Trim(p_deskid);
        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Invalid desk.';
            Return;
        End If;

        --Check attendance date
        v_next_work_date := selfservice.iot_swp_common.fn_get_next_work_date(sysdate + 1);
        If p_attendance_date Not Between trunc(sysdate) And v_next_work_date Then
            p_message_type := not_ok;
            p_message_text := 'Invalid attendance date.';
            Return;
        End If;

        v_key_id         := dbms_random.string('X', 8);

        Select
            office
        Into
            v_office
        From
            dms.dm_deskmaster
        Where
            deskid = p_deskid;
        Begin
            If p_emptype = c_emptype Then

                Insert Into db_cabin_bookings (
                    key_id,
                    empno,
                    guestname,
                    attendance_date,
                    deskid,
                    office,
                    emptype,
                    modified_on,
                    modified_by
                )
                Values (
                    v_key_id,
                    p_guestno,
                    upper(p_guest_name),
                    p_attendance_date,
                    p_deskid,
                    v_office,
                    p_emptype,
                    sysdate,
                    p_by_empno
                );
            Else

                Insert Into db_cabin_bookings (
                    key_id,
                    empno,
                    empname,
                    guestname,
                    attendance_date,
                    deskid,
                    office,
                    emptype,
                    modified_on,
                    modified_by
                )
                Values (
                    v_key_id,
                    p_for_empno,
                    get_emp_name(p_for_empno),
                    p_guest_name,
                    p_attendance_date,
                    p_deskid,
                    v_office,
                    p_emptype,
                    sysdate,
                    p_by_empno
                );
            End If;
        Exception
            When dup_val_on_index Then
                Rollback;
                p_message_type := not_ok;
                p_message_text := 'Booking already exists for the selected resource';
                Return;
        End;
        Commit;
        p_message_type   := ok;
        p_message_text   := 'Procedure executed successfully.';
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
        p_attendance_date  Date,
        p_emptype          Varchar2,
        p_guest_name       Varchar2 Default Null,
        p_deskid           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno   Varchar2(5);
        v_guestno Varchar2(5) Default Null;

    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If p_emptype = 'G' Then
            v_guestno := dbms_random.string('X', 5);
        End If;

        prc_book_desk(
            p_for_empno       => v_empno,
            p_by_empno        => v_empno,
            p_guestno         => v_guestno,
            p_attendance_date => trunc(p_attendance_date),
            p_emptype         => p_emptype,
            p_guest_name      => p_guest_name,
            p_deskid          => p_deskid,
            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

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
            From db_cabin_bookings
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
End;