--------------------------------------------------------
--  DDL for Package Body IOT_SWP_PRIMARY_WORKSPACE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."IOT_SWP_PRIMARY_WORKSPACE" As

    Procedure sp_add_weekly_atnd(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_weekly_attendance typ_tab_string,
        p_empno             Varchar2,
        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        strsql         Varchar2(600);
        v_count        Number;
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
            v_count
        From
            swp_assignworkspace
        Where
            Trim(empno)         = Trim(p_empno)
            And Trim(workspace) = '2';

        If v_count = 0 Then
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
                From swp_wfh_weekatnd
            Where
                empno         = v_empno
                And atnd_date = v_atnd_date;

            If v_ststue = '1' Then

                v_pk := dbms_random.string('X', 10);

                Select
                    key
                Into
                    v_fk
                From
                    swp_assignworkspace
                Where
                    Trim(empno)         = Trim(p_empno)
                    And Trim(workspace) = '2';

                Insert Into swp_wfh_weekatnd
                (
                    key,
                    fk_swp_assignworkspace,
                    empno,
                    atnd_date,
                    deskid,
                    modifiedon,
                    modifiedby
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

    End sp_add_weekly_atnd;

    Procedure sp_assign_work_space(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_emp_workspace_array typ_tab_string,
        p_message_type Out    Varchar2,
        p_message_text Out    Varchar2
    ) As
        v_workspace_code Number;
        v_mod_by_empno   Varchar2(5);
        v_count          Number;
        v_key            Varchar2(10);
        v_empno          Varchar2(5);
    Begin
        v_mod_by_empno := get_empno_from_meta_id(p_meta_id);

        If v_mod_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        For i In 1..p_emp_workspace_array.count
        Loop

            With
                csv As (
                    Select
                        p_emp_workspace_array(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '[^~!~]+', 1, 1)) empno,
                Trim(regexp_substr(str, '[^~!~]+', 1, 2)) workspace_code
            Into
                v_empno, v_workspace_code
            From
                csv;

            Select
                Count(*)
            Into
                v_count
            From
                swp_assignworkspace
            Where
                empno         = Trim(v_empno)
                And workspace = v_workspace_code;

            --If same record exists in database then continue
            If v_count = 1 Then
                Continue;
            End If;

            Delete
                From swp_assignworkspace
            Where
                empno = Trim(v_empno);

            Delete
                From swp_wfh_weekatnd
            Where
                empno = Trim(v_empno)
                And trunc(atnd_date) >= trunc(sysdate);

            Delete
                From dms.dm_emp_desk_temp
            Where
                empno = Trim(v_empno);

            Delete
                From swp_wfh_weekatnd
            Where
                empno = Trim(v_empno)
                And trunc(atnd_date) >= trunc(sysdate);

            v_key := dbms_random.string('X', 10);
            Insert Into swp_assignworkspace (key, empno, workspace, startdate, modifiedon, modifiedby)
            Values (v_key, v_empno, v_workspace_code, sysdate, sysdate, v_mod_by_empno);
            Commit;
        End Loop;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;
End iot_swp_primary_workspace;

/
