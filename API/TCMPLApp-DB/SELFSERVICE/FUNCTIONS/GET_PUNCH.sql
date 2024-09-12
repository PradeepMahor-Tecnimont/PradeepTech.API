--------------------------------------------------------
--  DDL for Function GET_PUNCH
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GET_PUNCH" (
        param_empno         Varchar2,
        param_date          Date,
        param_first_punch   Varchar2,
        param_purpose varchar2 default ''
    ) Return Varchar2 As
        rec_punch_data   selfservice.ss_integratedpunch%rowtype;
        v_ret_val        Varchar2(13);
        v_option_0 number;
        v_option_1 number;
        --param_purpose varchar2(5);
    Begin
    v_option_0 := 0;
    v_option_1 := 1;
        if param_purpose in ( 'LC', 'EGO') then
            v_option_0 := 1;
        end if;

        If param_first_punch = 'OK' Then
            Select *
            Into
                rec_punch_data
            From (
                    Select *
                    From selfservice.ss_integratedpunch
                    Where empno   = param_empno
                        And pdate   = trunc(param_date)
                        and falseflag in (v_option_0,v_option_1)
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
                        And pdate   = trunc(param_date)
                        and falseflag in (v_option_0,v_option_1)
                    Order By
                        hh Desc,
                        mm Desc,
                        ss Desc
                )
            Where Rownum = 1;

        Else
            Return '';
        End If;

        v_ret_val   := To_Char(rec_punch_data.hh, 'FM00') ||':' ||To_Char(rec_punch_data.mm, 'FM00') ||':' ||To_Char(rec_punch_data.ss, 'FM00') ||'.000';

        Return v_ret_val;
    Exception
        When Others Then
            Return '0';
    End;


/
