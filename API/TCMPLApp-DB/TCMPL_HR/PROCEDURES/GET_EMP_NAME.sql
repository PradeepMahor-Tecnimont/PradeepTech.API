Create Or Replace Function "TCMPL_HR"."GET_EMP_NAME"(
    paramempno In Varchar2
) Return Varchar2 As
    vretval Varchar2(60);
Begin
    If paramempno = 'ALLSS' Then
        Return 'All Services';
    End If;
    Select
        name
    Into
        vretval
    From
        vu_emplmast
    Where
        empno = Trim(paramempno);

    Return vretval;
Exception
    When Others Then
        Return '';
End get_emp_name;