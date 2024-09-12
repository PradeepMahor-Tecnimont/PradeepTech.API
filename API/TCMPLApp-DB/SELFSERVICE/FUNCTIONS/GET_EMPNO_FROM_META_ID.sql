--------------------------------------------------------
--  DDL for Function GET_EMPNO_FROM_META_ID
--------------------------------------------------------

Create Or Replace Function "SELFSERVICE"."GET_EMPNO_FROM_META_ID"(
    p_meta_id In Varchar2
) Return Varchar2 As
    v_empno     Varchar2(5);
    v_meta_id   Varchar2(50);
    v_host_name Varchar2(100);
    c_dev_env   Constant Varchar2(100) := 'tpldevoradb';
Begin
    Return tcmpl_app_config.app_users.get_empno_from_meta_id(
            p_meta_id => p_meta_id
        );
    v_meta_id := p_meta_id;

    /*
        B E L O W   C O D E   I S   N O T   E X E C U T E D
    */
    ------------
    Return null;
    ------------
    Select
        empno
    Into
        v_empno
    From
        ss_emplmast
    Where
        Trim(metaid) = Trim(p_meta_id)
        And status   = 1;

    If Trim(v_empno) Is Null Then
        Return 'ERRRR';
    End If;
    Select
        sys_context('USERENV', 'SERVER_HOST')
    Into
        v_host_name
    From
        dual;
    If v_host_name = c_dev_env Then
        If v_empno = '02320' Then
            Null;
            --v_empno := '02640';
            --v_empno := '02766';
            --v_empno := '01412';
            --v_empno := '04170';
            --v_empno := '10646';
            --v_empno := '03150';
        End If;
    End If;
    Return v_empno;
Exception
    When Others Then
        Return 'ERRRR';

End get_empno_from_meta_id;
/