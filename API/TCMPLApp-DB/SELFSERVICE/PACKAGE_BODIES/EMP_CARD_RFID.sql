--------------------------------------------------------
--  DDL for Package Body EMP_CARD_RFID
--------------------------------------------------------

Create Or Replace Package Body "SELFSERVICE"."EMP_CARD_RFID" As

    Procedure update_emplmast_supplement As

        Cursor cur_emp_card_rfid Is
            Select
                *
            From
                ss_emp_card_rfid_temp;

        Type typ_tbl_card_rfid Is
            Table Of cur_emp_card_rfid%rowtype Index By Pls_Integer;
        tbl_card_rfid typ_tbl_card_rfid;
    Begin
        Insert Into ss_emplmast_supplement (
            empno,
            card_rfid
        )
        Select
            empno,
            card_rfid
        From
            ss_emp_card_rfid_temp
        Where
            empno Not In (
                Select
                    empno
                From
                    ss_emplmast_supplement
            );

        Open cur_emp_card_rfid;
        Loop
            Fetch cur_emp_card_rfid Bulk Collect Into tbl_card_rfid Limit 50;
            For indx In 1..tbl_card_rfid.count
            Loop
                Update
                    ss_emplmast_supplement
                Set
                    card_rfid = tbl_card_rfid(indx).card_rfid
                Where
                    empno = tbl_card_rfid(indx).empno;

            End Loop;

            Commit;
            Exit When cur_emp_card_rfid%notfound;
        End Loop;
    End update_emplmast_supplement;

    Procedure insert_2_temp_tab(
        param_text Varchar2
    ) As

        v_empno     Varchar2(5);
        v_emp_name  Varchar2(500);
        v_serial_no Varchar2(100);
        v_rfid      Varchar2(20);
    Begin

        With
            csv_tab As (
                Select
                    param_text As csv_line
                From
                    dual
            )
        Select
            substr(Trim(','
                    From
                    regexp_substr(csv_line, '^[^,]*', 1, 1)), 1, 5)   empno,
            substr(Trim(','
                    From
                    regexp_substr(csv_line, ',[^,]*', 1, 1)), 1, 100) emp_name,
            substr(Trim(','
                    From
                    regexp_substr(csv_line, ',[^,]*', 1, 2)), 1, 100) serial_no,
            substr(Trim(','
                    From
                    regexp_substr(csv_line, ',[^,]*', 1, 3)), 1, 20)  rfid
        Into
            v_empno,
            v_emp_name,
            v_serial_no,
            v_rfid
        From
            csv_tab;

        Insert Into ss_emp_card_rfid_temp (
            empno,
            card_rfid
        )
        Values (
            v_empno,
            v_rfid
        );

        Commit;
    End;

    Procedure upload_blob_to_temp_tab(p_blob Blob) As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_key_id             Varchar2(5);
        v_count              Number;
        ex_custom            Exception;
        Pragma exception_init(ex_custom, -20002);
        l_str1               Varchar2(4000);
        l_str2               Varchar2(4000);
        l_leftover           Varchar2(4000);
        l_chunksize          Number      := 3000;
        l_offset             Number      := 1;
        l_linebreak          Varchar2(2) := chr(13) || chr(10);
        l_length             Number;

        l_row                Varchar2(200);

    Begin
        l_length := dbms_lob.getlength(p_blob);
        dbms_output.put_line(l_length);

        Delete
            From ss_emp_card_rfid_temp;

        While l_offset < l_length
        Loop
            l_str1     := l_leftover || utl_raw.cast_to_varchar2(dbms_lob.substr(p_blob, l_chunksize, l_offset));

            l_leftover := Null;
            l_str2     := l_str1;
            While l_str2 Is Not Null
            Loop
                If instr(l_str2, l_linebreak) <= 0 Then
                    l_leftover := l_str2;
                    l_str2     := Null;
                Else
                    l_row  := (substr(l_str2, 1, instr(l_str2, l_linebreak) - 1));

                    insert_2_temp_tab(l_row);
                    --
                    l_str2 := substr(l_str2, instr(l_str2, l_linebreak) + 2);
                End If;
            End Loop;

            l_offset   := l_offset + l_chunksize;
        End Loop;

        If l_leftover Is Not Null Then
            l_row := substr(l_leftover, 1, 200);
            --Insert into table
            insert_2_temp_tab(l_row);
            --

            --Pipe Row ( l_row );
            --dbms_output.put_line(l_leftover);
        End If;

        Return;
    End;

    Procedure import_card_rfid(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_blob             Blob,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_key_id             Varchar2(5);
        v_count              Number;
        ex_custom            Exception;
        Pragma exception_init(ex_custom, -20002);
        l_str1               Varchar2(4000);
        l_str2               Varchar2(4000);
        l_leftover           Varchar2(4000);
        l_chunksize          Number      := 3000;
        l_offset             Number      := 1;
        l_linebreak          Varchar2(2) := chr(13) || chr(10);
        l_length             Number;
        v_blob               Blob;
        l_row                Varchar2(200);
    Begin
        If commonmasters.pkg_environment.is_production = not_ok Then
            p_message_type := ok;
            p_message_text := 'WARNING - This utility is available in Production only';
            --Return;
        End If;
        v_key_id       := dbms_random.string('X', 5);
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return;
        End If;

        upload_blob_to_temp_tab(p_blob => p_blob);

        update_emplmast_supplement;
        p_message_type := ok;
        p_message_text := 'Procedure executed succesfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure import_from_keyid(
        p_key_id Varchar2
    ) As
        v_blob         Blob;
        v_message_type Varchar2(10);
        v_message_text Varchar2(1000);

    Begin
        Select
            file_blob
        Into
            v_blob
        From
            ss_punch_upload_blob
        Where
            key_id = p_key_id;
        import_card_rfid(

            p_person_id    => '',
            p_meta_id      => '4EFFBD4567B5FCD5C2D9',
            p_blob         => v_blob,
            p_message_type => v_message_type,
            p_message_text => v_message_text

        );
    End;

End emp_card_rfid;
/