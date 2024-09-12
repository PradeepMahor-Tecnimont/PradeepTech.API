--------------------------------------------------------
--  DDL for Function DM_GET_EMP_OFFICE
--------------------------------------------------------

Create Or Replace Function "SELFSERVICE"."DM_GET_EMP_OFFICE"(
    param_empno In Varchar2
) Return Varchar2 As
    v_office Varchar2(10) := '';
Begin

    Select
        office
    Into
        v_office
    From
        (
            Select
                office
            From
                dms.dm_usermaster um,
                dms.dm_deskmaster dm
            Where
                empno         = param_empno
                And um.deskid = dm.deskid
        )
    Where
        Rownum = 1;

    Return v_office;
Exception
    When Others Then
        Return '-';
End dm_get_emp_office;
/