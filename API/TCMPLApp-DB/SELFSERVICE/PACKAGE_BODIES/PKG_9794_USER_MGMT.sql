--------------------------------------------------------
--  DDL for Package Body PKG_9794_USER_MGMT
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."PKG_9794_USER_MGMT" As

    Procedure remove_tf_user (
        param_key_id       Varchar2,
        param_by_win_uid   Varchar2,
        param_success      Out Varchar2,
        param_msg          Out Varchar2
    ) As
        v_by_empno   Varchar2(5);
    Begin
        v_by_empno      := pkg_09794.get_empno(param_by_win_uid);
        If v_by_empno Is Null Then
            param_success   := 'KO';
            param_msg       := 'Err - Data Entry by EmpNo not found.';
            return;
        End If;

        Insert Into ss_9794_emp_list_del (
            key_id,
            empno,
            entry_date,
            entry_by,
            del_by,
            del_date
        ) Select key_id,
               empno,
               entry_date,
               entry_by,
               v_by_empno,
               Sysdate
        From ss_9794_emp_list
        Where key_id   = param_key_id;

        If Sql%rowcount = 1 Then
            Delete From ss_9794_emp_list Where key_id   = param_key_id;

            Commit;
            param_success   := 'OK';
            param_msg       := 'User Successfully removed from Task Force';
        Else
            param_success   := 'KO';
            param_msg       := 'Err - No Matching entry could be found.';
        End If;

    Exception
        When Others Then
            param_success   := 'KO';
            param_msg       := 'Err - ' ||sqlcode ||' - ' ||sqlerrm;
    End remove_tf_user;

    Procedure add_tf_user (
        param_empno        Varchar2,
        param_by_win_uid   Varchar2,
        param_success      Out Varchar2,
        param_msg          Out Varchar2
    ) As
        v_key_id     Varchar2(5);
        v_by_empno   Varchar2(5);
        v_count      Number;
    Begin
        v_by_empno      := pkg_09794.get_empno(param_by_win_uid);
        If v_by_empno Is Null Then
            param_success   := 'KO';
            param_msg       := 'Err - Data Entry by EmpNo not found.';
            return;
        End If;

        Select Count(*)
        Into
            v_count
        From ss_9794_emp_list
        Where empno   = param_empno;

        If v_count > 0 Then
            param_success   := 'KO';
            param_msg       := 'Err - User already exists in taskforce.';
            return;
        End If;

        v_key_id        := dbms_random.string('X', 5);
        Insert Into ss_9794_emp_list (
            empno,
            entry_date,
            entry_by,
            key_id
        ) Values (
            param_empno,
            Sysdate,
            v_by_empno,
            v_key_id
        );

        If Sql%rowcount = 1 Then
            Commit;
            param_success   := 'OK';
            param_msg       := 'User Successfully added from Task Force';
        Else
            param_success   := 'KO';
            param_msg       := 'User could not be added to Task Force.';
        End If;

    Exception
        When Others Then
            param_success   := 'KO';
            param_msg       := 'Err - ' ||sqlcode ||' - ' ||sqlerrm;
    End add_tf_user;

    Procedure update_key_id Is
        Cursor c1 Is
            Select empno
            From ss_9794_emp_list;

    Begin
        For c2 In c1 Loop
            Update ss_9794_emp_list
                Set
                    key_id = dbms_random.string('X', 5);

        End Loop;

        Commit;
    End;

    Procedure add_role_2_emp (
        param_empno        Varchar2,
        param_role_id      Number,
        param_by_win_uid   Varchar2,
        param_success      Out Varchar2,
        param_msg          Out Varchar2
    ) Is
        v_by_empno   Varchar2(5);
        v_count      Number;
    Begin
        v_by_empno      := pkg_09794.get_empno(param_by_win_uid);
        if param_role_id in (3,5) and v_by_empno <> '02320' then
            param_success   := 'KO';
            param_msg       := 'Err - Please contact IT to add these roles.';
            return;
        End If;
        If v_by_empno Is Null Then
            param_success   := 'KO';
            param_msg       := 'Err - Data Entry by EmpNo not found.';
            return;
        End If;

        Select Count(*)
        Into
            v_count
        From ss_9794_emp_roles
        Where empno     = param_empno
            And role_id   = param_role_id;

        If v_count > 0 Then
            param_success   := 'KO';
            param_msg       := 'Err - Role has been already added to user.';
            return;
        End If;

        Insert Into ss_9794_emp_roles (
            empno,
            role_id,
            entry_by,
            entry_date
        ) Values (
            param_empno,
            param_role_id,
            v_by_empno,
            Sysdate
        );

        If Sql%rowcount = 1 Then
            Commit;
            param_success   := 'OK';
            param_msg       := 'Role Successfully added to user';
        Else
            param_success   := 'KO';
            param_msg       := 'Err - Role could not be added to User.';
        End If;

    Exception
        When Others Then
            param_success   := 'KO';
            param_msg       := 'Err - ' ||sqlcode ||' - ' ||sqlerrm;
    End;

    Procedure remove_role_from_user (
        param_empno        Varchar2,
        param_role_id      Number,
        param_by_win_uid   Varchar2,
        param_success      Out Varchar2,
        param_msg          Out Varchar2
    ) is

        v_by_empno   Varchar2(5);
    begin
        v_by_empno      := pkg_09794.get_empno(param_by_win_uid);
        if param_role_id in (3,5) and v_by_empno <> '02320' then
            param_success   := 'KO';
            param_msg       := 'Err - Please contact IT to remove these roles.';
            return;
        End If;

        delete from ss_9794_emp_roles where empno = param_empno and role_id = param_role_id;
        If Sql%rowcount = 1 Then
            Commit;
            param_success   := 'OK';
            param_msg       := 'Role Successfully removed from user';
        Else
            param_success   := 'KO';
            param_msg       := 'Err - Role could not be removed from User.';
        End If;

    Exception
        When Others Then
            param_success   := 'KO';
            param_msg       := 'Err - ' ||sqlcode ||' - ' ||sqlerrm;
    end;


End pkg_9794_user_mgmt;


/
