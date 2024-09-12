Create Or Replace Package Body "SELFSERVICE"."PKG_DB_AUTOBOOK_PREFERENCES_QRY" As

    Function fn_db_autobook_preferences_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            Select
                *
            From
                (
                    Select
                        a.key_id                            As key_id,
                        a.empno                             As empno,
                        a.office                            As office,
                        a.shift                             As shift,
                        a.desk_area                         As desk_area,
                        a.modified_on                       As modified_on,
                        a.modified_by                       As modified_by,
                        Row_Number() Over(Order By a.empno) row_number,
                        Count(*) Over()                     total_row
                    From
                        db_autobook_preferences a
                    Where
                        a.empno = v_empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_db_autobook_preferences_list;

    Procedure sp_db_autobook_preferences_details(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,
        p_key_id         Out Varchar2,
        p_empno          Out Varchar2,
        p_office         Out Varchar2,
        p_shift          Out Varchar2,
        p_desk_area      Out Varchar2,
        p_shift_desc     Out Varchar2,
        p_desk_area_desc Out Varchar2,
        p_modified_on    Out Date,
        p_modified_by    Out Varchar2,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            db_autobook_preferences
        Where
            empno = v_empno;

        If v_exists = 1 Then
            Select
                a.key_id,
                a.empno,
                a.office,
                a.shift,
                b.shiftdesc As sihif_desc,
                a.desk_area,
                c.area_desc area_desc,
                a.modified_on,
                a.modified_by
            Into
                p_key_id,
                p_empno,
                p_office,
                p_shift,
                p_shift_desc,
                p_desk_area,
                p_desk_area_desc,
                p_modified_on,
                p_modified_by
            From
                db_autobook_preferences a,
                ss_shiftmast            b,
                dm_vu_desk_areas        c
            Where
                a.empno         = v_empno
                And a.shift     = b.shiftcode
                And a.desk_area = c.area_key_id;

            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Autobook preferences exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_db_autobook_preferences_details;

    Function fn_db_autobook_preferences_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            Select
                a.key_id      As key_id,
                a.empno       As empno,
                a.office      As office,
                a.shift       As shift,
                a.desk_area   As desk_area,
                a.modified_on As modified_on,
                a.modified_by As modified_by
            From
                db_autobook_preferences a;
        Return c;
    End fn_db_autobook_preferences_list;

    Function fn_db_autobook_4_calendar_list(
        p_person_id  Varchar2,
        p_meta_id    Varchar2,
        p_start_date Date,
        p_end_date   Date
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            Select
                --d_date                                          as  start,
                --d_date                                          as  end,
                --to_char(d_date, 'dd-Mon-yyyy') || ' - ' || attend As title,
                booking_type                As title,
                d_date                      As "Start",
                d_date                      As "End",
                to_char(d_date, 'yyyymmdd') As id,
                to_char(d_date, 'yyyymmdd') As id,
                Case
                    When booking_type = 'Paused' Then
                        '#f0ad4e'
                    Else
                        '#3788d8'
                End                         As background_color
            From
                (
                    Select
                        d_date,
                        d_day,
                        Case
                            When h.holiday Is Not Null Then
                                Null
                            When xd.attendance_date Is Not Null Then
                                'Paused'
                            Else
                                'Autobook'
                        End booking_type
                    From
                        ss_days_details                          d
                        Left Outer Join ss_holidays              h
                        On d.d_date = h.holiday
                        Left Outer Join db_autobook_exclude_date xd
                        On d.d_date = xd.attendance_date
                        And empno   = v_empno
                    Where
                        d_date Between p_start_date And p_end_date
                        And d_date > trunc(sysdate + 1)
                )
            Where
                booking_type Is Not Null;

        /*                  
                          Select             
                          level as id,
                            (trunc(sysdate) + level)  as "Start",
                            (trunc(sysdate) + level)  as "End",
                            
                            --iot_swp_common.fn_get_next_work_date(sysdate + level) as work_date,
                            to_char((sysdate + level), 'dd-Mon-yyyy') ||' - '||( case when trunc((sysdate + level)) = trunc(iot_swp_common.fn_get_next_work_date(sysdate + level)) then 'Yes'
                                   --when trunc(sysdate + 2) = trunc(sysdate + level) then 'Yes'
                                   else 'No' end ) as Title,
                            ( case when trunc((sysdate + level)) = trunc(iot_swp_common.fn_get_next_work_date(sysdate + level)) then 'Yes'
                                   --when trunc(sysdate + 2) = trunc(sysdate + level) then 'Yes'
                                   else 'No' end ) as can_exclude       
                          From
                            dual
                        Connect By
                            level <= 30;
                            */
        Return c;
    End fn_db_autobook_4_calendar_list;

End pkg_db_autobook_preferences_qry;
/
Grant Execute On "SELFSERVICE"."PKG_DB_AUTOBOOK_PREFERENCES_QRY" To "TCMPL_APP_CONFIG";