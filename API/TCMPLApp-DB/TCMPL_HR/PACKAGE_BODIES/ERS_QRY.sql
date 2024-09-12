--------------------------------------------------------
--  DDL for Package Body ERS_QRY
--------------------------------------------------------

Create Or Replace Package Body "TCMPL_HR"."ERS_QRY" As
    Function fn_ers_get_cv_count(
        p_job_key_id Varchar2,
        p_empno      Varchar2
    ) Return Number As
        v_cv_count Number;
    Begin
        Select
            Count(vacancy_job_key_id)
        Into
            v_cv_count
        From
            ers_vacancy_cvs
        Where
            Trim(vacancy_job_key_id) = Trim(p_job_key_id)
            And Trim(refered_by_empno) Like '%' || Trim(p_empno) || '%';

        Return v_cv_count;
    Exception
        When Others Then
            Return 0;
    End fn_ers_get_cv_count;

    Function fn_ers_get_cv_status(
        p_cv_status_code Number
    ) Return Varchar2 As
        v_cv_status Varchar2(100);
    Begin
        Select
            cv_status_desc
        Into
            v_cv_status
        From
            ers_vacancy_cv_status
        Where
            cv_status_code = p_cv_status_code;

        Return v_cv_status;
    Exception
        When Others Then
            Return '';
    End fn_ers_get_cv_status;

    Function fn_ers_get_ref_code(
        p_job_key_id Varchar2
    ) Return Varchar2 As
        v_job_ref_code Varchar2(20);
    Begin
        Select
            job_reference_code
        Into
            v_job_ref_code
        From
            ers_vacancies
        Where
            Trim(job_key_id) = Trim(p_job_key_id);

        Return v_job_ref_code;
    Exception
        When Others Then
            Return '';
    End fn_ers_get_ref_code;

    Function fn_ers_get_vacancy_open_date(
        p_job_key_id Varchar2
    ) Return Varchar2 As
        v_job_open_date Char(11);
    Begin
        Select
            to_char(job_open_date, 'DD-Mon-YYYY')
        Into
            v_job_open_date
        From
            ers_vacancies
        Where
            Trim(job_key_id) = Trim(p_job_key_id);

        Return v_job_open_date;
    Exception
        When Others Then
            Return '';
    End fn_ers_get_vacancy_open_date;

    Function fn_cv_status_select_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                to_char(cv_status_code) data_value_field,
                cv_status_desc          data_text_field
            From
                ers_vacancy_cv_status
            Order By
                cv_status_desc;

        Return c;
    End fn_cv_status_select_list;

    Function fn_ers_vacancy_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2,
        p_row_number     Number,
        p_page_length    Number
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
                        short_desc,
                        job_type,
                        job_location,
                        ers_qry.fn_ers_get_cv_count(job_key_id, v_empno)     As uploaded_cvs,
                        Row_Number() Over (Order By job_reference_code Desc) row_number,
                        Count(*) Over ()                                     total_row
                    From
                        ers_vacancies
                    Where
                        job_status = 1
                        And (upper(job_reference_code) Like upper('%' || Trim(p_generic_search) || '%') Or
                            upper(short_desc) Like upper('%' || Trim(p_generic_search) || '%') Or
                            upper(job_type) Like upper('%' || Trim(p_generic_search) || '%') Or
                            upper(job_location) Like upper('%' || Trim(p_generic_search) || '%'))
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                job_reference_code Desc;
        Return c;
    End fn_ers_vacancy_list;

    Function fn_ers_uploaded_cv_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2,
        p_row_number     Number,
        p_page_length    Number
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
                        ers_qry.fn_ers_get_cv_status(cv_status)         cv_status,
                        vacancy_job_key_id,
                        ers_qry.fn_ers_get_ref_code(vacancy_job_key_id) job_reference_code,
                        candidate_name,
                        candidate_email,
                        candidate_mobile,
                        candidate_cv_disp_name,
                        candidate_cv_os_name,
                        pan,
                        Row_Number() Over (Order By cv_status Desc)     row_number,
                        Count(*) Over ()                                total_row
                    From
                        ers_vacancy_cvs
                    Where
                        refered_by_empno = v_empno
                        And (upper(candidate_name) Like upper('%' || Trim(p_generic_search) || '%') Or
                            upper(candidate_email) Like upper('%' || Trim(p_generic_search) || '%') Or
                            upper(ers_qry.fn_ers_get_cv_status(cv_status)) Like upper('%' || Trim(p_generic_search) || '%')
                            Or
                            upper(ers_qry.fn_ers_get_ref_code(vacancy_job_key_id)) Like upper('%' || Trim(p_generic_search) ||
                            '%')
                            Or
                            upper(pan) Like upper('%' || Trim(p_generic_search) || '%') Or
                            upper(candidate_mobile) Like upper('%' || Trim(p_generic_search) || '%'))
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                cv_status Desc;
        Return c;
    End fn_ers_uploaded_cv_list;

    Procedure sp_vacancy_detail(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,
        p_job_key_id        Varchar2,
        p_job_ref_code  Out Varchar2,
        p_job_open_date Out Date,
        p_short_desc    Out Varchar2,
        p_job_type      Out Varchar2,
        p_job_location  Out Varchar2,
        p_job_desc01    Out Varchar2,
        p_job_desc02    Out Varchar2,
        p_job_desc03    Out Varchar2,
        p_message_type  Out Varchar2,
        p_message_text  Out Varchar2
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
            job_reference_code,
            job_open_date,
            short_desc,
            job_type,
            job_location,
            job_desc_01,
            job_desc_02,
            job_desc_03
        Into
            p_job_ref_code,
            p_job_open_date,
            p_short_desc,
            p_job_type,
            p_job_location,
            p_job_desc01,
            p_job_desc02,
            p_job_desc03
        From
            ers_vacancies
        Where
            Trim(job_key_id) = Trim(p_job_key_id);

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_vacancy_detail;

    Function fn_ers_get_location(
        p_job_key_id Varchar2
    ) Return Varchar2 As
        v_job_location ers_vacancies.job_location%Type;
    Begin
        Select
            job_location
        Into
            v_job_location
        From
            ers_vacancies
        Where
            Trim(job_key_id) = Trim(p_job_key_id);

        Return v_job_location;
    Exception
        When Others Then
            Return '';
    End fn_ers_get_location;

    Function fn_costcode_create_select_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                costcode                  data_value_field,
                costcode || ' - ' || name data_text_field
            From
                ers_vu_costmast
            Where
                active = 1
            Order By
                costcode;

        Return c;
    End fn_costcode_create_select_list;

    Function fn_costcode_edit_select_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_costcode  Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                costcode                  data_value_field,
                costcode || ' - ' || name data_text_field
            From
                ers_vu_costmast
            Where
                active = 1

            Union

            Select
                costcode                  data_value_field,
                costcode || ' - ' || name data_text_field
            From
                ers_vu_costmast
            Where
                active       = 0
                And costcode = p_costcode

            Order By
                1;

        Return c;
    End fn_costcode_edit_select_list;

End ers_qry;
/
  Grant Execute On "TCMPL_HR"."ERS_QRY" To "TCMPL_APP_CONFIG";
/