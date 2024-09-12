--------------------------------------------------------
--  DDL for Function ISLEAVEDEPUTOUR
--------------------------------------------------------

Create Or Replace Function selfservice.isleavedeputour(
    v_date  In Date,
    v_empno In Varchar2
) Return Number Is
    v_cntr   Number;
    v_retval Number := 0;
Begin
    --Check Leave
    Select
        Count(*)
    Into
        v_cntr
    From
        ss_leaveledg
    Where
        empno = Trim(v_empno)
        And bdate <= v_date
        And nvl(edate, bdate) >= v_date
        And adj_type In ('LA', 'LC', 'SW');

    If v_cntr > 0 Then
        --v_retval := 1;
        Return 1;
    End If;

    --Check On Tour / On Deputation 
    Select
        Count(*)
    Into
        v_cntr
    From
        ss_depu
    Where
        empno             = Trim(v_empno)
        And bdate <= v_date
        And nvl(edate, bdate) >= v_date
        And (hod_apprl    = 1
            And hrd_apprl = 1)
        And type Not In ('RW', 'MC');

    If v_cntr > 0 Then
        --v_retval := v_retval + 2;
        Return 2;
    End If;

    --Remote Work (Work From Home)
    Select
        Count(*)
    Into
        v_cntr
    From
        ss_depu
    Where
        empno             = Trim(v_empno)
        And bdate <= v_date
        And nvl(edate, bdate) >= v_date
        And (hod_apprl    = 1
            And hrd_apprl = 1)
        And type          = 'RW';

    If v_cntr > 0 Then
        Return 3;
    End If;

    --Leave adjustment SW
    Select
        Count(*)
    Into
        v_cntr
    From
        ss_leave_adj
    Where
        empno        = v_empno
        And v_date Between bdate And nvl(edate, bdate)
        And adj_type = 'SW'
        And db_cr    = 'D';
    If v_cntr > 0 Then
        Return 4;
    End If;

    Return 0;
Exception
    When Others Then
        Return v_retval;
End;
/