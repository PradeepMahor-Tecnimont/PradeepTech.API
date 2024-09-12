Create Or Replace Package Body "DMS"."PKG_DMS_NEWJOIN" As

    Procedure sp_add_new_emp(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_emp_with_costcode_array typ_tab_string,

        p_message_type Out        Varchar2,
        p_message_text Out        Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_costcode     Varchar2(5);
        v_key          Varchar2(20);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        For i In 1..p_emp_with_costcode_array.count
        Loop

            With
                csv As (
                    Select
                        p_emp_with_costcode_array(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '[^~!~]+', 1, 1)) empno,
                Trim(regexp_substr(str, '[^~!~]+', 1, 2)) cost_code
            Into
                v_empno, v_costcode
            From
                csv;

            v_key := dbms_random.string('X', 20);

            Insert Into dm_newjoin_emp (sid, empno, ccode)
            Values (v_key, v_empno, v_costcode);

            Commit;
        End Loop;

        p_message_type := ok;
        p_message_text := ok;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_new_emp;

End pkg_dms_newjoin;
/

Grant Execute On "DMS"."PKG_DMS_NEWJOIN" To "TCMPL_APP_CONFIG";