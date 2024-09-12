Create Or Replace Package Body "SELFSERVICE"."PKG_HSE_QUIZ_HSE_QRY" As

    Procedure sp_hse_quiz_submit_count(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_quiz_id              Varchar2,
        p_emp_submit_count Out Number,
        p_emp_count        Out Number,
        p_submit_rating    Out Varchar2,

        p_message_type     Out Varchar2,
        p_message_text     Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        if length(p_quiz_id) > 0 then
            Select
                qm.emp_submit_count, qm.emp_count, qm.emp_submit_count || '/' || qm.emp_count
            Into
                p_emp_submit_count, p_emp_count, p_submit_rating
            From
                hse_quiz_master qm
            Where
                qm.quiz_id       = Trim(p_quiz_id)
                And qm.is_active = 1;
        else
            p_emp_submit_count := 0;
            p_emp_count := 0;
            p_submit_rating := 0/0;
        end if;
        
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_hse_quiz_submit_count;

End pkg_hse_quiz_hse_qry;
/