Create Or Replace Function commonmasters.fn_global_not_ok Return Varchar2
    Deterministic
As
Begin
    Return 'KO';
End;