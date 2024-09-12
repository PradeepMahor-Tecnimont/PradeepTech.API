--------------------------------------------------------
--  DDL for Function GET_EMPNO_FROM_META_ID
--------------------------------------------------------

 create or replace Function get_empno_from_meta_id(
    p_meta_id In Varchar2
) Return Varchar2 As
    v_empno ss_emplmast.empno%Type;
Begin
    Select
        tcmpl_app_config.app_users.get_empno_from_meta_id(p_meta_id)
    Into
        v_empno
    From
        dual;

    Return v_empno;

End get_empno_from_meta_id;
/