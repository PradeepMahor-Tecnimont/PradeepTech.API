Create Or Replace Function "DMS"."GET_COSTCODE_NAME" (
    p_costcode In Varchar2
) Return Varchar2 As
    v_retval Varchar2(1000);
Begin
    Select
        name
      Into v_retval
      From
        ss_costmast
     Where
        costcode = Trim(p_costcode);
    Return v_retval;
    
Exception
    When Others Then
        Return '';
End get_costcode_name;