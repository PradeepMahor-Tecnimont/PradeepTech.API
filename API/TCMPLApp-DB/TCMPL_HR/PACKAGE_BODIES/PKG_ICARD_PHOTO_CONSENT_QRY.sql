Create Or Replace Package Body "TCMPL_HR"."PKG_ICARD_PHOTO_CONSENT_QRY" As

    Function fn_icard_photo_consent_list(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_generic_search   Varchar2 Default Null,
        p_is_consent       Varchar2 Default Null,
        p_new_img_uploaded Varchar2 Default Null,
        p_row_number       Number,
        p_page_length      Number
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
                        a.empno                                               As empno,                  -- CHAR 
                        initcap(pkg_common.fn_get_employee_name(a.empno))     name,
                        is_consent,
                        to_char(consent_on, 'dd-Mon-yy')                      consent_date,
                        to_char(photo_upload_on, 'dd-Mon-yy')                 photo_changed_date,
                        to_char(hr_reset_on, 'dd-Mon-yy')                     hr_reset_date,
                        initcap(pkg_common.fn_get_employee_name(hr_reset_by)) hr_name,
                        Row_Number() Over(Order By a.empno)                   row_number,
                        Count(*) Over()                                       total_row
                    From
                        icard_photo_consent                a, vu_emplmast b
                    Where
                        a.empno                = b.empno
                        And a.is_consent       = nvl(Trim(p_is_consent), a.is_consent)
                        And a.new_img_uploaded = nvl(Trim(p_new_img_uploaded), a.new_img_uploaded)
                        And (
                            upper(a.is_consent) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(a.new_img_uploaded) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(a.modified_by) Like '%' || upper(Trim(p_generic_search))
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_icard_photo_consent_list;

    Procedure sp_icard_photo_consent_details(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_empno                Varchar2 Default Null,

        p_employee         Out Varchar2,
        p_is_consent       Out Varchar2,
        p_new_img_uploaded Out Varchar2,
        p_modified_on      Out Date,
        p_modified_by      Out Varchar2,
        p_message_type     Out Varchar2,
        p_message_text     Out Varchar2
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

        If (p_empno Is Not Null) Then
            v_empno := p_empno;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            icard_photo_consent
        Where
            empno = v_empno;

        If v_exists = 1 Then

            Select
                is_consent, new_img_uploaded, modified_on, modified_by
            Into
                p_is_consent, p_new_img_uploaded, p_modified_on, p_modified_by
            From
                icard_photo_consent
            Where
                empno = v_empno;

            Select
                empno || ' : ' || name
            Into
                p_employee
            From
                vu_emplmast
            Where
                empno = v_empno;

            Commit;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Icard photo exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_icard_photo_consent_details;

    Function sp_icard_photo_consent_xl_list(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_generic_search   Varchar2 Default Null,
        p_is_consent       Varchar2 Default Null,
        p_new_img_uploaded Varchar2 Default Null

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
            select 
                distinct b.empno as empno, 
                    b.email,
                    ( b.empno || ' : ' || b.name ) as employee,
                    b.parent as parent_code,
                    c.name as  parent_name,
                    ( case a.is_consent when 'OK' then 'Yes' else '' end ) as is_consent,
                    ( case a.new_img_uploaded when 'OK' then 'Yes' else '' end ) as new_img_uploaded,
                    a.consent_on as consent_date,
                    a.hr_reset_on hr_reset_date,
                    initcap(
                        pkg_common.fn_get_employee_name(
                            a.hr_reset_by
                        )
                    ) hr_reset_by,
                    a.modified_on modified_on,
                    a.photo_upload_on as new_img_upload_date,
                    initcap(
                        pkg_common.fn_get_employee_name(
                            a.modified_by
                        )
                    ) modified_by                 
              from icard_photo_consent a,
                   vu_emplmast b , vu_costmast c
             where b.empno = a.empno(+) 
                and b.emptype in ('R','C','F') 
                and b.status =1
                and b.parent = c.costcode
                /*And a.is_consent       = nvl(Trim(p_is_consent), a.is_consent)
                And a.new_img_uploaded = nvl(Trim(p_new_img_uploaded), a.new_img_uploaded)
                And (upper(a.is_consent) Like '%' || upper(Trim(p_generic_search)) || '%'
                    Or upper(a.new_img_uploaded) Like '%' || upper(Trim(p_generic_search)) || '%'
                    Or upper(a.modified_by) Like '%' || upper(Trim(p_generic_search)))
                    */;

        Return c;
    End sp_icard_photo_consent_xl_list;

End pkg_icard_photo_consent_qry;