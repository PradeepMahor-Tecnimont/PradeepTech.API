--------------------------------------------------------
--  DDL for Package Body PKG_LEAVE_REP
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."PKG_LEAVE_REP" As

    Function leave_credits_4_yyyy (
        param_empno       Varchar2,
        param_yyyy        Varchar2,
        param_leave_type  Varchar2
    ) Return Number As
        v_ret_val Number;
    Begin
        Select
            Sum(leaveperiod)
          Into v_ret_val
          From
            ss_leaveledg
         Where
                to_char(bdate, 'yyyy') = param_yyyy
               And db_cr      = 'C'
               and adj_type <> 'LP' --Loss Of Pay
               And empno      = param_empno
               And leavetype  = param_leave_type;

        Return v_ret_val / 8;
    Exception
        When Others Then
            Return 0;
    End leave_credits_4_yyyy;

    Function leave_dr_during_yyyy (
        param_empno       Varchar2,
        param_yyyy        Varchar2,
        param_leave_type  Varchar2
    ) Return Number As
        v_ret_val Number;
    Begin
        Select
            Sum(leaveperiod)
          Into v_ret_val
          From
            ss_leaveledg
         Where
                to_char(bdate, 'yyyy') = param_yyyy
               And db_cr      = 'D'
               And empno      = param_empno
               And leavetype  = param_leave_type
               And adj_type <> 'YA';

        Return ( v_ret_val * -1 ) / 8;
    Exception
        When Others Then
            Return 0;
    End leave_dr_during_yyyy;

    Function lapse_year_end_adjust (
        param_empno       Varchar2,
        param_yyyy        Varchar2,
        param_leave_type  Varchar2
    ) Return Number As
        v_ret_val Number;
    Begin
        Select
            Sum(leaveperiod)
          Into v_ret_val
          From
            ss_leaveledg
         Where
                to_char(bdate, 'yyyy') = param_yyyy
               And db_cr      = 'D'
               And empno      = param_empno
               And leavetype  = param_leave_type
               And adj_type   = 'YA';

        Return ( v_ret_val * -1 ) / 8;
    Exception
        When Others Then
            Return 0;
    End lapse_year_end_adjust;

End pkg_leave_rep;


/
