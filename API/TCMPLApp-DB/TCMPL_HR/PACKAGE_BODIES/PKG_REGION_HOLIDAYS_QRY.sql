Create Or Replace Package Body tcmpl_hr.pkg_region_holidays_qry As

    Function fn_region_holidays_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_region_code    Varchar2 Default Null,
        p_yyyy           Varchar2 Default Null,
        p_show_sat_sun   Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
        v_generic_search     Varchar2(100);
        v_region_csv         Varchar2(1000);
        v_yyyymm             Varchar2(10);
        v_sat                Varchar2(10);
        v_sun                Varchar2(10);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        If p_generic_search Is Not Null Then
            v_generic_search := '%' || upper(p_generic_search) || '%';
        Else
            v_generic_search := '%';
        End If;
        If p_region_code Is Null Then
            Select
                Listagg(region_code, ',')
            Into
                v_region_csv
            From
                hd_regions;
        Else
            v_region_csv := p_region_code;
        End If;
        If p_yyyy Is Not Null Then
            v_yyyymm := p_yyyy || '%';
        Else

            v_yyyymm := '%';
        End If;
        If p_show_sat_sun = ok Then
            v_sat := 'SHOW_SAT';
            v_sun := 'SHOW_SUN';
        Else
            v_sat := 'SAT';
            v_sun := 'SUN';
        End If;
        Open c For
            Select
                *
            From
                (
                    Select
                        a.holiday                                  As holiday,
                        a.region_code                              As region_code,
                        b.region_name                              As region_name,
                        a.yyyymm                                   As yyyymm,
                        a.weekday                                  As weekday,
                        a.holiday_desc                             As description,
                        Row_Number() Over(Order By a.holiday Desc) row_number,
                        Count(*) Over()                            total_row
                    From
                        hd_region_holidays   a
                        Left Join hd_regions b
                        On a.region_code = b.region_code
                    Where
                        a.region_code In (
                            Select
                                regexp_substr(v_region_csv, '[^,]+', 1, level) value
                            From
                                dual
                            Connect By level <=
                                length(v_region_csv) - length(replace(v_region_csv, ',')) + 1
                        )

                        And a.weekday Not In (v_sat, v_sun)
                        And a.yyyymm Like v_yyyymm/*
                        And (
                            upper(a.yyyymm) Like v_generic_search
                            Or upper(a.weekday) Like v_generic_search
                            Or upper(a.holiday_desc) Like v_generic_search
                        )*/
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_region_holidays_list;

    Procedure sp_region_holidays_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_holiday          Date,
        p_region_code      Number,
        p_region_name  Out Varchar2,
        p_yyyymm       Out Varchar2,
        p_weekday      Out Varchar2,
        p_description  Out Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
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
            hd_region_holidays
        Where
            holiday         = p_holiday
            And region_code = p_region_code;

        If v_exists = 1 Then
            Select
                b.region_name  As region_name,
                a.yyyymm       As yyyymm,
                a.weekday      As weekday,
                a.holiday_desc As description
            Into
                p_region_name,
                p_yyyymm,
                p_weekday,
                p_description
            From
                hd_region_holidays   a
                Left Join hd_regions b
                On a.region_code = b.region_code
            Where
                holiday           = p_holiday
                And a.region_code = p_region_code;

            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Holiday exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_region_holidays_details;

    Function fn_region_holidays_xl_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_region_code    Number Default Null
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
                a.holiday      As holiday,
                a.region_code  As region_code,
                b.region_name  As region_name,
                a.yyyymm       As yyyymm,
                a.weekday      As weekday,
                a.holiday_desc As description
            From
                hd_region_holidays   a
                Left Join hd_regions b
                On a.region_code = b.region_code
            Where
                a.region_code = nvl(p_region_code, a.region_code)
                And (upper(a.yyyymm) Like '%' || upper(Trim(p_generic_search)) || '%'
                Or upper(a.weekday) Like '%' || upper(Trim(p_generic_search)) || '%'
                Or upper(a.holiday_desc) Like '%' || upper(Trim(p_generic_search)) || '%');

        Return c;
    End fn_region_holidays_xl_list;

    Function fn_region_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For

            Select
                to_char(region_code) data_value_field,
                region_name          data_text_field
            From
                hd_regions
            Order By
                region_code;
        Return c;
    End;

End pkg_region_holidays_qry;
/
Grant Execute On tcmpl_hr.pkg_region_holidays_qry To tcmpl_app_config;