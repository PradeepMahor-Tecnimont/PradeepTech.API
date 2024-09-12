--------------------------------------------------------
--  DDL for Package Body pkg_manage_booking
--------------------------------------------------------

Create Or Replace Editionable Package Body desk_book.pkg_manage_booking As

    Procedure sp_bulk_desk_bookig_4_emp_json(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_parameter_blob   Blob,

        p_errors       Out Sys_Refcursor,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count           Number := 0;
        v_empno           Varchar2(5);
        v_err_num         Number;
        v_xl_row_number   Number := 0;
        is_error_in_row   Boolean;

        v_is_empno_valid  Number;
        v_is_deskid_valid Number;
        v_is_shift_valid  Number;
        v_invalid_msg     Varchar2(9000);
        v_key_id          Varchar2(10);
        v_meta_id         Varchar2(20);
        v_section         Varchar2(2000);
        Cursor cur_json Is
            Select
                jt.*
            From
                Json_Table (upper(p_parameter_blob) Format Json, '$[*]'
                    Columns (
                        empno  Varchar2 (5) Path '$.EMPNO',
                        deskid Varchar2 (7) Path '$.DESKID',
                        shift  Varchar2 (2) Path '$.SHIFT'
                    )
                )
                As jt;
    Begin
        v_err_num := 0;
        v_empno   := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        For c1 In cur_json
        Loop
            Begin
                is_error_in_row := False;
                v_xl_row_number := v_xl_row_number + 1;

                If (c1.empno Is Not Null) Then

                    Select
                        Count(*)
                    Into
                        v_is_empno_valid
                    From
                        vu_emplmast
                    Where
                        upper(Trim(empno)) = upper(Trim(c1.empno))
                        And status         = 1;

                    If v_is_empno_valid > 0 Then
                        Select
                            metaid
                        Into
                            v_meta_id
                        From
                            vu_emplmast
                        Where
                            upper(Trim(empno)) = upper(Trim(c1.empno))
                            And status         = 1;
                    End If;

                Else
                    v_section      := 'Employee validation';
                    p_message_type := not_ok;
                    v_invalid_msg  := 'Invalid Empnoyee no.';
                End If;
                If (c1.deskid Is Not Null) Then
                    Select
                        Count(*)
                    Into
                        v_is_deskid_valid
                    From
                        dms.dm_deskmaster
                    Where
                        upper(Trim(deskid)) = upper(Trim(c1.deskid))
                        And isdeleted       = 0
                        And isblocked       = 0;
                Else
                    v_section      := 'Desk validation';
                    p_message_type := not_ok;
                    v_invalid_msg  := 'Invalid Desk id (Not found/ Blocked or Deleted)';
                End If;

                If (c1.shift Is Not Null) Then

                    Select
                        Count(*)
                    Into
                        v_is_shift_valid
                    From
                        db_map_office_shifts
                    Where
                        upper(Trim(shiftcode)) = upper(Trim(c1.shift));
                Else
                    v_section      := 'Shift validation';
                    p_message_type := not_ok;
                    v_invalid_msg  := 'Invalid Shift Code.';
                End If;

                -- Delete Emplyee desk Area mapping
                Begin
                    Select
                        key_id
                    Into
                        v_key_id
                    From
                        dms.dm_area_type_user_desk_mapping b
                    Where
                        b.empno = c1.empno;

                    If v_key_id Is Not Null Then
                        dms.pkg_dm_area_type_emp_mapping.sp_delete_area_n_desk_emp_mapping(
                            p_person_id    => p_person_id,
                            p_meta_id      => v_meta_id,
                            p_key_id       => v_key_id,
                            p_message_type => p_message_type,
                            p_message_text => p_message_text
                        );
                        v_section := 'Delete Emplyee desk Area mapping';
                    End If;

                Exception
                    When Others Then
                    p_message_type:=ok;
                        Null;
                End;

                -- Delete Desk/Employee booking
                Begin
                    Delete
                        From db_desk_bookings
                    Where
                        (empno                     = c1.empno
                            Or deskid              = c1.deskid)
                            and upper(Trim(shiftcode)) = upper(Trim(c1.shift))
                        And trunc(attendance_date) >= trunc(sysdate);

                    v_section := 'Delete Desk/Employee booking';
                Exception
                    When Others Then
                    p_message_type:=ok;
                        Null;
                End;

                -- Delete from DM_TAG_OBJ_MAPPING
                /*
                    Begin
                        Delete
                            From dms.dm_tag_obj_mapping a
                        Where
                            a.obj_type_id = 1
                            And a.obj_id  = c1.empno;
                    Exception
                        When Others Then
                            Null;
                    End;
                */

                -- Create Booking
                Begin

                    pkg_deskbooking.sp_create(
                        p_person_id       => p_person_id,
                        p_meta_id         => v_meta_id,
                        p_office          => 'MOC4',
                        p_attendance_date => (selfservice.iot_swp_common.fn_get_next_work_date(sysdate + 1)),
                        p_shift           => c1.shift,
                        p_deskid          => c1.deskid,
                        p_message_type    => p_message_type,
                        p_message_text    => p_message_text
                    );


                Exception
                    When Others Then
                    null;
                End;

                If p_message_type = not_ok Then
                    v_err_num       := v_err_num + 1;
                    is_error_in_row := True;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,

                        p_id                => v_err_num,
                        p_section           => v_section,
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Empno : ' || c1.empno ,
                        p_error_type        => 1,
                        p_error_type_string => 'Warning',
                        p_message           => 'Error message : ' || v_invalid_msg || p_message_text,

                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                Else
                    is_error_in_row := False;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,

                        p_id                => v_err_num,
                        p_section           => v_section,
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Empno : ' || c1.empno ,
                        p_error_type        => 2,
                        p_error_type_string => 'Success',
                        p_message           => 'Success.',

                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;

            Exception
                When Others Then
                    p_message_type := 'KO';
                    p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
            End;
        End Loop;
        p_errors  := tcmpl_app_config.pkg_process_excel_import_errors.fn_read_error_list(
                         p_person_id => p_person_id,
                         p_meta_id   => p_meta_id);
        Commit;
        If (v_err_num = 0) Then
            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Procedure executed successfully.';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_bulk_desk_bookig_4_emp_json;

End;
/

Grant Execute On desk_book.pkg_manage_booking To tcmpl_app_config;