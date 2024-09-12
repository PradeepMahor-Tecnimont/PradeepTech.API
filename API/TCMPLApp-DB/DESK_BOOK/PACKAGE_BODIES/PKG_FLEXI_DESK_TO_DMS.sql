Create Or Replace Editionable Package Body desk_book.pkg_flexi_desk_to_dms As

    Procedure sp_action_on_desk_booking(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_deskid           Varchar2,
        p_empno            Varchar2,
        p_date             Date,
        p_action_type      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_count            Number;
        v_empno            Varchar2(5);
        v_key_id           Varchar2(8);
        v_office           Varchar2(4);
        v_shift            Varchar2(2) := 'GS';
        v_next_date        Date        := selfservice.iot_swp_common.fn_get_next_work_date(p_date + 1);
        v_shift_start_time Number(4);
        v_shift_end_time   Number(4);
        v_shift_details    selfservice.ss_shiftmast%rowtype;
        v_desk_date_lock   db_desk_date_locking%rowtype;
    Begin
        v_empno            := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            *
        Into
            v_shift_details
        From
            selfservice.ss_shiftmast
        Where
            shiftcode = v_shift;

        v_shift_start_time := v_shift_details.timein_hh * 60
                              + v_shift_details.timein_mn
                              + 1;

        v_shift_end_time   := (v_shift_details.timeout_hh * 60)
                              + v_shift_details.timeout_mn;

        If (trim(upper(p_action_type)) = 'ADD') Then

            Select
                office
            Into
                v_office
            From
                dms.dm_deskmaster
            Where
                deskid = p_deskid;
            
            -- Curr date
            v_key_id := dbms_random.string('X', 8);

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
                p_empno,
                p_deskid,
                p_date,
                v_shift,--p_shiftcode,
                v_office,--p_office,
                v_shift_start_time,
                v_shift_end_time,
                sysdate,
                v_empno
            );

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
          
            -- Next working date

            v_key_id := dbms_random.string('X', 8);

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
                p_empno,
                p_deskid,
                v_next_date,
                v_shift,--p_shiftcode,
                v_office,--p_office,
                v_shift_start_time,
                v_shift_end_time,
                sysdate,
                v_empno
            );
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

            Commit;

        End If;

        If (trim(upper(p_action_type)) = 'DEL') Then

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
                    Trim(upper(empno))      = Trim(upper(p_empno))
                    And trunc(attendance_date) >= trunc(p_date)
                    And Trim(upper(deskid)) = Trim(upper(p_deskid))
            );

            Delete
                From db_desk_bookings
            Where
                Trim(upper(empno))      = Trim(upper(p_empno))
                And trunc(attendance_date) >= trunc(p_date)
                And Trim(upper(deskid)) = Trim(upper(p_deskid));

            Delete
                From db_desk_date_locking
            Where
                trunc(attendance_date) >= trunc(p_date)
                And Trim(upper(deskid)) = Trim(upper(p_deskid));
            Commit;

        End If;

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

    Procedure sp_move_to_flexi_json(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_parameter_json   Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_empno                      Varchar2(5);
        v_message_type               Varchar2(2);
        v_message_text               Varchar2(200);
        v_dms_empno                  Varchar2(5);
        v_office_code                Varchar2(200);
        v_area_id                    Varchar2(200);
        v_desk_id                    Varchar2(200);
        v_count                      Number;
        v_smart_desk_booking_enabled Varchar2(2) := not_ok;

        Cursor cur_json Is
            Select
                jt.*
            From
                Json_Table (p_parameter_json Format Json, '$[*]'
                    Columns (
                        deskid Varchar2 (5) Path '$.Deskid'
                    )
                )
                As jt;

    Begin

        If commonmasters.pkg_environment.is_development = ok Or commonmasters.pkg_environment.is_staging = ok Then

            v_empno        := get_empno_from_meta_id(p_meta_id);
            If v_empno = 'ERRRR' Then
                p_message_type := 'KO';
                p_message_text := 'Invalid employee number';
                Return;
            End If;

            For i In
            (
                Select
                    Trim(regexp_substr(p_parameter_json, '[^,]+', 1, level)) desk_id
                From
                    dual
                Connect By
                    level <= regexp_count(p_parameter_json, ',') + 1
            )
            Loop
                dbms_output.put_line(i.desk_id);

                Begin

                    -- Get Details
                    Select
                        office,
                        work_area,
                        deskid
                    Into
                        v_office_code,
                        v_area_id,
                        v_desk_id
                    From
                        dms.dm_deskmaster
                    Where
                        deskid = Trim(i.desk_id);

                    If v_office_code != 'MOC4' Then
                        p_message_type := not_ok;
                        p_message_text := not_ok;
                        Return;
                    End If;

                    Select
                        Count(*)
                    Into
                        v_count
                    From
                        dms.dm_usermaster
                    Where
                        Trim(deskid) = Trim(i.desk_id);

                    If v_count != 1 Then
                        Return;
                    End If;

                    v_count := 0;
                    Select
                        Count(*)
                    Into
                        v_count
                    From
                        dms.dm_deskmaster
                    Where
                        Trim(deskid) = Trim(i.desk_id);

                    If v_count != 1 Then
                        Return;
                    End If;

                    Select
                        smart_desk_booking_enabled
                    Into
                        v_smart_desk_booking_enabled
                    From
                        dms.dm_offices
                    Where
                        office_code = v_office_code;

                    Select
                        empno
                    Into
                        v_dms_empno
                    From
                        dms.dm_usermaster
                    Where
                        Trim(deskid) = Trim(i.desk_id);

                    -- Set mapping
                    If v_smart_desk_booking_enabled = ok Then

                        -- Set flexi booking for next 2 days
                        Begin
                            dms.pkg_dms_movement.sp_create_flexi_booking(p_person_id => p_person_id, p_meta_id => p_meta_id,
                                                                         p_deskid => v_desk_id, p_empno => v_dms_empno, p_message_type =>
                                                                         v_message_type, p_message_text => v_message_text);
                        Exception
                            When Others Then
                                Null;
                        End;
                        -- change area based on zone
                        Begin
                            sp_set_zone_for_area(p_person_id => p_person_id, p_meta_id => p_meta_id,
                                                 p_deskid => v_desk_id, p_message_type => v_message_type,
                                                 p_message_text => v_message_text);
                        Exception
                            When Others Then
                                Null;
                        End;
                    End If;

                Exception
                    When Others Then
                        p_message_type := 'KO';
                        p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
                End;
            End Loop;

            Commit;
            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'KO';

        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_move_to_flexi_json;

    Function fn_get_work_area(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_deskid    Varchar2
    ) Return Varchar2
    As
        v_empno              Varchar2(5);
        v_dms_empno           Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_office             Varchar2(5);
        v_work_area_new      Varchar2(3);
        v_wing_existing      Varchar2(3);
        v_pc_exists          Number;
        v_dual_exists        Number;

        c_tag_pc             Number := 3;
        c_tag_dual_mon       Number := 1;
        

        v_tag_ids            Varchar2(200);
        v_zone               Number;
        v_pc                 Number;
        v_dual_mon           Number;

        c_tag_zone_a         Number := 4;
        c_tag_zone_b         Number := 5;
        c_tag_zone_c         Number := 6;
        c_tag_zone_d         Number := 7;
        c_tag_zone_e         Number := 8;
        c_tag_zone_f         Number := 9;

        v_message_type       Varchar2(2);
        v_message_text       Varchar2(200);
    Begin
        v_empno   := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Return not_ok;
        End If;

       
        Begin

            Select
                empno
            Into
                v_dms_empno
            From
                dms.dm_usermaster
            Where
                Trim(deskid) = Trim(p_deskid);
        Exception
            When Others Then
                Null;
        End;
        Select
            Count(assetid)
        Into
            v_pc_exists
        From
            dms.dm_deskallocation dd,
            dms.dm_assetcode      da
        Where
            da.barcode       = dd.assetid
            And da.assettype = 'PC'
            And deskid       = p_deskid;

        Select
            Count(assetid)
        Into
            v_dual_exists
        From
            dms.dm_deskallocation dd,
            dms.dm_assetcode      da
        Where
            da.barcode       = dd.assetid
            And da.assettype = 'MO'
            And deskid       = p_deskid;

        If v_pc_exists > 0 Then
            v_pc := c_tag_pc;
        Else
            v_pc := -404;
        End If;

        If v_dual_exists > 1 Then
            v_dual_mon := c_tag_dual_mon;
        Else
            v_dual_mon := -404;
        End If;

        If substr(p_deskid, 2, 1) = 'A' Then
            v_zone := c_tag_zone_a;
        Elsif substr(p_deskid, 2, 1) = 'B' Then
            v_zone := c_tag_zone_b;
        Elsif substr(p_deskid, 2, 1) = 'C' Then
            v_zone := c_tag_zone_c;
        Elsif substr(p_deskid, 2, 1) = 'D' Then
            v_zone := c_tag_zone_d;
        Elsif substr(p_deskid, 2, 1) = 'E' Then
            v_zone := c_tag_zone_e;
        Elsif substr(p_deskid, 2, 1) = 'F' Then
            v_zone := c_tag_zone_f;
        Else
            v_zone := -404;
        End If;

        v_tag_ids := to_char(v_zone) || ',' || to_char(v_pc) || ',' || to_char(v_dual_mon);

        v_tag_ids := replace(v_tag_ids, '-404', '');
        v_tag_ids := replace(v_tag_ids, '-404', '');
        v_tag_ids := replace(v_tag_ids, '-404', '');

        Begin
            Select
                empno
            Into
                v_dms_empno
            From
                dms.dm_usermaster
            Where
                deskid = p_deskid;
        Exception
            When Others Then
                Null;
        End;
       
        Select
            Listagg(tag_id, ',') Within
                Group (Order By
                    tag_id)
        Into
            v_tag_ids
        From
            (
                Select
                    *
                From
                    (
                        Select
                            Trim(regexp_substr(v_tag_ids, '[^,]+', 1, level)) As tag_id
                        From
                            dual
                        Connect By level <= regexp_count(v_tag_ids, ',') + 1
                    )
                Order By 1
            );

        Begin
            Select
                obj_id
            Into
                v_work_area_new
            From
                (
                    Select
                        obj_id,
                        Listagg(tag_id, ',') Within
                            Group (Order By tag_id) As key_id_list
                    From
                        dms.dm_tag_obj_mapping
                    Where
                        obj_type_id = 3
                    Group By obj_id
                )
            Where
                Trim(key_id_list) = v_tag_ids;
        Exception
            When Others Then
                v_work_area_new := Null;
        End;

        If v_work_area_new Is Not Null Then
           
           Return v_work_area_new;
           
        Else
            return not_ok ||' - No matching work area found';
        End If;
 
        Return not_ok;
    Exception
        When Others Then
            Return not_ok;
    End fn_get_work_area;

    Procedure sp_set_zone_for_area(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_deskid           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_office             Varchar2(5);
        v_work_area_new      Varchar2(3);
        v_wing_existing      Varchar2(3);
        v_pc_exists          Number;
        v_dual_exists        Number;

        c_tag_pc             Number := 3;
        c_tag_dual_mon       Number := 1;
        c_obj_type_employee  Number := 1;
        v_tag_key_id         Varchar2(200);

        v_tag_ids            Varchar2(200);
        v_zone               Number;
        v_pc                 Number;
        v_dual_mon           Number;

        c_tag_zone_a         Number := 4;
        c_tag_zone_b         Number := 5;
        c_tag_zone_c         Number := 6;
        c_tag_zone_d         Number := 7;
        c_tag_zone_e         Number := 8;
        c_tag_zone_f         Number := 9;
        v_dms_empno          Varchar2(5);

        v_message_type       Varchar2(2);
        v_message_text       Varchar2(200);
    Begin
        v_empno   := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Begin

            Select
                empno
            Into
                v_dms_empno
            From
                dms.dm_usermaster
            Where
                Trim(deskid) = Trim(p_deskid);
        Exception
            When Others Then
                Null;
        End;
        Select
            Count(assetid)
        Into
            v_pc_exists
        From
            dms.dm_deskallocation dd,
            dms.dm_assetcode      da
        Where
            da.barcode       = dd.assetid
            And da.assettype = 'PC'
            And deskid       = p_deskid;

        Select
            Count(assetid)
        Into
            v_dual_exists
        From
            dms.dm_deskallocation dd,
            dms.dm_assetcode      da
        Where
            da.barcode       = dd.assetid
            And da.assettype = 'MO'
            And deskid       = p_deskid;

        If v_pc_exists > 0 Then
            v_pc := c_tag_pc;
        Else
            v_pc := -404;
        End If;

        If v_dual_exists > 1 Then
            v_dual_mon := c_tag_dual_mon;
        Else
            v_dual_mon := -404;
        End If;

        If substr(p_deskid, 2, 1) = 'A' Then
            v_zone := c_tag_zone_a;
        Elsif substr(p_deskid, 2, 1) = 'B' Then
            v_zone := c_tag_zone_b;
        Elsif substr(p_deskid, 2, 1) = 'C' Then
            v_zone := c_tag_zone_c;
        Elsif substr(p_deskid, 2, 1) = 'D' Then
            v_zone := c_tag_zone_d;
        Elsif substr(p_deskid, 2, 1) = 'E' Then
            v_zone := c_tag_zone_e;
        Elsif substr(p_deskid, 2, 1) = 'F' Then
            v_zone := c_tag_zone_f;
        Else
            v_zone := -404;
        End If;

        v_tag_ids := to_char(v_zone) || ',' || to_char(v_pc) || ',' || to_char(v_dual_mon);

        v_tag_ids := replace(v_tag_ids, '-404', '');
        v_tag_ids := replace(v_tag_ids, '-404', '');
        v_tag_ids := replace(v_tag_ids, '-404', '');

        Begin
            Select
                empno
            Into
                v_dms_empno
            From
                dms.dm_usermaster
            Where
                deskid = p_deskid;
        Exception
            When Others Then
                Null;
        End;
        If v_pc = -404 Then
            -- Delete from tag_maping 
            Begin
                Select
                    key_id
                Into
                    v_tag_key_id
                From
                    dms.dm_tag_obj_mapping
                Where
                    obj_id     = v_dms_empno
                    And tag_id = c_tag_pc;

                dms.pkg_dm_tag_obj_mapping.sp_delete_tag_object_mapping(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,
                    p_key_id       => v_tag_key_id,
                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
            Exception
                When Others Then
                    Null;
            End;
        Else
            Begin
                dms.pkg_dm_tag_obj_mapping.sp_add_tag_object_mapping(p_person_id    => p_person_id,
                                                                     p_meta_id      => p_meta_id,
                                                                     p_tag_id       => c_tag_pc,
                                                                     p_obj_id       => v_dms_empno,
                                                                     p_obj_type_id  => c_obj_type_employee,
                                                                     p_message_type => p_message_type,
                                                                     p_message_text => p_message_text);
            Exception
                When Others Then
                    Null;
            End;
        End If;

        If v_dual_mon = -404 Then
            Begin
                Select
                    key_id
                Into
                    v_tag_key_id
                From
                    dms.dm_tag_obj_mapping
                Where
                    obj_id     = v_dms_empno
                    And tag_id = c_tag_dual_mon;

                dms.pkg_dm_tag_obj_mapping.sp_delete_tag_object_mapping(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,
                    p_key_id       => v_tag_key_id,
                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
            Exception
                When Others Then
                    Null;
            End;
        Else
            Begin
                dms.pkg_dm_tag_obj_mapping.sp_add_tag_object_mapping(p_person_id    => p_person_id,
                                                                     p_meta_id      => p_meta_id,
                                                                     p_tag_id       => c_tag_dual_mon,
                                                                     p_obj_id       => v_dms_empno,
                                                                     p_obj_type_id  => c_obj_type_employee,
                                                                     p_message_type => p_message_type,
                                                                     p_message_text => p_message_text);
            Exception
                When Others Then
                    Null;
            End;
        End If;

        Select
            Listagg(tag_id, ',') Within
                Group (Order By
                    tag_id)
        Into
            v_tag_ids
        From
            (
                Select
                    *
                From
                    (
                        Select
                            Trim(regexp_substr(v_tag_ids, '[^,]+', 1, level)) As tag_id
                        From
                            dual
                        Connect By level <= regexp_count(v_tag_ids, ',') + 1
                    )
                Order By 1
            );

        Begin
            Select
                obj_id
            Into
                v_work_area_new
            From
                (
                    Select
                        obj_id,
                        Listagg(tag_id, ',') Within
                            Group (Order By tag_id) As key_id_list
                    From
                        dms.dm_tag_obj_mapping
                    Where
                        obj_type_id = 3
                    Group By obj_id
                )
            Where
                Trim(key_id_list) = v_tag_ids;
        Exception
            When Others Then
                v_work_area_new := Null;
        End;

        If v_work_area_new Is Not Null Then

            If v_pc != -404 Then
                Begin
                    dms.pkg_dm_area_type_emp_mapping.sp_add_area_n_desk_emp_mapping(p_person_id    => p_person_id,
                                                                                    p_meta_id      => p_meta_id,
                                                                                    p_area_id      => v_work_area_new,
                                                                                    p_empno        => v_dms_empno,
                                                                                    p_desk_id      => p_deskid,
                                                                                    p_office_code  => 'MOC4',
                                                                                    p_start_date   => sysdate,
                                                                                    p_message_type => v_message_type,
                                                                                    p_message_text => v_message_text
                    );
                Exception
                    When Others Then
                        Null;
                End;
            End If;

            Update
                dms.dm_deskmaster
            Set
                work_area = v_work_area_new
            Where
                deskid = p_deskid;

            p_message_type := ok;
            p_message_text := 'Done';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching work area found';
        End If;

    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_set_zone_for_area;

  Procedure sp_auto_area_to_Desk_json(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_parameter_json   Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_empno                      Varchar2(5);
        v_message_type               Varchar2(2);
        v_message_text               Varchar2(200);
        v_dms_empno                  Varchar2(5);
        v_office_code                Varchar2(200);
        v_area_id                    Varchar2(200);
        v_desk_id                    Varchar2(200);
        v_count                      Number;
        v_smart_desk_booking_enabled Varchar2(2) := not_ok;

        Cursor cur_json Is
            Select
                jt.*
            From
                Json_Table (p_parameter_json Format Json, '$[*]'
                    Columns (
                        deskid Varchar2 (5) Path '$.Deskid'
                    )
                )
                As jt;

    Begin

        If commonmasters.pkg_environment.is_development = ok Or commonmasters.pkg_environment.is_staging = ok Then

            v_empno        := get_empno_from_meta_id(p_meta_id);
            If v_empno = 'ERRRR' Then
                p_message_type := 'KO';
                p_message_text := 'Invalid employee number';
                Return;
            End If;

            For i In
            (
                Select
                    Trim(regexp_substr(p_parameter_json, '[^,]+', 1, level)) desk_id
                From
                    dual
                Connect By
                    level <= regexp_count(p_parameter_json, ',') + 1
            )
            Loop
                
                Begin
 
                    Select
                        office,
                        work_area,
                        deskid
                    Into
                        v_office_code,
                        v_area_id,
                        v_desk_id
                    From
                        dms.dm_deskmaster
                    Where
                        deskid = Trim(i.desk_id);

                    If v_office_code != 'MOC4' Then
                        p_message_type := not_ok;
                        p_message_text := not_ok;
                        Return;
                    End If;
 
                    Select
                        smart_desk_booking_enabled
                    Into
                        v_smart_desk_booking_enabled
                    From
                        dms.dm_offices
                    Where
                        office_code = v_office_code;
 
                    -- Set mapping
                    If v_smart_desk_booking_enabled = ok Then
 
                        Begin
                            sp_set_zone_for_area(p_person_id => p_person_id, p_meta_id => p_meta_id,
                                                 p_deskid => v_desk_id, p_message_type => v_message_type,
                                                 p_message_text => v_message_text);
                        Exception
                            When Others Then
                                Null;
                        End;
                    End If;

                Exception
                    When Others Then
                        p_message_type := 'KO';
                        p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
                End;
            End Loop;

            Commit;
            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'KO';

        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_auto_area_to_Desk_json;

End;
/