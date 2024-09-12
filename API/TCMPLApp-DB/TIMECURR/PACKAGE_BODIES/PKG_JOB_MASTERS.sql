--------------------------------------------------------
--  DDL for Package Body PKG_JOB_MASTERS
--------------------------------------------------------

Create Or Replace Package Body "TIMECURR"."PKG_JOB_MASTERS" As

    Procedure sp_add_job_tmagroup(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_tma_group        Varchar2,
        p_sub_group        Varchar2,
        p_tma_group_desc   Varchar2,

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
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            job_tmagroup
        Where
            Trim(upper(tmagroup)) = Trim(upper(p_tma_group));

        If v_exists = 0 Then
            Insert Into job_tmagroup
                (tmagroup, subgroup, tmagroupdesc)
            Values
                (Trim(upper(p_tma_group)), Trim(p_sub_group), Trim(p_tma_group_desc));

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Job TMA Group ready exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_job_tmagroup;

    Procedure sp_update_job_tmagroup(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_tma_group        Varchar2,
        p_sub_group        Varchar2,
        p_tma_group_desc   Varchar2,

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
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            job_tmagroup
        Where
            tmagroup = p_tma_group;

        If v_exists = 1 Then
            Update
                job_tmagroup
            Set
                subgroup = p_sub_group,
                tmagroupdesc = p_tma_group_desc
            Where
                tmagroup = p_tma_group;

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'No matching job tmag roup exists !!!';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_job_tmagroup;

    Procedure sp_delete_job_tmagroup(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_tma_group        Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Delete
            From job_tmagroup
        Where
            tmagroup = p_tma_group
            And tmagroup Not In (
                Select
                Distinct tma_grp
                From
                    jobmaster
            );

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_job_tmagroup;

    Procedure sp_add_business_line(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_short_description Varchar2,
        p_description       Varchar2,

        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_code         Varchar2(6);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            business_line
        Where
            Trim(upper(short_description)) = Trim(upper(p_short_description));

        If v_exists = 0 Then
            v_code         := dbms_random.string('X', 6);
            Insert Into business_line
                (code, short_description, description)
            Values
                (v_code, Trim(upper(p_short_description)), Trim(p_description));

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Business line ready exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_business_line;

    Procedure sp_update_business_line(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_code              Varchar2,
        p_short_description Varchar2,
        p_description       Varchar2,

        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            business_line
        Where
            code = p_code;

        If v_exists = 1 Then

            Update
                business_line
            Set
                short_description = Trim(upper(p_short_description)),
                description = Trim(p_description)
            Where
                code = p_code;

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'No matching business line exists !!!';
        End If;
    Exception
        When dup_val_on_index Then
            p_message_type := 'KO';
            p_message_text := 'Business line ready exists !!!';
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_business_line;

    Procedure sp_delete_business_line(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_code             Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_is_used      Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_is_used
        From
            jobmaster
        Where
            business_line = p_code;

        If v_is_used > 0 Then
            p_message_type := 'KO';
            p_message_text := 'Record cannot be delete, this record ready used in job master !!!';
            Return;
        End If;

        Delete
            From business_line
        Where
            code = p_code
            And code Not In (
                Select
                Distinct business_line
                From
                    jobmaster
            );

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_business_line;

    Procedure sp_add_sub_business_line(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_short_description Varchar2,
        p_description       Varchar2,

        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_code         Varchar2(3);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            sub_business_line
        Where
            Trim(upper(short_description)) = Trim(upper(p_short_description));

        If v_exists = 0 Then
            v_code         := dbms_random.string('X', 3);
            Insert Into sub_business_line
                (code, short_description, description)
            Values
                (v_code, Trim(upper(p_short_description)), Trim(p_description));

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Sub business line ready exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_sub_business_line;

    Procedure sp_update_sub_business_line(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_code              Varchar2,
        p_short_description Varchar2,
        p_description       Varchar2,

        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            sub_business_line
        Where
            code = p_code;

        If v_exists = 1 Then

            Update
                sub_business_line
            Set
                short_description = Trim(upper(p_short_description)),
                description = Trim(p_description)
            Where
                code = p_code;

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'No matching sub business line exists !!!';
        End If;
    Exception
        When dup_val_on_index Then
            p_message_type := 'KO';
            p_message_text := 'Sub business ready exists !!!';
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_sub_business_line;

    Procedure sp_delete_sub_business_line(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_code             Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_is_used      Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_is_used
        From
            jobmaster
        Where
            sub_business_line = p_code;

        If v_is_used > 0 Then
            p_message_type := 'KO';
            p_message_text := 'Record cannot be delete, this record ready used in job master !!!';
            Return;
        End If;

        Delete
            From sub_business_line
        Where
            code = p_code
            And code Not In (
                Select
                Distinct sub_business_line
                From
                    jobmaster
            );

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_sub_business_line;

    Procedure sp_add_segment(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_code             Varchar2,
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
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            segment
        Where
            Trim(upper(code)) = Trim(upper(p_code));

        If v_exists = 0 Then
            Insert Into segment
                (code, description)
            Values
                (Trim(upper(p_code)), Trim(p_description));

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'SEGMENT ready exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_segment;

    Procedure sp_update_segment(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_code             Varchar2,
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
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            segment
        Where
            code = p_code;

        If v_exists = 1 Then
            Update
                segment
            Set
                description = p_description
            Where
                code = p_code;

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'No matching SEGMENT exists !!!';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_segment;

    Procedure sp_delete_segment(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_code             Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Delete
            From segment
        Where
            code = p_code
            And code Not In (
                Select
                Distinct lineofbu
                From
                    jobmaster
            );

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_segment;

    Procedure sp_add_scope_of_work(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_short_description Varchar2,
        p_description       Varchar2,

        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_code         Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            scope_of_work
        Where
            Trim(upper(short_description)) = Trim(upper(p_short_description));

        If v_exists = 0 Then

            v_code         := dbms_random.string('X', 5);

            Insert Into scope_of_work
                (code, short_description, description)
            Values
                (v_code, Trim(upper(p_short_description)), Trim(p_description));

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Scope of work ready exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_scope_of_work;

    Procedure sp_update_scope_of_work(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_code              Varchar2,
        p_short_description Varchar2,
        p_description       Varchar2,

        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            scope_of_work
        Where
            code = p_code;

        If v_exists = 1 Then

            Update
                scope_of_work
            Set
                short_description = Trim(upper(p_short_description)),
                description = p_description
            Where
                code = p_code;

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'No matching scope of work line exists !!!';
        End If;
    Exception
        When dup_val_on_index Then
            p_message_type := 'KO';
            p_message_text := 'Scope of work ready exists !!!';
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_scope_of_work;

    Procedure sp_delete_scope_of_work(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_code             Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_is_used      Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_is_used
        From
            jobmaster
        Where
            scope_of_work = p_code;

        If v_is_used > 0 Then
            p_message_type := 'KO';
            p_message_text := 'Record cannot be delete, this record ready used in job master !!!';
            Return;
        End If;
        Delete
            From scope_of_work
        Where
            code = p_code
            And code Not In (
                Select
                Distinct scope_of_work
                From
                    jobmaster
            );

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_scope_of_work;

    Procedure sp_add_plant_type(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_short_description Varchar2,
        p_description       Varchar2,

        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_code         Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            plant_type
        Where
            Trim(upper(short_description)) = Trim(upper(p_short_description));

        If v_exists = 0 Then

            v_code         := dbms_random.string('X', 5);

            Insert Into plant_type
                (code, short_description, description)
            Values
                (v_code, Trim(upper(p_short_description)), Trim(p_description));

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Plant type ready exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_plant_type;

    Procedure sp_update_plant_type(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_code              Varchar2,
        p_short_description Varchar2,
        p_description       Varchar2,

        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            plant_type
        Where
            code = p_code;

        If v_exists = 1 Then

            Update
                plant_type
            Set
                short_description = Trim(upper(p_short_description)),
                description = p_description
            Where
                code = p_code;

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'No matching plant type exists !!!';
        End If;
    Exception
        When dup_val_on_index Then
            p_message_type := 'KO';
            p_message_text := 'Plant type ready exists !!!';
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_plant_type;

    Procedure sp_delete_plant_type(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_code             Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_is_used      Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_is_used
        From
            jobmaster
        Where
            plant_type = p_code;

        If v_is_used > 0 Then
            p_message_type := 'KO';
            p_message_text := 'Record cannot be delete, this record ready used in job master !!!';
            Return;
        End If;

        Delete
            From plant_type
        Where
            code = p_code
            And code Not In (
                Select
                Distinct plant_type
                From
                    jobmaster
            );

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_plant_type;

    Procedure sp_add_project_type(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_short_description Varchar2,
        p_description       Varchar2,

        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_code         Varchar2(2);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            job_projtype
        Where
            Trim(upper(short_description)) = Trim(upper(p_short_description));

        If v_exists = 0 Then

            v_code         := dbms_random.string('X', 1);

            Insert Into job_projtype
                (code, short_description, description)
            Values
                (v_code, Trim(upper(p_short_description)), Trim(p_description));

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Project type ready exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_project_type;

    Procedure sp_update_project_type(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_code              Varchar2,
        p_short_description Varchar2,
        p_description       Varchar2,

        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            job_projtype
        Where
            code = p_code;

        If v_exists = 1 Then

            Update
                job_projtype
            Set
                short_description = Trim(upper(p_short_description)),
                description = p_description
            Where
                code = p_code;

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'No matching project type exists !!!';
        End If;
    Exception
        When dup_val_on_index Then
            p_message_type := 'KO';
            p_message_text := 'Project type ready exists !!!';
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_project_type;

    Procedure sp_delete_project_type(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_code             Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_is_used      Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_is_used
        From
            jobmaster
        Where
            projtype = p_code;

        If v_is_used > 0 Then
            p_message_type := 'KO';
            p_message_text := 'Record cannot be delete, this record ready used in job master !!!';
            Return;
        End If;

        Delete
            From job_projtype
        Where
            code = p_code;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_project_type;

    Procedure sp_add_job_co_master(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_short_description Varchar2,
        p_description       Varchar2,

        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            job_co_master
        Where
            Trim(upper(code)) = Trim(upper(p_short_description));

        If v_exists = 0 Then
            Insert Into job_co_master
                (code, description)
            Values
                (Trim(upper(p_short_description)), Trim(p_description));

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Job co master ready exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_job_co_master;

    Procedure sp_update_job_co_master(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_code              Varchar2,
        p_short_description Varchar2,
        p_description       Varchar2,

        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            job_co_master
        Where
            code = p_code;

        If v_exists = 1 Then
            Update
                job_co_master
            Set
                description = p_description
            Where
                code = p_code;

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'No matching job co master exists !!!';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_job_co_master;

    Procedure sp_delete_job_co_master(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_code             Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Delete
            From job_co_master
        Where
            code = p_code
            And code Not In (
                Select
                Distinct projtype
                From
                    jobmaster
            );

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_job_co_master;

End pkg_job_masters;
/
  Grant Execute On "TIMECURR"."PKG_JOB_MASTERS" To "TCMPL_APP_CONFIG";