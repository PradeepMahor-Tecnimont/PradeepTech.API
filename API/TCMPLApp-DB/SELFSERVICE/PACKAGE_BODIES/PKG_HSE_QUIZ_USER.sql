Create Or Replace Package Body "SELFSERVICE"."PKG_HSE_QUIZ_USER" As

    Procedure prc_hse_quiz_submit(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_quiz_id          Varchar2,
        p_action           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno                Varchar2(5);
        v_empno_submit_count   Number;
        v_empno_count_active   Number;
        v_empno_count_inactive Number;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(Distinct empno)
        Into
            v_empno_submit_count
        From
            hse_quiz_user_response
        Where
            quiz_id = Trim(p_quiz_id);

        Select
            Count(empno)
        Into
            v_empno_count_active
        From
            ss_emplmast
        Where
            status = 1;

        Select
            Count(empno)
        Into
            v_empno_count_inactive
        From
            ss_emplmast
        Where
            status = 0
            And empno In (
                Select
                    empno
                From
                    hse_quiz_user_response
                Where
                    quiz_id = Trim(p_quiz_id)
            );

        Update
            hse_quiz_master
        Set
            emp_submit_count = v_empno_submit_count, 
            emp_count = v_empno_count_active + v_empno_count_inactive, 
            modified_on = sysdate
        Where
            is_active   = 1
            And quiz_id = Trim(p_quiz_id);

        p_message_type := ok;
        p_message_text := 'Procedure execute successfully';

    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'Quiz not found';
    End;

    Procedure prc_hse_quiz_response(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_quiz_id          Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno          Varchar2(5);
        v_sum_is_correct Number;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Sum(is_correct)
        Into
            v_sum_is_correct
        From
            hse_quiz_user_response
        Where
            empno       = Trim(v_empno)
            And quiz_id = Trim(p_quiz_id);

        Delete
            From hse_quiz_response_master
        Where
            empno       = Trim(v_empno)
            And quiz_id = Trim(p_quiz_id);

        Insert Into hse_quiz_response_master
        Select
            p_quiz_id, 
            empno, 
            parent, 
            assign, 
            v_sum_is_correct, 
            sysdate
        From
            ss_emplmast
        Where
            empno = Trim(v_empno);

        p_message_type := ok;
        p_message_text := 'Procedure execute successfully';

    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'Quiz not found';
    End;

    Procedure prc_check_active_quiz(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_quiz_id          Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno     Varchar2(5);
        v_is_active hse_quiz_master.is_active%Type;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            is_active
        Into
            v_is_active
        From
            hse_quiz_master
        Where
            quiz_id = Trim(p_quiz_id);

        If v_is_active = 1 Then
            p_message_type := ok;
            p_message_text := 'Procedure execute successfully';
        Else
            p_message_type := not_ok;
            p_message_text := 'Quiz is not active';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Quiz not found';
    End;

    Procedure prc_hse_quiz_insert_answer(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_quiz_id          Varchar2,

        p_question_id      Varchar2,
        p_answer_id        Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno             Varchar2(5);
        v_correct_answer_id hse_quiz_question_master.correct_answer_id%Type;
        v_is_correct        Number(1);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Begin
            Select
                correct_answer_id
            Into
                v_correct_answer_id
            From
                hse_quiz_question_master
            Where
                correct_answer_id = p_answer_id
                And question_id   = Trim(p_question_id)
                And quiz_id       = Trim(p_quiz_id);
            v_is_correct := 1;
        Exception
            When Others Then
                v_is_correct := 0;
        End;

        Insert Into hse_quiz_user_response
        (
            quiz_id,
            empno,
            question_id,
            answer_id,
            is_correct,
            modified_on
        )
        Values
        (
            p_quiz_id,
            v_empno,
            p_question_id,
            p_answer_id,
            v_is_correct,
            sysdate
        );

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End prc_hse_quiz_insert_answer;

    Procedure prc_hse_quiz_insert(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_quiz_id          Varchar2,

        p_question_id1     Varchar2,
        p_answer_id1       Number,
        p_question_id2     Varchar2 Default Null,
        p_answer_id2       Number   Default Null,
        p_question_id3     Varchar2 Default Null,
        p_answer_id3       Number   Default Null,
        p_question_id4     Varchar2 Default Null,
        p_answer_id4       Number   Default Null,
        p_question_id5     Varchar2 Default Null,
        p_answer_id5       Number   Default Null,
        p_question_id6     Varchar2 Default Null,
        p_answer_id6       Number   Default Null,
        p_question_id7     Varchar2 Default Null,
        p_answer_id7       Number   Default Null,
        p_question_id8     Varchar2 Default Null,
        p_answer_id8       Number   Default Null,
        p_question_id9     Varchar2 Default Null,
        p_answer_id9       Number   Default Null,
        p_question_id10    Varchar2 Default Null,
        p_answer_id10      Number   Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        prc_hse_quiz_insert_answer(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,

            p_quiz_id      => p_quiz_id,

            p_question_id  => p_question_id1,
            p_answer_id    => p_answer_id1,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

        If p_message_type = ok Then
            If p_question_id2 Is Not Null Then
                prc_hse_quiz_insert_answer(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_quiz_id      => p_quiz_id,

                    p_question_id  => p_question_id2,
                    p_answer_id    => p_answer_id2,

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
            End If;
        Else
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If p_message_type = ok Then
            If p_question_id3 Is Not Null Then
                prc_hse_quiz_insert_answer(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_quiz_id      => p_quiz_id,

                    p_question_id  => p_question_id3,
                    p_answer_id    => p_answer_id3,

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
            End If;
        Else
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If p_message_type = ok Then
            If p_question_id4 Is Not Null Then
                prc_hse_quiz_insert_answer(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_quiz_id      => p_quiz_id,

                    p_question_id  => p_question_id4,
                    p_answer_id    => p_answer_id4,

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
            End If;
        Else
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If p_message_type = ok Then
            If p_question_id5 Is Not Null Then
                prc_hse_quiz_insert_answer(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_quiz_id      => p_quiz_id,

                    p_question_id  => p_question_id5,
                    p_answer_id    => p_answer_id5,

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
            End If;
        Else
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If p_message_type = ok Then
            If p_question_id6 Is Not Null Then
                prc_hse_quiz_insert_answer(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_quiz_id      => p_quiz_id,

                    p_question_id  => p_question_id6,
                    p_answer_id    => p_answer_id6,

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
            End If;
        Else
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If p_message_type = ok Then
            If p_question_id7 Is Not Null Then
                prc_hse_quiz_insert_answer(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_quiz_id      => p_quiz_id,

                    p_question_id  => p_question_id7,
                    p_answer_id    => p_answer_id7,

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
            End If;
        Else
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If p_message_type = ok Then
            If p_question_id8 Is Not Null Then
                prc_hse_quiz_insert_answer(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_quiz_id      => p_quiz_id,

                    p_question_id  => p_question_id8,
                    p_answer_id    => p_answer_id8,

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
            End If;
        Else
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If p_message_type = ok Then
            If p_question_id9 Is Not Null Then
                prc_hse_quiz_insert_answer(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_quiz_id      => p_quiz_id,

                    p_question_id  => p_question_id9,
                    p_answer_id    => p_answer_id9,

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
            End If;
        Else
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If p_message_type = ok Then
            If p_question_id10 Is Not Null Then
                prc_hse_quiz_insert_answer(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_quiz_id      => p_quiz_id,

                    p_question_id  => p_question_id10,
                    p_answer_id    => p_answer_id10,

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
            End If;
        Else
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        prc_hse_quiz_response(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,

            p_quiz_id      => p_quiz_id,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

        If p_message_type = ok Then
            prc_hse_quiz_submit(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,

                p_quiz_id      => p_quiz_id,
                p_action       => 'INSERT',

                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
            If p_message_type = not_ok Then
                p_message_type := p_message_type;
                p_message_text := p_message_text;
                Return;
            End If;

        Else
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End prc_hse_quiz_insert;

    Procedure prc_hse_quiz_update_answer(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_quiz_id          Varchar2,

        p_question_id      Varchar2,
        p_answer_id        Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno             Varchar2(5);
        v_correct_answer_id hse_quiz_question_master.correct_answer_id%Type;
        v_is_correct        Number(1);
        v_answer_id         hse_quiz_user_response.answer_id%Type;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            answer_id
        Into
            v_answer_id
        From
            hse_quiz_user_response
        Where
            empno           = Trim(v_empno)
            And question_id = Trim(p_question_id)
            And quiz_id     = Trim(p_quiz_id);

        If v_answer_id = p_answer_id Then
            p_message_type := ok;
            p_message_text := 'No change done.';
            Return;
        End If;

        Begin
            Select
                correct_answer_id
            Into
                v_correct_answer_id
            From
                hse_quiz_question_master
            Where
                correct_answer_id = p_answer_id
                And question_id   = Trim(p_question_id)
                And quiz_id       = Trim(p_quiz_id);
            v_is_correct := 1;
        Exception
            When Others Then
                v_is_correct := 0;
        End;

        Update
            hse_quiz_user_response
        Set
            answer_id = p_answer_id,
            is_correct = v_is_correct,
            modified_on = sysdate
        Where
            empno           = Trim(v_empno)
            And question_id = Trim(p_question_id)
            And quiz_id     = Trim(p_quiz_id);

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End prc_hse_quiz_update_answer;

    Procedure prc_hse_quiz_update(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_quiz_id          Varchar2,

        p_question_id1     Varchar2,
        p_answer_id1       Number,
        p_question_id2     Varchar2 Default Null,
        p_answer_id2       Number   Default Null,
        p_question_id3     Varchar2 Default Null,
        p_answer_id3       Number   Default Null,
        p_question_id4     Varchar2 Default Null,
        p_answer_id4       Number   Default Null,
        p_question_id5     Varchar2 Default Null,
        p_answer_id5       Number   Default Null,
        p_question_id6     Varchar2 Default Null,
        p_answer_id6       Number   Default Null,
        p_question_id7     Varchar2 Default Null,
        p_answer_id7       Number   Default Null,
        p_question_id8     Varchar2 Default Null,
        p_answer_id8       Number   Default Null,
        p_question_id9     Varchar2 Default Null,
        p_answer_id9       Number   Default Null,
        p_question_id10    Varchar2 Default Null,
        p_answer_id10      Number   Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        prc_hse_quiz_update_answer(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,

            p_quiz_id      => p_quiz_id,

            p_question_id  => p_question_id1,
            p_answer_id    => p_answer_id1,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

        If p_message_type = ok Then
            If p_question_id2 Is Not Null Then
                prc_hse_quiz_update_answer(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_quiz_id      => p_quiz_id,

                    p_question_id  => p_question_id2,
                    p_answer_id    => p_answer_id2,

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
            End If;
        Else
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If p_message_type = ok Then
            If p_question_id3 Is Not Null Then
                prc_hse_quiz_update_answer(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_quiz_id      => p_quiz_id,

                    p_question_id  => p_question_id3,
                    p_answer_id    => p_answer_id3,

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
            End If;
        Else
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If p_message_type = ok Then
            If p_question_id4 Is Not Null Then
                prc_hse_quiz_update_answer(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_quiz_id      => p_quiz_id,

                    p_question_id  => p_question_id4,
                    p_answer_id    => p_answer_id4,

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
            End If;
        Else
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If p_message_type = ok Then
            If p_question_id5 Is Not Null Then
                prc_hse_quiz_update_answer(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_quiz_id      => p_quiz_id,

                    p_question_id  => p_question_id5,
                    p_answer_id    => p_answer_id5,

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
            End If;
        Else
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If p_message_type = ok Then
            If p_question_id6 Is Not Null Then
                prc_hse_quiz_update_answer(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_quiz_id      => p_quiz_id,

                    p_question_id  => p_question_id6,
                    p_answer_id    => p_answer_id6,

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
            End If;
        Else
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If p_message_type = ok Then
            If p_question_id7 Is Not Null Then
                prc_hse_quiz_update_answer(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_quiz_id      => p_quiz_id,

                    p_question_id  => p_question_id7,
                    p_answer_id    => p_answer_id7,

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
            End If;
        Else
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If p_message_type = ok Then
            If p_question_id8 Is Not Null Then
                prc_hse_quiz_update_answer(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_quiz_id      => p_quiz_id,

                    p_question_id  => p_question_id8,
                    p_answer_id    => p_answer_id8,

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
            End If;
        Else
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If p_message_type = ok Then
            If p_question_id9 Is Not Null Then
                prc_hse_quiz_update_answer(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_quiz_id      => p_quiz_id,

                    p_question_id  => p_question_id9,
                    p_answer_id    => p_answer_id9,

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
            End If;
        Else
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        If p_message_type = ok Then
            If p_question_id10 Is Not Null Then
                prc_hse_quiz_update_answer(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_quiz_id      => p_quiz_id,

                    p_question_id  => p_question_id10,
                    p_answer_id    => p_answer_id10,

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
            End If;
        Else
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        prc_hse_quiz_response(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,

            p_quiz_id      => p_quiz_id,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

        If p_message_type = ok Then
            prc_hse_quiz_submit(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,

                p_quiz_id      => p_quiz_id,
                p_action       => 'UPDATE',

                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
            If p_message_type = not_ok Then
                p_message_type := p_message_type;
                p_message_text := p_message_text;
                Return;
            End If;

        Else
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End prc_hse_quiz_update;

    Procedure sp_hse_quiz_save(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_quiz_id          Varchar2,

        p_question_id1     Varchar2,
        p_answer_id1       Number,
        p_question_id2     Varchar2 Default Null,
        p_answer_id2       Number   Default Null,
        p_question_id3     Varchar2 Default Null,
        p_answer_id3       Number   Default Null,
        p_question_id4     Varchar2 Default Null,
        p_answer_id4       Number   Default Null,
        p_question_id5     Varchar2 Default Null,
        p_answer_id5       Number   Default Null,
        p_question_id6     Varchar2 Default Null,
        p_answer_id6       Number   Default Null,
        p_question_id7     Varchar2 Default Null,
        p_answer_id7       Number   Default Null,
        p_question_id8     Varchar2 Default Null,
        p_answer_id8       Number   Default Null,
        p_question_id9     Varchar2 Default Null,
        p_answer_id9       Number   Default Null,
        p_question_id10    Varchar2 Default Null,
        p_answer_id10      Number   Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
        v_count Number;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        prc_check_active_quiz(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,

            p_quiz_id      => p_quiz_id,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            hse_quiz_user_response
        Where
            empno       = Trim(v_empno)
            And quiz_id = Trim(p_quiz_id);

        If v_count = 0 Then
            prc_hse_quiz_insert(
                p_person_id     => p_person_id,
                p_meta_id       => p_meta_id,

                p_quiz_id       => p_quiz_id,

                p_question_id1  => p_question_id1,
                p_answer_id1    => p_answer_id1,
                p_question_id2  => p_question_id2,
                p_answer_id2    => p_answer_id2,
                p_question_id3  => p_question_id3,
                p_answer_id3    => p_answer_id3,
                p_question_id4  => p_question_id4,
                p_answer_id4    => p_answer_id4,
                p_question_id5  => p_question_id5,
                p_answer_id5    => p_answer_id5,
                p_question_id6  => p_question_id6,
                p_answer_id6    => p_answer_id6,
                p_question_id7  => p_question_id7,
                p_answer_id7    => p_answer_id7,
                p_question_id8  => p_question_id8,
                p_answer_id8    => p_answer_id8,
                p_question_id9  => p_question_id9,
                p_answer_id9    => p_answer_id9,
                p_question_id10 => p_question_id10,
                p_answer_id10   => p_answer_id10,

                p_message_type  => p_message_type,
                p_message_text  => p_message_text
            );
        Else
            prc_hse_quiz_update(
                p_person_id     => p_person_id,
                p_meta_id       => p_meta_id,

                p_quiz_id       => p_quiz_id,

                p_question_id1  => p_question_id1,
                p_answer_id1    => p_answer_id1,
                p_question_id2  => p_question_id2,
                p_answer_id2    => p_answer_id2,
                p_question_id3  => p_question_id3,
                p_answer_id3    => p_answer_id3,
                p_question_id4  => p_question_id4,
                p_answer_id4    => p_answer_id4,
                p_question_id5  => p_question_id5,
                p_answer_id5    => p_answer_id5,
                p_question_id6  => p_question_id6,
                p_answer_id6    => p_answer_id6,
                p_question_id7  => p_question_id7,
                p_answer_id7    => p_answer_id7,
                p_question_id8  => p_question_id8,
                p_answer_id8    => p_answer_id8,
                p_question_id9  => p_question_id9,
                p_answer_id9    => p_answer_id9,
                p_question_id10 => p_question_id10,
                p_answer_id10   => p_answer_id10,

                p_message_type  => p_message_type,
                p_message_text  => p_message_text
            );
        End If;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_hse_quiz_save;

End pkg_hse_quiz_user;
/