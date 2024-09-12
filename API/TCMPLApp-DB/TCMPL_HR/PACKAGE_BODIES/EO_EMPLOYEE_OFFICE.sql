Create Or Replace Package Body tcmpl_hr.eo_employee_office As

    Procedure prc_create(
        p_by_empno             Varchar2,
        p_for_empno            Varchar2,
        p_office_location_code Varchar2,
        p_start_date           Date,

        p_message_type Out     Varchar2,
        p_message_text Out     Varchar2

    ) As

        v_key_id Varchar2(8);
        v_count  Number;
    Begin

        v_key_id       := dbms_random.string('X', 8);

        --Check employee is valid.
        Select Count(*)
          Into v_count
          From vu_emplmast
         Where empno = p_for_empno;

        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Incorrect EMPNO. Procedure not executed.';
            Return;
        End If;

        --Check record exists beyond start_date
        Select Count(*)
          Into v_count
          From eo_employee_office_map
         Where empno = p_for_empno
           And start_date >= p_start_date;

        If v_count > 0 Then
            p_message_type := not_ok;
            p_message_text := 'Employee office record exists for START_DATE or beyond START_DATE. Procedure not executed.';
            Return;
        End If;

        --Check office is valid
        Select Count(*)
          Into v_count
          From mis_mast_office_location
         Where office_location_code = p_office_location_code;

        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Invalid office location provided. Procedure not executed.';
            Return;
        End If;

        Insert Into eo_employee_office_map (
            key_id,
            empno,
            office_location_code,
            start_date,
            modified_on,
            modified_by
        )
        Values
        (
            v_key_id,
            p_for_empno,
            p_office_location_code,
            p_start_date,
            sysdate,
            p_by_empno
        );

        Commit;
        /*
        sp_after_emp_office_map_created(
            p_person_id         => p_person_id,
            p_meta_id           => p_meta_id,

            p_emp_office_map_id => v_key_id,

            p_message_type      => p_message_type,
            p_message_text      => p_message_text

        );
        */

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure prc_after_emp_office_map_created(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_emp_office_map_id Varchar2,

        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As

        v_emp_office_map_row          eo_employee_office_map%rowtype;
        c_airoli_office_location_code Constant Varchar2(2) := '02';
        c_office_workspace            Constant Number      := 1;
    Begin

        Select *
          Into v_emp_office_map_row
          From eo_employee_office_map
         Where key_id = p_emp_office_map_id;

        If v_emp_office_map_row.office_location_code = c_airoli_office_location_code Then

            selfservice.iot_swp_primary_workspace.sp_assign_pws_emp(
                p_person_id      => p_person_id,
                p_meta_id        => p_meta_id,

                p_empno          => v_emp_office_map_row.empno,
                p_workspace_code => c_office_workspace,
                p_start_date     => v_emp_office_map_row.start_date,

                p_message_type   => p_message_type,
                p_message_text   => p_message_text
            );

        Else
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_create(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_empno                Varchar2,
        p_office_location_code Varchar2,
        p_start_date           Date,

        p_message_type Out     Varchar2,
        p_message_text Out     Varchar2

    ) As
        v_by_empno Varchar2(5);
        v_key_id   Varchar2(8);
        v_count    Number;
    Begin
        v_by_empno := get_empno_from_meta_id(p_meta_id);

        If v_by_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        prc_create(
            p_by_empno             => v_by_empno,
            p_for_empno            => p_empno,
            p_office_location_code => p_office_location_code,
            p_start_date           => p_start_date,

            p_message_type         => p_message_type,
            p_message_text         => p_message_text
        );

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,

        p_name         Out Varchar2,
        p_grade        Out Varchar2,
        p_emptype      Out Varchar2,
        p_parent       Out Varchar2,
        p_assign       Out Varchar2,

        --p_office_location_history Out Sys_Refcursor,
        p_emp_office   Out Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2

    ) As
        v_by_empno Varchar2(5);
        v_key_id   Varchar2(8);
        v_count    Number;
    Begin
        v_by_empno     := get_empno_from_meta_id(p_meta_id);

        If v_by_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select name, parent, assign, emptype, grade
          Into p_name, p_parent, p_assign, p_emptype, p_grade
          From vu_emplmast
         Where empno = p_empno;
        /*
        Open p_office_location_history For
            Select
                a.key_id,
                a.empno,
                a.office_location_code || ' - ' || b.office_desc emp_office_location,
                a.start_date,
                a.modified_on,
                a.modified_by
            From
                eo_employee_office_map   a,
                mis_mast_office_location b
            Where
                a.office_location_code = b.office_location_code;
        */

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_auto_create_4new_joinee(
        p_empno Varchar2
    ) As

        v_count               Number;
        v_emp_record          vu_emplmast%rowtype;
        v_by_empno            Varchar2(5) := 'SYSTM';
        v_emp_office_loc_code Varchar2(2);
        v_message_type        Varchar2(10);
        v_message_text        Varchar2(1000);
        v_30apr               Date        := To_Date('20230430', 'yyyymmdd');
    Begin
        Select Count(*)
          Into v_count
          From vu_emplmast
         Where empno = p_empno
           And status = 1
           And doj > v_30apr;

        If v_count = 0 Then
            tcmpl_app_config.task_scheduler.sp_log_failure(
                p_proc_name     => 'tcmpl_hr.eo_employee_office.sp_auto_create_4new_joinee',
                p_business_name => 'Auto assign office location to employees',
                p_message       => p_empno || ' not found in DB'
            );

        End If;

        Select *
          Into v_emp_record
          From vu_emplmast
         Where empno = p_empno;

        Begin
            Select location_code
              Into v_emp_office_loc_code
              From eo_office_location_map
             Where office_code = v_emp_record.office;

        Exception
            When Others Then
                tcmpl_app_config.task_scheduler.sp_log_failure(
                    p_proc_name     => 'tcmpl_hr.eo_employee_office.sp_auto_create_4new_joinee',
                    p_business_name => 'Auto assign office location to employees',
                    p_message       => p_empno || ' - Office - Location mapping not found.'
                );

                Return;
        End;

        prc_create(
            p_by_empno             => v_by_empno,
            p_for_empno            => p_empno,
            p_office_location_code => v_emp_office_loc_code,
            p_start_date           => v_emp_record.doj,
            p_message_type         => v_message_type,
            p_message_text         => v_message_text
        );

        If v_message_type = ok Then
            tcmpl_app_config.task_scheduler.sp_log_success(
                p_proc_name     => 'tcmpl_hr.eo_employee_office.sp_auto_create_4new_joinee',
                p_business_name => 'Auto assign office location to employees',
                p_message       => p_empno || ' - ' || v_message_text
            );
        Else
            tcmpl_app_config.task_scheduler.sp_log_failure(
                p_proc_name     => 'tcmpl_hr.eo_employee_office.sp_auto_create_4new_joinee',
                p_business_name => 'Auto assign office location to employees',
                p_message       => p_empno || ' - ' || v_message_text
            );
        End If;

    End;

    Procedure sp_delete(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_by_empno Varchar2(5);
    Begin
        v_by_empno     := get_empno_from_meta_id(p_meta_id);
        If v_by_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Delete
          From eo_employee_office_map
         Where key_id = Trim(p_key_id);

        Commit;
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_import_emp_office_location_json(
        p_person_id                      Varchar2,
        p_meta_id                        Varchar2,

        p_office_location_code           Varchar2,
        p_start_date                     Date,
        p_emp_office_location_json       Blob,
        p_emp_office_location_errors Out Sys_Refcursor,

        p_message_type               Out Varchar2,
        p_message_text               Out Varchar2
    ) As
        v_count         Number := 0;
        v_empno         Varchar2(5);
        v_err_num       Number;
        v_xl_row_number Number := 0;
        is_error_in_row Boolean;

        Cursor cur_json Is
            Select jt.*
              From Json_Table (p_emp_office_location_json Format Json, '$[*]'
                       Columns (
                           empno Varchar2 (5) Path '$.Empno'
                       )
                   )
                   As jt;
    Begin
        v_err_num                    := 0;
        v_empno                      := get_empno_from_meta_id(p_meta_id);
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
                prc_create(
                    p_by_empno             => v_empno,
                    p_for_empno            => Trim(upper(c1.empno)),
                    p_office_location_code => p_office_location_code,
                    p_start_date           => p_start_date,

                    p_message_type         => p_message_type,
                    p_message_text         => p_message_text
                );

                If p_message_type = not_ok Then
                    v_err_num       := v_err_num + 1;
                    is_error_in_row := True;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,

                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Empno',
                        p_error_type        => 1,
                        p_error_type_string => 'Warning',
                        p_message           => 'Emp No:' || Trim(upper(c1.empno)) || ' has already assign office location on that day.',

                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                Else
                    is_error_in_row := False;

                    tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,

                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Empno',
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
        p_emp_office_location_errors := tcmpl_app_config.pkg_process_excel_import_errors.fn_read_error_list(
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
    End sp_import_emp_office_location_json;

End;