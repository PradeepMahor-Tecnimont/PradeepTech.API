--------------------------------------------------------
--  DDL for Function TO_HRS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."TO_HRS" (v_min In Number) Return Varchar2 Is
    v_retval  Varchar2(10);
    v_minutes Number;
Begin
    If nvl(v_min, 0) = 0 Then
        Return '';
    End If;

    If v_min < 0 Then
        v_minutes := v_min * -1;
    Else
        v_minutes := v_min;
    End If;
    v_retval := to_char(floor(nvl(v_minutes, 0) / 60));
    If length(v_retval) < 2 Then
        v_retval := lpad(v_retval, 2, '0');
    End If;
    v_retval := v_retval || ':' || lpad(to_char(Mod(nvl(v_minutes, 0), 60)), 2, '0');
    if v_min < 0 then
        v_retval := '-' || v_retval;
    end if;
    Return v_retval;
End;

/
