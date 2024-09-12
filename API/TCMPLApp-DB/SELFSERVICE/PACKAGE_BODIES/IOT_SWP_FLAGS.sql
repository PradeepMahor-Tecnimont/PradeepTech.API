Create Or Replace Package Body selfservice.iot_swp_flags As
    Procedure get_all_flags(
        p_person_id                        Varchar2,
        p_meta_id                          Varchar2,

        p_restricted_desks_in_sws_plan Out Varchar2,
        p_open_desks_in_sws_plan       Out Varchar2,

        p_message_type                 Out Varchar2,
        p_message_text                 Out Varchar2

    ) As
        Type typ_tab_swp_flags Is Table Of swp_flags%rowtype Index By Pls_Integer;
        tab_swp_flags typ_tab_swp_flags;
    Begin
        Select
            *
        Bulk Collect
        Into
            tab_swp_flags
        From
            swp_flags;
        For i In 1..tab_swp_flags.count
        Loop
            If tab_swp_flags(i).flag_code = 'SWP_RESTRICTED_OPEN_DESK_AREA_FOR_SMART_PLANNING' Then
                p_restricted_desks_in_sws_plan := trim(tab_swp_flags(i).flag_value);
            End If;
            If tab_swp_flags(i).flag_code = 'SWP_OPEN_DESK_AREA_FOR_SMART_PLANNING' Then
                p_open_desks_in_sws_plan := trim(tab_swp_flags(i).flag_value);
            End If;

        End Loop;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;
    
     procedure get_flag_details(
        p_person_id             varchar2,
        p_meta_id               varchar2,

        p_flag_id               varchar2,
        p_flag_code         out varchar2,
        p_flag_desc         out varchar2,
        p_flag_value        out varchar2,
        p_flag_value_number out number,
        p_flag_value_date   out date,

        p_message_type      out varchar2,
        p_message_text      out varchar2

    ) as
   v_count number;
   begin
   
      select flag_code, flag_desc, flag_value, flag_value_number, flag_value_date
        into p_flag_code, p_flag_desc, p_flag_value, p_flag_value_number, p_flag_value_date
        from swp_flags
       where flag_id = p_flag_id;
   
      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';
       exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;
   end get_flag_details;

    
End iot_swp_flags;