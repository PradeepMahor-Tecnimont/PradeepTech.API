--------------------------------------------------------
--  DDL for Package Body RAP_GTT
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."RAP_GTT" As

    Procedure get_insert_query_4_gtt (
        p_timesheet_yyyy   Varchar2,
        p_table_name       Varchar2,
        p_insert_query     Out                Varchar2,
        p_success          Out                Varchar2,
        p_message          Out                Varchar2
    ) As

        v_rec_year_mast           ngts_year_mast%rowtype;
        v_rec_tab_gtt_map         rap_tab_gtt_mapping%rowtype;
        v_matching_cols           Varchar2(4000);
        v_insert_into_cols        Varchar2(4500);
        v_select_from_cols        Varchar2(4500);
        v_select_cols             Varchar2(5000);
        v_final_query             Varchar2(10000);
        v_count                   Number;
        v_non_match_default_val   Varchar2(2000);
        v_non_match_cols          Varchar2(2000);
        --P_BATCH_KEY_ID            Varchar2(8);  
    Begin


        Select
            *
        Into v_rec_year_mast
        From
            ngts_year_mast
        Where
            ts_yyyy = p_timesheet_yyyy;

        Select
            *
        Into v_rec_tab_gtt_map
        From
            rap_tab_gtt_mapping
        Where
            tab_name = Upper(p_table_name);

        Select
            Count(*)
        Into v_count
        From
            rap_tab_cols_4_reports
        Where
            tab_name = Upper(p_table_name);

        If v_count = 0 Then
            p_success   := 'KO';
            p_message   := 'Err - The requested table not found in configuration table.';
            return;
        End If;

        Select
            Listagg(col_name,
                    ',') Within Group(
                Order By
                    sort_order
            ) all_cols
        Into v_matching_cols
        From
            rap_tab_cols_4_reports
        Where
            --tab_name = 'TIME_DAILY' 
            tab_name = p_table_name
            And col_name In (
                Select
                    column_name
                From
                    all_tab_columns
                Where
                    owner = Trim(Upper(v_rec_year_mast.ts_userid))
                    And all_tab_columns.table_name = Upper(Trim(p_table_name))
            );

        Begin
            Select
                Listagg(col_name,
                        ',') Within Group(
                    Order By
                        sort_order
                ) non_match_cols,
                Listagg(default_val,
                        ',') Within Group(
                    Order By
                        sort_order
                ) non_match_default_vals
            Into
                v_non_match_cols,
                v_non_match_default_val
            From
                rap_tab_cols_4_reports
            Where
                tab_name = Upper(Trim(p_table_name))
                And col_name Not In (
                    Select
                        column_name
                    From
                        all_tab_columns
                    Where
                        owner = Trim(Upper(v_rec_year_mast.ts_userid))
                        And all_tab_columns.table_name = Upper(Trim(p_table_name))
                );

        Exception
            When Others Then
                Null;
        End;

        If Trim(v_non_match_cols) Is Not Null Then
            v_insert_into_cols   := v_matching_cols || ',' || v_non_match_cols;
            v_select_from_cols   := v_matching_cols || ',' || v_non_match_default_val;
        Else
            v_insert_into_cols   := v_matching_cols;
            v_select_from_cols   := v_matching_cols;
        End If;

        v_final_query    := ' insert into  ' || v_rec_tab_gtt_map.gtt_name || ' (' || v_insert_into_cols || ') Select ' || v_select_from_cols
        || ' from ' || v_rec_year_mast.ts_userid || '.' || p_table_name;

        --dbms_output.put_line(v_final_query);

        p_insert_query   := v_final_query;
        p_success        := 'OK';
    Exception
        When Others Then
            p_success   := 'KO';
            p_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End; 

End rap_gtt;

/
