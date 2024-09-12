--------------------------------------------------------
--  DDL for Function TO_DAYS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."TO_DAYS" (
    p_hrs In Varchar2
) Return Varchar2 As
    v_days         Varchar2(10);
    v_positive_hrs Number;
Begin
    If nvl(p_hrs, 0) = 0 Then
        Return '';
    End If;
    If p_hrs < 0 Then
        v_positive_hrs := p_hrs * -1;
    Else
        v_positive_hrs := p_hrs;
    End If;
    v_days := trunc(v_positive_hrs / 8);

    v_days := v_days || '.' || Mod(v_positive_hrs, 8);

    If p_hrs < 0 Then
        v_days := '-' || v_days;
    End If;
    Return v_days;
End to_days;

/
