--------------------------------------------------------
--  DDL for Package Body IOT_SWP_ACTION
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_ACTION" As

    Procedure sp_add_atnd(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_weekly_attendance typ_tab_string,
        p_empno             Varchar2,
        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        strsql         Varchar2(600);
        vcount         Number;
        v_ststue       Varchar2(5);
        -- 0 for delete only , 1 delete old and insert new
        v_mod_by_empno Varchar2(5);
        v_pk           Varchar2(10);
        v_fk           Varchar2(10);
        v_empno        Varchar2(5);
        v_atnd_date    Date;
        v_desk         Varchar2(20);
    Begin

        v_mod_by_empno := get_empno_from_meta_id(p_meta_id);

        If v_mod_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            vcount
        From
            swp_primary_workspace
        Where
            Trim(empno)         = Trim(p_empno)
            And Trim(primary_workspace) = '2';

        If vcount = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number ' || p_empno;
            Return;
        End If;

        For i In 1..p_weekly_attendance.count
        Loop

            With
                csv As (
                    Select
                        p_weekly_attendance(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '[^~!~]+', 1, 1))          empno,
                to_date(Trim(regexp_substr(str, '[^~!~]+', 1, 2))) atnd_date,
                Trim(regexp_substr(str, '[^~!~]+', 1, 3))          desk,
                Trim(regexp_substr(str, '[^~!~]+', 1, 4))          ststue
            Into
                v_empno, v_atnd_date, v_desk, v_ststue
            From
                csv;

            Delete
                From swp_smart_attendance_plan
            Where
                empno         = v_empno
                And attendance_date = v_atnd_date;

            If v_ststue = '1' Then

                v_pk := dbms_random.string('X', 10);

                Select
                    key_id
                Into
                    v_fk
                From
                    swp_primary_workspace
                Where
                    Trim(empno)         = Trim(p_empno)
                    And Trim(primary_workspace) = '2';

                Insert Into swp_smart_attendance_plan
                (
                    key_id,
                    ws_key_id,
                    empno,
                    attendance_date,
                    deskid,
                    modified_on,
                    modified_by
                )
                Values
                (
                    v_pk,
                    v_fk,
                    v_empno,
                    v_atnd_date,
                    v_desk,
                    sysdate,
                    v_mod_by_empno
                );

            End If;

        End Loop;
        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_atnd;

End iot_swp_action;

/
