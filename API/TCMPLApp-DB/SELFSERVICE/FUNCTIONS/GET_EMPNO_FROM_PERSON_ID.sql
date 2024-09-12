--------------------------------------------------------
--  DDL for Function GET_EMPNO_FROM_PERSON_ID
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GET_EMPNO_FROM_PERSON_ID" (
    p_person_id In Varchar2
) Return Varchar2 As
    v_empno     Varchar2(5);
    v_person_id Varchar2(10);
    v_host_name Varchar2(100);
    c_dev_env   Constant Varchar2(100) := 'tpldevoradb';
Begin
    /*
    v_person_id := trim(substr(p_person_id, 2));

    Select
        empno
    Into
        v_empno
    From
        ss_emplmast
    Where
        Trim(personid) In (Trim(p_person_id), v_person_id)
        And status = 1;
    */
    
    v_empno := swp_users.get_empno_from_win_uid(p_person_id);
    if trim(v_empno) is null then
        return 'ERRRR';
    end if;
    Select
        sys_context('USERENV', 'SERVER_HOST')
    Into
        v_host_name
    From
        dual;
    If v_host_name = c_dev_env Then
        If v_empno = '02320' Then
            null;
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
End get_empno_from_person_id;

/
