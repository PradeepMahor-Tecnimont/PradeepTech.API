Create Or Replace Package Body "SELFSERVICE"."PKG_HSE_QUIZ_SELECT_LIST_QRY" As

    Function fn_hse_quiz_question_options_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_quiz_id     Varchar2,
        p_question_id Varchar2

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                qam.answer_id   data_value_field,
                qam.answer_name data_text_field
            From
                hse_quiz_answer_master qam,
                hse_quiz_master        qm
            Where
                qm.quiz_id          = qam.quiz_id
                And qm.is_active    = 1
                And qam.quiz_id     = Trim(p_quiz_id)
                And qam.question_id = Trim(p_question_id);

        Return c;
    End fn_hse_quiz_question_options_list;

End pkg_hse_quiz_select_list_qry;
/