--------------------------------------------------------
--  DDL for Package Body PKG_DMS_OFFICES_QRY
--------------------------------------------------------

Create Or Replace Package Body "DMS"."PKG_DMS_OFFICES_QRY" As

    Function fn_offices (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                                  office_code,
                                  office_name,
                                  office_desc,
                                  office_location_val,
                                  office_location_txt,
                                  is_smart_desk_booking_enabled As smart_desk_booking_enabled_val,
                                  (
                                      Case is_smart_desk_booking_enabled
                                          When 'OK' Then
                                              'Yes'
                                          Else
                                              'No'
                                      End
                                  )                             As smart_desk_booking_enabled_txt,
                                  row_number,
                                  total_row
                                From
                                  (
                                      Select
                                          a.office_code,
                                          a.office_name,
                                          a.office_desc,
                                          a.office_location_code       As office_location_val,
                                          b.office_location_desc       As office_location_txt,
                                          a.smart_desk_booking_enabled As is_smart_desk_booking_enabled,
                                          Row_Number()
                                          Over(
                                               Order By
                                                  a.office_name
                                          )                            row_number,
                                          Count(*)
                                          Over()                       total_row
                                        From
                                          dm_offices                        a,
                                          tcmpl_hr.mis_mast_office_location b
                                       Where
                                              a.office_location_code = b.office_location_code And
                                          ( upper(
                                              a.office_code
                                          ) Like '%' || upper(
                                              Trim(p_generic_search)
                                          ) || '%' Or
                                            upper(
                                                a.office_name
                                            ) Like '%' || upper(
                                                Trim(p_generic_search)
                                            ) || '%' Or
                                            upper(
                                                b.office_location_desc
                                            ) Like '%' || upper(
                                                Trim(p_generic_search)
                                            ) || '%' )
                                  )
                    Where
                       row_number Between ( nvl(
                           p_row_number,
                           0
                       ) + 1 ) And ( nvl(
                           p_row_number,
                           0
                       ) + p_page_length );
        Return c;
    End fn_offices;

    Function fn_xl_download_offices (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                                  office_code,
                                  office_name,
                                  office_desc,
                                  office_location_txt As office_location,
                                  (
                                      Case is_smart_desk_booking_enabled
                                          When 'OK' Then
                                              'Yes'
                                          Else
                                              'No'
                                      End
                                  )                   As smart_desk_booking_enabled
                                From
                                  (
                                      Select
                                          a.office_code,
                                          a.office_name,
                                          a.office_desc,
                                          a.office_location_code       As office_location_val,
                                          b.office_location_desc       As office_location_txt,
                                          a.smart_desk_booking_enabled As is_smart_desk_booking_enabled
                                        From
                                          dm_offices                        a,
                                          tcmpl_hr.mis_mast_office_location b
                                       Where
                                              a.office_location_code = b.office_location_code And
                                          ( upper(
                                              a.office_code
                                          ) Like '%' || upper(
                                              Trim(p_generic_search)
                                          ) || '%' Or
                                            upper(
                                                a.office_name
                                            ) Like '%' || upper(
                                                Trim(p_generic_search)
                                            ) || '%' Or
                                            upper(
                                                b.office_location_desc
                                            ) Like '%' || upper(
                                                Trim(p_generic_search)
                                            ) || '%' )
                                  )
                    Order By
                       office_name;
        Return c;
    End fn_xl_download_offices;

    Procedure sp_offices_details (
        p_person_id                      Varchar2,
        p_meta_id                        Varchar2,
        p_office_code                    Varchar2,
        p_office_name                    Out Varchar2,
        p_office_desc                    Out Varchar2,
        p_office_location_val            Out Varchar2,
        p_office_location_txt            Out Varchar2,
        p_smart_desk_booking_enabled_val Out Varchar2,
        p_smart_desk_booking_enabled_txt Out Varchar2,
        p_message_type                   Out Varchar2,
        p_message_text                   Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            a.office_name,
            a.office_desc,
            a.office_location_code       As office_location_val,
            b.office_location_desc       As office_location_txt,
            a.smart_desk_booking_enabled As smart_desk_booking_enabled_val,
            (
                Case a.smart_desk_booking_enabled
                    When 'OK' Then
                        'Yes'
                    Else
                        'No'
                End
            )                            As smart_desk_booking_enabled_txt
          Into
            p_office_name,
            p_office_desc,
            p_office_location_val,
            p_office_location_txt,
            p_smart_desk_booking_enabled_val,
            p_smart_desk_booking_enabled_txt
          From
            dm_offices                        a,
            tcmpl_hr.mis_mast_office_location b
         Where
                a.office_location_code = b.office_location_code And
            a.office_code          = p_office_code;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_offices_details;

End pkg_dms_offices_qry;