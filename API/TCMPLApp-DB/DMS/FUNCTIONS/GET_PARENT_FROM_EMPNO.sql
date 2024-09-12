Create Or Replace Function "DMS"."GET_PARENT_FROM_EMPNO"(
    p_empno In Varchar2
) Return Varchar2 As
    v_parent ss_emplmast.parent%Type;
Begin
    Select
        parent
    Into
        v_parent
    From
        ss_emplmast
    Where
        empno = p_empno;
    Return v_parent;

End get_parent_from_empno;