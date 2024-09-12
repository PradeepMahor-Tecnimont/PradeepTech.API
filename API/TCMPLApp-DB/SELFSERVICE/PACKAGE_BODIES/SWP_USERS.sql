--------------------------------------------------------
--  DDL for Package Body SWP_USERS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."SWP_USERS" As

    Function fnc_get_roles_for_user (
        param_win_uid Varchar2
    ) Return Varchar2 As

        v_count     Number;
        v_empno     Varchar2(5);
        v_roles     Varchar2(200);
        v_ret_val   Varchar2(200);
    Begin
        v_roles   := 'NONE';
        v_empno   := get_empno_from_win_uid(param_win_uid);
        --Check Employee Exists
        Select
            Count(*)
        Into v_count
        From
            ss_emplmast
        Where
            empno = v_empno
            And status = 1;

        If v_count = 0 Then
            Return v_roles;
        Else
            v_ret_val := 'SWP_USER';
        End If;
        --Check Employee is HoD
        Select
            Count(*)
        Into v_count
        From
            ss_emplmast
        Where
            status = 1
            And mngr = v_empno;

        If v_count > 0 Then
            v_ret_val := v_ret_val || ',SWP_HOD';
        End If;
        Select
            Count(*)
        Into v_count
        From
            ss_usermast
        Where
            empno = v_empno
            And type    = 3
            And active  = 1;

        If v_count > 0 Then
            v_ret_val := v_ret_val || ',SWP_HR';
        End If;
        Select
            Count(*)
        Into v_count
        From
            ss_usermast
        Where
            empno = v_empno
            And type    = 4
            And active  = 1;

        If v_count > 0 Then
            v_ret_val := v_ret_val || ',TESTING_USER';
        End If;
        Select
            Count(*)
        Into v_count
        From
            ss_usermast
        Where
            empno = v_empno
            And type    = 5
            And active  = 1;

        If v_count > 0 Then
            v_ret_val := v_ret_val || ',SWP_GENSE';
        End If;
        Return v_ret_val;
    Exception
        When Others Then
            Return 'NONE';
    End fnc_get_roles_for_user;

    Function get_empno_from_win_uid (
        param_win_uid Varchar2
    ) Return Varchar2 As
        v_user_domain   Varchar2(60);
        v_user_id       Varchar2(60);
        v_empno         Varchar2(5);
    Begin
        If Instr(param_win_uid, '\') = 0 Then
            Select
                empno
            Into v_empno
            From
                ss_emplmast
            Where
                Trim(empno) = param_win_uid;

            Return v_empno;
        End If;

        v_user_domain   := Substr(param_win_uid, 1, Instr(param_win_uid, '\') - 1);

        v_user_id       := Substr(param_win_uid, Instr(param_win_uid, '\') + 1);
        Select
            a.empno
        Into v_empno
        From
            userids       a,
            ss_emplmast   b
        Where
            a.empno = b.empno
            And Upper(a.userid)  = Upper(v_user_id)
            And Upper(a.domain)  = Upper(v_user_domain)
            And b.status         = 1;

        If v_empno = '02320' Then
            --v_empno := '10952';
            --v_empno:= '02862';
            Null;
        End If;
        Return v_empno;
    Exception
        When Others Then
            Return Null;
    End;

    Function get_emp_name_from_empno (
        param_empno Varchar2
    ) Return Varchar2 As
        v_emp_name Varchar2(100);
    Begin
        Select
            name
        Into v_emp_name
        From
            ss_emplmast
        Where
            empno = param_empno;

        Return v_emp_name;
    Exception
        When Others Then
            Return Null;
    End;

    Procedure get_roles_for_user (
        param_win_uid   Varchar2,
        param_roles     Out             Varchar2,
        param_success   Out             Varchar2,
        param_message   Out             Varchar2
    ) As
        v_roles Varchar2(100);
    Begin
        param_roles     := fnc_get_roles_for_user(param_win_uid => param_win_uid);
        param_success   := 'OK';
        param_message   := '';
    Exception
        When Others Then
            param_roles     := 'NONE';
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End;

End swp_users;


/

  GRANT EXECUTE ON "SELFSERVICE"."SWP_USERS" TO "TCMPL_APP_CONFIG";
