Create Or Replace Package Body "TIMECURR"."PKG_EXPDP_REMAP_DATA" As

    Function fn_dob(p_dob Date) Return Date As
        v_ret_date   Date;

        v_random_day Number;
    Begin

        If p_dob Is Null Then
            Return Null;
        End If;

        v_random_day := dbms_random.value(1, 365);

        v_ret_date   := trunc(p_dob, 'YEAR') + v_random_day;
        Return v_ret_date;
    End;
    
    --
    Function fn_string(p_value Varchar2) Return Varchar2 As
        v_len     Number;
        v_ret_val Varchar2(1000);
        c_u_alpha  Varchar2(26) := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        c_l_alpha  Varchar2(26) := 'abcdefghijklmnopqrstuvwxyz';
        c_numbers varchar2(10) := '0123456789';
        v_random_str varchar2(26);
        v_random_num varchar2(10);
    Begin
        If p_value Is Null Then
            Return Null;
        End If;
        v_ret_val := p_value;
        
        --Replace upper text
        v_random_str := dbms_random.string('U',26);
        v_ret_val := translate(v_ret_val, c_u_alpha, v_random_str);

        --Replace lower text
        v_random_str := dbms_random.string('l',26);
        v_ret_val := translate(v_ret_val, c_l_alpha, v_random_str);
        
        --Replace numeric
        v_random_str := substr(dbms_random.value,3,10);
        v_ret_val := translate(v_ret_val, c_numbers, v_random_str);

        Return v_ret_val;

    End;

    --
    Function fn_remap_to_null(p_value Varchar2) Return Varchar2 As
    Begin
        Return Null;
    End;
    --
End;