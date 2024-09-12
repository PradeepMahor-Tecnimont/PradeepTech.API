create or replace Package Body ers_hr As
    
    Procedure sp_hr_vacancy_add(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_costcode         Varchar2,
        p_job_ref_code     Varchar2,
        p_job_open_date    Date,
        p_short_desc       Varchar2,
        p_job_type         Varchar2,
        p_job_location     Varchar2,
        p_job_desc01       Varchar2,
        p_job_desc02       Varchar2,
        p_job_desc03       Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno      Varchar2(5);
        v_job_key_id Varchar2(8);
        v_exists     Number;
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
            v_exists
        From
            ers_vacancies
        Where
            Trim(job_reference_code) = Trim(p_job_ref_code)
            And job_open_date        = p_job_open_date;

        If v_exists = 0 Then
            v_job_key_id   := dbms_random.string('X', 8);

            Insert Into ers_vacancies
            (
                job_key_id, job_reference_code, job_open_date, short_desc, job_type,
                job_location, job_desc_01, job_desc_02, job_desc_03, modified_by,
                modified_on, costcode
            )
            Values
            (
                v_job_key_id, Trim(p_job_ref_code), p_job_open_date, Trim(p_short_desc), p_job_type,
                Trim(p_job_location), Trim(p_job_desc01), Trim(p_job_desc02), Trim(p_job_desc03), v_empno,
                sysdate, p_costcode
            );

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Vacancy already exists.';
        End If;

    End sp_hr_vacancy_add;

    Procedure sp_hr_vacancy_update(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_job_key_id       Varchar2,
        p_job_ref_code     Varchar2,
        p_job_open_date    Date,
        p_short_desc       Varchar2,
        p_job_type         Varchar2,
        p_job_location     Varchar2,
        p_job_desc01       Varchar2,
        p_job_desc02       Varchar2,
        p_job_desc03       Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno  Varchar2(5);
        v_exists Number;
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
            v_exists
        From
            ers_vacancies
        Where
            Trim(job_key_id) = Trim(p_job_key_id);

        If v_exists = 1 Then
            Update
                ers_vacancies
            Set
                job_open_date = p_job_open_date,
                short_desc = p_short_desc,
                job_type = p_job_type,
                job_location = p_job_location,
                job_desc_01 = p_job_desc01,
                job_desc_02 = Trim(p_job_desc02),
                job_desc_03 = Trim(p_job_desc03),
                modified_by = v_empno,
                modified_on = sysdate
            Where
                Trim(job_key_id)             = Trim(p_job_key_id)
                And Trim(job_reference_code) = Trim(p_job_ref_code);

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'No vacancy found.';
        End If;
    End sp_hr_vacancy_update;

    Procedure sp_hr_vacancy_close(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_job_key_id       Varchar2,
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

        Update
            ers_vacancies
        Set
            job_status = 0,
            job_close_date = sysdate,
            modified_by = v_empno,
            modified_on = sysdate
        Where
            job_key_id = Trim(p_job_key_id);

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    End sp_hr_vacancy_close;

End ers_hr;