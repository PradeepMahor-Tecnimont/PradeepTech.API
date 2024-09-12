--------------------------------------------------------
--  DDL for Package RAP_MOVEMAST_EXCEL
--------------------------------------------------------

Create Or Replace Package Body "TIMECURR"."RAP_MOVEMAST_EXCEL" As
    Procedure validate_persons(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_persons             Number,

        p_message_remarks Out Varchar2) As
        v_persons Number;
    Begin
        Begin
            v_persons := To_Number(nvl(p_persons, 0));

            If instr(v_persons, '.') > 0 Then
                p_message_remarks := 'should not have decimal values';
            End If;

            If length(v_persons) > 8 Then
                p_message_remarks := 'should have max. 8 digits';
            End If;

        Exception
            When Others Then
                p_message_remarks := 'should be in Number format';
        End;
    End;

    Procedure import_movemast_costcode(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_costcode            Varchar2,
        p_movemast_json       Blob,
        p_movemast_errors Out Sys_Refcursor,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As
        v_costcode                movemast.costcode%Type;
        v_yymm                    movemast.yymm%Type;

        v_yymm_remarks            Varchar2(200);
        v_movetotcm_remarks       Varchar2(200);
        v_movetosite_remarks      Varchar2(200);
        v_movetoothers_remarks    Varchar2(200);
        v_ext_subcontract_remarks Varchar2(200);
        v_fut_recruit_remarks     Varchar2(200);
        v_int_dept_remarks        Varchar2(200);
        v_hrs_subcont_remarks     Varchar2(200);

        v_pros_month              tsconfig.pros_month%Type;
        v_err_num                 Number;
        v_xl_row_number           Number := 0;
        is_error_in_row           Boolean;
        v_count                   Number;

        Cursor cur_json Is
            Select
                jt.*
            From
                Json_Table(p_movemast_json Format Json, '$[*]'
                    Columns (
                        costcode        Varchar2(4) Path '$.Costcode',
                        yymm            Varchar2(6) Path '$.Yymm',
                        movetotcm       Number      Path '$.Movetotcm',
                        movetosite      Number      Path '$.Movetosite',
                        movetoothers    Number      Path '$.Movetoothers',
                        ext_subcontract Number      Path '$.ExtSubcontract',
                        fut_recruit     Number      Path '$.FutRecruit',
                        int_dept        Number      Path '$.IntDept',
                        hrs_subcont     Number      Path '$.HrsSubcont'
                    )
                ) As "JT";

    Begin
        v_err_num         := 0;

        For c1 In cur_json
        Loop
            is_error_in_row           := false;
            v_yymm_remarks            := Null;
            v_movetotcm_remarks       := Null;
            v_movetosite_remarks      := Null;
            v_movetoothers_remarks    := Null;
            v_ext_subcontract_remarks := Null;
            v_fut_recruit_remarks     := Null;
            v_int_dept_remarks        := Null;
            v_hrs_subcont_remarks     := Null;

            v_xl_row_number           := v_xl_row_number + 1;
            
            --costcode               
            If p_costcode != nvl(c1.costcode, '0') Then
                v_err_num       := v_err_num + 1;
                is_error_in_row := true;

                insert_movemast_errors(
                    p_person_id         => p_person_id,
                    p_meta_id           => p_meta_id,

                    p_id                => v_err_num,
                    p_section           => '',
                    p_excel_row_number  => v_xl_row_number,
                    p_field_name        => 'Costcode',
                    p_error_type        => 0,
                    p_error_type_string => 'Critical',
                    p_message           => 'Costcode does not match',

                    p_message_type      => p_message_type,
                    p_message_text      => p_message_text
                );
            End If;

            --yymm
            Begin
                v_yymm := To_Number(nvl(c1.yymm, 'yymm'));

                If length(c1.yymm) != 6 Then
                    v_err_num       := v_err_num + 1;
                    v_yymm_remarks  := 'Yymm should be 6 characters long';
                    is_error_in_row := true;
                Else
                    Select
                        pros_month
                    Into
                        v_pros_month
                    From
                        tsconfig;
                    If v_pros_month > c1.yymm Then
                        v_err_num       := v_err_num + 1;
                        v_yymm_remarks  := 'Yymm should not be earlier than Processing month';
                        is_error_in_row := true;
                    End If;
                End If;
            Exception
                When Others Then
                    v_err_num       := v_err_num + 1;
                    v_yymm_remarks  := 'Yymm should be in YYYYMM format';
                    is_error_in_row := true;
            End;

            If v_yymm_remarks Is Not Null Then
                insert_movemast_errors(
                    p_person_id         => p_person_id,
                    p_meta_id           => p_meta_id,

                    p_id                => v_err_num,
                    p_section           => '',
                    p_excel_row_number  => v_xl_row_number,
                    p_field_name        => 'Yymm',
                    p_error_type        => 0,
                    p_error_type_string => 'Critical',
                    p_message           => v_yymm_remarks,

                    p_message_type      => p_message_type,
                    p_message_text      => p_message_text
                );
            End If;

            validate_persons(
                p_person_id       => p_person_id,
                p_meta_id         => p_meta_id,
                p_persons         => c1.movetotcm,
                p_message_remarks => v_movetotcm_remarks);

            If v_movetotcm_remarks Is Not Null Then
                v_err_num           := v_err_num + 1;
                v_movetotcm_remarks := 'Move to TCM ' || v_movetotcm_remarks;
                is_error_in_row     := true;

                insert_movemast_errors(
                    p_person_id         => p_person_id,
                    p_meta_id           => p_meta_id,

                    p_id                => v_err_num,
                    p_section           => '',
                    p_excel_row_number  => v_xl_row_number,
                    p_field_name        => 'MoveToTCM',
                    p_error_type        => 0,
                    p_error_type_string => 'Critical',
                    p_message           => v_movetotcm_remarks,

                    p_message_type      => p_message_type,
                    p_message_text      => p_message_text
                );
            End If;

            validate_persons(
                p_person_id       => p_person_id,
                p_meta_id         => p_meta_id,
                p_persons         => c1.movetosite,
                p_message_remarks => v_movetosite_remarks);

            If v_movetosite_remarks Is Not Null Then
                v_err_num            := v_err_num + 1;
                v_movetosite_remarks := 'Move to site ' || v_movetosite_remarks;
                is_error_in_row      := true;

                insert_movemast_errors(
                    p_person_id         => p_person_id,
                    p_meta_id           => p_meta_id,

                    p_id                => v_err_num,
                    p_section           => '',
                    p_excel_row_number  => v_xl_row_number,
                    p_field_name        => 'MoveToSite',
                    p_error_type        => 0,
                    p_error_type_string => 'Critical',
                    p_message           => v_movetosite_remarks,

                    p_message_type      => p_message_type,
                    p_message_text      => p_message_text
                );
            End If;

            validate_persons(
                p_person_id       => p_person_id,
                p_meta_id         => p_meta_id,
                p_persons         => c1.movetoothers,
                p_message_remarks => v_movetoothers_remarks);

            If v_movetoothers_remarks Is Not Null Then
                v_err_num              := v_err_num + 1;
                v_movetoothers_remarks := 'Move to others ' || v_movetoothers_remarks;
                is_error_in_row        := true;

                insert_movemast_errors(
                    p_person_id         => p_person_id,
                    p_meta_id           => p_meta_id,

                    p_id                => v_err_num,
                    p_section           => '',
                    p_excel_row_number  => v_xl_row_number,
                    p_field_name        => 'MoveToOthers',
                    p_error_type        => 0,
                    p_error_type_string => 'Critical',
                    p_message           => v_movetoothers_remarks,

                    p_message_type      => p_message_type,
                    p_message_text      => p_message_text
                );
            End If;

            validate_persons(
                p_person_id       => p_person_id,
                p_meta_id         => p_meta_id,
                p_persons         => c1.ext_subcontract,
                p_message_remarks => v_ext_subcontract_remarks);

            If v_ext_subcontract_remarks Is Not Null Then
                v_err_num                 := v_err_num + 1;
                v_ext_subcontract_remarks := 'External subcontract ' || v_ext_subcontract_remarks;
                is_error_in_row           := true;

                insert_movemast_errors(
                    p_person_id         => p_person_id,
                    p_meta_id           => p_meta_id,

                    p_id                => v_err_num,
                    p_section           => '',
                    p_excel_row_number  => v_xl_row_number,
                    p_field_name        => 'Ext Subcontract',
                    p_error_type        => 0,
                    p_error_type_string => 'Critical',
                    p_message           => v_ext_subcontract_remarks,

                    p_message_type      => p_message_type,
                    p_message_text      => p_message_text
                );
            End If;

            validate_persons(
                p_person_id       => p_person_id,
                p_meta_id         => p_meta_id,
                p_persons         => c1.fut_recruit,
                p_message_remarks => v_fut_recruit_remarks);

            If v_fut_recruit_remarks Is Not Null Then
                v_err_num             := v_err_num + 1;
                v_fut_recruit_remarks := 'Future recruitment ' || v_fut_recruit_remarks;
                is_error_in_row       := true;

                insert_movemast_errors(
                    p_person_id         => p_person_id,
                    p_meta_id           => p_meta_id,

                    p_id                => v_err_num,
                    p_section           => '',
                    p_excel_row_number  => v_xl_row_number,
                    p_field_name        => 'Future recruit',
                    p_error_type        => 0,
                    p_error_type_string => 'Critical',
                    p_message           => v_fut_recruit_remarks,

                    p_message_type      => p_message_type,
                    p_message_text      => p_message_text
                );
            End If;

            validate_persons(
                p_person_id       => p_person_id,
                p_meta_id         => p_meta_id,
                p_persons         => c1.int_dept,
                p_message_remarks => v_int_dept_remarks);

            If v_int_dept_remarks Is Not Null Then
                v_err_num          := v_err_num + 1;
                v_int_dept_remarks := 'Internal dept ' || v_int_dept_remarks;
                is_error_in_row    := true;

                insert_movemast_errors(
                    p_person_id         => p_person_id,
                    p_meta_id           => p_meta_id,

                    p_id                => v_err_num,
                    p_section           => '',
                    p_excel_row_number  => v_xl_row_number,
                    p_field_name        => 'Internal department',
                    p_error_type        => 0,
                    p_error_type_string => 'Critical',
                    p_message           => v_int_dept_remarks,

                    p_message_type      => p_message_type,
                    p_message_text      => p_message_text
                );
            End If;

            validate_persons(
                p_person_id       => p_person_id,
                p_meta_id         => p_meta_id,
                p_persons         => c1.hrs_subcont,
                p_message_remarks => v_hrs_subcont_remarks);

            If v_hrs_subcont_remarks Is Not Null Then
                v_err_num             := v_err_num + 1;
                v_hrs_subcont_remarks := 'Hrs subcontractor ' || v_hrs_subcont_remarks;
                is_error_in_row       := true;

                insert_movemast_errors(
                    p_person_id         => p_person_id,
                    p_meta_id           => p_meta_id,

                    p_id                => v_err_num,
                    p_section           => '',
                    p_excel_row_number  => v_xl_row_number,
                    p_field_name        => 'Hours subcontract',
                    p_error_type        => 0,
                    p_error_type_string => 'Critical',
                    p_message           => v_hrs_subcont_remarks,

                    p_message_type      => p_message_type,
                    p_message_text      => p_message_text
                );
            End If;

            If is_error_in_row = false Then
                Select
                    Count(*)
                Into
                    v_count
                From
                    movemast
                Where
                    costcode = Trim(c1.costcode)
                    And yymm = Trim(c1.yymm);

                If v_count = 0 Then
                    insert_movemast(
                        p_person_id       => p_person_id,
                        p_meta_id         => p_meta_id,

                        p_costcode        => c1.costcode,
                        p_yymm            => c1.yymm,
                        p_movetotcm       => c1.movetotcm,
                        p_movetosite      => c1.movetosite,
                        p_movetoothers    => c1.movetoothers,
                        p_ext_subcontract => c1.ext_subcontract,
                        p_fut_recruit     => c1.fut_recruit,
                        p_int_dept        => c1.int_dept,
                        p_hrs_subcont     => c1.hrs_subcont,

                        p_message_type    => p_message_type,
                        p_message_text    => p_message_text
                    );
                Else
                    update_movemast(
                        p_person_id       => p_person_id,
                        p_meta_id         => p_meta_id,

                        p_costcode        => c1.costcode,
                        p_yymm            => c1.yymm,
                        p_movetotcm       => c1.movetotcm,
                        p_movetosite      => c1.movetosite,
                        p_movetoothers    => c1.movetoothers,
                        p_ext_subcontract => c1.ext_subcontract,
                        p_fut_recruit     => c1.fut_recruit,
                        p_int_dept        => c1.int_dept,
                        p_hrs_subcont     => c1.hrs_subcont,

                        p_message_type    => p_message_type,
                        p_message_text    => p_message_text
                    );
                End If;
            End If;
        End Loop;

        If v_err_num != 0 Then
            p_message_type := not_ok;
            p_message_text := 'Not all records were imported.';

        Else
            p_message_type := ok;
            p_message_text := 'File imported successfully.';
        End If;

        p_movemast_errors := tcmpl_app_config.pkg_process_excel_import_errors.fn_read_error_list(p_person_id => p_person_id,
                                                                                                 p_meta_id   => p_meta_id);

        Commit;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := sqlcode || ' - ' || sqlerrm;
    End import_movemast_costcode;

    Procedure insert_movemast(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_costcode         Varchar2,
        p_yymm             Varchar2,
        p_movetotcm        Number Default Null,
        p_movetosite       Number Default Null,
        p_movetoothers     Number Default Null,
        p_ext_subcontract  Number Default Null,
        p_fut_recruit      Number Default Null,
        p_int_dept         Number Default Null,
        p_hrs_subcont      Number Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        Insert Into movemast (
            costcode,
            yymm,
            movement,
            movetotcm,
            movetosite,
            movetoothers,
            ext_subcontract,
            fut_recruit,
            int_dept,
            hrs_subcont)
        Values(
            p_costcode,
            p_yymm,
            nvl(p_movetotcm, 0) + nvl(p_movetosite, 0) + nvl(p_movetoothers, 0),
            p_movetotcm,
            p_movetosite,
            p_movetoothers,
            p_ext_subcontract,
            p_fut_recruit,
            p_int_dept,
            p_hrs_subcont);

        p_message_type := ok;
        p_message_text := 'Success';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure update_movemast(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_costcode         Varchar2,
        p_yymm             Varchar2,
        p_movetotcm        Number Default Null,
        p_movetosite       Number Default Null,
        p_movetoothers     Number Default Null,
        p_ext_subcontract  Number Default Null,
        p_fut_recruit      Number Default Null,
        p_int_dept         Number Default Null,
        p_hrs_subcont      Number Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        Update
            movemast
        Set
            movement = nvl(p_movetotcm, 0) + nvl(p_movetosite, 0) + nvl(p_movetoothers, 0),
            movetotcm = p_movetotcm,
            movetosite = p_movetosite,
            movetoothers = p_movetoothers,
            ext_subcontract = p_ext_subcontract,
            fut_recruit = p_fut_recruit,
            int_dept = p_int_dept,
            hrs_subcont = p_hrs_subcont
        Where
            costcode = Trim(p_costcode)
            And yymm = Trim(p_yymm);

        p_message_type := ok;
        p_message_text := 'Success';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure insert_movemast_errors(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_id                Number,
        p_section           Varchar2,
        p_excel_row_number  Number,
        p_field_name        Varchar2,
        p_error_type        Number,
        p_error_type_string Varchar2,
        p_message           Varchar2,

        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
    Begin
        tcmpl_app_config.pkg_process_excel_import_errors.sp_insert_errors(
            p_person_id         => p_person_id,
            p_meta_id           => p_meta_id,

            p_id                => p_id,
            p_section           => p_section,
            p_excel_row_number  => p_excel_row_number,
            p_field_name        => p_field_name,
            p_error_type        => p_error_type,
            p_error_type_string => p_error_type_string,
            p_message           => p_message,

            p_message_type      => p_message_type,
            p_message_text      => p_message_text
        );
    End;

End rap_movemast_excel;
/
Grant Execute On "TIMECURR"."RAP_MOVEMAST_EXCEL" To "TCMPL_APP_CONFIG";