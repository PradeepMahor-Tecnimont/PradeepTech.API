--------------------------------------------------------
--  DDL for Function GET_EMP_NAME_FROM_PERSON_ID
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GET_EMP_NAME_FROM_PERSON_ID" (
    p_person_id In Varchar2
) Return Varchar2 As
    v_emp_name     Varchar2(60);
    v_person_id Varchar2(10);
Begin
    v_person_id := trim(substr(p_person_id, 2));

    Select
        name
    Into
        v_emp_name
    From
        ss_emplmast
    Where
        Trim(personid) In (Trim(p_person_id), v_person_id)
        And status = 1;
    Return v_emp_name;
Exception
    When Others Then
        Return 'ERRRR';
End get_emp_name_from_person_id;

/
