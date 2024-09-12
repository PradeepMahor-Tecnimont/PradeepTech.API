--------------------------------------------------------
--  DDL for Function GET_AD_EMAIL
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "COMMONMASTERS"."GET_AD_EMAIL" (
    p_empno In Varchar2
) Return Varchar2 As
    v_ad_email_id Varchar2(200);
Begin
    Select
        email_id
    Into
        v_ad_email_id
    From
        emp_ad_details
    Where
        empno = p_empno;
    Return v_ad_email_id;
Exception
    When Others Then
        Return Null;
End get_ad_email;


/
