Create Or Replace Package Body tcmpl_hr.pkg_region_holidays As

    Procedure sp_add_region_holiday(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_holiday          Date,
        p_region_code      Number,
        p_yyyymm           Varchar2,
        p_weekday          Varchar2,
        p_description      Varchar2,
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
            hd_region_holidays
        Where
            region_code        = p_region_code
            And trunc(holiday) = trunc(p_holiday);

        If v_exists = 0 Then
            Insert Into hd_region_holidays (
                holiday,
                region_code,
                yyyymm,
                weekday,
                holiday_desc
            )
            Values (
                trunc(p_holiday),
                p_region_code,
                p_yyyymm,
                p_weekday,
                Trim(p_description)
            );

            Commit;
            p_message_type := ok;
            p_message_text := 'Holiday added successfully..';
        Else
            p_message_type := not_ok;
            p_message_text := 'Holiday already exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_region_holiday;

    Procedure sp_update_region_holiday(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_holiday          Date,
        p_region_code      Number,
        p_yyyymm           Varchar2,
        p_weekday          Varchar2,
        p_description      Varchar2,
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
            hd_region_holidays
        Where
            holiday = p_holiday;

    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Holiday already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_region_holiday;

    Procedure sp_delete_region_holiday(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_holiday          Date,
        p_region_code      Number,
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

        Delete
            From hd_region_holidays
        Where
            trunc(holiday)  = trunc(p_holiday)
            And region_code = p_region_code;

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
    End sp_delete_region_holiday;

End pkg_region_holidays;
/