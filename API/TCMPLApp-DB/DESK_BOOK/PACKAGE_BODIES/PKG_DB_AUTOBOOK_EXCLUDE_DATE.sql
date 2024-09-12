--------------------------------------------------------
--  DDL for Package Body PKG_DB_AUTOBOOK_EXCLUDE_DATE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "DESK_BOOK"."PKG_DB_AUTOBOOK_EXCLUDE_DATE" As

    Procedure sp_pause_db_autobook_exclude_date(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_from_date        Date,
        p_to_date          Date,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_keyid        Varchar2(8);
        v_groupid      Varchar2(8);
        v_date_diff    Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;


        v_groupid      := dbms_random.string('X', 8);
        v_date_diff := p_to_date - p_from_date;

        For i IN 0..v_date_diff Loop
            Select
                Count(*)
            Into
                v_exists
            From
            db_autobook_exclude_date
            Where
                Trim(upper(empno))         = Trim(upper(v_empno))
                And trunc(attendance_date) = trunc(p_from_date + i);
            v_keyid        := dbms_random.string('X', 8);

            If v_exists = 0 Then
                Insert Into db_autobook_exclude_date (
                    key_id,
                    empno,
                    attendance_date,
                    modified_on,
                    modified_by,
                    group_id
                )
                Values (
                    v_keyid,
                    Trim(v_empno),
                    p_from_date + i,
                    sysdate,
                    Trim(v_empno),
                    v_groupid
                );
                Commit;
                p_message_type := ok;
                p_message_text := 'Autobook exclude added successfully..';
            Else
                p_message_type := not_ok;
                p_message_text := 'Autobook exclude Already exists !!!';
            End If;
        End Loop;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_pause_db_autobook_exclude_date;

    Procedure sp_update_db_autobook_exclude_date(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_key_id           Varchar2,
        p_attendance_date  Date,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            db_autobook_exclude_date
        Where
            key_id    = p_key_id
            And empno = v_empno
            And trunc(attendance_date) != trunc(p_attendance_date);

        If v_exists = 1 Then
            Update
                db_autobook_exclude_date
            Set
                attendance_date = p_attendance_date,
                modified_on = sysdate,
                modified_by = Trim(v_empno)
            Where
                key_id    = p_key_id
                And empno = v_empno;

            Commit;
            p_message_type := ok;
            p_message_text := 'Autobook exclude updated successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Autobook exclude exists !!!';
        End If;
    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Autobook exclude already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_db_autobook_exclude_date;

    Procedure sp_resume_db_autobook_exclude_date(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_from_date        Date,
        p_to_date          Date,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_is_used      Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        /* Select
             Count(*)
         Into
             v_is_used
         From
             tblName
         Where
             keyId = p_keyId;

         If v_is_used > 0 Then
             p_message_type := not_ok;
             p_message_text := 'Record cannot be delete, this record already used !!!';
             Return;
         End If;
         */

        Delete
            From db_autobook_exclude_date
        Where
            attendance_date between
            p_from_date and p_to_date;

        If (Sql%rowcount > 0) Then
            Commit;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'Procedure not executed.';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_resume_db_autobook_exclude_date;

End pkg_db_autobook_exclude_date;


/

  GRANT EXECUTE ON "DESK_BOOK"."PKG_DB_AUTOBOOK_EXCLUDE_DATE" TO "TCMPL_APP_CONFIG";
