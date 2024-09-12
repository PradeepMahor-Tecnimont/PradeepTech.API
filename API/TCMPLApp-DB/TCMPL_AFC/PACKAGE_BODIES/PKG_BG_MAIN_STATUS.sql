create or replace Package Body tcmpl_afc.pkg_bg_main_status As

    Procedure sp_bg_status_add(
        p_person_id        Varchar2 Default Null,
        p_meta_id          Varchar2 Default Null,
        p_refnum           Varchar2,
        p_amendmentnum     Varchar2,
        p_status_type_id   Varchar2,
        
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno          vu_emplmast.empno%Type;
        v_status_type_id bg_main_status.status_type_id%Type;
    Begin
        If p_status_type_id = c_s02 Or p_status_type_id = c_s03 Then
            v_empno := c_sys;
        Else
            v_empno := get_empno_from_meta_id(p_meta_id);

            If v_empno = 'ERRRR' Then
                p_message_type := 'KO';
                p_message_text := 'Invalid employee number';
                Return;
            End If;
        End If;

        Select
            status_type_id
        Into
            v_status_type_id
        From
            (
                Select
                    status_type_id
                From
                    bg_main_status
                Where
                    refnum           = Trim(p_refnum)
                    And amendmentnum = Trim(p_amendmentnum)
                Order By modified_date Desc
            )
        Where
            Rownum = 1;

        If v_status_type_id != p_status_type_id Then

            Insert Into bg_main_status (status_id, refnum, amendmentnum, status_type_id, modified_by, modified_date)
            Values (dbms_random.string('X', 10), Trim(p_refnum), Trim(p_amendmentnum), p_status_type_id, v_empno, sysdate);

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'OK';
            p_message_text := 'Nothing to change.';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_bg_status_add;

End pkg_bg_main_status;