--------------------------------------------------------
--  DDL for Package Body GENERATE_CSHARP_CODE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TCMPL_HR"."GENERATE_CSHARP_CODE" As

    Procedure proc_to_class (
        p_package_name  In   Varchar2,
        p_proc_name     In   Varchar2,
        p_class         Out  Varchar2
    ) As

        Cursor cur_proc_params Is
        Select
            object_name,
            package_name,
            argument_name,
            data_type,
            in_out
        From
            user_arguments
        Where
                package_name = upper(p_package_name)
            And object_name = upper(p_proc_name)
        Order By
            position;

        v_class       Varchar2(4000);
        v_properties  Varchar2(2000);
        v_datatype    Varchar2(60);
        v_class_name  Varchar2(60);
    Begin
        v_class       := 'public class CLASS_NAME ! { ! public string CommandText {get => "'
                   || upper(p_package_name)
                   || '.'
                   || upper(p_proc_name)
                   || '"; } ! PARAM_NAMES ! }';

        v_class_name  := replace(initcap(p_package_name)
                                || initcap(p_proc_name), '_',
                               '');

        v_class       := replace(v_class, 'CLASS_NAME', v_class_name);
        For cur_row In cur_proc_params Loop
            v_datatype :=
                Case cur_row.data_type
                    When 'VARCHAR2' Then
                        'string'
                    When 'CHAR' Then
                        'string'
                    When 'DATE' Then
                        'DateTime'
                    When 'NUMBER' Then
                        'Int32'
                    Else 'string'
                End;

            If cur_row.in_out = 'OUT' Then
                v_properties := v_properties
                                || ' public '
                                || v_datatype
                                || ' Out'
                                || trim(replace(initcap(nvl(cur_row.argument_name,'return_value')), '_'))
                                || ' { get; set; } ! ';

            Else
                v_properties := v_properties
                                || ' public '
                                || v_datatype
                                || '    '
                                || replace(initcap(cur_row.argument_name), '_')
                                || ' { get; set; } ! ';
            End If;

        End Loop;

        v_class       := replace(replace(v_class, 'PARAM_NAMES', v_properties), '!',
                          chr(13));

        p_class       := v_class;
    End proc_to_class;

    Procedure table_to_class (
        p_table_view_name  Varchar2,
        p_class            Out Varchar2
    ) As

        Cursor cur_columns Is
        Select
            table_name,
            column_name,
            data_type
        From
            user_tab_columns
        Where
            table_name = upper(p_table_view_name);

        v_class       Varchar(4000);
        v_properties  Varchar2(3900);
        v_datatype    Varchar2(60);
        v_class_name  Varchar2(60);
    Begin
        v_class  := 'public class CHANGE_CLASS_NAME ! { ! PARAM_NAMES ! }';
        For cur_row In cur_columns Loop
            v_datatype    :=
                Case cur_row.data_type
                    When 'VARCHAR2' Then
                        'string'
                    When 'CHAR' Then
                        'string'
                    When 'DATE' Then
                        'DateTime'
                    When 'NUMBER' Then
                        'Int32'
                    Else 'string'
                End;

            v_properties  := v_properties
                            || ' public '
                            || v_datatype
                            || ' '
                            || replace(initcap(cur_row.column_name), '_')
                            || '{get;set;}! ';

        End Loop;

        v_class  := replace(replace(v_class, 'PARAM_NAMES', v_properties), '!',
                          chr(13));

        p_class  := v_class;
    End;

End generate_csharp_code;


/

  GRANT EXECUTE ON "TCMPL_HR"."GENERATE_CSHARP_CODE" TO "TCMPL_APP_CONFIG";
