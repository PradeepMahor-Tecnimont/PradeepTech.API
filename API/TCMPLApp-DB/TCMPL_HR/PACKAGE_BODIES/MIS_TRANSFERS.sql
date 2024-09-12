Create Or Replace Package Body tcmpl_hr.mis_transfers As

    Procedure sp_create(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_transfer_date    Date,
        p_from_costcode    Varchar2,
        p_to_costcode      Varchar2,     

        p_message_type Out Varchar2,
        p_message_text Out Varchar2

    ) As
        v_by_empno      Varchar2(5);
        v_key_id        Varchar2(8);
        v_exists        Number;
        v_from_costcode Varchar2(4);
        v_count        Number;
    Begin
        v_by_empno     := get_empno_from_meta_id(p_meta_id);

        If v_by_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select Count(*) into v_count from vu_costmast where costcode in (p_from_costcode,p_to_costcode);
        
        If v_count != 2 Then
            p_message_type := not_ok;
            p_message_text := 'Err - Invalid costcode selected' ;
            Return;
        End If;
        v_key_id       := dbms_random.string('X', 8);
        Insert Into mis_internal_transfers(
            key_id,
            empno,
            transfer_date,
            from_costcode,
            to_costcode,
            modified_by,
            modified_on
        )
        Values(
            v_key_id,
            p_empno,
            p_transfer_date,
            p_from_costcode,
            p_to_costcode,
            v_by_empno,
            sysdate
        );

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_update(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,
        p_empno            Varchar2,
        p_transfer_date    Date,
        p_to_costcode      Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2

    ) As
        v_by_empno Varchar2(5);
        v_count    Number;
        v_exists   Number;
    Begin
        v_by_empno     := get_empno_from_meta_id(p_meta_id);

        If v_by_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            mis_internal_transfers
        Where
            key_id    = p_key_id
            And empno = p_empno;

        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Key Id - Empno not found.';
            Return;
        End If;

        Update
            mis_internal_transfers
        Set
            transfer_date = p_transfer_date,
            to_costcode = p_to_costcode,
            modified_by = v_by_empno,
            modified_on = sysdate
        Where
            key_id = p_key_id;
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_delete(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_by_empno Varchar2(5);
        v_count    Number;
    Begin
        v_by_empno     := get_empno_from_meta_id(p_meta_id);

        If v_by_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Delete
            From mis_internal_transfers
        Where
            key_id = p_key_id;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_details(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_key_id            Varchar2,

        p_empno         Out Varchar2,
        p_employee_name Out Varchar2,
        p_from_costcode Out Varchar2,
        p_to_costcode   Out Varchar2,
        p_transfer_date Out Date,

        p_message_type  Out Varchar2,
        p_message_text  Out Varchar2
    ) As
        v_by_empno               Varchar2(5);
        v_count                  Number;
        v_rec_internal_transfers mis_internal_transfers%rowtype;
    Begin
        v_by_empno      := get_empno_from_meta_id(p_meta_id);

        If v_by_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            mis_internal_transfers
        Where
            key_id = p_key_id;
        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Invalid id';
            Return;
        End If;

        Select
            *
        Into
            v_rec_internal_transfers
        From
            mis_internal_transfers
        Where
            key_id = p_key_id;

        p_empno         := v_rec_internal_transfers.empno;
        p_employee_name := pkg_common.fn_get_employee_name(p_empno);
        p_from_costcode := v_rec_internal_transfers.from_costcode || ' - ' || pkg_common.fn_get_dept_name(v_rec_internal_transfers.
        from_costcode);
        p_to_costcode   := v_rec_internal_transfers.to_costcode;
        p_transfer_date := v_rec_internal_transfers.transfer_date;

        p_message_type  := ok;
        p_message_text  := 'Procedure executed successfully';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

End;