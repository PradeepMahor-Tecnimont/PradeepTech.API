--------------------------------------------------------
--  DDL for Function DM_GETUSER
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."DM_GETUSER" (p_empno in varchar2) return varchar2 as 
  vUserid varchar2(5);
begin
  select trim(userid) INTO vUserid
  from userids
  where upper(trim(empno)) = upper(trim(p_empno));

  return vUserid;

exception
  when others then  
  return null;

end dm_getuser;


/
