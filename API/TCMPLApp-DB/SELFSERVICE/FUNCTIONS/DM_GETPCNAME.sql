--------------------------------------------------------
--  DDL for Function DM_GETPCNAME
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."DM_GETPCNAME" (p_Assetid in varchar2) return varchar2 as
  vCompname varchar2(20);
begin
  select trim(compname) INTO vCompname 
  from dm_assetcode
  where upper(trim(barcode)) = upper(trim(p_Assetid));

  return vCompname;

exception
  when others then
    return null;

end dm_getpcname;


/
