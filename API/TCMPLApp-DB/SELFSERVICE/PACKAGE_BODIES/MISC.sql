--------------------------------------------------------
--  DDL for Package Body MISC
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."MISC" As

    Function is_emp_present (
        p_empno Varchar2,
        p_date Date
    ) Return Number As
        v_count Number;
    Begin
        If p_date = To_Date('12-Jun-2021', 'dd-Mon-yyyy') Then
            Return 0;
        End If;
        Select
            Count(*)
        Into v_count
        From
            ss_punch
        Where
            empno = p_empno
            And pdate = Trunc(p_date);

        If v_count > 0 Then
            Return 1;
        End If;

        Select
            Count(*)
        Into v_count
        From
            ss_punch_manual
        Where
            empno = p_empno
            And pdate = Trunc(p_date);
        If v_count > 0 Then
            Return 1;
        End If;

        Select
            Count(*)
        Into v_count
        From
            ss_onduty
        Where
            empno = p_empno
            And pdate  = p_date
            And type   = 'IO';

        If v_count > 0 Then
            Return 1;
        Else
            Return 0;
        End If;
    Exception
        When Others Then
            Return 0;
    End is_emp_present;

    Function is_present_for_8days (
        p_empno   Varchar2,
        p_date1   Date,
        p_date2   Date
    ) Return Number As
        v_count Number;
    Begin
        Select
            Sum(present_days)
        Into v_count
        From
            (
                Select
                    is_emp_present(
                        p_empno,
                        d_date
                    ) present_days
                From
                    ss_days_details
                Where
                    d_date >= p_date1
                    And d_date <= p_date2
            );
        Return v_count;

        If v_count < 9 Then
            Return 0;
        Else
            Return v_count;
        End If;
    Exception
        When Others Then
            Return -1;
    End is_present_for_8days;

End misc;


/
