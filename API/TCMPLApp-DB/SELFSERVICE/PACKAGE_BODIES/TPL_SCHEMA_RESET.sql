Create Or Replace Package Body "SELFSERVICE"."TPL_SCHEMA_RESET" As
    Type typ_array Is Varray(3) Of Varchar2(30);

    ary_schemas typ_array := typ_array('SELFSERVICE', 'TIMECURR', 'DMS');

    Procedure drop_tables(
        p_schema_name      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        not_ok         Varchar2(2) := 'KO';
        ok             Varchar2(2) := 'OK';
        b_schema_found Boolean     := false;
        v_schema_name  Varchar2(30);
    Begin
        v_schema_name  := upper(p_schema_name);
        --Check ENVIRONMENT is staging
        If commonmasters.pkg_environment.is_staging = not_ok Then
            p_message_type := not_ok;
            p_message_text := 'Err - Incorrect environment.';
            Return;
        End If;

        p_message_type := not_ok;
        p_message_text := 'Err - Incorrect schema name.';

        --Check schema exists
        For i In 1..ary_schemas.count
        Loop
            If v_schema_name = ary_schemas(i) Then
                b_schema_found := true;
                Exit;
            End If;
        End Loop;
        
        --If schema not found then exit
        If Not b_schema_found Then
            Return;
        End If;

        For c In (
            Select
                object_name, object_type
            From
                user_objects
            Where
                object_type In('TABLE', 'VIEW')

        )
        Loop
            Begin
                If c.object_type = 'TABLE' Then
                    Execute Immediate ('DROP TABLE ' || v_schema_name || '.' || c.object_name || ' CASCADE CONSTRAINTS');
                Else
                    Execute Immediate ('DROP VIEW ' || v_schema_name || '.' || c.object_name);
                End If;
                dbms_output.put_line('Success: DROP ' || c.object_type || ' - ' || v_schema_name || '.' || c.object_name);
            Exception
                When Others Then
                    dbms_output.put_line('FAILED: DROP ' || c.object_type || ' - ' || v_schema_name || '.' || c.object_name);

            End;
        End Loop;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End drop_tables;

End tpl_schema_reset;
/