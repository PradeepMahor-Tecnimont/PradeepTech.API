--------------------------------------------------------
--  DDL for Package Body ERS
--------------------------------------------------------

Create Or Replace Package Body "TCMPL_HR"."ERS" As
    Procedure sp_refer_vacancy(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_job_key_id       Varchar2,
        p_pan              Varchar2,
        p_candidate_name   Varchar2,
        p_candidate_email  Varchar2,
        p_candidate_mobile Varchar2,
        p_ers_cv_disp_name Varchar2,
        p_ers_cv_os_name   Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_winthin_year Number;
        v_new_date     Varchar2(11);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_winthin_year
        From
            ers_vacancy_cvs
        Where
            pan = p_pan
            And add_months(To_Date(upload_date), 12) >= sysdate;

        If v_winthin_year = 0 Then

            Insert Into ers_vacancy_cvs
            (
                vacancy_job_key_id, pan, candidate_name, candidate_email, candidate_mobile,
                candidate_cv_disp_name, candidate_cv_os_name, refered_by_empno,
                refered_on, cv_status, upload_date
            )
            Values
            (
                p_job_key_id, p_pan, p_candidate_name, p_candidate_email, p_candidate_mobile,
                p_ers_cv_disp_name, p_ers_cv_os_name, v_empno,
                sysdate, 0, sysdate
            );

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            Select
                to_char(upload_date, 'dd-Mon-yyyy')
            Into
                v_new_date
            From
                (
                    Select
                        add_months(To_Date(evc.upload_date), 12) upload_date
                    From
                        ers_vacancy_cvs evc
                    Where
                        pan = p_pan
                    Order By
                        upload_date Desc
                )
            Where
                rownum = 1;

            p_message_type := 'KO';
            p_message_text := 'CV already refered, try after ' || v_new_date || '.';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_refer_vacancy;

    Procedure sp_refer_vacancy_validate(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_job_key_id       Varchar2,
        p_pan              Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_winthin_year Number;
        v_new_date     Varchar2(11);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_winthin_year
        From
            ers_vacancy_cvs
        Where
            pan = p_pan
            And add_months(To_Date(upload_date), 12) >= sysdate;

        If v_winthin_year = 0 Then
            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            Select
                to_char(upload_date, 'dd-Mon-yyyy')
            Into
                v_new_date
            From
                (
                    Select
                        add_months(To_Date(evc.upload_date), 12)         upload_date,
                        Row_Number() Over (Order By evc.upload_date Asc) As rn
                    From
                        ers_vacancy_cvs evc
                    Where
                        pan = p_pan
                )
            Where
                rn = 1;

            p_message_type := 'KO';
            p_message_text := 'CV already refered, try after ' || v_new_date || '.';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_refer_vacancy_validate;

    Procedure sp_refer_delete(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_job_key_id       Varchar2,
        p_candidate_email  Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Delete
            From ers_vacancy_cvs
        Where
            Trim(vacancy_job_key_id)  = Trim(p_job_key_id)
            And Trim(candidate_email) = Trim(p_candidate_email);

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_refer_delete;

    Procedure sp_cv_status_update(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,
        p_job_key_id           Varchar2,
        p_candidate_email      Varchar2,
        p_cv_status            Number,
        p_change_job_reference Varchar2 Default Null,
        p_message_type Out     Varchar2,
        p_message_text Out     Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Update
            ers_vacancy_cvs
        Set
            cv_status = p_cv_status,
            cv_status_modified_by = v_empno,
            cv_status_modified_on = sysdate
        Where
            Trim(vacancy_job_key_id)  = Trim(p_job_key_id)
            And Trim(candidate_email) = Trim(p_candidate_email);

        If p_change_job_reference Is Not Null Then
            Insert Into ers_vacancy_cvs_history
            Select
                vacancy_job_key_id,
                candidate_name,
                candidate_mobile,
                candidate_email,
                pan,
                refered_by_empno,
                refered_on,
                v_empno,
                sysdate
            From
                ers_vacancy_cvs
            Where
                Trim(vacancy_job_key_id)  = Trim(p_job_key_id)
                And Trim(candidate_email) = Trim(p_candidate_email);
        
            Update
                ers_vacancy_cvs
            Set
                vacancy_job_key_id = p_change_job_reference
            Where
                Trim(vacancy_job_key_id)  = Trim(p_job_key_id)
                And Trim(candidate_email) = Trim(p_candidate_email);
            
        End If;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_cv_status_update;
End ers;
/

  Grant Execute On "TCMPL_HR"."ERS" To "TCMPL_APP_CONFIG";