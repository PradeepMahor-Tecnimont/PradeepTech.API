--------------------------------------------------------
--  DDL for Function GET_PUNCH_SEC
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GET_PUNCH_SEC" (
        param_empno         Varchar2,
        param_date          Date,
        param_first_punch   Varchar2
    ) Return number As
        rec_punch_data   selfservice.ss_integratedpunch%rowtype;
        v_ret_val        number;
    Begin
        If param_first_punch = 'OK' Then
            Select *
            Into
                rec_punch_data
            From (
                    Select *
                    From selfservice.ss_integratedpunch
                    Where empno   = param_empno
                        And pdate   = param_date
                    Order By hh, mm, ss
                )
            Where Rownum = 1;


        Elsif param_first_punch = 'KO' Then
            Select *
            Into
                rec_punch_data
            From (
                    Select *
                    From selfservice.ss_integratedpunch
                    Where empno   = param_empno
                        And pdate   = param_date
                    Order By
                        hh Desc,
                        mm Desc,
                        ss Desc
                )
            Where Rownum = 1;

        Else
            Return '';
        End If;
        v_ret_val := (rec_punch_data.hh * 60 * 60 ) + (rec_punch_data.mm * 60) + rec_punch_data.ss;
        --v_ret_val   := To_Char(rec_punch_data.hh, 'FM00') ||':' ||To_Char(rec_punch_data.mm, 'FM00') ||':' ||To_Char(rec_punch_data.ss, 'FM00') ||'.000';

        Return v_ret_val;
    Exception
        When Others Then
            Return 0;
    End;


/
