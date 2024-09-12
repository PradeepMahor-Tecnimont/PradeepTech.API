Create Or Replace Package Body "TCMPL_HR"."PKG_RELATIVES_AS_COLLEAGUES" As

    Procedure prc_update_emp_relatives_decl_status(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_decl_status      Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
        v_count Number;
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
            v_count
        From
            emp_relatives_as_colleagues
        Where
            empno = Trim(v_empno);

        Update
            emp_relatives_decl_status
        Set
            decl_status = p_decl_status,
            decl_date = sysdate,
            relative_as_colleague_exists = Case
                                               When v_count > 0 Then
                                                   ok
                                               Else
                                                   not_ok
                                           End
        Where
            empno = v_empno
            And decl_status In (0, 3);

        If Sql%found Then
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'Error...Invalid operation';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End prc_update_emp_relatives_decl_status;

    Procedure sp_add_emp_relatives_as_colleagues(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_colleague_name     Varchar2,
        p_colleague_dept     Varchar2,
        p_colleague_relation Varchar2,
        p_colleague_location Varchar2,
        p_colleague_empno    Varchar2 Default Null,

        p_message_type Out   Varchar2,
        p_message_text Out   Varchar2
    ) As
        v_exists Number;
        v_empno  Varchar2(5);
        v_emp    Varchar2(5);
        v_count  Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            rds.empno
        Into
            v_emp
        From
            emp_relatives_decl_status rds,
            vu_emplmast               e
        Where
            e.status      = 1
            And e.empno   = rds.empno
            And rds.decl_status In (0, 3)
            And rds.empno = v_empno;

        Select
            Count(*)
        Into
            v_exists
        From
            emp_relatives_as_colleagues
        Where
            empno              = v_empno
            And colleague_name = Trim(upper(p_colleague_name));

        If v_exists = 0 Then
            Insert Into emp_relatives_as_colleagues (
                empno,
                colleague_name,
                colleague_dept,
                colleague_relation,
                colleague_location,
                colleague_empno,
                modified_on,
                modified_by
            )
            Values (
                v_empno,
                upper(Trim(p_colleague_name)),
                Trim(p_colleague_dept),
                Trim(p_colleague_relation),
                Trim(p_colleague_location),
                p_colleague_empno,
                sysdate,
                Trim(v_empno)
            );

            If Sql%found Then
                Select
                    Count(*)
                Into
                    v_count
                From
                    emp_relatives_as_colleagues
                Where
                    empno = Trim(v_empno);

                prc_update_emp_relatives_decl_status(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_decl_status  => Case v_count
                                          When 0 Then
                                              0
                                          Else
                                              3
                                      End,
                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );

                If p_message_type = not_ok Then
                    Rollback;
                End If;
                p_message_type := p_message_type;
                p_message_text := p_message_text;
            Else
                p_message_type := not_ok;
                p_message_text := 'Error...Procedure not executed.';
            End If;
        Else
            p_message_type := not_ok;
            p_message_text := 'Employment of relatives already exists !!!';
        End If;

    Exception
        When no_data_found Then
            p_message_type := not_ok;
            p_message_text := 'Error...Invalid operation !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_emp_relatives_as_colleagues;

    Procedure sp_update_emp_relatives_as_colleagues(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_colleague_name     Varchar2,
        p_colleague_dept     Varchar2,
        p_colleague_relation Varchar2,
        p_colleague_location Varchar2,
        p_colleague_empno    Varchar2 Default Null,

        p_message_type Out   Varchar2,
        p_message_text Out   Varchar2
    ) As
        v_exists Number;
        v_empno  Varchar2(5);
        v_emp    Varchar2(5);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            rds.empno
        Into
            v_emp
        From
            emp_relatives_decl_status rds,
            vu_emplmast               e
        Where
            e.status            = 1
            And e.empno         = rds.empno
            And rds.decl_status = 3
            And rds.empno       = v_empno;

        Select
            Count(*)
        Into
            v_exists
        From
            emp_relatives_as_colleagues
        Where
            empno              = v_empno
            And colleague_name = Trim(upper(p_colleague_name));

        If v_exists = 1 Then
            Update
                emp_relatives_as_colleagues
            Set
                colleague_name = upper(Trim(p_colleague_name)),
                colleague_dept = Trim(p_colleague_dept),
                colleague_relation = Trim(p_colleague_relation),
                colleague_location = Trim(p_colleague_location),
                colleague_empno = p_colleague_empno,
                modified_on = sysdate,
                modified_by = Trim(v_empno)
            Where
                empno                     = v_empno
                And upper(colleague_name) = upper(Trim(p_colleague_name));

            p_message_type := ok;
            p_message_text := 'Employment of relatives updated successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Employment of relatives exists !!!';
        End If;
    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Employment of relatives already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_emp_relatives_as_colleagues;

    Procedure sp_delete_emp_relatives_as_colleagues(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_colleague_name   Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
        v_count Number;
        v_emp   Varchar2(5);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            rds.empno
        Into
            v_emp
        From
            emp_relatives_decl_status rds,
            vu_emplmast               e
        Where
            e.status            = 1
            And e.empno         = rds.empno
            And rds.decl_status = 3
            And rds.empno       = v_empno;

        Delete
            From emp_relatives_as_colleagues
        Where
            empno              = Trim(v_empno)
            And colleague_name = Trim(upper(p_colleague_name));

        If Sql%found Then
            Select
                Count(*)
            Into
                v_count
            From
                emp_relatives_as_colleagues
            Where
                empno = Trim(v_empno);

            prc_update_emp_relatives_decl_status(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,

                p_decl_status  => Case v_count
                                      When 0 Then
                                          0
                                      Else
                                          3
                                  End,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );

            If p_message_type = not_ok Then
                Rollback;
            End If;
            p_message_type := p_message_type;
            p_message_text := p_message_text;
        Else
            p_message_type := not_ok;
            p_message_text := 'Error...Procedure not executed.';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_delete_emp_relatives_as_colleagues;

    Procedure sp_submit_hr(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_relative_exists  Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
        v_emp   Varchar2(5);
        v_count Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            rds.empno
        Into
            v_emp
        From
            emp_relatives_decl_status rds,
            vu_emplmast               e
        Where
            e.status      = 1
            And e.empno   = rds.empno
            And rds.decl_status In (0, 3)
            And rds.empno = v_empno;

        Select
            Count(*)
        Into
            v_count
        From
            emp_relatives_as_colleagues
        Where
            empno = Trim(v_empno);

        If v_count > 0 And p_relative_exists = not_ok Then
            Delete
                From emp_relatives_as_colleagues
            Where
                empno = Trim(v_empno);
        Elsif v_count = 0 And p_relative_exists = ok Then
            p_message_type := not_ok;
            p_message_text := 'Error...Relatives not found';
            Return;
        End If;

        Update
            emp_relatives_decl_status
        Set
            decl_status = 1,
            decl_date = sysdate,
            relative_as_colleague_exists = p_relative_exists
        Where
            empno = v_empno
            And decl_status In (0, 3);

        If Sql%found Then
            pkg_relatives_as_colleagues_send_email.sp_send_mail_on_declaration (
                p_person_id     =>  p_person_id,
                p_meta_id       =>  p_meta_id,
                
                p_empno         =>  v_empno,
                p_decl_status   =>  1,
                p_accept_status =>  ok,
                
                p_message_type  =>  p_message_type,
                p_message_text  =>  p_message_text
            );
            
            If p_message_type = ok Then
                p_message_type := ok;
                p_message_text := 'Procedure executed successfully.';
            Else
                p_message_type := not_ok;
                p_message_text := 'Error in executing procedure !!!';
            End If;
        Else
            p_message_type := not_ok;
            p_message_text := 'Error...Invalid operation';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_submit_hr;

    Procedure sp_auto_submit_hr (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As        
        Cursor cur_rel_col Is
            Select
                rds.empno, rds.decl_status
            From
                emp_relatives_decl_status rds,
                vu_emplmast               e
            Where
                    e.status = 1
                And e.empno = rds.empno
                And rds.decl_status In ( 0, 3 )
            Order By
                empno;
        v_empno Varchar2(5);
        v_emp   Varchar2(5);
        v_count Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        
        For c1 In cur_rel_col Loop
            Select
                Count(*)
            Into v_count
            From
                emp_relatives_as_colleagues
            Where
                empno = Trim(c1.empno);

            Update emp_relatives_decl_status
            Set
                decl_status =
                    Case decl_status
                        When 3 Then
                            1
                        When 0 Then
                            2
                    End,
                decl_date = sysdate,
                relative_as_colleague_exists =
                    Case v_count
                        When 0 Then
                            not_ok
                        Else
                            ok
                    End
            Where
                empno = Trim(c1.empno);
            
            If Sql%Found then
                If c1.decl_status = 3 Then
                    pkg_relatives_as_colleagues_send_email.sp_send_mail_on_declaration (
                        p_person_id     =>  p_person_id,
                        p_meta_id       =>  p_meta_id,
                        
                        p_empno         =>  v_empno,
                        p_decl_status   =>  1,
                        p_accept_status =>  ok,
                        
                        p_message_type  =>  p_message_type,
                        p_message_text  =>  p_message_text
                    );
                Else
                    pkg_relatives_as_colleagues_send_email.sp_send_mail_on_deemed_declaration (
                        p_person_id     =>  p_person_id,
                        p_meta_id       =>  p_meta_id,
                        
                        p_empno         =>  v_empno,
                        p_decl_status   =>  2,
                        p_accept_status =>  not_ok,
                        
                        p_message_type  =>  p_message_type,
                        p_message_text  =>  p_message_text
                    );
                End If;
            End If;
        
        End Loop;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_auto_submit_hr;
    
End pkg_relatives_as_colleagues;