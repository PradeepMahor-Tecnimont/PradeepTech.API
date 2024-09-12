Create Or Replace Package Body "SELFSERVICE"."PKG_HSE_QUIZ_USER_QRY" As

    Function fn_hse_quiz_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_quiz_id     Varchar2,

        p_row_number  Number,
        p_page_length Number

    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
        v_count Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            Return Null;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            hse_quiz_user_response qur,
            hse_quiz_master        qm
        Where
            qm.quiz_id       = qur.quiz_id
            And qm.is_active = 1
            And qur.quiz_id  = Trim(p_quiz_id)
            And qur.empno    = Trim(v_empno);

        If v_count = 0 Then
            Open c For
                Select
                    quiz_id,
                            question_id,
                            question_name,
                            Null As correct_answer_id,
                            (Null) As correct_answer_text,
                            Null As answer_id,
                            (Null) As answer_id_text,
                            Row_Number() Over (Order By question_id)    row_number,
                            Count(*) Over ()                             total_row
                From
                    (
                        Select
                            qqm.quiz_id,
                            qqm.question_id,
                            qqm.question_name,
                            Row_Number() Over (Order By question_id) row_number,
                            Count(*) Over ()                         total_row
                        From
                            hse_quiz_question_master qqm,
                            hse_quiz_master          qm
                        Where
                            qm.quiz_id       = qqm.quiz_id
                            And qm.is_active = 1
                            And qqm.quiz_id  = Trim(p_quiz_id)
                    )
                Where
                    row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Else
            Open c For
                Select
                            quiz_id,
                            question_id,
                            question_name,
                            correct_answer_id,
                            (Case
                                When correct_answer_id = 1 Then
                                    'True'
                                Else
                                    'False'
                            End) As correct_answer_text,
                            answer_id,
                            (Case
                                When answer_id = 1 Then
                                    'True'
                                Else
                                    'False'
                            End) As answer_id_text,
                            Row_Number() Over (Order By question_id)    row_number,
                            Count(*) Over ()                             total_row
                From
                    (
                        Select
                            qqm.quiz_id,
                            qqm.question_id,
                            qqm.question_name,
                            qqm.correct_answer_id,
                            (Case
                                When qqm.correct_answer_id = 1 Then
                                    'True'
                                Else
                                    'False'
                            End) As correct_answer_text,
                            qur.answer_id,
                            (Case
                                When qur.answer_id = 1 Then
                                    'True'
                                Else
                                    'False'
                            End) As answer_id_text,
                            Row_Number() Over (Order By qqm.question_id) row_number,
                            Count(*) Over ()                             total_row
                        From
                            hse_quiz_question_master qqm,
                            hse_quiz_master          qm,
                            hse_quiz_user_response   qur
                        Where
                            qm.quiz_id          = qqm.quiz_id
                            And qqm.quiz_id     = qur.quiz_id
                            And qqm.question_id = qur.question_id
                            And qm.is_active    = 1
                            And qur.empno       = Trim(v_empno)
                            And qqm.quiz_id     = Trim(p_quiz_id)
                    )
                Where
                    row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        End If;
        Return c;
    End fn_hse_quiz_list;

    Procedure sp_hse_quiz_detail(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_quiz_id         Out Varchar2,
        p_description     Out Varchar2,
        p_quiz_date       Out Date,
        p_quiz_start_date Out Date,
        p_quiz_end_date   Out Date,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            qm.quiz_id,
            qm.description,
            qm.quiz_date,
            qm.quiz_start_date,
            qm.quiz_end_date
        Into
            p_quiz_id,
            p_description,
            p_quiz_date,
            p_quiz_start_date,
            p_quiz_end_date
        From
            hse_quiz_master qm
        Where
            qm.is_active = 1;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_hse_quiz_detail;

End pkg_hse_quiz_user_qry;
/