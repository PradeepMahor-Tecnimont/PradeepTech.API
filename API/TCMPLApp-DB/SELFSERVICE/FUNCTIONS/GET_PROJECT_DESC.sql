--------------------------------------------------------
--  DDL for Function GET_PROJECT_DESC
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GET_PROJECT_DESC" 
(
  param_projno IN VARCHAR2  
) RETURN VARCHAR2 AS 
lcl_desc varchar2(100);
BEGIN
  if trim(param_projno) is null then 
    return '';
  End If;
  select name into lcl_desc from ss_projmast where projno = param_projno;
  return lcl_desc;
Exception
  when others then 
    return '';
END GET_PROJECT_DESC;


/
