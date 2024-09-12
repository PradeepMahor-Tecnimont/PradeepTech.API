--------------------------------------------------------
--  DDL for Procedure CHANGE_PASSWORD
--------------------------------------------------------
Set Define Off;

Create Or Replace Procedure "SELFSERVICE"."CHANGE_PASSWORD"(
    param_empno    In  Varchar2,
    param_cur_pwd  In  Varchar2,
    param_new_pwd1 In  Varchar2,
    param_new_pwd2 In  Varchar2,
    param_success  Out Varchar2,
    param_message  Out Varchar2
) As
    v_count Number;
    v_empno Varchar2(5);
Begin
    v_empno       := upper(lpad(trim(param_empno), 5, '0'));

    Select
        Count(*)
    Into
        v_count
    From
        ss_emplmast
    Where
        empno      = v_empno
        And status = 1;

    If v_count = 0 Then
        param_success := 'KO';
        param_message := 'Error :- Incorrect Empno . Password not changed.';
        Return;
    End If;

    If length(param_new_pwd1) Not Between 1 And 10 Then
        param_success := 'KO';
        param_message := 'Error :- Password length should be greater than "7" and less then "10"';
        Return;
    End If;

    If length(param_new_pwd1) Not Between 1 And 10 Then
        param_success := 'KO';
        param_message := 'Error :- Password length should be greater than "0" and less then "10"';
        Return;
    End If;

    If param_new_pwd1 <> param_new_pwd2 Then
        param_success := 'KO';
        param_message := 'Error :- New Password and Confirm Password do not match.';
        Return;
    End If;

    Update
        ss_emplmast
    Set
        password = Trim(param_new_pwd1),
        pwd_chgd = 1
    Where
        empno = v_empno;

    Commit;
    param_success := 'OK';
    param_message := 'Password changed successfully.';
Exception
    When Others Then
        param_success := 'KO';
        param_message := 'Error :- ' || sqlcode || ' - ' || sqlerrm;
End change_password;
/

Grant Execute On "SELFSERVICE"."CHANGE_PASSWORD" To "TCMPL_APP_CONFIG";