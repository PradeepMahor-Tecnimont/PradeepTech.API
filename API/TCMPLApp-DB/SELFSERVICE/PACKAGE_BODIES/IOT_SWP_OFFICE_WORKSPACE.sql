Create Or Replace Package Body "IOT_SWP_OFFICE_WORKSPACE" As
    Procedure sp_add_office_ws_desk(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_deskid           Varchar2,
        p_empno            Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        strsql            Varchar2(600);
        v_count           Number;
        v_ststue          Varchar2(5);
        v_mod_by_empno    Varchar2(5);
        v_pk              Varchar2(10);
        v_fk              Varchar2(10);
        v_empno           Varchar2(5);
        v_attendance_date Date;
        v_desk            Varchar2(20);
        v_parent          Varchar2(4);
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
            swp_primary_workspace
        Where
            Trim(empno)                 = Trim(p_empno)
            And Trim(primary_workspace) = '1';

        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number ' || p_empno;
            Return;
        End If;
        Select
            parent
        Into
            v_parent
        From
            ss_emplmast
        Where
            empno = p_empno;


        iot_swp_dms.sp_add_desk_user(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,

            p_empno        => p_empno,
            p_deskid       => p_deskid,
            p_parent       => v_parent,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_office_ws_desk;
End iot_swp_office_workspace;