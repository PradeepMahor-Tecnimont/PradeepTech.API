Create Or Replace Package Body tcmpl_hr.pkg_emp_family As

    Procedure sp_add_family(
        p_empno            Varchar2,
        p_modified_by      Varchar2,
        p_member           Varchar2,
        p_dob              Date,
        p_family_relation  Number,
        p_occupation       Number,
        p_remarks          Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists         Number;
        v_dob_validation Number;
        v_self_dob       Date;
        v_keyid          Varchar2(8);
        v_user_tcp_ip    Varchar2(5)          := 'NA';
        v_message_type   Number               := 0;
        v_emp_gender     Varchar2(1);
        c_female         Constant Varchar2(1) := 'F';
        c_male           Constant Varchar2(1) := 'M';
        v_child_age      Number;
    Begin
        Select sex Into v_emp_gender From vu_emplmast Where empno = p_empno;
        If (p_family_relation = c_family_relation_son Or p_family_relation = c_family_relation_daughter) Then
            Select trunc(dob)
              Into v_self_dob
              From vu_emplmast
             Where Trim(empno) = Trim(p_empno);

            v_dob_validation := fn_dob_validation(v_self_dob, p_dob);
            If (v_dob_validation <= 18 And v_emp_gender = c_female) Then
                p_message_type := not_ok;
                p_message_text := 'Invalid Date - from the date of employee`s DoB, 21 years for Male employees and 18 years for Female employees. ';
                Return;
            End If;

            If (v_dob_validation <= 21 And v_emp_gender = c_male) Then
                p_message_type := not_ok;
                p_message_text := 'Invalid Date - from the date of employee`s DoB, 21 years for Male employees and 18 years for Female employees. ';
                Return;
            End If;

            v_child_age      := (round(To_Number(months_between(p_dob, sysdate)) / 12));
            If v_child_age >= 25 Then
                p_message_type := not_ok;
                p_message_text := v_child_age || ' Children of age 25 years or more are not eligible for mediclaim.';
                Return;
            End If;
        End If;
        Select Count(*)
          Into v_exists
          From emp_family
         Where empno = p_empno;
        If v_exists > 4 Then

            p_message_type := not_ok;
            p_message_text := 'Only 4 family members are eligible for mediclaim.';
            Return;
        End If;
        v_keyid := dbms_random.string('X', 8);
        Select Count(*)
          Into v_exists
          From emp_family
         Where Trim(upper(member)) = Trim(upper(p_member))
           And relation            = p_family_relation
           And trunc(dob)          = trunc(p_dob)
           And Trim(empno)         = Trim(p_empno);

        If v_exists = 0 Then
            Insert Into emp_family (
                key_id,
                empno,
                member,
                dob,
                relation,
                occupation,
                remarks,
                modified_on,
                modified_by
            )
            Values (
                v_keyid,
                Trim(p_empno),
                Trim(upper(p_member)),
                p_dob,
                p_family_relation,
                p_occupation,
                Trim(p_remarks),
                sysdate,
                p_modified_by
            );

            Commit;
            p_message_type := ok;
            p_message_text := 'Employee family added successfully..';
        Else
            p_message_type := not_ok;
            p_message_text := 'Employee family already exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_family;

    Procedure sp_update_family(
        p_key_id           Varchar2,
        p_empno            Varchar2,
        p_modified_by      Varchar2,
        p_member           Varchar2,
        p_dob              Date,
        p_family_relation  Number,
        p_occupation       Number,
        p_remarks          Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists         Number;
        v_dob_validation Number;
        v_self_dob       Date;
        v_user_tcp_ip    Varchar2(5)          := 'NA';
        v_message_type   Number               := 0;
        v_emp_gender     Varchar2(1);
        c_female         Constant Varchar2(1) := 'F';
        c_male           Constant Varchar2(1) := 'M';
        v_child_age      Number;
    Begin
        Select sex Into v_emp_gender From vu_emplmast Where empno = p_empno;
        Select Count(*)
          Into v_exists
          From emp_family
         Where key_id      = p_key_id
           And Trim(empno) = Trim(p_empno);

        If (p_family_relation = c_family_relation_son Or p_family_relation = c_family_relation_daughter) Then
            Select trunc(dob)
              Into v_self_dob
              From vu_emplmast
             Where Trim(empno) = Trim(p_empno);

            v_dob_validation := fn_dob_validation(v_self_dob, p_dob);
            If (v_dob_validation <= 18 And v_emp_gender = c_female) Then
                p_message_type := not_ok;
                p_message_text := 'Invalid Date - from the date of employee`s DoB, 21 years for Male employees and 18 years for Female employees. ';
                Return;
            End If;

            If v_dob_validation <= 21 And p_family_relation = c_family_relation_son Then
                p_message_type := not_ok;
                p_message_text := 'Invalid Date - from the date of employee`s DoB, 21 years for Male employees and 18 years for Female employees. ';
                Return;
            End If;
            v_child_age      := (round(To_Number(months_between(sysdate,p_dob )) / 12));
            If v_child_age >= 25 Then
                p_message_type := not_ok;
                p_message_text := 'Children of age 25 years or more are not eligible for mediclaim.';
                Return;
            End If;

        End If;

        If v_exists = 1 Then
            Update emp_family
               Set member = Trim(upper(p_member)),
                   dob = p_dob,
                   relation = p_family_relation,
                   occupation = p_occupation,
                   remarks = Trim(p_remarks),
                   modified_on = sysdate,
                   modified_by = p_modified_by
             Where key_id      = p_key_id
               And Trim(empno) = Trim(p_empno);

            Commit;
            p_message_type := ok;
            p_message_text := 'Employee family updated successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Employee family exists !!!';
        End If;
    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Employee family already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_family;

    Procedure sp_delete_family(
        p_key_id           Varchar2,
        p_empno            Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_is_used      Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        Delete From emp_family
         Where key_id      = p_key_id
           And Trim(empno) = Trim(p_empno);

        Commit;
        p_message_type := ok;
        p_message_text := 'Record deleted successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_delete_family;

    Procedure sp_emp_family_details(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,
        p_key_id              Varchar2,
        p_empno           Out Varchar2,
        p_member          Out Varchar2,
        p_dob             Out Date,
        p_relation_val    Out Number,
        p_occupation_val  Out Number,
        p_relation_text   Out Varchar2,
        p_occupation_text Out Varchar2,
        p_remarks         Out Varchar2,
        p_modified_on     Out Date,
        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
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

        Select Count(*)
          Into v_exists
          From emp_family
         Where key_id = p_key_id;

        If v_exists = 1 Then
            Select Distinct
                   empno,
                   member,
                   dob,
                   relation,
                   occupation,
                   rel.description || '(' || rel.gender || ')' As relation_text,           -- VARCHAR2 
                   oc.description                              As occupation_text,           -- VARCHAR2 
                   remarks,
                   modified_on
              Into p_empno,
                   p_member,
                   p_dob,
                   p_relation_val,
                   p_occupation_val,
                   p_relation_text,
                   p_occupation_text,
                   p_remarks,
                   p_modified_on
              From emp_family     a,
                   emp_relation_mast rel,
                   emp_occupation oc
             Where key_id   = p_key_id
               And oc.code  = a.occupation
               And rel.code = a.relation;

            Commit;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Employee family exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_emp_family_details;

    Procedure sp_add_emp_family(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_member           Varchar2,
        p_dob              Date,
        p_family_relation  Number,
        p_occupation       Number,
        p_remarks          Varchar2,
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

        pkg_emp_family.sp_add_family(
            p_empno           => v_empno,
            p_modified_by     => v_empno,
            p_member          => p_member,
            p_dob             => p_dob,
            p_family_relation => p_family_relation,
            p_occupation      => p_occupation,
            p_remarks         => p_remarks,
            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_emp_family;

    Procedure sp_update_emp_family(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_key_id           Varchar2,
        p_member           Varchar2,
        p_dob              Date,
        p_family_relation  Number,
        p_occupation       Number,
        p_remarks          Varchar2,
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

        pkg_emp_family.sp_update_family(
            p_key_id          => p_key_id,
            p_empno           => v_empno,
            p_modified_by     => v_empno,
            p_member          => p_member,
            p_dob             => p_dob,
            p_family_relation => p_family_relation,
            p_occupation      => p_occupation,
            p_remarks         => p_remarks,
            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Employee family already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_emp_family;

    Procedure sp_delete_emp_family(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_key_id           Varchar2,
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
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        pkg_emp_family.sp_delete_family(
            p_key_id       => p_key_id,
            p_empno        => v_empno,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

        p_message_type := ok;
        p_message_text := 'Record deleted successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_delete_emp_family;

    Procedure sp_add_4hr_emp_family(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_empno            Varchar2,
        p_member           Varchar2,
        p_dob              Date,
        p_family_relation  Number,
        p_occupation       Number,
        p_remarks          Varchar2,
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

        pkg_emp_family.sp_add_family(
            p_empno           => p_empno,
            p_modified_by     => v_empno,
            p_member          => p_member,
            p_dob             => p_dob,
            p_family_relation => p_family_relation,
            p_occupation      => p_occupation,
            p_remarks         => p_remarks,
            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_4hr_emp_family;

    Procedure sp_update_4hr_emp_family(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_key_id           Varchar2,
        p_empno            Varchar2,
        p_member           Varchar2,
        p_dob              Date,
        p_family_relation  Number,
        p_occupation       Number,
        p_remarks          Varchar2,
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

        pkg_emp_family.sp_update_family(
            p_key_id          => p_key_id,
            p_empno           => p_empno,
            p_modified_by     => v_empno,
            p_member          => p_member,
            p_dob             => p_dob,
            p_family_relation => p_family_relation,
            p_occupation      => p_occupation,
            p_remarks         => p_remarks,
            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Employee family already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_4hr_emp_family;

    Procedure sp_delete_4hr_emp_family(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_key_id           Varchar2,
        p_empno            Varchar2,
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
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        pkg_emp_family.sp_delete_family(
            p_key_id       => p_key_id,
            p_empno        => p_empno,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

        p_message_type := ok;
        p_message_text := 'Record deleted successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_delete_4hr_emp_family;

    Procedure sp_emp_self_details(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,
        p_emp_no              Varchar2,
        p_empno           Out Varchar2,
        p_member          Out Varchar2,
        p_dob             Out Date,
        p_relation_val    Out Number,
        p_occupation_val  Out Number,
        p_relation_text   Out Varchar2,
        p_occupation_text Out Varchar2,
        p_remarks         Out Varchar2,
        p_modified_on     Out Date,
        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
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

        Select Count(*)
          Into v_exists
          From emp_family
         Where empno = p_emp_no;

        If v_exists = 0 Then
            Select empno,
                   name                                        As member,
                   dob,
                   5                                           As relation,
                   1                                           As occupation,
                   rel.description || '(' || rel.gender || ')' relation_text,
                   oc.description                              As occupation_text,
                   ''                                          remarks,
                   sysdate                                     modified_on
              Into p_empno,
                   p_member,
                   p_dob,
                   p_relation_val,
                   p_occupation_val,
                   p_relation_text,
                   p_occupation_text,
                   p_remarks,
                   p_modified_on
              From vu_emplmast    a,
                   emp_relation_mast rel,
                   emp_occupation oc
             Where a.empno  = p_emp_no
               And oc.code  = 1  -- SELF(-)
               And
                   rel.code = 5; -- EMPLOYEED

            Commit;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Employee family exists !!!' || v_exists;
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_emp_self_details;

    Function fn_dob_validation(
        p_self_dob      Date,
        p_dependent_dob Date
    ) Return Number As
        v_retval Number;
        v_diff   Number;
    Begin
        Select (round(To_Number(months_between(p_dependent_dob, p_self_dob)) / 12)) As diff,
               Case
                   When (round(To_Number(months_between(p_dependent_dob, p_self_dob)) / 12) >= 18) Then
                       1
                   Else
                       0
               End                                                                  As result
          Into v_diff,
               v_retval
          From dual;

        Return v_diff;
    Exception
        When Others Then
            Return 0;
    End fn_dob_validation;

    Procedure sp_update_self_dob(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno       Varchar2(5);
        v_dob         Date;
        v_emp_name    Varchar2(80);
        v_user_tcp_ip Varchar2(5) := 'NA';
        v_count       Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select Count(*)
          Into v_count
          From emp_family a,
               vu_emplmast b
         Where b.status   = 1
           And a.relation = 5
           And a.empno    = b.empno
           And a.empno    = v_empno
           And (
                   trunc(a.dob) != trunc(b.dob)
                   Or
                   Trim(upper(a.member)) != Trim(upper(b.name))
               );

        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Record already up to date as per HR master record..';
            Return;
        End If;

        Select b.dob,
               b.name
          Into v_dob,
               v_emp_name
          From vu_emplmast b
         Where b.status = 1
           And b.empno  = v_empno;

        If v_dob Is Not Null Then

            Update emp_family a
               Set a.dob = v_dob,
                   a.member = v_emp_name
             Where a.empno    = v_empno
               And a.relation = 5;

            Commit;

        End If;

        p_message_type := ok;
        p_message_text := 'Date of birth updated successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_self_dob;

    Procedure sp_update_self_record(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno       Varchar2(5);
        v_dob         Date;
        v_emp_name    Varchar2(80);
        v_user_tcp_ip Varchar2(5) := 'NA';
        v_count       Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select Count(*)
          Into v_count
          From emp_family a,
               vu_emplmast b
         Where b.status   = 1
           And a.relation = 5
           And a.empno    = b.empno
           And a.empno    = v_empno
           And (
                   trunc(a.dob) != trunc(b.dob)
                   Or
                   Trim(upper(a.member)) != Trim(upper(b.name))
               );

        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Record already up to date as per HR master record..';
            Return;
        End If;

        Select b.dob,
               b.name
          Into v_dob,
               v_emp_name
          From vu_emplmast b
         Where b.status = 1
           And b.empno  = v_empno;

        If v_dob Is Not Null Then
            Update emp_family a
               Set a.dob = v_dob,
                   a.member = v_emp_name
             Where a.empno    = v_empno
               And a.relation = 5;
            Commit;
        End If;

        p_message_type := ok;
        p_message_text := 'Date of birth updated successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_self_record;

End pkg_emp_family;
/
Grant Execute On tcmpl_hr.pkg_emp_family To tcmpl_app_config;