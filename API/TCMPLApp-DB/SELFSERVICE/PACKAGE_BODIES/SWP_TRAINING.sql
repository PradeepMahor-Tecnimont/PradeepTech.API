--------------------------------------------------------
--  DDL for Package Body SWP_TRAINING
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."SWP_TRAINING" As

    Procedure insert_to_temp_table(
        p_blob_id     Varchar2,
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As

        Cursor cur_xl_data Is
            Select
                row_nr,
                col_nr,
                string_val,
                number_val
            From
                ss_xl_blob_data
            Where
                key_id       = p_blob_id
                And sheet_nr = 1
                And col_nr   = 1
                And Trim(nvl(string_val, to_char(number_val))) Is Not Null;

        Type typ_tab_xl_data Is
            Table Of cur_xl_data%rowtype;
        tab_xl_data        typ_tab_xl_data;
        Type rec_4_varay Is Record(
                col_no  Number,
                col_val Number
            );
        Type typ_emp_training Is
            Varray(5) Of rec_4_varay;
        varay_emp_training typ_emp_training;
    Begin
        Delete
            From swp_emp_training_temp
        Where
            key_id = p_blob_id;

        Commit;
        Open cur_xl_data;
        Loop
            Fetch cur_xl_data Bulk Collect Into tab_xl_data Limit 50;
            For i In 1..tab_xl_data.count
            Loop
                Select
                    col_nr,
                    number_val
                Bulk Collect
                Into
                    varay_emp_training
                From
                    ss_xl_blob_data
                Where
                    key_id     = p_blob_id
                    And row_nr = tab_xl_data(i).row_nr
                    And col_nr In (
                        3, 4, 5, 6, 7
                    );

                Insert Into swp_emp_training_temp (
                    empno,
                    security,
                    onedrive365,
                    planner,
                    sharepoint16,
                    teams,
                    key_id
                )
                Values (
                    lpad(tab_xl_data(i).string_val, 5, '0'),
                        varay_emp_training(1).col_val,
                        varay_emp_training(2).col_val,
                        varay_emp_training(3).col_val,
                        varay_emp_training(4).col_val,
                        varay_emp_training(5).col_val,
                    p_blob_id
                );

                varay_emp_training := typ_emp_training();
            End Loop;

            Commit;
            Exit When cur_xl_data%notfound;
        End Loop;

        Delete
            From ss_xl_blob_data
        Where
            key_id = p_blob_id;
        Commit;
    Exception
        When Others Then
            Rollback;
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure insert_into_prod_table(
        p_blob_id     Varchar2,
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As
    Begin
        Delete
            From swp_emp_training
        Where
            empno In (
                Select
                    empno
                From
                    swp_emp_training_temp
                Where
                    key_id = p_blob_id
            );

        Insert Into swp_emp_training (
            empno,
            security,
            onedrive365,
            planner,
            sharepoint16,
            teams
        )
        Select
            empno,
            security,
            onedrive365,
            planner,
            sharepoint16,
            teams
        From
            swp_emp_training_temp
        Where
            key_id = p_blob_id;

        Commit;

        Delete
            From swp_emp_training_temp
        Where
            key_id = p_blob_id;

        Commit;

        p_success := 'OK';
    Exception
        When Others Then
            Rollback;
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure update_swp_training_from_xl(
        p_blob_id     Varchar2,
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As
        v_count Number;
    Begin
        --Check Data exists for the said blob id
        Select
            Count(*)
        Into
            v_count
        From
            ss_xl_blob_data
        Where
            key_id = p_blob_id;

        If v_count = 0 Then
            p_success := 'KO';
            p_message := 'Err - Blob data not found.';
            Return;
        End If;

        --Keep only FIRST sheet data

        Delete
            From ss_xl_blob_data
        Where
            key_id = p_blob_id
            And sheet_nr <> 1;

        Delete
            From ss_xl_blob_data
        Where
            key_id     = p_blob_id
            And row_nr = 1;

        --Delete all rows where first column (EMPNO) is blank

        Delete
            From ss_xl_blob_data
        Where
            key_id = p_blob_id
            And row_nr In (
                Select
                    row_nr
                From
                    ss_xl_blob_data
                Where
                    key_id     = p_blob_id
                    And col_nr = 1
                    And Trim(nvl(string_val, to_char(number_val))) Is Null
            );

        Commit;

        --Delete all rows where first column (EMPNO) is blank
        Delete
            From ss_xl_blob_data
        Where
            key_id = p_blob_id
            And row_nr In (
                Select
                    row_nr
                From
                    ss_xl_blob_data
                Where
                    key_id     = p_blob_id
                    And col_nr = 1
                    And Trim(nvl(string_val, to_char(number_val))) Is Null
            );

        Commit;

        --Update number val from string val
        Update
            ss_xl_blob_data
        Set
            number_val = to_number(string_val)
        Where
            key_id = p_blob_id
            And string_val Is Not Null
            And col_nr In (
                3, 4, 5, 6, 7
            );

        Commit;

        --check if any data is blank
        Select
            Count(*)
        Into
            v_count
        From
            ss_xl_blob_data
        Where
            key_id = p_blob_id
            And number_val Is Null
            And col_nr Not In (
                1, 2
            );

        If v_count > 0 Then
            p_success := 'KO';
            p_message := 'Err - Blank values found.';
            Return;
        End If;

        --check values other than 1 / 0
        Select
            Count(*)
        Into
            v_count
        From
            ss_xl_blob_data
        Where
            key_id = p_blob_id
            And number_val Not In (0, 1)
            And col_nr Not In (
                1, 2
            );

        If v_count > 0 Then
            p_success := 'KO';
            p_message := 'Err - Incorrect values provided.';
            Return;
        End If;

        --Update temp table

        insert_to_temp_table(p_blob_id, p_success, p_message);
        If p_success = 'KO' Then
            Rollback;
            Return;
        End If;
        Commit;

        --Update prod table
        insert_into_prod_table(p_blob_id, p_success, p_message);
        If p_success = 'KO' Then
            Rollback;
            Return;
        End If;
    Exception
        When Others Then
            Rollback;
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End update_swp_training_from_xl;

    Procedure upload_training_excel(
        p_blob        Blob,
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As
        v_blob_id Varchar2(8);
    Begin
        xl_blob.upload_blob_file(
            p_blob    => p_blob,
            p_blob_id => v_blob_id,
            p_success => p_success,
            p_message => p_message
        );

        If p_success = 'KO' Then
            Return;
        End If;
        If v_blob_id Is Null Then
            p_success := 'KO';
            p_message := 'Err - Invlaid key internal error while uploading data.';
        End If;
        update_swp_training_from_xl(
            p_blob_id => v_blob_id,
            p_success => p_success,
            p_message => p_message
        );
    Exception
        When Others Then
            Rollback;
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

End swp_training;

/

  GRANT EXECUTE ON "SELFSERVICE"."SWP_TRAINING" TO "TCMPL_APP_CONFIG";
