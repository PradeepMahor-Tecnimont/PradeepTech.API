--------------------------------------------------------
--  DDL for Package Body ERS_HR_QRY
--------------------------------------------------------

Create Or Replace Package Body "TCMPL_HR"."ERS_HR_QRY" As

    Function fn_ers_hr_vacancy_list(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,
        p_generic_search         Varchar2,
        p_row_number             Number,
        p_page_length            Number,
        p_vacancy_status         Number   Default Null,
        p_job_ref_code           Varchar2 Default Null,
        p_job_location           Varchar2 Default Null,
        p_vacancy_open_from_date Date     Default Null,
        p_vacancy_open_to_date   Date Default Null
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
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
                        job_key_id,
                        job_reference_code,
                        costcode,
                        short_desc,
                        job_type,
                        job_location,
                        ers_qry.fn_ers_get_cv_count(job_key_id, Null)        As uploaded_cvs,
                        Row_Number() Over (Order By job_reference_code Desc) row_number,
                        Count(*) Over ()                                     total_row,
                        job_status,
                        job_open_date
                    From
                        ers_vacancies
                    Where
                        (upper(job_reference_code) Like upper('%' || Trim(p_generic_search) || '%') Or
                            upper(short_desc) Like upper('%' || Trim(p_generic_search) || '%') Or
                            upper(job_type) Like upper('%' || Trim(p_generic_search) || '%') Or
                            upper(job_location) Like upper('%' || Trim(p_generic_search) || '%'))
                        And job_status         = nvl(p_vacancy_status, job_status)
                        And job_reference_code = nvl(p_job_ref_code, job_reference_code)
                        And job_location       = nvl(p_job_location, job_location)
                        And (job_open_date Between
                        nvl(p_vacancy_open_from_date, job_open_date)
                        And nvl(p_vacancy_open_to_date, job_open_date))
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                job_open_date Desc,
                job_reference_code;
        Return c;
    End fn_ers_hr_vacancy_list;

    Function fn_ers_hr_cv_list(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,
        p_generic_search         Varchar2,
        p_row_number             Number,
        p_page_length            Number,
        p_vacancy_status         Number   Default Null,
        p_job_ref_code           Varchar2 Default Null,
        p_job_location           Varchar2 Default Null,
        p_vacancy_open_from_date Date     Default Null,
        p_vacancy_open_to_date   Date Default Null
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
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
                        ers_qry.fn_ers_get_cv_status(evc.cv_status)         cv_status,
                        evc.vacancy_job_key_id,
                        ers_qry.fn_ers_get_ref_code(evc.vacancy_job_key_id) job_reference_code,
                        to_char(evc.refered_on, 'DD-Mon-YYYY')              date_of_posting,
                        evc.candidate_name,
                        evc.candidate_email,
                        evc.candidate_mobile,
                        evc.candidate_cv_disp_name,
                        evc.candidate_cv_os_name,
                        Row_Number() Over (Order By evc.cv_status Desc)     row_number,
                        Count(*) Over ()                                    total_row,
                        evc.refered_by_empno,
                        evc.refered_by_empno || ' ' || eve.name             name,
                        evc.pan,
                        ers_qry.fn_ers_get_location(evc.vacancy_job_key_id) job_location,
                        evc.cv_status                                       status
                    From
                        ers_vacancy_cvs evc,
                        ers_vu_emplmast eve
                    Where
                        eve.empno                                               = evc.refered_by_empno
                        And (upper(evc.candidate_name) Like upper('%' || Trim(p_generic_search) || '%') Or
                            upper(evc.candidate_email) Like upper('%' || Trim(p_generic_search) || '%') Or
                            upper(ers_qry.fn_ers_get_cv_status(evc.cv_status)) Like upper('%' || Trim(p_generic_search) ||
                            '%')
                            Or
                            upper(ers_qry.fn_ers_get_ref_code(evc.vacancy_job_key_id)) Like upper('%' || Trim(p_generic_search) ||
                            '%') Or
                            upper(evc.candidate_mobile) Like upper('%' || Trim(p_generic_search) || '%'))
                        And evc.cv_status                                       = nvl(p_vacancy_status, evc.cv_status)
                        And ers_qry.fn_ers_get_ref_code(evc.vacancy_job_key_id) = nvl(p_job_ref_code, ers_qry.fn_ers_get_ref_code(
                        evc.vacancy_job_key_id))
                        And ers_qry.fn_ers_get_location(evc.vacancy_job_key_id) = nvl(p_job_location, ers_qry.fn_ers_get_location(
                        evc.vacancy_job_key_id))
                        And (evc.refered_on Between nvl(p_vacancy_open_from_date, evc.refered_on) And nvl(p_vacancy_open_to_date,
                        evc.refered_on))
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                date_of_posting Desc,
                job_reference_code;
        Return c;
    End fn_ers_hr_cv_list;

    Procedure sp_hr_vacancy_detail(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,
        p_job_key_id         Varchar2,
        p_costcode       Out Varchar2,
        p_costcode_name  Out Varchar2,
        p_job_ref_code   Out Varchar2,
        p_job_open_date  Out Date,
        p_short_desc     Out Varchar2,
        p_job_type       Out Varchar2,
        p_job_location   Out Varchar2,
        p_job_desc01     Out Varchar2,
        p_job_desc02     Out Varchar2,
        p_job_desc03     Out Varchar2,
        p_job_close_date Out Date,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            ev.costcode,
            evc.name,
            ev.job_reference_code,
            ev.job_open_date,
            ev.short_desc,
            ev.job_type,
            ev.job_location,
            ev.job_desc_01,
            ev.job_desc_02,
            ev.job_desc_03,
            ev.job_close_date
        Into
            p_costcode,
            p_costcode_name,
            p_job_ref_code,
            p_job_open_date,
            p_short_desc,
            p_job_type,
            p_job_location,
            p_job_desc01,
            p_job_desc02,
            p_job_desc03,
            p_job_close_date
        From
            ers_vacancies   ev,
            ers_vu_costmast evc
        Where
            ev.costcode             = evc.costcode
            And Trim(ev.job_key_id) = Trim(p_job_key_id);

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_hr_vacancy_detail;

    Procedure sp_hr_cv_refer_emp_detail(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,
        p_vacancy_job_key_id  Varchar2,
        p_candidate_email     Varchar2,
        p_empno           Out Varchar2,
        p_emp_name        Out Varchar2,
        p_emp_email       Out Varchar2,
        p_emp_parent      Out Varchar2,
        p_emp_parent_name Out Varchar2,
        p_short_desc      Out Varchar2,
        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            evcv.refered_by_empno,
            eve.name,
            eve.email,
            eve.parent,
            evc.name parent_name,
            ev.short_desc
        Into
            p_empno,
            p_emp_name,
            p_emp_email,
            p_emp_parent,
            p_emp_parent_name,
            p_short_desc
        From
            ers_vacancy_cvs evcv,
            ers_vu_emplmast eve,
            ers_vu_costmast evc,
            ers_vacancies   ev
        Where
            ev.costcode                 = evc.costcode
            And evcv.refered_by_empno   = eve.empno
            And ev.job_key_id           = evcv.vacancy_job_key_id
            And evcv.candidate_email    = Trim(p_candidate_email)
            And evcv.vacancy_job_key_id = Trim(p_vacancy_job_key_id);

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_hr_cv_refer_emp_detail;

    Procedure sp_hr_cv_detail(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,
        p_vacancy_job_key_id   Varchar2,
        p_candidate_email      Varchar2,
        p_short_desc       Out Varchar2,
        p_candidate_name   Out Varchar2,
        p_candidate_mobile Out Varchar2,
        p_pan              Out Varchar2,
        p_cv_status        Out Number,
        p_cv_status_desc   Out Varchar2,
        p_message_type     Out Varchar2,
        p_message_text     Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            ev.short_desc,
            evcv.candidate_name,
            evcv.candidate_mobile,
            evcv.pan,
            evcv.cv_status,
            evcs.cv_status_desc
        Into
            p_short_desc,
            p_candidate_name,
            p_candidate_mobile,
            p_pan,
            p_cv_status,
            p_cv_status_desc
        From
            ers_vacancy_cvs       evcv,
            ers_vacancies         ev,
            ers_vacancy_cv_status evcs
        Where
            evcs.cv_status_code         = evcv.cv_status
            And ev.job_key_id           = evcv.vacancy_job_key_id
            And evcv.candidate_email    = Trim(p_candidate_email)
            And evcv.vacancy_job_key_id = Trim(p_vacancy_job_key_id);

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_hr_cv_detail;

    Function fn_location_select_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                location data_value_field,
                location data_text_field
            From
                ers_location_mast
            Where
                isactive = 1
            Order By
                location;
        Return c;
    End fn_location_select_list;

    Function fn_job_reference_select_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
            Distinct
                job_reference_code data_value_field,
                job_reference_code data_text_field
            From
                ers_vacancies
            Order By
                job_reference_code;
        Return c;
    End fn_job_reference_select_list;

    Function fn_ers_hr_cv_list_excel(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,
        p_vacancy_status         Number   Default Null,
        p_job_ref_code           Varchar2 Default Null,
        p_job_location           Varchar2 Default Null,
        p_vacancy_open_from_date Date     Default Null,
        p_vacancy_open_to_date   Date Default Null
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                ers_qry.fn_ers_get_cv_status(evc.cv_status)         cv_status,
                ers_qry.fn_ers_get_ref_code(evc.vacancy_job_key_id) job_reference_code,
                to_char(evc.refered_on, 'DD-Mon-YYYY')              date_of_posting,
                evc.candidate_name,
                evc.candidate_email,
                evc.candidate_mobile,
                evc.candidate_cv_disp_name,
                evc.refered_by_empno,
                evc.refered_by_empno || ' ' || eve.name             name,
                evc.pan,
                ers_qry.fn_ers_get_location(evc.vacancy_job_key_id) job_location
            From
                ers_vacancy_cvs evc,
                ers_vu_emplmast eve
            Where
                eve.empno                                               = evc.refered_by_empno
                And evc.cv_status                                       = nvl(p_vacancy_status, evc.cv_status)
                And ers_qry.fn_ers_get_ref_code(evc.vacancy_job_key_id) = nvl(p_job_ref_code, ers_qry.fn_ers_get_ref_code(
                evc.vacancy_job_key_id))
                And ers_qry.fn_ers_get_location(evc.vacancy_job_key_id) = nvl(p_job_location, ers_qry.fn_ers_get_location(
                evc.vacancy_job_key_id))
                And (evc.refered_on Between nvl(p_vacancy_open_from_date, evc.refered_on) And nvl(p_vacancy_open_to_date,
                evc.refered_on))
            Order By
                date_of_posting Desc,
                job_reference_code;
        Return c;
    End fn_ers_hr_cv_list_excel;

    Function fn_change_job_ref_select_list(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,
        p_vacancy_job_key_id Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                ev.job_key_id                  data_value_field,
                ev.job_reference_code || ' -- ' || ev.short_desc || ' -- ' || ev.job_location || ' -- ' ||
                ev.costcode || ' ' || evc.name data_text_field
            From
                ers_vacancies   ev,
                ers_vu_costmast evc
            Where
                ev.job_status   = 1
                And ev.costcode = evc.costcode
                And ev.job_key_id != p_vacancy_job_key_id
            Order By
                2;

        Return c;
    End fn_change_job_ref_select_list;

    Function fn_ers_hr_vacancy_list_excel(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,
        p_vacancy_status         Number   Default Null,
        p_job_ref_code           Varchar2 Default Null,
        p_job_location           Varchar2 Default Null,
        p_vacancy_open_from_date Date     Default Null,
        p_vacancy_open_to_date   Date Default Null
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                job_reference_code,
                costcode,
                short_desc,
                job_type,
                job_location,
                ers_qry.fn_ers_get_cv_count(job_key_id, Null) As uploaded_cvs,
                Case job_status
                    When 1 Then
                        'Open'
                    Else
                        'Closed'
                End                                           job_status,
                job_open_date
            From
                ers_vacancies
            Where
                job_status             = nvl(p_vacancy_status, job_status)
                And job_reference_code = nvl(p_job_ref_code, job_reference_code)
                And job_location       = nvl(p_job_location, job_location)
                And (job_open_date Between
                nvl(p_vacancy_open_from_date, job_open_date)
                And nvl(p_vacancy_open_to_date, job_open_date))

            Order By
                job_open_date Desc,
                job_reference_code;
        Return c;
    End fn_ers_hr_vacancy_list_excel;

End ers_hr_qry;
/
Grant Execute On "TCMPL_HR"."ERS_HR_QRY" To "TCMPL_APP_CONFIG";
/