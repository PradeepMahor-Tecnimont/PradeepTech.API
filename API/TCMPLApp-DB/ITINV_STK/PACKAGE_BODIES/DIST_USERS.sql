--------------------------------------------------------
--  DDL for Package Body DIST_USERS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "ITINV_STK"."DIST_USERS" As

    Function get_dept_desc (
        p_costcode Varchar2
    ) Return Varchar2 As
        v_ret_val Varchar2(100);
    Begin
        Select
            name
        Into v_ret_val
        From
            vu_costmast
        Where
            costcode = p_costcode;

        Return v_ret_val;
    Exception
        When Others Then
            Null;
    End;

    Function get_roles_for_user (
        param_win_uid Varchar2
    ) Return Varchar2 As

        v_count     Number;
        v_empno     Varchar2(5);
        v_roles     Varchar2(200);
        v_ret_val   Varchar2(200);
    Begin
        v_roles     := 'NONE';
        v_empno     := dist_users.get_empno_from_win_uid(param_win_uid);
        /*
        Select
            Count(*)
        Into v_count
        From
            mbo_emp_yyyy_mast
        Where
            empno                     = v_empno And
            nvl(login_allowed, 'KO')  = 'OK' And
            mbo_yyyy In (
                Select
                    yyyy
                From
                    mbo_fin_year
                Where
                    is_open = 'OK'
            );

        If v_count > 0 Then
            v_roles := 'MBO_USER';
        End If;
        */
        Select
            Count(*)
        Into v_count
        From
            (
                Select
                    costcode
                From
                    vu_costmast
                Where
                    hod = v_empno
                Union
                Select
                    dept
                From
                    dist_user_dept
                Where
                    empno = v_empno
            );

        If v_count > 0 Then
            v_roles := v_roles || ',' || 'DIST_HOD';
        End If;

        Select
            Count(*)
        Into v_count
        From
            dist_roles_2_user
        Where
            empno = v_empno;

        If v_count > 0 Then
            Select
                Listagg(role_name,
                        ',') Within Group(
                    Order By
                        role_name
                ) emp_roles
            Into v_ret_val
            From
                dist_role_mast
            Where
                role_id In (
                    Select
                        role_id
                    From
                        dist_roles_2_user
                    Where
                        empno = v_empno
                );

        End If;

        v_ret_val   := Trim(Both ',' From ( v_roles || ',' || v_ret_val ));

        If v_ret_val <> 'NONE' Then
            v_ret_val := Replace(v_ret_val, 'NONE,', '');
        End If;

        Return v_ret_val;
    Exception
        When Others Then
            Return 'NONE';
    End;

    Function check_user_in_role (
        param_win_uid Varchar2,
        param_role Varchar2
    ) Return Varchar2 As
        v_user_roles   Varchar2(1000);
        v_int          Number;
    Begin
        v_user_roles   := get_roles_for_user(param_win_uid);
        v_int          := Instr(v_user_roles, param_win_uid);
        If v_int > 0 Then
            Return 'OK';
        Else
            Return 'KO';
        End If;
    End;

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
                stk_empmaster
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
            vu_userids      a,
            stk_empmaster   b
        Where
            a.empno = b.empno
            And Upper(a.userid)  = Upper(v_user_id)
            And Upper(a.domain)  = Upper(v_user_domain)
            And b.status         = 1;

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
            stk_empmaster
        Where
            empno = param_empno;

        Return v_emp_name;
    Exception
        When Others Then
            Return Null;
    End;

End dist_users;

/
